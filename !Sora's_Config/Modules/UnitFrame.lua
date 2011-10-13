-- Engines
local S, C, _, DB = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):GetAddon("SoraConfig")

-- BuildClass
C.UnitFrame = CreateFrame("Frame")

-- LoadSettings
function C.UnitFrame.LoadSettings()
	local Default = {
		-- 单位
		["ShowToT"] = true,				-- 显示"目标的目标"框体
		["ShowPet"] = true,				-- 显示"宠物"框体
		["ShowFocusTarget"] = true,		-- 显示"焦点目标"框体
		-- 团队&小队
		["ShowRaid"] = true,			-- 显示团队框体
		["RaidUnitWidth"] = 67,		-- 团队框体单位宽度
		["RaidPartyH"] = true,		-- 团队框体中各小队横向排列
		["ShowAuraWatch"] = true,	-- 团队框体中显示边角Hot/技能监视
		["ShowRaidDebuffs"] = true, 	-- 显示RaidDebuff
		["ShowParty"] = false,			-- 显示小队框体
		["ShowPartyDebuff"] = true,	-- 显示小队框体Debuff
		["RaidScale"] = 1,				-- 团队&小队缩放
		-- Buff
		["ShowTargetBuff"] = true,					-- 显示目标框体Buff
		["BuffOnlyShowPlayer"] = false,			-- 目标框体上只显示玩家的Buff
		["ShowTargetDebuff"] = true,					-- 显示目标框体Debuff
		["DebuffOnlyShowPlayer"] = false,		-- 目标框体上只显示玩家的Debuff
		["ShowFocusDebuff"] = true,					-- 显示焦点框体Buff
		["ShowFocusBuff"] = true,					-- 显示焦点框体Debuff
		-- 施法条
		["ShowCastbar"] = true,				-- 显示施法条
		["PlayerCastbarAlone"] = false,			-- 玩家施法条独立
		["TargetCastbarAlone"] = false,			-- 目标施法条独立
		-- 其他
		["Scale"] = 1,						-- 其他框体缩放
	}
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then
			UnitFrameDB[key] = value
		end
	end
end

-- ResetToDefault
function C.UnitFrame.ResetToDefault()
	wipe(UnitFrameDB)
	LoadSettings()
end

