AddCSLuaFile()

-- Поставь переменные
-- _G.SERVER_NAME
-- _G.SERVER_NAME_COLOR
-- _G.SERVER_ICON -- icon16/server.png

if CLIENT then
    language.Add("SERVER_NAME", SERVER_NAME)
end

NLCR = {}

local function IncludeAll(files)
    for i, file in ipairs(files) do
        AddCSLuaFile(file)
        include(file)
    end
end

IncludeAll({
})