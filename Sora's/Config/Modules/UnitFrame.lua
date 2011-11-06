-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- Init
C.UnitFrame = {}

-- LoadSettings
function C.UnitFrame.LoadSettings()
	local Default = {
		-- 玩家框体
		["ShowPlayerFrame"] = true,
			["PlayerWidth"] = 220,
			["PlayerHeight"] = 30,
			["ShowPet"] = true,
			["PlayerCastbarMode"] = "Small",
			["PlayerTagMode"] = "Short",
		-- 目标框体
		["ShowTargetFrame"] = true,
			["TargetWidth"] = 220,
			["TargetHeight"] = 30,
			["ShowToT"] = true,
			["TargetCastbarMode"] = "Small",
			["TargetTagMode"] = "Short",
			["TargetBuffMode"] = "Full",
			["TargetDebuffMode"] = "Full",
		-- 焦点框体
		["ShowFocusFrame"] = true,
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
		-- 团队框体
		["ShowRaidFrame"] = true,
			["RaidUnitWidth"] = 70,
			["RaidUnitHeight"] = 20,
			["RaidPartyArrangement"] = "Horizontal",
	}
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then UnitFrameDB[key] = value end
	end
end

-- ResetToDefault
function C.UnitFrame.ResetToDefault()
	wipe(UnitFrameDB)
end

