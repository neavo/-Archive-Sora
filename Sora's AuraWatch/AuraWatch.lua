----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local AuraList, Aura, MaxFrame = {}, {}, 15
local MyClass = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR
local Event = CreateFrame("Frame")

-- Init
local function Init()
	AuraList = SRAuraList["ALL"] and SRAuraList["ALL"] or {}
	for key, _ in pairs(SRAuraList) do
		if key == MyClass then
			for _, value in pairs(SRAuraList[MyClass]) do
				tinsert(AuraList, value)
			end
		end
	end
	wipe(SRAuraList)
	for _, value in pairs(AuraList) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			if value.Mode:lower() == "icon" then
				tinsert(FrameTable, BuildICON(value.IconSize, value.ClickCast))
			elseif value.Mode:lower() == "bar" then
				tinsert(FrameTable, BuildBAR(value.BarWidth, value.IconSize, value.ClickCast))
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
	cfg.AuraList = AuraList
	cfg.Aura = Aura
end

-- Pos
local function Pos()
	for key, VALUE in pairs(Aura) do
		local value = AuraList[key]
		local Pre = nil
		for i = 1, #VALUE do
			local frame = VALUE[i]
			if i == 1 then
				frame:SetPoint(unpack(value.Pos))
			elseif value.Direction:lower() == "right" then
				frame:SetPoint("LEFT", Pre, "RIGHT", value.Interval, 0)
			elseif value.Direction:lower() == "left" then
				frame:SetPoint("RIGHT", Pre, "LEFT", -value.Interval, 0)
			elseif value.Direction:lower() == "up" then
				frame:SetPoint("BOTTOM", Pre, "TOP", 0, value.Interval)
			elseif value.Direction:lower() == "down" then
				frame:SetPoint("TOP", Pre, "BOTTOM", 0, -value.Interval)
			end
			Pre = frame
		end
	end
end

-- OnUpdate
local Timer = 0
local function OnUpdate(self, elapsed)
	Timer = self.IsCD and self.expires+self.duration-GetTime() or self.expires-GetTime()
	if Timer < -1 then
		if self.Time then self.Time:SetText("N/A") end
		self.Statusbar:SetMinMaxValues(0, 1) 
		self.Statusbar:SetValue(1)
	elseif Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", Timer) end
		self.Statusbar:SetMinMaxValues(0, self.duration) 
		self.Statusbar:SetValue(Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", Timer/60, Timer%60) end
		self.Statusbar:SetMinMaxValues(0, self.duration) 
		self.Statusbar:SetValue(Timer)
	end
end

local function UpdateUnitDB(UnitID, Bool)
	local Func = Bool and UnitBuff or UnitDebuff
	local Type = Bool and "Buff" or "Debuff"
	local index = 1
    while true do
		local name, _, icon, count, _, duration, expires, caster, _, _, spellID = Func(UnitID, index)
		if not name then break end
		AuraDB[UnitID][Type][index] = {name, icon, count, duration, expires, caster, spellID}
		index = index + 1
	end
end

-- UpdateAura
local function UpdateAura(Frame, value, Name, VALUE)
	local name, _, icon, count, _, duration, expires, caster = nil, nil, nil, nil, nil, nil, nil, nil
	if UnitBuff(value.UnitID, Name) then 
		name, _, icon, count, _, duration, expires, caster = UnitBuff(value.UnitID, Name)
	else
		name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.UnitID, Name)
	end
	if value.Caster and value.Caster:lower() ~= caster then return end
	if value.Stack and count and value.Stack > count then return end
	
	Frame:Show()
	Frame.Icon:SetTexture(icon)
	Frame.Count:SetText(count > 1 and count or nil)
	
	if Frame.Cooldown then Frame.Cooldown:SetCooldown(expires-duration, duration) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.duration = duration
		Frame.expires = expires
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	
	if Frame.ClickCast then Frame.ClickCast:SetAttribute("macrotext", "/cast [target="..value.UnitID.."] "..name) end

	VALUE.Index = VALUE.Index + 1
end

-- UpdateCD
local function UpdateCD(Frame, value, VALUE)
	local start, duration = GetSpellCooldown(value.SpellID)
	local name, _, icon = GetSpellInfo(value.SpellID)

	Frame:Show()	
	Frame.Icon:SetTexture(icon)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(start, duration)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.IsCD = true
		Frame.duration = duration
		Frame.expires = start
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	VALUE.Index = VALUE.Index + 1
end

-- UpdateItemCD
local function UpdateItemCD(Frame, value, Name, VALUE)
	local start, duration = GetItemCooldown(value.ItemID)
	local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)

	Frame:Show()
	Frame.Icon:SetTexture(icon)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(start, duration)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.duration = duration
		Frame.expires = start
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	VALUE.Index = VALUE.Index + 1
end

-- Update
local function Update()
	-- 重置旧的Aura
	for KEY, VALUE in pairs(Aura) do
		for i = 1, MaxFrame do
			VALUE[i]:Hide()
			VALUE[i]:SetScript("OnUpdate", nil)		
		end
	end
	-- 更新新的Aura
	for KEY, VALUE in pairs(Aura) do
		VALUE.Index = 1
		for key, value in pairs(AuraList[KEY].List) do
			local Frame = VALUE[VALUE.Index]
			if value.AuraID then
				local Name = GetSpellInfo(value.AuraID)
				if UnitBuff(value.UnitID, Name) then UpdateAura(Frame, value, Name, VALUE) end
				if UnitDebuff(value.UnitID, Name) then UpdateAura(Frame, value, Name, VALUE) end
			end
			if value.ItemID then
				local Name = GetItemInfo(value.ItemID)
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then UpdateItemCD(Frame, value, Name, VALUE) end
			end
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then UpdateCD(Frame, value, VALUE) end
			end
		end
	end
end

-- Event
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	elseif event == "PLAYER_ENTERING_WORLD" then
		Pos()
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate", function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.5 then
		self.Timer = 0
		Update()
	end	
end)


-- Test
local TestFlag = true
SlashCmdList.SRAuraWatch = function()
	if TestFlag then
		TestFlag = false
		Event:SetScript("OnUpdate", nil)
		for _, VALUE in pairs(Aura) do
			for i = 1, MaxFrame do
				VALUE[i]:Hide()
				VALUE[i]:SetScript("OnUpdate", nil)		
				if VALUE[i].Icon then VALUE[i].Icon:SetTexture(select(3, GetSpellInfo(118))) end
				if VALUE[i].Count then VALUE[i].Count:SetText("9") end
				if VALUE[i].Time then VALUE[i].Time:SetText("59.59") end
				if VALUE[i].Statusbar then VALUE[i].Statusbar:SetValue(1) end
				if VALUE[i].Spellname then VALUE[i].Spellname:SetText("变形术") end
				VALUE[i]:Show()		
			end
		end
	else
		TestFlag = true
		Event:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = self.Timer + elapsed
			if self.Timer > 0.5 then
				self.Timer = 0
				Update()
			end	
		end)
		for _, VALUE in pairs(Aura) do
			for i = 1, MaxFrame do
				if VALUE[i].Count then VALUE[i].Count:SetText(nil) end
				VALUE[i]:Hide()
				VALUE[i]:SetScript("OnUpdate", nil)		
			end
		end
	end
end
SLASH_SRAuraWatch1 = "/SRAuraWatch"
SLASH_SRAuraWatch2 = "/sRaw"

