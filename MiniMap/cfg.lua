



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's\\MiniMap\\media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.GlowTex = Media.."glowTex"
cfg.Solid = Media.."solid"
cfg.Statusbar = Media.."statusbar"

cfg.MinimapPos = {"TOPLEFT", UIParent, "TOPLEFT", 10, -30}	-- 小地图位置
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.MapConfig = cfg
