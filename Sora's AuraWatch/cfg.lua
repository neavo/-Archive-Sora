



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's AuraWatch\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.Statusbar = Media.."Statusbar"
cfg.GlowTex = Media.."GlowTex"
cfg.Solid = Media.."Solid"
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.AuraWatchConfig = cfg

