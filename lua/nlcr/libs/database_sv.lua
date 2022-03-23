NLCR.DB = mysql

local function Connect()
    local cfg = NLCR.Config.Get("core_database")
    if cfg == nil or cfg.Adapter == nil then
        print("NLCR Database > no config or adapter is not specified, assuming SQLite database")
        cfg = { Adapter = "sqlite" }
    end

    NLCR.DB:SetModule(cfg.Adapter)
    NLCR.DB:Connect(cfg.Host, cfg.User, cfg.Password, cfg.DatabaseName, cfg.Port)
end

hook.Run("InitPostEntity", "NLCR.Database", function()
    Connect()
end)