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
	Aura.Count:SetPoint("BOTTOMRIGHT", Aura.Icon, "BOTTOMRIGHT", 3, -1) 

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
	Aura.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	
	Aura.Cooldown = CreateFrame("Cooldown", nil, Aura) 
	Aura.Cooldown:SetAllPoints() 
	Aura.Cooldown:SetReverse(true)

	return Aura
end

function Module:BuildAura(unit)
	if unit == "palyer" then
		local oUF_SoraPlayer = _G["oUF_SoraPlayer"]
		if C["PlayerMode"] == "Icon" then
			return Module:BuildIcon(30)
		end
		if C["PlayerMode"] == "Bar" then
			return Module:BuildBar(oUF_SoraPlayer:GetWidth()-20, 20)
		end
	end
	if unit == "target" then
		local oUF_SoraTarget = _G["oUF_SoraTarget"]
		if C["TargetMode"] == "Icon" then
			return Module:BuildIcon(30)
		end
		if C["TargetMode"] == "Bar" then
			return Module:BuildBar(oUF_SoraPlayer:GetWidth()-20, 20)
		end
	end
end

function Module:ClearPlayerAura()
	for _, value in pairs(PlayerAura) do
		value:Hide()
		value:ClearAllPoints()
		value:SetScript("OnUpdate", nil)
	end
	wipe(PlayerAura)
end

function Module:CleanUpPlayerAura()
	wipe(PlayerActive)
	for _, value in pairs(PlayerAura) do
		value:Hide()
	end
end

function Module:UpdatePlayerAuraPos()
	if C["PlayerMode"] == "Bar" then
		for i = 1, #PlayerAura do
			local oUF_SoraPlayer = _G["oUF_SoraPlayer"]
			local Aura, Pre = PlayerAura[i], PlayerAura[i-1]
			Aura:ClearAllPoints()
			if i == 1 then
				Aura:SetPoint("BOTTOM", oUF_SoraPlayer, "TOP", 0, 15)
			else
				Aura:SetPoint("BOTTOM", Pre, "TOP", 0, 5)
			end
			Aura.ID = i
		end
	end
	if C["PlayerMode"] == "Icon" then
		for i = 1, #PlayerAura do
			local oUF_SoraPlayer = _G["oUF_SoraPlayer"]
			local Aura, Pre, IconPerRow = PlayerAura[i], PlayerAura[i-1], floor(oUF_SoraPlayer:GetWidth()/30)
			local PreRowAura = PlayerAura[i-IconPerRow]
			Aura:ClearAllPoints()
			if i == 1 then
				Aura:SetPoint("BOTTOMLEFT", oUF_SoraPlayer, "TOPLEFT", 0, 12)
			elseif i%IconPerRow == 1 then
				Aura:SetPoint("BOTTOM", PreRowAura, "TOP", 0, 5)
			else
				Aura:SetPoint("LEFT", Pre, "RIGHT", 5, 0)
			end
			Aura.ID = i
		end
	end
end

function Module:UpdatePlayerActive()
	local index = 1
	while true do
		if not UnitBuff("player", index) then break end
		local name, _, icon, count, _, duration, expires, caster = UnitBuff("player", index)
		if caster == "player" and ((((duration < C["PlayerLimit"] and duration ~= 0) or C["PlayerLimit"] == 0) and not C["BlackList"][name]) or C["WhiteList"][name]) then
			tinsert(PlayerActive, {name, icon, count, duration, expires})
		end
		index = index + 1
	end
end

function Module:UpdatePlayerAura()
	for key, value in pairs(PlayerActive) do
		local name, icon, count, duration, expires = unpack(value)
		if not PlayerAura[key] then PlayerAura[key] = Module:BuildAura("palyer") end
		local Aura = PlayerAura[key]
		local Spellname, Icon, Count, Time, Statusbar, Cooldown = Aura.Spellname, Aura.Icon, Aura.Count, Aura.Time, Aura.Statusbar, Aura.Cooldown
		if Spellname then Spellname:SetText(name) end
		if Icon then Icon:SetTexture(icon) end
		if Count then Count:SetText(count>1 and count or "") end
		if Statusbar then Statusbar:SetMinMaxValues(0, duration) end
		if Cooldown then CooldownFrame_SetTimer(Cooldown, expires-duration, duration, 1) end
		local Timer = 0
		Aura:SetScript("OnUpdate", function(self, elapsed)
			Timer = expires-GetTime()
			if UnitBuff("player", name) then
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
				tremove(PlayerAura, self.ID)
				Module:UpdatePlayerAuraPos()
			end
		end)
		Aura:Show()
	end
