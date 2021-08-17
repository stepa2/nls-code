AddCSLuaFile()

ulx.command("NLS", "ulx pvp", function(ply)
    NLS.Gamemodes.Set(ply, NLS.Gamemodes.Types.PVP)
end, {"!pvp"})

ulx.command("NLS", "ulx build", function(ply)
    NLS.Gamemodes.Set(ply, NLS.Gamemodes.Types.BUILD)
end, {"!build"})