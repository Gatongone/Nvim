local explore = nvim.setting.editor.explore
local succeed = false

if explore == "yazi" and vim.fn.executable("yazi") then
    succeed = pcall(require, "comp.explore.yazi")
elseif explore == "ranger" and vim.fn.executable("ranger") then
    succeed = pcall(require, "comp.explore.ranger")
elseif explore == "superfile" and vim.fn.executable("spf") then
    succeed = pcall(require, "comp.explore.superfile")
end

-- Fallback to advanced Netrw.
if not succeed or explore == 'netrw' then
    require("comp.explore.netrw")
end
