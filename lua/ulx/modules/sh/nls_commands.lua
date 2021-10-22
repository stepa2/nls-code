AddCSLuaFile()

local cmd_pvp = ulx.command("NLS", "ulx pvp", function(caller, target)
    if IsValid(target) then
        if not caller:IsAdmin() then
            ulx.fancyLogAdmin( caller, false, "Только администрация может менять игровые режимы других игроков" )
            return
        end
    else
        target = caller
    end

    NLS.Gamemodes.Set(target, NLS.Gamemodes.Types.PVP)
end, {"!pvp"})

cmd_pvp:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
cmd_pvp:defaultAccess(ULib.ACCESS_ALL)
cmd_pvp:help("Переводит игрока в режим боя")

local cmd_build = ulx.command("NLS", "ulx build", function(caller, target)
    if IsValid(target) then
        if not caller:IsAdmin() then
            ulx.fancyLogAdmin( caller, false, "Только администрация может менять игровые режимы других игроков" )
            return
        end
    else
        target = caller
    end

    NLS.Gamemodes.Set(target, NLS.Gamemodes.Types.BUILD)
end, {"!build"})

cmd_pvp:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
cmd_build:defaultAccess(ULib.ACCESS_ALL)
cmd_build:help("Переводит игрока в режим строительства")