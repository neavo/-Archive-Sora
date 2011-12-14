-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ExtraActionBar", "AceEvent-3.0")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:OnInitialize()
	Bar:SetPoint("BOTTOM", 0, 250)
	Bar:SetSize(ExtraActionBarFrame:GetSize())
	
	ExtraActionBarFrame:SetParent(Bar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER")
		
	UIPARENT_MANAGED_FRAME_POSITIONS.ExtraActionBarFrame = nil
	UIPARENT_MANAGED_FRAME_POSITIONS.PlayerPowerBarAlt.extraActionBarFrame = nil
	
	if UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame then
		UIPARENT_MANAGED_FRAME_POSITIONS.CastingBarFrame.extraActionBarFrame = nil
	end
end