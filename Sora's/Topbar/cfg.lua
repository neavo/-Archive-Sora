

------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "InterFace\\AddOns\\Sora's\\Topbar\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.GlowTex = Media.."glowTex"
cfg.Statusbar = Media.."statusbar"


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.TopBarConfig = cfg

