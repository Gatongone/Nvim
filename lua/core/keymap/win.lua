local win = nvim.keymap.win

nmap(win.resize_vwin_bigger,  ":vertical resize +1<CR>")
nmap(win.resize_vwin_smaller, ":vertical resize -1<CR>")
nmap(win.resize_hwin_bigger,  ":horizontal resize +1<CR>")
nmap(win.resize_hwin_smaller, ":horizontal resize -1<CR>")
nmap(win.focus_left_win,      ":wincmd h<CR>")
nmap(win.focus_right_win,     ":wincmd l<CR>")
nmap(win.focus_up_win,        ":wincmd k<CR>")
nmap(win.focus_down_win,      ":wincmd j<CR>")
nmap(win.split_vwin,          ":vsp")
nmap(win.split_hwin,          ":sp")
