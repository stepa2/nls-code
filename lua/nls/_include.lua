AddCSLuaFile()

SERVER_NAME = "NLS"
SERVER_NAME_COLOR = Color(128,0,255)
NLS = {}

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

include("servermenu.lua")

include("gamemodes.lua")

include("zadalbot.lua")

if SERVER then
    include("lzwd_cfg_sv.lua")
end

if SERVER then
    AddCSLuaFile("entity_infobox_cl.lua")
else
    include("entity_infobox_cl.lua")
end

if SERVER then
    AddCSLuaFile("player_3dnick_cl.lua")
else
    include("player_3dnick_cl.lua")
end