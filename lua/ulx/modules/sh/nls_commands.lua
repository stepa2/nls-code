AddCSLuaFile()

local function CreateGamemodeCommand(gm)
    return function(caller)
        NLS.Gamemodes.Set(caller, gm)
    end
end

local cmd_pvp = ulx.command("NLS", "ulx pvp", CreateGamemodeCommand(NLS.Gamemodes.Types.PVP), {"!pvp"})
cmd_pvp:defaultAccess(ULib.ACCESS_ALL)
cmd_pvp:help("Переводит игрока в режим боя")

local cmd_build = ulx.command("NLS", "ulx build", CreateGamemodeCommand(NLS.Gamemodes.Types.BUILD), {"!build"})
cmd_build:defaultAccess(ULib.ACCESS_ALL)
cmd_build:help("Переводит игрока в режим строительства")

local cmd_build = ulx.command("NLS", "ulx rp", CreateGamemodeCommand(NLS.Gamemodes.Types.RP), {"!rp"})
cmd_build:defaultAccess(ULib.ACCESS_ALL)
cmd_build:help("Переводит игрока в ролевой режим")

local cmd_gamemode = ulx.command("NLS", "ulx gamemode", function(caller, gm_name, targets)
    local gm_id = NLS.Gamemodes.Types[string.upper(gm_name)]

    if gm_id == nil then
        ULib.tsayError( caller, "Неправильное название игрового режима", true )
        return
    end

    for i, target in ipairs(targets) do
        NLS.Gamemodes.Set(target, gm_id)
    end
end, "!gamemode")

cmd_gamemode:defaultAccess( ULib.ACCESS_ADMIN )
cmd_gamemode:help("Меняет игровой режим игроку (игрокам)")
cmd_gamemode:addParam({type = ULib.cmds.StringArg, hint = "gamemode"})
cmd_gamemode:addParam({type = ULib.cmds.PlayersArg})