----------------
--  命名空间  --
----------------

local _, ns = ...
local Media = "InterFace\\AddOns\\!Sora's\\Media\\"
ns.cfg = CreateFrame("Frame")
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.GlowTex = Media.."GlowTex"
ns.cfg.Statusbar = Media.."Statusbar"
ns.cfg.Solid = Media.."Solid"