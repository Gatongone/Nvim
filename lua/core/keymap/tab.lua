local map = require("core.keymap.map")
local config = require("config")
local tab = config.keymap.tab

map.nmap(tab.prev_tab,      ':-tabnext<CR>')
map.nmap(tab.next_tab,      ':+tabnext<CR>')
map.vmap(tab.prev_tab,      ':-tabnext<CR>')
map.vmap(tab.next_tab,      ':+tabnext<CR>')
