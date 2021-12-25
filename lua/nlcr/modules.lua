local MODULES_DIR = "nlcr/modules/"
local MODULE_ROOT = "nlcr/"
local MODULE_DIR_INCLUDEROOT = "module.lua"

local CurrentContext = nil
local Modules = {} -- Will be reloaded

local function ContextStart(name)
    CurrentContext = { Name = name }
    _G.MODULE = CurrentContext
end

local function ContextEnd()
    _G.MODULE = nil
    Modules[CurrentContext.Name] = CurrentContext
    hook.Run("NLCR.PostModuleLoaded", CurrentContext)
    CurrentContext = nil
end

local function LoadModuleDir(dir, name, no_include_root)
    ContextStart(name)
        hook.Run("NLCR.PreLoadModuleDir", dir, name)

        if not no_include_root then
            NLCR.IncludeFile(dir..MODULE_DIR_INCLUDEROOT)
        end

        hook.Run("NLCR.PostLoadModuleDir", dir, name)
    ContextEnd()
end

local function LoadModuleFile(filepath, name)
    ContextStart(name)
        NLCR.IncludeFile(filepath)
    ContextEnd()
end

local function LoadModules()
    LoadModuleDir(MODULE_ROOT, "__core", true)

    local files, dirs = file.Find(MODULES_DIR.."*", "LUA")
    local moduleList = {}

    for _, filename in ipairs(files) do
        moduleList[MODULES_DIR..filename] = {
            is_dir = false,
            name = string.StripExtension(filename)
        }
    end

    for _, dirname in ipairs(dirs) do
        moduleList[MODULES_DIR..dirname.."/"] = {
            is_dir = true,
            name = dirname
        }
    end

    for path, data in SortedPairs(moduleList) do
        if data.is_dir then
            LoadModuleDir(path, data.name)
        else
            LoadModuleFile(path, data.name)
        end
    end

end

hook.Add("NLCR.PreLoadModuleDir", "NLCR.LibsLoader", function(dir)
    do
        local _, dirs = file.Find(dir.."*", "LUA")
        if not table.HasValue(dirs, "libs") then return end
    end

    NLCR.IncludeDir(dir.."libs/", true)
end)

hook.Add("OnReloaded", "NLCR.ReloadModules", LoadModules)
LoadModules()