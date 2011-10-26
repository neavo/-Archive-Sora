-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- Init
C.UnitFrame = {}

-- LoadSettings
function C.UnitFrame.LoadSettings()
	local Default = {
		-- 玩家框体
		["ShowPet"] = true,
		["ShowPlayerCastbar"] = true,
			["PlayerCastbarAlone"] = false,
		["ShortPlayerTags"] = true,
		-- 目标框体
		["ShowToT"] = true,
		["ShowTargetCastbar"] = true,
			["TargetCastbarAlone"] = false,
		["ShortTargetTags"] = true,
		["ShowTargetBuff"] = true,
			["ShowTargetBuffOnlyPlayer"] = false,
		["ShowTargetDebuff"] = true,
			["ShowTargetDebuffOnlyPlayer"] = false,
		-- 焦点框体
		["ShowFocusTarget"] = true,
		["ShowFocusCastbar"] = true,
		["ShortFocusTags"] = true,
		["ShowFocusDebuff"] = true,
		["ShowFocusBuff"] = true,
		-- Boss框体
		["ShowBoss"] = false,
			["ShowBossTarget"] = true,
			["ShowBossCastbar"] = true,
			["ShowBossDebuff"] = true,
			["ShowBossBuff"] = true,
		-- 其他
		["Scale"] = 1,
		-- 团队框体
		["ShowRaid"] = true,
			["RaidUnitWidth"] = 70,
			["RaidUnitHeight"] = 20,
			["RaidPartyArrangement"] = "HORIZONTAL",
	}
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then UnitFrameDB[key] = value end
	end
end

-- ResetToDefault
function C.UnitFrame.ResetToDefault()
	wipe(UnitFrameDB)
	C.UnitFrame.LoadSettings()
end

