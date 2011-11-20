-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ClassTimer", "AceEvent-3.0")
local PlayerAura, PlayerActive, TargetAura, TargetActive = {}, {}, {}, {}

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
		return _G["oUF_SoraPlayer"], C["PlayerMode"], C["PlayerIconSize"], C["PlayerLimit"], PlayerAura, PlayerActive, UnitBuff
	end
	if unit == "target" then 
		return _G["oUF_SoraTarget"], C["TargetMode"], C["TargetIconSize"], C["TargetLimit"], TargetAura, TargetActive, UnitDebuff
	end
end

function Module:BuildAura(unit)
	local Parent, Mode, IconSize = Module:GetUnitVal(unit)
	if Mode == "Icon" then
		return Module:BuildIcon(IconSize)
	end
	if Mode == "Bar" then
		return Module:BuildBar(Parent:GetWidth()-20, IconSize)
	end
end

function Module:ClearAura(unit)
	local _, _, _, _, Aura = Module:GetUnitVal(unit)
	for _, value in pairs(Aura) do
		value:Hide()
		value:ClearAllPoints()
		value:SetScript("OnUpdate", nil)
	end
	wipe(Aura)
end

function Module:CleanUp(unit)
	local _, _, _, _, Aura, Active = Module:GetUnitVal(unit)
	wipe(Active)
	for _, value in pairs(Aura) do
		value:Hide()
	end
end

function Module:UpdateAuraPos(unit)
	local Parent, Mode, IconSize, _, Aura = Module:GetUnitVal(unit)
	if Mode == "Bar" then
		for i = 1, #Aura do
			local Frame, Pre = Aura[i], Aura[i-1]
			Frame:ClearAllPoints()
			if i == 1 then
				Frame:SetPoint("BOTTOM", Parent, "TOP", 0, unit == "player" and 12 or 8)
			else
				Frame:SetPoint("BOTTOM", Pre, "TOP", 0, 5)
			end
			Frame.ID = i
		end
	end
	if Mode == "Icon" then
		for i = 1, #Aura do
			local Frame, Pre, IconPerRow = Aura[i], Aura[i-1], floor(Parent:GetWidth()/(IconSize+5))
			local PreRowFrame = Aura[i-IconPerRow]
			Frame:ClearAllPoints()
			if i == 1 then
				Frame:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, unit == "player" and 12 or 8)
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
	local _, _, _, Limit, _, Active, Func = Module:GetUnitVal(unit)
	local index = 1
	while true do
		if not Func(unit, index) then break end
		local name, _, icon, count, _, duration, expires, caster = Func(unit, index)
		if caster == "player" and ((((duration < Limit and duration ~= 0) or Limit == 0) and not C["BlackList"][name]) or C["WhiteList"][name]) then
			tinsert(Active, {name, icon, count, duration, expires})
		end
		index = index + 1
	end
end

function Module:UpdateAura(unit)
	local _, _, _, _, Aura, Active, Func = Module:GetUnitVal(unit)
	for key, value in pairs(Active) do
		local name, icon, count, duration, expires = unpack(value)
		if not Aura[key] then Aura[key] = Module:BuildAura(unit) end
		local Frame = Aura[key]
		local Spellname, Icon, Count, Time, Statusbar, Cooldown = Frame.Spellname, Frame.Icon, Frame.Count, Frame.Time, Frame.Statusbar, Frame.Cooldown
		if Spellname then Spellname:SetText(name) end
		if Icon then Icon:SetTexture(icon) end
		if Count then Count:SetText(count>1 and count or "") end
		if Statusbar then Statusbar:SetMinMaxValues(0, duration) end
		if Cooldown then CooldownFrame_SetTimer(Cooldown, expires-duration, duration, 1) end
		local Timer = 0
		Frame:SetScript("OnUpdate", function(self, elapsed)
			Timer = expires-GetTime()
			if Func(unit, name) then
				if Timer >= 60 then
					if Time then Time:SetFormattedText("%d:%.2d", Timer/60, Timer%60) end
					if Statusbar then Statusbar:SetValue(Timer) end
				elseif Timer < 60 then
					if Time then Time:SetFormattedText("%.1f", Timer) end
					if Statusbar then Statusbar:SetValue(Timer) end
				end
			else
				self:Hide()
				self:SetScript("OnUpdate", nil)
				tremove(Aura, self.ID)
				Module:UpdateAuraPos(unit)
			end
		end)
		Frame:Show()
	end
end

function Module:UpdateAll(event, unit, ...)
	if unit == "player" and C["PlayerMode"] ~= "None" then
		Module:CleanUp(unit)
		Module:UpdateActive(unit)
		Module:UpdateAura(unit)
		Module:UpdateAuraPos(unit)
	elseif unit == "target" and C["TargetMode"] ~= "None" then
		Module:CleanUp(unit)
		Module:UpdateActive(unit)
		Module:UpdateAura(unit)
		Module:UpdateAuraPos(unit)
	end
end

function Module:OnInitialize()
	C = ClassTimerDB
	Module:RegisterEvent("UNIT_TARGET", "UpdateAll")
	Module:RegisterEvent("UNIT_AURA", "UpdateAll")
end