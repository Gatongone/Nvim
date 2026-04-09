local label_chars = string.toarray("abcdefghijklmnobqrstuvwxyz")
local ns_id = vim.api.nvim_create_namespace('JumpWord')
local hl_group =
{
    unmatch = "Comment",
    matched = "JumpWordMatch",
    label   = "JumpWordLabel"
}
local escape_chars =
{
    esc_code = vim.api.nvim_replace_termcodes("<Esc>", true, true, true),
    bs_code  = vim.api.nvim_replace_termcodes("<BS>", true, true, true)
}
local cache =
{
    positions      = {},
    labels         = {},
    label_buffer   = "",
    visible_range  = { first = 0, last = 0 },
    handling_input = false,
    pattern        = ""
}

-- Start jump listening
function cache.jump()
    cache.visible_range =
    {
        first = vim.fn.line('w0') - 1,
        last  = vim.fn.line('w$') - 1
    }
    cache.positions         = {}
    cache.pattern           = ""
    cache.labels            = {}
    cache.label_buffer      = ""
    cache.use_double_labels = false
    cache.handling_input    = true
    cache.listen_input_pattern()
end

--- Pattern and label listening loop
function cache.listen_input_pattern()
    local included_chars = {}

    -- Start the loop
    local function input_loop()
        -- If it's not handling, then exit loop
        if not cache.handling_input then
            cache.cleanup()
            return
        end

        -- Get user input
        local char_code = vim.fn.getchar()
        if char_code == 0 then
            input_loop()
            return
        end

        -- Character can be ascii code or control code
        local char = type(char_code) == "string" and char_code or string.char(char_code)

        -- Handle char, false stands for exiting loop or jumped to target position
        if not cache.try_process_char(char, included_chars) then
            cache.cleanup()
            return
        end

        -- Match user pattern
        cache.positions = cache.find_matches(cache.pattern)
        if #cache.positions == 0 then
            cache.clear_hightlight()
            cache.cleanup()
            return
        end

        -- Regenerate labels
        cache.labels, included_chars = cache.generate_labels(#cache.positions)
        cache.clear_hightlight()
        cache.highlight_labels_patterns()
        vim.defer_fn(input_loop, 10)
    end
    input_loop()
end

--- Handle user input
--- @param char string User inputed character
--- @param included_chars table Valid label characters
--- @return boolean succeed false stands for exiting loop or jumped to target position
function cache.try_process_char(char, included_chars)
    -- Handle escape characters
    if char == escape_chars.esc then
        return false
    elseif char == escape_chars.bs_code then
        cache.clear_hightlight()
        cache.pattern = cache.pattern:sub(1, -2)
        cache.label_buffer = ''
        return true
    end

    local is_label = table.contains(included_chars, char)

    -- Check if character can be label
    if is_label then
        cache.label_buffer = cache.label_buffer .. char
    else
        cache.label_buffer = ''
    end

    -- Label matching takes priority
    local expected_len = #cache.positions > #included_chars and 2 or 1

    -- Try to match labels
    if #cache.label_buffer >= expected_len then
        local target = cache.find_label_match(cache.label_buffer)
        if target then
            cache.jump_to_position(target)
        end
        return false
    end

    -- Keep listening
    if not is_label then
        cache.pattern = cache.pattern .. char
    end
    return true
end

--- Get positions from pattern
--- @param pattern string User pattern
--- @return table positions Positions of matched texts in current buffer
function cache.find_matches(pattern)
    local buf = vim.api.nvim_get_current_buf()
    local positions = {}

    for lnum = cache.visible_range.first, cache.visible_range.last do
        local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum+1, true)[1]
        local start_idx = 1

        while true do
            local start, finish = line:find(pattern, start_idx)
            if not start then break end
            local next_key = nil

            if finish ~= nil and line:len() >= finish + 1 then
                next_key = string.sub(line, finish + 1, finish + 1)
            end

            table.insert(positions,
            {
                row      = lnum,
                col      = start - 1,
                end_col  = finish,
                next_key = next_key
            })

            start_idx = finish + 1
        end
    end
    return positions
end

--- Generate labels
--- @param count number Generated label count
--- @return table labels Label array
--- @return table included_chars Label characters
function cache.generate_labels(count)
    -- Get all characters where are target text next keys
    local excluded_chars = {}
    for _, pos in ipairs(cache.positions) do
        if pos.next_key then
            local char = pos.next_key:lower()
            excluded_chars[char] = true
        end
    end

    -- Get that include characters so that we can avoid patterns and labels conflict
    local included_chars = {}
    for _, char in ipairs(label_chars) do
        if not excluded_chars[char] then
            table.insert(included_chars, char)
        end
    end

    -- Fallback to regular mode if all conflicts
    if #included_chars == 0 then
        included_chars = label_chars
    end


    -- Generate labels
    local labels = {}
    local single_labels_available = math.min(count, #included_chars)
    -- Single character label
    if count <= #included_chars then
        for i = 1, single_labels_available do
            labels[i] = included_chars[i]
        end
    -- Double characters label
    else
        local first_idx = 1
        local second_idx = 1

        for i = 1, count do
            labels[i] = included_chars[first_idx] .. included_chars[second_idx]
            second_idx = second_idx + 1
            if second_idx > #included_chars then
                second_idx = 1
                first_idx = (first_idx % #included_chars) + 1
            end
        end
    end

    return labels, included_chars
end

--- Highlight labels and patterns
function cache.highlight_labels_patterns()
    local buf = vim.api.nvim_get_current_buf()

    -- Highlight visible range
    for lnum = cache.visible_range.first, cache.visible_range.last do
        vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group.unmatch, lnum, 0, -1)
    end

    -- Append labels and match highlight
    for i, pos in ipairs(cache.positions) do
        vim.api.nvim_buf_add_highlight(buf, ns_id, hl_group.matched, pos.row, pos.col, pos.end_col)
        vim.api.nvim_buf_set_extmark(buf, ns_id, pos.row, pos.col,
        {
            virt_text     = {{cache.labels[i], hl_group.label}},
            virt_text_pos = 'overlay',
            hl_mode       = 'combine',
            priority      = 1000
        })
    end
end

--- Get position of matched label
--- @param input string Label to match
--- @return table|nil position Position of matching label
function cache.find_label_match(input)
    for i, label in ipairs(cache.labels) do
        if label == input then
            return cache.positions[i]
        end
    end
    return nil
end

--- Jump to target position
--- @param pos table Position
function cache.jump_to_position(pos)
    cache.handling_input = false
    vim.api.nvim_win_set_cursor(0, {pos.row + 1, pos.col})
end

--- Clear highlight of pattern and label
function cache.clear_hightlight()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

--- Reset jumping status
function cache.cleanup()
    cache.clear_hightlight()
    cache.handling_input = false
    cache.label_buffer = ''
end

-- Append user command
vim.api.nvim_create_user_command("JumpWord", cache.jump, {})
