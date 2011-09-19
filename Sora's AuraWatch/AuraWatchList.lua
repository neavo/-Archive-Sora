--[[

	Sora's AuraWatch对于Buff列表的管理是分组进行的,每一组Buff公用同一个定位点,同样的大小,同样的样式
	
	在组属性中
	{
		Name = 分组的名称
		Direction = 提示的增长方向 ("RIGHT"/"LEFT"/"UP"/"DOWN")
		Interval = 相邻提示的间距
		Mode = 提示模式(图标ICON 或者 计时条BAR)
		iconSize = 图标大小
		barWidth = 计时条宽度(BAR模式下必须有这个属性)
		Pos = 首图标的定位点
		List = 要监视的Buff/Debuff/CD列表
	}
	
	其中List = 
	{
		spellID = 要监视的Buff/Debuff/技能 ID (必须有)
		unitId = 要监视的目标，常用的有 玩家"player"/目标"target" (必须有)
		Filter = 要监视的类型， "BUFF"/"DEBUFF"/"CD" (必须有)
		Caster = 过滤Buff/Debuff的释放者 (可选，如果不需要按照施法者过滤请不要写这一项)
		Stack = 过滤Buff/Debuff的层数(可选，当Buff/Debuff层数大于等于Stack的值的时候才显示)
	}

	eg. 这是一个示例
	{
		Name = "TargetDebuff",
		Direction = "UP",
		Interval = 4,
		Mode = "BAR",
		iconSize = 16,
		barWidth = 175,
		Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
		List = {
			--血之疫病
			{spellID = 55078, unitId = "target", Filter = "DEBUFF", Stack = 1},
			--冰霜疫病
			{spellID = 55095, unitId = "target", Filter = "DEBUFF", Caster = "player"},
		},
	},

]]


----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

