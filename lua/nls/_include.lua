AddCSLuaFile()

SERVER_NAME = "NLS"
NLS = {}

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

include("servermenu.lua")

include("gamemodes.lua")

include("zadalbot.lua")