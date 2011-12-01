-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["MoveHandle"] = {}
local Module = DB["Modules"]["MoveHandle"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Player"] = {"CENTER", "UIParent", "CENTER", -270, -100},
		["Pet"] = {"CENTER", "UIParent", "CENTER", -420, -130},
		["PlayerCastbar"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 115},
		["Target"] = {"CENTER", "UIParent", "CENTER", 270, -100},
		["TargetTarget"] = {"CENTER", "UIParent", "CENTER", 420, -130},
		["TargetCastbar"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 140},
		["Focus"] = {"TOP", "UIParent", "TOP", 0, -100},
		["Raid"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -5, 5},
		["BossFrame"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -50, -200},
		["ActionBar"] = {"BOTTOM", "UIParent", "BOTTOM", 0, 20},
		["LeftBar"] = {"LEFT", "UIParent", "LEFT", 5, 0},
		["RightBar"] = {"RIGHT", "UIParent", "RIGHT", -5, 0},
		["Buff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -5},
		["Debuff"] = {"TOPRIGHT", "UIParent", "TOPRIGHT", -5, -140},
		["Minimap"] = {"TOPLEFT", "UIParent", "TOPLEFT", 10, -30},
		["ChatFrame"] = {"BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 5, 25},
		["InfoPanel"] = {"TOP", "UIParent", "TOP", 0, -10},
	}
	if not MoveHandleDB then MoveHandleDB = {} end
	for key, value in pairs(Default) do
		if MoveHandleDB[key] == nil then MoveHandleDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(MoveHandleDB)
end

-- BuildGUI
function Module.BuildGUI() end