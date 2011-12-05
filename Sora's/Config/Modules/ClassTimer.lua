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
			["PlayerIconSize"] = 30,
		["TargetMode"] = "Bar",
			["TargetLimit"] = 60,
			["TargetIconSize"] = 20,
		["BlackList"] = {},
		["WhiteList"] = {
			[GetSpellInfo(2825)] = true, -- 嗜血
			[GetSpellInfo(8699)] = true, -- 邪恶狂热
			[GetSpellInfo(10060)] = true, -- 能量灌注
			[GetSpellInfo(32182)] = true, -- 英勇
			[GetSpellInfo(33206)] = true, -- 痛苦压制
			[GetSpellInfo(50461)] = true, -- 反魔法领域
			[GetSpellInfo(64205)] = true, -- 神圣牺牲
			[GetSpellInfo(80353)] = true, -- 时间扭曲
			[GetSpellInfo(81781)] = true, -- 真言术：障
			[GetSpellInfo(90355)] = true, -- 远古狂乱
			[GetSpellInfo(97463)] = true, -- 集结呐喊
			[GetSpellInfo(98007)] = true, -- 灵魂链接图腾
		},
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
local BlackListTable, WhiteListTable = {}, {}

local function UpdateBlackListTable()
	wipe(BlackListTable)
	BlackListTable["BlackListNew"] = {
		type = "input", order = 1,
		name = "添加新条目", width = "full",
		get = function() return "无" end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			ClassTimerDB["BlackList"][Name] = true
			UpdateBlackListTable()
		end,
	}
	local Order = 1
	for key, value in pairs(ClassTimerDB["BlackList"]) do
		if value then
			Order = Order + 1
			BlackListTable[key] = {
				type = "toggle", order = Order,
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

local function UpdateWhiteListTable()
	wipe(WhiteListTable)
	WhiteListTable["WhiteListNew"] = {
		type = "input", order = 1,
		name = "添加新条目", width = "full",
		get = function() return "无" end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			ClassTimerDB["WhiteList"][Name] = true
			UpdateWhiteListTable()
		end,
	}
	local Order = 1
	for key, value in pairs(ClassTimerDB["WhiteList"]) do
		if value then
			Order = Order + 1
			WhiteListTable[key] = {
				type = "toggle", order = Order,
				name = key, desc = "启用/禁用",
				get = function() return value end,
				set = function(_, val)
					ClassTimerDB["WhiteList"][key] = val
					UpdateWhiteListTable()
				end,
			}
		end
	end
end

function Module.BuildGUI()
	UpdateBlackListTable()
	UpdateWhiteListTable()
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
								Sora:GetModule("ClassTimer"):ClearAura("player")
							end,
						},
						PlayerIconSize = {
							type = "range", order = 2,
							name = "玩家增益计时图标大小：", desc = "请输入玩家增益计时图标大小",
							min = 10, max = 100, step = 1,
							width = "full",
							disabled = ClassTimerDB["PlayerMode"] == "None",
							get = function() return ClassTimerDB["PlayerIconSize"] end,
							set = function(_, value)
								ClassTimerDB["PlayerIconSize"] = value
								Sora:GetModule("ClassTimer"):ClearAura("player")
							end,
						},
						TargetMode = {
							type = "select", order = 3,
							name = "目标减益计时模式：", desc = "请选择目标减益计时模式：",
							values = {["Bar"] = "计时条模式", ["Icon"] = "图标模式", ["None"] = "无"},
							get = function() return ClassTimerDB["TargetMode"] end,
							set = function(_, value)
								ClassTimerDB["TargetMode"] = value
								Sora:GetModule("ClassTimer"):ClearAura("target")
							end,
						}, 
						TargetIconSize = {
							type = "range", order = 4,
							name = "目标减益计时图标大小：", desc = "请输入目标减益计时图标大小",
							min = 10, max = 100, step = 1,
							width = "full",
							disabled = ClassTimerDB["TargetMode"] == "None",
							get = function() return ClassTimerDB["TargetIconSize"] end,
							set = function(_, value)
								ClassTimerDB["TargetIconSize"] = value
								Sora:GetModule("ClassTimer"):ClearAura("target")
							end,
						},
					},
				}, 
				Gruop_2 = {
					type = "group", order = 2, 
					name = "黑名单", guiInline = true, 
					disabled = ClassTimerDB["PlayerMode"] == "None" and ClassTimerDB["TargetMode"] == "None",
					args = BlackListTable,
				}, 
				Gruop_3 = {
					type = "group", order = 3, 
					name = "白名单", guiInline = true, 
					disabled = ClassTimerDB["PlayerMode"] == "None" and ClassTimerDB["TargetMode"] == "None",
					args = WhiteListTable,
				}, 
			},
		}
	end
end


