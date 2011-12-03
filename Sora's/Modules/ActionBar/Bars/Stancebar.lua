-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Stancebar", "AceEvent-3.0")
local Stancebar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
}

function Module:OnInitialize()
	C = ActionBarDB
	Module:RegisterEvent("PLAYER_LOGIN")
	Module:RegisterEvent("PLAYER_ENTERING_WORLD", StyleShift)
	Module:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	Module:RegisterEvent("UPDATE_SHAPESHIFT_USABLE", ShiftBarUpdate)
	Module:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN", ShiftBarUpdate)
	Module:RegisterEvent("UPDATE_SHAPESHIFT_FORM", ShiftBarUpdate)
	Module:RegisterEvent("ACTIONBAR_PAGE_CHANGED", ShiftBarUpdate)
end

function Module:PLAYER_LOGIN(self, event, ...)
	local Button = nil
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		Button = _G["ShapeshiftButton"..i]
		Button:ClearAllPoints()
		Button:SetParent(Stancebar)
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		if i == 1 then
			Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
		else
			Button:SetPoint("LEFT", _G["ShapeshiftButton"..i-1], "RIGHT", 3, 0)
		end
		local _, name = GetShapeshiftFormInfo(i)
		if name then
			Button:Show()
		end
	end
	RegisterStateDriver(Stancebar, "visibility", States[DB.MyClass] or "hide")
end

function Module:UPDATE_SHAPESHIFT_FORMS(self, event, ...)
	if InCombatLockdown() then return end 
	local button
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		local _, name = GetShapeshiftFormInfo(i)
		if name then
			button:Show()
		else
			button:Hide()
		end
	end
	ShiftBarUpdate()
end