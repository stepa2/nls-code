util.AddNetworkString("LzWD_WorkshopAddons")
util.AddNetworkString("LzWD_ClientMessage")

-- The addons we need to send to player
local AddonsDeferred = {}

resource.AddWorkshopActual = resource.AddWorkshop

resource.AddWorkshop = function(workshopid)
    assert(isstring(workshopid), "workshopid ("..tostring(workshopid)..") is not a string")

    if AddonsDeferred[workshopid] == true then return end

    AddonsDeferred[workshopid] = true
end

-- Config loading
local CONFIG_FILE = "nlcr/lzwd_config.lua"

local function LoadConfig(clear_all)
    -- If error happens here, add LzWD config file
    local cfg = NLCR.IncludeFile(CONFIG_FILE)

    if clear_all then
        AddonsDeferred = {}
    end

    for _, wsid in ipairs(assert(cfg.Deferred)) do
        AddonsDeferred[wsid] = true
    end

    for _, wsid in ipairs(assert(cfg.Connection)) do
        resource.AddWorkshopActual(wsid)
    end
end

LoadConfig(false)

concommand.Add("lzwd_reload_config", function(_,_,args)
    LoadConfig(tobool(args[1]))
end, nil, "Reloads LzWD addons config (lua/"..CONFIG_FILE..").\n"..
        "If called with true or 1, previously-loaded addons are not keeped")

concommand.Add("lzwd_request_addons", function(requester)
    if not IsValid(requester) then
        print("This concommand should only be run by players!")
        return
    end

    if table.IsEmpty(AddonsDeferred) then return end

    net.Start("LzWD_WorkshopAddons")
        net.WriteUInt(table.Count(AddonsDeferred), 32)

        for workshopid, _ in pairs(AddonsDeferred) do
            net.WriteString(workshopid) -- As GLua does not supports 64-bit integers and addon ID will go over 32 bits (it is already >31 bit), 
                                        -- writing addon id as string is only futureproof way
        end
    net.Send(requester)
end)

net.Receive("LzWD_ClientMessage", function(len, ply)
    MsgN("LzWD > ",ply:Nick()," message: ", net.ReadString())
end)