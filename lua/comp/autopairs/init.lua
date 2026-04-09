local patterns =
{
    -- Halfwidth
    ["'"] = "''",
    ['"'] = '""',
    ["("] = "()",
    ["{"] = "{}",
    ["["] = "[]",
    ["“"] = "“”",
    ["‘"] = "‘’",
    ["⟦"] = "⟦⟧",
    ["⦅"] = "⦅⦆",
    ["⟪"] = "⟪⟫",
    ["⦗"] = "⦗⦘",
    ["⟮"] = "⟮⟯",
    ["⟨"] = "⟨⟩",
    ["‹"] = "‹›",

    -- Fullwidth
    ["〔"] = "〔〕",
    ["〈"] = "〈〉",
    ["《"] = "《》",
    ["【"] = "【】",
    ["「"] = "「」",
    ["『"] = "『』",
    ["〝"] = "〝〞",
    ["（"] = "（）",
    ["［"] = "［］",
    ["｛"] = "｛｝",
    ["〖"] = "〖〗",
    ["〚"] = "〚〛",
    ["〘"] = "〘〙",
    ["｟"] = "｟｠",
}
local map = require("core.keymap.map")
vim.api.nvim_create_autocmd({ "InsertEnter" },
{
    group = vim.api.nvim_create_augroup("AutoPairs", {}),
    once = true,
    callback = function()
        for k, v in pairs(patterns) do
            map.imap(k, v .. "<Left>")
        end
    end
})
