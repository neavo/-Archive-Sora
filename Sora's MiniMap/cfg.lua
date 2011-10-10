



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's MiniMap\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.GlowTex = Media.."GlowTex"
cfg.Solid = Media.."Solid"
cfg.Statusbar = Media.."Statusbar"

cfg.MinimapPos = {"TOPLEFT", UIParent, "TOPLEFT", 10, -30}	-- 小地图位置
	
----------------
--  命名空间  --
----------------

local _, ns = ...
ns.cfg = cfg
