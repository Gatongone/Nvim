-- Refer to luisiacc/gruvbox-baby
local M              = {}
local util           = require("theme.util")
local none           = "NONE"
local default_config =
{
    background_color     = "medium",
    comment_style        = "italic",
    keyword_style        = {"bold","italic"},
    function_style       = "bold",
    string_style         = "nocombine",
    variable_style       = "NONE",
    highlights           = {},
    term_highlights      = {},
    color_overrides      = {},
    telescope_theme      = false,
    use_original_palette = false,
}

local function get_gitdiff_scheme(scheme)
    return
    {
        add    = scheme.base0B,
        change = scheme.base0D,
        delete = scheme.base0E,
        text   = scheme.base01,
    }
end

local function get_term_scheme(scheme)
    return
    {
        scheme.base00,
        scheme.base08,
        scheme.base09,
        scheme.base0A,
        scheme.base0B,
        scheme.base0C,
        scheme.base0D,
        scheme.base0E,
        scheme.base0F,
        scheme.base01,
        scheme.base02,
        scheme.base03,
        scheme.base04,
        scheme.base05,
        scheme.base06,
        scheme.base07,
    }
end

local function setup_scheme(theme_name, opts)
    local scheme = require("theme.scheme." .. theme_name)
    local diff   = get_gitdiff_scheme(scheme)
    local theme  = {}
    local style  = vim.tbl_extend("force", default_config, opts or {})

    theme.defer  = diff
    theme.term   = get_term_scheme(require("theme.scheme.gruvbox_dark"))
    theme.base   =
    {
        -- Editor
        NormalFloat                         = { fg = scheme.base05, bg = scheme.base01 },
        Normal                              = { fg = scheme.base05, bg = scheme.base00 },
        Comment                             = { fg = scheme.base03, style = style.comment_style },
        Constant                            = { fg = scheme.base0C },
        String                              = { fg = scheme.base0B, style = style.string_style },
        Character                           = { fg = scheme.base0A },
        Number                              = { fg = scheme.base09 },
        Float                               = { fg = scheme.base0A },
        Boolean                             = { fg = scheme.base09 },
        Identifier                          = { fg = scheme.base08, style = style.variable_style },
        Function                            = { fg = scheme.base0D },
        Statement                           = { fg = scheme.base0E },
        Conditional                         = { fg = scheme.base0E, style = style.keyword_style },
        Repeat                              = { fg = scheme.base0E },
        Label                               = { fg = scheme.base07 },
        Operator                            = { fg = scheme.base0C },
        Keyword                             = { fg = scheme.base0E, style = style.keyword_style },
        Exception                           = { fg = scheme.base0F },
        PreProc                             = { fg = scheme.base0A },
        Include                             = { fg = scheme.base0E },
        Define                              = { fg = scheme.base0F, style = "bold" },
        Title                               = { fg = scheme.base0D, style = "bold" },
        Macro                               = { fg = scheme.base0E },
        PreCondit                           = { fg = scheme.base0F },
        Type                                = { fg = scheme.base0A },
        StorageClass                        = { fg = scheme.base09 },
        Structure                           = { fg = scheme.base0A },
        Typedef                             = { fg = scheme.base0A },
        Special                             = { fg = scheme.base0F },
        SpecialComment                      = { fg = scheme.base03 },
        MoreMsg                             = { fg = scheme.base05 },
        Error                               = { fg = scheme.base0E, style = {"bold", "strikethrough"} },
        Todo                                = { fg = scheme.base0F, style = "bold" },
        CursorLineNr                        = { fg = scheme.base03, style = "bold" },
        debugPc                             = { bg = scheme.base0E },
        Conceal                             = { fg = scheme.base03 },
        Directory                           = { fg = scheme.base0F },

        WinBar                              = { bg = scheme.base01 },
        WinBarNC                            = { bg = scheme.base01 },
        TabLine                             = { bg = scheme.base01, fg = scheme.base03 },
        TabLineFill                         = { bg = scheme.base02 },
        TabLineSel                          = { fg = scheme.base05, bg = scheme.base00 },

        DiffAdd                             = { bg = diff.add },
        DiffChange                          = { bg = diff.change },
        DiffDelete                          = { bg = diff.delete },
        DiffText                            = { bg = diff.text },

        ErrorMsg                            = { fg = scheme.base0E },
        VertSplit                           = { fg = scheme.base04 },
        Folded                              = { fg = scheme.base03 },
        IncSearch                           = { bg = scheme.base02 },
        LineNr                              = { fg = scheme.base03 },
        MatchParen                          = { bg = diff.text, style = "underline" },
        NonText                             = { fg = scheme.base03 },
        Pmenu                               = { fg = scheme.base05, bg = scheme.base04 },
        PmenuSel                            = { fg = scheme.base02, bg = scheme.base09 },
        Question                            = { fg = scheme.base0F },
        QuickFixLine                        = { fg = scheme.base02, bg = scheme.base0A },
        Search                              = { bg = scheme.base02 },
        SpecialKey                          = { fg = scheme.base03 },
        SpellBad                            = { fg = scheme.base0E, style = "underline" },
        SpellCap                            = { fg = scheme.base0A },
        SpellLocal                          = { fg = scheme.base0A },
        SpellRare                           = { fg = scheme.base0A },
        StatusLine                          = { fg = scheme.base05, bg = scheme.base01 },
        StatusLineNC                        = { fg = scheme.base03 },
        StatusLineTerm                      = { fg = scheme.base05 },
        StatusLineTermNC                    = { fg = scheme.base03 },
        Terminal                            = { fg = scheme.base05, bg = scheme.base02 },
        VisualNOS                           = { fg = scheme.base03 },
        WarningMsg                          = { fg = scheme.base0A },
        WildMenu                            = { fg = scheme.base02, bg = scheme.base09 },
        EndOfBuffer                         = { fg = scheme.base02 },
        JumpWordLabel                       = { fg = scheme.base0B, style = "bold" },
        JumpWordMatch                       = { fg = scheme.base08 },

        -- Dap
        DapBreakpoint                       = { fg = scheme.base0E },
        DapBreakpointRejected               = { fg = scheme.base0E },
        DapBreakpointCondition              = { fg = scheme.base0D },
        DapStopped                          = { fg = scheme.base0D },
        DapStoppedLine                      = { bg = util.darken(scheme.base0D, 0.55) },
        DapLogPoint                         = { fg = scheme.base08, },
        DapUIType                           = { fg = scheme.base0A, style = "bold" },
        DapUIVariable                       = { fg = scheme.base0F },
        DapUIModifiedValue                  = { fg = scheme.base0F },
        DapUIScope                          = { fg = scheme.base08, style = "bold" },
        DapUIDecoration                     = { fg = scheme.base05 },
        DapUIThread                         = { fg = scheme.base0A },
        DapUIStoppedThread                  = { fg = scheme.base0D, style = "bold" },
        DapUIFrameName                      = { fg = scheme.base0F, style = "bold" },
        DapUISource                         = { fg = scheme.base0D },
        DapUILineNumber                     = { fg = scheme.base0C },
        DapUIFloatBorder                    = { fg = scheme.base05 },
        DapUIWatchesHeader                  = { fg = scheme.base0C },
        DapUIWatchesEmpty                   = { fg = scheme.base03 },
        DapUIWatchesValue                   = { fg = scheme.base05 },
        DapUIWatchesError                   = { fg = scheme.base0E },
        DapUIWatchesFrame                   = { fg = scheme.base0C },
        DapUIBreakpointsPath                = { fg = scheme.base0B, style = "bold" },
        DapUIBreakpointsInfo                = { fg = scheme.base08 },
        DapUIBreakpointsCurrentLine         = { fg = scheme.base09 },
        DapUIStop                           = { fg = scheme.base0E },
        DapUIPlayPause                      = { fg = scheme.base0D },
        DapUIRestart                        = { fg = scheme.base0D },
        DapUIStepOver                       = { fg = scheme.base08 },
        DapUIStepInto                       = { fg = scheme.base08 },
        DapUIStepBack                       = { fg = scheme.base08 },
        DapUIStepOut                        = { fg = scheme.base08 },
        DapUIUnavailable                    = { fg = scheme.base03, bg = none },

        -- Noice
        NoiceCmdlineIcon                    = { fg = scheme.base0B },
        NoiceCmdlinePopupBorder             = { fg = scheme.base0D },
        NoiceCompletionItemKindDefault      = { fg = scheme.base0C },
        DiagnosticSignWarn                  = { fg = scheme.base0A },
        DiagnosticSignInfo                  = { fg = scheme.base0F },
        DiagnosticVirtualTextWarn           = { fg = scheme.base0A },
        DiagnosticVirtualTextInfo           = { fg = scheme.base0B },
        DiagnosticVirtualTextError          = { fg = scheme.base0E },
        MsgArea                             = { fg = scheme.base0C },

        -- Mason
        MasonNormal                         = { fg = scheme.base05 },
        MasonHeader                         = { fg = scheme.base07, style = "bold" },
        MasonHeaderSecondary                = { fg = scheme.base07, style = "bold" },
        MasonHighlight                      = { fg = scheme.base08 },
        MasonHighlightBlock                 = { fg = scheme.base08, style = "bold" },
        MasonHighlightBlockBold             = { fg = scheme.base08, style = "bold" },
        MasonHighlightSecondary             = { fg = scheme.base09 },
        MasonHighlightBlockSecondary        = { fg = scheme.base09, style = "bold" },
        MasonHighlightBlockBoldSecondary    = { fg = scheme.base09, style = "bold" },
        MasonLink                           = { fg = scheme.base0B, style = "bold" },
        MasonMuted                          = { fg = scheme.base0C, style = "bold" },
        MasonMutedBlock                     = { fg = scheme.base06, style = "bold" },
        MasonMutedBlockBold                 = { fg = scheme.base03, style = "bold" },
        MasonError                          = { fg = scheme.base0E, style = "bold" },
        MasonWarning                        = { fg = scheme.base0A, style = "bold" },
        MasonHeading                        = { fg = scheme.base0B, style = "bold" },

        -- Lazy
        LazyH1                              = { fg = scheme.base08, style = "bold" },
        LazyButton                          = { fg = scheme.base07, style = "bold" },
        LazyButtonActive                    = { fg = scheme.base0B, style = "bold" },

        -- Netrw
        NetrwLink                           = { fg = scheme.base0B, style = "bold" },
        NetrwFile                           = { fg = scheme.base03, style = "bold" },
        NetrwDirectory                      = { fg = scheme.base0A, style = "bold" },
        NetrwCopied                         = { fg = scheme.base0B, style = "bold" },
        NetrwCut                            = { fg = scheme.base0C, style = "bold" },
        NetrwMarkFile                       = { fg = scheme.base0A, style = "bold" },

        -- Tree Sitter
        ["@boolean"]                        = { fg = scheme.base09 },
        ["@define"]                         = { fg = scheme.base0E },
        ["@keyword.directive"]              = { fg = scheme.base0E },
        ["@comment"]                        = { fg = scheme.base03, style = style.comment_style },
        ["@error"]                          = { fg = scheme.base0E, style = {"bold", "strikethrough"}  },
        ["@punctuation.delimiter"]          = { fg = scheme.base05 },
        ["@punctuation.bracket"]            = { fg = scheme.base05 },
        ["@punctuation.special"]            = { fg = scheme.base05 },
        ["@markup.list"]                    = { fg = scheme.base05 },
        ["@constant"]                       = { fg = scheme.base0C, style = "bold" },
        ["@definition.constant"]            = { fg = scheme.base0C, style = "bold" },
        ["@constant.builtin"]               = { fg = scheme.base0C },
        ["@string"]                         = { fg = scheme.base0B, style = style.string_style },
        ["@character"]                      = { fg = scheme.base0B },
        ["@number"]                         = { fg = scheme.base09 },
        ["@namespace"]                      = { fg = scheme.base0E, style = style.keyword_style },
        ["@module"]                         = { fg = scheme.base08 },
        ["@func.builtin"]                   = { fg = scheme.base0D },
        ["@function"]                       = { fg = scheme.base0D, style = style.function_style },
        ["@function.call"]                  = { fg = scheme.base0D, style = style.function_style },
        ["@function.builtin"]               = { fg = scheme.base0D, style = style.function_style },
        ["@func.macro"]                     = { fg = scheme.base0E, style = style.keyword_style  },
        ["@parameter"]                      = { fg = scheme.base09, style = "nocombine" },
        ["@variable.parameter"]             = { fg = scheme.base09, style = "nocombine" },
        ["@parameter.reference"]            = { fg = scheme.base03 },
        ["@method"]                         = { fg = scheme.base0A, style = style.function_style },
        ["@function.method"]                = { fg = scheme.base0A, style = style.function_style },
        ["@method.call"]                    = { fg = scheme.base0D, style = style.function_style },
        ["@function.method.call"]           = { fg = scheme.base0D, style = style.function_style },
        ["@field"]                          = { fg = scheme.base08 },
        ["@variable.member"]                = { fg = scheme.base08 },
        ["@property"]                       = { fg = scheme.base09 },
        ["@constructor"]                    = { fg = scheme.base0D, style = "nocombine" },
        ["@conditional"]                    = { fg = scheme.base0E, style.keyword_style },
        ["@keyword.conditional"]            = { fg = scheme.base0E, style = style.keyword_style },
        ["@repeat"]                         = { fg = scheme.base0E, style = style.keyword_style },
        ["@keyword.repeat"]                 = { fg = scheme.base0E, style = style.keyword_style },
        ["@label"]                          = { fg = scheme.base09 },
        ["@keyword"]                        = { fg = scheme.base0E, style = style.keyword_style },
        ["@keyword.return"]                 = { fg = scheme.base0E, style = style.keyword_style },
        ["@keyword.function"]               = { fg = scheme.base0E, style = style.keyword_style },
        ["@keyword.operator"]               = { fg = scheme.base0E },
        ["@operator"]                       = { fg = scheme.base0C },
        ["@exception"]                      = { fg = scheme.base0E },
        ["@keyword.exception"]              = { fg = scheme.base0E },
        ["@type"]                           = { fg = scheme.base0D },
        ["@type.builtin"]                   = { fg = scheme.base09 },
        ["@type.qualifier"]                 = { fg = scheme.base08 },
        ["@storageclass.lifetime"]          = { fg = scheme.base08 },
        ["@keyword.storage.lifetime"]       = { fg = scheme.base0E },
        ["@structure"]                      = { fg = scheme.base09 },
        ["@variable"]                       = { fg = scheme.base08, style = style.variable_style },
        ["@variable.builtin"]               = { fg = scheme.base09 },
        ["@text"]                           = { fg = scheme.base0A },
        ["@text.strong"]                    = { fg = scheme.base0A, style = "bold" },
        ["@text.emphasis"]                  = { fg = scheme.base0A, style = "italic" },
        ["@text.underline"]                 = { fg = scheme.base0A, style = "underline" },
        ["@text.strike"]                    = { fg = scheme.base03, style = "strikethrough" },
        ["@text.title"]                     = { fg = scheme.base0A },
        ["@text.literal"]                   = { fg = scheme.base0A },
        ["@markup"]                         = { fg = scheme.base0A },
        ["@markup.strong"]                  = { fg = scheme.base0A, style = "bold" },
        ["@markup.emphasis"]                = { fg = scheme.base0A, style = "italic" },
        ["@markup.underline"]               = { fg = scheme.base0A, style = "underline" },
        ["@markup.strike"]                  = { fg = scheme.base03, style = "strikethrough" },
        ["@markup.heading"]                 = { fg = scheme.base0A },
        ["@markup.raw"]                     = { fg = scheme.base0A },
        ["@uri"]                            = { fg = scheme.base0A },
        ["@tag"]                            = { fg = scheme.base0D },
        ["@tag.delimiter"]                  = { fg = scheme.base03 },
        ["@tag.attribute"]                  = { fg = scheme.base0A },

        ["@variable.python"]                = { fg = scheme.base05, style = "NONE" },
        ["@attribute.python"]               = { fg = scheme.base08, style = "bold" },
        ["@decorator"]                      = { fg = scheme.base08, style = "bold" },
        ["@variable.rust"]                  = { fg = scheme.base05, style = "NONE" },
        ["@conditional.javascript"]         = { fg = scheme.base0E },
        ["@keyword.conditional.javascript"] = { fg = scheme.base0E },
        ["@variable.javascript"]            = { fg = scheme.base08 },

        ["@lsp.type.class"]                 = { fg = scheme.base0A, style = "bold" },
        ["@lsp.type.decorator"]             = { fg = scheme.base08 },
        ["@lsp.type.enum"]                  = { fg = scheme.base0A, style = "bold" },
        ["@lsp.type.enumMember"]            = { fg = scheme.base0F },
        ["@lsp.type.function"]              = { fg = scheme.base0D, style = style.function_style },
        ["@lsp.type.interface"]             = { fg = scheme.base0A, style = "bold" },
        ["@lsp.type.macro"]                 = { fg = scheme.base0E },
        ["@lsp.type.method"]                = { fg = scheme.base0D, style = "bold" },
        ["@lsp.type.namespace"]             = { fg = scheme.base05 },
        ["@lsp.type.parameter"]             = { fg = scheme.base0F },
        ["@lsp.type.property"]              = { fg = scheme.base05 },
        ["@lsp.type.struct"]                = { fg = scheme.base0A, style = "bold" },
        ["@lsp.type.type"]                  = { fg = scheme.base0E },
        ["@lsp.type.typeParameter"]         = { fg = scheme.base0A, style = "bold" },
        ["@lsp.type.variable"]              = { fg = scheme.base08 },

        htmlArg                             = { fg = scheme.base0A },
        htmlBold                            = { fg = scheme.base0A, style = "bold" },
        htmlEndTag                          = { fg = scheme.base05 },
        htmlH1                              = { fg = scheme.base05 },
        htmlH2                              = { fg = scheme.base05 },
        htmlH3                              = { fg = scheme.base05 },
        htmlH4                              = { fg = scheme.base05 },
        htmlH5                              = { fg = scheme.base05 },
        htmlH6                              = { fg = scheme.base05 },
        htmlItalic                          = { fg = scheme.base0F, style = "italic" },
        htmlLink                            = { fg = scheme.base05, style = "underline" },
        htmlSpecialChar                     = { fg = scheme.base0A },
        htmlSpecialTagName                  = { fg = scheme.base09 },
        htmlTag                             = { fg = scheme.base03 },
        htmlTagN                            = { fg = scheme.base08 },
        htmlTagName                         = { fg = scheme.base08 },
        htmlTitle                           = { fg = scheme.base05 },

        markdownBlockquote                  = { fg = scheme.base03 },
        markdownBold                        = { fg = scheme.base0A, style = "bold" },
        markdownCode                        = { fg = scheme.base0A },
        markdownCodeBlock                   = { fg = scheme.base03 },
        markdownCodeDelimiter               = { fg = scheme.base03 },
        markdownH1                          = { fg = scheme.base05 },
        markdownH2                          = { fg = scheme.base05 },
        markdownH3                          = { fg = scheme.base05 },
        markdownH4                          = { fg = scheme.base05 },
        markdownH5                          = { fg = scheme.base05 },
        markdownH6                          = { fg = scheme.base05 },
        markdownHeadingDelimiter            = { fg = scheme.base08 },
        markdownHeadingRule                 = { fg = scheme.base03 },
        markdownId                          = { fg = scheme.base0F },
        markdownIdDeclaration               = { fg = scheme.base09 },
        markdownIdDelimiter                 = { fg = scheme.base0F },
        markdownItalic                      = { fg = scheme.base0F, style = "italic" },
        markdownLinkDelimiter               = { fg = scheme.base0F },
        markdownLinkText                    = { fg = scheme.base09 },
        markdownListMarker                  = { fg = scheme.base08 },
        markdownOrderedListMarker           = { fg = scheme.base08 },
        markdownRule                        = { fg = scheme.base03 },
        markdownUrl                         = { fg = scheme.base0B, style = "underline" },

        phpInclude                          = { fg = scheme.base0F },
        phpClass                            = { fg = scheme.base0A },
        phpClasses                          = { fg = scheme.base0A },
        phpFunction                         = { fg = scheme.base09 },
        phpType                             = { fg = scheme.base0F },
        phpKeyword                          = { fg = scheme.base0F },
        phpVarSelector                      = { fg = scheme.base05 },
        phpIdentifier                       = { fg = scheme.base05 },
        phpMethod                           = { fg = scheme.base09 },
        phpBoolean                          = { fg = scheme.base09 },
        phpParent                           = { fg = scheme.base05 },
        phpOperator                         = { fg = scheme.base0F },
        phpRegion                           = { fg = scheme.base0F },
        phpUseNamespaceSeparator            = { fg = scheme.base05 },
        phpClassNamespaceSeparator          = { fg = scheme.base05 },
        phpDocTags                          = { fg = scheme.base0F },
        phpDocParam                         = { fg = scheme.base0F },

        CocExplorerIndentLine               = { fg = scheme.base03 },
        CocExplorerBufferRoot               = { fg = scheme.base08 },
        CocExplorerFileRoot                 = { fg = scheme.base08 },
        CocExplorerBufferFullPath           = { fg = scheme.base03 },
        CocExplorerFileFullPath             = { fg = scheme.base03 },
        CocExplorerBufferReadonly           = { fg = scheme.base0F },
        CocExplorerBufferModified           = { fg = scheme.base0F },
        CocExplorerBufferNameVisible        = { fg = scheme.base08 },
        CocExplorerFileReadonly             = { fg = scheme.base0F },
        CocExplorerFileModified             = { fg = scheme.base0F },
        CocExplorerFileHidden               = { fg = scheme.base03 },
        CocExplorerHelpLine                 = { fg = scheme.base0F },
        CocHighlightText                    = { bg = scheme.base01 },

        EasyMotionTarget                    = { fg = scheme.base0E, style = "bold" },
        EasyMotionTarget2First              = { fg = scheme.base0E, style = "bold" },
        EasyMotionTarget2Second             = { fg = scheme.base0E, style = "bold" },

        StartifyNumber                      = { fg = scheme.base05 },
        StartifySelect                      = { fg = scheme.base09 },
        StartifyBracket                     = { fg = scheme.base09 },
        StartifySpecial                     = { fg = scheme.base08 },
        StartifyVar                         = { fg = scheme.base09 },
        StartifyPath                        = { fg = scheme.base0A },
        StartifyFile                        = { fg = scheme.base05 },
        StartifySlash                       = { fg = scheme.base05 },
        StartifyHeader                      = { fg = scheme.base03 },
        StartifySection                     = { fg = scheme.base0A },
        StartifyFooter                      = { fg = scheme.base0A },

        WhichKey                            = { fg = scheme.base0F },
        WhichKeySeperator                   = { fg = scheme.base0A },
        WhichKeyGroup                       = { fg = scheme.base08 },
        WhichKeyDesc                        = { fg = scheme.base0F },

        diffAdded                           = { fg = scheme.base0F },
        diffRemoved                         = { fg = scheme.base0E },
        diffFileId                          = { fg = scheme.base0F },
        diffFile                            = { fg = scheme.base03 },
        diffNewFile                         = { fg = scheme.base0A },
        diffOldFile                         = { fg = scheme.base08 },

        SignifySignAdd                      = { fg = scheme.base0A },
        SignifySignChange                   = { fg = scheme.base0A },
        SignifySignDelete                   = { fg = scheme.base08 },
        GitGutterAdd                        = { fg = scheme.base0F },
        GitGutterChange                     = { fg = scheme.base0A },
        GitGutterDelete                     = { fg = scheme.base0E },
        debugBreakpoint                     = { fg = scheme.base0E, style = "reverse" },

        VimwikiHeader1                      = { fg = scheme.base08, style = "bold" },
        VimwikiHeader2                      = { fg = scheme.base0B, style = "bold" },
        VimwikiHeader3                      = { fg = scheme.base03, style = "bold" },
        VimwikiHeader4                      = { fg = scheme.base0D, style = "bold" },
        VimwikiHeader5                      = { fg = scheme.base0E, style = "bold" },
        VimwikiHeader6                      = { fg = scheme.base0C, style = "bold" },
        VimwikiLink                         = { fg = scheme.base0F },
        VimwikiHeaderChar                   = { fg = scheme.base03 },
        VimwikiHR                           = { fg = scheme.base0A },
        VimwikiList                         = { fg = scheme.base08 },
        VimwikiTag                          = { fg = scheme.base08 },
        VimwikiMarkers                      = { fg = scheme.base03 },

        ColorColumn                         = { bg = scheme.base02 },
        SignColumn                          = { bg = scheme.none   },
        CursorColumn                        = { bg = scheme.base04 },
        CursorLine                          = { bg = scheme.base04 },
        FoldColumn                          = { fg = scheme.none },
        PmenuSbar                           = { bg = scheme.base03 },
        PmenuThumb                          = { bg = scheme.base05 },
        EasyMotionShade                     = { fg = none },
        Visual                              = { bg = scheme.base02 },
        MultiCursor                         = { bg = scheme.base03 },
        Cursor                              = { bg = scheme.base07, fg = none },

        -- Mix
        GitSignsCurrentLineBlame            = { fg = scheme.base03 },
        Underlined                          = { fg = scheme.base0E, style = "underline" },
        ["@variable.cpp"]                   = { fg = scheme.base05 },

        -- Nvim Tree
        NvimTreeNormal                      = { fg = scheme.base05, bg = scheme.base00 },
        NvimTreeNormalNC                    = { fg = scheme.base05, bg = scheme.base00 },
        NvimTreeFolderIcon                  = { fg = scheme.base0A },
        NvimTreeRootFolder                  = { fg = scheme.base0F },
        NvimTreeExecFile                    = { fg = scheme.base08, style = "NONE" },

        NvimTreeGitDirty                    = { fg = scheme.base0E },
        NvimTreeGitStaged                   = { fg = scheme.base05 },
        NvimTreeGitMerge                    = { fg = scheme.base0A },
        NvimTreeGitRenamed                  = { fg = scheme.base0A },
        NvimTreeGitNew                      = { fg = scheme.base0B },
        NvimTreeGitDeleted                  = { fg = scheme.base0E },

        -- NeoTree
        NeoTreeNormal                       = { fg = scheme.base05, bg = scheme.base00 },
        NeoTreeNormalNC                     = { fg = scheme.base05, bg = scheme.base00 },
        NeoTreeVertSplit                    = { fg = scheme.base02, bg = scheme.base02 },
        NeoTreeWinSeparator                 = { fg = scheme.base02, bg = scheme.base02 },
        NeoTreeDirectoryIcon                = { fg = scheme.base0A },
        NeoTreeRootName                     = { fg = scheme.base0F },
        NeoTreeExecFile                     = { fg = scheme.base08, style = "NONE" },

        NeoTreeGitUnstaged                  = { fg = scheme.base0E },
        NeoTreeGitStaged                    = { fg = scheme.base05 },
        NeoTreeGitModified                  = { fg = scheme.base0A },
        NeoTreeGitUnstracked                = { fg = scheme.base0B },
        NeoTreeGitDeleted                   = { fg = scheme.base0E },

        -- Hop
        HopNextKey                          = { fg = scheme.base0A, bg = scheme.base01, style = "bold" },
        HopNextKey1                         = { fg = scheme.base0A, bg = scheme.base01, style = "bold" },
        HopNextKey2                         = { fg = scheme.base07, bg = scheme.base01 },

        -- indent blankline
        IndentBlanklineChar                 = { fg = "#414141" },
        IndentBlanklineSpaceChar            = { fg = "#414141" },
        IndentBlanklineSpaceCharBlankline   = { fg = "#414141" },
        IndentBlanklineContextChar          = { fg = "#505050" },
        FloatBorder                         = { bg = scheme.base00 },

        -- Cmp
        CmpDocumentation                    = { fg = scheme.base05, bg = scheme.bg_float },
        CmpDocumentationBorder              = { fg = scheme.base03, bg = scheme.bg_float },

        CmpItemAbbr                         = { fg = scheme.base05 },
        CmpItemAbbrDeprecated               = { fg = scheme.base07, style = "strikethrough" },
        CmpItemAbbrMatch                    = { fg = scheme.base08 },
        CmpItemAbbrMatchFuzzy               = { fg = scheme.base08 },

        CmpItemMenu                         = { fg = scheme.base03 },

        CmpItemKindDefault                  = { fg = scheme.base03 },
        CmpItemKindKeyword                  = { fg = scheme.base09 },
        CmpItemKindVariable                 = { fg = scheme.base0F },
        CmpItemKindConstant                 = { fg = scheme.base0F },
        CmpItemKindReference                = { fg = scheme.base0F },
        CmpItemKindValue                    = { fg = scheme.base0F },
        CmpItemKindFunction                 = { fg = scheme.base08 },
        CmpItemKindMethod                   = { fg = scheme.base08 },
        CmpItemKindConstructor              = { fg = scheme.base08 },
        CmpItemKindClass                    = { fg = scheme.base0C },
        CmpItemKindInterface                = { fg = scheme.base0C },
        CmpItemKindStruct                   = { fg = scheme.base0C },
        CmpItemKindEvent                    = { fg = scheme.base0C },
        CmpItemKindEnum                     = { fg = scheme.base0C },
        CmpItemKindUnit                     = { fg = scheme.base0C },
        CmpItemKindModule                   = { fg = scheme.base0A },
        CmpItemKindProperty                 = { fg = scheme.base0F },
        CmpItemKindField                    = { fg = scheme.base0F },
        CmpItemKindTypeParameter            = { fg = scheme.base0F },
        CmpItemKindEnumMember               = { fg = scheme.base0F },
        CmpItemKindOperator                 = { fg = scheme.base0F },
        CmpItemKindSnippet                  = { fg = scheme.base03 },

        -- Mutt-Mail
        mailHeader                          = { fg = scheme.base0E },
        mailHeaderKey                       = { fg = scheme.base0E },
        mailHeaderEmail                     = { fg = scheme.base0F },
        mailSubject                         = { fg = scheme.base0F, style = "italic" },

        mailQuoted1                         = { fg = scheme.base0D },
        mailQuoted2                         = { fg = scheme.base08 },
        mailQuoted3                         = { fg = scheme.base09 },
        mailQuoted4                         = { fg = scheme.base0C },
        mailQuoted5                         = { fg = scheme.base0B },
        mailQuoted6                         = { fg = scheme.base08 },

        mailQuotedExp1                      = { fg = scheme.base07 },
        mailQuotedExp2                      = { fg = scheme.base08 },
        mailQuotedExp3                      = { fg = scheme.base09 },
        mailQuotedExp4                      = { fg = scheme.base0C },
        mailQuotedExp5                      = { fg = scheme.base0B },
        mailQuotedExp6                      = { fg = scheme.base08 },

        mailSignature                       = { fg = scheme.base03 },
        mailURL                             = { fg = scheme.base08, style = "underline" },
        mailEmail                           = { fg = scheme.base0A },

        rainbowcol1                         = { fg = scheme.base0F },
        rainbowcol2                         = { fg = scheme.base03 },
        rainbowcol3                         = { fg = scheme.base0D },
        rainbowcol4                         = { fg = scheme.base0B },
        rainbowcol5                         = { fg = scheme.base0A },
        rainbowcol6                         = { fg = scheme.base08 },
        rainbowcol7                         = { fg = scheme.base0C },

        -- Illuminate
        IlluminatedWordText                 = { bg = scheme.base04 },
        IlluminatedWordRead                 = { bg = scheme.base04 },
        IlluminatedWordWrite                = { bg = scheme.base04 },

        -- Dashboard
        DashboardHeader                     = { fg = scheme.base0E },
        DashboardShortCut                   = { fg = scheme.base08 },
        DashboardCenter                     = { fg = scheme.base0A },
        DashboardFooter                     = { fg = scheme.base09 },

        -- Lspsaga
        DiagnosticError                     = { fg = scheme.base0E },
        DiagnosticWarning                   = { fg = scheme.base0A },
        DiagnosticInformation               = { fg = scheme.base08 },
        DiagnosticHint                      = { fg = scheme.base03 },
        LspSagaDiagnosticBorder             = { fg = scheme.base07 },
        LspSagaDiagnosticHeader             = { fg = scheme.base0A },
        LspSagaDiagnosticTruncateLine       = { fg = scheme.base07 },
        LspSagaRenameBoarder                = { fg = scheme.base09 },
        SagaSelect                          = { fg = scheme.base08 },
        CodeActionText                      = { fg = scheme.base05 },
    }

    if style.telescope_theme then
        theme.base = vim.tbl_extend("force", theme.base,
        {
            -- Telescope
            TelescopeBorder        = { fg = scheme.base00, bg = scheme.base00 },
            TelescopePromptCounter = { fg = scheme.base07, bg = scheme.base03 },
            TelescopePromptBorder  = { fg = scheme.base03, bg = scheme.base03 },
            TelescopePromptNormal  = { fg = scheme.base07, bg = scheme.base03 },
            TelescopePromptPrefix  = { fg = scheme.base0A, bg = scheme.base03 },
            TelescopePreviewTitle  = { fg = scheme.base02, bg = scheme.base0F },
            TelescopePromptTitle   = { fg = scheme.base02, bg = scheme.base0A },
            TelescopeResultsTitle  = { fg = scheme.base00, bg = scheme.base07 },
            TelescopeSelection     = { bg = diff.change },
            TelescopeNormal        = { bg = scheme.base00 },
        })
    end

    if style.transparent_bg then
        theme.base = vim.tbl_extend("force", theme.base,
        {
            DapUIEndofBuffer = { bg = scheme.base01 },
        })
    else
       vim.api.nvim_set_hl(0, "DimNormal", { bg = scheme.base01 })
       vim.api.nvim_create_autocmd("FileType",
       {
           pattern = { "netrw", "notify" },
           callback = function()
               vim.wo.winhl = "Normal:DimNormal,NormalNC:DimNormal"
           end
       })
    end

    theme.base = vim.tbl_extend("force", theme.base, style.highlights or {})
    theme.term = vim.tbl_extend("force", theme.term, style.term_highlights or {})
    return theme
end

function M.setup(theme, opts)
    local style = setup_scheme(theme, opts)
    -- Only needed to clear when not the default colorscheme
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end

    vim.o.termguicolors = true
    -- Load base theme
    util.syntax(style.base)
    vim.defer_fn(function()
        util.syntax(style.defer)
    end, 100)
end

return M
