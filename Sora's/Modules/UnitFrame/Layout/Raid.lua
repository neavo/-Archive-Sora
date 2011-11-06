-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("RaidFrame")

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
	Bar:SetHeight(UnitFrameDB.RaidUnitHeight-2-1)
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
	Bar:SetPoint("BOTTOM")
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
	local LFDRoleIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRoleIcon:SetSize(16, 16)
	LFDRoleIcon:SetPoint("TOPRIGHT", self.Health, 7, 9)
	self.LFDRole = LFDRoleIcon
end

local function BuildReadyCheckIcon(self)
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
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
	local RaidDebuff = CreateFrame("Frame", nil, self)
	RaidDebuff:SetSize(18, 18)
	RaidDebuff:SetPoint("CENTER")
	RaidDebuff:SetFrameStrata("HIGH")
	RaidDebuff.Icon = RaidDebuff:CreateTexture(nil, "ARTWORK")
	RaidDebuff.Icon:SetAllPoints()
	RaidDebuff.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	RaidDebuff.Count = S.MakeFontString(RaidDebuff, 8)
	RaidDebuff.Count:SetPoint("BOTTOMRIGHT", 1, -1)
	RaidDebuff.Cooldown = CreateFrame("Cooldown", nil, RaidDebuff) 
	RaidDebuff.Cooldown:SetAllPoints() 
	RaidDebuff.Cooldown:SetReverse(true)
	self.RaidDebuff = RaidDebuff
end

local function BuildIndicator(self)
	local Indicator = {}
	for i = 1, 4 do
		local Button = CreateFrame("Frame", nil, self.Health)
		Button:SetSize(6, 6)
		Button:SetFrameStrata("HIGH")
		Button:SetBackdrop({
			bgFile = DB.Solid, insets = {left = 1, right = 1, top = 1, bottom = 1},
			edgeFile = DB.Solid, edgeSize = 1,
		})
		Button:SetBackdropColor(0, 0.9, 0)
		Button:SetBackdropBorderColor(0, 0, 0)
		if i == 1 then
			Button:SetPoint("TOPLEFT", 2, -1)
		elseif i == 2 then
			Button:SetPoint("TOPRIGHT", -2, -1)
		elseif i == 3 then
			Button:SetPoint("BOTTOMLEFT", 2, 1)
		elseif i == 4 then
			Button:SetPoint("BOTTOMRIGHT", -2, 1)
		end
		Button:Hide()
		tinsert(Indicator, Button)
	end
	self.Indicator = Indicator
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
	
	-- BuildRaidDebuffs
	BuildRaidDebuffs(self)
	
	-- BuildIndicator
	BuildIndicator(self)
	
	self.Health.PostUpdate = PostUpdateRaidFrame
end

function Module:OnInitialize()
	if not UnitFrameDB.ShowRaidFrame then return end
	-- Hide the Blizzard raid frames
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()		
	CompactRaidFrameContainer:SetParent(UIParent)
	
	oUF:RegisterStyle("SoraRaid", BuildRaidFrame)
	oUF:SetActiveStyle("SoraRaid")
	local RaidFramePos = CreateFrame("Frame", nil, UIParent)
	RaidFramePos:SetSize(UnitFrameDB.RaidUnitWidth*5+5*4, UnitFrameDB.RaidUnitHeight*5+5*4)
	MoveHandle.RaidFrame = S.MakeMoveHandle(RaidFramePos, "团队框体", "RaidFrame")
	DB.RaidFrame = oUF:SpawnHeader("oUF_Raid", nil, "raid,party,solo", 
		"showRaid", true,  
		"showPlayer", true, 
		"showParty", true, 
		"showSolo", false, 
		"xoffset", (UnitFrameDB.RaidPartyArrangement == "Horizontal") and 5 or 0, 
		"yoffset", (UnitFrameDB.RaidPartyArrangement == "Vertical") and -5 or 0, 
		"groupFilter", "1,2,3,4,5", 
		"groupBy", "GROUP", 
		"groupingOrder", "1,2,3,4,5", 
		"sortMethod", "INDEX", 
		"maxColumns", 5, 
		"unitsPerColumn", 5, 
		"columnSpacing", 5, 
		"point", (UnitFrameDB.RaidPartyArrangement == "Horizontal") and "LEFT" or "TOP", 
		"columnAnchorPoint", (UnitFrameDB.RaidPartyArrangement == "Horizontal") and "TOP" or "LEFT", 
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(UnitFrameDB.RaidUnitWidth, UnitFrameDB.RaidUnitHeight))
	DB.RaidFrame:SetPoint("TOPLEFT", RaidFramePos)
end