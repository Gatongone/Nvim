local win = nvim.ext.win
local eidtor_key = nvim.keymap.editor

local function get_visual_selection()
    -- Check whether using visual mode
    local mode = vim.fn.mode()
    if not mode:match("[vV]") then
        return ""
    end

    -- Save original register content and type
    local original_reg = vim.fn.getreg('"')
    local original_reg_type = vim.fn.getregtype('"')

    -- Copy selected content to register.
    vim.cmd('silent normal! y')

    -- Get string from register
    local selection = vim.fn.getreg('"')

    -- Restore register content
    vim.fn.setreg('"', original_reg, original_reg_type)

    return selection
end

local function on_kd_exit()
    tmap("i", 'i')
    tmap("j", 'j')
    tmap("k", 'k')
    tmap("l", 'l')
end

local function is_english(string)
end

--- Open kd as float window
local function open_kd()
    local selection = get_visual_selection()
    if selection and selection ~= "" then
        local wininfo = win.create_win(true,
        {
            title    = "Translation",
            relative = "cursor",
            width    = 100,
            height   = 20,
            row      = 1,
            col      = 0
        })
        string.gsub(selection, '"', '\"')
        if selection:find('%s') ~= nil or selection:match("^[A-Za-z]+$") == nil then
            vim.fn.jobstart('kd -t "' .. selection .. '"', { term = true, on_exit = on_kd_exit })
        else
            vim.fn.jobstart('kd "' .. selection .. '"', { term = true, on_exit = on_kd_exit })
        end

        vim.cmd("startinsert")
        tmap(eidtor_key.normal_up,    'k')
        tmap(eidtor_key.normal_down,  'j')
        tmap(eidtor_key.normal_left,  'h')
        tmap(eidtor_key.normal_right, 'l')
    end
end

vim.api.nvim_create_user_command("Translate", open_kd, { })
