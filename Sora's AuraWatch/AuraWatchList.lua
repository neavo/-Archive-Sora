--[[

一些说明：

   Sora's AuraWatch对于Buff列表的管理是分组进行的,每一组Buff公用同一个定位点,同样的大小,同样的样式
   
   在组属性中
   {
		Name = 分组的名称
		Direction = 提示的增长方向 ("RIGHT"/"LEFT"/"UP"/"DOWN")
		Interval = 相邻提示的间距
		Mode = 提示模式(图标ICON 或者 计时条BAR)
		IconSize = 图标大小
		BarWidth = 计时条宽度(BAR模式下必须有这个属性)
		Pos = 首图标的定位点
		List = 要监视的Buff/Debuff/CD列表	
   }
   
   其中List =
   {
		AuraID/ItemID/SpellID = 三选一,分别对应监视 Buff/Debuff,物品CD,技能CD 三种情况
		UnitID = 要监视的目标,常用的有 玩家"player"/目标"target" (如果要监视Buff/Debuff的话必须有)
		Caster = 过滤Buff/Debuff的释放者 (可选,如果不需要按照施法者过滤请不要写这一项 ！！！注意,C为大写！！！ )
		Stack = 过滤Buff/Debuff的层数(可选,当Buff/Debuff层数大于等于Stack的值的时候才显示 ！！！注意,S为大写！！！)
	}

	eg. 这是一个示例
	{
		Name = "目标Debuff",
		Direction = "UP",
		Interval = 4,
		Mode = "BAR",
		IconSize = 16,
		BarWidth = 175,
		Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5},
		List = {
			-- 血之疫病
			{AuraID = 55078, UnitID = "target", Stack = 1},
			-- 冰霜疫病
			{AuraID = 55095, UnitID = "target", Caster = "player"},
			-- 不灭药水
			{ItemID = 40093},
		},
	},

]]

local _, SR = ...
local cfg = SR.AuraWatchConfig

