-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Petbar")

function Module:OnEnable()
	PetActionBarFrame:ClearAllPoints()
	PetActionBarFrame.SetPoint = function() end
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		Button:ClearAllPoints()
		Button:SetParent(DB.ActionBar)
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		if ActionBarDB.MainBarLayout == 1 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", ActionBarDB.ButtonSize*8+3*8, 5)
			else
				Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
			end
		end
		if ActionBarDB.MainBarLayout == 2 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", ActionBarDB.ButtonSize*6+3*6, 5)
			elseif i > 7 then
				Button:SetPoint("TOP", _G["PetActionButton"..i-1], "BOTTOM", 0, -5)
			else
				Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
			end
		end
		RegisterStateDriver(Button, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
	end
end