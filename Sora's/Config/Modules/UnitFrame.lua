-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["UnitFrame"] = {}
local Module = DB["Modules"]["UnitFrame"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		-- 玩家框体
		["PlayerEnable"] = true,
			["PetEnable"] = true,
			["PlayerWidth"] = 220,
			["PlayerHealthHeight"] = 24,
			["PlayerPowerHeight"] = 2,
			["PlayerTagMode"] = "Short",
			["PlayerCastbarEnable"] = true,
			["PlayerCastbarWidth"] = 515,
			["PlayerCastbarHeight"] = 20,
		-- 目标框体
		["TargetEnable"] = true,
			["TargetTargetEnable"] = true,
			["TargetWidth"] = 220,
			["TargetHealthHeight"] = 24,
			["TargetPowerHeight"] = 2,
			["TargetTagMode"] = "Short",
			["TargetBuffMode"] = "Full",
			["TargetDebuffMode"] = "Full",
			["TargetCastbarEnable"] = true,
			["TargetCastbarWidth"] = 515,
			["TargetCastbarHeight"] = 20,
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
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(UnitFrameDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["PlayerFrame"] =  {
			type = "group", order = 9,
			name = "玩家框体",
			args = {
				Gruop_1 = {
					type = "group", order = 1,
					name = " ", guiInline = true,
					args = {
						PlayerEnable = {
							type = "toggle", order = 1,
							name = "启用玩家框体",		
							get = function() return UnitFrameDB["PlayerEnable"] end,
							set = function(_, value) UnitFrameDB["PlayerEnable"] = value end,
						},
					}
				},
				Gruop_2 = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["PlayerEnable"],	
					args = {
						PetEnable = {
							type = "toggle", order = 1,
							name = "启用宠物框体",
							get = function() return UnitFrameDB["PetEnable"] end,
							set = function(_, value) UnitFrameDB["PetEnable"]= value end,
						},
					}
				},
				Gruop_3 = {
					type = "group", order = 3,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["PlayerEnable"],	
					args = {
						PlayerWidth = {
							type = "range", order = 1,
							name = "玩家框体宽度：", desc = "请输入玩家框体宽度",
							min = 100, max = 600, step = 10,
							get = function() return UnitFrameDB["PlayerWidth"] end,
							set = function(_, value)
								Sora:GetModule("Player"):UpdateWidth(value)
								Sora:GetModule("Player"):UpdateClassPowerBar()
								UnitFrameDB["PlayerWidth"] = value
							end,
						},
						PlayerHealthHeight = {
							type = "range", order = 2,
							name = "玩家框体生命值高度：", desc = "请输入玩家框体生命值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["PlayerHealthHeight"] end,
							set = function(_, value)
								Sora:GetModule("Player"):UpdateHealthHeight(value)
								UnitFrameDB["PlayerHealthHeight"] = value
							end,
						},
						PlayerPowerHeight = {
							type = "range", order = 3,
							name = "玩家框体能量值高度：", desc = "请输入玩家框体能量值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["PlayerPowerHeight"] end,
							set = function(_, value)
								Sora:GetModule("Player"):UpdatePowerHeight(value)
								UnitFrameDB["PlayerPowerHeight"] = value
							end,
						},
						PlayerTagMode = {
							type = "select", order = 4,
							name = "状态数值：", desc = "请选择状态数值模式",
							values = {["Short"] = "缩略", ["Full"] = "详细"},
							get = function() return UnitFrameDB["PlayerTagMode"] end,
							set = function(_, value) UnitFrameDB["PlayerTagMode"] = value end,
						},
					},
				},
				Gruop_4 = {
					type = "group", order = 4,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["PlayerEnable"],	
					args = {
						PlayerCastbarEnable = {
							type = "toggle", order = 1,
							name = "启用施法条",						
							get = function() return UnitFrameDB["PlayerCastbarEnable"] end,
							set = function(_, value) UnitFrameDB["PlayerCastbarEnable"] = value end,
						},
						PlayerCastbarWidth = {
							type = "range", order = 2,
							name = "施法条宽度：", desc = "请输入施法条宽度",
							min = 100, max = 1000, step = 20,
							disabled = not UnitFrameDB["PlayerCastbarEnable"],
							get = function() return UnitFrameDB["PlayerCastbarWidth"] end,
							set = function(_, value)
								Sora:GetModule("PlayerCastbar"):UpdateWidth(value)
								UnitFrameDB["PlayerCastbarWidth"] = value
							end,
						},
						PlayerCastbarHeight = {
							type = "range", order = 2,
							name = "施法条高度：", desc = "请输入施法条高度",
							min = 10, max = 100, step = 5,
							disabled = not UnitFrameDB["PlayerCastbarEnable"],
							get = function() return UnitFrameDB["PlayerCastbarHeight"] end,
							set = function(_, value)
								Sora:GetModule("PlayerCastbar"):UpdateHeight(value)
								UnitFrameDB["PlayerCastbarHeight"] = value
							end,
						}
					}
				}
			}
		}
		DB["Config"]["TargetFrame"] =  {
			type = "group", order = 10,
			name = "目标框体",
			args = {
				Gruop_1 = {
					type = "group", order = 1,
					name = " ", guiInline = true,
					args = {
						TargetEnable = {
							type = "toggle", order = 1,
							name = "启用目标框体",		
							get = function() return UnitFrameDB["TargetEnable"] end,
							set = function(_, value) UnitFrameDB["TargetEnable"] = value end,
						},
					}
				},
				Gruop_2 = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["TargetEnable"],
					args = {
						TargetTargetEnable = {
							type = "toggle", order = 1,
							name = "启用目标的目标框体",
							get = function() return UnitFrameDB["TargetTargetEnable"] end,
							set = function(_, value) UnitFrameDB["TargetTargetEnable"] = value end,
						},
					}
				},
				Gruop_3 = {
					type = "group", order = 3,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["TargetEnable"],
					args = {
						TargetWidth = {
							type = "range", order = 1,
							name = "目标框体宽度：", desc = "请输入目标框体宽度",
							min = 100, max = 600, step = 10,
							get = function() return UnitFrameDB["TargetWidth"] end,
							set = function(_, value)
								Sora:GetModule("Target"):UpdateWidth(value)
								UnitFrameDB["TargetWidth"] = value
							end,
						},
						TargetHealthHeight = {
							type = "range", order = 2,
							name = "目标框体生命值高度：", desc = "请输入目标框体生命值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["TargetHealthHeight"] end,
							set = function(_, value)
								Sora:GetModule("Target"):UpdateHealthHeight(value)
								UnitFrameDB["TargetHealthHeight"] = value
							end,
						},
						TargetPowerHeight = {
							type = "range", order = 3,
							name = "目标框体能量值高度：", desc = "请输入目标框体能量值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["TargetPowerHeight"] end,
							set = function(_, value)
								Sora:GetModule("Target"):UpdatePowerHeight(value)
								UnitFrameDB["TargetPowerHeight"] = value
							end,
						},
						TargetTagMode = {
							type = "select", order = 4,
							name = "状态数值：", desc = "请选择状态数值模式",
							values = {["Short"] = "缩略", ["Full"] = "详细"},
							get = function() return UnitFrameDB["TargetTagMode"] end,
							set = function(_, value) UnitFrameDB["TargetTagMode"] = value end,
						},
						TargetBuffMode = {
							type = "select", order = 5,
							name = "增益效果：", desc = "请选择增益效果显示模式",
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB["TargetBuffMode"] end,
							set = function(_, value) UnitFrameDB["TargetBuffMode"] = value end,
						},
						TargetDebuffMode = {
							type = "select", order = 6,
							name = "减益效果：", desc = "请选择减益效果显示模式",
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB["TargetDebuffMode"] end,
							set = function(_, value) UnitFrameDB["TargetDebuffMode"] = value end,
						},
					}
				},
				Gruop_4 = {
					type = "group", order = 4,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["TargetEnable"],	
					args = {
						TargetCastbarEnable = {
							type = "toggle", order = 1,
							name = "启用施法条",						
							get = function() return UnitFrameDB["TargetCastbarEnable"] end,
							set = function(_, value) UnitFrameDB["TargetCastbarEnable"] = value end,
						},
						TargetCastbarWidth = {
							type = "range", order = 2,
							name = "施法条宽度：", desc = "请输入施法条宽度",
							min = 100, max = 1000, step = 20,
							disabled = not UnitFrameDB["TargetCastbarEnable"],
							get = function() return UnitFrameDB["TargetCastbarWidth"] end,
							set = function(_, value)
								Sora:GetModule("TargetCastbar"):UpdateWidth(value)
								UnitFrameDB["TargetCastbarWidth"] = value
							end,
						},
						TargetCastbarHeight = {
							type = "range", order = 2,
							name = "施法条高度：", desc = "请输入施法条高度",
							min = 10, max = 100, step = 5,
							disabled = not UnitFrameDB["TargetCastbarEnable"],
							get = function() return UnitFrameDB["TargetCastbarHeight"] end,
							set = function(_, value)
								Sora:GetModule("TargetCastbar"):UpdateHeight(value)
								UnitFrameDB["TargetCastbarHeight"] = value
							end,
						}
					}
				}
			}
		}
		DB["Config"]["FocusFrame"] =  {
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
		DB["Config"]["BossFrame"] =  {
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
		DB["Config"]["RaidFrame"] =  {
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