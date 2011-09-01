local bar = CreateFrame("Frame","rABS_PetBar",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(24*NUM_PET_ACTION_SLOTS+1*(NUM_PET_ACTION_SLOTS-1))
bar:SetHeight(24)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 52, 111)
PetActionBarFrame:SetParent(bar)
PetActionBarFrame:EnableMouse(false)

for i=1, NUM_PET_ACTION_SLOTS do
	local button = _G["PetActionButton"..i]
	local cd = _G["PetActionButton"..i.."Cooldown"]
		button:SetSize(24, 24)
		button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["PetActionButton"..i-1]      
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
	cd:SetAllPoints(button)
end

local function lighton(alpha)
	if PetActionBarFrame:IsShown() then
		for i=1, NUM_PET_ACTION_SLOTS do
			local pb = _G["PetActionButton"..i]
			pb:SetAlpha(alpha)
		end
	end
end    
bar:EnableMouse(true)
bar:SetScript("OnEnter", function(self) lighton(1) end)
bar:SetScript("OnLeave", function(self) lighton(0.3) end)  
for i=1, NUM_PET_ACTION_SLOTS do
	local pb = _G["PetActionButton"..i]
	pb:SetAlpha(0.3)
	pb:HookScript("OnEnter", function(self) lighton(1) end)
	pb:HookScript("OnLeave", function(self) lighton(0.3) end)
end 