# habamax qutebrowser theme

bg0_hard = "#1c1c1c"
bg0_soft  = '#262626'
bg0_normal = '#1c1c1c'

bg0 = bg0_hard
bg1 = "#2a2a2a"
bg2 = "#3a3a3a"
bg3 = "#444444"
bg4 = "#585858"

fg0 = "#dadada"
fg1 = "#c7c7c7"
fg2 = "#adadad"
fg3 = "#9e9e9e"
fg4 = "#767676"

bright_red    = "#af5f5f"
bright_green  = "#5faf5f"
bright_yellow = "#d7af87"
bright_blue   = "#5f87af"
bright_purple = "#af87af"
bright_aqua   = "#5f8787"
bright_gray   = "#767676"
bright_orange = "#ffaf5f"

dark_red    = "#875f5f"
dark_green  = "#5f875f"
dark_yellow = "#af875f"
dark_blue   = "#5f7f9f"
dark_purple = "#875f87"
dark_aqua   = "#5f7f7f"
dark_gray   = "#626262"
dark_orange = "#d7875f"

### Completion
c.colors.completion.fg = [fg1, bright_aqua, bright_yellow]
c.colors.completion.odd.bg = bg0
c.colors.completion.even.bg = c.colors.completion.odd.bg
c.colors.completion.category.fg = bright_blue
c.colors.completion.category.bg = bg1
c.colors.completion.category.border.top = c.colors.completion.category.bg
c.colors.completion.category.border.bottom = c.colors.completion.category.bg
c.colors.completion.item.selected.fg = fg0
c.colors.completion.item.selected.bg = bg4
c.colors.completion.item.selected.border.top = bg2
c.colors.completion.item.selected.border.bottom = c.colors.completion.item.selected.border.top
c.colors.completion.item.selected.match.fg = bright_orange
c.colors.completion.match.fg = c.colors.completion.item.selected.match.fg
c.colors.completion.scrollbar.fg = c.colors.completion.item.selected.fg
c.colors.completion.scrollbar.bg = c.colors.completion.category.bg

### Context menu
c.colors.contextmenu.disabled.bg = bg3
c.colors.contextmenu.disabled.fg = fg3
c.colors.contextmenu.menu.bg = bg0
c.colors.contextmenu.menu.fg = fg2
c.colors.contextmenu.selected.bg = bg2
c.colors.contextmenu.selected.fg = c.colors.contextmenu.menu.fg

### Downloads
c.colors.downloads.bar.bg = bg0
c.colors.downloads.start.fg = bg0
c.colors.downloads.start.bg = bright_blue
c.colors.downloads.stop.fg = c.colors.downloads.start.fg
c.colors.downloads.stop.bg = bright_aqua
c.colors.downloads.error.fg = bright_red

### Hints
c.colors.hints.fg = bg0
c.colors.hints.bg = 'rgba(215, 175, 135, 200)'
c.colors.hints.match.fg = bg4

### Keyhint widget
c.colors.keyhint.fg = fg4
c.colors.keyhint.suffix.fg = fg0
c.colors.keyhint.bg = bg0

### Messages
c.colors.messages.error.fg = bg0
c.colors.messages.error.bg = bright_red
c.colors.messages.error.border = c.colors.messages.error.bg
c.colors.messages.warning.fg = bg0
c.colors.messages.warning.bg = bright_purple
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.info.fg = fg2
c.colors.messages.info.bg = bg0
c.colors.messages.info.border = c.colors.messages.info.bg

### Prompts
c.colors.prompts.fg = fg2
c.colors.prompts.border = f'1px solid {bg1}'
c.colors.prompts.bg = bg3
c.colors.prompts.selected.bg = bg2

### Statusbar
c.colors.statusbar.normal.fg = fg2
c.colors.statusbar.normal.bg = bg0
c.colors.statusbar.insert.fg = bg0
c.colors.statusbar.insert.bg = dark_aqua
c.colors.statusbar.passthrough.fg = bg0
c.colors.statusbar.passthrough.bg = dark_blue
c.colors.statusbar.private.fg = bright_purple
c.colors.statusbar.private.bg = bg0
c.colors.statusbar.command.fg = fg3
c.colors.statusbar.command.bg = bg1
c.colors.statusbar.command.private.fg = c.colors.statusbar.private.fg
c.colors.statusbar.command.private.bg = c.colors.statusbar.command.bg
c.colors.statusbar.caret.fg = bg0
c.colors.statusbar.caret.bg = dark_purple
c.colors.statusbar.caret.selection.fg = c.colors.statusbar.caret.fg
c.colors.statusbar.caret.selection.bg = bright_purple
c.colors.statusbar.progress.bg = bright_blue
c.colors.statusbar.url.fg = fg4
c.colors.statusbar.url.error.fg = dark_red
c.colors.statusbar.url.hover.fg = bright_orange
c.colors.statusbar.url.success.http.fg = bright_red
c.colors.statusbar.url.success.https.fg = fg0
c.colors.statusbar.url.warn.fg = bright_purple

### Tabs
c.colors.tabs.bar.bg = bg0
c.colors.tabs.indicator.start = bright_blue
c.colors.tabs.indicator.stop = bright_aqua
c.colors.tabs.indicator.error = bright_red
c.colors.tabs.odd.fg = fg2
c.colors.tabs.odd.bg = bg2
c.colors.tabs.even.fg = c.colors.tabs.odd.fg
c.colors.tabs.even.bg = bg3
c.colors.tabs.selected.odd.fg = fg2
c.colors.tabs.selected.odd.bg = bg0
c.colors.tabs.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.selected.even.bg = bg0
c.colors.tabs.pinned.even.bg = bright_green
c.colors.tabs.pinned.even.fg = bg2
c.colors.tabs.pinned.odd.bg = bright_green
c.colors.tabs.pinned.odd.fg = c.colors.tabs.pinned.even.fg
c.colors.tabs.pinned.selected.even.bg = bg0
c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.odd.fg
c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.pinned.selected.even.bg
c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg
