-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar2")

function Module:OnEnable()
	MultiBarBottomLeft:SetParent(DB.ActionBar)
	MultiBarBottomLeft:ClearAllPoints()
	MultiBarBottomLeft.SetPoint = function() end
	for i = 1, 12 do
		local Button = _G["MultiBarBottomLeftButton"..i]
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		if i == 1 then
			Button:SetPoint("BOTTOM", ActionButton1, "TOP", 0, 5)
		else
			Button:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", 3, 0)
		end
	end
end