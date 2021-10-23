surface.CreateFont( "NLS_3DNick", {
	font = "Open Sans Bold",
	size = 70,
	weight = 500,
	entialias = true
} )

local function Get3DNickPos(ply)
	local attach = ply:LookupAttachment("anim_attachment_head")

	if attach <= 0 then
		return ply:GetPos() + Vector(0,0,90)
	end

	return ply:GetAttachment(attach).Pos + Vector(0,0,30)
end

local COLOR_TEXT_DEFAULT = Color(255,255,255)
local COLOR_OUTLINE = Color(0,0,0)

hook.Add( "PostPlayerDraw", "NLS_3DNick", function(ply, flags)
	if not IsValid(ply) then return end
	if not ply:Alive() then return end

	local plyTeam = ply:Team()
	local plyTeamName = team.GetName(plyTeam)
	if plyTeamName == "" then plyTeamName = "ЕГГОГ" end
	local plyTeamColor = team.GetColor(plyTeam) or Color(255,0,0)



	local pos = Get3DNickPos(ply)
	cam.Start3D2D( pos, Angle( 0, RenderAngles().y - 90, 90 ), 0.1 )
		draw.SimpleTextOutlined ( ply:Name(),
			"NLS_3DNick",  0, 0, COLOR_TEXT_DEFAULT,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT,
			1, COLOR_OUTLINE )

		draw.SimpleTextOutlined ( plyTeamName,
			"NLS_3DNick",  0, 60, plyTeamColor,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT,
			1, COLOR_OUTLINE )

		draw.SimpleTextOutlined ( NLS.Gamemodes.GetFancyName(ply),
			"NLS_3DNick",  0, 120, COLOR_TEXT_DEFAULT,
			TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT,
			1, COLOR_OUTLINE )
	cam.End3D2D()
end)

hook.Add("HUDDrawTargetID", "NLS_3DNick", function() return false end)