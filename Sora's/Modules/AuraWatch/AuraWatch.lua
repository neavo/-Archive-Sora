-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("AuraWatch", "AceTimer-3.0")
local Aura, MaxFrame, Index = {}, 12, 1

local function MakeMoveHandle(Frame, Text, key, Pos)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetSize(Frame:GetWidth(), Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = S.MakeFontString(MoveHandle, 10)
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	if not MoveHandleDB["AuraWatch"][key] then 
		MoveHandle:SetPoint(unpack(Pos))
	else
		MoveHandle:SetPoint(unpack(MoveHandleDB["AuraWatch"][key]))		
	end
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		MoveHandleDB["AuraWatch"][key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end

local function BuildAura()
	for key, value in pairs(AuraWatchDB) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			local Frame = nil
			if value.Mode:lower() == "icon" then
				Frame = S.BuildICON(value.IconSize)
			elseif value.Mode:lower() == "bar" then
				Frame = S.BuildBAR(value.BarWidth, value.IconSize)
			end
			if i == 1 then
				Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos)
				MoveHandle["AuraWatch_"..key] = Frame.MoveHandle
			end
			tinsert(FrameTable, Frame)
		end
		tinsert(Aura, FrameTable)
	end
end

local function UpdatePos()
	for key, value in pairs(Aura) do
		local Direction, Interval = AuraWatchDB[key].Direction, AuraWatchDB[key].Interval
		for i = 1, MaxFrame do
			value[i]:ClearAllPoints()
			if i == 1 then
				value[i]:SetPoint("CENTER", value[i].MoveHandle)
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

local function CleanUp()
	for _, VALUE in pairs(Aura) do
		for _, value in pairs(VALUE) do
			if value then
				value:Hide()
				value:SetScript("OnUpdate", nil)
			end
			if value.Icon then value.Icon:SetTexture(nil) end
			if value.Count then value.Count:SetText(nil) end
			if valueSpellname then value.Spellname:SetText(nil) end
			if value.Statusbar then
				value.Statusbar:SetMinMaxValues(0, 1) 
				value.Statusbar:SetValue(0)
			end
		end
	end
end

local function SetTime(self)
	if self.Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", self.Timer) end
		self.Statusbar:SetValue(self.Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60) end
		self.Statusbar:SetValue(self.Timer)
	end
end

local function UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
	if value.Caster and value.Caster ~= caster then return end
	if value.Stack and count and value.Stack > count then return end
	local Frame = Aura[KEY][Index]
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
	Index = Index + 1
end

local function UpdateCDFrame(KEY, name, icon, start, duration)
	local Frame = Aura[KEY][Index]
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
	Index = Index + 1
end

local function UpdateFrame()
	for KEY, VALUE in pairs(AuraWatchDB) do
		Index = 1
		for _, value in pairs(VALUE.List) do
			if value.AuraID then
				local name = GetSpellInfo(value.AuraID)
				if UnitBuff(value.UnitID, name) then
					local name, _, icon, count, _, duration, expires, caster = UnitBuff(value.UnitID, name)
					UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
				elseif UnitDebuff(value.UnitID, name) then
					local name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.UnitID, name)
					UpdateAuraFrame(KEY, value, name, icon, count, duration, expires, caster)
				end
			end
			if value.SpellID then
				if GetSpellCooldown(value.SpellID) and select(2, GetSpellCooldown(value.SpellID)) > 1.5 then
					local name, _, icon = GetSpellInfo(value.SpellID)
					local start, duration = GetSpellCooldown(value.SpellID)
					UpdateCDFrame(name, icon, start, duration)
				end
			end
			if value.ItemID then
				if select(2, GetItemCooldown(value.ItemID)) > 1.5 then
					local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(value.ItemID)
					local start, duration = GetItemCooldown(value.ItemID)
					UpdateCDFrame(name, icon, start, duration)
				end
			end
		end
	end
end

local function OnUpdate()
	CleanUp()
	UpdateFrame()
end

function Module:OnEnable()
	if not MoveHandleDB["AuraWatch"] then MoveHandleDB["AuraWatch"] = {} end
	BuildAura()
	UpdatePos()
	Module:ScheduleRepeatingTimer(OnUpdate, 0.5)
end