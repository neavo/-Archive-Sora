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
	[47755] = 12, -- 全神贯注
	[96171] = 45, -- 大墓地的意志
	[81094] = 12, -- 新生
	[87023] = 60, -- 灸灼
	[96263] = 60, -- 圣洁护盾

	-- 饰品
	[89091] = 45, -- 火山毁灭
	[101289]= 50, -- 石化卤蛋
	[101291]= 50, -- 密银秒表
	[101287]= 50, -- 科林的冰冻铬银杯垫
	[97139] = 105, -- 矩阵回稳器H
	[97140] = 105, -- 矩阵回稳器H
	[97141] = 105, -- 矩阵回稳器H
	[96978] = 105, -- 矩阵回稳器
	[96977] = 105, -- 矩阵回稳器
	[96979] = 105, -- 矩阵回稳器
	[97129] = 60, -- 蛛丝纺锤H
	[96945] = 60, -- 蛛丝纺锤
	[97125] = 60, -- 饥不择食H
	[96911] = 60, -- 饥不择食
	[100322]= 45, -- 杜耶尔的重棍
	[91192] = 50, -- 激越曼陀罗坠石
	[91047] = 75, -- 时光的残枝
	[92233] = 30, -- 基岩护符
	[92320] = 90, -- 瑟纳利昂之镜H
	[92355] = 30, -- 共生之虫H
	[92349] = 75, -- 普瑞斯托的诡计护符H
	[92345] = 100, -- 狂怒之心H
	[92332] = 75, -- 生命之殒H
	[92351] = 50, -- 气旋精华H
	[92342] = 75, -- 压顶之力H
	[92318] = 100, -- 狂怒鸣响之铃H	
	[92108] = 50, -- 无闻之兆
	[91024] = 90, -- 瑟纳利昂之镜
	[92235] = 30, -- 共生之虫
	[92124] = 75, -- 普瑞斯托的诡计护符
	[91816] = 100, -- 狂怒之心
	[91184] = 75, -- 生命之殒
	[92126] = 50, -- 气旋精华
	[91821] = 75, -- 压顶之力
	[91007] = 100, -- 狂怒鸣响之铃
	[97136] = 45, --炽焰能量之眼H
	[96966] = 45, --炽焰能量之眼
	
	-- 附魔
	[74241] = 45, -- 能量洪流
	[74221] = 45, -- 飓风
	[74224] = 20, -- 心灵之歌
	[75173] = 50, -- 黑光
	[75170] = 65, -- 亮纹
	[75176] = 55, -- 剑刃刺绣
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
local function UpdateFrame(spellID, duration)
	local Frame = DB.Mode == "BAR" and BuildBAR(DB.BarWidth, DB.IconSize) or BuildICON(DB.IconSize)
	local name, _, icon = GetSpellInfo(spellID)
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
local Event = CreateFrame("Frame")
Event:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Event:SetScript("onEvent", function(self, event, ...)
	if bit.band(select(6, ...), COMBATLOG_OBJECT_AFFILIATION_MINE) == 0 then return end
	if GetAddOnMemoryUsage("Sora's AuraWatch") > 200 then collectgarbage() end
	local spellID = select(12, ...)
	if InternalCD[spellID] then
		local _, eventType, _, _, sourceName = ...	
		if eventType == "SPELL_AURA_APPLIED" then
			if sourceName == MyName then UpdateFrame(spellID, InternalCD[spellID]) end				
		elseif eventType == "SPELL_CAST_SUCCESS" then
			UpdateFrame(spellID, InternalCD[spellID])
		elseif eventType == "SPELL_ENERGIZE" then
			if sourceName == MyName and spellID == 47755 then UpdateFrame(spellID, InternalCD[spellID]) end
			if sourceName == MyName and spellID == 81094 then UpdateFrame(spellID, InternalCD[spellID]) end
		elseif eventType == "SPELL_HEAL" then
			if sourceName == MyName and (spellID == 87023 or spellID == 97136 or spellID == 96966) then UpdateFrame(spellID, InternalCD[spellID]) end
		end
	end
end)