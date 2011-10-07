﻿




------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's Loot\\Media\\"
cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
cfg.Solid = Media.."Solid"
cfg.Statusbar = Media.."Statusbar"

----------------
--  命名空间  --
----------------

local _, SR = ...
SR.LootConfig = cfg