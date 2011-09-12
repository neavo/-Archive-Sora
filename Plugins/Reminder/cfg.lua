



------------
--  设置  --
------------

local cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's\\Plugins\\Reminder\\Media\\"
cfg.Font = "Fonts\\ZYKai_T.ttf"
cfg.Solid = Media.."solid"
cfg.GlowTex = Media.."glowTex"
cfg.Warning = Media.."Warning.mp3"


cfg.RaidBuffSize = 18											-- RaidBuff图标大小
cfg.RaidBuffSpace = 4											-- RaidBuff图标间距
cfg.RaidBuffDirection = 1										-- RaidBuff图标排列方向 1-横排 2-竖排
cfg.RaidBuffPos = {"TOPLEFT", Minimap, "BOTTOMLEFT", -5, -35}	-- RaidBuff图标位置
cfg.ShowOnlyInParty = true										-- 只在队伍中显示RaidBuff图标

cfg.ClassBuffSize = 48											-- ClassBuff图标大小
cfg.ClassBuffSpace = 40											-- ClassBuff图标间距
cfg.ClassBuffPos = {"CENTER", UIParent, "CENTER", -150, 150}	-- ClassBuff图标位置
cfg.ClassBuffSound = true										-- 开启缺失ClassBuf声音警报


----------------
--  命名空间  --
----------------

local _, SR = ...
SR.RDConfig = cfg

