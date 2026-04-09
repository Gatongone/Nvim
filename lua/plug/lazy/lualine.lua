local succeed, scheme = pcall(require, "theme.scheme." .. require("config").setting.appearance.theme)
local icon            = require("theme.icon")
local filetype        = { "filetype", icon_only = true }
local theme           = "auto"

_G.get_line_ending    = function()
    local line_endings = "LF"
    if vim.bo.fileformat == "dos" then
        line_endings = "CRLF"
    elseif vim.bo.fileformat == "mac" then
        line_endings = "CR"
    end
    return line_endings
end

if succeed then
    --- @diagnostic disable-next-line: cast-local-type
    theme =
    {
        normal =
        {
            a = { bg = "None", fg = scheme.base05, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        insert =
        {
            a = { bg = "None", fg = scheme.base08, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        visual =
        {
            a = { bg = "None", fg = scheme.base0A, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        replace =
        {
            a = { bg = "None", fg = scheme.base0F, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        command =
        {
            a = { bg = "None", fg = scheme.base0B, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        inactive =
        {
            a = { bg = "None", fg = scheme.base0E, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
        terminal =
        {
            a = { bg = "None", fg = scheme.base0D, gui = "bold" },
            b = { bg = "None", fg = scheme.base05 },
            c = { bg = "None", fg = scheme.base05 },
        },
    }
end

local diagnostics =
{
    "diagnostics",
    sources           = { "nvim_diagnostic" },
    sections          = { "error", "warn", "info", "hint" },
    colored           = true,
    update_in_insert  = false,
    always_visible    = false,
    symbols           =
    {
        error = icon.diagnostics.error .. " ",
        hint  = icon.diagnostics.hint .. " ",
        info  = icon.diagnostics.info .. " ",
        warn  = icon.diagnostics.warning .. " ",
    },
    diagnostics_color =
    {
        error = { bg = "None", fg = scheme.base0E, gui = "bold" },
        warn  = { bg = "None", fg = scheme.base0A, gui = "bold" },
        hint  = { bg = "None", fg = scheme.base0D, gui = "bold" },
        info  = { bg = "None", fg = scheme.base08, gui = "bold" },
    },
}

local diff =
{
    "diff",
    colored        = true,
    always_visible = false,
    source         = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns == nil then
            return
        end
        return
        {
            added    = gitsigns.added,
            modified = gitsigns.changed,
            removed  = gitsigns.removed,
        }
    end,
    diff_color     =
    {
        added    = { bg = "None", fg = scheme.base0E, gui = "bold" },
        modified = { bg = "None", fg = scheme.base0A, gui = "bold" },
        removed  = { bg = "None", fg = scheme.base0D, gui = "bold" },
    },
    symbols        =
    {
        added    = icon.git.added .. " ",
        modified = icon.git.modified .. " ",
        removed  = icon.git.removed .. " ",
    },
}

local filename =
{
    'filename',
    file_status     = true,
    newfile_status  = false,
    path            = 0,
    shorting_target = 40,
    symbols         =
    {
        modified = '[+]',
        readonly = '[-]',
        unnamed  = '[*]',
        newfile  = '[#]',
    }
}

local buffers =
{
    'tabs',
    mode = 1,
    tabs_color =
    {
        active   = { bg = "None", fg = scheme.base05, gui = "bold" },
        inactive = { bg = "None", fg = scheme.base03 },
    },
    symbols =
    {
        modified = icon.kind.event
    },
}

local opts =
{
    options =
    {
        theme                = theme,
        always_show_tabline  = false,
        globalstatus         = true,
        section_separators   = "",
        component_separators = "",
        disabled_filetypes   = { statusline = { "dashboard", "lazy", "alpha" } },
    },
    sections =
    {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = { filename, "require('theme.icon').ui.lsp..' '..string.upper(vim.bo.fileencoding)", "require('theme.icon').kind.field..' '.._G.get_line_ending()" },
        lualine_x = { diff, diagnostics, filetype },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    tabline =
    {
        lualine_a = { buffers },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    }
}

return
{
    "nvim-lualine/lualine.nvim",
    config = function()
        vim.opt.showmode = false
        require("lualine").setup(opts)
    end
}
