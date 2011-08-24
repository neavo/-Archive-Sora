



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's\\Bags\\media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.edgeFile = Media.."glowTex"
cfg.Scale = 1 												-- 背包缩放
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.BagConfig = cfg
