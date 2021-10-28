print("LzWD > Serverside init")

util.AddNetworkString("LzWD_WorkshopAddons")
util.AddNetworkString("LzWD_ClientError")

assert(istable(LzWDAddons), "lua/autorun/server/stpm64_lzwd_sv_cfg.lua did not executed before this file")

-- The addons we need to send to player
local WorkshopAddons = {}

do
    for i, workshopid in ipairs(LzWDAddons) do
        WorkshopAddons[workshopid] = true
    end
end

resource.AddWorkshop = function(workshopid)
    assert(isstring(workshopid), "workshopid ("..tostring(workshopid)..") is not a string")

    if WorkshopAddons[workshopid] == true then return end

    WorkshopAddons[workshopid] = true
end

concommand.Add("lzwd_requestaddons", function(requester)
    if not IsValid(requester) then
        print("This concommand should only be run by players!")
        return
    end

    net.Start("LzWD_WorkshopAddons")
        net.WriteUInt(table.Count(WorkshopAddons), 32)

        for workshopid, _ in pairs(WorkshopAddons) do
            net.WriteString(workshopid) -- As GLua does not supports 64-bit integers and addon ID will go over 32 bits (it is already >31 bit), 
                                        -- writing addon id as string is only futureproof way
        end
    net.Send(requester)
end)

net.Receive("LzWD_ClientMessage", function(len, ply)
    MsgN("LzWD > ",ply:Nick()," message: ", net.ReadString())
end)

print("LzWD > Serverside init finished")