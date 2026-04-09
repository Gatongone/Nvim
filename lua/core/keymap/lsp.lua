local config = require("config")
local keymap = config.keymap.lsp
local map = require("core.keymap.map")

vim.api.nvim_create_autocmd('LspAttach',
{
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Setup default lsp actions
        map.nmap(keymap.format_code,         vim.lsp.buf.format)
        map.nmap(keymap.rename_buf,          vim.lsp.buf.rename)
        map.nmap(keymap.open_error_diag,     vim.diagnostic.setqflist)
        map.nmap(keymap.open_hover_diag,     vim.diagnostic.open_float)
        map.nmap(keymap.open_code_action,    vim.lsp.buf.code_action)
        map.nmap(keymap.open_hover_doc,      vim.lsp.buf.hover)
        map.nmap(keymap.open_sign_help,      vim.lsp.buf.signature_help)
        map.nmap(keymap.goto_ref,            vim.lsp.buf.references)
        map.nmap(keymap.goto_definition,     vim.lsp.buf.definition)
        map.nmap(keymap.goto_declaration,    vim.diagnostic.setqflist)
        map.nmap(keymap.goto_implementation, vim.lsp.buf.implementation)
        map.nmap(keymap.goto_prev_diag,      function() vim.diagnostic.jump({ count = -1, float = true }) end)
        map.nmap(keymap.goto_next_diag,      function() vim.diagnostic.jump({ count = 1, float = true }) end)

        -- Show variable highlight
        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
            {
                buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' },
            {
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end
        -- Show parameters signature_help
        vim.api.nvim_create_autocmd("CursorHoldI",
        {
            buffer = bufnr,
            callback = function()
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local before = line:sub(1, col)
                if before:match("%b()") == nil and before:match("%(") then
                    vim.lsp.buf.signature_help()
                end
            end
        })

        -- Setup default cmp actions
        map.imap(keymap.cmp_open, "<C-x><C-o>")
        map.imap(keymap.cmp_next, "<C-n>")
        map.imap(keymap.cmp_prev, "<C-p>")
        map.imap(keymap.cmp_accept, function()
            if vim.fn.pumvisible() == 1 then
                return "<C-y>"
            else
                return keymap.cmp_accept
            end
        end, { expr = true })
        if keymap.cmp_open == keymap.cmp_accept then
            map.imap(keymap.cmp_accept, function()
                if vim.fn.pumvisible() == 1 then
                    return "<C-y>"
                else
                    return "<C-x><C-o>"
                end
            end, { expr = true })
        end
        map.imap(keymap.cmp_close, function()
            if vim.fn.pumvisible() == 1 then
                return "<C-d>"
            else
                return keymap.cmp_close
            end
        end, { expr = true })

        vim.opt.completeopt = { "menuone", "noinsert" }
        vim.opt.updatetime = 300

        -- Show complete diagnostic when input something
        local autocomplete_group = vim.api.nvim_create_augroup("NativeAutocomplete", { clear = true })
        vim.api.nvim_create_autocmd("TextChangedI",
        {
            buffer = bufnr,
            group = autocomplete_group,
            callback = function()
                -- This will not be triggered if the completion window is already open or if a deletion is being undone
                if vim.fn.pumvisible() == 1 or vim.fn.state("m") == "m" then
                    return
                end

                -- Get the character before the cursor
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local char_before = line:sub(col, col)

                -- This is triggered only when the input consists of letters, underscores, or specific characters (such as .)
                if char_before:match("[%w_%.]") then
                    -- Use `schedule` to ensure that autocompletion is triggered after the character is entered
                    vim.schedule(function()
                        -- If `omnifunc` is not set for this language, it will fall back to standard keyword completion
                        pcall(vim.api.nvim_feedkeys, vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n", true)
                    end)
                end
            end
        })
    end
})
