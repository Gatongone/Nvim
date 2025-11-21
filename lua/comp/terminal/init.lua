require("core.keymap.terminal")

local win = nvim.ext.win
local ignore_bufs =
{
    "noice",
    "notify",
    "smear-cursor",
    "netrw",
    "terminal"
}

vim.t.f_termid = -1
vim.t.v_termid = -1
vim.t.h_termid = -1

--- Open Terminal as float window
local function open_terminal()
    if vim.t.f_termid and vim.t.f_termid >= 0 and vim.api.nvim_win_is_valid(vim.t.f_termid) then
        vim.api.nvim_set_current_win(vim.t.f_termid)
        return
    end

    vim.t.f_termid = win.create_win(true, { title = "Terminal" }).winnr

    -- Open explore
    vim.cmd("terminal")
    vim.cmd("startinsert")
end

--- Open Ternimal as horizontally window
local function open_terminal_horizontally()
    if vim.t.h_termid and vim.t.h_termid >= 0 and vim.api.nvim_win_is_valid(vim.t.h_termid) then
        vim.api.nvim_set_current_win(vim.t.h_termid)
        return
    end

    -- Create window
    vim.cmd("split")
    vim.t.h_termid = vim.api.nvim_get_current_win()
    vim.cmd("resize "..nvim.ext.ui.get_screen_row(0.3))
    vim.cmd("terminal")
    vim.cmd("startinsert")
    vim.opt_local.number = false
end

--- Open Ternimal as vertically window
local function open_terminal_vertically()
    if vim.t.v_termid and vim.t.v_termid >= 0 and vim.api.nvim_win_is_valid(vim.t.v_termid) then
        vim.api.nvim_set_current_win(vim.t.v_termid)
        return
    end
    vim.cmd("vsplit")
    vim.t.v_termid = vim.api.nvim_get_current_win()
    vim.cmd("vertical resize "..nvim.ext.ui.get_screen_col(0.35))
    vim.cmd("terminal")
    vim.cmd("startinsert")
    vim.opt_local.number = false
end

--- Close terminal when it's last window
local function terminal_closed_on_last()
    if not vim.t.f_termid or vim.api.nvim_win_is_valid(vim.t.f_termid) and
       not vim.t.h_termid or vim.api.nvim_win_is_valid(vim.t.h_termid) and
       not vim.t.v_termid or vim.api.nvim_win_is_valid(vim.t.v_termid) then
        return
    end

    -- Close the terminal when it's the last window
    if nvim.ext.win.get_cur_wins_count() == 1 then
        if vim.bo.buftype == "terminal" then
            goto exit
        else
            return
        end
    end

    -- Ignore certain plugin windows
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local bufnr = vim.api.nvim_win_get_buf(winnr)
        local filetype = vim.fn.getbufvar(bufnr, '&filetype')
        if filetype == "" or filetype == nil then
            goto continue
        end
        if not vim.tbl_contains(ignore_bufs, filetype) then
            return
        end
        ::continue::
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
            goto exit
        end
    end

    ::exit::
    vim.cmd("q!")
end

--- Switch to insert mode after enter terminal
local function terminal_enter_with_insert()
    if vim.bo.buftype ~= "terminal" then
        return
    end
    local cur_win = vim.api.nvim_get_current_win()
    if cur_win == vim.t.f_termid or cur_win == vim.t.v_termid or cur_win == vim.t.h_termid then
        vim.cmd("startinsert")
    end
end

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_user_command("OpenTerminal",             open_terminal,              { })
vim.api.nvim_create_user_command("OpenTerminalHorizontally", open_terminal_horizontally, { })
vim.api.nvim_create_user_command("OpenTerminalVertically",   open_terminal_vertically,   { })
vim.api.nvim_create_autocmd("WinClosed",  { pattern = "*", callback = terminal_closed_on_last    })
vim.api.nvim_create_autocmd("WinEnter",   { pattern = "*", callback = terminal_enter_with_insert })
