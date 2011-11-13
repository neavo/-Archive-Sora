-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Player")
local Parent = nil

function Module:UpdateWidth(value)
	if Parent then Parent:SetWidth(value) end
	if Parent.Health then Parent.Health:SetWidth(value) end
	if Parent.Power then Parent.Power:SetWidth(value) end
	if MoveHandle.Player then MoveHandle.Player:SetWidth(value) end
end
function Module:UpdateHealthHeight(value)
	if Parent then Parent:SetHeight(value+UnitFrameDB["PlayerPowerHeight"]+4) end
	if Parent.Health then Parent.Health:SetHeight(value) end
	if MoveHandle.Player then MoveHandle.Player:SetHeight(value+UnitFrameDB["PlayerPowerHeight"]+4) end
end
function Module:UpdatePowerHeight(value)
	if Parent then Parent:SetHeight(value+UnitFrameDB["PlayerHealthHeight"]+4) end
	if Parent.Power then Parent.Power:SetHeight(value) end
	if MoveHandle.Player then MoveHandle.Player:SetHeight(value+UnitFrameDB["PlayerHealthHeight"]+4) end
end
function Module:BuildHealthBar(self)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(DB.Statusbar)
	Health:SetPoint("TOP")
	Health.Shadow = S.MakeShadow(Health, 3)
	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetTexture(DB.Statusbar)
	Health.BG:SetAllPoints()
	Health.BG:SetVertexColor(0.1, 0.1, 0.1)
	Health.BG.multiplier = 0.2
	
	Health.frequentUpdates = true
	Health.colorClass = true
	Health.Smooth = true
	
	self.Health = Health
	Module:UpdateWidth(UnitFrameDB["PlayerWidth"])
	Module:UpdateHealthHeight(UnitFrameDB["PlayerHealthHeight"])
end
function Module:BuildPowerBar(self)
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(DB.Statusbar)
	Power:SetPoint("BOTTOM")
	Power.Shadow = S.MakeShadow(Power, 3)
	Power.BG = Power:CreateTexture(nil, "BACKGROUND")
	Power.BG:SetTexture(DB.Statusbar)
	Power.BG:SetAllPoints()
	Power.BG:SetVertexColor(0.1, 0.1, 0.1)
	Power.BG.multiplier = 0.2
	
	Power.frequentUpdates = true
	Power.Smooth = true
	Power.colorPower = true
	
	self.Power = Power
	Module:UpdateWidth(UnitFrameDB["PlayerWidth"])
	Module:UpdatePowerHeight(UnitFrameDB["PlayerPowerHeight"])
end
function Module:UpdateClassPowerBar()
	if Parent.Runes then
		local Runes = Parent.Runes
		for i = 1, 6 do
			Runes[i]:SetSize((Parent:GetWidth()-15)/6, 3)
			if i == 1 then
				Runes[i]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 4)
			else
				Runes[i]:SetPoint("LEFT", Runes[i-1], "RIGHT", 3, 0)
			end
		end
	end
	if Parent.HolyPower then
		local HolyPower = Parent.HolyPower
		for i = 1, 3 do
			HolyPower[i]:SetSize((Parent:GetWidth()-10)/3, 3)
			if i == 1 then
				HolyPower[i]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 4)
			else
				HolyPower[i]:SetPoint("LEFT", HolyPower[i-1], "RIGHT", 5, 0)
			end
		end
	end
	if Parent.SoulShards then
		local SoulShards = Parent.SoulShards
		for i = 1, 3 do
			SoulShards[i]:SetSize((Parent:GetWidth()-10)/3, 3)
			if i == 1 then
				SoulShards[i]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 4)
			else
				SoulShards[i]:SetPoint("LEFT", SoulShards[i-1], "RIGHT", 5, 0)
			end
		end
	end
	if Parent.Totems then
		local Totems = Parent.Totems
		for i = 1, 4 do
			Totems[i]:SetSize((Parent:GetWidth()-15)/4, 3)
			if i == 1 then
				Totems[i]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 4)
			else
				Totems[i]:SetPoint("LEFT", Totems[i-1], "RIGHT", 5, 0)
			end	
		end
	end
	if Parent.CPoints then	
		local CPoints = Parent.CPoints
		for i = 1, 5 do
			CPoints[i]:SetSize((Parent:GetWidth() / 5)-5, 3)
			if i == 1 then
				CPoints[i]:SetPoint("BOTTOMLEFT", Parent, "TOPLEFT", 0, 4)
			else
				CPoints[i]:SetPoint("LEFT", CPoints[i-1], "RIGHT", 6, 0)
			end
		end
	end
	if Parent.EclipseBar then
		local EclipseBar = Parent.EclipseBar
		EclipseBar:SetSize(Parent:GetWidth(), 3)
	end
