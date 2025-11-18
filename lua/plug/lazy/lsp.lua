local lsp_keymap       = require("core.keymap.lsp")
local icon             = require("theme.icon")
local on_client_attach = function(_, bufnr)
    local bmap = function(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    lsp_keymap.setup_lsp(bmap)
end

-- Collect servers and configs
local langs            = require("plug.langs")
local servers          = {}
local lsps             = {}
local daps             = {}

for lang, server in pairs(langs) do
    if server == nil then
        goto continue
    end
    local status, config = pcall(require, "plug.langs." .. lang)
    if status then
        if config.dap then
            daps[lang] = config.dap
        end
        if config.lsp then
            config.lsp.on_attach = on_client_attach
            lsps[server] = config.lsp
        end
    else
        lsps[server] = { on_attach = on_client_attach }
    end
    table.insert(servers, server)
    ::continue::
end

-- Reset window style
local function on_mason_ui_open()
    local win          = vim.api.nvim_get_current_win()
    local opts         = vim.api.nvim_win_get_config(win)
    local default_opts = nvim.ext.win.get_win_config({ title = "LSP Configs" })
    opts.title         = default_opts.title
    opts.title_pos     = default_opts.title_pos
    opts.border        = default_opts.border
    opts.width         = default_opts.width
    opts.height        = default_opts.height
    opts.col           = default_opts.col
    opts.row           = default_opts.row
    vim.api.nvim_win_set_config(win, opts)
end
vim.api.nvim_create_autocmd("FileType", { pattern = "mason", callback = on_mason_ui_open })

local function debug()
    require("dap").continue()
end

vim.api.nvim_create_user_command('Debug', debug, { })

-- Setup dap icon/hl
local dap_breakpoint =
{
    breakpoint =
    {
        text   = icon.debug.breakpoint,
        texthl = "DapBreakpoint",
        numhl  = "DapBreakpoint",
    },
    condition =
    {
        text   = icon.debug.continue,
        texthl = 'DapBreakpointCondition',
        numhl  = 'DapBreakpointCondition',
    },
    rejected =
    {
        text   = icon.debug.rejected,
        texthl = "DapBreakpointRejected",
        numhl  = "DapBreakpointRejected",
    },
    logpoint =
    {
        text   = icon.debug.info,
        texthl = 'DapLogPoint',
        numhl  = 'DapLogPoint',
    },
    stopped =
    {
        text   = icon.debug.stopped,
        texthl = 'DapStopped',
        numhl  = 'DapStopped',
        linehl = 'DapStoppedLine'
    },
}

return
{
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            local confs    = require("mason-lspconfig")

            for server, config in pairs(lsps) do
                vim.lsp.config(server, config)
            end
            require 'nvim-treesitter.configs'.setup(
            {
                highlight =
                {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
            require("mason").setup(
            {
                ui =
                {
                    keymaps =
                    {
                        install_package   = "o",
                        uninstall_package = "d"
                    }
                }
            })
            require("lspsaga").setup(
            {
                lightbulb = { enable = false },
                finder =
                {
                    max_height = 0.6,
                    keys =
                    { toggle_or_open = '<CR>', split = 's' },
                }
            })
            confs.setup({ ensure_installed = servers })
            vim.diagnostic.config { float = { border = "rounded" } }
        end,
        dependencies =
        {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            "nvimdev/lspsaga.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        }
    },
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            cmp.setup(
                {
                    snippet =
                    {
                        expand = function(args) vim.fn["vsnip#anonymous"](args.body) end
                    },
                    sources = cmp.config.sources(
                        {
                            { name = 'nvim_lsp' },
                            { name = 'vsnip' },
                        },
                        {
                            { name = 'buffer' },
                            { name = 'path' }
                        }
                    ),
                    mapping = cmp.mapping.preset.insert(lsp_keymap.setup_cmp(cmp)),
                    window  =
                    {
                        completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                })
        end,
        dependencies =
        {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/vim-vsnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind-nvim',
        }
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap   = require("dap")
            local dapui = require("dapui")
            local mason = require("mason-nvim-dap")
            vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
            vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.condition)
            vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)
            vim.fn.sign_define('DapLogPoint', dap_breakpoint.logpoint)
            vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)

            mason.setup({ ensure_installed = { "cppdbg" } })
            dapui.setup({})
            dap.adapters.gdb =
            {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
            }
            for lang, dap_config in pairs(daps) do
                dap.configurations[lang] = dap_config
            end

            lsp_keymap.setup_dap(dap)
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close({})
                dap.repl.close()
            end
            dap.listeners.before.event_exited["dapui_config"]     = function()
                dapui.close({})
                dap.repl.close()
            end
        end,
        dependencies =
        {
            "jay-babu/mason-nvim-dap.nvim",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
        }
    },
}
