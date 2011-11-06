-- Engines
local S, C, _, DB = unpack(select(2, ...))

-- Init
C.MoveHandle = {}

-- LoadSettings
function C.MoveHandle.LoadSettings()
	local Default = {
		["PlayerFrame"] = {"CENTER", "UIParent", "CENTER", -270, -100},
		["TargetFrame"] = {"CENTER", "UIParent", "CENTER", 270, -100},
		["FocusFrame"] = {"TOP", "UIParent", "TOP", 0, -100},
		["PartyFrame"] = {"TOPLEFT", "UIParent", "TOPLEFT", 10, -250},
		["RaidFrame"] = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -5, 5},
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
function C.MoveHandle.ResetToDefault()
	wipe(MoveHandleDB)
end

-- BuildGUI
function C.MoveHandle.BuildGUI() end