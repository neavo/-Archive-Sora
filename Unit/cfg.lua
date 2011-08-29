  -----------------------------
  -- INIT
  -----------------------------

local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = CreateFrame("Frame")
local mediaFolder = "Interface\\AddOns\\Sora's\\Unit\\media\\"	-- don't touch this ...

  -----------------------------
  -- CONFIG
  -----------------------------
  
  -- Units
  cfg.showtot = true -- show target of target frame
  cfg.showpet = true -- show pet frame
  cfg.showfocus = true -- show focus frame
  cfg.showfocustarget = true -- show focus target frame
  cfg.ShowPlayerName = true -- show player's name and level
  cfg.showBossFrame = true -- show boss frame
  
  -- Raid and Party
  cfg.party_leader_icon = true -- Show Leader Icon
  cfg.ShowRaid = true -- show raid frames
  cfg.RaidUnitHeight = 24 -- 团队框架单位高度
  cfg.RaidUnitWidth = 78 -- 团队框架单位高度
  cfg.RaidPartyH = true -- 团队框架中各小队横向排列  
  
  -- Auras
  cfg.showPlayerAuras = false -- use a custom player buffs/debuffs frame instead of Blizzard's default.
  cfg.showTargetBuffs = true -- show target buffs
  cfg.showTargetDebuffs = true -- show target debuffs
  cfg.showBossBuffs = true -- show target buffs
  cfg.showBossDebuffs = true -- show target debuffs
  cfg.debuffsOnlyShowPlayer = false -- only show your debuffs on target
  cfg.buffsOnlyShowPlayer = false -- only show your buffs

  -- Plugins
  cfg.enableDebuffHighlight = true -- enable *dispelable* debuff highlight for raid frames
  cfg.showRaidDebuffs = true -- enable important debuff icons to show on raid units
  cfg.showAuraWatch = true -- enable display of HoTs and important player buffs/debuffs on raid frames
  cfg.Castbars = true

  -- Misc
  cfg.showRunebar = true -- show DK's rune bar
  cfg.showHolybar = true -- show Paladin's HolyPower bar
  cfg.showEclipsebar = true -- show druidz's Eclipse bar
  cfg.showShardbar = true -- show Warlock's SoulShard bar
  cfg.showTotemBar = true -- show Shaman Totem timer bar
  cfg.RCheckIcon = true -- show raid check icon
  cfg.ShowIncHeals = true -- Show incoming heals in player and raid frames
  cfg.showLFDIcons = true -- Show dungeon role icons in raid/party
  
  cfg.statusbar_texture = mediaFolder.."Statusbar"
  cfg.powerbar_texture = mediaFolder.."Minimalist"
  cfg.backdrop_texture = mediaFolder.."backdrop"
  cfg.highlight_texture = mediaFolder.."raidbg"
  cfg.debuffhighlight_texture = mediaFolder.."debuff_highlight"
  cfg.backdrop_edge_texture = mediaFolder.."backdrop_edge"
  cfg.debuffBorder = mediaFolder.."iconborder"
  cfg.spark = mediaFolder.."spark"
  cfg.font = "Fonts\\ZYKai_T.ttf"
  cfg.smallfont = "Fonts\\ZYKai_T.ttf"
  cfg.raidScale = 0.95 -- scale factor for raid and party frames
  cfg.scale = 1 -- scale factor for all other frames
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  ns.cfg = cfg