SRAuraList = {
	-- 全职业
	["ALL"] = {
		{
			Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			iconSize = 54,
			Pos = {"CENTER", UIParent, "CENTER", -200, 200},
			List = {
				--变羊
				{spellID =   118, unitId = "player", Filter = "DEBUFF"},
				--制裁之锤
				{spellID =   853, unitId = "player", Filter = "DEBUFF"},
				--肾击
				{spellID =   408, unitId = "player", Filter = "DEBUFF"},
				--撕扯
				{spellID = 47481, unitId = "player", Filter = "DEBUFF"},
				--沉默
				{spellID = 55021, unitId = "player", Filter = "DEBUFF"},
				--割碎
				{spellID = 22570, unitId = "player", Filter = "DEBUFF"},
				--断筋
				{spellID =  1715, unitId = "player", Filter = "DEBUFF"},
				--减速药膏
				{spellID =  3775, unitId = "player", Filter = "DEBUFF"},
			},
		},
	},

	-- 德鲁伊
	["DRUID"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--节能施法
				{spellID = 16870, unitId = "player", Filter = "BUFF"},
				--自然之赐
				{spellID = 16886, unitId = "player", Filter = "BUFF"},
				--日蚀
				{spellID = 48517, unitId = "player", Filter = "BUFF"},			
				--月蚀
				{spellID = 48518, unitId = "player", Filter = "BUFF"},
				--狂暴(猫&熊)
				{spellID = 50334, unitId = "player", Filter = "BUFF"},
				--野蛮咆哮(猫)
				{spellID = 52610, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--粉碎
				{spellID = 80951, unitId = "player", Filter = "BUFF"},
				--月光淋漓
				{spellID = 81192, unitId = "player", Filter = "BUFF"},
				--坠星
				{spellID = 93400, unitId = "player", Filter = "BUFF"},
				--狂暴
				{spellID = 93622, unitId = "player", Filter = "BUFF"},
			},
		},
		
		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {	
				--挫志咆哮(熊)
				{spellID =    99, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--回春术
				{spellID =   774, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--割裂(猫)
				{spellID =  1079, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--斜掠(猫)
				{spellID =  1822, unitId = "target", Caster = "player", Filter = "DEBUFF"},			
				--虫群
				{spellID =  5570, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--月火术
				{spellID =  8921, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--割伤(熊)
				{spellID = 33745, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--生命绽放
				{spellID = 33763, unitId = "target", Caster = "player", Filter = "DEBUFF"},			
				--裂伤(猫)
				{spellID = 33876, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--野蛮咆哮(猫)
				{spellID = 52610, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--阳炎术
				{spellID = 93402, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},
	
	-- 猎人
	["HUNTER"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {	
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--急速射击
				{spellID =  3045, unitId = "player", Filter = "BUFF"},
				--野兽之心
				{spellID = 34471, unitId = "player", Filter = "BUFF"},
				--误导
				{spellID = 34477, unitId = "player", Filter = "BUFF"},			
				--误导
				{spellID = 35079, unitId = "player", Filter = "BUFF"},
				--强化稳固射击
				{spellID = 53220, unitId = "player", Filter = "BUFF"},
				--眼镜蛇打击
				{spellID = 53257, unitId = "player", Filter = "BUFF"},
				--野性呼唤
				{spellID = 53434, unitId = "player", Filter = "BUFF"},
				--荷枪实弹
				{spellID = 56453, unitId = "player", Filter = "BUFF"},
				--攻击弱点
				{spellID = 70728, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--准备,端枪,瞄准... ...
				{spellID = 82925, unitId = "player", Filter = "BUFF"},
				--开火!
				{spellID = 82926, unitId = "player", Filter = "BUFF"},
				--上!
				{spellID = 89388, unitId = "player", Filter = "BUFF"},
				--血性大发
				{spellID = 94007, unitId = "player", Filter = "BUFF"},
				--X光瞄准
				{spellID = 95712, unitId = "player", Filter = "BUFF"},
			},
		},
		
		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175 ,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--猎人印记
				{spellID =  1130 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--毒蛇钉刺
				{spellID =  1978 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--驱散射击
				{spellID = 19503 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--穿刺射击
				{spellID = 63468 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},
	
	-- 法师
	["MAGE"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--奥术强化
				{spellID = 12042, unitId = "player", Filter = "BUFF"},
				--唤醒
				{spellID = 12051, unitId = "player", Filter = "BUFF"},
				--奥术冲击
				{spellID = 36032, unitId = "player", Filter = "DEBUFF"},				
				--寒冰指
				{spellID = 44544, unitId = "player", Filter = "BUFF"},
				--法术连击
				{spellID = 48108, unitId = "player", Filter = "BUFF"},
				--冰冷智慧
				{spellID = 57761, unitId = "player", Filter = "BUFF"},
				--冲击(等级1)
				{spellID = 64343, unitId = "player", Filter = "BUFF"},
				--奥术飞弹!
				{spellID = 79683, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--灸灼
				{spellID = 87023, unitId = "player", Filter = "BUFF"},
			},
		},
		
		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175 ,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {		
				--点燃
				{spellID = 12654 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--临界炽焰
				{spellID = 22959 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--减速
				{spellID = 31589 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--活动炸弹
				{spellID = 44457 ,unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},
	
	-- 战士
	["WARRIOR"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--盾墙(防御姿态)
				{spellID =   871, unitId = "player", Filter = "BUFF"},
				--怒火中烧
				{spellID =  1134, unitId = "player", Filter = "BUFF"},
				--盾牌格挡(防御姿态)
				{spellID =  2565, unitId = "player", Filter = "BUFF"},			
				--横扫攻击(战斗,狂暴姿态)
				{spellID = 12328, unitId = "player", Filter = "BUFF"},
				--战斗专注
				{spellID = 12964, unitId = "player", Filter = "BUFF"},
				--破釜沉舟
				{spellID = 12975, unitId = "player", Filter = "BUFF"},
				--血之狂热
				{spellID = 16491, unitId = "player", Filter = "BUFF"},
				--反击风暴(战斗姿态)
				{spellID = 20230, unitId = "player", Filter = "BUFF"},
				--嗜血
				{spellID = 23885, unitId = "player", Filter = "BUFF"},
				--法术发射(战斗,防御姿态)
				{spellID = 23920, unitId = "player", Filter = "BUFF"},
				--复苏之风(等级1)
				{spellID = 29841, unitId = "player", Filter = "BUFF"},
				--胜利
				{spellID = 32216, unitId = "player", Filter = "BUFF"},
				--血脉喷张
				{spellID = 46916, unitId = "player", Filter = "BUFF"},
				--剑盾猛攻
				{spellID = 50227, unitId = "player", Filter = "BUFF"},
				--猝死
				{spellID = 55694, unitId = "player", Filter = "BUFF"},
				--激怒(等级2)
				{spellID = 57519, unitId = "player", Filter = "BUFF"},
				--血之气息
				{spellID = 60503, unitId = "player", Filter = "BUFF"},
				--主宰
				{spellID = 65156, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--胜利
				{spellID = 82368, unitId = "player", Filter = "BUFF"},
				--屠夫(等级3)
				{spellID = 84586, unitId = "player", Filter = "BUFF"},
				--坚守阵地
				{spellID = 84620, unitId = "player", Filter = "BUFF"},
				--致命平静
				{spellID = 85730, unitId = "player", Filter = "BUFF"},
				--激动
				{spellID = 86627, unitId = "player", Filter = "BUFF"},
				--雷霆余震
				{spellID = 87096, unitId = "player", Filter = "BUFF"},
				--行刑者
				{spellID = 90806, unitId = "player", Filter = "BUFF"},
			},
		},	

		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--撕裂(战斗,防御姿态)
				{spellID = 94009, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},
	
	-- 萨满
	["SHAMAN"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 25},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--闪电之盾
				{spellID =   324, unitId = "player", Filter = "BUFF"},
				--水之护盾
				{spellID = 52127, unitId = "player", Filter = "BUFF"},
				--潮汐奔涌
				{spellID = 53390, unitId = "player", Filter = "BUFF"},
				--5层漩涡武器
				{spellID = 53817, unitId = "player", Filter = "BUFF", Stack = 5},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
			},
		},
		
		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--灼热烈焰
				{spellID = 77661, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--烈焰震击
				{spellID =  8050, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},
	
	-- 圣骑士
	["PALADIN"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--圣佑术
				{spellID =   498, unitId = "player", Filter = "BUFF"},
				--圣盾术
				{spellID =   642, unitId = "player", Filter = "BUFF"},
				--神恩术
				{spellID = 31842, unitId = "player", Filter = "BUFF"},			
				--复仇之怒
				{spellID = 31884, unitId = "player", Filter = "BUFF"},
				--炙热防御者
				{spellID = 31850, unitId = "player", Filter = "BUFF"},
				--纯洁审判(等级3)
				{spellID = 53657, unitId = "player", Filter = "BUFF"},
				--圣光灌注(等级2)
				{spellID = 54149, unitId = "player", Filter = "BUFF"},
				--神圣恳求
				{spellID = 54428, unitId = "player", Filter = "BUFF"},
				--战争艺术
				{spellID = 59578, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--异端裁决
				{spellID = 84963, unitId = "player", Filter = "BUFF"},
				--黎明圣光
				{spellID = 85222, unitId = "player", Filter = "BUFF"},
				--狂热
				{spellID = 85696, unitId = "player", Filter = "BUFF"},
				--远古列王守卫
				{spellID = 86659, unitId = "player", Filter = "BUFF"},
				--破晓
				{spellID = 88819, unitId = "player", Filter = "BUFF"},
				--神圣意志
				{spellID = 90174, unitId = "player", Filter = "BUFF"},
			},
		},

		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--制裁之锤
				{spellID =   853, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--神圣愤怒
				{spellID =  2812, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--超度邪恶
				{spellID = 10326, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--忏悔
				{spellID = 20066, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},

	-- 牧师
	["PRIEST"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--消散
				{spellID = 47585, unitId = "player", Filter = "BUFF"},
				--争分夺秒
				{spellID = 59888, unitId = "player", Filter = "BUFF"},			
				--妙手回春
				{spellID = 63735, unitId = "player", Filter = "BUFF"},
				--心灵融化
				{spellID = 73510, unitId = "player", Filter = "BUFF"},				--暗影宝珠
				{spellID = 77487, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--脉轮:佑
				--{spellID = 81206, unitId = "player", Filter = "BUFF"},
				--脉轮:静
				--{spellID = 81208, unitId = "player", Filter = "BUFF"},
				--脉轮:罚
				--{spellID = 81209, unitId = "player", Filter = "BUFF"},
				--真言术:障
				{spellID = 81782, unitId = "player", Filter = "BUFF"},
				--黑暗福音
				{spellID = 87118, unitId = "player", Filter = "BUFF"},
				--天使长
				{spellID = 87152, unitId = "player", Filter = "BUFF"},
				--黑暗天使长
				{spellID = 87153, unitId = "player", Filter = "BUFF"},    
				--福音传播
				{spellID = 81661, unitId = "player", Filter = "BUFF"},
				--圣光涌动(等级1)
				{spellID = 88688, unitId = "player", Filter = "BUFF"},
				--强效暗影
				{spellID = 95799, unitId = "player", Filter = "BUFF"},
			},
		},

		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--暗言术:痛
				{spellID =   589, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--噬灵疫病
				{spellID =  2944, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--虚弱灵魂
				{spellID =  6788, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--吸血鬼之触
				{spellID = 34914, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
	},

	-- 术士
	["WARLOCK"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--夜幕(等级2)
				{spellID = 18095, unitId = "player", Filter = "BUFF"},
				--反冲(等级3)
				{spellID = 34939, unitId = "player", Filter = "BUFF"},
				--小鬼增效
				{spellID = 47283, unitId = "player", Filter = "BUFF"},			
				--灭杀(等级2)
				{spellID = 63158, unitId = "player", Filter = "BUFF"},
				--灭杀
				{spellID = 63167, unitId = "player", Filter = "BUFF"},
				--熔火之心
				{spellID = 71165, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--强化灵魂之火
				{spellID = 85383, unitId = "player", Filter = "BUFF"},
				--魔能火花
				{spellID = 89937, unitId = "player", Filter = "BUFF"},
			},
		},

		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--腐蚀术
				{spellID =   172, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--献祭
				{spellID =   348, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--末日灾祸
				{spellID =   603, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--暗影箭
				{spellID =   686, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--痛苦灾祸
				{spellID =   980, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--元素诅咒
				{spellID =  1490, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--烧尽
				{spellID = 29722, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--痛苦无常
				{spellID = 30108, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--鬼影缠身
				{spellID = 48181, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--混乱之箭
				{spellID = 50796, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--浩劫灾祸
				{spellID = 80240, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--古尔丹邪咒
				{spellID = 86000, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},	
	},
	
	-- 盗贼
	["ROGUE"] = {
		{
			Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--佯攻
				{spellID =  1966, unitId = "player", Filter = "BUFF"},
				--切割
				{spellID =  5171, unitId = "player", Filter = "BUFF"},
				--嫁祸诀窍
				{spellID = 57934, unitId = "player", Filter = "BUFF"},			
				--灭绝
				{spellID = 58427, unitId = "player", Filter = "BUFF"},
				--嫁祸诀窍
				{spellID = 59628, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--致命冲动
				{spellID = 84590, unitId = "player", Filter = "BUFF"},
			}
		},
		
		{
			Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 20,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--割裂
				{spellID =  1943, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--要害打击
				{spellID = 84617, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			}
		},
			
	},
	
	-- 死亡骑士
	["DEATHKNIGHT"] = {
		{
			--Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 6,
			Mode = "ICON",
			iconSize = 30,
			Pos = {"BOTTOM","oUF_SoraPlayer", "TOP", -95, 15},
			List = {	
				--嗜血
				{spellID =  2825, unitId = "player", Filter = "BUFF"},
				--英勇气概
				{spellID = 32182, unitId = "player", Filter = "BUFF"},
				--利刃屏障(等级3)
				{spellID = 64856, unitId = "player", Filter = "BUFF"},
				--反魔法护罩
				{spellID = 48707, unitId = "player", Filter = "BUFF"},
				--冰封之韧
				{spellID = 48792, unitId = "player", Filter = "BUFF"},			
				--巫妖之躯
				{spellID = 49039, unitId = "player", Filter = "BUFF"},
				--白骨之盾
				{spellID = 49222, unitId = "player", Filter = "BUFF"},
				--杀戮机器
				{spellID = 51124, unitId = "player", Filter = "BUFF"},
				--灰烬冰川
				{spellID = 53386, unitId = "player", Filter = "BUFF"},
				--吸血鬼之血
				{spellID = 55233, unitId = "player", Filter = "BUFF"},
				--冰冻之雾
				{spellID = 59052, unitId = "player", Filter = "BUFF"},
				--时间扭曲
				{spellID = 80353, unitId = "player", Filter = "BUFF"},
				--赤色天灾
				{spellID = 81141, unitId = "player", Filter = "BUFF"},
				--大墓地的意志
				{spellID = 81162, unitId = "player", Filter = "BUFF"},
				--符文刃舞
				{spellID = 81256, unitId = "player", Filter = "BUFF"},
			},
		},
		
		{
			--Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			iconSize = 16,
			barWidth = 175,
			Pos = {"BOTTOM", "oUF_SoraTarget", "TOP", 8, 5},
			List = {
				--血之疫病
				{spellID = 55078, unitId = "target", Caster = "player", Filter = "DEBUFF"},
				--冰霜疫病
				{spellID = 55095, unitId = "target", Caster = "player", Filter = "DEBUFF"},
			},
		},
		
		--[[{
			Name = "CD",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			iconSize = 48,
			Pos = {"CENTER", UIParent, "CENTER", 0, 100},
			List = {	
				--Example
				{spellID = 77577, Filter = "CD"},
				--Example
				{spellID = 48982, Filter = "CD"},
				--Example
				{spellID = 55233, Filter = "CD"},
				--Example
				{spellID = 49028, Filter = "CD"},
				--Example
				{spellID = 48792, Filter = "CD"},
				--Example
				{spellID = 48707, Filter = "CD"},
			},
		},]]
	
	},
}