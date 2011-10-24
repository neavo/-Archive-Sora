-- Engines
local S, C, L, DB = unpack(select(2, ...))

DB.OptModules.Tooltip = {}

-- LoadSettings
function DB.OptModules.Tooltip.LoadSettings()
	local Default = {
		["Cursor"] = true,
		["HideInCombat"] = true,
	}
	if not TooltipDB then TooltipDB = {} end
	for key, value in pairs(Default) do
		if TooltipDB[key] == nil then TooltipDB[key] = value end
	end
end

-- ResetToDefault
function DB.OptModules.Tooltip.ResetToDefault()
	wipe(TooltipDB)
	C.Tooltip.LoadSettings()
end

-- BuildGUI
function DB.OptModules.Tooltip.BuildGUI()
	DB.OptTable["Tooltip"] =  {
		type = "group",
		name = "鼠标提示",
		args = {
			Cursor = {
				type = "toggle",
				name = "提示框体跟随鼠标",
				order = 1,
				get = function() return TooltipDB.Cursor end,
				set = function(_, value) TooltipDB.Cursor = value end,
			},
			HideInCombat = {
				type = "toggle",
				name = "进入战斗自动隐藏",
				order = 2,
				get = function() return TooltipDB.HideInCombat end,
				set = function(_, value) TooltipDB.HideInCombat = value end,
			},
		},
	}
end
