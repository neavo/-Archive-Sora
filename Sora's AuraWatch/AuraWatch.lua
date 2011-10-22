----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local AuraList, Aura, MaxFrame = {}, {}, 15
local MyClass = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR

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
				tinsert(FrameTable, BuildICON(value.IconSize))
			elseif value.Mode:lower() == "bar" then
				tinsert(FrameTable, BuildBAR(value.BarWidth, value.IconSize))
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
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
	if Timer < 0 then
		if self.Time then self.Time:SetText("N/A") end
		self.Statusbar:SetMinMaxValues(0, 1) 
		self.Statusbar:SetValue(0)
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

-- UpdateCD
local function UpdateCDFrame(index, name, icon, start, duration, bool)
	local Frame = Aura[index][Aura[index].Index]
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
	Frame.Type = "CD"
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function UpdateCD()
	for KEY, VALUE in pairs(Aura) do
		local Flag = false
		for i = 1, MaxFrame do
			if VALUE[i].Type == "CD" then
				VALUE[i]:SetScript("OnUpdate", nil)
				VALUE[i]:Hide()
				VALUE[i].Type = nil
				Flag = true
			end
		end
		if Flag then VALUE.Index = 1 end
	end
	
	for KEY, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then
					local name, _, icon = GetSpellInfo(value.SpellID)
					local start, duration = GetSpellCooldown(value.SpellID)
					UpdateCDFrame(KEY, name, icon, start, duration, true)
				end
			end
			if value.ItemID then
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					local start, duration = GetItemCooldown(value.ItemID)
					UpdateCDFrame(KEY, name, icon, start, duration, false)
				end
			end
		end
	end
end

-- UpdateAura
local function UpdateAuraFrame(index, UnitID, name, icon, count, duration, expires)
	local Frame = Aura[index][Aura[index].Index]
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
	if Frame.ClickCast then Frame.ClickCast:SetAttribute("macrotext", "/cast [target="..UnitID.."] "..name) end
	
	Frame.UnitID = UnitID
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function AuraFilter(spellID, unitID, name, bool)
	for KEY, VALUE in pairs(AuraList) do
		for key, value in pairs(VALUE.List) do
			if value.AuraID == spellID and value.UnitID == unitID then
				if bool then
					local name, _, icon, count, _, duration, expires, caster = UnitBuff(value.UnitID, name)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires
				else
					local name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.UnitID, name)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires
				end
			end
		end
	end
	return false
end
local function UpdateAura(self, event, unitID, ...)
	for KEY, VALUE in pairs(Aura) do
		local Flag = false
		for i = 1, MaxFrame do
			if VALUE[i].UnitID == unitID then
				VALUE[i]:SetScript("OnUpdate", nil)
				VALUE[i]:Hide()
				VALUE[i].UnitID = nil
				Flag = true
			end
		end
		if Flag then VALUE.Index = 1 end
	end
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unitID, index)
		if not name then break end
		if AuraFilter(spellID, unitID, name, true) then UpdateAuraFrame(AuraFilter(spellID, unitID, name, true)) end
		index = index + 1
	end
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff(unitID, index)
		if not name then break end
		if AuraFilter(spellID, unitID, name, false) then UpdateAuraFrame(AuraFilter(spellID, unitID, name, false)) end
		index = index + 1
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:SetScript("onEvent", function(self, event, unitID, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	elseif event == "PLAYER_ENTERING_WORLD" then
		Pos()
	elseif event == "UNIT_AURA" then
		UpdateAura(self, event, unitID, ...)
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdateAura(self, event, "target", ...)
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate", function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.5 then
		self.Timer = 0
		UpdateCD()
	end	
end)


-- Test
local TestFlag = true
SlashCmdList.SRAuraWatch = function()
	if TestFlag then
		TestFlag = false
		Event:SetScript("OnUpdate", nil)
		Event:UnregisterEvent("UNIT_AURA")
		Event:UnregisterEvent("PLAYER_TARGET_CHANGED")
		for _, VALUE in pairs(Aura) do
			for i = 1, MaxFrame do
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
				UpdateCD()
			end	
		end)
		Event:RegisterEvent("UNIT_AURA")
		Event:RegisterEvent("PLAYER_TARGET_CHANGED")
		for _, VALUE in pairs(Aura) do
			for i = 1, MaxFrame do
				VALUE[i]:Hide()
			end
			VALUE.Index = 1
		end
	end
end
SLASH_SRAuraWatch1 = "/SRAuraWatch"
SLASH_SRAuraWatch2 = "/sRaw"

