local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.filetype.add(
{
    extension =
    {
        v = function(path, bufnr)
            if vim.fs.root(path, { 'v.mod' }) then
                return 'vlang'
            end
            if vim.fs.root(path, { '_CoqProject' }) then
                return 'coq'
            end
            -- Fallback to content check.
            local first_lines = vim.api.nvim_buf_get_lines(bufnr, 0, 5, false)
            for _, line in ipairs(first_lines) do
                if line:match('^%s*Require') or line:match('^%s*Definition')
                   or line:match('^%s*Theorem') or line:match('^%s*Lemma') then
                    return 'coq'
                end
            end
            return 'vlang'
        end,
        mbtx = "moonbit",
        mbt = "moonbit"
    },
    filename =
    {
        ['moon.pkg'] = 'moonbit',
    },
})
return
{
    vls =
    {
        cmd = { 'vls' },
        filetypes = { 'vlang' },
        root_markers = { 'v.mod', '.git' },
        single_file_support = true,
        settings =
        {
            v = { fmt = true },
        }
    },
    pylsp =
    {
        cmd = { 'pylsp' },
        filetypes = { 'python' },
        root_markers = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt', "Pipfile" },
        single_file_support = true,
        init_options =
        {
            configurationSources = { 'pycodestyle' },
            plugins =
            {
                pycodestyle = { enabled = true, maxLineLength = 88 },
                pyflakes = { enabled = true },
                mccabe = { enabled = true, threshold = 15 }
            }
        },
        capabilities = capabilities
    },
    lua_ls =
    {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml', '.git' },
        single_file_support = true,
        settings =
        {
            Lua =
            {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { 'vim' } },
                workspace =
                {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME }
                }
            }
        },
        capabilities = capabilities
    },
    clangd =
    {
        cmd =
        {
            'clangd',
            '--background-index',
            '--clang-tidy',
            '-j=4'
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        single_file_support = true,
        root_markers =
        {
            '.git',
            'compile_commands.json',
            '.clangd',
            'build/compile_commands.json',
            "*.sln",
            "*.slnx",
            "CMakeLists.txt"
        },
        init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
        },
        capabilities = capabilities
    },
    gopls =
    {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.mod', 'go.work', '.git' },
        capabilities = capabilities
    },
    csharp_ls =
    {
        cmd = { 'csharp-ls' },
        filetypes = { 'cs' },
        single_file_support = true,
        root_markers =
        {
            '*.slnx',
            '*.sln',
            '*.csproj',
            '.git',
        }
    },
    fsautocomplete =
    {
        cmd = { 'fsautocomplete', '--background-service-enabled' },
        filetypes = { 'fsharp', 'fs', 'fsx', 'fsi' },
        root_markers =
        {
            '*.sln',
            '*.slnx',
            '*.fsproj',
            '*.fsprojx',
            '.git',
            'paket.dependencies'
        }
    },
    ocamllsp =
    {
        cmd = { 'ocamllsp' },
        filetypes = { 'ocaml', 'ocamlinterface', 'menhir', 'dune', 'reason' },
        root_markers = { 'dune-project', '*.opam', 'esy.json', '.git', 'dune-workspace' },
        single_file_support = true,
        settings =
        {
            ocamllsp =
            {
                extendedHover = true,
                codelens = true,
                duneDiagnostics = true,
                syntaxDocumentation = true,
                merlinJumpCodeActions = true
            },
            inlayHints =
            {
                hintLetBindings = true,
                hintPatternVariables = true,
            }
        }
    },
    scheme_ls =
    {
        cmd = { '/home/gatongone/.lsp/guile-language-server/wrapper' }, -- path/to/your/scheme_lsp
        filetypes = { 'scheme', 'scm', 'ss', 'sls', 'scheme.guile' },
        root_markers = { '.git', '.nvim' },
        single_file_support = true,

    },
    ts_ls =
    {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' },
        single_file_support = true,
        init_options =
        {
            hostInfo = 'neovim'
        },
        settings =
        {
            typescript =
            {
                inlayHints =
                {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
            javascript =
            {
                inlayHints =
                {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            }
        },
        capabilities = capabilities
    },
    hls =
    {
        cmd = { 'haskell-language-server-wrapper', '--lsp' },
        filetypes = { 'haskell', 'lhaskell', 'cabal' },
        root_markers = { '.git', '*.cabal', 'stack.yaml', 'cabal.project', 'hie.yaml' },
        single_file_support = true,
        settings =
        {
            haskell =
            {
                formattingProvider = "ormolu",
                hlintOn = true,
                diagnosticsOnChange = true,
                completionSnippetsOn = true,
                formatOnImportOn = true,
                maxNumberOfProblems = 100,
                plugin =
                {
                    hlint = { diagnosticsOn = true },
                    ormolu =
                    {
                        args = { "--ghc-opt", "-XTypeApplications" }
                    },
                    importLens =
                    {
                        enableLens = true,
                        codeLensOn = true
                    }
                }
            }
        }
    },
    rust_analyzer =
    {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml' },
          settings =
          {
            ['rust-analyzer'] =
            {
                checkOnSave = { command = "clippy" },
                cargo = { features = "all" }
            },
        },
        capabilities = capabilities
    },
    ols =
    {
        cmd = { 'ols' },
        filetypes = { 'odin' },
        root_markers = { 'ols.json', '.git' },
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        single_file_support = true,
        init_options =
        {
            enable_format = true,
            enable_hover = true,
            enable_semantic_tokens = true,
            enable_document_symbols = true,
            enable_snippets = true,
            enable_inlay_hints = true
        }
    },
    zls =
    {
        cmd = { 'zls' },
        filetypes = { 'zig' },
        single_file_support = true,
        root_markers = { 'build.zig', '.git' },
        capabilities = capabilities
    },
    moonbit =
    {
        cmd = { 'moon', 'lsp' },
        filetypes = { 'moonbit' },
        root_markers = { 'moon.mod.json', 'moon.pkg.json', '.git' },
        single_file_support = true,
        capabilities = capabilities
    },
    nixd =
    {
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        root_markers = { '.git', 'flake.nix', 'shell.nix', 'default.nix' },
        single_file_support = true,
        settings =
        {
            nixd =
            {
                formatting =
                {
                    command = { 'nixfmt' }
                },
                nixpkgs =
                {
                    expr = "import <nixpkgs> { }"
                },
                options =
                {
                    nixos =
                    {
                        expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.".. vim.uv.os_gethostname() ..".options"
                    }
                }
            }
        }
    },
    intelephense =
    {
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        root_markers = { 'composer.json', '.git' },
        settings =
        {
            intelephense =
            {
                files = { maxSize = 5000000 },
                completion = { triggerParameterHints = true }
            }
        },
        capabilities = capabilities
    },
    solargraph =
    {
        cmd = { 'solargraph', 'stdio' },
        filetypes = { 'ruby' },
        root_markers = { '.git', 'Gemfile', 'Rakefile' },
        settings = {
            solargraph = {
            diagnostics = true,
            completion = true,
            formatting = true,
            hover = true,
            rename = true,
            folding = true,
            },
        },
        capabilities = capabilities
    },
    lean_ls =
    {
        cmd = { 'leanls' },
        filetypes = { 'lean' },
        root_markers = { 'lean-toolchain', 'lakefile.lean', 'lakefile.toml' },
        init_options =
        {
            editDelay = 0,
            hasWidgets = true,
        },
        capabilities = capabilities
    },
    coq_lsp =
    {
        cmd = { 'coq-lsp' },
        filetypes = { 'coq', 'v' },
        root_markers = { '_CoqProject', '.git', 'Makefile' },
        init_options =
        {
            show_notices_as_diagnostics = true,
        },
        capabilities = capabilities
    },
    bashls =
    {
        cmd = { 'bash-language-server', 'start' },
        single_file_support = true,
        filetypes = { 'bash', 'sh' }
    },
    marksman =
    {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown' },
        root_markers = { '.git', '.marksman.toml', 'README.md' },
        single_file_support = true,
        capabilities = capabilities
    },
    vscode_html_ls =
    {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html' },
        root_markers = { '.git', 'package.json', 'index.html' },
        single_file_support = true,
        settings =
        {
            html =
            {
                autoClosingTags = true,
                autoCreateQuotes = true,
                suggest =
                {
                    html5 = true,
                }
            }
        }
    }
}
