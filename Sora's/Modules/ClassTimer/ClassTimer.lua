-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ClassTimer", "AceEvent-3.0")
local PlayerAura, TargetAura, WhiteList, BlackList, oUF_SoraPlayer, oUF_SoraTarget = {}, {}, nil, nil, nil, nil

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

function Module:BuildBar(IconSize, BarWidth)
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

function Module:ClearAura(unit)
	if unit == "player" then
		for key, value in pairs(PlayerAura) do
			value:ClearAllPoints()
			value:SetScript("OnUpdate", nil)
			value:Hide()
		end
		wipe(PlayerAura)
	end
	if unit == "target" then
		for key, value in pairs(TargetAura) do
			value:ClearAllPoints()
			value:SetScript("OnUpdate", nil)
			value:Hide()
		end
		wipe(TargetAura)
	end
end

function Module:UpdateAura(Aura, Parent, Mode, IconSize, BarWidth, Key, name, icon, count, duration, expires)
	if Mode == "Icon" then
		if not Aura[Key] then
			Aura[Key] = Module:BuildIcon(IconSize)
			if Key == 1 then
				Aura[Key]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 12)
			elseif Key%floor(Parent:GetWidth()/(IconSize+5)) == 1 then
				Aura[Key]:SetPoint("BOTTOM", Aura[Key-floor(Parent:GetWidth()/(IconSize+5))], "TOP", 0, 5)
			else
				Aura[Key]:SetPoint("LEFT", Aura[Key-1], "RIGHT", 5, 0)
			end
		end
		
		local Aura = Aura[Key]
		Aura.Icon:SetTexture(icon)
		Aura.Count:SetText(count > 1 and count or "")		
		CooldownFrame_SetTimer(Aura.Cooldown, expires-duration, duration, 1)
		
		Aura:Show()
	end
	if Mode == "Bar" then		
		if not Aura[Key] then
			Aura[Key] = Module:BuildBar(IconSize, Parent:GetWidth()-20)
			if Key == 1 then
				Aura[Key]:SetPoint("BOTTOM", Parent, "TOP", 0, 12)
			else
				Aura[Key]:SetPoint("BOTTOM", Aura[Key-1], "TOP", 0, 5)
			end
		end
		
		local Aura = Aura[Key]
		Aura.Icon:SetTexture(icon)
		Aura.Count:SetText(count > 1 and count or "")		
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
		
		Aura:Show()
	end
end

function Module:OnUpdate(unit)
	if unit == "player" and C["PlayerMode"] ~= "None" then
		local Key = 0
		
		for index = 1, 40 do
			local name, rank, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, index)
			if not name then break end
			if ((duration < 60 and duration ~= 0) and caster == "player" and not BlackList[name]) or WhiteList[name] then
				Key = Key + 1
				Module:UpdateAura(PlayerAura, oUF_SoraPlayer, C["PlayerMode"], C["PlayerIconSize"], oUF_SoraPlayer:GetWidth()-20, Key, name, icon, count, duration, expires)
			end
		end
		
		for index = 1, 40 do
			local name, rank, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, index)
			if not name then break end
			if WhiteList[name] then
				Key = Key + 1
				Module:UpdateAura(PlayerAura, oUF_SoraPlayer, C["PlayerMode"], C["PlayerIconSize"], oUF_SoraPlayer:GetWidth()-20, Key, name, icon, count, duration, expires)
			end
		end
		
		for index = Key + 1, #PlayerAura do
			PlayerAura[index]:Hide()
		end
	end
	if unit == "target" and C["TargetMode"] ~= "None" then
		local isFriends = UnitIsFriend("player", unit) and "HELPFUL" or "HARMFUL"   
		local Key = 0
		for index = 1, 40 do
			local name, rank, icon, count, dispelType, duration, expires, caster = UnitAura(unit, index, isFriends)
			if not name then break end
			if ((duration < 60 and duration ~= 0) and caster == "player" and not BlackList[name]) or WhiteList[name] then
				Key = Key + 1
				Module:UpdateAura(TargetAura, oUF_SoraTarget, C["TargetMode"], C["TargetIconSize"], oUF_SoraTarget:GetWidth()-20, Key, name, icon, count, duration, expires)
			end
		end
		
		for index = Key + 1, #TargetAura do
			TargetAura[index]:Hide()
			TargetAura[index]:SetScript("OnUpdate", nil)
		end
	end
end

function Module:OnEvent(event, unit, ...)
	if event == "UNIT_AURA" then
		Module:OnUpdate(unit)
	end
	if event == "PLAYER_TARGET_CHANGED" then
		Module:OnUpdate("target")
	end
end

function Module:OnInitialize()
	C = ClassTimerDB
	WhiteList = C["WhiteList"]
	BlackList = C["BlackList"]
	Module:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
	Module:RegisterEvent("UNIT_AURA", "OnEvent")
end

function Module:OnEnable()
	oUF_SoraPlayer = _G["oUF_SoraPlayer"]
	oUF_SoraTarget = _G["oUF_SoraTarget"]
end