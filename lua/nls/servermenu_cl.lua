language.Add("NLS_Category_Modes", "Режимы")
language.Add("NLS_CategoryMode_Build", "Режим строительства")
language.Add("NLS_CategoryMode_PVP", "Режим боя (PVP)")
language.Add("NLS_CategoryMode_RP", "Ролевой режим (RP)")

language.Add("NLS_Mode_Build_Desc", "В режиме строительства доступна возможность полёта, невозможно получать и наносить урон.")
language.Add("NLS_Mode_Build_Switch", "Переключиться в режим строительства")

language.Add("NLS_Mode_PVP_Desc", [[
В режиме боя отсуствует возможность полёта (noclip), можно получать и наносить урон.
TODO: про бой без правил
]])
language.Add("NLS_Mode_PVP_Switch", "Переключиться в режим боя")

language.Add("NLS_Mode_RP_Switch", "Переключиться в ролевой режим")
language.Add("NLS_Mode_RP_Desc", "Ролевой режим")

language.Add("NLS_Category_Info", "Информация")
language.Add("NLS_CategoryInfo_Links", "Ссылки")

hook.Add("AddToolMenuTabs", "NLS_Servermenu", function()
    spawnmenu.AddToolTab("aNLS", "#SERVER_NAME", "icon16/server.png")
end)

hook.Add("AddToolMenuCategories", "NLS_Servermenu", function()
    spawnmenu.AddToolCategory("aNLS", "Modes", "#NLS_Category_Modes")
    spawnmenu.AddToolCategory("aNLS", "Info", "#NLS_Category_Info")
end)

hook.Add("PopulateToolMenu", "NLS_Servermenu", function()
    spawnmenu.AddToolMenuOption("aNLS", "Modes", "Build", "#NLS_CategoryMode_Build", nil, nil, function(panel)
        panel:Help("#NLS_Mode_Build_Desc")
        panel:Button("#NLS_Mode_Build_Switch", "nls_changemode", "BUILD")
    end)

    spawnmenu.AddToolMenuOption("aNLS", "Modes", "PVP", "#NLS_CategoryMode_PVP", nil, nil, function(panel)
        panel:Help("#NLS_Mode_PVP_Desc")
        panel:Button("#NLS_Mode_PVP_Switch", "nls_changemode", "PVP")
    end)

    spawnmenu.AddToolMenuOption("aNLS", "Modes", "RP", "#NLS_CategoryMode_RP", nil, nil, function(panel)
        panel:Help("#NLS_Mode_RP_Desc")
        panel:Button("#NLS_Mode_RP_Switch", "nls_changemode", "RP")
        --panel:Button("#NLS_Mode_RP_CreateSession")
    end)

    spawnmenu.AddToolMenuOption("aNLS", "Info", "Links", "#NLS_CategoryInfo_Links", nil, nil, function(panel)
        panel:Button("Discord-группа").DoClick = function(self)
            gui.OpenURL("https://discord.gg/pPaeQpE5Xd")
        end

        panel:Button("Коллекция сервера").DoClick = function(self)
            gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2541972502")
        end

        panel:Button("Правила сервера").DoClick = function(self)
            gui.OpenURL("https://docs.google.com/document/d/14gc3uAComDs2fsUPW0Z1gBRWF7TVXRmdWvHAJ99Z-go")
        end
    end)
end)