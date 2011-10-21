-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, _, _, DB = unpack(select(2, ...))

local function BuildMenu(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if cunit == "Vehicle" then
		cunit = "Pet"
	end

	if unit == "party" or unit == "partypet" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local function BuildClickCast(self)
	for KEY, VALUE in pairs(UnitFrameDB.ClickCast) do
		for	key, value in pairs(VALUE) do
			if value.Enable then
				local Button = key == "Left" and "1" or "2"
				if KEY == "Click" then
					self:SetAttribute("type"..Button, "spell")
					self:SetAttribute("spell"..Button, value.Spell)
				else
					self:SetAttribute(KEY:lower().."-type"..Button, "spell")
					self:SetAttribute(KEY:lower().."-spell"..Button, value.Spell)
				end
			end
		end
	end
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetHeight(16)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP", 0, 0)
	Bar.Shadow = S.MakeShadow(Bar, 3)
	Bar.BG = Bar:CreateTexture(nil, "BACKGROUND")
	Bar.BG:SetTexture(DB.Statusbar)
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
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetWidth(self:GetWidth())
	Bar:SetHeight(2)
	Bar:SetPoint("BOTTOM", 0, -1)
	Bar.Shadow = S.MakeShadow(Bar , 3)
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

local function BuildTags(self)
	local Name = S.MakeFontString(self.Health, 9)
	Name:SetPoint("CENTER", 0, 0)
	self:Tag(Name, "[Sora:color][name]")
	local DeadInfo = S.MakeFontString(self.Health, 7)
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

local function BuildReadyCheckIcon(self)
	ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetSize(16, 16)
	ReadyCheck:SetPoint("CENTER", 0, 0)
	self.ReadyCheck = ReadyCheck
end

local function BuildThreatBorder(self)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Shadow:SetBackdropBorderColor(r, g, b, 0.6)
			self.Power.Shadow:SetBackdropBorderColor(r, g, b, 0.6)
		else
			self.Health.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
			self.Power.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Shadow:SetBackdropBorderColor(r, g, b, 0.6)
			self.Power.Shadow:SetBackdropBorderColor(r, g, b, 0.6)
		else
			self.Health.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
			self.Power.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end)
end

local function BuildRaidDebuffs(self)	
	self.RaidDebuffs = CreateFrame("Frame", nil, self)
	self.RaidDebuffs:SetHeight(18)
	self.RaidDebuffs:SetWidth(18)
	self.RaidDebuffs:SetPoint("CENTER")
	self.RaidDebuffs:SetFrameStrata("HIGH")
	self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, "OVERLAY")
	self.RaidDebuffs.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	self.RaidDebuffs.icon:SetAllPoints(self.RaidDebuffs)
	self.RaidDebuffs.time = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.time:SetFont(DB.Font, 12, "THINOUTLINE")
	self.RaidDebuffs.time:SetPoint("CENTER", self.RaidDebuffs, "CENTER", 0, 0)
	self.RaidDebuffs.time:SetTextColor(1, 0.9, 0)
	self.RaidDebuffs.count = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
	self.RaidDebuffs.count:SetFont(DB.Font, 8, "OUTLINE")
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
		Button.count = S.MakeFontString(Button, 12)
		Button.count:SetPoint("CENTER", Button, "BOTTOM", 3, 3)
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
	-- RegisterForClicks
	self.menu = BuildMenu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")
	
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
	
	-- BuildAuraWatch
	BuildAuraWatch(self)
	
	-- BuildRaidDebuffs
	if UnitFrameDB.ShowRaidDebuffs then BuildRaidDebuffs(self) end
	
	-- BuildClickCast
	if UnitFrameDB.EnableClickCast then BuildClickCast(self) end
	
	self.Health.PostUpdate = PostUpdateRaidFrame
end

if UnitFrameDB.ShowParty or UnitFrameDB.ShowRaid then
	-- Hide the Blizzard raid frames
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()		
	CompactRaidFrameContainer:SetParent(UIParent)	
end
if UnitFrameDB.ShowRaid then
	oUF:RegisterStyle("SoraRaid", BuildRaidFrame)
	oUF:SetActiveStyle("SoraRaid")
	if UnitFrameDB.RaidPartyH then
		local RaidFramePos = CreateFrame("Frame", nil, UIParent)
		RaidFramePos:SetSize(UnitFrameDB.RaidUnitWidth*5+5*4, 20*5+6*4)
		MoveHandle.RaidFrame = S.MakeMoveHandle(RaidFramePos, "团队框体", "RaidFrame")	
		DB.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo", 
			"showRaid", UnitFrameDB.ShowRaid,  
			"showPlayer", true, 
			"showSolo", true, 
			"showParty", true, 
			"xoffset", 5, 
			"groupFilter", "1, 2, 3, 4, 5", 
			"groupBy", "GROUP", 
			"groupingOrder", "1, 2, 3, 4, 5", 
			"sortMethod", "INDEX", 
			"maxColumns", 5, 
			"unitsPerColumn", 5, 
			"columnSpacing", 5, 
			"point", "LEFT", 
			"columnAnchorPoint", "TOP", 
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(UnitFrameDB.RaidUnitWidth, 20))
		DB.RaidFrame:SetScale(UnitFrameDB.RaidScale)
		DB.RaidFrame:SetPoint("TOPLEFT", RaidFramePos)
	else
		local RaidFramePos = CreateFrame("Frame", nil, UIParent)
		RaidFramePos:SetSize(UnitFrameDB.RaidUnitWidth*5+5*4, 20*5+6*4)
		MoveHandle.RaidFrame = S.MakeMoveHandle(RaidFramePos, "团队框体", "RaidFrame")
		DB.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo", 
			"showRaid", UnitFrameDB.ShowRaid,  
			"showPlayer", true, 
			"showSolo", false, 
			"showParty", true, 
			"yoffset", -5, 
			"groupFilter", "1,2,3,4,5", 
			"groupBy", "GROUP", 
			"groupingOrder", "1,2,3,4,5", 
			"sortMethod", "INDEX", 
			"maxColumns", 5, 
			"unitsPerColumn", 5, 
			"columnSpacing", 5, 
			"point", "TOP", 
			"columnAnchorPoint", "LEFT", 
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(UnitFrameDB.RaidUnitWidth, 20))
		DB.RaidFrame:SetScale(UnitFrameDB.RaidScale)
		DB.RaidFrame:SetPoint("TOPLEFT", RaidFramePos)
	end
end