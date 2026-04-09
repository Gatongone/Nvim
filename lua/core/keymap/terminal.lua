local map = require("core.keymap.map")
local terminal = nvim.keymap.terminal
map.nmap(terminal.open_terminal,            ":OpenTerminal<CR>")
map.nmap(terminal.open_terminal_horizontal, ":OpenTerminalHorizontally<CR>")
map.nmap(terminal.open_terminal_vertical,   ":OpenTerminalVertically<CR>")
map.tmap(nvim.keymap.editor.normal_mode,    [[<C-\><C-n>]])
