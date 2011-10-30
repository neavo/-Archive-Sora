----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local MyName = UnitName("player")
local MyClass = select(2, UnitClass("player")) 
local BuildICON, BuildBAR = cfg.BuildICON, cfg.BuildBAR
local InCD = {}
local DB = {
	Direction = "UP", Interval = 4,
	Mode = "BAR", IconSize = 20, BarWidth = 175,
	Pos = {"BOTTOM", "oUF_SoraPlayer", "TOP", 12, 55},
}

local InternalCD = {
	-- 职业
	[81094] =  {nil, 12}, -- 新生(德鲁伊)
	[96171] =  {nil, 45}, -- 大墓地的意志(死亡骑士)
	[12536] =  {nil, 15}, -- 节能施法(法师)
	[87023] =  {nil, 60}, -- 灸灼(法师)
	[89023] =   {nil, 8}, -- 神佑之体(圣骑士)
	[96263] =  {nil, 60}, -- 圣洁护盾(圣骑士)
	[47755] =  {nil, 12}, -- 全神贯注(牧师)
	[45182] =  {nil, 90}, -- 装死(盗贼)
	[51699] =   {nil, 4}, -- 盗贼的尊严(盗贼)
	[31616] =  {nil, 30}, -- 自然的守护者(萨满)
	[34936] =   {nil, 8}, -- 反冲(术士)
	[89140] = {nil, 120}, -- 恶魔重生标记(术士)
	[60503] =   {nil, 6}, -- 血之气息(战士)
	[85386] = {nil, 120}, -- 剑在人在(战士)
	[86624] = {nil, 120}, -- 剑在人在(战士)

	-- 套装
	[99063] =  {nil, 45}, -- 法师T12x2
	[99221] =  {nil, 45}, -- 术士T12x2
	[99035] =  {nil, 45}, -- 平衡德鲁伊T12x2
	[99202] = {nil, 120}, -- 元素萨满T12x2
	
	-- CTM T12团队副本饰品
	[97139] = {69150, 105}, -- 矩阵回稳器(H)
	[97140] = {69150, 105}, -- 矩阵回稳器(H)
	[97141] = {69150, 105}, -- 矩阵回稳器(H)
	[96978] = {68994, 105}, -- 矩阵回稳器
	[96977] = {68994, 105}, -- 矩阵回稳器
	[96979] = {68994, 105}, -- 矩阵回稳器
	[97136] = {69149,  45}, -- 觉醒之眼(H)
	[96966] = {68983,  45}, -- 觉醒之眼
	[97129] = {69138,  60}, -- 蛛丝纺锤(H)
	[96945] = {68981,  60}, -- 蛛丝纺锤
	[97125] = {69112,  60}, -- 饥不择食(H)
	[96911] = {68927,  60}, -- 饥不择食

	-- CTM T11团队副本饰品
	[92108] = {59520,  50}, -- 无闻之兆
	[91024] = {59519,  90}, -- 瑟纳利昂之镜
	[92235] = {59332,  30}, -- 共生之虫
	[92124] = {59441,  75}, -- 普瑞斯托的诡计护符
	[91816] = {59224, 100}, -- 狂怒之心
	[91184] = {59500,  75}, -- 生命之殒
	[92126] = {59473,  50}, -- 气旋精华
	[91821] = {59506,  75}, -- 压顶之力
	[91007] = {59326, 100}, -- 狂怒鸣响之铃
	[92320] = {65105,  90}, -- 瑟纳利昂之镜
	[92355] = {65048,  30}, -- 共生之虫
	[92349] = {65026,  75}, -- 普瑞斯托的诡计护符
	[92345] = {65072, 100}, -- 狂怒之心
	[92332] = {65124,  75}, -- 生命之殒
	[92351] = {65140,  50}, -- 气旋精华
	[92342] = {65118,  75}, -- 压顶之力
	[92318] = {65053, 100}, -- 狂怒鸣响之铃
	
	-- 节日饰品
	[101289] = {71336, 50}, -- 石化卤蛋
	[101291] = {71337, 50}, -- 密银秒表
	[101287] = {71335, 50}, -- 科林的冰冻铬银杯垫
	
	-- 海加尔山复仇者
	[100322] = {70141, 45}, -- 杜耶尔的重棍
	
	-- 暗月卡片
	[89091] = {62047, 45}, -- 暗月卡片：火山

	-- 托巴拉德监狱饰品
	[91192] = {62472, 50}, -- 激越曼陀罗坠石
	[91047] = {62470, 75}, -- 时光的残枝

	-- 点数饰品
	[92233] = {58182, 30}, -- 基岩护符
	
	-- CTM 英雄五人副本饰品
	[90992] = {56407,  50}, -- 安努尔之书(H)
	[91149] = {56414, 100}, -- 伊希斯特的精华(H)
	[92087] = {56295,  50}, -- 先驱之握(H)
	[91364] = {56393, 100}, -- 抚慰之心(H)
	[92091] = {56328,  75}, -- 无尽密室之匙(H)
	[92184] = {56347,  30}, -- 沉重绝望(H)
	[92094] = {56427,  50}, -- 拉夏的左眼(H)
	[92174] = {56280,  80}, -- 瓷蟹(H)
	[91143] = {56377,  75}, -- 雨歌(H)
	[91368] = {56431,  50}, -- 拉夏的右眼(H)
	[91002] = {56400,  20}, -- 悲歌(H)
	[91139] = {56351,  75}, -- 血红之泪(H)
	[90898] = {56339,  75}, -- 黑暗潜藏卷须(H)
	[92205] = {56449,  60}, -- 索朗格斯的指节(H)
	[90887] = {56320,  75}, -- 巫术沙漏(H)
	
	-- CTM 五人副本/世界掉落饰品
	[90989] = {55889,  50}, -- 安努尔之书
	[91147] = {55995, 100}, -- 伊希斯特的精华
	[91363] = {55868, 100}, -- 抚慰之心
	[92096] = {56102,  50}, -- 拉夏的左眼
	[91370] = {56100,  50}, -- 拉夏的右眼
	[90996] = {55879,  20}, -- 悲歌
	[92208] = {56121,  60}, -- 索朗格斯的指节
	[92052] = {66969,  50}, -- 邪恶之心
	[92069] = {55795,  75}, -- 无尽密室之匙
	[92179] = {55816,  30}, -- 沉重绝望
	[91141] = {55854,  75}, -- 雨歌
	[91138] = {55819,  75}, -- 血红之泪
	[90896] = {55810,  75}, -- 黑暗潜藏卷须
	[92052] = {55266,  50}, -- 先驱之握
	[90885] = {55787,  75}, -- 巫术沙漏
	
	-- S9 PVP
	[85027] = {61045, 50}, -- 残忍角斗士的统御徽章
	[85032] = {61046, 50}, -- 残忍角斗士的胜利徽章
	[85022] = {61047, 50}, -- 残忍角斗士的征服徽章
	[92218] = {64762, 50}, -- 嗜血角斗士的统御徽章
	[92216] = {64763, 50}, -- 嗜血角斗士的胜利徽章
	[92220] = {64761, 50}, -- 嗜血角斗士的征服徽章
	
	-- S10 PVP
	[99721] = {70579, 50}, -- 残忍角斗士的胜利徽记
	[99719] = {70578, 50}, -- 残忍角斗士的统御徽记
	[99717] = {70577, 50}, -- 残忍角斗士的征服徽记
	[99742] = {70402, 50}, -- 冷酷角斗士的统御徽记
	[99748] = {70404, 50}, -- 冷酷角斗士的征服徽记
	[99746] = {70403, 50}, -- 冷酷角斗士的胜利徽记
	
	-- 附魔
	[74241] = {nil, 45}, -- 能量洪流
	[74221] = {nil, 45}, -- 飓风
	[74224] = {nil, 20}, -- 心灵之歌
	[75173] = {nil, 50}, -- 黑光(等级2)
	[75170] = {nil, 65}, -- 亮纹(等级2)
	[75176] = {nil, 55}, -- 剑刃刺绣(等级2)
	[55637] = {nil, 45}, -- 闪电之纹(等级1)
	[55775] = {nil, 45}, -- 剑刃刺绣(Rank 1)
	[55767] = {nil, 45}, -- 黑光(等级1)
	[59626] = {nil, 35}, -- 黑魔法
}

