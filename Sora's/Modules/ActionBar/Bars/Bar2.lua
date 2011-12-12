-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar2")

function Module:OnInitialize()
	C = ActionBarDB
	MultiBarBottomLeft:SetParent(DB.ActionBar)
end

function Module:OnEnable()
	local Button = nil
	for i = 1, 12 do
		Button = _G["MultiBarBottomLeftButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if i == 1 then
			Button:SetPoint("BOTTOM", ActionButton1, "TOP", 0, 5)
		else
			Button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", 3, 0)
		end
	end
end