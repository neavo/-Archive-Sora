



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's Threat\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.Statusbar = Media.."statusbar"
cfg.GlowTex = Media.."glowTex"
cfg.Solid = Media.."solid"
cfg.ArrowT = Media.."ArrowT"
cfg.Arrow = Media.."Arrow"
cfg.Pos = {"TOP", "oUF_SoraPlayer", "BOTTOM", 0, -60}	-- 仇恨条位置(已修正, 可以锚在任意框体上, 包括oUF头像)
cfg.ThreatBarWidth = 210								-- 仇恨条宽度
cfg.NameTextL = 3										-- 姓名长度(单位:字)
cfg.ThreatLimited = 2									-- 显示仇恨人数(不包括Tank)
	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.ThreatConfig = cfg

