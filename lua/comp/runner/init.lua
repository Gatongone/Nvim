local cmds    = require("comp.runner.cmds")
local win     = nvim.ext.win

vim.t.f_runid = -1
vim.t.h_runid = -1
vim.t.v_runid = -1

--- Get terminal command
--- @return string|nil cmd
local function get_command()
    local filetype = vim.bo.filetype
    local lang = cmds[filetype]
    if not lang then
        vim.notify("Unknown runner for '" .. filetype .. "'.", vim.log.levels.ERROR)
        return nil
    end
    local result = ""
    for i = 1, #lang.cmd do
        local cmd = string.replace(lang.cmd[i],
        {
            file    = vim.fn.expand('%'),
            exename = vim.fn.fnamemodify(vim.fn.expand('%'), ":t:r"),
            delete  = nvim.env.cli_rmf,
        }):gsub("/", nvim.env.dir_sp):gsub(";", nvim.env.cli_sp)
        if i < #lang.cmd then
            cmd = nvim.env.cli_try(cmd).." || "
        end
        result = result..cmd
    end
    vim.notify(result)
    return result
end

--- Run file in a float window
local function run_code()
    if vim.t.f_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.f_termid)
    end
    local cmd = get_command()
    if not cmd then return end
    print(cmd)

    vim.t.f_runid = win.create_win(true, { title = "Runner" }).winnr
    vim.fn.termopen(cmd, { on_exit = function() vim.t.f_runid = -1 end })
    bnmap("<C-q>", ":q!<CR>")
end

--- Run file in a split horizontally window
local function run_code_horizontally()
    if vim.t.h_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.h_termid)
    end

    local cmd = get_command()
    if not cmd then return end

    vim.cmd("new")
    vim.fn.termopen(cmd, { on_exit = function() vim.t.h_runid = -1 end })
    vim.cmd("resize " .. nvim.ext.ui.get_screen_row(0.3))
    bnmap("<C-q>", ":q!<CR>")
    vim.t.h_runid = vim.api.nvim_get_current_win()
end

--- Run file in a split vertically window
local function run_code_vertically()
    if vim.t.v_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.v_termid)
    end

    local cmd = get_command()
    if not cmd then return end

    vim.cmd("vertical new")
    vim.fn.jobstart(cmd, { term = true, on_exit = function() vim.t.v_runid = -1 end })
    vim.cmd("vertical resize " .. nvim.ext.ui.get_screen_col(0.35))
    bnmap("<C-q>", ":q!<CR>")
    vim.t.v_runid = vim.api.nvim_get_current_win()
end

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_user_command("Run",  run_code,              { desc = "Run file in a float window." })
vim.api.nvim_create_user_command("Runh", run_code_horizontally, { desc = "Run file in a split horizontally window." })
vim.api.nvim_create_user_command("Runv", run_code_vertically,   { desc = "Run file in a split vertically window." })
