----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local AuraList, Aura, Arg = {}, {}, {}
local class = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR

local Event = CreateFrame("Frame")

-- Init
local function Init()
	AuraList = SRAuraList["ALL"] and SRAuraList["ALL"] or {}
	for key, _ in pairs(SRAuraList) do
		if key == class then
			for _, value in pairs(SRAuraList[class]) do
				table.insert(AuraList, value)
			end
		end
	end
	wipe(SRAuraList)
	for _, value in pairs(AuraList) do
		local tempTable = {}
		for i = 1, #(value.List) do
			local temp
			if value.Mode:lower() == "icon" then
				temp = BuildICON(value.iconSize)
			elseif value.Mode:lower() == "bar" then
				temp = BuildBAR(value.iconSize, value.barWidth)
			end
			temp:Hide()
			table.insert(tempTable, temp)
		end
		table.insert(Arg, 0)
		table.insert(Aura, tempTable)
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
	Timer = self.Filter == "CD" and self.expires+self.duration-GetTime() or self.expires-GetTime()
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

-- UpdateBuff
local function UpdateBuff(Frame, value, idName, key)
	local name, _, icon, count, _, duration, expires, caster = UnitBuff(value.unitId, idName)
	if value.Caster and value.Caster:lower() ~= caster:lower() then return end
	if value.Stack and count and value.Stack > count then return end
	
	Frame:Show()
	Frame.Icon:SetTexture(icon)
	Frame.Count:SetText(count > 1 and count or "")
	
	if Frame.Cooldown then CooldownFrame_SetTimer(Frame.Cooldown, expires-duration, duration, 1) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Filter = value.Filter
		Frame.duration = duration
		Frame.expires = expires
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	Arg[key] = Arg[key] + 1
end

-- UpdateDebuff
local function UpdateDebuff(Frame, value, idName, key)
	local name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.unitId, idName)
	if value.Caster and value.Caster:lower() ~= caster:lower() then return end
	if value.Stack and count and value.Stack > count then return end
	
	Frame:Show()
	Frame.Icon:SetTexture(icon)
	Frame.Count:SetText(count > 1 and count or "")
	
	if Frame.Cooldown then CooldownFrame_SetTimer(Frame.Cooldown, expires-duration, duration, 1) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Filter = value.Filter
		Frame.duration = duration
		Frame.expires = expires
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	Arg[key] = Arg[key] + 1
end

-- UpdateCD
local function UpdateCD(Frame, value, idName, key)
	local start, duration = GetSpellCooldown(idName)
	local _, _, icon = GetSpellInfo(value.spellID)

	Frame:Show()	
	Frame.Icon:SetTexture(icon)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start , duration, 1)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Filter = value.Filter
		Frame.duration = duration
		Frame.expires = start
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	Arg[key] = Arg[key] + 1
end

-- UpdateItemCD
local function UpdateItemCD(Frame, value, idName, key)
	local start, duration = GetItemCooldown(value.itemID)
	local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.itemID)

	Frame:Show()
	Frame.Icon:SetTexture(icon)
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start , duration, 1)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Filter = value.Filter
		Frame.duration = duration
		Frame.expires = start
		Frame:SetScript("OnUpdate", OnUpdate)
	end
	Arg[key] = Arg[key] + 1
end

-- Update
local function Update()
	-- 重置旧的Aura
	for KEY, VALUE in pairs(Aura) do
		for i = 1, Arg[KEY] do
			VALUE[i]:Hide()
			VALUE[i]:SetScript("OnUpdate", nil)		
		end
	end
	-- 更新新的Aura
	for KEY, VALUE in pairs(Aura) do
		Arg[KEY] = 1
		for key, value in pairs(AuraList[KEY].List) do
			local Frame = VALUE[Arg[KEY]]
			if value.spellID then
				local idName = GetSpellInfo(value.spellID)
				if value.Filter:lower() == "buff" and UnitBuff(value.unitId, idName) then
					UpdateBuff(Frame, value, idName, KEY)
				elseif value.Filter:lower() == "debuff" and UnitDebuff(value.unitId, idName) then
					UpdateDebuff(Frame, value, idName, KEY)
				elseif value.Filter:lower() == "cd" and GetSpellCooldown(idName) and select(2, GetSpellCooldown(idName)) > 1.5 then
					UpdateCD(Frame, value, idName, KEY)
				end
			elseif value.itemID then
				idName = GetItemInfo(value.itemID)
				if select(2, GetItemCooldown(value.itemID)) > 1.5 then
					UpdateItemCD(Frame, value, idName, KEY)
				end
			end
		end
		Arg[KEY] = Arg[KEY] - 1
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
local testFlag = true
SlashCmdList.SRAuraWatch = function()
	if testFlag then
		testFlag = false
		Event:SetScript("OnUpdate", nil)
		for _, VALUE in pairs(Aura) do
			for _, value in pairs(VALUE) do
				value:Hide()
				value:SetScript("OnUpdate", nil)		
				
				local name, _, icon = GetSpellInfo(118)
				
				if value.Icon then
					value.Icon:SetTexture(icon)
				end
				if value.Count then
					value.Count:SetText("9")
				end
				if value.Time then
					value.Time:SetText("59.59")
				end
				if value.Statusbar then
					value.Statusbar:SetValue(1)
				end
				if value.Spellname then
					value.Spellname:SetText(name)
				end
				if value.Cooldown then
					CooldownFrame_SetTimer(value.Cooldown, nil, nil, nil) 
				end
				
				value:Show()		
			end
		end
	else
		testFlag = true
		Event:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = self.Timer + elapsed
			if self.Timer > 0.5 then
				self.Timer = 0
				Update()
			end	
		end)
		for _, VALUE in pairs(Aura) do
			for _, value in pairs(VALUE) do
				if value.Count then
					value.Count:SetText(nil)
				end
				value:Hide()
				value:SetScript("OnUpdate", nil)		
			end
		end
	end
end
SLASH_SRAuraWatch1 = "/SRAuraWatch"
SLASH_SRAuraWatch2 = "/sRaw"

