-- External explore
local M =
{
    custom_keymaps = "",
    keymap_path    = "",
    use_vim_map    = true,
    get_cmd        = function(tempfile) end
}
local win = nvim.ext.win
local uv  = vim.loop
local ex  =
{
    winnr    = -1,
    bufnr    = -1,
    tempname = "",
}

-- Ensure the target path can be created
local function ensure_dir_exists(path)
    local dir = vim.fn.fnamemodify(path, ":h")
    vim.fn.mkdir(dir, "p")
end

-- Callback after ex exit
local function on_ex_exit(keymap_config)
    -- Open selected path
    if vim.api.nvim_win_is_valid(ex.winnr) then
        vim.api.nvim_win_close(ex.winnr, true)
        ex.winid = -1
        if vim.fn.filereadable(vim.fn.expand(ex.tempname)) == 1 then
            local selected_files = vim.fn.readfile(ex.tempname)
            for _, file in ipairs(selected_files) do
                vim.cmd('tabnew ' .. vim.fn.fnameescape(file))
            end
        end
    end

    -- Set new tab cd path
    vim.cmd('silent! tcd ' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"))

    -- Restore enviroment
    if keymap_config ~= nil then
        uv.fs_unlink(keymap_config)
    end
    vim.fn.delete(ex.tempname)
end

-- Generate temp keymap config
local function setup_ex_keymaps()
    local keymap_config = vim.fn.tempname() .. ".keymaps"
    ensure_dir_exists(M.keymap_path)
    vim.fn.writefile(vim.split(M.custom_keymaps, "\n"), keymap_config)

    -- Overwrite old link
    uv.fs_unlink(M.keymap_path)
    uv.fs_symlink(keymap_config, M.keymap_path, { dir = false })
    return keymap_config
end

-- Open explore as window
local function open_ex()
    -- Create window
    local win_info = win.create_win(true, {title = "Explore"})
    local keymap_config = nil

    ex.winnr    = win_info.winnr
    ex.bufnr    = win_info.bufnr
    ex.tempname = vim.fn.tempname()

    -- Use vim keymap only when keymap.toml not exist
    if M.use_vim_map then
        keymap_config = setup_ex_keymaps()
    end

    -- Open explore
    vim.fn.jobstart(M.get_cmd(ex.tempname), { term = true, on_exit = function() on_ex_exit(keymap_config) end })
    vim.cmd("startinsert")
end

M.open_explore = open_ex
return M
