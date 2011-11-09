﻿-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("PlayerFrame")

local function BuildMenu(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if cunit == "Vehicle" then cunit = "Pet" end

	if unit == "party" or unit == "partypet" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetHeight(UnitFrameDB.PlayerHeight-2-4)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP")
	Bar.Shadow = S.MakeShadow(Bar, 3)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(DB.Statusbar)
	Bar.BG:SetAllPoints()
	Bar.BG:SetVertexColor(0.1, 0.1, 0.1)
	Bar.BG.multiplier = 0.2
	
	Bar.frequentUpdates = true
	Bar.colorSmooth = true
	Bar.colorClass = true
	Bar.Smooth = true
		
	self.Health = Bar
end

local function BuildPowerBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetWidth(self:GetWidth())
	Bar:SetHeight(2)
	Bar:SetPoint("BOTTOM")
	Bar.Shadow = S.MakeShadow(Bar, 3)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(DB.Statusbar)
	Bar.BG:SetAllPoints()
	Bar.BG:SetVertexColor(0.1, 0.1, 0.1)
	Bar.BG.multiplier = 0.2
	
	Bar.frequentUpdates = true
	Bar.Smooth = true
	Bar.colorPower = true
		
	self.Power = Bar
end

local function Override(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and (powerType ~= "HOLY_POWER" and powerType ~= "SOUL_SHARDS")) then return end
	if self.HolyPower then
		local HolyPower = self.HolyPower
		for i = 1, MAX_HOLY_POWER do
			if i <= UnitPower(unit, SPELL_POWER_HOLY_POWER) then
				HolyPower[i]:SetAlpha(1)
			else
				HolyPower[i]:SetAlpha(0.3)
			end
		end
	end
	if self.SoulShards then
		local SoulShards = self.SoulShards
		for i = 1, SHARD_BAR_NUM_SHARDS do
			if i <= UnitPower(unit, SPELL_POWER_SOUL_SHARDS) then
				SoulShards[i]:SetAlpha(1)
			else
				SoulShards[i]:SetAlpha(0.3)
			end
		end
	end
end
local function BuildClassPowerBar(self)
	if DB.MyClass == "DEATHKNIGHT" then
		local Runes = CreateFrame("Frame")
		for i = 1, 6 do
			local Rune = CreateFrame("StatusBar", nil, self)
			Rune:SetSize((self:GetWidth()-15)/6, 3)
			Rune:SetStatusBarTexture(DB.Statusbar)					
			Rune.Shadow = S.MakeShadow(Rune, 3)
			Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
			Rune.BG:SetAllPoints()
			Rune.BG:SetTexture(DB.Statusbar)
			Rune.BG:SetVertexColor(0.1, 0.1, 0.1)	
			if i == 1 then
				Rune:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
			else
				Rune:SetPoint("LEFT", Runes[i-1], "RIGHT", 3, 0)
			end
			Runes[i] = Rune
		end
		self.Runes = Runes
	end
	if DB.MyClass == "PALADIN" then
		local HolyPower = CreateFrame("Frame")
		for i = 1, 3 do
			local HolyShard = CreateFrame("StatusBar", nil, self)
			HolyShard:SetSize((self:GetWidth()-10)/3, 3)
			HolyShard:SetStatusBarTexture(DB.Statusbar)
			HolyShard:SetStatusBarColor(0.9, 0.95, 0.33)		
			HolyShard.Shadow = S.MakeShadow(HolyShard, 3)
			if i == 1 then
				HolyShard:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				HolyShard:SetPoint("TOPLEFT", HolyPower[i-1], "TOPRIGHT", 5, 0)
			end
			HolyPower[i] = HolyShard
		end
		self.HolyPower = HolyPower
		self.HolyPower.Override = Override
	end
	if DB.MyClass == "WARLOCK" then
		local SoulShards = CreateFrame("Frame")
		for i= 1, 3 do
			local SoulShard = CreateFrame("StatusBar", nil, self)
			SoulShard:SetSize((self:GetWidth()-10)/3, 3)
			SoulShard:SetStatusBarTexture(DB.Statusbar)
			SoulShard:SetStatusBarColor(0.86, 0.44, 1)	
			SoulShard.Shadow = S.MakeShadow(SoulShard, 3)
			if i == 1 then
				SoulShard:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				SoulShard:SetPoint("TOPLEFT", SoulShards[i-1], "TOPRIGHT", 5, 0)
			end
			SoulShards[i] = SoulShard
		end
		self.SoulShards = Override
		self.SoulShards.Override = SoulShards_Override
	end
	if DB.MyClass == "DRUID" then
		local EclipseBar = CreateFrame("Frame", nil, self)
		EclipseBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
		EclipseBar:SetHeight(3)
		EclipseBar:SetWidth(self:GetWidth())
		EclipseBar.Shadow = S.MakeShadow(EclipseBar, 3)
		EclipseBar.LunarBar = CreateFrame("StatusBar", nil, EclipseBar)
		EclipseBar.LunarBar:SetPoint("LEFT", 0, 0)
		EclipseBar.LunarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
		EclipseBar.LunarBar:SetStatusBarTexture(DB.Statusbar)
		EclipseBar.LunarBar:SetStatusBarColor(0, 0.1, 0.7)
		EclipseBar.SolarBar = CreateFrame("StatusBar", nil, EclipseBar)
		EclipseBar.SolarBar:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
		EclipseBar.SolarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
		EclipseBar.SolarBar:SetStatusBarTexture(DB.Statusbar)
		EclipseBar.SolarBar:SetStatusBarColor(1, 1, 0.13)
		EclipseBar.Text = S.MakeFontString(EclipseBar.SolarBar, 9)
		EclipseBar.Text:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", -1, 0)
		self:Tag(EclipseBar.Text, "[pereclipse]")
		self.EclipseBar = EclipseBar
	end
	if DB.MyClass == "SHAMAN" then
		local Totems = CreateFrame("Frame", nil, self)
		for i = 1, 4 do
			local Totem = CreateFrame("StatusBar", nil, self)
			Totem:SetSize((self:GetWidth()-15)/4, 3)
			Totem:SetStatusBarTexture(DB.Statusbar)
			Totem:SetStatusBarColor(unpack(oUF.colors.totems[i]))
			Totem.BG = Totem:CreateTexture(nil, "BACKGROUND")
			Totem.BG:SetAllPoints()
			Totem.BG:SetTexture(DB.Statusbar)
			Totem.BG:SetVertexColor(0.1, 0.1, 0.1)	
			Totem.Shadow = S.MakeShadow(Totem, 3)
			if i == 1 then
				Totem:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
			else
				Totem:SetPoint("LEFT", Totems[i-1], "RIGHT", 5, 0)
			end	
			Totems[i] = Totem
		end
		self.Totems = Totems
		
		local function Totems_PostUpdate(self, slot, haveTotem, name, start, duration)
			local Totem = Totems[slot]
			Totem:SetMinMaxValues(0, duration)
			if haveTotem then
				Totem:SetScript("OnUpdate", function(self) Totem:SetValue(GetTotemTimeLeft(slot)) end)
			else
				Totem:SetScript("OnUpdate", nil)
			end
		end
		self.Totems.PostUpdate = Totems_PostUpdate
	end
	if DB.MyClass == "ROGUE" or DB.MyClass == "DRUID" then	
		local CPoints = CreateFrame("Frame", nil, self)	
		for i = 1, MAX_COMBO_POINTS do
			local CPoint = CreateFrame("StatusBar", nil, self)
			CPoint:SetSize((self:GetWidth() / 5)-5, 3)
			CPoint:SetStatusBarTexture(DB.Statusbar)
			CPoint:SetStatusBarColor(1, 0.9, 0)				
			CPoint.Shadow = S.MakeShadow(CPoint, 3)
			if i == 1 then
				CPoint:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				CPoint:SetPoint("TOPLEFT", CPoints[i-1], "TOPRIGHT", 6, 0)
			end
			CPoints[i] = CPoint
		end
		self.CPoints = CPoints
		self.CPoints.unit = "player"
	end
end

local function BuildPortrait(self)
	local Portrait = CreateFrame("PlayerModel", nil, self.Health)
	Portrait:SetAlpha(0.3) 
	Portrait.PostUpdate = function(self) 
		if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
			self:SetCamera(1)
		end	
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

local function BuildTags(self)
	local Name = S.MakeFontString(self.Health, 11)
	Name:SetPoint("LEFT", 5, 0)
	self:Tag(Name, "[Sora:color][name]")
	Name:SetAlpha(0)
	local HPTag = S.MakeFontString(self.Health, 11)
	HPTag:SetPoint("RIGHT", 0, 0)
	if UnitFrameDB.PlayerTagMode == "Short" then
		self:Tag(HPTag, "[Sora:color][Sora:hp]")
	else
		self:Tag(HPTag, "[Sora:color][curhp] | [perhp]%")		
	end
	HPTag:SetAlpha(0)
	local PPTag = S.MakeFontString(self.Power, 9)
	PPTag:SetPoint("RIGHT", 0, 0)
	if UnitFrameDB.PlayerTagMode == "Short" then
		self:Tag(PPTag, "[Sora:pp]")
	else
		self:Tag(PPTag, "[curpp] | [perpp]%")
	end
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
end

local function BuildCastbar(self)
	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(DB.Statusbar)
	Castbar:SetStatusBarColor(95/255, 182/255, 255/255, 1)
	if UnitFrameDB.PlayerCastbarMode == "Large" then
		Castbar:SetHeight(20)
		Castbar:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 2, 35)
		Castbar:SetPoint("BOTTOMRIGHT", DB.ActionBar, "TOPRIGHT", -30, 35)			
	elseif UnitFrameDB.PlayerCastbarMode == "Small" then
		Castbar:SetHeight(10)
		Castbar:SetWidth(self:GetWidth()-70)
		Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -14)
	end
	
	Castbar.Shadow = S.MakeShadow(Castbar, 3)
	Castbar.Shadow:SetBackdrop({
		bgFile = DB.Statusbar,insets = {left = 3, right = 3, top = 3, bottom = 3}, 
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	Castbar.Shadow:SetBackdropColor(0, 0, 0, 0.5)
	Castbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	
	Castbar.CastingColor = {95/255, 182/255, 255/255}
	Castbar.CompleteColor = {20/255, 208/255, 0/255}
	Castbar.FailColor = {255/255, 12/255, 0/255}
	Castbar.ChannelingColor = {95/255, 182/255, 255/255}

	Castbar.Text = S.MakeFontString(Castbar, 10)
	Castbar.Text:SetPoint("LEFT", 2, 0)
	
	Castbar.Time = S.MakeFontString(Castbar, 10)
	Castbar.Time:SetPoint("RIGHT", -2, 0)
	
	Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
	Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Castbar.Icon:SetSize(20, 20)
	Castbar.Icon:SetPoint("BOTTOMLEFT", Castbar, "BOTTOMRIGHT", 8, 0)
	Castbar.Icon.Shadow = S.MakeTexShadow(Castbar, Castbar.Icon, 3)

	--latency (only for player unit)
	Castbar.SafeZone = Castbar:CreateTexture(nil, "OVERLAY")
	Castbar.SafeZone:SetTexture(DB.Statusbar)
	Castbar.SafeZone:SetVertexColor(1, 0.1, 0, .6)
	Castbar.SafeZone:SetPoint("TOPRIGHT")
	Castbar.SafeZone:SetPoint("BOTTOMRIGHT")
	Castbar.Lag = S.MakeFontString(Castbar, 10)
	Castbar.Lag:SetPoint("CENTER", -2, 17)
	Castbar.Lag:Hide()
	self:RegisterEvent("UNIT_SPELLCAST_SENT", S.OnCastSent)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed

	self.Castbar = Castbar
end

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildCombatIcon(self)
	local Resting = self.Health:CreateTexture(nil, "OVERLAY")
	Resting:SetSize(24, 24)
	Resting:SetPoint("RIGHT", self.Health, "LEFT", -3, 0)
	self.Resting = Resting
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

local function BuildPlayerFrame(self, ...)
	-- RegisterForClicks
	self.menu = BuildMenu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")
	
	-- Set Size and Scale
	self:SetSize(UnitFrameDB.PlayerWidth, UnitFrameDB.PlayerHeight)
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildPowerBar
	BuildPowerBar(self)
	
	-- BuildClassPowerBar
	BuildClassPowerBar(self)
	
	-- BuildPortrait
	BuildPortrait(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildCastbar
	if UnitFrameDB.PlayerCastbarMode ~= "None" then BuildCastbar(self) end
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)

end

function Module:OnInitialize()
	if not UnitFrameDB.ShowPlayerFrame then return end
	oUF:RegisterStyle("SoraPlayer", BuildPlayerFrame)
	oUF:SetActiveStyle("SoraPlayer")
	DB.PlayerFrame = oUF:Spawn("player")
	MoveHandle.PlayerFrame = S.MakeMoveHandle(DB.PlayerFrame, "玩家框体", "PlayerFrame")
end
