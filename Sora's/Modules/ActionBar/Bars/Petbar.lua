-- Engines
local _, _, _, DB = unpack(select(2, ...))
PetActionBarFrame:ClearAllPoints()
PetActionBarFrame.SetPoint = function() end

for i = 1, NUM_PET_ACTION_SLOTS do
	local Button = _G["PetActionButton"..i]
	Button:ClearAllPoints()
	Button:SetParent(DB.ActionBar)
	Button:SetAlpha(0.3)
	Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
	if ActionBarDB.MainBarLayout == 1 then
		if i == 1 then
			Button:SetPoint("BOTTOM", MultiBarBottomLeftButton6, "TOP", 0, 5)
		else
			Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
		end
	elseif ActionBarDB.MainBarLayout == 2 then
		if i == 1 then
			Button:SetPoint("BOTTOM", MultiBarBottomRightButton1, "TOP", 0, 5)
		else
			Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
		end
	end
	Button:HookScript("OnEnter", function(self) 
		for i = 1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetAlpha(1) end
	end)
	Button:HookScript("OnLeave",function(self) 
		for i = 1, NUM_PET_ACTION_SLOTS do _G["PetActionButton"..i]:SetAlpha(0.3) end
	end)
	RegisterStateDriver(Button, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
end
