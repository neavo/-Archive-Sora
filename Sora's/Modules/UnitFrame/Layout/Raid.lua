-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Raid")

function Module:SetRegisterForClicks(self)
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
end

function Module:UpdateWidth()
	for i = 1, 40 do
		local UnitButton = _G["oUF_SoraRaidUnitButton"..i]
		if UnitButton then
			UnitButton:SetWidth(C["RaidUnitWidth"])
			UnitButton.Health:SetWidth(C["RaidUnitWidth"])
			UnitButton.Power:SetWidth(C["RaidUnitWidth"])
			Module.RaidPos:SetWidth(C["RaidUnitWidth"]*5+5*4)
			MoveHandle.Raid:SetWidth(C["RaidUnitWidth"]*5+5*4)
		else
			break
		end
	end
end

function Module:UpdateHealthHeight()
	for i = 1, 40 do
		local UnitButton = _G["oUF_SoraRaidUnitButton"..i]
		if UnitButton then
			UnitButton:SetHeight(C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)
			UnitButton.Health:SetHeight(C["RaidUnitHealthHeight"])
			Module.RaidPos:SetHeight((C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)*5+5*4)
			MoveHandle.Raid:SetHeight((C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)*5+5*4)
		else
			break
		end
	end
end

function Module:UpdatePowerHeight()
	for i = 1, 40 do
		local UnitButton = _G["oUF_SoraRaidUnitButton"..i]
		if UnitButton then
			UnitButton:SetHeight(C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)
			UnitButton.Power:SetHeight(C["RaidUnitPowerHeight"])
			Module.RaidPos:SetHeight((C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)*5+5*4)
			MoveHandle.Raid:SetHeight((C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)*5+5*4)
		else
			break
		end
	end
end

function Module:BuildHealthBar(self)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(DB.Statusbar)
	Health:SetSize(C["RaidUnitWidth"], C["RaidUnitHealthHeight"])
	Health:SetPoint("TOP")
	Health.Shadow = S.MakeShadow(Health, 3)
	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetTexture(DB.Statusbar)
	Health.BG:SetAllPoints()
	Health.BG:SetVertexColor(0.1, 0.1, 0.1)
	Health.BG.multiplier = 0.2
	
	Health.frequentUpdates = true
	Health.colorSmooth = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.Smooth = true
	Health.colorTapping = true
		
	self.Health = Health
end

function Module:BuildPowerBar(self)
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(DB.Statusbar)
	Power:SetSize(C["RaidUnitWidth"], C["RaidUnitPowerHeight"])
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
end

function Module:BuildTags(self)
	local Name = self.Health:CreateFontString(nil, "ARTWORK")
	Name:SetFont(DB.Font, 9, "THINOUTLINE")
	Name:SetPoint("CENTER", 0, 0)
	self:Tag(Name, "[Sora:color][name]")
	local DeadInfo = self.Health:CreateFontString(nil, "ARTWORK")
	DeadInfo:SetFont(DB.Font, 7, "THINOUTLINE")
	DeadInfo:SetPoint("CENTER", 0, -10)
	self:Tag(DeadInfo, "[Sora:info]")
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
	Leader:SetPoint("TOPLEFT", -7, 9)
	self.Leader = Leader
	local Assistant = self.Health:CreateTexture(nil, "OVERLAY")
	Assistant:SetAllPoints(Leader)
	self.Assistant = Assistant
	local MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
	MasterLooter:SetSize(16, 16)
	MasterLooter:SetPoint("LEFT", Leader, "RIGHT")
	self.MasterLooter = MasterLooter
end

function Module:BuildLFDRoleIcon(self)
	local LFDRoleIcon = self.Health:CreateTexture(nil, "OVERLAY")
	LFDRoleIcon:SetSize(16, 16)
	LFDRoleIcon:SetPoint("TOPRIGHT", 7, 9)
	self.LFDRole = LFDRoleIcon
end

function Module:BuildReadyCheckIcon(self)
	local ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:SetSize(16, 16)
	ReadyCheck:SetPoint("CENTER", 0, 0)
	self.ReadyCheck = ReadyCheck
end

function Module:BuildThreatBorder(self)
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

function Module:BuildRaidDebuffs(self)
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

function Module:BuildIndicators(self)
	local Indicators = {}
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
		tinsert(Indicators, Button)
	end
	self.Indicators = Indicators
end

function Module:SetHealthPostUpdate(self)
	self.Health.PostUpdate = function(Health, unit, min, max)
		local disconnnected = not UnitIsConnected(unit)
		local dead = UnitIsDead(unit)
		local ghost = UnitIsGhost(unit)

		if disconnnected or dead or ghost then
			Health:SetValue(max)	
			Health:SetStatusBarColor(0, 0, 0)
		else
			Health:SetValue(min)
			if unit == "vehicle" then Health:SetStatusBarColor(22/255, 106/255, 44/255) end
		end
	end
end

function Module:SetRange(self)
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = 0.4,
	}
end

local function BuildRaid(self, ...)
	Module:SetRegisterForClicks(self)
	Module:SetRange(self)
	Module:BuildHealthBar(self)
	Module:BuildPowerBar(self)
	Module:BuildTags(self)
	Module:BuildRaidIcon(self)
	Module:BuildCombatIcon(self)
	Module:BuildLFDRoleIcon(self)
	Module:BuildReadyCheckIcon(self)
	Module:BuildThreatBorder(self)
	Module:BuildRaidDebuffs(self)
	Module:BuildIndicators(self)
	Module:SetHealthPostUpdate(self)
end

function Module:OnInitialize()
	C = UnitFrameDB
	
	if not C["ShowRaid"] then return end
	
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = function() end
	CompactRaidFrameManager:Hide()
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = function() end
	CompactRaidFrameContainer:Hide()		
	CompactRaidFrameContainer:SetParent(UIParent)
	
	oUF:RegisterStyle("Raid", BuildRaid)
	oUF:SetActiveStyle("Raid")
	Module.RaidPos = CreateFrame("Frame", nil, UIParent)
	Module.RaidPos:SetSize(C["RaidUnitWidth"]*5+5*4, (C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2)*5+5*4)
	MoveHandle.Raid = S.MakeMoveHandle(Module.RaidPos, "团队框体", "Raid")
	DB.Raid = oUF:SpawnHeader("oUF_SoraRaid", nil, "raid,party,solo", 
		"showRaid", true,  
		"showPlayer", true, 
		"showParty", true, 
		"showSolo", false, 
		"xoffset", (C["RaidPartyArrangement"] == "Horizontal") and 5 or 0, 
		"yoffset", (C["RaidPartyArrangement"] == "Vertical") and -5 or 0, 
		"groupFilter", "1,2,3,4,5", 
		"groupBy", "GROUP", 
		"groupingOrder", "1,2,3,4,5", 
		"sortMethod", "INDEX", 
		"maxColumns", 5, 
		"unitsPerColumn", 5, 
		"columnSpacing", 5, 
		"point", (C["RaidPartyArrangement"] == "Horizontal") and "LEFT" or "TOP", 
		"columnAnchorPoint", (C["RaidPartyArrangement"] == "Horizontal") and "TOP" or "LEFT", 
		"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
		]]):format(C["RaidUnitWidth"], C["RaidUnitPowerHeight"]+C["RaidUnitHealthHeight"]+2))
	DB.Raid:SetPoint("TOPLEFT", Module.RaidPos)
end