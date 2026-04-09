local color = require("theme.scheme.."..nvim.setting.appearance.theme)
local util = require("theme.util")
local wininfo = { winnr = -1, bufnr = -1 }
local win = nvim.ext.win
local keymap = require("core.keymap.fzf")
local exclude_dirs =
{
    ".git",
    ".hg",
    ".svn",
    ".sublime-project",
    ".sublime-workspace",
    ".gradle",
    ".yarn",
    ".mvn",
    ".npm",
    ".yarn",
    ".vs",
    ".vscode",
    ".idea",
}

-- FZF style
local style =
[[
    --pointer ▶ \
    --input-label ' Input ' --header-label ' Encoding | Type ' --preview-label ' Preview ' \
    --style full \
    --bind 'result:transform-list-label:
    if \[\[ -z $FZF_QUERY \]\]; then
      echo " $FZF_MATCH_COUNT items "
    else
      echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "
    fi
    ' \
    --bind 'focus:+transform-header:file --brief {} || echo "No file selected"' \
]]
style = style.." --color 'prompt:"..util.lighten(color.base0C, 0.5).."' \\\n"
style = style.." --color 'pointer:"..color.base0B.."' \\\n"
style = style.." --color 'preview-border:"..color.base08..",preview-label:"..util.lighten(color.base08, 0.5).."' \\\n"
style = style.." --color 'list-border:"..color.base0B..",list-label:"..util.lighten(color.base0B, 0.5).."' \\\n"
style = style.." --color 'input-border:"..color.base0C..",input-label:"..util.lighten(color.base0C, 0.5).."' \\\n"
style = style.." --color 'header-border:"..color.base0D..",header-label:"..util.lighten(color.base0D, 0.5).."' \\\n"

-- Find command arguments
local find_exclude = ""
local fd_exclude = ""
for _, dir in pairs(exclude_dirs) do
    find_exclude = find_exclude.." -not -path '*/"..dir.."/*'"
    fd_exclude = fd_exclude.." -E "..dir
end

-- Set Previewer
local previewer
if vim.fn.executable("bat") == 1 then
    previewer = "--preview 'bat --color=always --style=numbers {}'"
elseif vim.fn.executable("cat") == 1 then
    previewer = "--preview 'cat {}'"
else
    previewer = "--preview 'fzf-preview.sh {}'"
end

--- FZF exit callback
local function on_fzf_exit(exit_code)
    if  exit_code == 0 or not vim.api.nvim_win_is_valid(wininfo.winnr) then
        vim.api.nvim_win_close(wininfo.winnr, true)
        return
    end
    local lines = vim.api.nvim_buf_get_lines(wininfo.bufnr, 0, -1, false)
    if #lines >= 1 and lines[1] ~= "" and vim.fn.filereadable(lines[1]) then
        vim.cmd("tabnew " .. vim.fn.fnameescape(lines[1]))
    end
    vim.api.nvim_win_close(wininfo.winnr, true)
    wininfo.winnr = -1
end

--- Open FZF as float window
local function open_fzf()
    wininfo = win.create_win(true, {title = "Finder"})
    local workspace = nvim.env.get_proj_root()
    if workspace then
        if vim.fn.executable("fd") == 1 then
            vim.fn.jobstart("fd "..fd_exclude.. " . "..workspace.." | fzf "..previewer.."\\"..style..keymap, { term = true, on_exit = on_fzf_exit })
        else
            vim.fn.jobstart("find "..workspace.." -type f \\( " ..find_exclude.. " \\) | fzf "..previewer..style..keymap, { term = true, on_exit = on_fzf_exit })
        end
    else
        vim.fn.jobstart("fzf"..style..keymap, { term = true })
    end
    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Fzf", open_fzf, { })
