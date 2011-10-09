



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\oUF_Sora\\Media\\"

-- 单位
cfg.ShowToT = true				-- 显示"目标的目标"框体
cfg.ShowPet = true				-- 显示"宠物"框体
cfg.ShowFocusTarget = true		-- 显示"焦点目标"框体

-- 团队&小队
cfg.ShowRaid = true				-- 显示团队框体
	cfg.RaidUnitWidth = 67		-- 团队框体单位宽度
	cfg.RaidPartyH = true		-- 团队框体中各小队横向排列
	cfg.ShowAuraWatch = true	-- 团队框体中显示边角Hot/技能监视
	cfg.ShowRaidDebuffs = true 	-- 显示RaidDebuff
cfg.ShowParty = true			-- 显示小队框体
	cfg.showPartyDebuff = true	-- 显示小队框体Debuff
cfg.raidScale = 1				-- 团队&小队缩放

-- Buff
cfg.showTargetBuff = true					-- 显示目标框体Buff
	cfg.BuffOnlyShowPlayer = false			-- 目标框体上只显示玩家的Buff
cfg.showTargetDebuff = true					-- 显示目标框体Debuff
	cfg.DebuffOnlyShowPlayer = false		-- 目标框体上只显示玩家的Debuff
cfg.showFocusDebuff = true					-- 显示焦点框体Buff
cfg.showFocusBuff = true 					-- 显示焦点框体Debuff

-- 施法条
cfg.ShowCastbar = true				-- 显示施法条
	cfg.CastbarAlone = false		-- true : 独立大施法条 false : 依附于玩家头像之下的小施法条

-- 其他
cfg.Scale = 1						-- 其他框体缩放

cfg.Solid = Media.."solid"
cfg.GlowTex = Media.."glowTex"
cfg.Statusbar = Media.."Statusbar"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"

----------------
--  命名空间  --
----------------

local _, SR = ...
SR.cfg = cfg
