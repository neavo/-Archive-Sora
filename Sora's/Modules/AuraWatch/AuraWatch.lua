-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local addon = Sora:NewModule("AuraWatch")

local Aura, UnitIDTable, MaxFrame = {}, {}, 12

-- Init
local function BuildUnitIDTable()
	for _, VALUE in pairs(AuraWatchDB) do
		for _, value in pairs(VALUE.List) do
			local Flag = true
			for _,v in pairs(UnitIDTable) do
				if value.UnitID == v then Flag = false end
			end
			if Flag then tinsert(UnitIDTable, value.UnitID) end
		end
	end
end
local function BuildAura()
	for key, value in pairs(AuraWatchDB) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			if value.Mode:lower() == "icon" then
				local Frame = S.BuildICON(value.IconSize)
				tinsert(FrameTable, Frame)
			elseif value.Mode:lower() == "bar" then
				local Frame = S.BuildBAR(value.BarWidth, value.IconSize)
				tinsert(FrameTable, Frame)
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
end
local function UpdatePos()
	for key, value in pairs(Aura) do
		local Pos, Direction, Interval = AuraWatchDB[key].Pos, AuraWatchDB[key].Direction, AuraWatchDB[key].Interval
		for i = 1, MaxFrame do
			value[i]:ClearAllPoints()
			if i == 1 then
				value[i]:SetPoint(unpack(Pos))
			elseif Direction:lower() == "right" then
				value[i]:SetPoint("LEFT", value[i-1], "RIGHT", Interval, 0)
			elseif Direction:lower() == "left" then
				value[i]:SetPoint("RIGHT", value[i-1], "LEFT", -Interval, 0)
			elseif Direction:lower() == "up" then
				value[i]:SetPoint("BOTTOM", value[i-1], "TOP", 0, Interval)
			elseif Direction:lower() == "down" then
				value[i]:SetPoint("TOP", value[i-1], "BOTTOM", 0, -Interval)
			end
		end
	end
end

-- SetTime
local function SetTime(self)
	if self.Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
		self.Statusbar:SetValue(self.Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
		self.Statusbar:SetValue(self.Timer)
	end
end

-- UpdateCD
local function UpdateCDFrame(index, name, icon, start, duration)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		CooldownFrame_SetTimer(Frame.Cooldown, start, duration, 1)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = start+duration-GetTime()
			SetTime(self)
		end)
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function UpdateCD()
	for KEY, VALUE in pairs(AuraWatchDB) do
		for _, value in pairs(VALUE.List) do
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then
					local name, _, icon = GetSpellInfo(value.SpellID)
					local start, duration = GetSpellCooldown(value.SpellID)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end
			end
			if value.ItemID then
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					local start, duration = GetItemCooldown(value.ItemID)
					UpdateCDFrame(KEY, name, icon, start, duration)
				end
			end
		end
	end
end

-- UpdateAura
local function UpdateAuraFrame(index, name, icon, count, duration, expires)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count then Frame.Count:SetText(count > 1 and count or nil) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(true)
		CooldownFrame_SetTimer(Frame.Cooldown, expires-duration, duration, 1)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		Frame.Timer = 0
		Frame.Statusbar:SetMinMaxValues(0, duration)
		Frame:SetScript("OnUpdate", function(self, elapsed)
			self.Timer = expires-GetTime()
			SetTime(self)
		end)
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function AuraFilter(spellID, UnitID, index, bool)
	for KEY, VALUE in pairs(AuraWatchDB) do
		for key, value in pairs(VALUE.List) do
			if value.AuraID == spellID and value.UnitID == UnitID then
				if bool then
					local name, _, icon, count, _, duration, expires, caster = UnitBuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, name, icon, count, duration, expires
				else
					local name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, name, icon, count, duration, expires
				end
			end
		end
	end
	return false
end
local function UpdateAura(UnitID)
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, true) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, true)) end
		index = index + 1
	end
	local index = 1
    while true do
		local name, _, _, _, _, _, _, _, _, _, spellID = UnitDebuff(UnitID, index)
		if not name then break end
		if AuraFilter(spellID, UnitID, index, false) then UpdateAuraFrame(AuraFilter(spellID, UnitID, index, false)) end
		index = index + 1
	end
end

-- CleanUp
local function CleanUp()
	for _, value in pairs(Aura) do
		for i = 1, MaxFrame do
			if value[i] then
				value[i]:Hide()
				value[i]:SetScript("OnUpdate", nil)
			end
			if value[i].Icon then value[i].Icon:SetTexture(nil) end
			if value[i].Count then value[i].Count:SetText(nil) end
			if value[i].Spellname then value[i].Spellname:SetText(nil) end
			if value[i].Statusbar then
				value[i].Statusbar:SetMinMaxValues(0, 1) 
				value[i].Statusbar:SetValue(0)
			end
		end
		value.Index = 1
	end
end

function addon:OnInitialize()
	BuildUnitIDTable()
end

function addon:OnEnable()
	BuildAura()
	UpdatePos()
	local Timer = 0
	local Update = CreateFrame("Frame")
	Update:SetScript("OnUpdate", function(self, elapsed)
		Timer = Timer + elapsed
		if Timer > 0.5 then
			Timer = 0
			CleanUp()
			UpdateCD()
			for _, value in pairs(UnitIDTable) do UpdateAura(value) end
		end	
	end)
end