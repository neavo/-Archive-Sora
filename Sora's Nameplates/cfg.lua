



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local MediaPath = "Interface\\AddOns\\Sora's Nameplates\\Media\\"
cfg.statusbar_texture = MediaPath.."Statusbar"
cfg.backdrop_edge_texture = MediaPath.."glowTex"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.Fontsize = 10						-- 字体大小
cfg.Fontflag = "THINOUTLINE"			-- 字体描边
cfg.hpHeight = 5						-- 姓名板血条高度
cfg.hpWidth = 120						-- 姓名板血条宽度
cfg.raidIconSize = 18					-- 团队标记大小
cfg.cbIconSize = 20						-- 姓名板施法条图标大小
cfg.cbHeight = 5						-- 姓名板施法条高度
cfg.cbWidth = 100						-- 姓名板施法条宽度
cfg.CombatToggle = true					-- 进入/离开战斗自动开启/关闭姓名板
  
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.NPConfig = cfg