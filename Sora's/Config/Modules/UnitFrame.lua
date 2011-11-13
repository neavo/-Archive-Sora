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
			["PlayerWidth"] = 220,
			["PlayerHealthHeight"] = 24,
			["PlayerPowerHeight"] = 2,
			["PlayerTagMode"] = "Short",
			["PlayerDebuffMode"] = "Full",
			["PlayerCastbarEnable"] = true,
				["PlayerCastbarWidth"] = 515,
				["PlayerCastbarHeight"] = 20,
			["PetWidth"] = 60,
			["PetHealthHeight"] = 15,
			["PetPowerHeight"] = 1,
		-- 目标框体
		["TargetEnable"] = true,
			["TargetWidth"] = 220,
			["TargetHealthHeight"] = 24,
			["TargetPowerHeight"] = 2,
			["TargetTagMode"] = "Short",
			["TargetAuraMode"] = "Full",
			["TargetCastbarEnable"] = true,
				["TargetCastbarWidth"] = 515,
				["TargetCastbarHeight"] = 20,
			["TargetTargetWidth"] = 60,
			["TargetTargetHealthHeight"] = 15,
			["TargetTargetPowerHeight"] = 1,
		-- 焦点框体
		["FocusEnable"] = true,
			["FocusWidth"] = 220,
			["FocusHealthHeight"] = 24,
			["FocusPowerHeight"] = 2,
		["FocusTagMode"] = "Short",
		["FocusBuffMode"] = "Full",
		["FocusDebuffMode"] = "Full",
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
		DB["Config"]["Player"] =  {
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
						PlayerDebuffMode = {
							type = "select", order = 5,
							name = "减益效果：", desc = "请选择减益效果显示模式",
							values = {["Full"] = "全部", ["None"] = "无"},
							get = function() return UnitFrameDB["PlayerDebuffMode"] end,
							set = function(_, value) UnitFrameDB["PlayerDebuffMode"] = value end,
						},
					},
				},
				Gruop_3 = {
					type = "group", order = 3,
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
							disabled = not UnitFrameDB["PlayerCastbarEnable"] or not UnitFrameDB["PlayerEnable"],
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
							disabled = not UnitFrameDB["PlayerCastbarEnable"] or not UnitFrameDB["PlayerEnable"],
							get = function() return UnitFrameDB["PlayerCastbarHeight"] end,
							set = function(_, value)
								Sora:GetModule("PlayerCastbar"):UpdateHeight(value)
								UnitFrameDB["PlayerCastbarHeight"] = value
							end,
						}
					}
				},
				Gruop_4 = {
					type = "group", order = 4,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["PlayerEnable"],	
					args = {
						PetWidth = {
							type = "range", order = 1,
							name = "宠物框体宽度：", desc = "请输入宠物框体宽度",
							min = 20, max = 200, step = 10,
							get = function() return UnitFrameDB["PetWidth"] end,
							set = function(_, value)
								Sora:GetModule("Pet"):UpdateWidth(value)
								UnitFrameDB["PetWidth"] = value
							end,
						},
						PetHealthHeight = {
							type = "range", order = 2,
							name = "宠物框体生命值高度：", desc = "请输入宠物框体生命值高度",
							min = 1, max = 50, step = 2,
							get = function() return UnitFrameDB["PetHealthHeight"] end,
							set = function(_, value)
								Sora:GetModule("Pet"):UpdateHealthHeight(value)
								UnitFrameDB["PetHealthHeight"] = value
							end,
						},
						PetPowerHeight = {
							type = "range", order = 3,
							name = "宠物框体能量值高度：", desc = "请输入宠物框体能量值高度",
							min = 1, max = 50, step = 2,
							get = function() return UnitFrameDB["PetPowerHeight"] end,
							set = function(_, value)
								Sora:GetModule("Pet"):UpdatePowerHeight(value)
								UnitFrameDB["PetPowerHeight"] = value
							end,
						},
					}
				}
			}
		}
		DB["Config"]["Target"] =  {
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
						TargetAuraMode = {
							type = "select", order = 5,
							name = "增益/减益效果：", desc = "请选择增益/减益效果显示模式",
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB["TargetAuraMode"] end,
							set = function(_, value) UnitFrameDB["TargetAuraMode"] = value end,
						},
					}
				},
				Gruop_3 = {
					type = "group", order = 3,
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
				},
				Gruop_4 = {
					type = "group", order = 4,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["TargetEnable"],	
					args = {
						TargetTargetWidth = {
							type = "range", order = 1,
							name = "目标的目标宽度：", desc = "请输入目标的目标宽度",
							min = 20, max = 200, step = 10,	
							get = function() return UnitFrameDB["TargetTargetWidth"] end,
							set = function(_, value)
								Sora:GetModule("TargetTarget"):UpdateWidth(value)
								UnitFrameDB["TargetTargetWidth"] = value
							end,
						},
						TargetTargetHealthHeight = {
							type = "range", order = 2,
							name = "目标的目标生命值高度：", desc = "请输入目标的目标生命值高度",
							min = 1, max = 50, step = 2,
							get = function() return UnitFrameDB["TargetTargetHealthHeight"] end,
							set = function(_, value)
								Sora:GetModule("TargetTarget"):UpdateHealthHeight(value)
								UnitFrameDB["TargetTargetHealthHeight"] = value
							end,
						},
						TargetTargetPowerHeight = {
							type = "range", order = 3,
							name = "目标的目标能量值高度：", desc = "请输入目标的目标能量值高度",
							min = 1, max = 50, step = 2,	
							get = function() return UnitFrameDB["TargetTargetPowerHeight"] end,
							set = function(_, value)
								Sora:GetModule("TargetTarget"):UpdatePowerHeight(value)
								UnitFrameDB["TargetTargetPowerHeight"] = value
							end,
						},
					}
				}
			}
		}
		DB["Config"]["Focus"] =  {
			type = "group", order = 11,
			name = "焦点框体",
			args = {
				Gruop_1 = {
					type = "group", order = 1,
					name = " ", guiInline = true,
					args = {
						FocusEnable = {
							type = "toggle", order = 1,
							name = "显示焦点框体",
							get = function() return UnitFrameDB["FocusEnable"] end,
							set = function(_, value) UnitFrameDB["FocusEnable"] = value end,
						}
					}
				},
				Gruop_2 = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					disabled = not UnitFrameDB["FocusEnable"],
					args = {
						FocusWidth = {
							type = "range", order = 1,
							name = "焦点框体宽度：", desc = "请输入焦点框体宽度",
							min = 100, max = 600, step = 10,
							get = function() return UnitFrameDB["FocusWidth"] end,
							set = function(_, value)
								Sora:GetModule("Focus"):UpdateWidth(value)
								UnitFrameDB["FocusWidth"] = value
							end,
						},
						FocusHealthHeight = {
							type = "range", order = 2,
							name = "焦点框体生命值高度：", desc = "请输入焦点框体生命值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["FocusHealthHeight"] end,
							set = function(_, value)
								Sora:GetModule("Focus"):UpdateHealthHeight(value)
								UnitFrameDB["FocusHealthHeight"] = value
							end,
						},
						FocusPowerHeight = {
							type = "range", order = 3,
							name = "焦点框体能量值高度：", desc = "请输入焦点框体能量值高度",
							min = 2, max = 100, step = 2,
							get = function() return UnitFrameDB["FocusPowerHeight"] end,
							set = function(_, value)
								Sora:GetModule("Focus"):UpdatePowerHeight(value)
								UnitFrameDB["FocusPowerHeight"] = value
							end,
						},
						FocusTagMode = {
							type = "select", order = 4,
							name = "状态数值：", desc = "请选择状态数值模式",
							values = {["Short"] = "缩略", ["Full"] = "详细"},
							get = function() return UnitFrameDB["FocusTagMode"] end,
							set = function(_, value) UnitFrameDB["FocusTagMode"] = value end,
						},
						FocusBuffMode = {
							type = "select", order = 5,
							name = "增益效果：", desc = "请选择增益效果显示模式",
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB["FocusBuffMode"] end,
							set = function(_, value) UnitFrameDB["FocusBuffMode"] = value end,
						},
						FocusDebuffMode = {
							type = "select", order = 6,
							name = "减益效果：", desc = "请选择减益效果显示模式",
							values = {["Full"] = "全部", ["OnlyPlayer"] = "仅显示玩家施放的", ["None"] = "无"},
							get = function() return UnitFrameDB["FocusDebuffMode"] end,
							set = function(_, value) UnitFrameDB["FocusDebuffMode"] = value end,
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