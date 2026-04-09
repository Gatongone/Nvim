local map = require("core.keymap.map")
local config = require("config")
local terminal = config.keymap.terminal
map.nmap(terminal.open_terminal,            ":OpenTerminal<CR>")
map.nmap(terminal.open_terminal_horizontal, ":OpenTerminalHorizontally<CR>")
map.nmap(terminal.open_terminal_vertical,   ":OpenTerminalVertically<CR>")
map.tmap(config.keymap.editor.normal_mode,  [[<C-\><C-n>]])
