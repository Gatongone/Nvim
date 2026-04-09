--- @class M Wrokspace environment
--- @field cli_nf string Command line string of creating new file.
--- @field cli_nd string Command line string of creating new directory
--- @field cli_cpf string Command line string of copying file
--- @field cli_cpd string Command line string of copying directory
--- @field cli_rmf string Command line string of removing file
--- @field cli_rmd string Command line string of removing directory
--- @field cli_mv string Command line string of moving item
--- @field cli_ls string Command line string of listing files of current directory
--- @field cli_es string Command line string of escape character
--- @field cli_sp string Command line string of command separator character
--- @field cli_try function Hiding command line output error message
--- @field home string Command line string of home path
--- @field root string Command line string of root path
--- @field shell string Current shell
--- @field os string Current operation system
--- @field get_line_ending function Get current file line ending type
--- @field get_proj_root function Get project root directory
local M = { }

local shell = vim.fn.fnamemodify(vim.o.shell:lower(), ':t'):gsub('%.exe$', '')

if shell:match('pwsh') then
    M.cli_nf  = "New-Item -Path"
    M.cli_nd  = "New-Item -ItemType Directory"
    M.cli_cpf = "Copy-Item"
    M.cli_cpd = "Copy-Item -Recurse"
    M.cli_rmf = "Remove-Item"
    M.cli_rmd = "Remove-Item -Recurse"
    M.cli_mv  = "Move-Item"
    M.cli_ls  = "Get-ChildItem"
    M.cli_es  = "`"
    M.cli_sp  = ";"
    M.dir_sp  = "\\"
    M.home    = "~"
    M.root    = "\\"
    M.cli_try  = function(msg)
        return "(("..msg..")2> $null)"
    end
elseif shell:match('cmd') then
    M.cli_nf  = "echo.>"
    M.cli_nd  = "mkdir"
    M.cli_cpf = "copy"
    M.cli_cpd = "xcopy /e /i"
    M.cli_rmf = "del"
    M.cli_rmd = "rmdir /s /q"
    M.cli_mv  = "move"
    M.cli_ls  = "dir"
    M.cli_es  = "^"
    M.cli_sp  = "&&"
    M.dir_sp  = "\\"
    M.home    = "%USERPROFILE%"
    M.root    = "\\"
    M.cli_try  = function(msg)
        return "(("..msg..")2>nul)"
    end
else
    M.cli_nf  = "touch"
    M.cli_nd  = "mkdir"
    M.cli_cpf = "cp"
    M.cli_cpd = "cp -r"
    M.cli_rmf = "rm"
    M.cli_rmd = "rm -rf"
    M.cli_mv  = "mv"
    M.cli_ls  = "ls"
    M.cli_es  = "\\"
    M.cli_sp  = ";"
    M.dir_sp  = "/"
    M.home    = "~"
    M.root    = "/"
    M.cli_try  = function(msg)
        return "(("..msg..")2> /dev/null)"
    end
end

M.shell = shell
if vim.uv.os_uname then
    M.os = vim.uv.os_uname().sysname
elseif vim.loop.os_uname then
    M.os = vim.loop.os_uname().sysname
end

M.get_line_ending = function()
    local line_endings = "LF"
    if vim.bo.fileformat == "dos" then
        line_endings = "CRLF"
    elseif vim.bo.fileformat == "mac" then
        line_endings = "CR"
    end

    return line_endings
end

M.get_proj_root = function()
    -- Neovim workspace
    if vim.fs.root then -- Neovim 0.10+
        local root = vim.fs.root(0, {".nvim"})
        if root then
            return root
        end
    else -- Old version
        local root = vim.fn.finddir(".nvim", ".;")
        if root ~= "" then
            return vim.fn.fnamemodify(root, ":h")
        end
    end

    -- Project folders
    local workspace_folders = vim.lsp.buf.list_workspace_folders()
    if workspace_folders and #workspace_folders > 0 then
        return workspace_folders[1]
    end

    -- LSP root dir
    local clients = {}
    if vim.lsp.get_clients then
        clients = vim.lsp.get_clients({ bufnr = 0 }) -- Neovim 0.10+
    elseif vim.lsp.get_active_clients then
        clients = vim.lsp.get_active_clients({ bufnr = 0 }) -- Old version
    end
    for _, client in ipairs(clients) do
        if client.config and client.config.root_dir then
            return client.config.root_dir
        end
    end

    -- Git folder
    if vim.fs.root then
        local root = vim.fs.root(0, {".git"})
        if root then
            return root
        end
    else
        local root = vim.fn.finddir(".git", ".;")
        if root ~= "" then
            return vim.fn.fnamemodify(root, ":h")
        end
    end

    -- Current folder
    return vim.fn.getcwd()
end

return M
