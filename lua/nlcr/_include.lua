AddCSLuaFile()

-- Поставь переменные
-- _G.SERVER_NAME
-- _G.SERVER_NAME_COLOR
-- _G.SERVER_ICON -- icon16/server.png

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

NLCR = {}

function NLCR.GetRealmFromFilename(filename)
    if string.EndsWith(filename, "_sv.lua") then
        return "sv"
    elseif string.EndsWith(filename, "_cl.lua") then
        return "cl"
    end

    filename = string.GetFileFromFilename(filename)
    if string.StartWith(filename, "sv_") then
        return "sv"
    elseif string.StartWith(filename, "cl_") then
        return "cl"
    end

    -- xxx_sh.lua and sh_xxx.lua goes there
    return "sh"
end

function NLCR.IncludeFile(filename)
    local realm = NLCR.GetRealmFromFilename(filename)

    if realm ~= "sv" and SERVER then
        AddCSLuaFile(filename)
    end

    if  (realm == "sv" and SERVER) or
        (realm == "cl" and CLIENT) or
        (realm == "sh")
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