----------------
--  命名空间  --
----------------
local _, ns = ...
ns.cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\oUF_Sora\\Media\\"
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.Solid = Media.."Solid"
ns.cfg.GlowTex = Media.."GlowTex"
ns.cfg.Statusbar = Media.."Statusbar"

----------------------
--  公用变量和函数  --
----------------------

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
	["CastbarAlone"] = false,		-- true : 独立大施法条 false : 依附于玩家头像之下的小施法条
	-- 其他
	["Scale"] = 1,						-- 其他框体缩放
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not UnitFrameDB then UnitFrameDB = {} end
	for key, value in pairs(Default) do
		if UnitFrameDB[key] == nil then
			UnitFrameDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	UnitFrameDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["oUF_Sora"] =  {
			type = "group",
			name = "oUF_|cff70C0F5Sora's|r",
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
				Header_2 = {
					type = "header",
					name = "团队&小队",
					order = 5,
				},
				ShowRaid = {
					type = "toggle",
					name = "显示团队框体",
					order = 6,
					get = function() return UnitFrameDB.ShowRaid end,
					set = function(_, value) UnitFrameDB.ShowRaid = value end,
				},
				RaidPartyH = {
					type = "toggle",
					name = "横向各小队排列",
					disabled = not UnitFrameDB.ShowRaid,
					order = 7,
					get = function() return UnitFrameDB.RaidPartyH end,
					set = function(_, value) UnitFrameDB.RaidPartyH = value end,
				},
				ShowAuraWatch = {
					type = "toggle",
					name = "边角Hot/技能监视",
					disabled = not UnitFrameDB.ShowRaid,
					order = 8,
					get = function() return UnitFrameDB.ShowAuraWatch end,
					set = function(_, value) UnitFrameDB.ShowAuraWatch = value end,
				},
				ShowRaidDebuffs = {
					type = "toggle",
					name = "显示RaidDebuff",
					disabled = not UnitFrameDB.ShowRaid,
					order = 9,
					get = function() return UnitFrameDB.ShowRaidDebuffs end,
					set = function(_, value) UnitFrameDB.ShowRaidDebuffs = value end,
				},
				ShowParty = {
					type = "toggle",
					name = "显示小队框体",
					order = 10,
					get = function() return UnitFrameDB.ShowParty end,
					set = function(_, value) UnitFrameDB.ShowParty = value end,
				},
				ShowPartyDebuff = {
					type = "toggle",
					name = "显示小队Debuff",
					disabled = not UnitFrameDB.ShowParty,
					order = 11,
					get = function() return UnitFrameDB.ShowPartyDebuff end,
					set = function(_, value) UnitFrameDB.ShowPartyDebuff = value end,
				},
				RaidUnitWidth = {
					type = "input",
					name = "团队框体单位宽度：",
					desc = "请输入团队框体单位宽度",
					order = 12,
					get = function() return tostring(UnitFrameDB.RaidUnitWidth) end,
					set = function(_, value) UnitFrameDB.RaidUnitWidth = tonumber(value) end,
				},
				RaidScale = {
					type = "input",
					name = "团队&小队缩放比例：",
					desc = "请输入团队&小队缩放比例：",
					order = 13,
					get = function() return tostring(UnitFrameDB.RaidScale) end,
					set = function(_, value) UnitFrameDB.RaidScale = tonumber(value) end,
				},
				Header_3 = {
					type = "header",
					name = "Buff&Debuff",
					order = 14,
				},
				ShowTargetBuff = {
					type = "toggle",
					name = "显示目标框体Buff",
					order = 15,
					get = function() return UnitFrameDB.ShowTargetBuff end,
					set = function(_, value) UnitFrameDB.ShowTargetBuff = value end,
				},
				BuffOnlyShowPlayer = {
					type = "toggle",
					name = "目标框体上只显示玩家的Buff",
					disabled = not UnitFrameDB.ShowTargetBuff,
					order = 16,
					get = function() return UnitFrameDB.BuffOnlyShowPlayer end,
					set = function(_, value) UnitFrameDB.BuffOnlyShowPlayer = value end,
				},
				ShowTargetDebuff = {
					type = "toggle",
					name = "显示目标框体Debuff",
					order = 17,
					get = function() return UnitFrameDB.ShowTargetDebuff end,
					set = function(_, value) UnitFrameDB.ShowTargetDebuff = value end,
				},
				DebuffOnlyShowPlayer = {
					type = "toggle",
					name = "目标框体上只显示玩家的Debuff",
					disabled = not UnitFrameDB.ShowTargetDebuff,
					order = 18,
					get = function() return UnitFrameDB.DebuffOnlyShowPlayer end,
					set = function(_, value) UnitFrameDB.DebuffOnlyShowPlayer = value end,
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
					name = "其他",
					order = 21,
				},
				ShowCastbar = {
					type = "toggle",
					name = "显示施法条",
					order = 22,
					get = function() return UnitFrameDB.ShowCastbar end,
					set = function(_, value) UnitFrameDB.ShowCastbar = value end,
				},
				CastbarAlone = {
					type = "toggle",
					name = "独立大施法条",
					disabled = not UnitFrameDB.ShowCastbar,
					order = 23,
					get = function() return UnitFrameDB.CastbarAlone end,
					set = function(_, value) UnitFrameDB.CastbarAlone = value end,
				},
				Scale = {
					type = "input",
					name = "其他框体缩放比例：",
					desc = "请输入其他框体缩放比例：：",
					order = 24,
					get = function() return tostring(UnitFrameDB.Scale) end,
					set = function(_, value) UnitFrameDB.Scale = tonumber(value) end,
				},
				SpaceLine_1 = {
					type = "description",
					name = "\n\n\n",
					order = 25,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 26,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 27,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 28,
					func  = function() ResetToDefault() ReloadUI() end,
				},
			},
		}
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(slef, event, addon, ...)
	if event == "ADDON_LOADED" and addon == "oUF_Sora" then
		LoadSettings(UnitFrameDB)
		BuildGUI()
	end
end)