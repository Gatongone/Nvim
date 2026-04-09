# Nvim

A personal Neovim configuration written entirely in Lua, built around a clean layered architecture and a fully centralized configuration entry point.

## Branches

This repository maintains two branches with an upstream/downstream relationship:

| Branch | Description |
|--------|-------------|
| [`pure`](https://github.com/Gatongone/Nvim/tree/pure) | Plugin-free. All features are implemented using native Neovim APIs only. |
| [`main`](https://github.com/Gatongone/Nvim/tree/main) | Downstream of `pure`. Adds a [lazy.nvim](https://github.com/folke/lazy.nvim) plugin layer on top without modifying any core files. |

## Requirements

- Neovim >= 0.11
- For the `main` branch: `git` (for lazy.nvim bootstrap)
- Optional external tools (configured in [`lua/config.lua`](lua/config.lua)):
  - File explorer: `yazi`, `ranger`, or `superfile` (falls back to `netrw`)
  - Fuzzy finder: `fzf` (or `telescope`)
  - Git TUI: `lazygit` or `gitui`

## Installation

```bash
# Clone to your Neovim config directory
git clone https://github.com/Gatongone/Nvim.git ~/.config/nvim

# Use the plugin-free branch
git checkout pure

# Or use the full-featured branch (requires lazy.nvim auto-bootstrap)
git checkout main
```

## Architecture

```txt
init.lua                  ← Entry point: loads config → util → core → comp [→ plug]
│
├── lua/config.lua        ← Single centralized user configuration (keymaps, settings, appearance)
│
├── lua/util/             ← Utility layer
│   ├── env.lua           ← Cross-platform shell environment abstraction (bash/cmd/pwsh)
│   └── ext.lua           ← Extended APIs: win / buf / tab / ui / table string extensions
│
├── lua/core/             ← Native Neovim setup
│   ├── setting/          ← Editor options (appearance, file encoding, indentation)
│   ├── cmd/              ← Custom user commands
│   └── keymap/           ← Keymap registration, driven by values from config.lua
│
├── lua/comp/             ← Feature components (all native, no plugin dependency)
│   ├── lsp/              ← Built-in LSP client setup and server configurations
│   ├── terminal/         ← Floating/split terminal integration
│   ├── finder/           ← File/text finder (fzf or native)
│   ├── explore/          ← File explorer integration (netrw / yazi / ranger / superfile)
│   ├── git/              ← Git TUI launcher (lazygit / gitui)
│   ├── autopairs/        ← Auto bracket pairing
│   ├── align/            ← Text alignment
│   ├── jmpword/          ← Word jump (EasyMotion-style, native)
│   ├── translation/      ← Translation engine (kd)
│   └── task/             ← Task runner (see Task System section below)
│
├── lua/theme/            ← Built-in theme engine (Base16-based, HSLuv color space)
│   └── scheme/           ← Color schemes: popnlock, gruvbox_dark, gruvbox_light, github, pico
│
└── lua/plug/             ← [main branch only] lazy.nvim plugin layer
    ├── init.lua          ← lazy.nvim bootstrap and UI customization
    ├── langs/            ← Per-language LSP/DAP configurations (lua, cpp, etc.) 
    └── lazy/             ← Plugin specs (one file per plugin or group)
```

## Configuration

**All user-facing options live in a single file: [`lua/config.lua`](lua/config.lua).**

### `config.keymap` — Key bindings

Defines the key for every action across all modes and components. Keymap files under `lua/core/keymap/` and component files read from this table — no keybinding is hardcoded elsewhere.

### `config.setting` — Editor settings

```lua
setting =
{
    editor =
    {
        translator = 'kd',       -- 'kd'
        explore    = 'netrw',    -- 'netrw' | 'yazi' | 'ranger' | 'superfile'
        finder     = 'fzf',      -- 'fzf'   | 'telescope'
        git        = 'lazygit',  -- 'lazygit' | 'gitui'
    },
    file =
    {
        encoding    = 'utf-8',
        tab_indent  = false,   -- true for tabs, false for spaces
        indent_num  = 4,
    },
    appearance =
    {
        theme                  = 'popnlock', -- see lua/theme/scheme/ for available schemes
        transparent_background = true,
        show_line_number       = true,
        relative_line_number   = false,
        highlight_line         = false,
    },
}
```

### `config.setting.appearance.theme` — Theming

Built-in schemes are located in [`lua/theme/scheme/`](lua/theme/scheme/). Each scheme file exports a Base16 color palette. To add a custom scheme, place a new file in that directory and set `theme` to its name (without `.lua`).

## Task System

The task system provides `:Run`, `:Build`, and `:Task` commands to execute language-specific workflows directly from within Neovim. All three commands accept an optional window type argument:

| Argument | Output window |
|----------|---------------|
| `f` (default) | Floating window |
| `h` | Horizontal split |
| `v` | Vertical split |

```
:Run [f|h|v]            ← Run the current file or project
:Build [f|h|v]          ← Build the current project
:Task <name> [f|h|v]    ← Run any named task type
```

When multiple run or build variants are available for the current filetype, a selection prompt appears automatically.

### Template tasks

Default run and build commands for each language are defined in [`lua/comp/task/template.lua`](lua/comp/task/template.lua). The following languages have built-in templates:

| Language | Run | Build |
|----------|-----|-------|
| C | gcc, clang | CMake, MSBuild |
| C++ | g++, clang++ | CMake, MSBuild |
| C# / F# | dotnet run (Debug/Release/Script) | dotnet build |
| Go | go run | Debug, Release |
| Rust | rustc | cargo (Debug/Release) |
| Zig | zig run | Debug, ReleaseSafe, ReleaseFast, ReleaseSmall |
| Odin | Project, Script | None/Minimal/Size/Speed/Aggressive |
| Java | Gradle, Maven, Script | javac, Maven, Gradle |
| JavaScript / TypeScript | Node | npm, Webpack, Vite, Parcel |
| Python | python | PyInstaller |
| Ruby | ruby | Ocra, Ruby-Packer |
| Haskell | GHC, Stack, Cabal | Stack, Cabal |
| OCaml | dune, ocaml | Dune, OcamlBuild |
| Swift | Project, Script | Debug, Release |
| Kotlin | Gradle, Maven, Script | Maven, Gradle |
| Lua | luajit | — |
| V lang | Project, Script | Dev, Product, C, JavaScript |
| MoonBit | Project, Script | Debug, Release |
| Nix | Script, Project | Project, CurrentFile |
| Scheme | Guile, Racket, Chez, Gambit, Chicken, Gauche, Chibi, MIT | Guile, Racket, Chez, Gambit, Chicken, Gauche, Bigloo |
| Common Lisp | SBCL, CLISP, ECL, ROS | SBCL, CLISP, ECL |
| Coq | coqc, coqtop | Makefile, Dune |
| Agda | Agda, Agda-CLI | Executable, Html |
| Lean | Script, Project | Lake |
| Bash / Shell | bash | — |
| Markdown | glow, mdcat, slides, frogmouth, and more | — |
| HTML | w3m, lynx, elinks, links2, xdg-open | — |
| Batch / PowerShell | cmd, wine / powershell, pwsh | — |
| PHP | php | — |

### Project-local tasks

To override or extend the built-in templates for a specific project, create a `.nvim/tasks.lua` file at the project root:

```lua
-- <project-root>/.nvim/tasks.lua
return
{
    root  = "/path/to/project",   -- optional: override the project root used in commands
    tasks =
    {
        run =
        {
            { title = "MyRunner", cmd = "my-tool run $filepath" }
        },
        build =
        {
            { title = "MyBuilder", cmd = "my-tool build $projpath" }
        },
        -- Any custom task name is also valid, accessible via :Task <name>
        test =
        {
            { title = "MyTest", cmd = "my-tool test" }
        },
    }
}
```

The `cmd` string supports the following template variables:

| Variable | Value |
|----------|-------|
| `$filepath` | Full path to the current file |
| `$filename` | Current file name without extension |
| `$projpath` | Project root directory |
| `$projname` | Project root directory name |
| `$delete`   | Platform-appropriate delete command (`rm` / `del` / `Remove-Item`) |

Path separators and command separators are automatically normalized for the current platform (Linux/macOS/Windows cmd/PowerShell).

> Project-local tasks take priority over built-in templates. If `.nvim/tasks.lua` defines tasks for a given task name, the template for that name is ignored entirely.

## LSP Support

Server configurations are defined in [`lua/comp/lsp/servers.lua`](lua/comp/lsp/servers.lua). The following language servers are pre-configured:

| Language | Server |
|----------|--------|
| C / C++ | `clangd` |
| Rust | `rust-analyzer` |
| Zig | `zls` |
| Odin | `ols` |
| Go | `gopls` |
| Python | `pylsp` |
| Lua | `lua-language-server` |
| TypeScript / JavaScript | `ts_ls` |
| HTML | `vscode-html-language-server` |
| C# | `csharp-ls` |
| F# | `fsautocomplete` |
| Haskell | `hls` |
| OCaml | `ocamllsp` |
| Ruby | `solargraph` |
| PHP | `intelephense` |
| Nix | `nixd` |
| Bash | `bash-language-server` |
| Markdown | `marksman` |
| V lang | `vls` |
| MoonBit | `moon lsp` |
| Lean | `leanls` |
| Coq | `coq-lsp` |
| Scheme | `scheme-lsp` |

On the `main` branch, Mason is used to manage server installation. Active servers are declared in [`lua/plug/langs/init.lua`](lua/plug/langs/init.lua).

## Adding a Language (main branch)

1. Add an entry to [`lua/plug/langs/init.lua`](lua/plug/langs/init.lua):
   ```lua
   return {
       lua = "lua_ls",
       cpp = "clangd",
       go  = "gopls",   -- add your language here
   }
   ```
2. Optionally create `lua/plug/langs/<lang>.lua` to provide custom `lsp` or `dap` config:
   ```lua
   return {
       lsp = { ... },  -- merged into the server config
       dap = { ... },  -- registered as dap.configurations[lang]
   }
   ```
   If the file is absent, the server runs with default settings.

## Theme

Create a new file under [`lua/theme/scheme/`](lua/theme/scheme/) following the Base16 convention used by the existing schemes, then set `config.setting.appearance.theme` to the filename (without `.lua`) in [`lua/config.lua`](lua/config.lua).
