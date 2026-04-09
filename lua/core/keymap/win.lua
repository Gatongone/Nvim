local map = require("core.keymap.map")
local win = nvim.keymap.win

map.nmap(win.resize_vwin_bigger,  ":vertical resize +1<CR>")
map.nmap(win.resize_vwin_smaller, ":vertical resize -1<CR>")
map.nmap(win.resize_hwin_bigger,  ":horizontal resize +1<CR>")
map.nmap(win.resize_hwin_smaller, ":horizontal resize -1<CR>")
map.nmap(win.focus_left_win,      ":wincmd h<CR>")
map.nmap(win.focus_right_win,     ":wincmd l<CR>")
map.nmap(win.focus_up_win,        ":wincmd k<CR>")
map.nmap(win.focus_down_win,      ":wincmd j<CR>")
map.nmap(win.split_vwin,          ":vsp")
map.nmap(win.split_hwin,          ":sp")
