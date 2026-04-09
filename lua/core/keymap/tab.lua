local map = require("core.keymap.map")
local tab = nvim.keymap.tab

map.nmap(tab.prev_tab,      ':-tabnext<CR>')
map.nmap(tab.next_tab,      ':+tabnext<CR>')
map.vmap(tab.prev_tab,      ':-tabnext<CR>')
map.vmap(tab.next_tab,      ':+tabnext<CR>')
