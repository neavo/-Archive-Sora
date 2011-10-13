-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, _, _, DB = unpack(select(2, ...))

local function MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

local function MakeFontString(Parent, fontsize)
	local tempText = Parent:CreateFontString(nil, "ARTWORK")
	tempText:SetFont(DB.Font, fontsize, "THINOUTLINE")
	return tempText
end

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

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetHeight(16)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP", 0, 0)
	Bar.Shadow = MakeShadow(Bar, 3)
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
	Bar.Shadow = MakeShadow(Bar , 3)
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

--[[local function BuildIndicator(self)
	local _, Class = UnitClass("player")
	self.IndicatorTL = self.Health:CreateFontString(nil, "OVERLAY")
	self.IndicatorTL:ClearAllPoints()
	self.IndicatorTL:SetPoint("TOPLEFT")
	self.IndicatorTL:SetFont(DB.Indicator, 8, "THINOUTLINE")
	self:Tag(self.IndicatorTL, ns.classIndicators[Class]["TL"])

	self.IndicatorTR = self.Health:CreateFontString(nil, "OVERLAY")
	self.IndicatorTR:ClearAllPoints()
	self.IndicatorTR:SetPoint("TOPRIGHT")
	self.IndicatorTR:SetFont(DB.Indicator, 8, "THINOUTLINE")
	self:Tag(self.IndicatorTR, ns.classIndicators[Class]["TR"])

	self.IndicatorBL = self.Health:CreateFontString(nil, "OVERLAY")
	self.IndicatorBL:ClearAllPoints()
	self.IndicatorBL:SetPoint("BOTTOMLEFT")
	self.IndicatorBL:SetFont(DB.Indicator, 8, "THINOUTLINE")
	self:Tag(self.IndicatorBL, ns.classIndicators[Class]["BL"])	

	self.IndicatorBR = self.Health:CreateFontString(nil, "OVERLAY")
	self.IndicatorBR:ClearAllPoints()
	self.IndicatorBR:SetPoint("BOTTOMRIGHT")
	self.IndicatorBR:SetFont(DB.Symbol, 8, "THINOUTLINE")
	self:Tag(self.IndicatorBR, ns.classIndicators[Class]["BR"])
end]]

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
	
	-- BuildRaidDebuffs
	if UnitFrameDB.ShowRaidDebuffs then BuildRaidDebuffs(self) end
	
	-- BuildAuraWatch
	--if UnitFrameDB.ShowAuraWatch then BuildIndicator(self) end
	
	self.Health.PostUpdate = PostUpdateRaidFrame
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(slef, event, addon, ...)
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
			ns.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo", 
				"showRaid", UnitFrameDB.ShowRaid,  
				"showPlayer", true, 
				"showSolo", true, 
				"showParty", true, 
				"xoffset", 7, 
				"groupFilter", "1, 2, 3, 4, 5", 
				"groupBy", "GROUP", 
				"groupingOrder", "1, 2, 3, 4, 5", 
				"sortMethod", "INDEX", 
				"maxColumns", 5, 
				"unitsPerColumn", 5, 
				"columnSpacing", 7, 
				"point", "LEFT", 
				"columnAnchorPoint", "TOP", 
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				]]):format(UnitFrameDB.RaidUnitWidth, 20))
			ns.RaidFrame:SetScale(UnitFrameDB.RaidScale)
			ns.RaidFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", -370, 135)		
		else
			ns.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo", 
				"showRaid", UnitFrameDB.ShowRaid,  
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
				]]):format(UnitFrameDB.RaidUnitWidth, 20))
			ns.RaidFrame:SetScale(UnitFrameDB.RaidScale)
			ns.RaidFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMRIGHT", -370, 135)
		end
	end
end)