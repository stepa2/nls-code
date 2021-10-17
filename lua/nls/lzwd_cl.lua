print("LzWD > Clientside init")

local function PrintChat(msg)
    local lp = LocalPlayer()

    if IsValid(lp) then
        lp:ChatPrint(msg)
    else
        print(msg)
    end
end

local function PrintError(msg)
    PrintChat("LZWD > "..msg)
    net.Start("LzWD_ClientError")
        net.WriteString(msg)
    net.SendToServer()
end

local SAVED_ADDONS_DATA_FILE = "nls/lzwd/desc.json"
local SAVED_ADDONS_CACHE_DIR = "nls/lzwd/"

local SavedAddonsData = {}


local WorkshopAddons = {}
local WorkshopAddonsInfo = {}
local NewWorkshopAddonsNoInfoCount = 0

local DownloadInProcess = false

-- Caching functions

file.CreateDir("nls/lzwd")

local function ReadCacheDesc()
    local data = file.Read(SAVED_ADDONS_DATA_FILE,"DATA")

    if data == nil then return end

    SavedAddonsData = util.JSONToTable(data) or {}

    local to_remove = {}
    for gma, _ in pairs(SavedAddonsData) do
        if not file.Exists(gma, "DATA") then
            table.insert(to_remove, gma)
        end
    end

    for _, remove in ipairs(to_remove) do
        SavedAddonsData[remove] = nil
    end
end

local function WriteCacheDesc()
    file.Write(SAVED_ADDONS_DATA_FILE, util.TableToJSON(SavedAddonsData, true))
end

ReadCacheDesc()
concommand.Add("lzwd_reload_cachedesc", ReadCacheDesc)

local function CacheFile(id, data, timestamp)
    file.Write(SAVED_ADDONS_CACHE_DIR..id..".gma.dat", data)

    SavedAddonsData[id] = timestamp
    WriteCacheDesc()
end

local function GetCachedFilePath(id, timestamp)
    local cache_timestamp = SavedAddonsData[id]

    if cache_timestamp == nil or timestamp > cache_timestamp then
        return nil
    end

    return "data/"..SAVED_ADDONS_CACHE_DIR..id..".gma.dat"
end

-- Functions
local StartWorkshopDownload
local OnAllInfoReceived
local LoadAllAddons
local MountGMAs


net.Receive("LzWD_WorkshopAddons", function()
    assert(not DownloadInProcess, "Too fast!")
    DownloadInProcess = true

    local count = net.ReadUInt(32)
    local newCount = 0

    for i = 1, count do
        local wid = net.ReadString()
        local new = WorkshopAddons[wid] or false
        
        WorkshopAddons[wid] = new

        if new == false then newCount = newCount + 1 end
    end

    PrintChat("LzWD > Будет загружено "..tostring(newCount).." аддонов")

    StartWorkshopDownload(count)
end)


StartWorkshopDownload = function(count)
    local to_remove = {}

    for workshopid, is_loaded in pairs(WorkshopAddons) do
        if is_loaded then
            continue 
        end

        steamworks.FileInfo(workshopid, function(info)
            count = count - 1
            
            if info.error ~= nil then
                to_remove[workshopid] = true
                PrintError("Ошибка #"..tostring(info.error).." при получении информации об аддоне "..workshopid)
            else
                WorkshopAddonsInfo[workshopid] = info
                --PrintChat("LzWD > Получена информация об аддоне #"..workshopid.." ("..info.title..")")
            
                if count == 0 then
                    OnAllInfoReceived()
                end
            end
        end)
    end

    for workshopid, _ in pairs(to_remove) do
        WorkshopAddons[workshopid] = nil
    end
end

OnAllInfoReceived = function()
    local addons = {}

    for wid, is_loaded in pairs(WorkshopAddons) do
        if is_loaded == false then
            addons[wid] = {
                Size = WorkshopAddonsInfo[wid].size,
                UpdateTime = WorkshopAddonsInfo[wid].updated,
                Actual = is_loaded
            }
        end
    end

    for i, data in ipairs(engine.GetAddons()) do
        local addon = addons[data.wsid]

        if addon then
            addon.Actual = true
            addon.GMA = data.file
        end
    end

    for wid, addon in pairs(addons) do
        local cached_gma = GetCachedFilePath(wid, addon.UpdateTime)

        if cached_gma then
            addon.Actual = true
            addon.GMA = cached_gma
        end
    end

    local addonsBySize = {}

    for wid, data in SortedPairsByMemberValue(addons, "Size", false) do
        table.insert(addonsBySize, {
            WorkshopId = wid,
            Size = data.Size,
            Actual = data.Actual,
            GMA = data.GMA,
            UpdateTime = data.UpdateTime
        })
    end


    LoadAllAddons(addonsBySize)
end


-- This function assumes that if it is called, than addon #workshopid exists
-- So it will retry downloading over and over
-- callback = function(path)
local function DownloadAddon(workshopid, callback)
    steamworks.DownloadUGC(workshopid, function(path, gma_file)
        if path ~= nil then
            callback(path, gma_file)
        else
            timer.Simple(2, function()
                PrintError("Ошибка при скачивании аддона #"..workshopid..", перезапуск закачки")
                DownloadAddon(workshopid, callback)
            end)
        end
    end)

end 

LoadAllAddons = function(addonsBySize)
    local remainingCount = #addonsBySize
    local anyNonActual = false


    for i, data in ipairs(addonsBySize) do
        local wid = data.WorkshopId

        if not data.Actual then
            anyNonActual = true

            DownloadAddon(wid, function(path, gma_file)
                data.GMA = path
                data.Actual = true
                CacheFile(wid, gma_file:Read(gma_file:Size()), data.UpdateTime)
            
                remainingCount = remainingCount - 1
                --PrintChat("LzWD > Скачен аддон #"..wid.." ("..WorkshopAddonsInfo[wid].title..")")

                if remainingCount == 0 then
                    MountGMAs(addonsBySize)
                end
            end)
        else
            --PrintChat("LzWD > Аддон #"..wid.." ("..WorkshopAddonsInfo[wid].title..") уже скачен")
            remainingCount = remainingCount - 1
        end
    end

    if not anyNonActual then
        MountGMAs(addonsBySize)
    end
end

MountGMAs = function(addons)
    PrintChat("LzWD > Монтируем "..tostring(table.Count(addons)).." аддонов")
    
    for i, addon in pairs(addons) do
        local success, files = game.MountGMA(addon.GMA)
        
        local wid = addon.WorkshopId
        
        if not success then
            PrintError("Ошибка при монтировании аддона #"..wid.." ("..WorkshopAddonsInfo[wid].title..")")
        else
            WorkshopAddons[wid] = true
        end
    end

    DownloadInProcess = false

    WriteCacheDesc()

    PrintChat("LzWD > Завершено!")
end

hook.Add("InitPostEntity", "LzWD_InitPostEntity", function()
    PrintChat("LzWD > Сейчас начнётся загрузка аддонов")

    timer.Simple(6, function()
        RunConsoleCommand("lzwd_requestaddons")
    end)
end)

print("LzWD > Clientside init finished")