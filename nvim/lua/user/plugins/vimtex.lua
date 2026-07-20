local M = {}

M.opts = {
  build_dir = "build",
  viewer = "zathura",
  latexmk_args = { "-pdf", "-interaction=nonstopmode", "-file-line-error", "-synctex=1" },
}

local continuous_job = nil

local function paths()
  local file = vim.fn.expand("%:t")
  local name = vim.fn.expand("%:t:r")
  local dir = vim.fn.expand("%:p:h")
  return file, name, dir
end

local function pdf_path()
  local _, name, dir = paths()
  return dir .. "/" .. M.opts.build_dir .. "/" .. name .. ".pdf"
end

local function log_path()
  local _, name, dir = paths()
  return dir .. "/" .. M.opts.build_dir .. "/" .. name .. ".log"
end

local function file_mtime(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.mtime.sec or 0
end

-- Find a running zathura process for this exact PDF, regardless of how it
-- was spawned (forking wrappers, flatpak, etc make jobstart's own pid
-- unreliable to track long-term).
local function find_zathura_pid(pdf)
  local out = vim.fn.systemlist({ "pgrep", "-f", "zathura.*" .. vim.fn.fnameescape(pdf) })
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  return tonumber(out[1])
end

-- Parse latexmk's log for "file:line: message" entries (from -file-line-error)
-- and populate the quickfix list. Anything without that exact shape (e.g.
-- Underfull/Overfull warnings) is silently skipped -- no extra filtering needed.
local function parse_log(dir, logfile)
  if vim.fn.filereadable(logfile) == 0 then
    return
  end
  local lines = vim.fn.readfile(logfile)

  local prev_dir = vim.fn.chdir(dir)
  vim.fn.setqflist({}, " ", { title = "LaTeX", lines = lines, efm = "%f:%l: %m" })
  if prev_dir ~= "" then
    vim.fn.chdir(prev_dir)
  end

  local has_errors = false
  for _, item in ipairs(vim.fn.getqflist()) do
    if item.valid == 1 then
      has_errors = true
      break
    end
  end

  if has_errors then
    vim.cmd("copen")
  else
    vim.notify("LaTeX: no errors", vim.log.levels.INFO)
  end
end

local function spawn_viewer(pdf)
  vim.fn.jobstart({
    M.opts.viewer,
    "--synctex-editor-command=nvim --headless -c \"e +%{line} %{input}\" -c 'qa'",
    pdf,
  }, { detach = true })
end

local function do_synctex_forward(pid, line, tex_file, pdf)
  vim.fn.jobstart({
    M.opts.viewer,
    string.format("--synctex-forward=%d:1:%s", line, tex_file),
    string.format("--synctex-pid=%d", pid),
    pdf,
  }, { detach = true })
  -- Focus (not urgent) so jumping never turns the window red.
  vim.fn.jobstart({ "swaymsg", string.format("[pid=%d] focus", pid) })
end

-- Jump the PDF viewer to `line`, opening it first if needed. Used by lf,
-- and by both compile paths after a successful build.
local function jump_to_line(line)
  local pdf = pdf_path()
  local tex_file = vim.fn.expand("%:p")

  local pid = find_zathura_pid(pdf)
  if pid then
    do_synctex_forward(pid, line, tex_file, pdf)
    return
  end

  spawn_viewer(pdf)
  local attempts = 0
  local function retry()
    attempts = attempts + 1
    local retry_pid = find_zathura_pid(pdf)
    if retry_pid then
      do_synctex_forward(retry_pid, line, tex_file, pdf)
      return
    end
    if attempts < 10 then
      vim.defer_fn(retry, 300)
    end
  end
  vim.defer_fn(retry, 300)
end

-- on_success is called only when the build exits 0.
function M.compile(on_success)
  local file, name, dir = paths()
  local build_dir = dir .. "/" .. M.opts.build_dir
  vim.fn.mkdir(build_dir, "p")

  local cmd = { "latexmk" }
  vim.list_extend(cmd, M.opts.latexmk_args)
  vim.list_extend(cmd, { "-outdir=" .. M.opts.build_dir, file })

  vim.notify("LaTeX: compiling " .. file .. " ...", vim.log.levels.INFO)

  vim.fn.jobstart(cmd, {
    cwd = dir,
    on_exit = function(_, code)
      vim.schedule(function()
        parse_log(dir, build_dir .. "/" .. name .. ".log")
        if code == 0 then
          vim.notify("LaTeX: build OK", vim.log.levels.INFO)
          if on_success then
            on_success()
          end
        else
          vim.notify("LaTeX: build failed (exit " .. code .. ")", vim.log.levels.WARN)
        end
      end)
    end,
  })
end

-- Manual compile (<leader>ll): compile, then jump to the line the cursor
-- was on when compilation was triggered.
function M.compile_and_jump()
  local line = vim.fn.line(".")
  M.compile(function()
    jump_to_line(line)
  end)
end

function M.compile_toggle()
  if continuous_job then
    vim.fn.jobstop(continuous_job)
    continuous_job = nil
    vim.notify("LaTeX: continuous compilation stopped", vim.log.levels.INFO)
    return
  end

  local file, _, dir = paths()
  vim.fn.mkdir(dir .. "/" .. M.opts.build_dir, "p")

  local cmd = { "latexmk", "-pvc" }
  vim.list_extend(cmd, M.opts.latexmk_args)
  vim.list_extend(cmd, { "-outdir=" .. M.opts.build_dir, file })

  continuous_job = vim.fn.jobstart(cmd, {
    cwd = dir,
    on_exit = function()
      continuous_job = nil
    end,
  })
  vim.notify("LaTeX: continuous compilation started", vim.log.levels.INFO)
end

-- Called on every save while watch mode is active. Polls the log file's
-- mtime until latexmk's background rebuild finishes, then jumps.
local function on_save_while_watching()
  if not continuous_job then
    return
  end
  local line = vim.fn.line(".")
  local logfile = log_path()
  local before = file_mtime(logfile)

  local attempts = 0
  local function poll()
    attempts = attempts + 1
    local now = file_mtime(logfile)
    if now > before then
      jump_to_line(line)
      return
    end
    if attempts < 20 then
      vim.defer_fn(poll, 300)
    end
  end
  vim.defer_fn(poll, 300)
end

-- lv: open the viewer. If it's already open, flash it red via Sway's
-- urgency hint instead of opening a duplicate window. If not built yet,
-- compile first, then open -- silently, no warning.
function M.view()
  local pdf = pdf_path()

  if vim.fn.filereadable(pdf) == 0 then
    M.compile(function()
      spawn_viewer(pdf)
    end)
    return
  end

  local pid = find_zathura_pid(pdf)
  if pid then
    vim.fn.jobstart({ "swaymsg", string.format("[pid=%d] urgent enable", pid) })
    return
  end

  spawn_viewer(pdf)
end

-- lf: jump to the current line in the PDF. Never warns, never flashes red,
-- meant to be pressed freely and repeatedly. Works on the very first press.
function M.forward_search()
  local line = vim.fn.line(".")
  local pdf = pdf_path()

  if vim.fn.filereadable(pdf) == 0 then
    M.compile(function()
      jump_to_line(line)
    end)
  else
    jump_to_line(line)
  end
end

-- === Omni-completion: \cite{}, \ref{}/\eqref{}, \begin{} ===

local ENVIRONMENTS = {
  "itemize", "enumerate", "description", "equation", "equation*",
  "align", "align*", "figure", "table", "tabular", "minipage",
  "verbatim", "center", "quote", "abstract",
}

local function find_bib_files(dir)
  local out = vim.fn.systemlist({ "rg", "-o", "--no-filename", [[\\(bibliography|addbibresource)\{([^}]+)\}]], "-r", "$2", dir })
  local files = {}
  for _, entry in ipairs(out) do
    for part in entry:gmatch("[^,]+") do
      part = part:gsub("%.bib$", "") .. ".bib"
      if part:sub(1, 1) ~= "/" then
        part = dir .. "/" .. part
      end
      table.insert(files, part)
    end
  end
  return files