end

function Module:ClearTargetAura()
	for _, value in pairs(TargetAura) do
		value:Hide()
		value:ClearAllPoints()
		value:SetScript("OnUpdate", nil)
	end
	wipe(TargetAura)
end

function Module:CleanUpTargetAura()
	wipe(TargetActive)
	for _, value in pairs(TargetAura) do
		value:Hide()
	end
end

function Module:UpdateTargetAuraPos()
	if C["TargetMode"] == "Bar" then
		for i = 1, #TargetAura do
			local oUF_SoraTarget = _G["oUF_SoraTarget"]
			local Aura, Pre = TargetAura[i], TargetAura[i-1]
			Aura:ClearAllPoints()
			if i == 1 then
				Aura:SetPoint("BOTTOM", oUF_SoraTarget, "TOP", 0, 10)
			else
				Aura:SetPoint("BOTTOM", Pre, "TOP", 0, 5)
			end
			Aura.ID = i
		end
	end
	if C["TargetMode"] == "Icon" then
		for i = 1, #TargetAura do
			local oUF_SoraTarget = _G["oUF_SoraTarget"]
			local Aura, Pre, IconPerRow = TargetAura[i], TargetAura[i-1], floor(oUF_SoraTarget:GetWidth()/30)
			local PreRowAura = TargetAura[i-IconPerRow]
			Aura:ClearAllPoints()
			if i == 1 then
				Aura:SetPoint("BOTTOMLEFT", oUF_SoraTarget, "TOPLEFT", 0, 12)
			elseif i%IconPerRow == 1 then
				Aura:SetPoint("BOTTOM", PreRowAura, "TOP", 0, 5)
			else
				Aura:SetPoint("LEFT", Pre, "RIGHT", 5, 0)
			end
			Aura.ID = i
		end
	end
end

function Module:UpdateTargetActive()
	local index = 1
	while true do
		if not UnitDebuff("target", index) then break end
		local name, _, icon, count, _, duration, expires, caster = UnitDebuff("target", index)
		if caster == "player" and ((((duration < C["TargetLimit"] and duration ~= 0) or C["TargetLimit"] == 0) and not C["BlackList"][name]) or C["WhiteList"][name]) then
			tinsert(TargetActive, {name, icon, count, duration, expires})
		end
		index = index + 1
	end
end

function Module:UpdateTargetAura()
	for key, value in pairs(TargetActive) do
		local name, icon, count, duration, expires = unpack(value)
		if not TargetAura[key] then TargetAura[key] = Module:BuildAura("target") end
		local Aura = TargetAura[key]
		local Spellname, Icon, Count, Time, Statusbar, Cooldown = Aura.Spellname, Aura.Icon, Aura.Count, Aura.Time, Aura.Statusbar, Aura.Cooldown
		if Spellname then Spellname:SetText(name) end
		if Icon then Icon:SetTexture(icon) end
		if Count then Count:SetText(count>1 and count or "") end
		if Statusbar then Statusbar:SetMinMaxValues(0, duration) end
		if Cooldown then CooldownFrame_SetTimer(Cooldown, expires-duration, duration, 1) end
		local Timer = 0
		Aura:SetScript("OnUpdate", function(self, elapsed)
			Timer = expires-GetTime()
			if UnitDebuff("target", name) then
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
				tremove(TargetAura, self.ID)
				Module:UpdateTargetAuraPos()
			end
		end)
		Aura:Show()
	end
end

function Module:UpdateAll(event, unit, ...)
	if unit == "player" and C["PlayerMode"] ~= "None" then
		Module:CleanUpPlayerAura()
		Module:UpdatePlayerActive()
		Module:UpdatePlayerAura()
		Module:UpdatePlayerAuraPos()
	elseif unit == "target" and C["TargetMode"] ~= "None" then
		Module:CleanUpTargetAura()
		Module:UpdateTargetActive()
		Module:UpdateTargetAura()
		Module:UpdateTargetAuraPos()
	end
end

function Module:OnInitialize()
	C = ClassTimerDB
	Module:RegisterEvent("UNIT_TARGET", "UpdateAll")
	Module:RegisterEvent("UNIT_AURA", "UpdateAll")
end