SRAuraList = {
	-- 全职业
	["ALL"] = {
		{
			Name = "玩家Debuff",
			Direction = "RIGHT", Interval = 4,
			Mode = "ICON", IconSize = 54,
			Pos = {"CENTER", UIParent, "CENTER", -200, 200},
			List = {
				-- 变羊
				{AuraID =   118, UnitID = "player"},
				-- 制裁之锤
				{AuraID =   853, UnitID = "player"},
				-- 肾击
				{AuraID =   408, UnitID = "player"},
				-- 撕扯
				{AuraID = 47481, UnitID = "player"},
				-- 沉默
				{AuraID = 55021, UnitID = "player"},
				-- 割碎
				{AuraID = 22570, UnitID = "player"},
				-- 断筋
				{AuraID =  1715, UnitID = "player"},
			},
		},
	},

	-- 德鲁伊
	["DRUID"] = {
		{
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 节能施法
				{AuraID = 16870, UnitID = "player"},
				-- 自然之赐
				{AuraID = 16886, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 日蚀
				{AuraID = 48517, UnitID = "player"},			
				-- 月蚀
				{AuraID = 48518, UnitID = "player"},
				-- 狂暴(猫&熊)
				{AuraID = 50334, UnitID = "player"},
				-- 野蛮咆哮(猫)
				{AuraID = 52610, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
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
			Name = "目标Debuff",
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
				-- 割伤(熊)
				{AuraID = 33745, UnitID = "target", Caster = "player"},
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
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 治疗宠物
				{AuraID = 136, UnitID = "pet"},
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 急速射击
				{AuraID =  3045, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
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
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
				-- 准备,端枪,瞄准... ...
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
			Name = "目标Debuff",
			Direction = "UP", Interval = 4,
			Mode = "BAR",
			IconSize = 20, BarWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5},
			List = {
				-- 猎人印记
				{AuraID =  1130 ,UnitID = "target", Caster = "player"},
				-- 毒蛇钉刺
				{AuraID =  1978 ,UnitID = "target", Caster = "player"},
				-- 驱散射击
				{AuraID = 19503 ,UnitID = "target", Caster = "player"},
				-- 穿刺射击
				{AuraID = 63468 ,UnitID = "target", Caster = "player"},
			},
		},
	},
	
	-- 法师
	["MAGE"] = {
		{
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 奥术强化
				{AuraID = 12042, UnitID = "player"},
				-- 唤醒
				{AuraID = 12051, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 奥术冲击
				{AuraID = 36032, UnitID = "player"},				
				-- 寒冰指
				{AuraID = 44544, UnitID = "player"},
				-- 法术连击
				{AuraID = 48108, UnitID = "player"},
				-- 冰冷智慧
				{AuraID = 57761, UnitID = "player"},
				-- 冲击(等级1)
				{AuraID = 64343, UnitID = "player"},
				-- 奥术飞弹!
				{AuraID = 79683, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
				-- 灸灼
				{AuraID = 87023, UnitID = "player"},
			},
		},
		
		{
			Name = "目标Debuff",
			Direction = "UP", Interval = 4,
			Mode = "BAR",
			IconSize = 20, BarWidth = 175 ,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5},
			List = {		
				-- 点燃
				{AuraID = 12654 ,UnitID = "target", Caster = "player"},
				-- 临界炽焰
				{AuraID = 22959 ,UnitID = "target", Caster = "player"},
				-- 减速
				{AuraID = 31589 ,UnitID = "target", Caster = "player"},
				-- 活动炸弹
				{AuraID = 44457 ,UnitID = "target", Caster = "player"},
			},
		},
	},
	
	-- 战士
	["WARRIOR"] = {
		{
			Name = "玩家Buff",
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
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},				
				-- 横扫攻击(战斗,狂暴姿态)
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
				-- 法术发射(战斗,防御姿态)
				{AuraID = 23920, UnitID = "player"},
				-- 复苏之风(等级1)
				{AuraID = 29841, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
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
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
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
			Name = "目标Debuff",
			Direction = "UP", Interval = 4,
			Mode = "BAR", IconSize = 20, BarWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5},
			List = {
				-- 破甲
				{AuraID = 58567, UnitID = "target", Caster = "player"},
				-- 撕裂(战斗,防御姿态)
				{AuraID = 94009, UnitID = "target", Caster = "player"},
			},
		},
	},
	
	-- 萨满
	["SHAMAN"] = {
		{
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 25},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 闪电之盾
				{AuraID =   324, UnitID = "player"},
				-- 萨满之怒
				{AuraID = 30823, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 水之护盾
				{AuraID = 52127, UnitID = "player"},
				-- 潮汐奔涌
				{AuraID = 53390, UnitID = "player"},
				-- 5层漩涡武器
				{AuraID = 53817, UnitID = "player", Stack = 5},
				-- 灵魂行者的恩赐
				{AuraID = 79206, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
			},
		},
		{
			Name = "目标Debuff",
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
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 圣佑术
				{AuraID =   498, UnitID = "player"},
				-- 圣盾术
				{AuraID =   642, UnitID = "player"},
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
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
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 纯洁审判(等级3)
				{AuraID = 53657, UnitID = "player"},
				-- 圣光灌注(等级2)
				{AuraID = 54149, UnitID = "player"},
				-- 神圣恳求
				{AuraID = 54428, UnitID = "player"},
				-- 战争艺术
				{AuraID = 59578, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
				-- 异端裁决
				{AuraID = 84963, UnitID = "player"},
				-- 大十字军 (复仇盾)
				{AuraID = 85043, UnitID = "player"},
				-- 神圣使命 (盾击必暴)
				{AuraID = 85433, UnitID = "player"},
				-- 狂热
				{AuraID = 85696, UnitID = "player"},
				-- 远古列王守卫
				{AuraID = 86659, UnitID = "player"},
				-- 破晓
				{AuraID = 88819, UnitID = "player"},
				-- 神圣意志
				{AuraID = 90174, UnitID = "player"},
			},
		},
		{
			Name = "目标Debuff",
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
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 消散
				{AuraID = 47585, UnitID = "player"},
				-- 争分夺秒
				{AuraID = 59888, UnitID = "player"},			
				-- 妙手回春
				{AuraID = 63735, UnitID = "player"},
				-- 心灵融化
				{AuraID = 73510, UnitID = "player"},				-- 暗影宝珠
				{AuraID = 77487, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
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
				-- 圣光涌动(等级1)
				{AuraID = 88688, UnitID = "player"},
				-- 强效暗影
				{AuraID = 95799, UnitID = "player"},
			},
		},

		{
			Name = "目标Debuff",
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
			},
		},
	},

	-- 术士
	["WARLOCK"] = {
		{
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 暗影冥思
				{AuraID = 17941, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 反冲(等级3)
				{AuraID = 34939, UnitID = "player"},
				-- 小鬼增效
				{AuraID = 47283, UnitID = "player"},			
				-- 灭杀(等级2)
				{AuraID = 63158, UnitID = "player"},
				-- 灭杀
				{AuraID = 63167, UnitID = "player"},
				-- 熔火之心
				{AuraID = 71165, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
				-- 强化灵魂之火
				{AuraID = 85383, UnitID = "player"},
				-- 魔能火花
				{AuraID = 89937, UnitID = "player"},
			},
		},

		{
			Name = "目标Debuff",
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
			Name = "玩家Buff",
			Direction = "RIGHT", Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 佯攻
				{AuraID =  1966, UnitID = "player"},
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 切割
				{AuraID =  5171, UnitID = "player"},
				-- 冷血
				{AuraID = 14177, UnitID = "player"},
				-- 毒伤
				{AuraID = 32645, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
				-- 嫁祸诀窍
				{AuraID = 57934, UnitID = "player"},			
				-- 灭绝
				{AuraID = 58427, UnitID = "player"},
				-- 嫁祸诀窍
				{AuraID = 59628, UnitID = "player"},
				-- 养精蓄锐
				{AuraID = 73651, UnitID = "player"},
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
				-- 致命冲动
				{AuraID = 84590, UnitID = "player"},
				-- 洞悉弱点
				{AuraID = 84745, UnitID = "player"},
				-- 洞悉弱点
				{AuraID = 84746, UnitID = "player"},
				-- 洞悉弱点
				{AuraID = 84747, UnitID = "player"},
			}
		},
		
		{
			Name = "目标Debuff",
			Direction = "UP", Interval = 4,
			Mode = "BAR", IconSize = 20, BarWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 12, 5},
			List = {
				-- 肾击
				{AuraID =   408, UnitID = "target", Caster = "player"},
				-- 绞喉
				{AuraID =   408, UnitID = "target", Caster = "player"},
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
			Name = "玩家Buff",
			Direction = "RIGHT",Interval = 6,
			Mode = "ICON", IconSize = 30,
			Pos = {"BOTTOMLEFT", "oUF_SoraPlayer", "TOPLEFT", 0, 12},
			List = {
				-- 嗜血
				{AuraID =  2825, UnitID = "player"},
				-- 英勇气概
				{AuraID = 32182, UnitID = "player"},
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
				-- 时间扭曲
				{AuraID = 80353, UnitID = "player"},
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
			Name = "目标Debuff",
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
		--[[{
			Name = "CD",
			Direction = "DOWN",
			Interval = 4,
			Mode = "ICON",
			IconSize = 48,
			BarWidth = 175,
			Pos = {"CENTER", UIParent, "CENTER", 0, 100},
			List = {
				-- 随身邮箱
				{ItemID = 40768},
				-- 冰封之韧
				{SpellID = 48792},
				-- 反魔法护罩
				{SpellID = 48707},
			},
		},]]
	},
}