local map = require("core.keymap.map")
local keymap = nvim.keymap.lsp
local M = {}

--- Setup when lsp client was appended
function M.setup_lsp(bmap)
    local opts = { noremap = true, silent = true }
    -- Actions
    bmap('n', keymap.rename_buf,  '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    bmap('n', keymap.format_code, '<cmd>lua vim.lsp.buf.format()<CR>', opts)

    -- Goto
    bmap('n', keymap.goto_declaration,    '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    bmap('n', keymap.goto_implementation, '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

    -- Setup lspsaga
    map.nmap(keymap.goto_definition,  ':Lspsaga goto_definition<CR>')
    map.nmap(keymap.open_code_action, ':Lspsaga code_action<CR>')
    map.nmap(keymap.goto_prev_diag,   ':Lspsaga diagnostic_jump_prev<CR>')
    map.nmap(keymap.goto_next_diag,   ':Lspsaga diagnostic_jump_next<CR>')
    map.nmap(keymap.open_error_diag,  ':Lspsaga show_workspace_diagnostics<CR>')
    map.nmap(keymap.open_hover_diag,  ':Lspsaga show_cursor_diagnostics<CR>')
    map.nmap(keymap.open_hover_doc,   ':Lspsaga hover_doc<CR>')
    map.nmap(keymap.goto_ref,         ':Lspsaga finder<CR>')
end

--- Setup cmp mappings
function M.setup_cmp(cmp)
    local maps =
    {
        [keymap.cmp_prev]            = cmp.mapping(function() cmp.select_prev_item() end),
        [keymap.cmp_next]            = cmp.mapping(function() cmp.select_next_item() end),
        [keymap.cmp_close]           = cmp.mapping.abort(),
        [keymap.cmp_open]            = cmp.mapping.complete(),
        [keymap.cmp_accept]          = cmp.mapping.confirm({ select = true }),
        ["<Tab>"]                    = cmp.mapping.confirm({ select = true }),
    }
    if keymap.cmp_accept == keymap.cmp_open then
        maps[keymap.cmp_accept] = function()
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                cmp.complete()
            end
        end
    end
    return maps
end

--- Setup dap mappings
function M.setup_dap(dap)
    map.nmap(keymap.dap_breakpoint,       function() dap.toggle_breakpoint() end)
    map.nmap(keymap.dap_continue,         function() dap.continue() end)
    map.nmap(keymap.dap_stepinto,         function() dap.step_into() end)
    map.nmap(keymap.dap_stepover,         function() dap.step_over() end)
    map.nmap(keymap.dap_stepout,          function() dap.step_out() end)
end

return M
