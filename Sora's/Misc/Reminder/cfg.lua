



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\s_Mini\\Reminder\\Media"
cfg.Font = ChatFrame1:GetFont()
cfg.Solid = Media.."gloss"
cfg.GlowTex = Media.."gloss"
cfg.Warning = Media.."Warning.mp3"


cfg.RaidBuffSize = 20											-- RaidBuff图标大小
cfg.RaidBuffSpace = 2											-- RaidBuff图标间距
cfg.RaidBuffDirection = 1										-- RaidBuff图标排列方向 1-横排 2-竖排
cfg.RaidBuffPos = {"TOP", Minimap, "BOTTOM", -55, 195}	-- RaidBuff图标位置
cfg.ShowOnlyInParty = false										-- 只在队伍中显示RaidBuff图标

cfg.ClassBuffSize = 48											-- ClassBuff图标大小
cfg.ClassBuffSpace = 40											-- ClassBuff图标间距
cfg.ClassBuffPos = {"CENTER", UIParent, "CENTER", -150, 150}	-- ClassBuff图标位置
cfg.ClassBuffSound = false										-- 开启缺失ClassBuf声音警报


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.RDConfig = cfg

