AddCSLuaFile()

if SERVER then

    local function PlayerSpawnedEngineEnt(ply, ent)
        if ent:GetCreator() ~= ply then
            ent:SetCreator(ply)
        end
    end

    local function PlayerSpawnedModel(ply, model, ent)
        PlayerSpawnedEngineEnt(ply, ent)
    end

    local ENGINE_ENT_HOOKS = {
        PlayerSpawnedEffect = PlayerSpawnedModel,
        PlayerSpawnedNPC = PlayerSpawnedEngineEnt,
        PlayerSpawnedProp = PlayerSpawnedModel,
        PlayerSpawnedRagdoll = PlayerSpawnedModel,
        PlayerSpawnedVehicle = PlayerSpawnedEngineEnt
    }

    for hookname, hookfn in pairs(ENGINE_ENT_HOOKS) do
        hook.Add(hookname, "NLS_Bugfix_Creator", hookfn)
    end

end