AddCSLuaFile()

local cmd_pvp = ulx.command("NLS", "ulx pvp", function(ply)
    NLS.Gamemodes.Set(ply, NLS.Gamemodes.Types.PVP)
end, {"!pvp"})

cmd_pvp:defaultAccess(ULib.ACCESS_ALL)
cmd_pvp:help("Переводит игрока в режим боя")

local cmd_build = ulx.command("NLS", "ulx build", function(ply)
    NLS.Gamemodes.Set(ply, NLS.Gamemodes.Types.BUILD)
end, {"!build"})

cmd_build:defaultAccess(ULib.ACCESS_ALL)
cmd_build:help("Переводит игрока в режим строительства")