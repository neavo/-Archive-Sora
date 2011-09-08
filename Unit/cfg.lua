-----------------------------
-- INIT
-----------------------------

local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's\\Unit\\media\\"	-- don't touch this ...

-----------------------------
-- CONFIG
-----------------------------

-- 单位
cfg.showtot = true				-- 显示"目标的目标"框体
cfg.showpet = true				-- 显示"宠物"框体
cfg.showfocus = true			-- 显示"焦点"框体
cfg.showfocustarget = true		-- 显示"焦点目标"框体
cfg.showBossFrame = true		-- 显示"Boss"框体

-- 团队&小队
cfg.ShowRaid = true				-- 显示团队框体
	cfg.RaidUnitWidth = 67		-- 团队框体单位宽度
	cfg.RaidPartyH = true		-- 团队框体中各小队横向排列
	cfg.showAuraWatch = true	-- 团队框体中显示边角Hot/技能监视
	cfg.showRaidDebuffs = true 	-- 显示RaidDebuff
	
cfg.ShowParty = false			-- 显示小队框体
	cfg.showPartyDebuff = true	-- 显示小队框体Debuff
	
cfg.raidScale = 1				-- 团队&小队缩放

-- Buff
cfg.showTargetBuff = true					-- 显示目标框体Buff
	cfg.BuffOnlyShowPlayer = false			-- 目标框体上只显示玩家的Buff
cfg.showTargetDebuff = true					-- 显示目标框体Debuff
	cfg.DebuffOnlyShowPlayer = false		-- 目标框体上只显示玩家的Debuff

cfg.showFocusDebuff = true					-- 显示焦点框体Buff
cfg.showFocusBuff = true 					-- 显示焦点框体Debuff
cfg.showBossBuff = true 					-- 显示Boss框体Buff
cfg.showBossDebuff = true					-- 显示Boss框体Debuff

-- 施法条
cfg.ShowCastbar = true				-- 显示施法条
	cfg.CastbarAlone = false		-- true : 独立大施法条 false : 依附于玩家头像之下的小施法条

-- 其他
cfg.RCheckIcon = true				-- 显示就位确认图标
cfg.ShowIncHeals = true				-- 显示治疗预估
cfg.showLFDIcons = true				-- 显示随机副本角色图标
cfg.scale = 1						-- 其他框体缩放


cfg.Solid = Media.."solid"
cfg.GlowTex = Media.."glowTex"

cfg.statusbar_texture = Media.."Statusbar"
cfg.powerbar_texture = Media.."Minimalist"
cfg.backdrop_texture = Media.."backdrop"
cfg.highlight_texture = Media.."raidbg"
cfg.debuffhighlight_texture = Media.."debuff_highlight"
cfg.backdrop_edge_texture = Media.."backdrop_edge"
cfg.spark = Media.."spark"
cfg.font = "Fonts\\ZYKai_T.ttf"
cfg.smallfont = "Fonts\\ZYKai_T.ttf"

-----------------------------
-- HANDOVER
-----------------------------

ns.cfg = cfg
