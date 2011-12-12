-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Stancebar")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
  
function Module:OnInitialize()
	C = ActionBarDB
	ShapeshiftBarFrame:SetParent(Bar)
	ShapeshiftBarFrame:EnableMouse(false)
end

function Module:OnEnable()
	local Button = nil
	
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		Button = _G["ShapeshiftButton"..i]
		Button:ClearAllPoints()
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		if i == 1 then
			Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
		else
			Button:SetPoint("LEFT", _G["ShapeshiftButton"..i-1], "RIGHT", 3, 0)
		end
	end
	
	hooksecurefunc("ShapeshiftBar_Update", function()
		ShapeshiftButton1:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
	end)
end