if CLIENT then
    hook.Remove("PopulateContent", "CONRED.SpawnList") -- Does not works with LzWD
end

if SERVER then
    local function ReplaceACFFuncs()
        local ACF_VehicleDamage_Old = ACF_VehicleDamage
        function ACF_VehicleDamage(Entity, Energy, FrAera, Angle, Inflictor, Bone, Gun, Type)
            local HitRes = ACF_VehicleDamage_Old(Entity, Energy, FrAera, Angle, Inflictor, Bone, Gun, Type)
            Entity:TakeDamage(HitRes.Damage, Inflictor, Gun)
            return HitRes
        end

        local ACF_PropDamage_Old = ACF_PropDamage
        function ACF_PropDamage(Entity, Energy, FrAera, Angle, Inflictor, Bone, Type)
            local HitRes = ACF_PropDamage_Old(Entity, Energy, FrAera, Angle, Inflictor, Bone, Type)
            Entity:TakeDamage(HitRes.Damage, Inflictor, Inflictor) -- TODO: some patch to ACE is required to make Gun available here
            return HitRes
        end
    end

    if ACF ~= nil then
        ReplaceACFFuncs()
    else
        timer.Simple(0, function()
            if ACF ~= nil then
                ReplaceACFFuncs()
            else
                print("NLCR Bugfixes > Not detected ACF")
            end
        end)
    end
end