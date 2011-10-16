-- Engines
local _, _, _, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):NewAddon("Sora")

local Media = "InterFace\\AddOns\\Sora's\\Media\\"
DB.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
DB.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
DB.Icon = "Interface\\Addons\\Sora's\\Modules\\Chat\\Icon\\"
DB.GlowTex = Media.."GlowTex"
DB.Statusbar = Media.."Statusbar"
DB.ThreatBar = Media.."ThreatBar"
DB.Solid = Media.."Solid"
DB.Button = Media.."Button"
DB.ArrowT = Media.."ArrowT"
DB.Arrow = Media.."Arrow"
DB.Warning = Media.."Warning.mp3"
DB.BuffPos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -5}
DB.DebuffPos = {"TOPRIGHT", UIParent, "TOPRIGHT", -5, -140}
DB.MinimapPos = {"TOPLEFT", UIParent, "TOPLEFT", 10, -30}
DB.RaidBuffPos = {"TOPLEFT", Minimap, "BOTTOMLEFT", -5, -25}
DB.ClassBuffPos = {"CENTER", UIParent, -150, 150}
DB.ThreatPos = {"TOP", "oUF_SoraPlayer", "BOTTOM", 0, -60}
DB.TooltipPos = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 201}
DB.Colors = {
	normal		= {r =   0, g =   0, b =    0},
	pushed 		= {r =   1, g =   1, b =    1},
	highlight 	= {r = 0.9, g = 0.8, b =  0.6},
	checked 	= {r = 0.9, g = 0.8, b =  0.6},
	outofrange 	= {r = 0.8, g = 0.3, b =  0.2},
	outofmana 	= {r = 0.3, g = 0.3, b =  0.7},
	usable 		= {r =   1, g =   1, b =    1},
	unusable 	= {r = 0.4, g = 0.4, b =  0.4},
}