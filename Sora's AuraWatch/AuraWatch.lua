----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig

local AuraList, Aura, UnitIDTable, MaxFrame = {}, {}, {}, 12
local MyClass = select(2, UnitClass("player")) 
local BuildICON = cfg.BuildICON
local BuildBAR = cfg.BuildBAR
if not sRawDB then sRawDB = {} end

-- Init
local function BuildAuraList()
	AuraList = SRAuraList["ALL"] and SRAuraList["ALL"] or {}
	for key, _ in pairs(SRAuraList) do
		if key == MyClass then
			for _, value in pairs(SRAuraList[MyClass]) do
				tinsert(AuraList, value)
			end
		end
	end
	wipe(SRAuraList)
end
local function BuildUnitIDTable()
	for _, VALUE in pairs(AuraList) do
		for _, value in pairs(VALUE.List) do
			local Flag = true
			for _,v in pairs(UnitIDTable) do
				if value.UnitID == v then Flag = false end
			end
			if Flag then tinsert(UnitIDTable, value.UnitID) end
		end
	end
end
local function MakeMoveHandle(Frame, Text, key, Pos)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetWidth(Frame:GetWidth())
	MoveHandle:SetHeight(Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = cfg.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = MoveHandle:CreateFontString(nil, "OVERLAY")
	MoveHandle.Text:SetFont(cfg.Font, 10, "THINOUTLINE")
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	if not sRawDB[key] then 
		MoveHandle:SetPoint(unpack(Pos))
	else
		MoveHandle:SetPoint(unpack(sRawDB[key]))		
	end
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		sRawDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end
local function BuildAura()
	for key, value in pairs(AuraList) do
		local FrameTable = {}
		for i = 1, MaxFrame do
			if value.Mode:lower() == "icon" then
				local Frame = BuildICON(value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			elseif value.Mode:lower() == "bar" then
				local Frame = BuildBAR(value.BarWidth, value.IconSize)
				if i == 1 then Frame.MoveHandle = MakeMoveHandle(Frame, value.Name, key, value.Pos) end
				tinsert(FrameTable, Frame)
			end
		end
		FrameTable.Index = 1
		tinsert(Aura, FrameTable)
	end
end
local function Pos()
	for key, VALUE in pairs(Aura) do
		local value = AuraList[key]
		local Pre = nil
		for i = 1, #VALUE do
			local Frame = VALUE[i]
			if i == 1 then
				Frame:SetPoint("CENTER", Frame.MoveHandle)
			elseif value.Direction:lower() == "right" then
				Frame:SetPoint("LEFT", Pre, "RIGHT", value.Interval, 0)
			elseif value.Direction:lower() == "left" then
				Frame:SetPoint("RIGHT", Pre, "LEFT", -value.Interval, 0)
			elseif value.Direction:lower() == "up" then
				Frame:SetPoint("BOTTOM", Pre, "TOP", 0, value.Interval)
			elseif value.Direction:lower() == "down" then
				Frame:SetPoint("TOP", Pre, "BOTTOM", 0, -value.Interval)
			end
			Pre = Frame
		end
	end
end
local function Init()
	BuildAuraList()
	BuildUnitIDTable()
	BuildAura()
	Pos()
end

-- SetTime
local function SetTime(self, Timer, duration)
	if Timer < 0 then
		if self.Time then self.Time:SetText("N/A") end
		self.Statusbar:SetMinMaxValues(0, 1) 
		self.Statusbar:SetValue(0)
	elseif Timer < 60 then
		if self.Time then self.Time:SetFormattedText("%.1f", Timer) end
		self.Statusbar:SetMinMaxValues(0, duration) 
		self.Statusbar:SetValue(Timer)
	else
		if self.Time then self.Time:SetFormattedText("%d:%.2d", Timer/60, Timer%60) end
		self.Statusbar:SetMinMaxValues(0, duration) 
		self.Statusbar:SetValue(Timer)
	end
end

-- UpdateCD
local function UpdateCDFrame(index, name, icon, start, duration)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(false)
		Frame.Cooldown:SetCooldown(start, duration)
	end
	if Frame.Count then Frame.Count:SetText(nil) end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		local Timer = 0
		Frame:SetScript("OnUpdate", function(self, elapsed)
			Timer = start+duration-GetTime()
			SetTime(self, Timer, duration)
		end)
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function UpdateCD()
	for KEY, VALUE in pairs(AuraList) do
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
local function UpdateAuraFrame(index, UnitID, name, icon, count, duration, expires)
	local Frame = Aura[index][Aura[index].Index]
	if Frame then Frame:Show() end
	if Frame.Icon then Frame.Icon:SetTexture(icon) end
	if Frame.Count then Frame.Count:SetText(count > 1 and count or nil) end
	if Frame.Cooldown then
		Frame.Cooldown:SetReverse(true)
		Frame.Cooldown:SetCooldown(expires-duration, duration)
	end
	if Frame.Spellname then Frame.Spellname:SetText(name) end
	if Frame.Statusbar then
		local Timer = 0
		Frame:SetScript("OnUpdate", function(self, elapsed)
			Timer = expires-GetTime()
			SetTime(self, Timer, duration)
		end)
	end
	
	Aura[index].Index = (Aura[index].Index + 1 > MaxFrame) and MaxFrame or Aura[index].Index + 1
end
local function AuraFilter(spellID, UnitID, index, bool)
	for KEY, VALUE in pairs(AuraList) do
		for key, value in pairs(VALUE.List) do
			if value.AuraID == spellID and value.UnitID == UnitID then
				if bool then
					local name, _, icon, count, _, duration, expires, caster = UnitBuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires
				else
					local name, _, icon, count, _, duration, expires, caster = UnitDebuff(value.UnitID, index)
					if value.Caster and value.Caster:lower() ~= caster then return false end
					if value.Stack and count and value.Stack > count then return false end
					return KEY, value.UnitID, name, icon, count, duration, expires
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

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("onEvent", function(self, event, unitID, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Init()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate", function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 0.5 then
		self.Timer = 0
		CleanUp()
		UpdateCD()
		for _, value in pairs(UnitIDTable) do
			UpdateAura(value)
		end
	end	
end)

-- Test
local TestFlag = true
SlashCmdList.SRAuraWatch = function(msg)
	if msg:lower() == "test" then
		if TestFlag then
			TestFlag = false
			Event:SetScript("OnUpdate", nil)
			for _, value in pairs(Aura) do
				for i = 1, MaxFrame do
					if value[i] then
						value[i]:SetScript("OnUpdate", nil)
						value[i]:Show()	
					end		
					if value[i].Icon then value[i].Icon:SetTexture(select(3, GetSpellInfo(118))) end
					if value[i].Count then value[i].Count:SetText("9") end
					if value[i].Time then value[i].Time:SetText("59.59") end
					if value[i].Statusbar then value[i].Statusbar:SetValue(1) end
					if value[i].Spellname then value[i].Spellname:SetText("变形术") end				
				end
				value[1].MoveHandle:Show()
			end
		else
			TestFlag = true
			CleanUp()
			for _, value in pairs(Aura) do
				value[1].MoveHandle:Hide()
			end
			Event:SetScript("OnUpdate", function(self, elapsed)
				self.Timer = self.Timer + elapsed
				if self.Timer > 0.5 then
					self.Timer = 0
					CleanUp()
					UpdateCD()
					for _, value in pairs(UnitIDTable) do
						UpdateAura(value)
					end
				end	
			end)
		end
	elseif msg:lower() == "reset" then
		wipe(sRawDB)
		ReloadUI()
	else
		print("/sRaw Test -- 测试模式")
		print("/sRaw Reset -- 恢复默认设置")
	end
end
SLASH_SRAuraWatch1 = "/sRaw"

