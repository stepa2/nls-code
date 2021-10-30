print("LzWD > Clientside init")

-- game.AddParticles override

local game_AddParticles = game.AddParticles
local required_particles = {}

function game.AddParticles(file)
    required_particles[file] = false
end

hook.Add("LzWD_OnMounted", "LzWD_Particles", function(name, files)
    for i, f in ipairs(files) do
        if required_particles[f] == false then
            game_AddParticles(f)
            required_particles[f] = true
        end
    end
end)

-- Specific Logging

local function PrintServer(msg)
    net.Start("LzWD_ClientMessage")
        net.WriteString(msg)
    net.SendToServer()
end

local function PrintChat(msg)
    local lp = LocalPlayer()
    local chat_msg = "LzWD > "..msg

    if IsValid(lp) then
        lp:ChatPrint(chat_msg)
    else
        print(chat_msg)
    end

    PrintServer(msg)
end

-- Caching

local SAVED_ADDONS_DATA_FILE = "nls/lzwd/cache.txt"
local SAVED_ADDONS_CACHE_DIR = "nls/lzwd/"

local SavedAddonsData = {}

file.CreateDir("nls/lzwd")

local function ReadCacheDesc()
    SavedAddonsData = {}

    local data = file.Read(SAVED_ADDONS_DATA_FILE,"DATA")

    if data == nil then return end

    for i, line in ipairs(string.Explode("\n", data)) do
        if line == "" then continue end
        line = string.Explode(" ", line)

        local wid = line[1]
        local timestamp = tonumber(line[2])

        local gma = SAVED_ADDONS_CACHE_DIR..wid..".gma.dat"

        if file.Exists(gma, "DATA") then
            SavedAddonsData[wid] = timestamp
        end
    end
end

local function WriteCacheDesc()
    local cache = file.Open(SAVED_ADDONS_DATA_FILE, "w", "DATA")

    for wid, timestamp in pairs(SavedAddonsData) do
        cache:Write(wid.." "..tostring(timestamp).."\n")
    end

    cache:Close()
end

ReadCacheDesc()
concommand.Add("lzwd_reload_cachedesc", ReadCacheDesc)

local READ_STEP = 16*1024*1024

local function CacheFile(id, src_file, timestamp)
    local dest_file = file.Open(SAVED_ADDONS_CACHE_DIR..id..".gma.dat", "wb", "DATA")

    local count_f = src_file:Size() / READ_STEP
    local count = math.ceil(count_f)

    for i = 1, count do
        local data = src_file:Read(math.min(READ_STEP, src_file:Size() - src_file:Tell()))

        dest_file:Write(data)
    end

    dest_file:Close()

    SavedAddonsData[id] = timestamp
    WriteCacheDesc()
end

local function GetCachedFilePath(id, timestamp)
    local cache_timestamp = SavedAddonsData[id]

    if cache_timestamp == nil or timestamp > cache_timestamp then
        return nil
    end

    local path = "data/"..SAVED_ADDONS_CACHE_DIR..id..".gma.dat"

    return path
end

-- Downloading

local WorkshopAddons = {}
local WorkshopAddonsInfo = {}

local DownloadInProcess = false

local StartWorkshopDownload
local OnAllInfoReceived
local LoadAllAddons
local MountGMA
local OnFinished

hook.Add("InitPostEntity", "LzWD_InitPostEntity", function()
    PrintChat("Сейчас начнётся загрузка аддонов")

    timer.Simple(6, function()
        RunConsoleCommand("lzwd_requestaddons")
    end)
end)

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

    PrintChat("Всего "..tostring(newCount).." аддонов")

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
                PrintChat("Ошибка #"..tostring(info.error).." при получении информации об аддоне "..workshopid)
            else
                WorkshopAddonsInfo[workshopid] = info

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

local DownloadRetries = {}

