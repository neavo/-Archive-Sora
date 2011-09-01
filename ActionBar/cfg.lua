



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's\\ActionBar\\Media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.Texture = Media.."icon"
cfg.GlowTex = Media.."glowTex"
cfg.HideHotKey = false		-- remove key binding text from the bars
cfg.HideMacroName = true	-- remove macro name text from the bars
cfg.CountFontSize = 10		-- remove count text from the bars
cfg.HotkeyFontSize = 10		-- font size for the key bindings text
cfg.NameFontSize = 10		-- font size for the macro name text

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

