local git = nvim.setting.editor.git
if git == 'lazygit' and vim.fn.executable("lazygit") then
    require("comp.git.lazygit")
elseif git == 'gitui' and vim.fn.executable("gitui") then
    require("comp.git.gitui")
end