-- UpdatePos
local function UpdatePos()
	for i = 1, #InCD do
		InCD[i]:ClearAllPoints()
		if i == 1 then
			InCD[i]:SetPoint(unpack(DB.Pos))
		elseif DB.Direction:lower() == "right" then
			InCD[i]:SetPoint("LEFT", InCD[i-1], "RIGHT", DB.Interval, 0)
		elseif DB.Direction:lower() == "left" then
			InCD[i]:SetPoint("RIGHT", InCD[i-1], "LEFT", -DB.Interval, 0)
		elseif DB.Direction:lower() == "up" then
			InCD[i]:SetPoint("BOTTOM", InCD[i-1], "TOP", 0, DB.Interval)
		elseif DB.Direction:lower() == "down" then
			InCD[i]:SetPoint("TOP", InCD[i-1], "BOTTOM", 0, -DB.Interval)
		end
		InCD[i].ID = i
	end
end

-- UpdateFrame
local function UpdateFrame(spellID, itemID, duration)
	local Frame = DB.Mode == "BAR" and BuildBAR(DB.BarWidth, DB.IconSize) or BuildICON(DB.IconSize)
	local name, icon = nil, nil
	if itemID then
		name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemID)
	else
		name, _, icon = GetSpellInfo(spellID)
	end
	if Frame then
		Frame:Show()
		tinsert(InCD, Frame)
		UpdatePos()
	end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(GetTime(), duration)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration) 
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = self.Timer + elapsed
			local Timer = duration-self.Timer 
			if Timer > 60 then
				if self.Time then self.Time:SetFormattedText("%d:%.2d", Timer/60, Timer%60) end
				self.Statusbar:SetValue(Timer)
			elseif Timer < 60 and Timer > 0 then
				if self.Time then self.Time:SetFormattedText("%.1f", Timer) end
				self.Statusbar:SetValue(Timer)
			else
				self:SetScript("OnUpdate", nil)
				self:Hide()
				tremove(InCD, self.ID)
				UpdatePos()
			end
		end)
	end
end

-- Event
local EventList = {
	["SPELL_DAMAGE"] = true,
	["SPELL_PERIODIC_HEAL"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_AURA_APPLIED"] = true,
	["SPELL_ENERGIZE"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_SUMMON"] = true,
}
local Event = CreateFrame("Frame")
Event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Event:SetScript("onEvent", function(self, event, ...)
	if bit.band(select(6, ...), COMBATLOG_OBJECT_AFFILIATION_MINE) == 0 then return end
	if GetAddOnMemoryUsage("Sora's AuraWatch") > 128 then collectgarbage() end
	local _, eventType, _, _, sourceName, _, _, _, _, _, _, spellID = ...
	if InternalCD[spellID] and EventList[eventType] and sourceName == MyName then
		local itemID, duration = unpack(InternalCD[spellID])
		UpdateFrame(spellID, itemID, duration)
	end
end)