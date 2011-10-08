----------------
--  命名空间  --
----------------

local _, SR = ...
local oUF = SR.oUF or oUF
local cfg = SR.cfg
local cast = SR.cast

local function MakeShadow(Frame)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", 5, 0)
	Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex, edgeSize = 5, 
	})
	Shadow:SetBackdropBorderColor(0,0,0,1)
	return Shadow
end

local function MakeTexBorder()
	local Border = CreateFrame("Frame")
	Border:SetFrameLevel(1)
	Border:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0,0,0,1)
	return Border
end

local function MakeBorder(Frame)
	local Border = CreateFrame("Frame", nil, Frame)
	Border:SetFrameLevel(1)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Border:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0,0,0,1)
	return Border
end

local function MakeFontString(parent, fontsize)
	local tempText = parent:CreateFontString(nil, "OVERLAY")
	tempText:SetFont(cfg.Font, fontsize, "THINOUTLINE")
	return tempText
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(cfg.Statusbar)
	Bar:SetHeight(16)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP", 0, 0)
	Bar.Shadow = MakeShadow(Bar)
	Bar.Shadow:SetPoint("TOPLEFT", -5, 5)
	Bar.Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	Bar.Border = MakeBorder(Bar)
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
	Bar.Shadow = MakeShadow(Bar)
	Bar.Shadow:SetPoint("TOPLEFT", -5, 5)
	Bar.Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	Bar.Border = MakeBorder(Bar)
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

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildCombatIcon(self)
	local LeaderIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LeaderIcon:SetSize(16,16)
	LeaderIcon:SetPoint("TOPLEFT", self.Health, -7, 9)
	self.Leader = LeaderIcon

	local MasterLooterIcon = self.Health:CreateTexture(nil, "OVERLAY")
	MasterLooterIcon:SetSize(16,16)
	MasterLooterIcon:SetPoint("LEFT", LeaderIcon, "RIGHT")
	self.MasterLooter = MasterLooterIcon
	
	local AssistantIcon = self.Health:CreateTexture(nil, "OVERLAY")
	AssistantIcon:SetSize(16,16)
	AssistantIcon:SetPoint("LEFT", MasterLooterIcon, "RIGHT")
	self.Assistant = AssistantIcon
end

local function BuildLFDRoleIcon(self)
	LFDRoleIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRoleIcon:SetSize(16,16)
	LFDRoleIcon:SetPoint("BOTTOM", self.Health, "TOP", 15, -7)
	self.LFDRole = LFDRoleIcon
end

local function BuildReadyCheckIcon(self)
	ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetSize(16, 16)
	ReadyCheck:SetPoint("CENTER", 0, 0)
	self.ReadyCheck = ReadyCheck
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

local function BuildRaidDebuffs(self)
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0)

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")
	
	self.RaidDebuffs = CreateFrame("Frame", nil, self)
	self.RaidDebuffs:SetHeight(18)
	self.RaidDebuffs:SetWidth(18)
	self.RaidDebuffs:SetPoint("CENTER", self)
	self.RaidDebuffs:SetFrameStrata("HIGH")

	self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, "OVERLAY")
	self.RaidDebuffs.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	self.RaidDebuffs.icon:SetAllPoints(self.RaidDebuffs)
	
	self.RaidDebuffs.time = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.time:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
	self.RaidDebuffs.time:SetPoint("CENTER", self.RaidDebuffs, "CENTER", 0, 0)
	self.RaidDebuffs.time:SetTextColor(1, 0.9, 0)

	self.RaidDebuffs.count = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.count:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
	self.RaidDebuffs.count:SetPoint("BOTTOMRIGHT", self.RaidDebuffs, "BOTTOMRIGHT", 2, 0)
	self.RaidDebuffs.count:SetTextColor(1, 0.9, 0)
end 

