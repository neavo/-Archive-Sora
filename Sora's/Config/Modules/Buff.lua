-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Buff"] = {}
local Module = DB["Modules"]["Buff"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["IconSize"] = 24,
		["Spacing"] = 8,
		["IconsPerRow"] = 12,
		["BuffDirection"] = 1,
		["DebuffDirection"] = 1,
		["WarningTime"] = 15,
	}
	if not BuffDB then BuffDB = {} end
	for key, value in pairs(Default) do
		if BuffDB[key] == nil then BuffDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(BuffDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Buff"] =  {
			type = "group", order = 4,
			name = "增益效果",
			args = {
				IconSize = {
					type = "input",
					name = "图标大小：",
					desc = "请输入图标大小",
					order = 1,
					get = function() return tostring(BuffDB.IconSize) end,
					set = function(_, value) BuffDB.IconSize = tonumber(value) end,
				},
				BuffDirection = {
					type = "select",
					name = "BUFF增长方向：",
					desc = "请选择BUFF增长方向",
					order = 2,
					values = {[1] = "从右向左", [2] = "从左向右"},
					get = function() return BuffDB.BuffDirection end,
					set = function(_, value) BuffDB.BuffDirection = value end,
				},
				DebuffDirection = {
					type = "select",
					name = "DEBUFF增长方向：",
					desc = "请选择DEBUFF增长方向",
					order = 3,
					values = {[1] = "从右向左", [2] = "从左向右"},
					get = function() return BuffDB.DebuffDirection end,
					set = function(_, value) BuffDB.DebuffDirection = value end,
				},
			},
		}
	end
end





