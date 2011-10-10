﻿----------------
--  命名空间  --
----------------

local _, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg

local function MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex, edgeSize = Size, 
	})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

local function MakeFontString(Parent, fontsize)
	local tempText = Parent:CreateFontString(nil, "OVERLAY")
	tempText:SetFont(cfg.Font, fontsize, "THINOUTLINE")
	return tempText
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(cfg.Statusbar)
	Bar:SetHeight(16)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP", 0, 0)
	Bar.Shadow = MakeShadow(Bar, 3)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(cfg.Statusbar)
	Bar.BG:SetAllPoints()
	Bar.BG:SetVertexColor(0.1, 0.1, 0.1)
	Bar.BG.multiplier = 0.2
	
	Bar.frequentUpdates = true
	Bar.colorSmooth = true
	Bar.colorClass = true
	Bar.colorReaction = true
	Bar.Smooth = true
	Bar.colorTapping = true
		
	self.Health = Bar
end

local function BuildPowerBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(cfg.Statusbar)
	Bar:SetWidth(self:GetWidth())
	Bar:SetHeight(2)
	Bar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	Bar.Shadow = MakeShadow(Bar , 3)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(cfg.Statusbar)
	Bar.BG:SetAllPoints()
	Bar.BG:SetVertexColor(0.1, 0.1, 0.1)
	Bar.BG.multiplier = 0.2
	
	Bar.frequentUpdates = true
	Bar.Smooth = true
	Bar.colorPower = true
		
	self.Power = Bar
end

local function BuildTags(self)
	local Name = MakeFontString(self.Health, 9)
	Name:SetPoint("CENTER", 0, 0)
	self:Tag(Name, "[Sora:color][name]")
	local DeadInfo = MakeFontString(self.Health, 7)
	DeadInfo:SetPoint("CENTER", 0, -10)
	self:Tag(DeadInfo, "[Sora:info]")
end

local function PostCreateIcon(self, Button)
	Button.Shadow = MakeShadow(Button, 3)	
	Button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Button.icon:SetAllPoints()	
	Button.count = MakeFontString(Button, 9)
	Button.count:SetPoint("TOPRIGHT", Button, 3, 0)
end
  
local function PostUpdateIcon(self, unit, Button, index, offset, filter, isDebuff)
	local Caster = select(8, UnitAura(unit, index, Button.filter))
	if Button.debuff then
		if Caster == "player" or Caster == "vehicle" then
			Button.icon:SetDesaturated(false)                 
		elseif not UnitPlayerControlled(unit) then -- If Unit is Player Controlled dont desaturate debuffs
			Button:SetBackdropColor(0, 0, 0)
			Button.overlay:SetVertexColor(0.3, 0.3, 0.3)      
			Button.icon:SetDesaturated(true)  
		end
	end
end

local function BuildDebuff(self)
	Debuff = CreateFrame("Frame", nil, self)
	Debuff.size = 20
	Debuff.num = 40
	Debuff.spacing = 5
	Debuff:SetHeight((Debuff.size+Debuff.spacing)*5)
	Debuff:SetWidth(self:GetWidth())
	Debuff:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	Debuff.initialAnchor = "TOPLEFT"
	Debuff["growth-x"] = "RIGHT"
	Debuff["growth-y"] = "DOWN"
	Debuff.PostCreateIcon = PostCreateIcon
	Debuff.PostUpdateIcon = PostUpdateIcon

	self.Debuffs = Debuff
end

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildCombatIcon(self)
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

local function BuildLFDRoleIcon(self)
	LFDRoleIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRoleIcon:SetSize(16, 16)
	LFDRoleIcon:SetPoint("TOPRIGHT", self.Health, 7, 9)
	self.LFDRole = LFDRoleIcon
end

local function BuildThreatBorder(self)
	self.ThreatBorder = CreateFrame("Frame", nil, self)
	self.ThreatBorder:SetPoint("TOPLEFT", self, -5, 5)
	self.ThreatBorder:SetPoint("BOTTOMRIGHT", self, 5, -5)
	self.ThreatBorder:SetBackdrop({edgeFile = cfg.GlowTex, edgeSize = 3})
	self.ThreatBorder:SetFrameLevel(1)
	self.ThreatBorder:Hide()
	
	local function UpdateThreat(self, event, unit)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
				self.ThreatBorder:Show()
				self.ThreatBorder:SetBackdropBorderColor(r, g, b, 1)
		else
			self.ThreatBorder:SetBackdropBorderColor(r, g, b, 0)
			self.ThreatBorder:Hide()
		end
	end
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
end

local function PostUpdateRaidFrame(Health, unit, min, max)
	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	if disconnnected or dead or ghost then
		Health:SetValue(max)	
		if disconnnectedthen then
			Health:SetStatusBarColor(0, 0, 0, 0.7)
		elseif ghost then
			Health:SetStatusBarColor(0, 0, 0, 0.7)
		elseif dead then
			Health:SetStatusBarColor(0, 0, 0, 0.7)
		end
	else
		Health:SetValue(min)
		if unit == "vehicle" then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
end

local function BuildPartyFrame(self, ...)
	
	self.Range = {insideAlpha = 1, outsideAlpha = 0.4}
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildPowerBar
	BuildPowerBar(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildDebuff
	if UnitFrameDB.ShowPartyDebuff then BuildDebuff(self) end
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)
	
	-- BuildLFDRoleIcon
	BuildLFDRoleIcon(self)
	
	-- BuildThreatBorder
	BuildThreatBorder(self)
	
	self.Health.PostUpdate = PostUpdateRaidFrame
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(slef, event, addon, ...)
	if UnitFrameDB.ShowParty then
		oUF:RegisterStyle("SoraParty", BuildPartyFrame)
		oUF:SetActiveStyle("SoraParty")
		ns.PartyFrame = oUF:SpawnHeader("oUF_Party", nil, "raid,party,solo", 
		"showParty", true, 
		"yoffset", -30, 
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(180, 22))
		ns.PartyFrame:SetScale(UnitFrameDB.RaidScale)
		ns.PartyFrame:SetPoint("TOPLEFT", UIParent, 10, -250)
	end
end)