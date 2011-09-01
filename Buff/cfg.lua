



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's\\Buff\\media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.bgFile = Media.."iconborder"
cfg.edgeFile = Media.."glowTex"
cfg.IconSize = 30 											-- 图标大小
cfg.Spacing = 4												-- 图标间距
cfg.BUFFpos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -5} 	-- BUFF位置
cfg.DEUFFpos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -130}	-- DEBUFF位置
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.BuffConfig = cfg

