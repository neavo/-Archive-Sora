----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local Aura, Arg, AuraList = {}, {}, {}
local class = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR


-- Init
local function Init()
	AuraList = SRAuraList["ALL"] and SRAuraList["ALL"] or {}
	for key, _ in pairs(SRAuraList) do
		if key == class then
			for _, value in pairs(SRAuraList[class]) do
				table.insert(AuraList, value)
			end
		end
		SRAuraList[key] = nil
	end
	for _, value in pairs(AuraList) do
		local tempTable = {}
		for i = 1, #(value.List) do
			local temp = nil
			if value.Mode:lower() == "icon" then
				temp = BuildICON(value.iconSize)
			elseif value.Mode:lower() == "bar" then
				temp = cfg.BuildBAR(value.iconSize, value.barWidth)
			end
			temp:Hide()
			table.insert(tempTable, temp)
		end
		table.insert(Arg, 0)
		table.insert(Aura, tempTable)
	end
end

-- Pos
local function Pos()
	for key,VALUE in pairs(Aura) do
		local value = AuraList[key]
		local Pre = nil
		for i = 1,#VALUE do
			local frame = VALUE[i]
			if i == 1 then
				frame:SetPoint(unpack(value.Pos))
			elseif value.Direction == "RIGHT" then
				frame:SetPoint("LEFT", Pre, "RIGHT", value.Interval, 0)
			elseif value.Direction == "LEFT" then
				frame:SetPoint("RIGHT", Pre, "LEFT", -value.Interval, 0)
			elseif value.Direction == "UP" then
				frame:SetPoint("BOTTOM", Pre, "TOP", 0, value.Interval)
			elseif value.Direction == "DOWN" then
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
	if self.Time then
		self.Statusbar:SetMinMaxValues(0, self.duration) 
		self.Statusbar:SetValue(Timer) 
		if Timer <= 60 then
			self.Time:SetFormattedText("%.1f",(Timer)) 
		else
			self.Time:SetFormattedText("%d:%.1d",(Timer/60),(Timer/2)) 
		end
	end
end

-- Update
local function Update()
	for KEY,VALUE in pairs(Aura) do
		for i = 1, Arg[KEY] do
			VALUE[i]:Hide()
			VALUE[i]:SetScript("OnUpdate",nil)		
		end
	end
	for KEY,VALUE in pairs(Aura) do
		Arg[KEY] = 1
		for key,value in pairs(AuraList[KEY].List) do
			local spn = GetSpellInfo(value.spellID)
			local contiue = true
			local name, icon, count, duration, expires, caster, start
			if value.Filter:lower() == "buff" and UnitBuff(value.unitId, spn) then
				name, _, icon, count, _, duration, expires, caster = UnitBuff(value.unitId, spn)
			elseif value.Filter:lower() == "debuff" and UnitDebuff(value.unitId, spn) then
				name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.unitId, spn)
			elseif value.Filter:lower() == "cd" and GetSpellCooldown(spn) then
				start, duration = GetSpellCooldown(spn)
				_, _, icon = GetSpellInfo(value.spellID)
				count = 0
				name = spn
			else
				contiue = false
			end
			if value.Caster and caster and value.Caster:lower() ~= caster:lower() then
				contiue = false
			end
			if value.Stack and count and value.Stack > count then
				contiue = false
			end
			if contiue then
				local frame = VALUE[Arg[KEY]]
				frame:Show()
				
				if frame.Icon and value.Filter:lower() ~= "cd" then
					frame.Icon:SetTexture(icon)
				elseif frame.Icon and value.Filter:lower() == "cd" and duration > 1.5 then
					frame.Icon:SetTexture(icon)
				elseif frame.Icon then
					frame.Icon:SetTexture(nil)
					frame:Hide()
				end
				if frame.Count and count > 1 then
					frame.Count:SetText(count)
				elseif frame.Count then
					frame.Count:SetText("")
				end
				if frame.Cooldown and value.Filter:lower() ~= "cd" then
					CooldownFrame_SetTimer(frame.Cooldown, expires-duration, duration, 1) 
				elseif frame.Cooldown and value.Filter:lower() == "cd" then
					frame.Cooldown:SetReverse(false)
					CooldownFrame_SetTimer(frame.Cooldown, start , duration, 1) 
				end
				if frame.Time then
					frame.Filter = value.Filter
					frame.duration = duration
					frame.expires = expires or start
					frame:SetScript("OnUpdate",OnUpdate)
				end
				if frame.Spellname then
					frame.Spellname:SetText(name)		
				end
				Arg[KEY] = Arg[KEY] + 1
			end
		end
		Arg[KEY] = Arg[KEY] - 1
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent",function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	elseif event == "PLAYER_ENTERING_WORLD" then
		Pos()
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate",function(self,elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.5 then
		self.Timer = 0
		Update()
	end	
end)


-- Test
local testFlag = true
local function Test()
	if testFlag then
		testFlag = false
		Event:SetScript("OnUpdate", nil)
		for _,VALUE in pairs(Aura) do
			for _,value in pairs(VALUE) do
				value:Hide()
				value:SetScript("OnUpdate",nil)		
				
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
		Event:SetScript("OnUpdate",function(self,elapsed)
			self.Timer = self.Timer + elapsed
			if self.Timer > 0.5 then
				self.Timer = 0
				Update()
			end	
		end)
		for _,VALUE in pairs(Aura) do
			for _,value in pairs(VALUE) do
				value:Hide()
				value:SetScript("OnUpdate",nil)		
			end
		end
	end
end
SlashCmdList.SRAuraWatch = function()
	Test()
end
SLASH_SRAuraWatch1 = "/SRAuraWatch"

