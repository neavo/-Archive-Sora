--[[
	
	Filger
	Copyright (c) 2009, Nils Ruesch
	All rights reserved.
	
]]

--[[
	
	FilgerMod
	A Mod Based on Filger ：)
	By Neavo
	neavo7@Gmail.com
]]

--[[

	关于FilgerMod的新属性

	spellID，size，unitId，barWidth，caster，filter 等属性均与Filger原版一样，就不说多了,不理解的请自行查阅资料

	要说的是新属性stack，即BUFF层数的显示阀值

	当BUFF的层数"大于等于"stack的值得时候，BUFF才会显示

	如果不需要控制BUFF层数阀值，请将stack设为0，或者干脆不要写stack这一项，就像下面的Test_Icon一样
	
	-- Test_Icon
	{ spellID = 67696, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
	-- Test_Bar
	{ spellID = 67696, size = 30, barWidth = 170 ,unitId = "player", caster = "player", filter = "BUFF", stack = 3},
]]


----------------
--  命名空间  --
----------------

local _, SR = ...
cfg = SR.FilgerModConfig



Filger_Settings = {
	configmode = false
}

Filger_Spells = {

	["DRUID"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--节能施法
			{ spellID = 16870, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--自然之赐
			{ spellID = 16886, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--日蚀
			{ spellID = 48517, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--月蚀
			{ spellID = 48518, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--狂暴(猫&熊)
			{ spellID = 50334, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--野蛮咆哮(猫)
			{ spellID = 52610, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--粉碎
			{ spellID = 80951, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--月光淋漓
			{ spellID = 81192, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--坠星
			{ spellID = 93400, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--狂暴
			{ spellID = 93622, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--挫志咆哮(熊)
			{ spellID =    99, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--回春术
			{ spellID =   774, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--割裂(猫)
			{ spellID =  1079, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--斜掠(猫)
			{ spellID =  1822, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},			
			--虫群
			{ spellID =  5570, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--月火术
			{ spellID =  8921, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--割伤(熊)
			{ spellID = 33745, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--生命绽放
			{ spellID = 33763, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},			
			--裂伤(猫)
			{ spellID = 33876, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--野蛮咆哮(猫)
			{ spellID = 52610, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--阳炎术
			{ spellID = 93402, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},
	
	["HUNTER"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--急速射击
			{ spellID =  3045, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--野兽之心
			{ spellID = 34471, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--误导
			{ spellID = 34477, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--误导
			{ spellID = 35079, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--强化稳固射击
			{ spellID = 53220, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--眼镜蛇打击
			{ spellID = 53257, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--野性呼唤
			{ spellID = 53434, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--荷枪实弹
			{ spellID = 56453, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--攻击弱点
			{ spellID = 70728, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--准备,端枪,瞄准... ...
			{ spellID = 82925, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--开火!
			{ spellID = 82926, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--上!
			{ spellID = 89388, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--血性大发
			{ spellID = 94007, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--X光瞄准
			{ spellID = 95712, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--猎人印记
			{ spellID =  1130, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--毒蛇钉刺
			{ spellID =  1978, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--驱散射击
			{ spellID = 19503, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--穿刺射击
			{ spellID = 63468, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},
	
	["MAGE"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--奥术强化
			{ spellID = 12042, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--唤醒
			{ spellID = 12051, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--奥术冲击
			{ spellID = 36032, size = 54, unitId = "player", caster = "player", filter = "DEBUFF"},				
			--寒冰指
			{ spellID = 44544, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--法术连击
			{ spellID = 48108, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--冰冷智慧
			{ spellID = 57761, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--冲击(等级1)
			{ spellID = 64343, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--奥术飞弹!
			{ spellID = 79683, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--灸灼
			{ spellID = 87023, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--点燃
			{ spellID = 12654, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--临界炽焰
			{ spellID = 22959, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--减速
			{ spellID = 31589, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--活动炸弹
			{ spellID = 44457, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},
	
	["WARRIOR"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--盾墙(防御姿态)
			{ spellID =   871, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--怒火中烧
			{ spellID =  1134, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--盾牌格挡(防御姿态)
			{ spellID =  2565, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--横扫攻击(战斗,狂暴姿态)
			{ spellID = 12328, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--战斗专注
			{ spellID = 12964, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--破釜沉舟
			{ spellID = 12975, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--血之狂热
			{ spellID = 16491, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--反击风暴(战斗姿态)
			{ spellID = 20230, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--嗜血
			{ spellID = 23885, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--法术发射(战斗,防御姿态)
			{ spellID = 23920, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--复苏之风(等级1)
			{ spellID = 29841, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--胜利
			{ spellID = 32216, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--血脉喷张
			{ spellID = 46916, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--剑盾猛攻
			{ spellID = 50227, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--猝死
			{ spellID = 55694, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--激怒(等级2)
			{ spellID = 57519, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--血之气息
			{ spellID = 60503, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--主宰
			{ spellID = 65156, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--胜利
			{ spellID = 82368, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--屠夫(等级3)
			{ spellID = 84586, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--坚守阵地
			{ spellID = 84620, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--致命平静
			{ spellID = 85730, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--激动
			{ spellID = 86627, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--雷霆余震
			{ spellID = 87096, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--行刑者
			{ spellID = 90806, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},	

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},

		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--撕裂(战斗,防御姿态)
			{ spellID = 94009, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},
	
	["SHAMAN"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},
			
			--闪电之盾
			{ spellID =   324, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--水之护盾
			{ spellID = 52127, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--潮汐奔涌
			{ spellID = 53390, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--5层漩涡武器
			{ spellID = 53817, size = 54, unitId = "player", caster = "player", filter = "BUFF", stack=5},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--灼热烈焰
			{ spellID = 77661, size = 54, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--烈焰震击
			{ spellID =  8050, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},
	
	["PALADIN"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--圣佑术
			{ spellID =   498, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--圣盾术
			{ spellID =   642, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--神恩术
			{ spellID = 31842, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--复仇之怒
			{ spellID = 31884, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--炙热防御者
			{ spellID = 31850, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--纯洁审判(等级3)
			{ spellID = 53657, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--圣光灌注(等级2)
			{ spellID = 54149, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--神圣恳求
			{ spellID = 54428, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--战争艺术
			{ spellID = 59578, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--异端裁决
			{ spellID = 84963, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--黎明圣光
			{ spellID = 85222, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--狂热
			{ spellID = 85696, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--破晓
			{ spellID = 85819, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--远古列王守卫
			{ spellID = 86659, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--神圣意志
			{ spellID = 90174, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--制裁之锤
			{ spellID = 853, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--神圣愤怒
			{ spellID = 2812, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--超度邪恶
			{ spellID = 10326, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--忏悔
			{ spellID = 20066, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},

	["PRIEST"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--消散
			{ spellID = 47585, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--争分夺秒
			{ spellID = 59888, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--妙手回春
			{ spellID = 63735, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--心灵融化
			{ spellID = 73510, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			--暗影宝珠
			{ spellID = 77487, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--脉轮:佑
			--{ spellID = 81206, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--脉轮:静
			--{ spellID = 81208, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--脉轮:罚
			--{ spellID = 81209, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--真言术:障
			{ spellID = 81782, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--黑暗福音
			{ spellID = 87118, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--天使长
			{ spellID = 87152, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--黑暗天使长
			{ spellID = 87153, size = 54, unitId = "player", caster = "player", filter = "BUFF"},    
			--福音传播
			{ spellID = 81661, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--圣光涌动(等级1)
			{ spellID = 88688, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--强效暗影
			{ spellID = 95799, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--暗言术:痛
			{ spellID =   589, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--噬灵疫病
			{ spellID =  2944, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--虚弱灵魂
			{ spellID =  6788, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--吸血鬼之触
			{ spellID =  34914, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
	},

	["WARLOCK"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--夜幕(等级2)
			{ spellID = 18095, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--反冲(等级3)
			{ spellID = 34939, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--小鬼增效
			{ spellID = 47283, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--灭杀(等级2)
			{ spellID = 63158, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--灭杀
			{ spellID = 63167, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--熔火之心
			{ spellID = 71165, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--强化灵魂之火
			{ spellID = 85383, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--魔能火花
			{ spellID = 89937, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},

		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},

		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--腐蚀术
			{ spellID =   172, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--献祭
			{ spellID =   348, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--末日灾祸
			{ spellID =   603, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--暗影箭
			{ spellID =   686, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--痛苦灾祸
			{ spellID =   980, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--元素诅咒
			{ spellID =  1490, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--烧尽
			{ spellID = 29722, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--痛苦无常
			{ spellID = 30108, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--鬼影缠身
			{ spellID = 48181, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--混乱之箭
			{ spellID = 50796, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--浩劫灾祸
			{ spellID = 80240, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--古尔丹邪咒
			{ spellID = 86000, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},	
	},
	
	["ROGUE"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--佯攻
			{ spellID =  1966, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--切割
			{ spellID =  5171, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--嫁祸诀窍
			{ spellID = 57934, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--灭绝
			{ spellID = 58427, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--嫁祸诀窍
			{ spellID = 59628, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--致命冲动
			{ spellID = 84590, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
		},
		
		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},

		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM", "oUF_NevoTarget", "TOP", -90, 5 },
			
			--割裂
			{ spellID =  1943, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--要害打击
			{ spellID = 84617, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
			
	},
	
	["DEATHKNIGHT"] = {
		{
		Name = "PlayerBuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "BOTTOM", nil, "BOTTOM", -100, 190},

			--利刃屏障(等级3)
			{ spellID = 64856, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--反魔法护罩
			{ spellID = 48707, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--冰封之韧
			{ spellID = 48792, size = 54, unitId = "player", caster = "player", filter = "BUFF"},			
			--巫妖之躯
			{ spellID = 49039, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--白骨之盾
			{ spellID = 49222, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--杀戮机器
			{ spellID = 51124, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--灰烬冰川
			{ spellID = 53386, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--吸血鬼之血
			{ spellID = 55233, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--冰冻之雾
			{ spellID = 59052, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--赤色天灾
			{ spellID = 81141, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--大墓地的意志
			{ spellID = 81162, size = 54, unitId = "player", caster = "player", filter = "BUFF"},
			--符文刃舞
			{ spellID = 81256, size = 54, unitId = "player", caster = "player", filter = "BUFF"},

		},
		
		{
		Name = "PlayerDebuff",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER",nil, "CENTER", -200, 200},
			
			--变羊
			{ spellID =   118, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--制裁之锤
			{ spellID =   853, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--肾击
            { spellID =   408, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--撕扯
            { spellID = 47481, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--沉默
            { spellID = 55021, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--割碎
            { spellID = 22570, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--断筋
           { spellID =   1715, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
			--减速药膏
           { spellID =   3775, size = 54, unitId = "player", caster = "all", filter = "DEBUFF" },
		},
		
		{
		Name = "TargetDebuff",
			Direction = "UP",
			Interval = 4,
			Mode = "BAR",
			setPoint = { "BOTTOM","oUF_NevoTarget", "TOP", -90, 5 },
			
			--血之疫病
			{ spellID = 55078, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
			--冰霜疫病
			{ spellID = 55095, size = 20, barWidth = 175 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
		
		--[[{
		Name = "CD",
			Direction = "RIGHT",
			Interval = 4,
			Mode = "ICON",
			setPoint = { "CENTER", nil, "CENTER", -400, 100 },
			
			--Example
			{ spellID = 48792, size = 54, unitId = "player", caster = "player", filter = "CD"},
		},	]]
	
	},
}