OnAllInfoReceived = function()
    local addons = {}

    for wid, is_loaded in pairs(WorkshopAddons) do
        if is_loaded == false then
            addons[wid] = {
                Size = WorkshopAddonsInfo[wid].size,
                UpdateTime = WorkshopAddonsInfo[wid].updated,
                Name = WorkshopAddonsInfo[wid].title,
                Actual = false
            }
        end
    end

    for i, data in ipairs(engine.GetAddons()) do
        local addon = addons[data.wsid]

        if addon then
            PrintServer("Аддон скачан клиентом и будет смонтирован: "..data.wsid.." '"..addon.Name,"'")

            addon.Actual = true
            addon.GMA = data.file
        end
    end

    for wid, addon in pairs(addons) do
        local cached_gma = GetCachedFilePath(wid, addon.UpdateTime)

        if cached_gma and not addon.Actual then
            PrintServer("Аддон кеширован: "..wid.." '"..addon.Name.."'")

            addon.Actual = true
            addon.GMA = cached_gma
        end
    end

    local addonsBySize = {}
    local downloadAddons = 0

    for wid, data in SortedPairsByMemberValue(addons, "Size", false) do
        table.insert(addonsBySize, {
            WorkshopId = wid,
            Size = data.Size,
            Actual = data.Actual,
            GMA = data.GMA,
            UpdateTime = data.UpdateTime,
            Name = data.Name
        })

        if not data.Actual then
            downloadAddons = downloadAddons + 1
        end
    end

    PrintChat("Будет скачано "..tostring(downloadAddons).." аддонов")
    DownloadRetries = {}

    LoadAllAddons(addonsBySize)
end

local INITIAL_RETRIES = 6

-- This function assumes that if it is called, than addon #workshopid exists
-- So it will retry downloading over and over
-- callback = function(path)
local function DownloadAddon(workshopid, callback, fatal_callback)
    steamworks.DownloadUGC(workshopid, function(path, gma_file)
        if path ~= nil then
            PrintServer("Скачан аддон "..workshopid)
            callback(path, gma_file)
        else
            local attempt = (DownloadRetries[workshopid] or INITIAL_RETRIES + 1) - 1
            DownloadRetries[workshopid] = attempt

            if attempt > 0 then
                timer.Simple(2, function()
                    PrintChat("Ошибка при скачивании аддона "..workshopid..", перезапуск закачки ("..tostring(attempt)..")")
                    DownloadAddon(workshopid, callback, fatal_callback)
                end)
            else
                fatal_callback()
            end


        end
    end)

end

LoadAllAddons = function(addonsBySize)
    local remainingCount = #addonsBySize

    if remainingCount == 0 then
        OnFinished()
        return
    end

    for i, data in ipairs(addonsBySize) do
        local wid = data.WorkshopId

        if not data.Actual then
            DownloadAddon(wid, function(path, gma_file)
                data.GMA = path
                data.Actual = true
                CacheFile(wid, gma_file, data.UpdateTime)
                MountGMA(data)

                remainingCount = remainingCount - 1

                if remainingCount == 0 then
                    OnFinished()
                    return
                end
            end, function()
                PrintChat("Ошибка при скачивании аддона "..wid)
                PrintChat("Для ручного перезапуска закачки введите lzwd_requestaddons в консоль")
                remainingCount = remainingCount - 1
            end)
        else
            MountGMA(data)

            remainingCount = remainingCount - 1

            if remainingCount == 0 then
                OnFinished()
                return
            end
        end
    end
end

MountGMA = function(addon)
    local success, files = game.MountGMA(addon.GMA)

    local wid = addon.WorkshopId

    if not success then
        PrintChat("Ошибка при монтировании аддона #"..wid.." '"..WorkshopAddonsInfo[wid].title.."'")
        return
    end

    hook.Run("LzWD_OnMounted", addon.Name, files)

    PrintServer("Смонтирован аддон "..wid.." '"..string.Replace(addon.Name,"\n", " ").."'")

    addon.Mounted = true
    WorkshopAddons[wid] = true
end

OnFinished = function()
    DownloadInProcess = false

    PrintChat("Завершено!")
end

print("LzWD > Clientside init finished")