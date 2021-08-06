AddCSLuaFile()

local Gamemodes = {}
NLS.Gamemodes = Gamemodes

Gamemodes.Types = {
    PVP = 1,
    BUILD = 2,
    --RP = 3,
    [1] = "PVP",
    [2] = "BUILD",
    --[3] = "RP"
}


if SERVER then
    local PlayerGamemodes = {}

    local function SetGamemode(ply, gm)
        if gm == PlayerGamemodes[ply] then
            return
        end
        
        if PlayerGamemodes[ply] ~= nil and gm ~= Gamemodes.Types.BUILD then
            ply:Spawn()
        end

        ply:SetNWInt("NLS_Gamemode", gm)
        ply:EmitSound("buttons/button24.wav")
        PlayerGamemodes[ply] = gm
    end

    function NLS.Gamemodes.Get(ply)
        return PlayerGamemodes[ply]
    end

    concommand.Add("nls_changemode", function(ply, cmd, args)
        SetGamemode(ply, Gamemodes.Types[args[1] or ""] or Gamemodes.Types.PVP)
    end, nil, nil, 0)

    hook.Add("PlayerInitialSpawn", "NLS_Gamemodes", function(ply)
        SetGamemode(ply, Gamemodes.Types.PVP)
    end)

    hook.Add("PlayerDisconnected", "NLS_Gamemodes", function(ply)
        SetGamemode(ply, nil)
    end)
else
    function NLS.Gamemodes.Get(ply)
        return ply:GetNWInt("NLS_Gamemode")
    end
end

if SERVER then

    local function TakeDamageBy(target, damager)
        --if not IsValid(target) or not IsValid(damager) then
        --    return false
        --end
        
        local targetPly = target
    
        if not targetPly:IsPlayer() then
            targetPly = targetPly:GetOwner()
        end
    
        if targetPly ~= nil and not targetPly:IsPlayer() then
            targetPly = nil
        end 
    
        local damagerPly = damager
    
        if not damagerPly:IsPlayer() then
            damagerPly = damagerPly:GetOwner()
        end
    
        if damagerPly ~= nil and not damagerPly:IsPlayer() then
            damagerPly = nil
        end 
    
        if damagerPly ~= nil then
            local damagerMode = NLS.Gamemodes.Get(damagerPly)
          
            if targetPly == nil then
                return damagerMode ~= Gamemodes.Types.BUILD
            end
    
            local targetMode = NLS.Gamemodes.Get(targetPly)
    
    
            if targetMode == Gamemodes.Types.BUILD then
                return damagerPly == targetPly
            elseif targetMode == Gamemodes.Types.PVP then
                return damagerMode == Gamemodes.Types.PVP
            else -- Gamemodes.Types.RP
               if damagerMode ~= Gamemodes.Types.RP then
                   return false
               end
    
               -- TODO: roleplay groups
               return true
            end
        else
            if targetPly == nil then
                return true
            end
    
            return NLS.Gamemodes.Get(targetPly) ~= Gamemodes.Types.BUILD
        end
    end
    
    hook.Add("EntityTakeDamage", "NLS_Gamemodes", function(target, dmg)
        local damager = dmg:GetInflictor()
    
        if not TakeDamageBy(target, damager) then
            return true
        end
    end)

end


local function AllowNoclip(ply)
    local plyMode = NLS.Gamemodes.Get(ply)

    if plyMode == Gamemodes.Types.BUILD then
        return true
    end

    if plyMode == Gamemodes.Types.RP then
        -- TODO: roleplay custom rulse (GMing)

        return false
    end

    return false
end


hook.Add("PlayerNoClip", "NLS_Gamemodes", function(ply, targetState)
    if targetState == true and not AllowNoclip(ply) then
        return false
    end
end)