-- BuildGUI
function C.UnitFrame.BuildGUI()
	if Modules then
		Modules["UnitFrame"] =  {
			type = "group",
			name = "单位框体",
			args = {
				Header_1 = {
					type = "header",
					name = "玩家框体",
					order = 1,
				},
				ShowPet = {
					type = "toggle",
					name = "显示宠物框体",
					order = 2,
					get = function() return UnitFrameDB.ShowPet end,
					set = function(_, value) UnitFrameDB.ShowPet = value end,
				},
				ShowPlayerCastbar = {
					type = "toggle",
					name = "显示施法条",
					order = 3,
					get = function() return UnitFrameDB.ShowPlayerCastbar end,
					set = function(_, value) UnitFrameDB.ShowPlayerCastbar = value end,
				},
				PlayerCastbarAlone = {
					type = "toggle",
					name = "玩家施法条独立",
					disabled = not UnitFrameDB.ShowPlayerCastbar,
					order = 4,
					get = function() return UnitFrameDB.PlayerCastbarAlone end,
					set = function(_, value) UnitFrameDB.PlayerCastbarAlone = value end,
				},
				ShortPlayerTags = {
					type = "toggle",
					name = "缩写状态数值",
					order = 5,
					get = function() return UnitFrameDB.ShortPlayerTags end,
					set = function(_, value) UnitFrameDB.ShortPlayerTags = value end,
				},
				Header_2 = {
					type = "header",
					name = "目标框体",
					order = 6,
				},
				ShowToT = {
					type = "toggle",
					name = "显示目标的目标框体",
					order = 7,
					get = function() return UnitFrameDB.ShowToT end,
					set = function(_, value) UnitFrameDB.ShowToT = value end,
				},
				ShowTargetCastbar = {
					type = "toggle",
					name = "显示施法条",
					order = 8,
					get = function() return UnitFrameDB.ShowTargetCastbar end,
					set = function(_, value) UnitFrameDB.ShowTargetCastbar = value end,
				},
				TargetCastbarAlone = {
					type = "toggle",
					name = "目标施法条独立",
					disabled = not UnitFrameDB.ShowTargetCastbar,
					order = 9,
					get = function() return UnitFrameDB.TargetCastbarAlone end,
					set = function(_, value) UnitFrameDB.TargetCastbarAlone = value end,
				},
				ShortTargetTags = {
					type = "toggle",
					name = "缩写状态数值",
					order = 10,
					get = function() return UnitFrameDB.ShortTargetTags end,
					set = function(_, value) UnitFrameDB.ShortTargetTags = value end,
				},
				ShowTargetBuff = {
					type = "toggle",
					name = "显示目标框体Buff",
					order = 11,
					get = function() return UnitFrameDB.ShowTargetBuff end,
					set = function(_, value) UnitFrameDB.ShowTargetBuff = value end,
				},
				ShowTargetBuffOnlyPlayer = {
					type = "toggle",
					name = "只显示玩家释放的Buff",
					disabled = not UnitFrameDB.ShowTargetBuff,
					order = 12,
					get = function() return UnitFrameDB.ShowTargetBuffOnlyPlayer end,
					set = function(_, value) UnitFrameDB.ShowTargetBuffOnlyPlayer = value end,
				},
				ShowTargetDebuff = {
					type = "toggle",
					name = "显示目标框体Debuff",
					order = 13,
					get = function() return UnitFrameDB.ShowTargetDebuff end,
					set = function(_, value) UnitFrameDB.ShowTargetDebuff = value end,
				},
				ShowTargetDebuffOnlyPlayer = {
					type = "toggle",
					name = "只显示释放玩家的Debuff",
					disabled = not UnitFrameDB.ShowTargetDebuff,
					order = 14,
					get = function() return UnitFrameDB.ShowTargetDebuffOnlyPlayer end,
					set = function(_, value) UnitFrameDB.ShowTargetDebuffOnlyPlayer = value end,
				},
				Header_3 = {
					type = "header",
					name = "焦点框体",
					order = 15,
				},
				ShowFocusTarget = {
					type = "toggle",
					name = "显示焦点目标框体",
					order = 16,
					get = function() return UnitFrameDB.ShowFocusTarget end,
					set = function(_, value) UnitFrameDB.ShowFocusTarget = value end,
				},
				ShowFocusCastbar = {
					type = "toggle",
					name = "显示施法条",
					order = 17,
					get = function() return UnitFrameDB.ShowFocusCastbar end,
					set = function(_, value) UnitFrameDB.ShowFocusCastbar = value end,
				},
				ShortFocusTags = {
					type = "toggle",
					name = "缩写状态数值",
					order = 18,
					get = function() return UnitFrameDB.ShortFocusTags end,
					set = function(_, value) UnitFrameDB.ShortFocusTags = value end,
				},
				ShowFocusBuff = {
					type = "toggle",
					name = "显示焦点框体Buff",
					order = 19,
					get = function() return UnitFrameDB.ShowFocusBuff end,
					set = function(_, value) UnitFrameDB.ShowFocusBuff = value end,
				},
				ShowFocusDebuff = {
					type = "toggle",
					name = "显示焦点框体Debuff",
					order = 20,
					get = function() return UnitFrameDB.ShowFocusDebuff end,
					set = function(_, value) UnitFrameDB.ShowFocusDebuff = value end,
				},
				Header_4 = {
					type = "header",
					name = "Boss框体",
					order = 21,
				},
				ShowBoss = {
					type = "toggle",
					name = "显示Boss框体",
					order = 22,
					get = function() return UnitFrameDB.ShowBoss end,
					set = function(_, value) UnitFrameDB.ShowBoss = value end,
				},
				ShowBossTarget = {
					type = "toggle",
					name = "显示Boss目标框体",
					disabled = not UnitFrameDB.ShowBoss,
					order = 23,
					get = function() return UnitFrameDB.ShowBossTarget end,
					set = function(_, value) UnitFrameDB.ShowBossTarget = value end,
				},
				ShowBossCastbar = {
					type = "toggle",
					name = "显示施法条",
					disabled = not UnitFrameDB.ShowBoss,
					order = 24,
					get = function() return UnitFrameDB.ShowBossCastbar end,
					set = function(_, value) UnitFrameDB.ShowBossCastbar = value end,
				},
				ShowBossBuff = {
					type = "toggle",
					name = "显示Boss框体Buff",
					disabled = not UnitFrameDB.ShowBoss,
					order = 25,
					get = function() return UnitFrameDB.ShowBossBuff end,
					set = function(_, value) UnitFrameDB.ShowBossBuff = value end,
				},
				ShowBossDebuff = {
					type = "toggle",
					name = "显示Boss框体Debuff",
					disabled = not UnitFrameDB.ShowBoss,
					order = 26,
					get = function() return UnitFrameDB.ShowBossDebuff end,
					set = function(_, value) UnitFrameDB.ShowBossDebuff = value end,
				},
				Header_5 = {
					type = "header",
					name = "其他",
					order = 27,
				},
				Scale = {
					type = "input",
					name = "单位框体缩放比例：",
					desc = "请输入单位框体缩放比例：",
					order = 28,
					get = function() return tostring(UnitFrameDB.Scale) end,
					set = function(_, value) UnitFrameDB.Scale = tonumber(value) end,
				},
			}
		}
		Modules["Raid"] =  {
			type = "group",
			name = "团队框体",
			args = {	
				ShowRaid = {
					type = "toggle",
					name = "启用团队框体",
					order = 1,
					get = function() return UnitFrameDB.ShowRaid end,
					set = function(_, value) UnitFrameDB.ShowRaid = value end,
				},
				NewLine = {
					type = "description",
					name = "\n",
					order = 2,
				},
				RaidUnitWidth = {
					type = "range",
					name = "团队框体单位宽度：",
					desc = "请输入团队框体单位宽度",
					min = 30, max = 200,
					order = 3,
					get = function() return UnitFrameDB.RaidUnitWidth end,
					set = function(_, value) UnitFrameDB.RaidUnitWidth = value end,
				},
				RaidUnitHeight = {
					type = "range",
					name = "团队框体单位高度：",
					desc = "请输入团队框体单位高度",
					min = 10, max = 50,
					order = 4,
					get = function() return UnitFrameDB.RaidUnitHeight end,
					set = function(_, value) UnitFrameDB.RaidUnitHeight = value end,
				},
				RaidPartyArrangement = {
					type = "select",
					name = "小队成员排列方式：",
					desc = "请选择小队成员排列方式:",
					values = {["HORIZONTAL"] = "横向排列", ["VERTICAL"] = "纵向排列"},
					disabled = not UnitFrameDB.ShowRaid,
					order = 5,
					get = function() return UnitFrameDB.RaidPartyArrangement end,
					set = function(_, value) UnitFrameDB.RaidPartyArrangement = value end,
				},
			}
		}
	end
end