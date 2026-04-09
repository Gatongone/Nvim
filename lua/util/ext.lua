local default_win_opts =
{
    anchor    = 'NW',
    title     = '',
    title_pos = 'center',
    relative  = 'editor',
    width     = 0.7,
    height    = 0.6,
    focusable = true,
    bufpos    = nil,
    border    = 'rounded',
    style     = 'minimal',
    zindex    = 1,
    noautocmd = false,
}

--- Get window properties that expand with default config
--- @param opts table|nil See https://neovim.io/doc/user/api.html#nvim_open_win()
--- @return table opts Options that expand with default config
local get_win_config = function(opts)
    opts = opts or {}
    local ui = vim.api.nvim_list_uis()[1]
    if opts.width and opts.width < 1 then
        opts.width = math.floor(ui.width * opts.width)
    end
    if opts.height and opts.height < 1 then
        opts.height = math.floor(ui.height * opts.height)
    end
    opts.width = opts.width or math.min(ui.width - 10, math.floor(ui.width / 1.5))
    opts.height = opts.height or math.min(ui.height - 10, math.floor(ui.height / 1.3))
    opts.row = opts.row or math.floor((ui.height - opts.height) / 2.5)
    opts.col = opts.col or math.floor((ui.width - opts.width) / 2)
    opts = vim.tbl_extend("force", default_win_opts, opts)
    if type(opts.title) == 'string' and opts.title ~= ''  then
        opts.title = " "..opts.title.." "
    end
    return opts
end

