util.AddNetworkString("LzWD_WorkshopAddons")
util.AddNetworkString("LzWD_ClientMessage")

-- The addons we need to send to player
local AddonsDeferredRuntime = {}
local AddonsDeferredConfig = {}

resource.AddWorkshopActual = resource.AddWorkshop

resource.AddWorkshop = function(workshopid)
    assert(isstring(workshopid), "workshopid ("..tostring(workshopid)..") is not a string")

    if AddonsDeferredRuntime[workshopid] == true then return end

    AddonsDeferredRuntime[workshopid] = true
end

-- Config loading
local CONFIG_FILE = "nlcr/lzwd_config.lua"

local function LoadConfig()
    -- If error happens here, add LzWD config file
    local cfg = NLCR.Config.Get("core_lzwd")
    assert(cfg ~= nil, "Missing LzWD configuration!")

    for _, wsid in ipairs(assert(cfg.Deferred)) do
        AddonsDeferredConfig[wsid] = true
    end

    for _, wsid in ipairs(assert(cfg.Connection)) do
        resource.AddWorkshopActual(wsid)
    end
end
LoadConfig()

concommand.Add("lzwd_request_addons", function(requester)
    if not IsValid(requester) then
        print("This concommand should only be run by players!")
        return
    end

    if table.IsEmpty(AddonsDeferredRuntime) and table.IsEmpty(AddonsDeferredConfig) then return end

    net.Start("LzWD_WorkshopAddons")
        net.WriteUInt(table.Count(AddonsDeferredRuntime) +
                      table.Count(AddonsDeferredConfig), 32)

        for workshopid, _ in pairs(AddonsDeferredRuntime) do
            net.WriteString(workshopid) -- As GLua does not supports 64-bit integers and addon ID will go over 32 bits (it is already >31 bit), 
                                        -- writing addon id as string is only futureproof way
        end

        for workshopid, _ in pairs(AddonsDeferredConfig) do
            net.WriteString(workshopid)
        end
    net.Send(requester)
end)

net.Receive("LzWD_ClientMessage", function(len, ply)
    MsgN("LzWD > ",ply:Nick()," message: ", net.ReadString())
end)