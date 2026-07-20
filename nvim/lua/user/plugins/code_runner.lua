local M = {}
-- filetype -> command. Use $file $fileName $fileNameWithoutExt $dir
local commands = {
  -- python = "python3 -u $file",
  sh = "bash $file",
  -- lua = "lua $file",
  c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
  cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
  -- rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
  -- javascript = "node $file",
}
local compiled = { c = true, cpp = true, rust = true } 
local bufname_prefix = "runner://"
local term_position = "vertical botright"
local term_size = 40
local function expand_vars(cmd, path)
  local info = {
    file = vim.fn.shellescape(path),
    fileName = vim.fn.shellescape(vim.fn.fnamemodify(path, ":t")),
    fileNameWithoutExt = vim.fn.shellescape(vim.fn.fnamemodify(path, ":t:r")),
    dir = vim.fn.shellescape(vim.fn.fnamemodify(path, ":p:h")),
  }
  return (cmd:gsub("%$(%w+)", function(v) return info[v] or ("$" .. v) end))
end
local function close_runner(bufname)
  local id = vim.fn.bufnr(bufname)
  if id ~= -1 then
    vim.cmd("bwipeout! " .. id)
  end
end
function M.run()
  local ft = vim.bo.filetype
  local cmd = commands[ft]
  if not cmd then
    vim.notify("No command for filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  local path = vim.fn.expand("%:p")
  local bin_path = compiled[ft]
      and (vim.fn.fnamemodify(path, ":p:h") .. "/" .. vim.fn.fnamemodify(path, ":t:r"))
      or nil
  cmd = expand_vars(cmd, path)
  local bufname = bufname_prefix .. vim.fn.fnamemodify(path, ":t:r")
  close_runner(bufname)
  vim.cmd(string.format("%s %d new", term_position, term_size))
  local job_id
  job_id = vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      if bin_path then vim.fn.delete(bin_path) end
    end,
  })
  local buf, win = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.bo[buf].filetype = "runner"
  vim.cmd("file " .. bufname)
  vim.bo[buf].buflisted = false
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, nowait = true, desc = "Runner: normal mode" })
  vim.keymap.set("n", "<Esc>", function()
    if job_id and job_id > 0 then
      vim.fn.jobstop(job_id)
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, nowait = true, desc = "Close runner window" })
end
vim.api.nvim_create_user_command("RunCode", M.run, {})
vim.keymap.set("n", "<leader>rr", M.run, { desc = "Run current file" })
return M
