-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["ClassTimer"] = {}
local Module = DB["Modules"]["ClassTimer"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["PlayerMode"] = "Icon",
			["PlayerLimit"] = 60,
		["TargetMode"] = "Bar",
			["TargetLimit"] = 60,
		["BlackListEnable"] = false,
			["BlackList"] = {},
	}
	if not ClassTimerDB then ClassTimerDB = {} end
	for key, value in pairs(Default) do
		if ClassTimerDB[key] == nil then ClassTimerDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ClassTimerDB)
end

-- BuildGUI
local BlackListTable = {}
local function UpdateBlackListTable()
	wipe(BlackListTable)
	for key, value in pairs(ClassTimerDB["BlackList"]) do
		if value then
			BlackListTable[key] = {
				type = "toggle",
				name = key, desc = "启用/禁用",
				get = function() return value end,
				set = function(_, val)
					ClassTimerDB["BlackList"][key] = val
					UpdateBlackListTable()
				end,
			}
		end
	end
end
function Module.BuildGUI()
	UpdateBlackListTable()
	if DB["Config"] then
		DB["Config"]["ClassTimer"] =  {
			type = "group", order = 6,
			name = "法术计时", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						PlayerMode = {
							type = "select", order = 1,
							name = "玩家增益计时模式：", desc = "请选择玩家增益计时模式：",
							values = {["Bar"] = "计时条模式", ["Icon"] = "图标模式", ["None"] = "无"},
							get = function() return ClassTimerDB["PlayerMode"] end,
							set = function(_, value)
								ClassTimerDB["PlayerMode"] = value
								Sora:GetModule("ClassTimer"):ClearPlayerAura()
							end,
						},
						PlayerLimit = {
							type = "range", order = 2,
							name = "玩家增益计时阈值：", desc = "请输入玩家增益计时阈值",
							min = 0, max = 600, step = 1, width = "double",
							get = function() return ClassTimerDB["PlayerLimit"] end,
							set = function(_, value) ClassTimerDB["PlayerLimit"] = value end,
						},
						TargetMode = {
							type = "select", order = 3,
							name = "目标减益计时模式：", desc = "请选择目标减益计时模式：",
							values = {["Bar"] = "计时条模式", ["Icon"] = "图标模式", ["None"] = "无"},
							get = function() return ClassTimerDB["TargetMode"] end,
							set = function(_, value)
								ClassTimerDB["TargetMode"] = value
								Sora:GetModule("ClassTimer"):ClearTargetAura()
							end,
						}, 
						TargetLimit = {
							type = "range", order = 4,
							name = "目标减益计时阈值：", desc = "请输入目标减益计时阈值",
							min = 0, max = 600, step = 1, width = "double",
							get = function() return ClassTimerDB["TargetLimit"] end,
							set = function(_, value) ClassTimerDB["TargetLimit"] = value end,
						},
					},
				}, 
				Gruop_2 = {
					type = "group", order = 2, 
					name = " ", guiInline = true, 
					args = {
						BlackListEnable = {
							type = "toggle", order = 1,
							name = "启用黑名单",
							get = function() return ClassTimerDB["BlackListEnable"] end,
							set = function(_, value) ClassTimerDB["BlackListEnable"] = value end,
						},
						BlackListNew = {
							type = "input", order = 2,
							name = "添加新条目",
							disabled = not ClassTimerDB["BlackListEnable"],
							get = function() return "无" end,
							set = function(_, value)
								local Name = GetSpellInfo(tonumber(value))
								ClassTimerDB["BlackList"][Name] = true
								UpdateBlackListTable()
							end,
						}, 
					}, 
				}, 
				Gruop_3 = {
					type = "group", order = 3, 
					name = "黑名单", guiInline = true, 
					disabled = not ClassTimerDB["BlackListEnable"],	
					args = BlackListTable,
				}, 
			},
		}
	end
end


