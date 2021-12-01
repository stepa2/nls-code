AddCSLuaFile()

-- Поставь переменные
-- _G.SERVER_NAME
-- _G.SERVER_NAME_COLOR
-- _G.SERVER_ICON -- icon16/server.png

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

NLCR = {}

function NLCR.IncludeFile(filename)
    local ends_with_sv = string.EndsWith(filename, "_sv.lua")
    local ends_with_cl = string.EndsWith(filename, "_cl.lua")
    -- _sh.lua handled as *anything else*.lua

    if not ends_with_sv and SERVER then
        AddCSLuaFile(filename)
    end

    if  (ends_with_sv and SERVER) or
        (ends_with_cl and CLIENT) or
        (not ends_with_sv and not ends_with_cl)
    then
        return include(filename)
    end
end

function NLCR.IncludeAll(files)
    for i, filename in ipairs(files) do
        NLCR.IncludeFile(filename)
    end
end

NLCR.IncludeAll({
    "bugfixes.lua",
    "spawnmenu_cl.lua",
    "lzwd_cl.lua",
    "lzwd_sv.lua"
})