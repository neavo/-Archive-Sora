local bar = CreateFrame("Frame","rABS_VehicleExit",UIParent, "SecureHandlerStateTemplate")
bar:SetHeight(36)
bar:SetWidth(36)
bar:SetPoint("CENTER", ActionButton8, "CENTER", 0, 0)

local veb = CreateFrame("BUTTON", nil, bar, "SecureActionButtonTemplate");
veb:SetAllPoints(bar)
veb:RegisterForClicks("AnyUp")
veb:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
veb:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
veb:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
veb:SetScript("OnClick", function(self)
	VehicleExit()
end)

veb:RegisterEvent("PLAYER_REGEN_ENABLED")
veb:RegisterEvent("UNIT_ENTERING_VEHICLE")
veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
veb:RegisterEvent("UNIT_EXITING_VEHICLE")
veb:RegisterEvent("UNIT_EXITED_VEHICLE")
veb:SetScript("OnEvent", function(self,event,...)
	local arg1 = ...
	if (event=="UNIT_ENTERING_VEHICLE" or event=="UNIT_ENTERED_VEHICLE") and arg1 == "player" then
		veb:Show()
		veb:SetAlpha(1)
	elseif (event=="UNIT_EXITING_VEHICLE" or event=="UNIT_EXITED_VEHICLE" or event == "PLAYER_REGEN_ENABLED") and arg1 == "player" then
		veb:SetAlpha(0)
		veb:Hide()
	end
end)  
veb:SetAlpha(0)
veb:Hide()