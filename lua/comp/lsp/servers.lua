local capabilities = vim.lsp.protocol.make_client_capabilities()
return
{
    vls =
    {
        cmd = { 'vls' },
        filetypes = { 'v' },
        root_markers = { 'v.mod', '.git' },
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
        cmd = { 'steel-language-server' },
        filetypes = { 'scheme', 'scm', 'ss', 'sls' },
        root_markers = { '.git' },
        single_file_support = true
    },
    ts_ls =
    {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { '.git', 'package.json', 'tsconfig.json', 'jsconfig.json' },
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
        root_markers = { 'build.zig', '.git' }
    },
    moonbit =
    {
        cmd = { 'moon', 'lsp' },
        filetypes = { 'moonbit' },
        root_markers = { 'moon.mod.json', 'moon.pkg.json', '.git' },
        capabilities = capabilities
    },
    nixd =
    {
        cmd = { 'nixd' },
        filetypes = { 'nix' },
        root_markers = { '.git', 'flake.nix', 'shell.nix', 'default.nix' },
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
                        expr = "(builtins.getFlake \"/path/to/your/flake\").nixosConfigurations.<hostname>.options"
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
