-- Default
require("comp.terminal")
require("comp.jmpword")
require("comp.runner")
require("comp.autopairs")
require("comp.kd")

-- File explore implementation
local explore = nvim.setting.editor.explore

local succeed = false
if explore == "yazi" and vim.fn.executable("yazi") then
    succeed = pcall(require, "comp.yazi")
elseif explore == "ranger" and vim.fn.executable("ranger") then
    succeed = pcall(require, "comp.ranger")
elseif explore == "superfile" and vim.fn.executable("spf") then
    succeed = pcall(require, "comp.superfile")
end


if not succeed or explore == 'netrw' then
    require("comp.netrw")
end

-- Finder
local finder = nvim.setting.editor.finder
if finder == "fzf" and vim.fn.executable("fzf") then
    require("comp.fzf")
end

-- Git
local git = nvim.setting.editor.git
if git == 'lazygit' and vim.fn.executable("lazygit") then
    require("comp.lazygit")
elseif  git == 'gitui' and vim.fn.executable("gitui") then
    require("comp.lazygit")
end
