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

-- Units
cfg.showtot = true -- show target of target frame
cfg.showpet = true -- show pet frame
cfg.showfocus = true -- show focus frame
cfg.showfocustarget = true -- show focus target frame
cfg.showBossFrame = true -- show boss frame

-- Raid and Party
cfg.party_leader_icon = true	-- Show Leader Icon
cfg.ShowRaid = true				-- 显示团队框架
cfg.RaidUnitHeight = 21			-- 团队框架单位高度
cfg.RaidUnitWidth = 70			-- 团队框架单位高度
cfg.RaidPartyH = true			-- 团队框架中各小队横向排列  

-- Auras
cfg.showTargetBuffs = true -- show target buffs
cfg.showTargetDebuffs = true -- show target debuffs
cfg.showBossBuffs = true -- show target buffs
cfg.showBossDebuffs = true -- show target debuffs
cfg.debuffsOnlyShowPlayer = false -- only show your debuffs on target
cfg.buffsOnlyShowPlayer = false -- only show your buffs

-- Plugins
cfg.enableDebuffHighlight = true 	-- enable *dispelable* debuff highlight for raid frames
cfg.showRaidDebuffs = true 			-- enable important debuff icons to show on raid units
cfg.showAuraWatch = true			-- enable display of HoTs and important player buffs/debuffs on raid frames
cfg.Castbars = true					-- 显示施法条

-- Misc
cfg.RCheckIcon = true -- 显示就位确认图标
cfg.ShowIncHeals = true -- 显示治疗预估
cfg.showLFDIcons = true -- 显示随机副本角色图标

cfg.statusbar_texture = Media.."Statusbar"
cfg.powerbar_texture = Media.."Minimalist"
cfg.backdrop_texture = Media.."backdrop"
cfg.highlight_texture = Media.."raidbg"
cfg.debuffhighlight_texture = Media.."debuff_highlight"
cfg.backdrop_edge_texture = Media.."backdrop_edge"
cfg.spark = Media.."spark"
cfg.font = "Fonts\\ZYKai_T.ttf"
cfg.smallfont = "Fonts\\ZYKai_T.ttf"
cfg.raidScale = 1 -- scale factor for raid and party frames
cfg.scale = 1 -- scale factor for all other frames

-----------------------------
-- HANDOVER
-----------------------------

ns.cfg = cfg
