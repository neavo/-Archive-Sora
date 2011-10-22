﻿-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- Init
C.UnitFrame = {}
C.UnitFrame.LeftButton = "Click"
C.UnitFrame.RightButton = "Click"

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
			["RaidPartyH"] = true,
			["ShowRaidDebuffs"] = true,
		-- 小队框体
		["ShowParty"] = false,
			["ShowPartyDebuff"] = true,
		-- 点击施法
		["EnableClickCast"] = false,
		["ClickCast"] = {
			["Click"] = {
				["Left"] = {["Enable"] = false, ["Spell"] = "无"},
				["Right"] = {["Enable"] = false, ["Spell"] = "无"},
			},
			["Ctrl"] = {
				["Left"] = {["Enable"] = false, ["Spell"] = "无"},
				["Right"] = {["Enable"] = false, ["Spell"] = "无"},
			},
			["Shift"] = {
				["Left"] = {["Enable"] = false, ["Spell"] = "无"},
				["Right"] = {["Enable"] = false, ["Spell"] = "无"},
			},
			["Alt"] = {
				["Left"] = {["Enable"] = false, ["Spell"] = "无"},
				["Right"] = {["Enable"] = false, ["Spell"] = "无"},
			},
		},
		--其他
		["RaidScale"] = 1,
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
				Header_1 = {
					type = "header",
					name = "小队框体",
					order = 1,
				},	
				ShowParty = {
					type = "toggle",
					name = "显示小队框体",
					order = 2,
					get = function() return UnitFrameDB.ShowParty end,
					set = function(_, value) UnitFrameDB.ShowParty = value end,
				},
				ShowPartyDebuff = {
					type = "toggle",
					name = "显示小队Debuff",
					disabled = not UnitFrameDB.ShowParty,
					order = 3,
					get = function() return UnitFrameDB.ShowPartyDebuff end,
					set = function(_, value) UnitFrameDB.ShowPartyDebuff = value end,
				},
				Header_2 = {
					type = "header",
					name = "团队框体",
					order = 4,
				},			
				ShowRaid = {
					type = "toggle",
					name = "显示团队框体",
					order = 5,
					get = function() return UnitFrameDB.ShowRaid end,
					set = function(_, value) UnitFrameDB.ShowRaid = value end,
				},
				RaidPartyH = {
					type = "toggle",
					name = "各小队排列横向",
					disabled = not UnitFrameDB.ShowRaid,
					order = 6,
					get = function() return UnitFrameDB.RaidPartyH end,
					set = function(_, value) UnitFrameDB.RaidPartyH = value end,
				},
				ShowRaidDebuffs = {
					type = "toggle",
					name = "显示RaidDebuff",
					disabled = not UnitFrameDB.ShowRaid,
					order = 7,
					get = function() return UnitFrameDB.ShowRaidDebuffs end,
					set = function(_, value) UnitFrameDB.ShowRaidDebuffs = value end,
				},
				RaidUnitWidth = {
					type = "input",
					name = "团队框体单位宽度：",
					desc = "请输入团队框体单位宽度",
					order = 8,
					get = function() return tostring(UnitFrameDB.RaidUnitWidth) end,
					set = function(_, value) UnitFrameDB.RaidUnitWidth = tonumber(value) end,
				},
				Header_3 = {
					type = "header",
					name = "点击施法",
					order = 9,
				},
				EnableClickCast = {
					type = "toggle",
					name = "启用点击施法",
					width = "full",
					order = 10,
					get = function() return UnitFrameDB.EnableClickCast end,
					set = function(_, value) UnitFrameDB.EnableClickCast = value end,
				},
				LeftButton = {
					type = "select",
					name = "选择",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 11,
					values = {
						["Click"] = "鼠标左键",
						["Ctrl"] = "Ctrl + 鼠标左键",
						["Shift"] = "Shift + 鼠标左键",
						["Alt"] = "Alt + 鼠标左键",
					},
					get = function() return C.UnitFrame.LeftButton end,
					set = function(_, value) C.UnitFrame.LeftButton = value end,
				},
				LeftButtonSpell = {
					type = "input",
					name = "法术名称：",
					desc = "请输入法术名称：",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 12,
					get = function() return UnitFrameDB["ClickCast"][C.UnitFrame.LeftButton]["Left"]["Spell"] end,
					set = function(_, value) UnitFrameDB["ClickCast"][C.UnitFrame.LeftButton]["Left"]["Spell"] = value end,
				},
				LeftButtonEnable = {
					type = "toggle",
					name = "启用",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 13,
					get = function() return UnitFrameDB["ClickCast"][C.UnitFrame.LeftButton]["Left"]["Enable"] end,
					set = function(_, value) UnitFrameDB["ClickCast"][C.UnitFrame.LeftButton]["Left"]["Enable"] = value end,
				},
				RightButton = {
					type = "select",
					name = "选择",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 14,
					values = {
						["Click"] = "鼠标右键",
						["Ctrl"] = "Ctrl + 鼠标右键",
						["Shift"] = "Shift + 鼠标右键",
						["Alt"] = "Alt + 鼠标右键",
					},
					get = function() return C.UnitFrame.RightButton end,
					set = function(_, value) C.UnitFrame.RightButton = value end,
				},
				RightButtonSpell = {
					type = "input",
					name = "法术名称：",
					desc = "请输入法术名称：",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 15,
					get = function() return UnitFrameDB["ClickCast"][C.UnitFrame.RightButton]["Right"]["Spell"] end,
					set = function(_, value) UnitFrameDB["ClickCast"][C.UnitFrame.RightButton]["Right"]["Spell"] = value end,
				},
				RightButtonEnable = {
					type = "toggle",
					name = "启用",
					disabled = not UnitFrameDB.EnableClickCast,
					order = 16,
					get = function() return UnitFrameDB["ClickCast"][C.UnitFrame.RightButton]["Right"]["Enable"] end,
					set = function(_, value) UnitFrameDB["ClickCast"][C.UnitFrame.RightButton]["Right"]["Enable"] = value end,
				},
				Header_4 = {
					type = "header",
					name = "其他",
					order = 17,
				},	
				RaidScale = {
					type = "input",
					name = "团队&小队缩放比例：",
					desc = "请输入团队&小队缩放比例：",
					order = 18,
					get = function() return tostring(UnitFrameDB.RaidScale) end,
					set = function(_, value) UnitFrameDB.RaidScale = tonumber(value) end,
				},
			}
		}
	end
end