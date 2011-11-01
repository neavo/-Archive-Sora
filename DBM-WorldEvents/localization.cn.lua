if GetLocale() ~= "zhCN" then return end

local L

----------------------
--  Coren Direbrew  --
----------------------
L = DBM:GetModLocalization("CorenDirebrew")

L:SetGeneralLocalization({
	name 			= "科林·烈酒"
})

L:SetWarningLocalization({
	specWarnBrew		= "在他再丢你一个前喝掉酒！",
	specWarnBrewStun	= "提示：你疯狂了，记得下一次喝啤酒！"
})

L:SetOptionLocalization({
	specWarnBrew		= "为$spell:47376显示特别警报",
	specWarnBrewStun	= "为$spell:47340显示特别警报",
	YellOnBarrel		= "当你中了$spell:51413时大喊"
})

L:SetMiscLocalization({
	YellBarrel		= "我中了空桶(晕)"
})

-------------------------
--  Headless Horseman  --
-------------------------
L = DBM:GetModLocalization("HeadlessHorseman")

L:SetGeneralLocalization({
	name 			= "无头骑士"
})

L:SetWarningLocalization({
	WarnPhase				= "阶段 %d",
	warnHorsemanSoldiers	= "跳动的南瓜出现了！",
	warnHorsemanHead		= "躲避旋风斩 - 快打脑袋!"
})

L:SetTimerLocalization{
	TimerCombatStart		= "战斗开始"
}

L:SetOptionLocalization({
	WarnPhase				= "为每次阶段转换显示警报",
	TimerCombatStart		= "为战斗开始显示计时条",
	warnHorsemanSoldiers	= "为跳动的南瓜出现显示警报",
	warnHorsemanHead		= "为骑士脑袋出现显示警报"
})

L:SetMiscLocalization({
	HorsemanSummon			= "无头骑士来了……",
	HorsemanHead		= "白痴，到这边来！",
	HorsemanSoldiers	= "士兵们，起来战斗吧！为死去的骑士带来胜利的荣耀！",
	SayCombatEnd		= "我曾经经历过这样的结局。这次会有新意吗？"
})

-----------------------
--  Apothecary Trio  --
-----------------------
L = DBM:GetModLocalization("ApothecaryTrio")

L:SetGeneralLocalization({
	name 			= "药剂师三人组"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	HummelActive		= "药剂师汉摩尔 开始活动",
	BaxterActive		= "药剂师拜克斯特 开始活动",
	FryeActive		= "药剂师弗莱 开始活动"
})

L:SetOptionLocalization({
	TrioActiveTimer		= "为药剂师三人组开始活动显示计时条"
})

L:SetMiscLocalization({
	SayCombatStart		= "他们顾得上告诉你我是谁或者我在做些什么吗？"
})

-------------
--  Ahune  --
-------------
L = DBM:GetModLocalization("Ahune")

L:SetGeneralLocalization({
	name 			= "埃霍恩"
})

L:SetWarningLocalization({
	Submerged		= "埃霍恩已隐没",
	Emerged			= "埃霍恩已现身",
	specWarnAttack		= "埃霍恩拥有易伤 - 现在攻击!"
})

L:SetTimerLocalization({
	SubmergTimer		= "隐没",
	EmergeTimer		= "现身",
	TimerCombat		= "战斗开始"
})

L:SetOptionLocalization({
	Submerged		= "当埃霍恩隐没时显示警报",
	Emerged			= "当埃霍恩现身时显示警报",
	specWarnAttack		= "当埃霍恩拥有易伤时显示特别警报",
	SubmergTimer		= "为隐没显示计时条",
	EmergeTimer		= "为现身显示计时条",
	TimerCombat		= "为战斗开始显示计时条"
})

L:SetMiscLocalization({
	Pull			= "寒冰之石融化了！"
})