local function BuildAuraWatch(self, ...)
	local _, Class = UnitClass("player")
	local AuraWatch = {}
	local spellIDs = {
		DEATHKNIGHT = {},
		DRUID = {
			33763, -- Lifebloom
			8936, -- Regrowth
			774, -- Rejuvenation
			48438, -- Wild Growth
		},
		HUNTER = {
			34477, -- Misdirection
		},
		MAGE = {
			54646, -- Focus Magic
		},
		PALADIN = {
			53563, -- Beacon of Light
			25771, -- Forbearance
		},
		PRIEST = { 
			17, -- Power Word: Shield
			139, -- Renew
			33076, -- Prayer of Mending
			6788, -- Weakened Soul
		},
		ROGUE = {
			57934, -- Tricks of the Trade
		},
		SHAMAN = {
			974, -- Earth Shield
			61295, -- Riptide
		},
		WARLOCK = {
			20707, -- Soulstone Resurrection
		},
		WARRIOR = {
			50720, -- Vigilance
		},
	}
		
	local function PostCreateIcon(_, Button, ...)
		Button.cd:SetReverse()
		Button.count = MakeFontString(Button, 12)
		Button.count:SetPoint("CENTER", Button, "BOTTOM", 3, 3)
		local Border = MakeBorder(Button)
	end
	AuraWatch.onlyShowPresent = true
	AuraWatch.anyUnit = true
	AuraWatch.PostCreateIcon = PostCreateIcon
	-- Set any other AuraWatch settings
	AuraWatch.icons = {}

	for i, sid in pairs(spellIDs[Class]) do
		local icon = CreateFrame("Frame", nil, self)
		icon.spellID = sid
		-- set the dimensions and positions
		icon:SetWidth(12)
		icon:SetHeight(12)
		icon:SetFrameLevel(5)
		if i == 1 then
			icon:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
		elseif i == 2 then
			icon:SetPoint("TOPRIGHT", self, "TOPRIGHT", 1, 1)
		elseif i == 3 then
			icon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -1, -1)
		elseif i == 4 then
			icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
		end
		
		AuraWatch.icons[sid] = icon
	end
	self.AuraWatch = AuraWatch
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

local function BuildRaidFrame(self, ...)
	
	self.Range = {insideAlpha = 1, outsideAlpha = 0.4}
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildPowerBar
	BuildPowerBar(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)
	
	-- BuildLFDRoleIcon
	BuildLFDRoleIcon(self)
	
	-- BuildReadyCheckIcon
	BuildReadyCheckIcon(self)
	
	-- BuildThreatBorder
	BuildThreatBorder(self)
	
	-- BuildRaidDebuffs
	if cfg.ShowRaidDebuffs then BuildRaidDebuffs(self) end
	
	-- BuildAuraWatch
	if cfg.ShowAuraWatch then BuildAuraWatch(self) end
	
	self.Health.PostUpdate = PostUpdateRaidFrame
end

if cfg.ShowParty or cfg.ShowRaid then
	-- Hide the Blizzard raid frames
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()		
	CompactRaidFrameContainer:SetParent(UIParent)	
end

if cfg.ShowRaid then
	oUF:RegisterStyle("SoraRaid", BuildRaidFrame)
	oUF:SetActiveStyle("SoraRaid")
	if cfg.RaidPartyH then
		SR.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo",
			"showRaid", cfg.ShowRaid,  
			"showPlayer", true,
			"showSolo", true,
			"showParty", true,
			"xoffset", 7,
			"groupFilter", "1,2,3,4,5",
			"groupBy", "GROUP",
			"groupingOrder", "1,2,3,4,5",
			"sortMethod", "INDEX",
			"maxColumns", 5,
			"unitsPerColumn", 5,
			"columnSpacing", 7,
			"point", "LEFT",
			"columnAnchorPoint", "TOP",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(cfg.RaidUnitWidth, 20))
		SR.RaidFrame:SetScale(cfg.raidScale)
		SR.RaidFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -370, 135)		
	else
		SR.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo",
			"showRaid", cfg.ShowRaid,  
			"showPlayer", true,
			"showSolo", false,
			"showParty", true,
			"yoffset", -7,
			"groupFilter", "1,2,3,4,5",
			"groupBy", "GROUP",
			"groupingOrder", "1,2,3,4,5",
			"sortMethod", "INDEX",
			"maxColumns", 5,
			"unitsPerColumn", 5,
			"columnSpacing", 7,
			"point", "TOP",
			"columnAnchorPoint", "LEFT",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(cfg.RaidUnitWidth, 20))
		SR.RaidFrame:SetScale(cfg.raidScale)
		SR.RaidFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMRIGHT", -370, 135)
	end
end