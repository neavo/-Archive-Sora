-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["AuraWatch"] = {}
local Module = DB["Modules"]["AuraWatch"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		-- 德鲁伊
		["DRUID"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 猎人
		["HUNTER"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 法师
		["MAGE"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 战士
		["WARRIOR"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 萨满
		["SHAMAN"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 圣骑士
		["PALADIN"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 牧师
		["PRIEST"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 术士
		["WARLOCK"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 盗贼
		["ROGUE"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
		-- 死亡骑士
		["DEATHKNIGHT"] = {
			{
				Name = "玩家减益", 
				Direction = "RIGHT", Interval = 10, 
				Mode = "ICON", IconSize = 48, 
				Pos = {"CENTER", "UIParent", "CENTER", -200, 200}, 
				List = {
					-- 变形术
					{AuraID =   118, UnitID = "player"},
					-- 肾击
					{AuraID =   408, UnitID = "player"},
					-- 制裁之锤
					{AuraID =   853, UnitID = "player"},
					-- 断筋
					{AuraID =  1715, UnitID = "player"},
					-- 恐惧嚎叫
					{AuraID =  5484, UnitID = "player"},
					-- 恐惧
					{AuraID =  5782, UnitID = "player"},
					-- 心灵尖啸
					{AuraID =  8122, UnitID = "player"},
					-- 沉默
					{AuraID = 15487, UnitID = "player"},
					-- 脚踢 - 沉默
					{AuraID = 18425, UnitID = "player"},
					-- 法术反制 - 沉默
					{AuraID = 18469, UnitID = "player"},
					-- 割碎
					{AuraID = 22570, UnitID = "player"},
					-- 震荡波
					{AuraID = 46968, UnitID = "player"},
					-- 绞袭
					{AuraID = 47476, UnitID = "player"},
					-- 撕扯
					{AuraID = 47481, UnitID = "player"},
					-- 沉默 - 强化法术反制
					{AuraID = 55021, UnitID = "player"},
					-- 心灵惊骇
					{AuraID = 64058, UnitID = "player"},
					-- 罪与罚
					{AuraID = 87204, UnitID = "player"},
					-- 沉默 - 强化脚踢
					{AuraID = 86759, UnitID = "player"},
					-- 寒冰锁链
					{AuraID = 45524, UnitID = "player"},
					-- 爆裂灰烬
					{AuraID = 79339, UnitID = "player"},
					-- 闪电魔棒
					{AuraID = 83099, UnitID = "player"},
					-- 噬体魔法
					{AuraID = 86622, UnitID = "player"},
					-- 暮光陨星
					{AuraID = 88518, UnitID = "player"},
					-- 熔岩打击
					{AuraID = 98492, UnitID = "player"},
					-- 灼熱種子
					{AuraID = 98450, UnitID = "player"},
					-- 受到折磨
					{AuraID = 99257, UnitID = "player"},
					-- 凝視
					{AuraID = 99849, UnitID = "player"},
					-- 燃燒之球
					{AuraID = 100210, UnitID = "player"},
					-- 折磨
					{AuraID = 100230, UnitID = "player"},
				},
			},
		}, 
	}
	if not AuraWatchDB then AuraWatchDB = {} end
	for key, value in pairs(Default[select(2, UnitClass("player"))]) do
		if AuraWatchDB[key] == nil then AuraWatchDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(AuraWatchDB)
end

-- BuildGUI
local GruopValue, AuraList, GroupSelectValue, AuraSelectValue = {}, {}, 1, 1
local function UpdateAuraList()
	AuraList = {
		AuraSelect = {
			type = "select", order = 1, 
			name = "选择Aura：", desc = "请选择Aura", 
			values = function()
				local Table = {}
				for key, value in pairs(AuraWatchDB[GroupSelectValue]["List"]) do
					if value["AuraID"] then Table[key] = GetSpellInfo(value["AuraID"]) or value["AuraID"] end
					if value["SpellID"] then Table[key] = GetSpellInfo(value["SpellID"]) or value["AuraID"] end
					if value["ItemID"] then Table[key] = GetItemInfo(value["ItemID"]) or value["AuraID"] end
				end
				return Table
			end, 
			get = function() return AuraSelectValue end, 
			set = function(_, value)
				AuraSelectValue = value
				UpdateAuraList()
			end, 
		}, 
		AddNewAura = {
			type = "execute", order = 2, 
			name = "添加Aura", 
			func = function()
				tinsert(AuraWatchDB[GroupSelectValue]["List"], {AuraID = 118, UnitID = "player"})
				AuraSelectValue = #AuraWatchDB[GroupSelectValue]["List"]
				UpdateAuraList()
			end, 
		}, 
		DeleteAura = {
			type = "execute", order = 3, 
			name = "删除Aura", 
			func = function()
				tremove(AuraWatchDB[GroupSelectValue]["List"], AuraSelectValue)
				AuraSelectValue = AuraSelectValue-1 > 0 and AuraSelectValue-1 or 1
				UpdateAuraList()
			end, 
		}, 
		AuraID = {
			type = "input", order = 4, 
			name = "AuraID：", desc = "请输入AuraID", 
			get = function()
				local Aura = AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]
				if Aura["AuraID"] then return tostring(Aura["AuraID"]) end
				if Aura["SpellID"] then return tostring(Aura["SpellID"]) end
				if Aura["ItemID"] then return tostring(Aura["ItemID"]) end			
			end, 
			set = function(_, value)
				local Aura = AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]
				if Aura["AuraID"] and GetSpellInfo(value) then Aura["AuraID"] = tonumber(value) return end
				if Aura["SpellID"] and GetSpellInfo(value) then Aura["SpellID"] = tonumber(value) return end
				if Aura["ItemID"] and GetItemInfo(value) then Aura["ItemID"] = tonumber(value) return end
			end,
		}, 
		Mode = {
			type = "select", order = 5, 
			name = "监视类型：", desc = "请选择监视类型：", 
			values = {["AuraID"] = "Aura", ["SpellID"] = "技能CD", ["ItemID"] = "物品CD"}, 
			get = function()
				local Aura = AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]
				if Aura["AuraID"] then return "AuraID" end
				if Aura["SpellID"] then return "SpellID" end
				if Aura["ItemID"] then return "ItemID" end	
			end, 
			set = function(_, value)
				local Aura = AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]
				if value == "AuraID" then Aura["AuraID"] = 118 Aura["SpellID"] = nil Aura["ItemID"] = nil end
				if value == "SpellID" then Aura["AuraID"] = nil Aura["SpellID"] = 118 Aura["ItemID"] = nil end
				if value == "ItemID" then Aura["AuraID"] = nil Aura["SpellID"] = nil Aura["ItemID"] = 6948 end
				UpdateAuraList()
			end, 
		}, 
		UnitID = {
			type = "select", order = 6, 
			name = "监视对象：", desc = "请选择监视对象：", 
			values = {["player"] = "玩家", ["target"] = "目标", ["pet"] = "宠物", ["focus"] = "焦点"}, 
			get = function() return AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["UnitID"] end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["UnitID"] = value end,
		}, 
		Caster = {
			type = "select", order = 7, 
			name = "施法者过滤：", desc = "请选择施法者过滤类型：", 
			values = {["player"] = "玩家", ["None"] = "无"}, 
			get = function() return AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] or "None" end, 
			set = function(_, value)
				if value == "None" then
					AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] = nil
				else
					AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Caster"] = value
				end
			end,
		}, 
		Stack = {
			type = "select", order = 8, 
			name = "堆叠层数过滤：", desc = "请选择堆叠过滤层数：", 
			values = {[0] = "无", [1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7, [8] = 8, [9] = 9}, 
			get = function() return AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] or 0 end, 
			set = function(_, value)
				if value == 0 then
					AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] = nil
				else
					AuraWatchDB[GroupSelectValue]["List"][AuraSelectValue]["Stack"] = value
				end
			end,
		}, 
	}
end
local function UpdateGruopValue()
	GruopValue = {
		GroupSelect = {
			type = "select", order = 1, 
			name = "选择分组：", desc = "请选择分组", 
			values = function()
				local Table = {}
				for key, value in pairs(AuraWatchDB) do Table[key] = value["Name"] end
				return Table
			end, 
			get = function() return GroupSelectValue end, 
			set = function(_, value)
				GroupSelectValue = value
				UpdateGruopValue()
				UpdateAuraList()
				AuraSelectValue = 1
			end, 
		}, 
		AddNewGroup = {
			type = "execute", order = 2, 
			name = "添加分组", 	
			func = function()
				tinsert(AuraWatchDB, {
					Name = "新分组", 
					Direction = "RIGHT", Interval = 8, 
					Mode = "ICON", IconSize = 48, 
					Pos = {"CENTER", "UIParent", "CENTER", 0, 0},
					List = {{AuraID = 118, UnitID = "player"}}
				})
				GroupSelectValue = #AuraWatchDB
				UpdateGruopValue()
			end, 
		}, 
		DeleteGroup = {
			type = "execute", order = 3, 
			name = "删除分组", 
			func = function()
				tremove(AuraWatchDB, GroupSelectValue)
				GroupSelectValue = GroupSelectValue-1 > 0 and GroupSelectValue-1 or 1
				UpdateGruopValue()
			end, 
		}, 
		GroupName = {
			type = "input", order = 4, 
			name = "分组名称：", desc = "请输入分组名称", 
			get = function() return AuraWatchDB[GroupSelectValue]["Name"] end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue]["Name"] = value end,
		}, 
		Mode = {
			type = "select", order = 4, 
			name = "显示模式：", desc = "请选择显示模式", 
			values = {["ICON"] = "图标模式", ["BAR"] = "计时条"}, 
			get = function() return AuraWatchDB[GroupSelectValue]["Mode"] end, 
			set = function(_, value)
				AuraWatchDB[GroupSelectValue]["Mode"] = value
				if not AuraWatchDB[GroupSelectValue]["BarWidth"] then AuraWatchDB[GroupSelectValue]["BarWidth"] = 200 end
			end, 
		}, 
		Direction = {
			type = "select", order = 5, 
			name = "增长方向：", desc = "请选择增长方向", 
			values = {["LEFT"] = "左", ["RIGHT"] = "右", ["UP"] = "上", ["DOWN"] = "下"}, 
			get = function() return AuraWatchDB[GroupSelectValue].Direction end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue].Direction = value end, 
		}, 
		Interval = {
			type = "range", order = 6, 
			name = "间距：", desc = "请输入间距", 
			min = 0, max = 30, step = 1, 
			get = function() return AuraWatchDB[GroupSelectValue].Interval end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue].Interval = value end, 
		}, 
		IconSize = {
			type = "range", order = 7, 
			name = "图标大小：", desc = "图标大小", 
			min = 8, max = 64, step = 1, 
			get = function() return AuraWatchDB[GroupSelectValue].IconSize end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue].IconSize = value end, 
		}, 
		BarWidth = {
			type = "range", order = 8, 
			name = "计时条宽度：", desc = "请输入计时条宽度", 
			min = 20, max = 300, step = 5, 
			get = function() return AuraWatchDB[GroupSelectValue]["BarWidth"] end, 
			set = function(_, value) AuraWatchDB[GroupSelectValue]["BarWidth"] = value end, 
		}, 		
	}
end
function Module.BuildGUI()
	UpdateGruopValue()
	UpdateAuraList()
	if DB["Config"] then
		DB["Config"]["AuraWatch"] =  {
			type = "group", order = 6,
			name = "技能监视", 
			args = {
				GruopValue= {
					type = "group", order = 2, 
					name = " ", guiInline = true, 
					args = GruopValue, 
				}, 
				AuraList = {
					type = "group", order = 3, 
					name = " ", guiInline = true, 
					args = AuraList, 
				}
			}
		}
	end
end


