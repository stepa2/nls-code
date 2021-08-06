--[[

SUI Scoreboard v2.6 by .Z. Dathus [BR] is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
----------------------------------------------------------------------------------------------------------------------------
Copyright (c) 2014 - 2021 .Z. Dathus [BR] <http://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US.
----------------------------------------------------------------------------------------------------------------------------
This Addon is based on the original SUI Scoreboard v2 developed by suicidal.banana.
Copyright only on the code that I wrote, my implementation and fixes and etc, The Initial version (v2) code still is from suicidal.banana.
----------------------------------------------------------------------------------------------------------------------------

$Id$
Version 2.6.3 - 2021-07-01 06:14 PM(UTC -03:00)

]]--

include( "admin_buttons.lua" )

local PANEL = {}

surface.CreateFont(  "suiscoreboardcardinfo", { font = "DefaultSmall", size = 12, weight = 0, antialiasing = true} )

--- Init
function PANEL:Init()
	self.InfoLabels = {}
	self.InfoLabels[ 1 ] = {}
	self.InfoLabels[ 2 ] = {}
	self.InfoLabels[ 3 ] = {}

	self.btnKick = vgui.Create( "suiplayerkickbutton", self )
	self.btnBan = vgui.Create( "suiplayerbanbutton", self )
	self.btnPBan = vgui.Create( "suiplayerpermbanbutton", self )
end

--- SetInfo
function PANEL:SetInfo( column, k, v )
	if not v or v == "" then v = "N/A" end

	if not self.InfoLabels[ column ][ k ] then
		self.InfoLabels[ column ][ k ] = {}
		self.InfoLabels[ column ][ k ].Key 	= vgui.Create( "DLabel", self )
		self.InfoLabels[ column ][ k ].Value 	= vgui.Create( "DLabel", self )
		self.InfoLabels[ column ][ k ].Key:SetText( k )
		self.InfoLabels[ column ][ k ].Key:SetColor(Color(0,0,0,255))
		self.InfoLabels[ column ][ k ].Key:SetFont("suiscoreboardcardinfo")
		self:InvalidateLayout()
	end

	self.InfoLabels[ column ][ k ].Value:SetText( v )
	self.InfoLabels[ column ][ k ].Value:SetColor(Color(0,0,0,255))
	self.InfoLabels[ column ][ k ].Value:SetFont("suiscoreboardcardinfo")
	return true
end

--- SetPlayer
function PANEL:SetPlayer( ply )
	self.Player = ply
	self:UpdatePlayerData()
end

--- UpdatePlayerData
function PANEL:UpdatePlayerData()
	if not self.Player then return end
	if not self.Player:IsValid() then return end

	self:SetInfo( 1, "Пропы:", self.Player:GetCount( "props" ) )
	self:SetInfo( 1, "HoverBall'ы:", self.Player:GetCount( "hoverballs" ) )
	self:SetInfo( 1, "Thruster'ы:", self.Player:GetCount( "thrusters" ) )
	self:SetInfo( 1, "Шарики:", self.Player:GetCount( "balloons" ) )
	self:SetInfo( 1, "Кнопки:", self.Player:GetCount( "buttons" ) )
	self:SetInfo( 1, "Взывчатка:", self.Player:GetCount( "dynamite" ) )
	self:SetInfo( 1, "SENTs:", self.Player:GetCount( "sents" ) )

	self:SetInfo( 2, "Рэгдоллы:", self.Player:GetCount( "ragdolls" ) )
	self:SetInfo( 2, "Эффекты:", self.Player:GetCount( "effects" ) )
	self:SetInfo( 2, "Транспорт:", self.Player:GetCount( "vehicles" ) )
	self:SetInfo( 2, "NPC:", self.Player:GetCount( "npcs" ) )
	self:SetInfo( 2, "Эмиттеры:", self.Player:GetCount( "emitters" ) )
	self:SetInfo( 2, "Лампы:", self.Player:GetCount( "lamps" ) )
	self:SetInfo( 2, "Спавнеры:", self.Player:GetCount( "spawners" ) )

	self:InvalidateLayout()
end

--- ApplySchemeSettings
function PANEL:ApplySchemeSettings()
	for _k, column in pairs( self.InfoLabels ) do
		for k, v in pairs( column ) do
				v.Key:SetFGColor( 50, 50, 50, 255 )
				v.Value:SetFGColor( 80, 80, 80, 255 )
		end
	end
end

--- Think
function PANEL:Think()
	if self.PlayerUpdate and self.PlayerUpdate > CurTime() then return end
	self.PlayerUpdate = CurTime() + 0.25

	self:UpdatePlayerData()
end

--- PerformLayout
function PANEL:PerformLayout()
	local x = 5

	for column, column in pairs( self.InfoLabels ) do

		local y = 0
		local RightMost = 0

		for k, v in pairs( column ) do
			v.Key:SetPos( x, y )
			v.Key:SizeToContents()

			v.Value:SetPos( x + 60 , y )
			v.Value:SizeToContents()

			y = y + v.Key:GetTall() + 2

			RightMost = math.max( RightMost, v.Value.x + v.Value:GetWide() )
		end

		if x<100 then
			x = x + 205
		else
			x = x + 115
		end
	end

	if not LocalPlayer():IsAdmin() then
		self.btnKick:SetVisible( false )
		self.btnBan:SetVisible( false )
		self.btnPBan:SetVisible( false )
	else
		self.btnKick:SetVisible( true )
		self.btnBan:SetVisible( true )
		self.btnPBan:SetVisible( true )

		self.btnKick:SetPos( self:GetWide() - 46 - 4, 85 - (22 * 2) )
		self.btnKick:SetSize( 46, 20 )

		self.btnBan:SetPos( self:GetWide() - 46 - 4, 85 - (22 * 1) )
		self.btnBan:SetSize( 46, 20 )

		self.btnPBan:SetPos( self:GetWide() - 46 - 4, 85 - (22 * 0) )
		self.btnPBan:SetSize( 46, 20 )

		self.btnKick.DoClick = function () Scoreboard.kick( self.Player ) end
		self.btnPBan.DoClick = function () Scoreboard.pBan( self.Player ) end
		
		self.btnBan.DoClick = function () Scoreboard.ban( self.Player ) end
	end
end

--- Paint
function PANEL:Paint(w,h)
	return true
end

vgui.Register( "suiscoreplayerinfocard", PANEL, "Panel" )
