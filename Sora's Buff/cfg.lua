



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's Buff\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.GlowTex = Media.."GlowTex"
cfg.Solid = Media.."Solid"
cfg.IconSize = 27 											-- 图标大小
cfg.Spacing = 4												-- 图标间距
cfg.BUFFpos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -5} 	-- BUFF位置
cfg.DEUFFpos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -130}	-- DEBUFF位置
cfg.BuffDirection = 1										-- Buff增长方向 1:从右向左 2:从左向右
cfg.DebuffDirection = 1										-- Debuff增长方向 1:从右向左 2:从左向右
cfg.WarningTime = 15										-- 闪耀提示的时间(秒)
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.BuffConfig = cfg

