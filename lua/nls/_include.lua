AddCSLuaFile()

SERVER_NAME = "NLS"
NLS = {}

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

include("servermenu.lua")

include("gamemodes.lua")

include("zadalbot.lua")

if CLIENT then
    include("lzwd_cl.lua")
else
    AddCSLuaFile("lzwd_cl.lua")
    include("lzwd_cfg_sv.lua")
    include("lzwd_sv.lua")        
end

if SERVER then
    AddCSLuaFile("entity_infobox_cl.lua")
else
    include("entity_infobox_cl.lua")
end