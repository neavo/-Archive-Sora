-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ClassTimer", "AceEvent-3.0")
local PlayerAura, PlayerActive, TargetAura, TargetActive = {}, {}, {}, {}
local UnitFrame, Mode, IconSize, Limit, Aura, Active, Func =  nil, nil, nil, nil, nil, nil, nil
local tinsert, tsort, _G, UnitBuff, UnitDebuff = tinsert, table.sort, _G, UnitBuff, UnitDebuff

function Module:BuildBar(BarWidth, IconSize)
	local Aura = CreateFrame("Frame", nil, UIParent)
	Aura:SetSize(BarWidth, IconSize)
	
	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK")
	Aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Aura.Icon:SetSize(IconSize, IconSize)
	Aura.Icon:SetPoint("LEFT", -5, 0)
	Aura.Icon.Shadow = S.MakeTexShadow(Aura, Aura.Icon, 3)

	Aura.Statusbar = CreateFrame("StatusBar", nil, Aura)
	Aura.Statusbar:SetSize(Aura:GetWidth()-Aura:GetHeight()-5, Aura:GetHeight()/3)
	Aura.Statusbar:SetPoint("BOTTOMRIGHT") 
	Aura.Statusbar:SetStatusBarTexture(DB.Statusbar) 
	Aura.Statusbar:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0.9)
	Aura.Statusbar.Shadow = S.MakeShadow(Aura.Statusbar, 3)

	Aura.Count = S.MakeFontString(Aura, 9)
	Aura.Count:SetPoint("BOTTOMRIGHT", Aura.Icon, "BOTTOMRIGHT", 3, -2) 

	Aura.Time = S.MakeFontString(Aura.Statusbar, 11)
	Aura.Time:SetPoint("RIGHT", 0, 5) 

	Aura.Spellname = S.MakeFontString(Aura.Statusbar, 11)
	Aura.Spellname:SetPoint("CENTER", -10, 5)
		
	return Aura
end

function Module:BuildIcon(IconSize)
	local Aura = CreateFrame("Frame", nil, UIParent)
	Aura:SetSize(IconSize, IconSize)
	
	Aura.Icon = Aura:CreateTexture(nil, "ARTWORK") 
	Aura.Icon:SetAllPoints()
	Aura.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Aura.Icon.Shadow = S.MakeTexShadow(Aura, Aura.Icon, 3)
	
	Aura.Count = S.MakeFontString(Aura, 10)
	Aura.Count:SetPoint("BOTTOMRIGHT", 3, -2)
	
	Aura.Cooldown = CreateFrame("Cooldown", nil, Aura) 
	Aura.Cooldown:SetAllPoints() 
	Aura.Cooldown:SetReverse(true)

	return Aura
end

function Module:GetUnitVal(unit)
	if unit == "player" then
		UnitFrame, Mode, IconSize, Limit, Aura, Active, Func = _G["oUF_SoraPlayer"], C["PlayerMode"], C["PlayerIconSize"], BUFF_ACTUAL_DISPLAY, PlayerAura, PlayerActive, UnitBuff
	end
	if unit == "target" then 
		UnitFrame, Mode, IconSize, Limit, Aura, Active, Func = _G["oUF_SoraTarget"], C["TargetMode"], C["TargetIconSize"], MAX_TARGET_DEBUFFS, TargetAura, TargetActive, UnitDebuff
	end
end

function Module:BuildAura(unit)
	Module:GetUnitVal(unit)
	if Mode == "Icon" then
		return Module:BuildIcon(IconSize)
	end
	if Mode == "Bar" then
		return Module:BuildBar(UnitFrame:GetWidth()-20, IconSize)
	end
end

function Module:ClearAura(unit)
	Module:GetUnitVal(unit)
	for _, value in pairs(Aura) do
		value:Hide()
		value:ClearAllPoints()
		value:SetScript("OnUpdate", nil)
	end
	wipe(Aura)
end

function Module:CleanUp(unit)
	Module:GetUnitVal(unit)
	wipe(Active)
	for key, value in pairs(Aura) do
		value:Hide()
	end
end

