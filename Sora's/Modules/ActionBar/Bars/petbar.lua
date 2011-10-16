-- Engines
local S, _, _, DB = unpack(select(2, ...))

PetActionBarFrame:SetParent(DB.ActionBar)

for i=1, NUM_PET_ACTION_SLOTS do
	local Button = _G["PetActionButton"..i]
	Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOM", MultiBarBottomLeftButton6, "TOP", 0, 5)
	else
		local Pre = _G["PetActionButton"..i-1]      
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	end
	_G["PetActionButton"..i.."Cooldown"]:SetAllPoints(Button)
end

for i=1, NUM_PET_ACTION_SLOTS do
	local Button = _G["PetActionButton"..i]
	Button:SetAlpha(0.3)
	Button:HookScript("OnEnter", function(self) 
		for i = 1, NUM_PET_ACTION_SLOTS do
			local Button = _G["PetActionButton"..i]
			Button:SetAlpha(1)
		end
	end)
	Button:HookScript("OnLeave",function(self) 
		for i = 1, NUM_PET_ACTION_SLOTS do
			local Button = _G["PetActionButton"..i]
			Button:SetAlpha(0.3)
		end
	end)
end 