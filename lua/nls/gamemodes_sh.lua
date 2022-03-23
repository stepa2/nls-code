if SERVER then
    util.AddNetworkString("NLS_Gamemode_Changed")
end

local Gamemodes = {}
NLS.Gamemodes = Gamemodes

Gamemodes.Types = {
    PVP = 1,
    BUILD = 2,
    RP = 3,
    [1] = "PVP",
    [2] = "BUILD",
    [3] = "RP"
}

Gamemodes.FancyName = {
    [1] = "PvP",
    [2] = "Build",
    [3] = "RP"
}

if SERVER then
    local PlayerGamemodes = {}

    function Gamemodes.Set(ply, gm)
        assert(ply ~= nil)

        if gm == PlayerGamemodes[ply] then
            return
        end

        if PlayerGamemodes[ply] ~= nil and gm ~= Gamemodes.Types.BUILD then
            ply:Spawn()
        end

        ply:SetNoTarget(gm == Gamemodes.Types.Build)

        ply:SetNWInt("NLS_Gamemode", gm)

        if gm ~= nil and IsValid(ply) then
            ply:EmitSound("buttons/button24.wav")
            net.Start("NLS_Gamemode_Changed")
                net.WriteEntity(ply)
                net.WriteUInt(gm, 4)
            net.Broadcast()
        end

        PlayerGamemodes[ply] = gm
    end

    function Gamemodes.Get(ply)
        return PlayerGamemodes[ply]
    end

    concommand.Add("nls_changemode", function(ply, cmd, args)
        Gamemodes.Set(ply, Gamemodes.Types[args[1] or ""] or Gamemodes.Types.PVP)
    end, nil, nil, 0)

    hook.Add("PlayerInitialSpawn", "NLS_Gamemodes", function(ply)
        Gamemodes.Set(ply, Gamemodes.Types.BUILD)
    end)

    hook.Add("PlayerDisconnected", "NLS_Gamemodes", function(ply)
        Gamemodes.Set(ply, nil)
    end)
else
    function Gamemodes.Get(ply)
        return ply:GetNWInt("NLS_Gamemode")
    end

    net.Receive("NLS_Gamemode_Changed", function()
        local ply = net.ReadEntity()
        local gm_id = net.ReadUInt(4)

        local gm = Gamemodes.FancyName[gm_id] or "Invalid"

        chat.AddText(SERVER_NAME_COLOR, "NLS: ",
            Color(255,255,255), "Игрок ", ply, " сменил игровой режим на ", gm)
    end)
end


function Gamemodes.GetFancyName(ply)
    return Gamemodes.FancyName[Gamemodes.Get(ply)] or "Invalid"
end

if SERVER then
    local function GetDamageRelatedPlayer(ent)
        if not IsValid(ent) then
            return nil
        end

        if ent:IsPlayer() then
            return ent
        end

        local owner = ent:GetOwner()
        if IsValid(owner) then
            return GetDamageRelatedPlayer(owner)
        end

        local creator = ent:GetCreator()
        if IsValid(creator) then
            return GetDamageRelatedPlayer(creator)
        end

        return nil
    end

    local function TakeDamageBy(target, damager)
        --if not IsValid(target) or not IsValid(damager) then
        --    return false
        --end

        local targetPly = GetDamageRelatedPlayer(target)
        local damagerPly = GetDamageRelatedPlayer(damager)

        if damagerPly == nil then
            return
                (targetPly == nil) or
                (NLS.Gamemodes.Get(targetPly) ~= Gamemodes.Types.BUILD)
        end

        local damagerMode = NLS.Gamemodes.Get(damagerPly)

        if targetPly == nil then
            return damagerMode ~= Gamemodes.Types.BUILD
        end

        local targetMode = NLS.Gamemodes.Get(targetPly)


        if targetMode == Gamemodes.Types.BUILD then
            return
                (not target:IsPlayer()) and
                damagerPly == targetPly
        end

        if targetMode ~= damagerMode then
            return false
        end


        if targetMode == Gamemodes.Types.PVP then
            return true
        end

        -- TODO: roleplay groups
       return true
    end

    hook.Add("PlayerShouldTakeDamage", "NLS_Gamemodes", function(target, damager)
        if not TakeDamageBy(target, damager) then
            return false
        end
    end)

    hook.Add("EntityTakeDamage", "NLS_Gamemodes", function(target, dmg)
        local damager = dmg:GetInflictor()

        if not TakeDamageBy(target, damager) then
            return true
        end
    end)

    local function RegisterACFDamageMode()
        ACF.Permissions.RegisterMode(function(_, attacker, target)
            return TakeDamageBy(target, attacker)
        end, "nls_gm", "Режим урона, совместимый с игровыми режимами NLS",
            true, nil, false) -- Is default?, Think function, Do damage when one of players is logging out?
    end

    if ACF ~= nil then
        RegisterACFDamageMode()
    else
        timer.Simple(0, function()
            if ACF ~= nil then
                RegisterACFDamageMode()
            else
                print("NLS Gamemodes > Not detected ACF")
            end
        end)
    end
end


local function AllowNoclip(ply)
    if ply:IsAdmin() then
        return true
    end

    local plyMode = NLS.Gamemodes.Get(ply)

    if plyMode == Gamemodes.Types.BUILD then
        return true
    end

    if plyMode == Gamemodes.Types.PVP then
        return false
    end

    -- TODO: roleplay custom rules (GMing)

    return false
end


hook.Add("PlayerNoClip", "NLS_Gamemodes", function(ply, targetState)
    if targetState == true and not AllowNoclip(ply) then
        return false
    end
end)