-- BuildGUI
function C.UnitFrame.BuildGUI()
	if Modules then
		Modules["PlayerFrame"] =  {
			type = "group", order = 9,
			name = "玩家框体",
			args = {
				ShowPlayerFrame = {
					type = "toggle", order = 1,
					name = "启用玩家框体",		
					get = function() return UnitFrameDB.ShowPlayerFrame end,
					set = function(_, value) UnitFrameDB.ShowPlayerFrame = value end,
				},
				Gruop = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						PlayerWidth = {
							type = "range", order = 1,
							name = "玩家框体单位宽度：", desc = "请输入玩家框体宽度",
							min = 150, max = 400, step = 1,
							disabled = not UnitFrameDB.ShowPlayerFrame,
							get = function() return UnitFrameDB.PlayerWidth end,
							set = function(_, value) UnitFrameDB.PlayerWidth = value end,
						},
						PlayerHeight = {
							type = "range", order = 2,
							name = "玩家框体高度：", desc = "请输入玩家框体高度",
							min = 20, max = 100, step = 1,
							disabled = not UnitFrameDB.ShowPlayerFrame,
							get = function() return UnitFrameDB.PlayerHeight end,
							set = function(_, value) UnitFrameDB.PlayerHeight = value end,
						},
						ShowPet = {
							type = "toggle", order = 3,
							name = "显示宠物框体",
							disabled = not UnitFrameDB.ShowPlayerFrame,
							get = function() return UnitFrameDB.ShowPet end,
							set = function(_, value) UnitFrameDB.ShowPet = value end,
						},
						PlayerCastbarMode = {
							type = "select", order = 4,
							name = "施法条：", desc = "请选择施法条模式",
							disabled = not UnitFrameDB.ShowPlayerFrame,
							values = {["None"] = "无", ["Small"] = "依附模式", ["Large"] = "独立模式"},
							get = function() return UnitFrameDB.PlayerCastbarMode end,
							set = function(_, value) UnitFrameDB.PlayerCastbarMode = value end,
						},
						PlayerTagMode = {
							type = "select", order = 5,
							name = "状态数值：", desc = "请选择状态数值模式",
							disabled = not UnitFrameDB.ShowPlayerFrame,
							values = {["Short"] = "缩略", ["Full"] = "详细"},
							get = function() return UnitFrameDB.PlayerTagMode end,
							set = function(_, value) UnitFrameDB.PlayerTagMode = value end,
						},
					},
				}
			}
		}
		Modules["TargetFrame"] =  {
			type = "group", order = 10,
			name = "目标框体",
			args = {
				ShowTargetFrame = {
					type = "toggle", order = 1,
					name = "启用目标框体",		
					get = function() return UnitFrameDB.ShowTargetFrame end,
					set = function(_, value) UnitFrameDB.ShowTargetFrame = value end,
				},
				Gruop = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						TargetWidth = {
							type = "range", order = 1,
							name = "目标框体单位宽度：", desc = "请输入目标框体宽度",
							min = 150, max = 400, step = 1,
							disabled = not UnitFrameDB.ShowTargetFrame,
							get = function() return UnitFrameDB.TargetWidth end,
							set = function(_, value) UnitFrameDB.TargetWidth = value end,
						},
						TargetHeight = {
							type = "range", order = 2,
							name = "目标框体单位高度：", desc = "请输入目标框体高度",
							min = 20, max = 100, step = 1,
							disabled = not UnitFrameDB.ShowTargetFrame,
							get = function() return UnitFrameDB.TargetHeight end,
							set = function(_, value) UnitFrameDB.TargetHeight = value end,
						},
						ShowToT = {
							type = "toggle", order = 3,
							name = "显示目标的目标框体",
							disabled = not UnitFrameDB.ShowTargetFrame,
							get = function() return UnitFrameDB.ShowToT end,
							set = function(_, value) UnitFrameDB.ShowToT = value end,
						},
						TargetCastbarMode = {
							type = "select", order = 4,
							name = "施法条：", desc = "请选择施法条模式",
							disabled = not UnitFrameDB.ShowTargetFrame,
							values = {["None"] = "无", ["Small"] = "依附模式", ["Large"] = "独立模式"},
							get = function() return UnitFrameDB.TargetCastbarMode end,
							set = function(_, value) UnitFrameDB.TargetCastbarMode = value end,
						},
						TargetTagMode = {
							type = "select", order = 5,
							name = "状态数值：", desc = "请选择状态数值模式",
							disabled = not UnitFrameDB.ShowTargetFrame,
							values = {["Short"] = "缩略", ["Full"] = "详细"},
							get = function() return UnitFrameDB.TargetTagMode end,
							set = function(_, value) UnitFrameDB.TargetTagMode = value end,
						},
						TargetBuffMode = {
							type = "select", order = 6,
							name = "增益效果：", desc = "请选择增益效果显示模式",
							disabled = not UnitFrameDB.ShowTargetFrame,
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB.TargetBuffMode end,
							set = function(_, value) UnitFrameDB.TargetBuffMode = value end,
						},
						TargetDebuffMode = {
							type = "select", order = 7,
							name = "减益效果：", desc = "请选择减益效果显示模式",
							disabled = not UnitFrameDB.ShowTargetFrame,
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB.TargetDebuffMode end,
							set = function(_, value) UnitFrameDB.TargetDebuffMode = value end,
						},
					}
				}
			}
		}
		Modules["FocusFrame"] =  {
			type = "group", order = 11,
			name = "焦点框体",
			args = {
				ShowFocusFrame = {
					type = "toggle", order = 1,
					name = "显示焦点框体",
					get = function() return UnitFrameDB.ShowFocusFrame end,
					set = function(_, value) UnitFrameDB.ShowFocusFrame = value end,
				},
				Gruop = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						ShowFocusTarget = {
							type = "toggle", order = 1,
							name = "显示焦点目标框体",
							get = function() return UnitFrameDB.ShowFocusTarget end,
							set = function(_, value) UnitFrameDB.ShowFocusTarget = value end,
						},
						ShowFocusCastbar = {
							type = "toggle", order = 2,
							name = "显示施法条",		
							get = function() return UnitFrameDB.ShowFocusCastbar end,
							set = function(_, value) UnitFrameDB.ShowFocusCastbar = value end,
						},
						ShortFocusTags = {
							type = "toggle", order = 3,
							name = "缩写状态数值",		
							get = function() return UnitFrameDB.ShortFocusTags end,
							set = function(_, value) UnitFrameDB.ShortFocusTags = value end,
						},
						ShowFocusBuff = {
							type = "toggle", order = 4,
							name = "显示焦点框体Buff",
							get = function() return UnitFrameDB.ShowFocusBuff end,
							set = function(_, value) UnitFrameDB.ShowFocusBuff = value end,
						},
						ShowFocusDebuff = {
							type = "toggle", order = 5,
							name = "显示焦点框体Debuff",		
							get = function() return UnitFrameDB.ShowFocusDebuff end,
							set = function(_, value) UnitFrameDB.ShowFocusDebuff = value end,
						},
					}
				}
			}
		}
		Modules["BossFrame"] =  {
			type = "group", order = 12,
			name = "首领框体",
			args = {
				ShowBoss = {
					type = "toggle", order = 1,
					name = "显示首领框体",
					get = function() return UnitFrameDB.ShowBoss end,
					set = function(_, value) UnitFrameDB.ShowBoss = value end,
				},
				Gruop = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						ShowBossTarget = {
							type = "toggle", order = 1,
							name = "显示首领目标框体",
							disabled = not UnitFrameDB.ShowBoss,				
							get = function() return UnitFrameDB.ShowBossTarget end,
							set = function(_, value) UnitFrameDB.ShowBossTarget = value end,
						},
						ShowBossCastbar = {
							type = "toggle", order = 2,
							name = "显示首领施法条",
							disabled = not UnitFrameDB.ShowBoss,		
							get = function() return UnitFrameDB.ShowBossCastbar end,
							set = function(_, value) UnitFrameDB.ShowBossCastbar = value end,
						},
						ShowBossBuff = {
							type = "toggle", order = 3,
							name = "显示首领框体增益效果",
							disabled = not UnitFrameDB.ShowBoss,				
							get = function() return UnitFrameDB.ShowBossBuff end,
							set = function(_, value) UnitFrameDB.ShowBossBuff = value end,
						},
						ShowBossDebuff = {
							type = "toggle", order = 4,
							name = "显示首领框体减益效果",
							disabled = not UnitFrameDB.ShowBoss,		
							get = function() return UnitFrameDB.ShowBossDebuff end,
							set = function(_, value) UnitFrameDB.ShowBossDebuff = value end,
						},
					}
				}
			}
		}
		Modules["RaidFrame"] =  {
			type = "group", order = 13,
			name = "团队框体",
			args = {	
				ShowRaidFrame = {
					type = "toggle", order = 1,
					name = "启用团队框体",
					get = function() return UnitFrameDB.ShowRaidFrame end,
					set = function(_, value) UnitFrameDB.ShowRaidFrame = value end,
				},
				Gruop = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						RaidUnitWidth = {
							type = "range", order = 1,
							name = "团队框体单位宽度：", desc = "请输入团队框体单位宽度",
							min = 30, max = 200, step = 1,
							disabled = not UnitFrameDB.ShowRaidFrame,
							get = function() return UnitFrameDB.RaidUnitWidth end,
							set = function(_, value) UnitFrameDB.RaidUnitWidth = value end,
						},
						RaidUnitHeight = {
							type = "range", order = 2,
							name = "团队框体单位高度：", desc = "请输入团队框体单位高度",
							min = 10, max = 50, step = 1,
							disabled = not UnitFrameDB.ShowRaidFrame,
							get = function() return UnitFrameDB.RaidUnitHeight end,
							set = function(_, value) UnitFrameDB.RaidUnitHeight = value end,
						},
						RaidPartyArrangement = {
							type = "select", order = 3,
							name = "小队成员排列方式：", desc = "请选择小队成员排列方式",
							values = {["Horizontal"] = "横向排列", ["Vertical"] = "纵向排列"},
							disabled = not UnitFrameDB.ShowRaidFrame,			
							get = function() return UnitFrameDB.RaidPartyArrangement end,
							set = function(_, value) UnitFrameDB.RaidPartyArrangement = value end,
						},
					}
				}
			}
		}
	end
end