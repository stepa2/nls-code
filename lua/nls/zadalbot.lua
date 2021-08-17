AddCSLuaFile()

if SERVER then
    util.AddNetworkString("NLS_PlayerReady")
    util.AddNetworkString("NLS_ZadalBot_Message")

    local Config = {}

    local function LoadConfig()
        local cfgRaw = file.Read("nls/zadalbot.json", "DATA")

        MsgN("NLS > ZadalBot > Loading config")

        if cfgRaw == nil then
            MsgN("NLS > ZadalBot > Config file missing")
            return 
        end

        local config = util.JSONToTable(cfgRaw)

        if config == nil then
            MsgN("NLS > ZadalBot > Config file has invalid contents")
            return 
        end
    
        MsgN("NLS > ZadalBot > Config loaded")

        Config = config
        assert(Config.BotAddress, "Bot addess unspecified!")
    end

    concommand.Add("zadalbot_reloadconfig", LoadConfig)
    LoadConfig()

    local function SendDataToBot(data)
        HTTP({
            url = Config.BotAddress,
            method = "POST",
            body = util.TableToJSON(data),
            success = function(code)
                if code ~= 200 then MsgN("NLS > ZadalBot > Error sending data (code ",code,")") end
            end,
            failed = function(reason)
                MsgN("NLS > ZadalBot > Error sending data: ",reason)
            end
        })
    end

    local function RecvDataFromBot(callback)
        HTTP({
            url = Config.BotAddress,
            method = "GET",
            success = function(code, body)
                if code ~= 200 then
                    MsgN("NLS > ZadalBot > Error receiving data (code ",code,")")
                else
                    callback(util.JSONToTable(body))
                end
            end,
            failed = function(reason)
                MsgN("NLS > ZadalBot > Error receiving data: ",reason)
            end
        })
    end

    local function BotDataHandler(data)
        local type = data.Type
    
        if type == "ChatMessage" then
            local sender = data.Sender
            local contents = data.Contents
            local attachments = data.Attachments
    
            local msg = sender .. ": "..contents
    
            if not table.IsEmpty(attachments) then
                msg = msg.."\n"..table.concat(attachments, "\n")
            end
    
            MsgN("NLS > ZadalBot message > ", msg)

            net.Start("NLS_ZadalBot_Message")
                net.WriteString(msg)
            net.Broadcast()
        else
            MsgN("NLS > ZadalBot > Invald data type from bot: ", type)
        end
    end
    
    concommand.Add("zadalbot_fetch", function()
        RecvDataFromBot(function(data)
            for i, subdata in ipairs(data) do
                BotDataHandler(subdata)
            end
        end)
    end)
    
    hook.Add("PlayerSay", "NLS_ZadalBot", function(ply, msg)
        if msg[1] == "!" or msg[1] == "~" then return end

        SendDataToBot({
            Type = "GameMessage",
            Sender = ply:Nick(),
            Contents = msg
        }) 
    end)
    
    hook.Add("PlayerConnect", "NLS_ZadalBot", function(name)
        SendDataToBot({
            Type = "PlayerConnection",
            Player = name,
            Status = "ConnectedToServer"
        })
    end)

    hook.Add("PlayerInitialSpawn", "NLS_ZadalBot", function(ply)
        SendDataToBot({
            Type = "PlayerConnection",
            Player = ply:Nick(),
            Status = "LoadedServerside"
        }) 
    end)

    net.Receive("NLS_PlayerReady", function(len, ply)
        SendDataToBot({
            Type = "PlayerConnection",
            Player = ply:Nick(),
            Status = "LoadedClientside"
        }) 
    end)
    
    gameevent.Listen("player_disconnect")
    hook.Add("player_disconnect", "NLS_ZadalBot", function(data)
        SendDataToBot({
            Type = "PlayerDisconnected",
            Player = data.name,
            Reason = data.reason
        })
    end)
end

if CLIENT then
    hook.Add("ClientSignOnStateChanged", "NLS_ZadalBot", function(uid, old, new)
        if new == SIGNONSTATE_FULL then
            net.Start("NLS_PlayerReady")
            net.SendToServer()
        end
    end)

    net.Receive("NLS_ZadalBot_Message", function()
        local msg = net.ReadString()
        chat.AddText("[ZadalBot] ", msg)
    end)
end
