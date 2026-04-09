local ext = require("util.ext")
local env = require("util.env")
local map = require("core.keymap.map")
local win = ext.win

vim.t.f_runid = -1
vim.t.h_runid = -1
vim.t.v_runid = -1

--- Get commands for task
--- @param task_name string runner | builder
--- @return table commands
local function get_commands(task_name)
    local filetype = vim.bo.filetype
    local cmds     = {}
    local delete   = env.cli_rmf
    local filepath = vim.fn.expand('%')
    local filename = vim.fn.fnamemodify(filepath, ":t:r")
    local projpath = env.get_proj_root()
    local projname = vim.fn.fnamemodify(projpath, ":t")
    local tasks    = {}

    -- Load from .nvim
    local tasks_file = projpath:gsub(env.dir_sp..'$', '') .. env.dir_sp .. ".nvim" .. env.dir_sp .. "tasks.lua"
    if vim.fn.filereadable(tasks_file) == 1 then
        local config = dofile(tasks_file)
        if config["tasks"] and config["tasks"][task_name] then
            tasks = config["tasks"][task_name]
        end
        if config["root"] then
            projpath = config["root"]
        end
    end
    -- Load from template
    if ext.table.length(tasks) == 0 then
        local template = require("comp.task.template")
        local lang     = template[filetype]
        if not lang then
            return cmds
        end
        tasks = lang[task_name]
    end

    if not tasks then
        return {}
    end

    for name, task in pairs(tasks) do
        local cmd = task.cmd

        if type(cmd) == "function" then
            cmds[task.title] = cmd
            goto continue
        elseif type(cmd) ~= "string" then
            goto continue
        end

        -- If not the executable file, then skip
        if vim.fn.executable(string.match(cmd, "%w+")) == 0 then
            goto continue
        end


        if task_name == "build" then
            cmd = cmd .. [[cd "$projpath" ; ]]
        end

        cmd = ext.string.replace(cmd,
        {
            delete      = delete,
            filepath    = filepath,
            filename    = filename,
            projname    = projname,
            projpath    = projpath,
        }):gsub("/", env.dir_sp):gsub(";", env.cli_sp)

        cmds[task.title] = cmd
        ::continue::
    end
    return cmds
end

--- Append text to buffer end
--- @param buf number Buffer
--- @param col string|nil highlight group
--- @param msg string|table Messages
local function append_to_end(buf, col, msg)
    local lines = type(msg) == "string" and { msg } or msg
    local line_count = vim.api.nvim_buf_line_count(buf)
    local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    local start_line

    if line_count == 1 and first_line == "" then
        -- Empty buffer, just cover first_line
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        start_line = 0
    else
        -- Append to end
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, lines)
        start_line = line_count
    end

    -- Set highlight
    if not col then
        return
    end
    local ns = vim.api.nvim_create_namespace("TASK-" .. tostring(os.time()))
    for i = 1, #lines do
        local line = start_line + i - 1
        vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
            end_line = line,
            end_col = #vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1],
            hl_group = col,
            strict = false,
        })
    end
end

--- Execute function and set the print() result to the buffer
--- @param target_buf number BuferID
--- @param callback function The function that invoke in the buffer
local function run_with_redirect(target_buf, callback)
    -- Overwrite print
    local fenv = {}
    -- Redirect others to Global env
    setmetatable(fenv, {__index = _G})
    fenv["print"] = function(...)
        append_to_end(target_buf, nil, ...)
    end
    setfenv(callback, fenv)

    -- Try invoke
    local start = vim.uv.hrtime()
    local success, err = pcall(callback)
    local finish = vim.uv.hrtime()
    append_to_end(target_buf, "Comment", string.format("Task tooks: %.3f ms.", (finish - start) / 1e6))

    if not success then
        vim.api.nvim_buf_set_lines(target_buf, -1, -1, false, { "Error: " .. tostring(err) })
    end
end

--- Execute command on float window
--- @param cmd string CLI string
local function exec_cmd_f(cmd)
    if vim.t.f_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.f_termid)
    end
    if type(cmd) == "function" then
        local winids = ext.win.create_win(true, {title = "Task"})
        vim.t.f_runid = winids.winnr
        run_with_redirect(winids.bufnr, cmd)
        vim.t.f_runid = -1
    else
        vim.t.f_runid = win.create_win(true, { title = "Task" }).winnr
        vim.fn.jobstart(cmd, { term = true, on_exit = function() vim.t.f_runid = -1 end })
    end
    map.bnmap("q", ":q!<CR>")