-- BuildGUI
function C.UnitFrame.BuildGUI()
	if Modules then
		Modules["UnitFrame"] =  {
			type = "group",
			name = "|cff70C0F5单位框体|r",
			args = {
				Header_1 = {
					type = "header",
					name = "单位",
					order = 1,
				},
				ShowToT = {
					type = "toggle",
					name = "显示\"目标的目标\"框体",
					order = 2,
					get = function() return UnitFrameDB.ShowToT end,
					set = function(_, value) UnitFrameDB.ShowToT = value end,
				},
				ShowPet = {
					type = "toggle",
					name = "显示\"宠物\"框体",
					order = 3,
					get = function() return UnitFrameDB.ShowPet end,
					set = function(_, value) UnitFrameDB.ShowPet = value end,
				},
				ShowFocusTarget = {
					type = "toggle",
					name = "显示\"焦点目标\"框体",
					order = 4,
					get = function() return UnitFrameDB.ShowFocusTarget end,
					set = function(_, value) UnitFrameDB.ShowFocusTarget = value end,
				},
				Header_3 = {
					type = "header",
					name = "Buff&Debuff",
					order = 5,
				},
				ShowTargetBuff = {
					type = "toggle",
					name = "显示目标框体Buff",
					order = 6,
					get = function() return UnitFrameDB.ShowTargetBuff end,
					set = function(_, value) UnitFrameDB.ShowTargetBuff = value end,
				},
				BuffOnlyShowPlayer = {
					type = "toggle",
					name = "目标框体上只显示玩家的Buff",
					disabled = not UnitFrameDB.ShowTargetBuff,
					order = 7,
					get = function() return UnitFrameDB.BuffOnlyShowPlayer end,
					set = function(_, value) UnitFrameDB.BuffOnlyShowPlayer = value end,
				},
				ShowTargetDebuff = {
					type = "toggle",
					name = "显示目标框体Debuff",
					order = 8,
					get = function() return UnitFrameDB.ShowTargetDebuff end,
					set = function(_, value) UnitFrameDB.ShowTargetDebuff = value end,
				},
				DebuffOnlyShowPlayer = {
					type = "toggle",
					name = "目标框体上只显示玩家的Debuff",
					disabled = not UnitFrameDB.ShowTargetDebuff,
					order = 9,
					get = function() return UnitFrameDB.DebuffOnlyShowPlayer end,
					set = function(_, value) UnitFrameDB.DebuffOnlyShowPlayer = value end,
				},
				ShowFocusBuff = {
					type = "toggle",
					name = "显示焦点框体Buff",
					order = 10,
					get = function() return UnitFrameDB.ShowFocusBuff end,
					set = function(_, value) UnitFrameDB.ShowFocusBuff = value end,
				},
				ShowFocusDebuff = {
					type = "toggle",
					name = "显示焦点框体Debuff",
					order = 11,
					get = function() return UnitFrameDB.ShowFocusDebuff end,
					set = function(_, value) UnitFrameDB.ShowFocusDebuff = value end,
				},
				Header_3 = {
					type = "header",
					name = "其他",
					order = 12,
				},
				ShowCastbar = {
					type = "toggle",
					name = "显示施法条",
					order = 13,
					get = function() return UnitFrameDB.ShowCastbar end,
					set = function(_, value) UnitFrameDB.ShowCastbar = value end,
				},
				PlayerCastbarAlone = {
					type = "toggle",
					name = "玩家施法条独立",
					disabled = not UnitFrameDB.ShowCastbar,
					order = 14,
					get = function() return UnitFrameDB.PlayerCastbarAlone end,
					set = function(_, value) UnitFrameDB.PlayerCastbarAlone = value end,
				},
				TargetCastbarAlone = {
					type = "toggle",
					name = "目标施法条独立",
					disabled = not UnitFrameDB.ShowCastbar,
					order = 15,
					get = function() return UnitFrameDB.TargetCastbarAlone end,
					set = function(_, value) UnitFrameDB.TargetCastbarAlone = value end,
				},
				Scale = {
					type = "input",
					name = "其他框体缩放比例：",
					desc = "请输入其他框体缩放比例：",
					order = 16,
					get = function() return tostring(UnitFrameDB.Scale) end,
					set = function(_, value) UnitFrameDB.Scale = tonumber(value) end,
				},
			}
		}
		Modules["Raid"] =  {
			type = "group",
			name = "|cff70C0F5团队框体|r",
			args = {
				Header_1 = {
					type = "header",
					name = "团队",
					order = 1,
				},			
				ShowRaid = {
					type = "toggle",
					name = "显示团队框体",
					order = 2,
					get = function() return UnitFrameDB.ShowRaid end,
					set = function(_, value) UnitFrameDB.ShowRaid = value end,
				},
				RaidPartyH = {
					type = "toggle",
					name = "横向各小队排列",
					disabled = not UnitFrameDB.ShowRaid,
					order = 3,
					get = function() return UnitFrameDB.RaidPartyH end,
					set = function(_, value) UnitFrameDB.RaidPartyH = value end,
				},
				ShowAuraWatch = {
					type = "toggle",
					name = "边角Hot/技能监视",
					disabled = not UnitFrameDB.ShowRaid,
					order = 4,
					get = function() return UnitFrameDB.ShowAuraWatch end,
					set = function(_, value) UnitFrameDB.ShowAuraWatch = value end,
				},
				ShowRaidDebuffs = {
					type = "toggle",
					name = "显示RaidDebuff",
					disabled = not UnitFrameDB.ShowRaid,
					order = 5,
					get = function() return UnitFrameDB.ShowRaidDebuffs end,
					set = function(_, value) UnitFrameDB.ShowRaidDebuffs = value end,
				},
				RaidUnitWidth = {
					type = "input",
					name = "团队框体单位宽度：",
					desc = "请输入团队框体单位宽度",
					order = 6,
					get = function() return tostring(UnitFrameDB.RaidUnitWidth) end,
					set = function(_, value) UnitFrameDB.RaidUnitWidth = tonumber(value) end,
				},
				Header_2 = {
					type = "header",
					name = "小队",
					order = 7,
				},	
				ShowParty = {
					type = "toggle",
					name = "显示小队框体",
					order = 8,
					get = function() return UnitFrameDB.ShowParty end,
					set = function(_, value) UnitFrameDB.ShowParty = value end,
				},
				ShowPartyDebuff = {
					type = "toggle",
					name = "显示小队Debuff",
					disabled = not UnitFrameDB.ShowParty,
					order = 9,
					get = function() return UnitFrameDB.ShowPartyDebuff end,
					set = function(_, value) UnitFrameDB.ShowPartyDebuff = value end,
				},
				RaidScale = {
					type = "input",
					name = "团队&小队缩放比例：",
					desc = "请输入团队&小队缩放比例：",
					order = 10,
					get = function() return tostring(UnitFrameDB.RaidScale) end,
					set = function(_, value) UnitFrameDB.RaidScale = tonumber(value) end,
				},
			}
		}
	end
end