end
function Module:BuildClassPowerBar(self)
	if DB.MyClass == "DEATHKNIGHT" then
		local Runes = CreateFrame("Frame")
		for i = 1, 6 do
			local Rune = CreateFrame("StatusBar", nil, self)
			Rune:SetStatusBarTexture(DB.Statusbar)					
			Rune.Shadow = S.MakeShadow(Rune, 3)
			Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
			Rune.BG:SetAllPoints()
			Rune.BG:SetTexture(DB.Statusbar)
			Rune.BG:SetVertexColor(0.1, 0.1, 0.1)	
			Runes[i] = Rune
		end
		self.Runes = Runes
	end
	if DB.MyClass == "PALADIN" then
		local HolyPower = CreateFrame("Frame")
		for i = 1, 3 do
			local HolyShard = CreateFrame("StatusBar", nil, self)
			HolyShard:SetStatusBarTexture(DB.Statusbar)
			HolyShard:SetStatusBarColor(0.9, 0.95, 0.33)		
			HolyShard.Shadow = S.MakeShadow(HolyShard, 3)
			HolyPower[i] = HolyShard
		end
		self.HolyPower = HolyPower
		self.HolyPower.Override = function(self, event, unit, powerType)
			if self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")then return end
			for i = 1, MAX_HOLY_POWER do
				if i <= UnitPower(unit, SPELL_POWER_HOLY_POWER) then
					self.HolyPower[i]:SetAlpha(1)
				else
					self.HolyPower[i]:SetAlpha(0.3)
				end
			end
		end
	end
	if DB.MyClass == "WARLOCK" then
		local SoulShards = CreateFrame("Frame")
		for i = 1, 3 do
			local SoulShard = CreateFrame("StatusBar", nil, self)
			SoulShard:SetStatusBarTexture(DB.Statusbar)
			SoulShard:SetStatusBarColor(0.86, 0.44, 1)	
			SoulShard.Shadow = S.MakeShadow(SoulShard, 3)
			SoulShards[i] = SoulShard
		end
		self.SoulShards = SoulShards
		self.SoulShards.Override = function(self, event, unit, powerType)
			if self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS") then return end
			for i = 1, SHARD_BAR_NUM_SHARDS do
				if i <= UnitPower(unit, SPELL_POWER_SOUL_SHARDS) then
					self.SoulShards[i]:SetAlpha(1)
				else
					self.SoulShards[i]:SetAlpha(0.3)
				end
			end
		end
	end
	if DB.MyClass == "DRUID" then
		local EclipseBar = CreateFrame("Frame", nil, self)
		EclipseBar:SetPoint("BOTTOM", self, "TOP", 0, 4)
		EclipseBar.Shadow = S.MakeShadow(EclipseBar, 3)
		EclipseBar.BG = EclipseBar:CreateTexture(nil, "BACKGROUND")
		EclipseBar.BG:SetTexture(DB.Statusbar)
		EclipseBar.BG:SetVertexColor(1, 1, 0.13)
		EclipseBar.BG:SetAllPoints()
		EclipseBar.LunarBar = CreateFrame("StatusBar", nil, EclipseBar)
		EclipseBar.LunarBar:SetStatusBarTexture(DB.Statusbar)
		EclipseBar.LunarBar:SetStatusBarColor(0, 0.1, 0.7)
		EclipseBar.LunarBar:SetAllPoints()
		EclipseBar.Text = S.MakeFontString(EclipseBar, 9)
		EclipseBar.Text:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", -1, 0)
		self:Tag(EclipseBar.Text, "[pereclipse]")
		self.EclipseBar = EclipseBar
	end
	if DB.MyClass == "SHAMAN" then
		local Totems = CreateFrame("Frame", nil, self)
		for i = 1, 4 do
			local Totem = CreateFrame("StatusBar", nil, self)
			Totem:SetStatusBarTexture(DB.Statusbar)
			Totem:SetStatusBarColor(unpack(oUF.colors.totems[i]))
			Totem.BG = Totem:CreateTexture(nil, "BACKGROUND")
			Totem.BG:SetAllPoints()
			Totem.BG:SetTexture(DB.Statusbar)
			Totem.BG:SetVertexColor(0.1, 0.1, 0.1)	
			Totem.Shadow = S.MakeShadow(Totem, 3)
			Totems[i] = Totem
		end
		self.Totems = Totems
		self.Totems.PostUpdate = function(self, slot, haveTotem, name, start, duration)
			local Totem = self[slot]
			Totem:SetMinMaxValues(0, duration)
			Totem:SetScript("OnUpdate", haveTotem and function(self) self:SetValue(GetTotemTimeLeft(slot)) end or nil)
		end
	end
	if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then	
		local CPoints = CreateFrame("Frame", nil, self)	
		for i = 1, MAX_COMBO_POINTS do
			local CPoint = CreateFrame("StatusBar", nil, self)
			CPoint:SetStatusBarTexture(DB.Statusbar)
			CPoint:SetStatusBarColor(1, 0.9, 0)				
			CPoint.Shadow = S.MakeShadow(CPoint, 3)
			CPoints[i] = CPoint
		end
		self.CPoints = CPoints
		self.CPoints.unit = "player"
	end
	Module:UpdateClassPowerBar()