end

--- Execute command on horizontal window
--- @param cmd string CLI string
local function exec_cmd_h(cmd)
    if vim.t.f_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.h_runid)
    else
        vim.cmd("horizontal new")
    end
    if type(cmd) == "function" then
        vim.t.h_runid = vim.api.nvim_get_current_win()
        run_with_redirect(vim.fn.bufnr(), cmd)
        vim.t.h_runid = -1
    else
        vim.fn.jobstart(cmd, { term = true, on_exit = function() vim.t.v_runid = -1 end })
        vim.cmd("resize " .. ext.ui.get_screen_row(0.3))
        vim.t.h_runid = vim.api.nvim_get_current_win()
    end
    map.bnmap("<C-q>", ":q!<CR>")
end

--- Execute command on vertical window
--- @param cmd string CLI string
local function exec_cmd_v(cmd)
    if vim.t.f_runid ~= -1 then
        vim.api.nvim_set_current_win(vim.t.h_runid)
    else
        vim.cmd("vertical new")
    end
    if type(cmd) == "function" then
        vim.t.v_runid = vim.api.nvim_get_current_win()
        run_with_redirect(vim.fn.bufnr(), cmd)
        vim.t.v_runid = -1
    else
        vim.fn.jobstart(cmd, { term = true, on_exit = function() vim.t.v_runid = -1 end })
        vim.cmd("vertical resize " .. ext.ui.get_screen_col(0.35))
        vim.t.v_runid = vim.api.nvim_get_current_win()
    end
    map.bnmap("<C-q>", ":q!<CR>")
end

--- Run codes.
--- @param task_name string Task name
--- @param exec function Execution function
local function run_task(task_name, exec)
    local cmds = get_commands(task_name)
    local cmds_count = ext.table.length(cmds)
    if cmds_count == 0 then
        vim.notify("Missing" .. task_name .. " task for '" .. vim.bo.filetype .. "'.", vim.log.levels.ERROR)
    elseif cmds_count == 1 then
        exec(ext.table.index(cmds, 1))
    else
        vim.ui.select(
            ext.table.select(cmds, function(key, value)
                return key
            end),
            {
                prompt = 'Tasks',
            },
            function(choice)
                exec(cmds[choice])
            end)
    end
end

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_user_command("Run", function(opts)
    local wintype = ""
    if #opts.fargs ~= 0 then
        wintype = opts.fargs[1]
    end

    local exec = ext.string.switch(wintype,
    {
        f     = exec_cmd_f,
        h     = exec_cmd_h,
        v     = exec_cmd_v,
        _     = exec_cmd_f
    })
    run_task("run", exec)
end,
{
    desc = "Run code.",
    nargs = '?',
    complete = function ()
        return {"f", "h", "v"}
    end
})

vim.api.nvim_create_user_command("Build", function(opts)
    local wintype = ""
    if #opts.fargs ~= 0 then
        wintype = opts.fargs[1]
    end

    local exec = ext.string.switch(wintype,
    {
        f     = exec_cmd_f,
        h     = exec_cmd_h,
        v     = exec_cmd_v,
        _     = exec_cmd_f
    })
    run_task("build", exec)
end,
{
    desc = "Build project.",
    nargs = '?',
    complete = function ()
        return {"f", "h", "v"}
    end
})

vim.api.nvim_create_user_command("Task", function(opts)
    local wintype = ""

    if #opts.fargs == 2 then
        wintype = opts.fargs[2]
    end

    local exec = ext.string.switch(wintype,
    {
        f     = exec_cmd_f,
        h     = exec_cmd_h,
        v     = exec_cmd_v,
        _     = exec_cmd_f
    })
    run_task(opts.fargs[1], exec)
end,
{
    desc = "Build project.",
    nargs = "+",
    complete = function (_, cmdline, _)
        local parts = vim.split(cmdline, "%s+")
        if #parts == 3 then
            return {"f", "h", "v"}
        else
            return {}
        end
    end
})
