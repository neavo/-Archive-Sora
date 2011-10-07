




------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's Chat\\Media\\"
cfg.Icon = "Interface\\Addons\\Sora's Chat\\icon\\"

cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.GlowTex = Media.."glowTex"
cfg.Statusbar = Media.."Statusbar"


cfg.AutoSet = true	-- 关闭自动设置(关闭后才能手动设置聊天框体)
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.ChatConfig = cfg