--- Extensions for neovim
local M =
{
    --- UI APIS
    ui =
    {
        --- Get screen row
        --- @param ratio number The ratio of screen height
        --- @return number row 
        get_screen_row = function(ratio)
            local ui = vim.api.nvim_list_uis()[1]

            if ratio ~= nil and ratio < 1 then
                return ui.height * ratio
            end
            return ui.height
        end,

        --- Get screen col
        --- @param ratio number The ratio of screen width
        --- @return number col
        get_screen_col = function(ratio)
            local ui = vim.api.nvim_list_uis()[1]

            if ratio ~= nil and ratio < 1 then
                return ui.width * ratio
            end
            return ui.width
        end
    },

    --- Buffer APIs
    buf =
    {
        --- Get buffer's count
        --- @return number count Buffers count
        get_bufs_count = function()
            return vim.fn.bufnr('$')
        end,

        --- Get buffers with varialbe that match var_value
        --- @param var_name string Variable name
        --- @param var_value any Variable value
        --- @return table buffers Buffers with varialbe that match var_value
        get_bufs_with_var = function(var_name, var_value)
            local bufs = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.fn.getbufvar(buf, '&'..var_name) == var_value then
                    table.insert(bufs, buf)
                end
            end
            return bufs
        end,

        --- Get tab name by buffer id
        --- @param id number Buffer hid, 0 for current tab
        --- @return string bufname Buffer name
        get_buf_name = function(id)
            return vim.api.nvim_buf_get_name(id)
        end,

        --- Get current buffer id
        --- @return number current buffer ID
        get_cur_buf_id = function()
            return vim.fn.bufnr()
        end,

        --- get buffers
        get_bufs = function()
            return vim.api.nvim_list_bufs()
        end
    },

    --- Tab APIs
    tab =
    {
        --- Get number of tabs
        --- @return number count Number of tabs
        get_tabs_count = function()
            return vim.fn.tabpagenr('$')
        end,

        --- Get tab id by tab name
        --- @param name string Tab name
        --- @return number tab handle
        get_tab_id = function(name)
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local buf_name = vim.api.nvim_buf_get_name(buf)
                if buf_name == name or vim.fn.fnamemodify(buf_name, ":t") == name then
                    return buf
                end
            end
            return -1
        end,

        --- Get current tab id
        --- @return number tabid Current tab handle
        get_cur_tab_id = function()
            return vim.api.nvim_tabpage_get_number(0)
        end,

        --- Get current tab name
        --- @return string tabname Current tab name
        get_cur_tab_name = function()
            return vim.api.nvim_buf_get_name(0)
        end,
    },

    --- Window APIs
    win =
    {
        --- Get number of windows where in specific tab
        --- @param id number|nil Tab id
        --- @return number id Numbers of windows where in specific tab
        get_wins_count = function(id)
            if not id then
                id = 0
            end
            return #vim.api.nvim_tabpage_list_wins(id)
        end,

        --- Get number of windows where in cur tab
        --- @return number count Numbers of windows where in cur tab
        get_cur_wins_count = function()
            return vim.fn.winnr('$')
        end,

        -- Get windows where in current tab
        --- @return number winnr Window id
        get_cur_win =  function()
            return vim.fn.winnr()
        end,

        --- Create a float window
        --- @param enter boolean Whether focus on the window after it created
        --- @param opts table|nil See https://neovim.io/doc/user/api.html#nvim_open_win()
        --- @return table winconfig with window info: {bufnr: number, winnr: number, title: window title}
        create_win = function(enter, opts)
            local win         = {}
            local focus       = enter == nil or enter == true
            local useropts = get_win_config(opts)
            win.title = useropts.title
            win.bufnr = vim.api.nvim_create_buf(false, false)
            win.winnr = vim.api.nvim_open_win(win.bufnr, focus, useropts)
            return win
        end,

        --- Get window properties that expand with default config
        --- @param opts table|nil See https://neovim.io/doc/user/api.html#nvim_open_win()
        --- @return table opts Options that expand with default config
        get_win_config = get_win_config
    },

    --- Table APIs.
    table =
    {
        --- Check if element contains in table
        --- @param src table
        --- @param element any
        --- @return boolean contains
        contains = function(src, element)
            for _, value in pairs(src) do
                if element == value then
                    return true
                end
            end
            return false
        end,

        --- Gets the total number of elements in the table
        --- @param src any A table which to get length
        --- @return number length The total number of elements in the table
        length = function(src)
            if not src then
                return 0
            end
            local count = 0
            for _ in pairs(src) do
                count = count + 1
            end
            return count
        end,

        --- Gets the value at the specified position in the paris(table)
        --- @param src any A table which to get value
        --- @param index any The position of the table element to get
        --- @return any | nil element The value at the specified position in paris(table)
        index = function(src, index)
            local count = 0
            for _ , value in pairs(src) do
                count = count + 1
                if count == index then
                    return value
                end
            end
            return nil
        end,

        --- Projects each element of a sequence into a new form
        --- @param src table A table to invoke a transform function on
        --- @param selector function A transform function(key, value) to apply to each element
        --- @return table
        select = function(src, selector)
            local result = {}
            for key, value in pairs(src) do
                table.insert(result, selector(key, value))
            end
            return result
        end,

        --- Filters a sequence of values based on a predicate
        --- @param src table A table to filter
        --- @param predicate function A function(key, value) to test each element for a condition
        --- @return table A table that contains elements from the input sequence that satisfy the condition
        where = function(src, predicate)
            local result = {}
            for key, value in pairs(src) do
                if predicate(key, value) then
                    table.insert(result, value)
                end
            end
            return result
        end
    },

    --- String APIs.
    string =
    {
        --- Convert string to array
        --- @param str string
        --- @return table array
        toarray = function(str)
            local result = {}
            for i = 1, #str do
                result[i] = string.sub(str, i, i)
            end
            return result
        end,

        --- Replace string with pattern
        --- @param str string
        --- @return string result
        replace = function(str, patterns)
            return (str:gsub("%$([%a_][%w_]*)", function(key)
                return patterns[key] or ("$"..key)
            end))
        end,

        --- Searches for the specified object and returns the value whose key first match in a cases table.
        --- Use '_' for default cases.
        ---
        --- Example:
        ---
        --- ```lua
        --- local match = "A"
        --- string.switch(match,
        --- {
        ---     A  = "This is A",
        ---     B  = "This is B",
        ---     _  = "Default value"
        --- })
        --- print(match) -- => This is A
        --- ```
        --- @param str string The string to match against the keys of the cases table
        --- @param cases table A table where keys are strings to compare with `str` and values are the corresponding results
        --- @return any matched The value associated with the matching key, or the value of "@others" if present, otherwise nil
        switch = function(str, cases)
            local others = nil
            for key, value in pairs(cases) do
                if str == key then
                    return value
                elseif key == "_" then
                    others = value
                end
            end
            return others
        end
    }
}
return M
