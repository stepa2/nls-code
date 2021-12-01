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
local CONFIG_FILE = "nlcr/lzwd_config.json"

local function LoadConfig(clear_all)
    local cfg_text = file.Read(CONFIG_FILE, "DATA")
    if cfg_text == nil then
        Error("LzWD Error: configuration file at garrysmod/data/",CONFIG_FILE," is missing!")
    end

    local cfg = util.JSONToTable(cfg_text)
    if cfg == nil then
        Error("LzWD Error: configuration file at garrysmod/data/",CONFIG_FILE," contains invalid JSON!")
    end

    if clear_all then
        AddonsDeferred = {}
    end

    for _, wsid in ipairs(cfg.Deferred or {}) do
        AddonsDeferred[wsid] = true
    end

    for _, wsid in ipairs(cfg.Connection or {}) do
        resource.AddWorkshopActual(wsid)
    end
end

LoadConfig(false)

concommand.Add("lzwd_reload_config", function(_,_,args)
    LoadConfig(tobool(args[1]))
end, nil, "Reloads LzWD addons config (garrysmod/data/"..CONFIG_FILE..").\n"..
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