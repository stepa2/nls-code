surface.CreateFont( "bigHud", {
	font = "Open Sans Bold",
	size = 70,
	weight = 500,
	entialias = true
} )

local function nameTop ( ply )

	if !IsValid ( ply ) then return end
	
	local color = team.GetColor ( ply:Team() )
	
	cam.Start3D2D( ply:GetPos() + Vector( 0, 0, 85), Angle( 0, RenderAngles().y - 90, 90 ), 0.1 )
		draw.SimpleTextOutlined ( ply:Name(), "bigHud", 0, 0, color, TEXT_ALIGN_CENTER, 0, 2, Color( 255, 255, 255, 255 ) )
	cam.End3D2D()

end

hook.Add( "PostPlayerDraw", "nameTop", nameTop )