-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ExtraActionBar")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:OnEvent(event, ...)
	if HasExtraActionBar() then
		self:Show()
		ExtraActionButton1:Show()
	else
		self:Hide()
	end
end

function Module:OnInitialize()
	Module:RegisterEvent("UPDATE_EXTRA_ACTIONBAR", "OnEvent")
	Module:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
end

function Module:OnEnable()
	ExtraActionBarFrame:SetParent(bar)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("BOTTOM", 0, 300)
	ExtraActionBarFrame.ignoreFramePositionManager = true

	ExtraActionButton1:SetSize(40, 40)
	Bar.button = ExtraActionButton1
	ExtraActionButton1.style:SetTexture(nil)
	hooksecurefunc(ExtraActionButton1.style, "SetTexture", function(style, texture)
		if not texture then return end
		if string.sub(texture,1,9) == "Interface" then
			style:SetTexture(nil)
		end
	end)
end