function Module:UpdateAuraPos(unit)
	Module:GetUnitVal(unit)
	if Mode == "Bar" then
		for i = 1, #Aura do
			local Frame, Pre = Aura[i], Aura[i-1]
			Frame:ClearAllPoints()
			if i == 1 then
				Frame:SetPoint("BOTTOM", UnitFrame, "TOP", 0, unit == "player" and 12 or 8)
			else
				Frame:SetPoint("BOTTOM", Pre, "TOP", 0, 5)
			end
			Frame.ID = i
		end
	end
	if Mode == "Icon" then
		for i = 1, #Aura do
			local Frame, Pre, IconPerRow = Aura[i], Aura[i-1], floor(UnitFrame:GetWidth()/(IconSize+5))
			local PreRowFrame = Aura[i-IconPerRow]
			Frame:ClearAllPoints()
			if i == 1 then
				Frame:SetPoint("BOTTOMLEFT", UnitFrame, "TOPLEFT", 0, unit == "player" and 12 or 8)
			elseif i%IconPerRow == 1 then
				Frame:SetPoint("BOTTOM", PreRowFrame, "TOP", 0, 5)
			else
				Frame:SetPoint("LEFT", Pre, "RIGHT", 5, 0)
			end
			Frame.ID = i
		end
	end
end

function Module:UpdateActive(unit)
	Module:GetUnitVal(unit)
	for i = 1, Limit do 
		local name, _, icon, count, _, duration, expires, caster = Func(unit, i)
		if (caster == "player" and ((duration < 60 and duration ~= 0) and not C["BlackList"][name])) or C["WhiteList"][name] then
			tinsert(Active, {name, icon, count, duration, expires})
		end
	end
end

function Module:SortActive(unit)
	Module:GetUnitVal(unit)
	tsort(Active, function(a, b)
		return (a[5]-GetTime()) < (b[5]-GetTime())
	end)
end

function Module:UpdateAura(unit)
	Module:GetUnitVal(unit)
	for key, value in pairs(Active) do
		local name, icon, count, duration, expires = unpack(value)
		if not Aura[key] then
			Aura[key] = Module:BuildAura(unit)
		end
		local Aura = Aura[key]
		Aura.Icon:SetTexture(icon)
		Aura.Count:SetText(count>1 and count or "")		
		if Mode == "Icon" then
			CooldownFrame_SetTimer(Aura.Cooldown, expires-duration, duration, 1)
		end
		if Mode == "Bar" then
			Aura.Spellname:SetText(name)
			Aura.Statusbar:SetMinMaxValues(0, duration)
			Aura.Timer = 0
			Aura:SetScript("OnUpdate", function(self, elapsed)
				self.Timer = expires-GetTime()
				if self.Timer >= 60 then
					self.Time:SetFormattedText("%d:%.2d", self.Timer/60, self.Timer%60)
					self.Statusbar:SetValue(self.Timer)
				elseif self.Timer < 60 then
					self.Time:SetFormattedText("%.1f", self.Timer)
					self.Statusbar:SetValue(self.Timer)
				end
			end)
		end
		Aura:Show()
	end
end

function Module:PLAYER_DEAD(event, ...)
	if C["PlayerMode"] ~= "None" then
		Module:Update("player")
	end
	if C["TargetMode"] ~= "None" then
		Module:Update("target")
	end
end

function Module:UNIT_AURA(event, unit, ...)
	if not unit == "player" or not unit == "target" then
		return
	end
	if unit == "player" and C["PlayerMode"] ~= "None" then
		Module:Update(unit)
	end
	if unit == "target" and C["TargetMode"] ~= "None" then
		Module:Update(unit)
	end
end

function Module:UNIT_TARGET(event, unit, ...)
	if C["PlayerMode"] ~= "None" then
		Module:Update("player")
	end
	if C["TargetMode"] ~= "None" then
		Module:Update("target")
	end
end

function Module:Update(unit)
	Module:CleanUp(unit)
	Module:UpdateActive(unit)
	Module:SortActive(unit)
	Module:UpdateAura(unit)
	Module:UpdateAuraPos(unit)
end

function Module:OnInitialize()
	C = ClassTimerDB
	Module:RegisterEvent("UNIT_TARGET")
	Module:RegisterEvent("PLAYER_DEAD")
	Module:RegisterEvent("UNIT_AURA")
end