local engine = require("config").setting.editor.translator
if engine == 'kd' and vim.fn.executable("kd") then
    require("comp.translation.kd")
end
