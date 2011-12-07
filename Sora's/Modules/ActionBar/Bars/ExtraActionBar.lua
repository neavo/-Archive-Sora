-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ExtraActionBar")

local _, _, _, uiVersion = GetBuildInfo()
if uiVersion ~= 40300 then return end

function Module:OnEnable()

	local Bar = CreateFrame("Frame","rABS_ExtraActionBar",UIParent, "SecureHandlerStateTemplate")
	Bar:SetSize(40, 40)
	Bar:SetPoint("BOTTOM", 0, 350)
	Bar:SetAllPoints(AnchorExtraBossBar)

	ExtraActionBarFrame:SetParent(Bar)
	ExtraActionBarFrame:SetAllPoints()

	UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
	ExtraActionButton1.noResize = true
	
	local Button = ExtraActionButton1
	local Icon = Button.icon
	local Texture = Button.style

	Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Icon:SetPoint("TOPLEFT", Button, 2, -2)
	Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)

	Texture:SetTexture("")
	
	Button:SetSize(30, 30)

	StyleButton(Button, true)
	S.MakeShadow(Button, 4)
end

hooksecurefunc(texture, "SetTexture", function(style, texture)
	if string.sub(texture,1,9) == "Interface" then
		style:SetTexture("")
	end
end)