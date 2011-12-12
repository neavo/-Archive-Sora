-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Petbar")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:OnInitialize()
	C = ActionBarDB
	PetActionBarFrame:SetParent(Bar)
	PetActionBarFrame:EnableMouse(false)
end

function Module:OnEnable()
	local Button, Cooldown = nil, nil
	
	for i = 1, NUM_PET_ACTION_SLOTS do
		Button = _G["PetActionButton"..i]
		Button:ClearAllPoints()
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		
		if C["MainBarLayout"] == 1 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", C["ButtonSize"]*8+3*8, 5)
			else
				Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
			end
		end
		if C["MainBarLayout"] == 2 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", C["ButtonSize"]*6+3*6, 5)
			elseif i > 7 then
				Button:SetPoint("TOP", _G["PetActionButton"..i-1], "BOTTOM", 0, -5)
			else
				Button:SetPoint("LEFT", _G["PetActionButton"..i-1], "RIGHT", 3, 0)
			end
		end
		
		_G["PetActionButton"..i.."Cooldown"]:SetAllPoints(Button)
	end
end