end

local function cite_candidates(dir)
  local bibs = find_bib_files(dir)
  if #bibs == 0 then
    return {}
  end
  local cmd = { "rg", "-o", "--no-filename", [[^@\w+\{([^,]+),]], "-r", "$1" }
  vim.list_extend(cmd, bibs)
  return vim.fn.systemlist(cmd)
end

local function label_candidates(dir)
  return vim.fn.systemlist({ "rg", "-o", "--no-filename", "--type", "tex", [[\\label\{([^}]+)\}]], "-r", "$1", dir })
end

function M.omnifunc(findstart, base)
  if findstart == 1 then
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before = line:sub(1, col)

    if before:match("\\cite%{[^}]*$") or before:match("\\ref%{[^}]*$")
      or before:match("\\eqref%{[^}]*$") or before:match("\\begin%{[^}]*$") then
      local start = before:find("[^{,]*$")
      return start - 1
    end
    return -3 -- no completion here
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  local dir = vim.fn.expand("%:p:h")

  local pool = {}
  if before:match("\\cite%{[^}]*$") then
    pool = cite_candidates(dir)
  elseif before:match("\\ref%{[^}]*$") or before:match("\\eqref%{[^}]*$") then
    pool = label_candidates(dir)
  elseif before:match("\\begin%{[^}]*$") then
    pool = ENVIRONMENTS
  end

  local matches = {}
  for _, cand in ipairs(pool) do
    if base == "" or cand:sub(1, #base) == base then
      table.insert(matches, cand)
    end
  end
  return matches
end

-- === Setup ===

vim.api.nvim_create_user_command("TexCompile", M.compile_and_jump, {})
vim.api.nvim_create_user_command("TexWatch", M.compile_toggle, {})
vim.api.nvim_create_user_command("TexView", M.view, {})
vim.api.nvim_create_user_command("TexForward", M.forward_search, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(ev)
    vim.g.tex_flavor = "latex"
    vim.bo[ev.buf].omnifunc = "v:lua.require'user.tex'.omnifunc"

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("<leader>ll", M.compile_and_jump, "LaTeX compile + jump")
    map("<leader>lw", M.compile_toggle, "LaTeX toggle watch")
    map("<leader>lv", M.view, "LaTeX view PDF")
    map("<leader>lf", M.forward_search, "LaTeX forward search")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.tex",
  callback = on_save_while_watching,
})

return M
