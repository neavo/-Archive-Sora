



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "InterFace\\AddOns\\Sora's Tooltip\\Media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.GlowTex = Media.."glowTex"
cfg.Solid = Media.."Solid"
cfg.Statusbar = Media.."Statusbar"

cfg.Cursor = true														-- 提示框体跟随鼠标
	cfg.Position = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 201}		-- 如果不跟随鼠标,那提示框体的位置
cfg.HideInCombat = true 												-- 进入战斗自动隐藏提示框体


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.TooltipConfig = cfg

