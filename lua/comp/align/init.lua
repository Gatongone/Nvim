--- Multi-delimiter alignment
local function align_with_delimiters(lines, delimiters)
    local result = vim.deepcopy(lines)
    for _, delim in ipairs(delimiters) do
        local positions = {}
        local max_pos = 0

        -- Find the maximum number of characters before "delim" in all lines containing "delim"
        for i, line in ipairs(result) do
            -- Byte index
            local idx = line:find(delim, 1, true)
            if idx then
                local prefix = line:sub(1, idx - 1)
                local char_count = vim.fn.strchars(prefix)
                positions[i] = char_count
                if char_count > max_pos then
                    max_pos = char_count
                end
            end
        end

        -- If there is no such delimiter, skip
        if max_pos == 0 then
            goto continue
        end

        -- Insert Spaces for alignment on each line
        for i, line in ipairs(result) do
            if positions[i] then
                local idx = line:find(delim, 1, true)
                if idx then
                    local prefix = line:sub(1, idx - 1)
                    local current_len = vim.fn.strchars(prefix)
                    local spaces_needed = max_pos - current_len
                    if spaces_needed > 0 then
                        result[i] = prefix .. string.rep(' ', spaces_needed) .. line:sub(idx)
                    end
                end
            end
        end
        ::continue::
    end
    return result
end

-- Create usercmd
vim.api.nvim_create_user_command('Align', function(opts)
    local delimiters = opts.fargs
    if #delimiters == 0 then
        print("Usage: Align delim1 [delim2 ...]")
        return
    end

    -- Read the selected line
    local lines = {}
    for i = opts.line1, opts.line2 do
        table.insert(lines, vim.fn.getline(i))
    end

    -- Invoke align
    local new_lines = align_with_delimiters(lines, delimiters)

    -- Write back to the buffer
    for i, line in ipairs(new_lines) do
        vim.fn.setline(opts.line1 + i - 1, line)
    end
end, { range = true, nargs = '*' })
