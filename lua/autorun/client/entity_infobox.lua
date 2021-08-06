local disappearTime  = CreateClientConVar("entityinfobox_disappeartime", "0.8", true, false, "Time it takes the InfoBox to disappear (seconds)")
local animationSpeed = CreateClientConVar("entityinfobox_animationspeed", "5", true, false, "Divisor of the animation speed (the higher the slower animation speed)")

-- override the FPP HUD display
if ConVarExists("FPP_PrivateSettings_HideOwner") then
    GetConVar("FPP_PrivateSettings_HideOwner"):SetBool(true)
end


local round = math.Round
local font = "HudHintTextLarge"


local icons = {
    [1] = Material("icon16/user.png"),
    [2] = Material("icon16/package.png"),
    [3] = Material("icon16/brick.png"),
    [4] = Material("icon16/paintcan.png"),
    [5] = Material("icon16/color_wheel.png"),
    [6] = Material("icon16/picture_edit.png"),
    [7] = Material("icon16/arrow_in.png"),
    [8] = Material("icon16/arrow_rotate_clockwise.png"),
    
    ["disconnected"] = Material("icon16/user_female.png"),
    ["blocked"]      = Material("icon16/cross.png"),
    ["shared"]       = Material("icon16/group.png"),
    ["world"]        = Material("icon16/world.png"),
    ["buddy"]        = Material("icon16/user_green.png"),
}

local touchTypes = {
    ["weapon_physgun"]    = "Physgun",
    ["weapon_physcannon"] = "Gravgun",
    ["gmod_tool"]         = "Toolgun",
}

local data = {
    display = {},
    
    width    = 0,
    height   = 0,
    
    lastSeen = 0,
}


-- FPP's way of getting owner and reason like Buddy (Player), world, blocked, etc.
local function getFPPOwner(ply, ent)
    local weapon = ply:GetActiveWeapon()
    local class = IsValid(weapon) and weapon:GetClass() or ""

    local touchType = touchTypes[class] or "EntityDamage"
    local reason = FPP.entGetTouchReason(ent, touchType)
    
    if not reason then return "<invalid>" end
    
    local originalOwner = ent:GetNW2String("FPP_OriginalOwner")
    if originalOwner ~= "" then
        reason = reason .. " (previous owner: "..originalOwner..")"
    end

    return reason
end

-- only update in certain cases like looking at new prop or on weapon change
local function updateDataStatic(ply, ent)
    data.entity = ent
    
    local owner = getFPPOwner(ply, ent)
    local model = ent:GetModel()
    local skin  = ent:GetSkin()
    local color = ent:GetColor()
    local mat   = ent:GetMaterial() ~= '' and ent:GetMaterial() or not ent:IsNPC() and ent:GetMaterials()[1] or nil; mat = mat and table.remove(string.Explode("/", mat))
    
    data.display[1] = owner
    data.display[2] = string.format("%s [%s]", ent:GetClass(), ent:EntIndex())
    data.display[3] = string.sub(model, 1, 1) ~= "*" and string.sub(table.remove(string.Explode("/", model)), 1, -5) or nil
    data.display[4] = (mat ~= data.display[3]) and mat or nil
    data.display[5] = (color.r ~= 255 or color.g ~= 255 or color.b ~= 255) and string.format("%s, %s, %s", color.r, color.g, color.b) or nil
    data.display[6] = skin ~= 0 and skin or nil
    
    -- additional icons for ownership and accesibility
    if     owner == "world"                   then data.icon = "world"
    elseif owner == "disconnected"            then data.icon = "disconnected"
    elseif owner == "blocked"                 then data.icon = "blocked"
    elseif owner == "shared"                  then data.icon = "shared"
    elseif string.sub(owner, 1, 5) == "Buddy" then data.icon = "buddy"
    else data.icon = nil -- default
    end
end

-- dynamic data like color, mat, pos to avoid shit tons of checks on when to update
local function updateDataDynamic(ent)
    local pos   = ent:GetPos()
    local ang   = ent:GetAngles()
    local p,y,r = round(ang.p), round(ang.y), round(ang.r)
    
    data.display[7] = string.format("%s, %s, %s", round(pos.x), round(pos.y), round(pos.z))
    data.display[8] = (p ~= 0 or y ~= 0 or r ~= 0) and string.format("%s, %s, %s", p, y, r)
end


local function displayIcon(id, x, y)
    local mat = id
    
    -- select custom icon
    if id == 1 and data.icon then
        id = data.icon
    end
    
    surface.SetMaterial(icons[id])
    surface.DrawTexturedRect(x, y, 16, 16)
end


-- needed to display correct touch permissions, i.e. by default you can hit world objects but not pick them up
hook.Add("PlayerSwitchWeapon", "EntityInfobox_PlayerSwitchWeapon", function(ply, old, new)
    data.doUpdate = true
end)


local spacing = 20
local dynWidth, dynHeight = 0, 0

hook.Add("HUDPaint", "EntityInfobox_HUDPaint", function()
    local ply = LocalPlayer()
    local ent = data.entity
    local traceEnt = ply:GetEyeTraceNoCursor().Entity
    
    -- update static properties
    if traceEnt ~= ent or data.doUpdate then
        if IsValid(traceEnt) and not traceEnt:IsPlayer() then
            updateDataStatic(ply, traceEnt)
        end
        
        data.doUpdate = false
    else
        data.lastSeen = CurTime()
    end
    
    -- additional update of static data when pointing at the same prop after looking away
    if traceEnt:IsWorld() then
        data.doUpdate = true
    end
    
    -- update dynamic properties as long as the ent is valid
    if IsValid(ent) then updateDataDynamic(ent) end
    
    -- keep the box shown a little longer
    if data.lastSeen < CurTime() - disappearTime:GetFloat() then
        data.width = 0
        data.height = 0
    end
    
    -- animate the container width and height
    local divisor = animationSpeed:GetFloat()
    divisor = divisor < 1 and 1 or divisor
    
    dynWidth = dynWidth + (data.width - dynWidth)/divisor
    dynHeight = dynHeight + (data.height - dynHeight)/divisor
    
    -- stop drawing when container collapsed
    if (dynWidth == 0 or dynHeight == 0) and traceEnt ~= ent then return end
    
    
    local scrw, scrh = ScrW(), ScrH()
    
    -- container
    draw.RoundedBox(4, scrw-dynWidth, scrh/2 - 208, dynWidth, dynHeight, Color(0,0,0,150))
    
    -- stencil start
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
    render.SetStencilCompareFunction( STENCIL_EQUAL )
    
    -- stencil box
	render.ClearStencilBufferRectangle( scrw-dynWidth, scrh/2 - 208, scrw, scrh/2 - 208 + dynHeight, 1 )
    
    -- display data
    surface.SetFont(font)
    surface.SetDrawColor(255, 255, 255, 255)
    
    -- width won't get smaller than this
    local y, width = 0, 32
    
    for k, v in pairs(data.display) do
        if v then
            
            draw.DrawText(v, font, scrw - 32, spacing/2 - 8 + scrh/2 - 198 + y*spacing, Color(255,255,255,255), TEXT_ALIGN_RIGHT)
            displayIcon(k, scrw - 24, 4 + scrh/2 - 200 + y*spacing)
            
            -- measure the containter width
            local w = surface.GetTextSize(v)
            if w > width then
                width = w
            end
            
            y = y + 1
        end
    end
    
    -- update container based on the contents
    data.height = y*spacing+16
    data.width = width + 42
    
    -- stencil end
    render.SetStencilEnable( false )
    
end)
