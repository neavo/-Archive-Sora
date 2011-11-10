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
		Button:SetAlpha(0.3)
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		if i == 1 then
			Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", ActionBarDB.ButtonSize*8+3*8, 5)
		elseif ActionBarDB.MainBarLayout == 2 and i > 7 then
			Button:SetPoint("TOP", _G["PetActionButton"..i-1], "BOTTOM", 0, -5)
		else
			Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
		end
		Button:HookScript("OnEnter", function(self) 
			for i = 1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetAlpha(1) end
		end)
		Button:HookScript("OnLeave",function(self) 
			for i = 1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetAlpha(0.3) end
		end)
		RegisterStateDriver(Button, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
	end
end