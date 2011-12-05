-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Petbar", "AceEvent-3.0")
local PetBar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:OnInitialize()
	C = ActionBarDB
	Module:RegisterEvent("PLAYER_LOGIN")
	Module:RegisterEvent("PLAYER_CONTROL_LOST", PetBarUpdate)
	Module:RegisterEvent("PLAYER_CONTROL_GAINED", PetBarUpdate)
	Module:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED", PetBarUpdate)
	Module:RegisterEvent("PET_BAR_UPDATE", PetBarUpdate)
	Module:RegisterEvent("PET_BAR_UPDATE_COOLDOWN", PetActionBar_UpdateCooldowns)
	Module:RegisterEvent("UNIT_PET")
	Module:RegisterEvent("UNIT_FLAGS", PetBarUpdate)
	Module:RegisterEvent("UNIT_AURA")
end

function Module:PLAYER_LOGIN(self, event, ...)
	PetActionBarFrame.showgrid = 1 
	local Button = nil		
	for i = 1, 10 do
		Button = _G["PetActionButton"..i]
		Button:ClearAllPoints()
		Button:SetParent(PetBar)
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
		Button:Show()
		PetBar:SetAttribute("addchild", Button)
	end
	StylePet()
	RegisterStateDriver(PetBar, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
	hooksecurefunc("PetActionBar_Update", PetBarUpdate)
end

function Module:UNIT_PET(self, event, ...)
	if ... == "player" then
		PetBarUpdate()
	end
end

function Module:UNIT_AURA(self, event, ...)
	if ... == "player" then
		PetBarUpdate()
	end
end