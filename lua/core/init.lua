-- Make sure setfenv/getfenv valid
if not setfenv then
    local function findenv(f)
        local level = 1
        repeat
            local name, value = debug.getupvalue(f, level)
            if name == "_ENV" then
                return level, value
            end
            level = level + 1
        until name == nil
        return nil
    end
    ---Version: >= Lua5.2
    getfenv = function(f)
        return (select(2, findenv(f)) or _G)
    end
    ---Version: >= Lua5.2
    setfenv = function(f, t)
        local level = findenv(f)
        if level then
            debug.setupvalue(f, level, t)
        end
        return f
    end
end

require("core.setting")
require("core.cmd")
require("core.keymap")
