require("core.keymap.netrw")
local ui = require("comp.explore.netrw.ui")
local ignore_bufs =
{
    "noice",
    "notify",
    "smear-cursor",
    "netrw",
    "terminal",
}

--- Netrw extension
local netrw =
{
    --- Copied path
    copied = { },

    --- Cut path
    cut = { },

    --- Pasted highlight
    hl = { },

    --- Add file to highligh buffer
    --- @param mod string Highligh group
    --- @param path string The file's full path
    add_highlight = function(self, mod, path)
        if vim.b.netrw_liststyle == 3 then
            return
        end
        local file_name = vim.fn.fnamemodify(path, ":t")
        local file_dir = vim.fn.fnamemodify(path, ":p:h")
        if self.hl[file_dir] == nil then
            self.hl[file_dir] = { }
        end
        table.insert(self.hl[file_dir],
        {
            id   = vim.fn.matchadd(mod, file_name),
            path = path,
            name = file_name,
            mod  = mod,
            ishl = true
        })
    end,

    --- Delete file from highligh buffer
    --- @param path string The file's full path
    delete_highlight = function(self, path)
        if vim.b.netrw_liststyle == 3 then
            return
        end
        local dir = vim.fn.fnamemodify(path, ":p:h")
        if self.hl[dir] == nil then
            return
        end
        for i, value in pairs(self.hl[dir]) do
            if value.path == path then
                vim.fn.matchdelete(value.id)
                table.remove(self.hl[dir], i)
                return
            end
        end
    end,

    --- If the path is not add to netrw.copied, then insert it
    --- @param path string The copy target's full path
    --- @return boolean succeed True when insert insert succeed.
    try_copy = function(self, path)
        for i = #self.copied, 1, -1 do
            if self.copied[i] == path then
                return false
            end
        end
        self:add_highlight("NetrwCopied", path)
        table.insert(self.copied, path)
        print("Copy", path)
        return true
    end,

    --- If the path is not add to netrw.cut, then insert it
    --- @param path string The cut target's full path
    --- @return boolean succeed True when insert insert succeed.
    try_cut = function(self, path)
        for i = 1, #self.cut do
            if self.cut[i] == path then
                return false
            end
        end
        self:add_highlight("NetrwCut", path)
        table.insert(self.cut, path)
        print("Cut", path)
        return true
    end,

    --- If the path is not add to netrw.copied, then remove it ,or insert it
    --- @param path string The copy target's full path
    toggle_copy = function(self, path)
        for i = 1, #self.copied do
            if self.copied[i] == path then
                self:delete_highlight(path)
                table.remove(self.copied, i)
                print("Remove copy", path)
                return
            end
        end
        self:add_highlight("NetrwCopied", path)
        table.insert(self.copied, path)
        print("Copy", path)
        return true
    end,

    --- If the path is not add to netrw.cut, then remove it ,or insert it
    --- @param path string The cut target's full path
    toggle_cut = function(self, path)
        for i = 1, #self.cut do
            if self.cut[i] == path then
                self:delete_highlight(path)
                table.remove(self.cut, i)
                print("Remove cut", path)
                return
            end
        end
        self:add_highlight("NetrwCut", path)
        table.insert(self.cut, path)
        print("Cut", path)
        return true
    end,

    --- Get marked list
    --- @return table marked_files marked list as table type
    get_marked_list = function()
        vim.cmd([[let g:netrw_marked_files = netrw#Expose('netrwmarkfilelist')]])
        local marked_files = vim.g.netrw_marked_files
        if marked_files == nil or marked_files == "n/a" or marked_files[1] == nil then
            marked_files = { }
        end
        return marked_files
    end,

    --- Clear marked list
    clear_marked_list = function(self)
        vim.cmd([[call netrw#Modify('netrwmarkfilelist',[])]])
        if vim.b.netrw_liststyle ~= 3 then
            for _, dir in pairs(self.hl) do
                for _, item in dir do
                    vim.fn.matchdelete(item.id)
                end
            end
        end
        self.copied = { }
        self.cut = { }
        self.hl = { }
    end,
}

--- Verify wether netrw window alive
--- @return boolean isalive
local is_netrw_alive = function()
    if vim.t.netrw_winid == nil then
        return false
    end
    for bufnr = 1, vim.fn.bufnr('$') do
        local file_type = vim.fn.getbufvar(bufnr, '&filetype')
        if file_type == 'netrw' then
            return true
        end
    end
    return false
end

--- Verify if current line path can be collapsed
local can_curline_collapse = function()
    local current_line = vim.api.nvim_get_current_line()
    local current_lnum = vim.fn.line('.')
    local next_lnum = current_lnum + 1

    -- Second line can't be collapsed. Kinda werid, right?
    -- Final line can't be collapsed.
    -- Only directory can be collapsed.
    if current_lnum == 2 or next_lnum > vim.fn.line('$') or not current_line:match("/$") then
        return false
    end

    local next_line = vim.fn.getline(next_lnum)

    -- Pipes
    local _, current_pipes = current_line:gsub("|", "")
    local _, next_pipes    = next_line:gsub("|", "")

    return next_pipes == current_pipes + 1
end

--- Gets the full path to the line item where the netrw cursor is currently located
--- @return string curline_path Currentline path
local get_curline_path = function()
    local path = ""

    vim.cmd
    [[
        let b:netrw_curfile_name = netrw#Call('NetrwGetWord')
        let b:netrw_curdir_path  = netrw#Call('NetrwTreePath', exists("w:netrw_treetop") ? w:netrw_treetop : b:netrw_curdir )
        let b:netrw_curfile_path = netrw#Call('ComposePath', b:netrw_curdir_path, b:netrw_curfile_name)
    ]]

    if vim.b.netrw_curfile_name:sub(-1) == "/" and not can_curline_collapse() then
        path = vim.b.netrw_curdir_path
    else
        path = vim.b.netrw_curfile_path
    end

    if path:sub(-1) == "/" then
        path = path:sub(1, -2)
    end
    return path
end

--- Paste files
local netrw_paste_files = function()
    local pasted_files = { }
    local copy_list  = ""
    local cut_list   = ""
    local unmark_all  = false

    -- Get cli parameters
    copy_list = table.concat(netrw.copied, " ")
    cut_list = table.concat(netrw.cut, " ")

    -- Copy files to current directory
    if #netrw.copied ~= 0 then
        vim.fn.execute("silent !" .. nvim.env.cli_cpd .. " " .. copy_list .. " "  .. vim.b.netrw_curdir)
        unmark_all = true
    end

    -- Cut files to current directory
    if #netrw.cut ~= 0 then
        vim.fn.execute("silent !" .. nvim.env.cli_mv .. " " .. cut_list .. " "  .. vim.b.netrw_curdir)
        unmark_all = true
    end

    -- Unmark all
    if unmark_all then
        netrw:clear_marked_list()
    else
        print("Nothing to paste")
    end
end

--- Copy file
local netrw_copy_file = function()
    netrw:toggle_copy(get_curline_path())
end

--- Cut file
local netrw_cut_file = function()
    netrw:toggle_cut(get_curline_path())
end

--- Create file
local netrw_create_file = function()
    local name = vim.fn.input("Please enter name: ")
    vim.fn.execute("silent !" .. nvim.env.cli_nf .. " " .. vim.b.netrw_curdir .. "/" .. name)
    vim.fn.execute("redraw!")
end

--- Create directory
local netrw_create_directory = function()
    local name = vim.fn.input("Please enter name: ")
    vim.fn.execute("silent !" .. nvim.env.cli_nd .. " "  .. vim.b.netrw_curdir .. "/" .. name)
    vim.fn.execute("redraw!")
end

-- Rename directory
local netrw_rename = function()
    local curpath = get_curline_path()
    local name = vim.fn.input("Please enter name: ")
    local destpath = vim.fn.isdirectory(curpath) == 1
    and vim.fn.fnamemodify(curpath, ":p:h:h")..nvim.env.dir_sp..name
    or vim.fn.fnamemodify(curpath, ":p:h")..nvim.env.dir_sp..name
    vim.fn.execute("silent !"..nvim.env.cli_mv.." "..curpath.." "..destpath)
    vim.fn.execute("redraw!")
end

--- Remove recursively
local netrw_remove_recursively = function()
    if vim.o.filetype ~= 'netrw' then
        return
    end

    local marked_files = netrw:get_marked_list()

    if #marked_files == 0 then
        vim.cmd("normal mf")
        vim.cmd("NetrwRemoveRecursively")
        return
    end

    local params = table.concat(marked_files, " ")
    print("Try removing:\n"..table.concat(marked_files, "\n"))
    vim.ui.select({"YES", "NO"}, { prompt = "Are you sure remove these files?" }, function(choice)
        if choice == "YES" then
            vim.fn.execute("silent !" .. nvim.env.cli_rmd .. " " .. params)
            netrw:clear_marked_list()
        end
    end)
end

--- Open netrw, if it was opened, then focus on it
local netrw_open = function()
    -- It's still netrw window, we don't need to open it twice
    if vim.o.filetype == 'netrw' then
        return
    end

    -- The window was opened, we just focus on it
    if is_netrw_alive() then
        vim.api.nvim_set_current_win(vim.t.netrw_winid)
    else
        vim.cmd("Lexplore")
        netrw:clear_marked_list()
        vim.t.netrw_winid = vim.api.nvim_get_current_win()
    end
end

--- Close netrw and reset status
local netrw_close = function()
    if vim.o.filetype ~= 'netrw' then
        return
    end
    vim.t.netrw_winid = nil
    vim.cmd("Lexplore")
end

--- Setup icons and highlight
local netrw_setup_ui = function()
	-- Hook on BufModifiedSet to configure the netrw buffer
	if not (vim.bo and vim.bo.filetype == "netrw") then
		return
	end

	if vim.b.netrw_liststyle ~= 0 and vim.b.netrw_liststyle ~= 1 and vim.b.netrw_liststyle ~= 3 then
		return
	end

	-- Forces the usage of signcolumn in netrw buffers
	vim.opt_local.signcolumn = "yes"

	local bufnr = vim.api.nvim_get_current_buf()
	ui.setup(bufnr)
end

--- Callback when netrw close
local netrw_on_close = function()
    if vim.o.filetype ~= 'netrw' then
        return
    end
    vim.t.netrw_winid = nil
end

--- Callback when netrw enter
local netrw_on_enter = function()
    if vim.o.filetype ~= 'netrw' then
        return
    end

    -- Close the netrw when it's the last window
    if nvim.ext.win.get_cur_wins_count() == 1 then
        goto exit
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

    ::exit::
    vim.cmd("q!")
end

--- On a directory enter
--- @param path_before string The path that is before enter directory
--- @param path_after string The path that is after enter directory
local netrw_on_enter_directory = function(path_before, path_after)
    if vim.b.netrw_liststyle == 3 then
        return
    end
    if netrw.hl[path_before] ~= nil then
        for _, value in pairs(netrw.hl[path_before]) do
            if value.ishl == true then
                vim.fn.matchdelete(value.id)
                value.ishl = false
            end
        end
    end

    if netrw.hl[path_after] ~= nil then
        for _, value in pairs(netrw.hl[path_after]) do
            if value.ishl == false then
                value.id = vim.fn.matchadd(value.mod, value.name)
                value.ishl = true
            end
        end
    end
end

--- Open a new netrw windows in new tab
local netrw_open_file_in_new_tab = function(path)
    if vim.b.netrw_liststyle ~= 1 then
        vim.cmd([[ let g:netrw_curtop = exists(w:netrw_treetop) ? w:netrw_treetop : b:netrw_curdir ]])
    end
    vim.cmd('wincmd p')
    vim.cmd(':tabnew '..path)
    netrw_open()
    netrw_setup_ui()
    vim.cmd('wincmd p')
end

--- Open the file or directory, and then reset highlight
local netrw_open_file_or_directory = function()
    -- It's just a collapse dir, do nothing
    if vim.b.netrw_liststyle == 3 and can_curline_collapse() then
        return
    end

    local path = get_curline_path()
    if vim.fn.isdirectory(path) ~= 1 then
        netrw_open_file_in_new_tab(path)
        vim.cmd('silent! lcd %:p:h')
        return
    end

    local before_dir = vim.b.netrw_curdir
    vim.cmd("normal \r")
    vim.cmd('silent! lcd %:p:h')
    if vim.b.netrw_liststyle == 3 then
        return
    end
    -- Enter directory and reset highligh
    local after_dir = vim.b.netrw_curdir
    if vim.fn.isdirectory(after_dir) == 1 then
        netrw_on_enter_directory(before_dir, after_dir)
        return
    end
end


--- Edit the file or directory, and then reset highlight
local netrw_edit_file_or_directory = function()
    local path = get_curline_path()
    vim.cmd('wincmd p')
    vim.cmd(':tabnew '..path)
    netrw_open()
    netrw_setup_ui()
    vim.cmd('wincmd p')
    vim.cmd('silent! lcd %:p:h')
end

--- Exit current directory, and then reset highlight
local netrw_exit_directory = function()
    -- If the folder was expanded, then collapse it
    if vim.b.netrw_liststyle == 3 and can_curline_collapse() then
        vim.cmd("normal \r")
        return
    end
    -- Exit to parent folder
    local cur_dir = vim.b.netrw_curdir
    vim.cmd("normal -")
    local parent_dir = vim.b.netrw_curdir
    netrw_on_enter_directory(cur_dir, parent_dir)
end

-- Cancel all marked, copied and cut items
local netrw_cancel = function()
    netrw.clear_marked_list()
    vim.cmd("normal mu")
end

-- Register usercmd and autocmd
vim.api.nvim_create_user_command("NetrwCancel",               netrw_cancel,                 { })
vim.api.nvim_create_user_command("NetrwEditFileOrDirectory",  netrw_edit_file_or_directory, { })
vim.api.nvim_create_user_command("NetrwOpenFileOrDirectory",  netrw_open_file_or_directory, { })
vim.api.nvim_create_user_command("NetrwExitDirectory",        netrw_exit_directory,         { })
vim.api.nvim_create_user_command("NetrwPasteFiles",           netrw_paste_files,            { })
vim.api.nvim_create_user_command("NetrwCopyFile",             netrw_copy_file,              { })
vim.api.nvim_create_user_command("NetrwCutFile",              netrw_cut_file,               { })
vim.api.nvim_create_user_command("NetrwRename",               netrw_rename,                 { })
vim.api.nvim_create_user_command("NetrwRemoveRecursively",    netrw_remove_recursively,     { })
vim.api.nvim_create_user_command("NetrwCreateFile",           netrw_create_file,            { })
vim.api.nvim_create_user_command("NetrwCreateDirectory",      netrw_create_directory,       { })
vim.api.nvim_create_user_command("NetrwOpenFileTree",         netrw_open,                   { })
vim.api.nvim_create_user_command("NetrwCloseFileTree",        netrw_close,                  { })
vim.api.nvim_create_autocmd("WinClosed",      { pattern = "*", callback = netrw_on_close })
vim.api.nvim_create_autocmd("WinEnter",       { pattern = "*", callback = netrw_on_enter })
vim.api.nvim_create_autocmd("BufModifiedSet", { pattern = "*", callback = netrw_setup_ui })

-- Netrw style
vim.api.nvim_set_var("netrw_keepdir", 0)                           -- Keep current directory (in the buffer) is matching with the browsing directory.
vim.api.nvim_set_var("netrw_winsize", 13)                          -- Netrw width size
vim.api.nvim_set_var("netrw_banner", 0)                            -- Set netrw banner status, 0 for closing and 1 for opening
vim.api.nvim_set_var("netrw_localcopydircmd", 'cp -r')             -- Enable recursively copy
vim.api.nvim_set_var("netrw_list_hide", [[\(^\|\s\s\)\zs\.\S\+]])  -- Hiding gh items
vim.api.nvim_set_var("netrw_liststyle", 3)                         -- List style:
                                                                   -- 0: thin listing (one file per line)
                                                                   -- 1: long listing (one file per line stamp information and file size)
                                                                   -- 2: wide listing (multiple files in columns)
                                                                   -- 3: tree style listing (there are some bugs seems will not be fixed)
