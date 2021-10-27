AddCSLuaFile()

SERVER_NAME = "NLS"
SERVER_NAME_COLOR = Color(128,0,255)
NLS = {}

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

include("bugfixes.lua")

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

if SERVER then
    AddCSLuaFile("player_3dnick_cl.lua")
else
    include("player_3dnick_cl.lua")
end

if SERVER then
    AddCSLuaFile("spawnmenu_cl.lua")
else
    include("spawnmenu_cl.lua")
end