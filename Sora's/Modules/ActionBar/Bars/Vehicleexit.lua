-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Vehicleexit")

function Module:OnEnable()
	local VehicleExitButton = CreateFrame("Button", nil, UIParent, "SecureHandlerClickTemplate")
	VehicleExitButton:SetPoint("TOPLEFT", ActionButton8, -3, 3)
	VehicleExitButton:SetPoint("BOTTOMRIGHT", ActionButton8, 3, -3)
	VehicleExitButton:SetNormalTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	VehicleExitButton:SetPushedTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	VehicleExitButton:SetHighlightTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	VehicleExitButton:SetFrameStrata(ActionButton8:GetFrameStrata())
	VehicleExitButton:SetFrameLevel(ActionButton8:GetFrameLevel()+1)
	VehicleExitButton:RegisterForClicks("AnyUp")
	VehicleExitButton:SetScript("OnClick", function() VehicleExit() end)
	RegisterStateDriver(VehicleExitButton, "visibility", "[target=vehicle,exists] show;hide")
end