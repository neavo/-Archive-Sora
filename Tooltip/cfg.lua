



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "InterFace\\AddOns\\Sora's\\Tooltip\\Media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.Fontsize = 11
cfg.GlowTex = Media.."glowTex"

cfg.colorborderClass = true											-- 边框职业着色
cfg.Cursor = true													-- 提示框体跟随鼠标
	cfg.Position = { "BOTTOMRIGHT", nil, "BOTTOMRIGHT", -50, 200 }	-- 如果不跟随鼠标,那提示框体的位置
cfg.HideInCombat = true 											-- 进入战斗自动隐藏提示框体


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.TooltipConfig = cfg

