----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local Aura = {}
local class = select(2, UnitClass("player")) 
local CLASS_COLORS = RAID_CLASS_COLORS[class]

-- BuildICON
local function BuildICON(iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetPoint("TOPLEFT", 2, -2)
	Frame.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) 
	
	Frame.Icon.Shadow = CreateFrame("Frame", nil, Frame)
	Frame.Icon.Shadow:SetPoint("TOPLEFT", 1, -4)
	Frame.Icon.Shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	Frame.Icon.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 5,
	})
	Frame.Icon.Shadow:SetBackdropBorderColor(0,0,0,1)
	Frame.Icon.Shadow:SetFrameLevel(0)
	
	Frame.Icon.Border = CreateFrame("Frame", nil, Frame)
	Frame.Icon.Border:SetPoint("TOPLEFT", 1, -1)
	Frame.Icon.Border:SetPoint("BOTTOMRIGHT", -1, 1)
	Frame.Icon.Border:SetBackdrop({ 
		edgeFile = cfg.Solid , edgeSize = 1,
	})
	Frame.Icon.Border:SetBackdropBorderColor(0,0,0,1)
	Frame.Icon.Border:SetFrameLevel(0)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	
	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate") 
	Frame.Cooldown:SetPoint("TOPLEFT", 2, -2) 
	Frame.Cooldown:SetPoint("BOTTOMRIGHT", -2, 2) 
	Frame.Cooldown:SetReverse(true)
	
	return Frame
end

-- BuildBAR
local function BuildBAR(iconSize,barWidth)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(barWidth)
	Frame:SetHeight(iconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetWidth(iconSize)
	Frame.Icon:SetHeight(iconSize)
	Frame.Icon:SetPoint("RIGHT", Frame, "LEFT", 0, 0)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame) 
	Frame.Statusbar:SetAllPoints() 
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = CreateFrame("Frame", nil, Frame.Statusbar)
	Frame.Statusbar.Shadow:SetPoint("TOPLEFT", -(3+iconSize), 3)
	Frame.Statusbar.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	Frame.Statusbar.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 3,
	})
	Frame.Statusbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Statusbar.Shadow:SetFrameLevel(0)

	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(cfg.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(1, 1, 1, 0.2) 
	
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 9, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Time:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Time:SetPoint("RIGHT", 0, 0) 

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Spellname:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Spellname:SetPoint("CENTER", -10, 1) 
	
	return Frame
end

-- Init
local function Init()
	for key, _ in pairs(SRAuraList) do
		if key ~= class then
			SRAuraList[key] = nil
		else
			for _, value in pairs(SRAuraList[class]) do
				local tempTable = {}
				for i = 1, #(value.List) do
					local temp = nil
					if value.Mode == "ICON" then
						temp = BuildICON(value.iconSize)
					elseif value.Mode == "BAR" then
						temp = BuildBAR(value.iconSize, value.barWidth)
					end
					temp:Hide()
					table.insert(tempTable,temp)
				end
				table.insert(Aura,tempTable)
			end
		end
	end
end

-- Pos
local function Pos()
	for key,VALUE in pairs(Aura) do
		local value = SRAuraList[class][key]
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
	Timer = self.expires-GetTime() 
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
	for _,VALUE in pairs(Aura) do
		for _,value in pairs(VALUE) do
			value:Hide()
			value:SetScript("OnUpdate",nil)		
		end
	end
	for KEY,VALUE in pairs(Aura) do
		local flag = 1
		for _,value in pairs(SRAuraList[class][KEY].List) do
			local spn = GetSpellInfo(value.spellID)
			local contiue = true
			local name, icon, count, duration, expires, caster, start
			if value.Filter == "BUFF" and UnitBuff(value.unitId, spn) then
				name, _, icon, count, _, duration, expires, caster = UnitBuff(value.unitId, spn)
			elseif value.Filter == "DEBUFF" and UnitDebuff(value.unitId, spn) then
				name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.unitId, spn)
			elseif value.Filter == "CD" and GetSpellCooldown(spn) then
				start, duration = GetSpellCooldown(spn)
				_, _, icon = GetSpellInfo(value.spellID)
				count = 0
			else
				contiue = false
			end
			if value.caster and value.caster ~= caster then
				contiue = false
			end
			if value.Stack and value.Stack > count then
				contiue = false
			end
			if contiue then
				local frame = VALUE[flag]
				if frame.Icon and value.Filter ~= "CD" then
					frame.Icon:SetTexture(icon)
					frame:Show()
				elseif frame.Icon and value.Filter == "CD" and duration > 1.5 then
					frame.Icon:SetTexture(icon)
					frame:Show()
				end
				if frame.Count and count > 1 and value.Filter ~= "CD" then
					frame.Count:SetText(count)
				end
				if frame.Cooldown and value.Filter ~= "CD" then
					CooldownFrame_SetTimer(frame.Cooldown, expires-duration, duration, 1) 
				elseif frame.Cooldown and value.Filter == "CD" and duration > 1.5 then
					frame.Cooldown:SetReverse(false)
					CooldownFrame_SetTimer(frame.Cooldown, start , duration, 1) 
				end
				if frame.Time then
					frame.duration = duration
					frame.expires = expires
					frame:SetScript("OnUpdate",OnUpdate)
				end
				if frame.Spellname then
					frame.Spellname:SetText(name)
				end
				flag = flag + 1
			end
		end
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:RegisterEvent("SPELL_UPDATE_USABLE")
Event:RegisterEvent("SPELL_UPDATE_COOLDOWN")
Event:SetScript("OnEvent",function(self, event, unit, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	elseif event == "PLAYER_ENTERING_WORLD" then
		Pos()
	end
	if event == "SPELL_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_USABLE" then
		Update()
	end
	if not (unit == "player" or unit == "target") then
		return
	end
	Update()
end)

-- Test
local function Test()
	for _,VALUE in pairs(Aura) do
		for _,value in pairs(VALUE) do
		
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
			
			value:Show()		
		end
	end	
end
SlashCmdList.Test = function()
	Test()
end
SLASH_Test1 = "/Test"