end
function Module:BuildPortrait(self)
	local Portrait = CreateFrame("PlayerModel", nil, self.Health)
	Portrait:SetAlpha(0.3) 
	Portrait.PostUpdate = function(self) 
		if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then self:SetCamera(1) end	
	end
	Portrait:SetAllPoints()
	Portrait:SetFrameLevel(self.Health:GetFrameLevel()+1)
	Portrait:RegisterEvent("PLAYER_REGEN_DISABLED")
	Portrait:RegisterEvent("PLAYER_REGEN_ENABLED")
	Portrait:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(self, 0.5, 0.3, 0)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(self, 0.5, 0, 0.3)
		end
	end)
	
	self.Portrait = Portrait
end
function Module:BuildTags(self)
	local Name = S.MakeFontString(self.Health, 11)
	Name:SetPoint("LEFT", 5, 0)
	self:Tag(Name, "[Sora:color][name]")
	Name:SetAlpha(0)
	local HPTag = S.MakeFontString(self.Health, 11)
	HPTag:SetPoint("RIGHT", 0, 0)
	HPTag:SetAlpha(0)
	local PPTag = S.MakeFontString(self.Power, 9)
	PPTag:SetPoint("RIGHT", 0, 0)
	PPTag:SetAlpha(0)
	
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_REGEN_DISABLED")
	Event:RegisterEvent("PLAYER_REGEN_ENABLED")
	Event:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(Name, 0.5, 0, 1)
			UIFrameFadeIn(HPTag, 0.5, 0, 1)
			UIFrameFadeIn(PPTag, 0.5, 0, 1)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(Name, 0.5, 1, 0)
			UIFrameFadeOut(HPTag, 0.5, 1, 0)
			UIFrameFadeOut(PPTag, 0.5, 1, 0)	
		end
	end)
	self:HookScript("OnEnter", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeIn(self.Portrait, 0.5, 0.3, 0)
			UIFrameFadeIn(Name, 0.5, 0, 1)
			UIFrameFadeIn(HPTag, 0.5, 0, 1)
			UIFrameFadeIn(PPTag, 0.5, 0, 1)
		end
	end)
	self:HookScript("OnLeave", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeOut(self.Portrait, 0.5, 0, 0.3)
			UIFrameFadeOut(Name, 0.5, 1, 0)
			UIFrameFadeOut(HPTag, 0.5, 1, 0)
			UIFrameFadeOut(PPTag, 0.5, 1, 0)
		end
	end)

	self:Tag(HPTag, UnitFrameDB["PlayerTagMode"] == "Short" and "[Sora:color][Sora:hp]" or "[Sora:color][curhp] | [perhp]%")
	self:Tag(PPTag, UnitFrameDB["PlayerTagMode"] == "Short" and "[Sora:pp]" or "[curpp] | [perpp]%")
end
function Module:BuildDebuff(self)
	if UnitFrameDB["PlayerDebuffMode"] == "None" then return end
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs.size = 20
	Debuffs.spacing = 5
	Debuffs.num = floor((self:GetWidth()+Debuffs.spacing)/(Debuffs.size+Debuffs.spacing))*3
	Debuffs:SetSize(self:GetWidth(), Debuffs.size*3+Debuffs.spacing*2)
	Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	Debuffs.initialAnchor = "TOPLEFT"
	Debuffs["growth-x"] = "RIGHT"
	Debuffs["growth-y"] = "DOWN"
	Debuffs.PostCreateIcon = function(self, Button)
		Button.Shadow = S.MakeShadow(Button, 3)	
		Button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.icon:SetAllPoints()	
		Button.count = S.MakeFontString(Button, 9)
		Button.count:SetPoint("TOPRIGHT", 3, 0)
	end
	self.Debuffs = Debuffs
end
function Module:BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end
function Module:BuildCombatIcon(self)
	local Leader = self.Health:CreateTexture(nil, "OVERLAY")
	Leader:SetSize(16, 16)
	Leader:SetPoint("TOPLEFT", self.Health, -7, 9)
	self.Leader = Leader
	local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	Assistant:SetAllPoints(Leader)
	self.Assistant = Assistant
	local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	MasterLooter:SetSize(16, 16)
	MasterLooter:SetPoint("LEFT", Leader, "RIGHT")
	self.MasterLooter = MasterLooter
end

local function BuildPlayer(self, ...)
	Parent = self
	
	-- RegisterForClicks
	self.menu = function(self)
		local unit = self.unit:sub(1, -2)
		local cunit = self.unit:gsub("^%l", string.upper)

		if cunit == "Vehicle" then cunit = "Pet" end

		if unit == "party" or unit == "partypet" then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
		elseif _G[cunit.."FrameDropDown"] then
			ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
		end
	end
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")

	Module:BuildHealthBar(self)
	Module:BuildPowerBar(self)
	Module:BuildClassPowerBar(self)
	Module:BuildPortrait(self)
	Module:BuildTags(self)
	Module:BuildDebuff(self)
	Module:BuildRaidIcon(self)
	Module:BuildCombatIcon(self)
end

function Module:OnInitialize()
	oUF:RegisterStyle("Player", BuildPlayer)
	oUF:SetActiveStyle("Player")
	DB.Player = oUF:Spawn("player", "oUF_SoraPlayer")
	MoveHandle.Player = S.MakeMoveHandle(DB.Player, "玩家框体", "Player")
end
