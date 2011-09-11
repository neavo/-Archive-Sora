




------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's\\Loot\\Media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.Solid = Media.."Solid"
cfg.Statusbar = Media.."Statusbar"

cfg.RollPos = {"CENTER", nil, "CENTER", 0, 0}		-- Roll框体位置
cfg.SuppressLootSpam = false						-- 屏蔽详细Roll点数信息
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.LootConfig = cfg