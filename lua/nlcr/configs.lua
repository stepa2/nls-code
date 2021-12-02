local CONFIG_DIR = "nlcr/configs/"

NLCR.Config = NLCR.Config or {}
local Data = {} -- Will be reloaded

local function LoadConfigs()
    local files, _ = file.Find(CONFIG_DIR.."*", "LUA")

    for _, filename in ipairs(files) do
        local filepath = CONFIG_DIR..filename

        local name, tbl = NLCR.IncludeFile(filepath)
        if isstring(name) and istable(tbl) then
            Data[name] = tbl
        elseif istable(name) and tbl == nil then
            tbl = name
            Data[string.StripExtension(filename)] = tbl
        else
            Error("Invalid config file ",filepath,": first return is ",type(name)," and second is ",type(tbl))
        end
    end
end

function NLCR.Config.Get(name)
    assert(isstring(name), "'name' is not a string")
    return Data[name]
end

function NLCR.Config.GetCurrentModule()
    assert(MODULE ~= nil, "Not called inside module")
    local name = MODULE.Name
    return Data[name]
end

hook.Add("OnReloaded", "NLCR.ConfigLoader", LoadConfigs)
LoadConfigs()
