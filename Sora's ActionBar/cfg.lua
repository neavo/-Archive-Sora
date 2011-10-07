



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's ActionBar\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.Texture = Media.."icon"
cfg.GlowTex = Media.."glowTex"
cfg.Solid = Media.."solid"

cfg.HideHotKey = false		-- 隐藏快捷键显示
cfg.HideMacroName = true	-- 隐藏宏名称显示
cfg.CountFontSize = 10		-- 计数字体大小
cfg.HotkeyFontSize = 10		-- 快捷键字体大小
cfg.NameFontSize = 10		-- 宏名称字体大小
cfg.ShowExtraBar = true		-- 显示侧边栏

cfg.colors = {
	normal		= {r =    0,	g =    0, 	b =    0	},
	pushed 		= {r =	  1,	g =    1, 	b =    1	},
	highlight 	= {r =  0.9,	g =  0.8,	b =  0.6	},
	checked 	= {r =  0.9,	g =  0.8,	b =  0.6	},
	outofrange 	= {r =  0.8,	g =  0.3, 	b =  0.2	},
	outofmana 	= {r =  0.3,	g =  0.3, 	b =  0.7	},
	usable 		= {r =    1,	g =	   1, 	b =    1	},
	unusable 	= {r =  0.4,	g =  0.4, 	b =  0.4	},
 }

	
----------------
--  命名空间  --
----------------

local _, SR = ...
SR.ActionBarConfig = cfg

