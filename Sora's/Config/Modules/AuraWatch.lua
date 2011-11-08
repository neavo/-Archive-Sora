-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- Init
C.AuraWatch = {}

-- LoadSettings
function C.AuraWatch.LoadSettings()
	local Default = {
		-- 德鲁伊
		["DRUID"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 节能施法
					{AuraID = 16870, UnitID = "player"}, 
					-- 自然之赐
					{AuraID = 16886, UnitID = "player"}, 
					-- 日蚀
					{AuraID = 48517, UnitID = "player"}, 			
					-- 月蚀
					{AuraID = 48518, UnitID = "player"}, 
					-- 野蛮咆哮(猫)
					{AuraID = 52610, UnitID = "player"}, 
					-- 粉碎
					{AuraID = 80951, UnitID = "player"}, 
					-- 月光淋漓
					{AuraID = 81192, UnitID = "player"}, 
					-- 坠星
					{AuraID = 93400, UnitID = "player"}, 
					-- 狂暴
					{AuraID = 93622, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {	
					-- 挫志咆哮(熊)
					{AuraID =    99, UnitID = "target", Caster = "player"}, 
					-- 回春术
					{AuraID =   774, UnitID = "target", Caster = "player"}, 
					-- 割裂(猫)
					{AuraID =  1079, UnitID = "target", Caster = "player"}, 
					-- 斜掠(猫)
					{AuraID =  1822, UnitID = "target", Caster = "player"}, 			
					-- 虫群
					{AuraID =  5570, UnitID = "target", Caster = "player"}, 
					-- 月火术
					{AuraID =  8921, UnitID = "target", Caster = "player"}, 
					-- 生命绽放
					{AuraID = 33763, UnitID = "target", Caster = "player"}, 			
					-- 裂伤(猫)
					{AuraID = 33876, UnitID = "target", Caster = "player"}, 
					-- 野蛮咆哮(猫)
					{AuraID = 52610, UnitID = "target", Caster = "player"}, 
					-- 阳炎术
					{AuraID = 93402, UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 猎人
		["HUNTER"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 治疗宠物
					{AuraID =   136, UnitID =    "pet"}, 
					-- 急速射击
					{AuraID =  3045, UnitID = "player"}, 
					-- 野兽之心
					{AuraID = 34471, UnitID = "player"}, 
					-- 误导
					{AuraID = 34477, UnitID = "player"}, 			
					-- 强化稳固射击
					{AuraID = 53220, UnitID = "player"}, 
					-- 眼镜蛇打击
					{AuraID = 53257, UnitID = "player"}, 
					-- 野性呼唤
					{AuraID = 53434, UnitID = "player"}, 
					-- 荷枪实弹
					{AuraID = 56453, UnitID = "player"}, 
					-- 攻击弱点
					{AuraID = 70728, UnitID = "player"}, 
					-- 准备, 端枪, 瞄准... ...
					{AuraID = 82925, UnitID = "player"}, 
					-- 开火!
					{AuraID = 82926, UnitID = "player"}, 
					-- 上!
					{AuraID = 89388, UnitID = "player"}, 
					-- 血性大发
					{AuraID = 94007, UnitID = "player"}, 
					-- X光瞄准
					{AuraID = 95712, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", 
				IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 猎人印记
					{AuraID =  1130 , UnitID = "target", Caster = "player"}, 
					-- 毒蛇钉刺
					{AuraID =  1978 , UnitID = "target", Caster = "player"}, 
					-- 驱散射击
					{AuraID = 19503 , UnitID = "target", Caster = "player"}, 
					-- 穿刺射击
					{AuraID = 63468 , UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 法师
		["MAGE"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 烈焰风暴
					{AuraID =  2120, UnitID = "player"},
					-- 奥术强化
					{AuraID = 12042, UnitID = "player"},
					-- 唤醒
					{AuraID = 12051, UnitID = "player"},
					-- 节能施法
					{AuraID = 12536, UnitID = "player"},
					-- 龙息术
					{AuraID = 31661, UnitID = "player"},
					-- 隐形术
					{AuraID = 32612, UnitID = "player"},
					-- 奥术冲击
					{AuraID = 36032, UnitID = "player"},
					-- 咒术吸收
					{AuraID = 44413, UnitID = "player"},
					-- 寒冰指
					{AuraID = 44544, UnitID = "player"},
					-- 法术连击
					{AuraID = 48108, UnitID = "player"},
					-- 镜像
					{AuraID = 55342, UnitID = "player"},
					-- 专注魔法
					{AuraID = 54648, UnitID = "player"},
					-- 火球！
					{AuraID = 57761, UnitID = "player"},
					-- 冲击
					{AuraID = 64343, UnitID = "player"},
					-- 奥术飞弹！
					{AuraID = 79683, UnitID = "player"},
					-- 灸灼
					{AuraID = 87023, UnitID = "player"},	
					-- 强化法力宝石
					{AuraID = 83098, UnitID = "player"},
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", 
				IconSize = 20, BarWidth = 175 , 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {		
					-- 点燃
					{AuraID = 12654 ,UnitID = "target", Caster = "player"},
					-- 强化灼烧
					{AuraID = 22959 ,UnitID = "target", Caster = "player"},
					-- 减速
					{AuraID = 31589 ,UnitID = "target", Caster = "player"},
					-- 深度冻结
					{AuraID = 44572, UnitID = "target", Caster = "player"},
					-- 活动炸弹
					{AuraID = 44457 ,UnitID = "target", Caster = "player"},
					-- 燃烧
					{AuraID = 83853, UnitID = "target", Caster = "player"},
				}, 
			}, 
		}, 
		-- 战士
		["WARRIOR"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 盾墙(防御姿态)
					{AuraID =   871, UnitID = "player"}, 
					-- 怒火中烧
					{AuraID =  1134, UnitID = "player"}, 
					-- 盾牌格挡(防御姿态)
					{AuraID =  2565, UnitID = "player"}, 			
					-- 横扫攻击(战斗, 狂暴姿态)
					{AuraID = 12328, UnitID = "player"}, 
					-- 战斗专注
					{AuraID = 12964, UnitID = "player"}, 
					-- 破釜沉舟
					{AuraID = 12975, UnitID = "player"}, 
					-- 血之狂热
					{AuraID = 16491, UnitID = "player"}, 
					-- 反击风暴(战斗姿态)
					{AuraID = 20230, UnitID = "player"}, 
					-- 嗜血
					{AuraID = 23885, UnitID = "player"}, 
					-- 法术反射(战斗, 防御姿态)
					{AuraID = 23920, UnitID = "player"}, 
					-- 复苏之风(等级1)
					{AuraID = 29841, UnitID = "player"}, 
					-- 胜利
					{AuraID = 32216, UnitID = "player"}, 
					-- 血脉喷张
					{AuraID = 46916, UnitID = "player"}, 
					-- 剑盾猛攻
					{AuraID = 50227, UnitID = "player"}, 
					-- 猝死
					{AuraID = 55694, UnitID = "player"}, 
					-- 激怒(等级2)
					{AuraID = 57519, UnitID = "player"}, 
					-- 血之气息
					{AuraID = 60503, UnitID = "player"}, 
					-- 主宰
					{AuraID = 65156, UnitID = "player"}, 
					-- 胜利
					{AuraID = 82368, UnitID = "player"}, 
					-- 屠夫(等级3)
					{AuraID = 84586, UnitID = "player"}, 
					-- 坚守阵地
					{AuraID = 84620, UnitID = "player"}, 
					-- 致命平静
					{AuraID = 85730, UnitID = "player"}, 
					-- 激动
					{AuraID = 86627, UnitID = "player"}, 
					-- 雷霆余震
					{AuraID = 87096, UnitID = "player"}, 
					-- 行刑者
					{AuraID = 90806, UnitID = "player"}, 
				}, 
			}, 	
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 破甲
					{AuraID = 58567, UnitID = "target", Caster = "player"}, 
					-- 撕裂
					{AuraID = 94009, UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 萨满
		["SHAMAN"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 58},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 25}, 
				List = {
					-- 闪电之盾
					{AuraID =   324, UnitID = "player"}, 
					-- 萨满之怒
					{AuraID = 30823, UnitID = "player"}, 
					-- 水之护盾
					{AuraID = 52127, UnitID = "player"}, 
					-- 潮汐奔涌
					{AuraID = 53390, UnitID = "player"}, 
					-- 5层漩涡武器
					{AuraID = 53817, UnitID = "player", Stack = 5}, 
					-- 灵魂行者的恩赐
					{AuraID = 79206, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 大地震击
					{AuraID =  8042, UnitID = "target", Caster = "player"}, 
					-- 烈焰震击
					{AuraID =  8050, UnitID = "target", Caster = "player"}, 
					-- 冰霜震击
					{AuraID =  8056, UnitID = "target", Caster = "player"}, 
					-- 风暴打击
					{AuraID = 17364, UnitID = "target", Caster = "player"}, 
					-- 灼热烈焰
					{AuraID = 77661, UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 圣骑士
		["PALADIN"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 圣佑术
					{AuraID =   498, UnitID = "player"}, 
					-- 圣盾术
					{AuraID =   642, UnitID = "player"}, 
					-- 神恩术
					{AuraID = 31842, UnitID = "player"}, 
					-- 神圣之盾
					{AuraID = 20925, UnitID = "player"}, 
					-- 智者审判
					{AuraID = 31930, UnitID = "player"}, 		
					-- 复仇之怒
					{AuraID = 31884, UnitID = "player"}, 
					-- 炙热防御者
					{AuraID = 31850, UnitID = "player"}, 
					-- 纯洁审判
					{AuraID = 53657, UnitID = "player"}, 
					-- 圣光灌注
					{AuraID = 54149, UnitID = "player"}, 
					-- 神圣恳求
					{AuraID = 54428, UnitID = "player"}, 
					-- 战争艺术
					{AuraID = 59578, UnitID = "player"}, 
					-- 异端裁决
					{AuraID = 84963, UnitID = "player"}, 
					-- 大十字军(刷新飞盾)
					{AuraID = 85043, UnitID = "player"}, 
					-- 神圣使命(盾猛必暴)
					{AuraID = 85433, UnitID = "player"}, 
					-- 狂热
					{AuraID = 85696, UnitID = "player"}, 
					-- 远古列王守卫
					{AuraID = 86659, UnitID = "player"}, 
					-- 破晓
					{AuraID = 88819, UnitID = "player"}, 
					-- 神圣意志
					{AuraID = 90174, UnitID = "player"}, 
					-- 烈焰庇护(防护T12x4)
					{AuraID = 99090, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 制裁之锤
					{AuraID =   853, UnitID = "target", Caster = "player"}, 
					-- 神圣愤怒
					{AuraID =  2812, UnitID = "target", Caster = "player"}, 
					-- 超度邪恶
					{AuraID = 10326, UnitID = "target", Caster = "player"}, 
					-- 忏悔
					{AuraID = 20066, UnitID = "target", Caster = "player"}, 
					-- 辩护
					{AuraID = 26017, UnitID = "target", Caster = "player"}, 
					-- 圣光道标
					{AuraID = 53563, UnitID = "target", Caster = "player"}, 
					-- 正义审判
					{AuraID = 68055, UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 牧师
		["PRIEST"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 渐隐
					{AuraID =  586, UnitID = "player"}, 
					-- 心灵专注
					{AuraID = 14751, UnitID = "player"}, 				
					-- 灵感
					{AuraID = 14893, UnitID = "player"}, 
					-- 圣光涌动
					{AuraID = 33150, UnitID = "player"},
					-- 消散
					{AuraID = 47585, UnitID = "player"}, 
					-- 守护之魂
					{AuraID = 47788, UnitID = "player"}, 
					-- 争分夺秒
					{AuraID = 59887, UnitID = "player"},			
					-- 妙手回春
					{AuraID = 63735, UnitID = "player"}, 
					-- 好运
					{AuraID = 63731, UnitID = "player"}, 
					-- 暗影宝珠
					{AuraID = 77487, UnitID = "player"}, 
					-- 精神分流雕文
					{AuraID = 81301, UnitID = "player"}, 
					-- 真言术:障
					{AuraID = 81782, UnitID = "player"}, 
					-- 黑暗福音
					{AuraID = 87118, UnitID = "player"}, 
					-- 天使长
					{AuraID = 87152, UnitID = "player"}, 
					-- 黑暗天使长
					{AuraID = 87153, UnitID = "player"}, 
					-- 福音传播
					{AuraID = 81661, UnitID = "player"}, 
					-- 心灵融化
					{AuraID = 87160, UnitID = "player"}, 
					-- 强效暗影
					{AuraID = 95799, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 暗言术:痛
					{AuraID =   589, UnitID = "target", Caster = "player"}, 
					-- 噬灵疫病
					{AuraID =  2944, UnitID = "target", Caster = "player"}, 
					-- 虚弱灵魂
					{AuraID =  6788, UnitID = "target", Caster = "player"}, 
					-- 吸血鬼之触
					{AuraID = 34914, UnitID = "target", Caster = "player"}, 
					-- 神圣庇护
					{AuraID = 47753, UnitID = "target", Caster = "player"}, 
					-- 圣言术：罚
					{AuraID = 88625, UnitID = "target", Caster = "player"}, 
					-- 圣言术：静
					{AuraID = 88684, UnitID = "target", Caster = "player"}, 
				}, 
			}, 
		}, 
		-- 术士
		["WARLOCK"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 暗影冥思
					{AuraID = 17941, UnitID = "player"}, 
					-- 反冲
					{AuraID = 34939, UnitID = "player"}, 
					-- 小鬼增效
					{AuraID = 47283, UnitID = "player"}, 			
					-- 灭杀
					{AuraID = 63158, UnitID = "player"}, 
					-- 灭杀
					{AuraID = 63167, UnitID = "player"}, 
					-- 熔火之心
					{AuraID = 71165, UnitID = "player"}, 
					-- 强化灵魂之火
					{AuraID = 85383, UnitID = "player"}, 
					-- 魔能火花
					{AuraID = 89937, UnitID = "player"}, 
				}, 
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 腐蚀术
					{AuraID =   172, UnitID = "target", Caster = "player"}, 
					-- 献祭
					{AuraID =   348, UnitID = "target", Caster = "player"}, 
					-- 末日灾祸
					{AuraID =   603, UnitID = "target", Caster = "player"}, 
					-- 痛苦灾祸
					{AuraID =   980, UnitID = "target", Caster = "player"}, 
					-- 元素诅咒
					{AuraID =  1490, UnitID = "target", Caster = "player"}, 
					-- 暗影烈焰 (强化暗箭)
					{AuraID = 17800, UnitID = "target", Caster = "player"}, 
					-- 烧尽
					{AuraID = 29722, UnitID = "target", Caster = "player"}, 
					-- 痛苦无常
					{AuraID = 30108, UnitID = "target", Caster = "player"}, 
					-- 暗影之拥
					{AuraID = 32389, UnitID = "target", Caster = "player"}, 
					-- 鬼影缠身
					{AuraID = 48181, UnitID = "target", Caster = "player"}, 
					-- 混乱之箭
					{AuraID = 50796, UnitID = "target", Caster = "player"}, 
					-- 浩劫灾祸
					{AuraID = 80240, UnitID = "target", Caster = "player"}, 
					-- 古尔丹邪咒
					{AuraID = 86000, UnitID = "target", Caster = "player"}, 
				}, 
			}, 	
		}, 
		-- 盗贼
		["ROGUE"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 佯攻
					{AuraID =  1966, UnitID = "player"}, 
					-- 切割
					{AuraID =  5171, UnitID = "player"}, 
					-- 冲动
					{AuraID = 13750, UnitID = "player"},
					-- 剑刃乱舞
					{AuraID = 13877, UnitID = "player"},
					-- 冷血
					{AuraID = 14177, UnitID = "player"}, 
					-- 毒伤
					{AuraID = 32645, UnitID = "player"}, 
					-- 嫁祸诀窍
					{AuraID = 57934, UnitID = "player"}, 			
					-- 灭绝
					{AuraID = 58427, UnitID = "player"}, 
					-- 养精蓄锐
					{AuraID = 73651, UnitID = "player"}, 
					-- 致命冲动
					{AuraID = 84590, UnitID = "player"}, 
					-- 初步洞悉
					{AuraID = 84745, UnitID = "player"},
					-- 中等洞悉
					{AuraID = 84746, UnitID = "player"}, 
					-- 深度洞悉
					{AuraID = 84747, UnitID = "player"}, 
				}
			}, 
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 20, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 肾击
					{AuraID =   408, UnitID = "target", Caster = "player"}, 
					-- 绞喉
					{AuraID =   703, UnitID = "target", Caster = "player"}, 
					-- 偷袭
					{AuraID =  1833, UnitID = "target", Caster = "player"}, 
					-- 割裂
					{AuraID =  1943, UnitID = "target", Caster = "player"}, 
					-- 破甲
					{AuraID =  8647, UnitID = "target", Caster = "player"}, 
					-- 缴械
					{AuraID = 51722, UnitID = "target", Caster = "player"}, 
					-- 要害打击
					{AuraID = 84617, UnitID = "target", Caster = "player"}, 
					-- 仇杀
					{AuraID = 79140, UnitID = "target", Caster = "player"}, 
				}
			}, 
				
		}, 
		-- 死亡骑士
		["DEATHKNIGHT"] = {
			{
				Name = "玩家Debuff", 
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
			{
				Name = "玩家重要增益",
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 45},
				List = {
					-- 邪恶狂热
					{AuraID =  8699, UnitID = "player"},
					-- 能量灌注
					{AuraID = 10060, UnitID = "player"},
					-- 英勇
					{AuraID = 32182, UnitID = "player"}, 
					-- 痛苦压制
					{AuraID = 33206, UnitID = "player"},
					-- 反魔法领域
					{AuraID = 50461, UnitID = "player"},
					-- 神圣牺牲
					{AuraID = 64205, UnitID = "player"},
					-- 能量洪流
					{AuraID = 74241, UnitID = "player"},
					-- 山崩
					{AuraID = 74245, UnitID = "player"},
					-- 亮纹
					{AuraID = 75170, UnitID = "player"},
					-- 火山能量
					{AuraID = 79476, UnitID = "player"},
					-- 托维尔敏捷
					{AuraID = 79633, UnitID = "player"},
					-- 傀儡的力量
					{AuraID = 79634, UnitID = "player"},
					-- 时间扭曲
					{AuraID = 80353, UnitID = "player"},
					-- 真言术：障
					{AuraID = 81781, UnitID = "player"},
					-- 火山毁灭
					{AuraID = 89091, UnitID = "player"},
					-- 远古狂乱
					{AuraID = 90355, UnitID = "player"},
					-- 灾难魔法
					{AuraID = 92318, UnitID = "player"},
					-- 吞噬
					{AuraID = 96911, UnitID = "player"},
					-- 神经元弹簧
					{AuraID = 96230, UnitID = "player"},
					-- 电荷
					{AuraID = 96890, UnitID = "player"},
					-- 火焰之王的印记
					{AuraID = 97007, UnitID = "player"},
					-- 火焰精粹
					{AuraID = 97008, UnitID = "player"},
					-- 上古化石种子
					{AuraID = 97009, UnitID = "player"},
					-- 灵魂残片
					{AuraID = 97131, UnitID = "player"},
					-- 集结呐喊
					{AuraID = 97463, UnitID = "player"},
					-- 灵魂链接图腾
					{AuraID = 98007, UnitID = "player"},
					-- 燧鎖的發射器
					{AuraID = 99621, UnitID = "player"},
				},
			},
			{
				Name = "玩家增益", 
				Direction = "RIGHT", Interval = 6, 
				Mode = "ICON", IconSize = 30, 
				Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12}, 
				List = {
					-- 利刃屏障
					{AuraID = 64856, UnitID = "player"}, 
					-- 反魔法护罩
					{AuraID = 48707, UnitID = "player"}, 
					-- 冰封之韧
					{AuraID = 48792, UnitID = "player"}, 
					-- 末日突降
					{AuraID = 49018, UnitID = "player"}, 			
					-- 巫妖之躯
					{AuraID = 49039, UnitID = "player"}, 
					-- 白骨之盾
					{AuraID = 49222, UnitID = "player"}, 
					-- 杀戮机器
					{AuraID = 51124, UnitID = "player"}, 
					-- 灰烬冰川
					{AuraID = 53386, UnitID = "player"}, 
					-- 吸血鬼之血
					{AuraID = 55233, UnitID = "player"}, 
					-- 冰冻之雾
					{AuraID = 59052, UnitID = "player"}, 
					-- 赤色天灾
					{AuraID = 81141, UnitID = "player"}, 
					-- 大墓地的意志
					{AuraID = 81162, UnitID = "player"}, 
					-- 符文刃舞
					{AuraID = 81256, UnitID = "player"}, 
					-- 暗影灌注
					{AuraID = 91342, UnitID = "pet"}, 
				}, 
			}, 	
			{
				Name = "目标减益", 
				Direction = "UP", Interval = 4, 
				Mode = "BAR", IconSize = 16, BarWidth = 175, 
				Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5}, 
				List = {
					-- 血之疫病
					{AuraID = 55078, UnitID = "target", Caster = "player"}, 
					-- 冰霜疫病
					{AuraID = 55095, UnitID = "target", Caster = "player"}, 
					-- 血红热疫
					{AuraID = 81130, UnitID = "target", Caster = "player"}, 
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
function C.AuraWatch.ResetToDefault()
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
				if Aura["AuraID"] then Aura["AuraID"] = tonumber(value) end
				if Aura["SpellID"] then Aura["SpellID"] = tonumber(value) end
				if Aura["ItemID"] then Aura["ItemID"] = tonumber(value) end
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
				if not AuraWatchDB[GroupSelectValue]["BarWidth"] then AuraWatchDB[GroupSelectValue]["BarWidth"] = 175 end
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
function C.AuraWatch.BuildGUI()
	UpdateGruopValue()
	UpdateAuraList()
	if Modules then
		Modules["AuraWatch"] =  {
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


