-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Stancebar")

function Module:OnEnable()
	ShapeshiftBarFrame:SetParent(DB.ActionBar)
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local Button = _G["ShapeshiftButton"..i]
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		if i == 1 then
			Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
		else
			Button:SetPoint("LEFT", _G["ShapeshiftButton"..i-1], "RIGHT", 3, 0)
		end
	end
	hooksecurefunc("ShapeshiftBar_Update", function()
		ShapeshiftButton1:ClearAllPoints()
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
	end)
end