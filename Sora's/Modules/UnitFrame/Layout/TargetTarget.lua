-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("TargetTarget")
local Parent = nil

function Module:UpdateWidth()
	if Parent then Parent:SetWidth(UnitFrameDB["TargetTargetWidth"]) end
	if Parent.Health then Parent.Health:SetWidth(UnitFrameDB["TargetTargetWidth"]) end
	if Parent.Power then Parent.Power:SetWidth(UnitFrameDB["TargetTargetWidth"]) end
	if MoveHandle.TargetTarget then MoveHandle.TargetTarget:SetWidth(UnitFrameDB["TargetTargetWidth"]) end
end

function Module:UpdateHealthHeight()
	if Parent then Parent:SetHeight(UnitFrameDB["TargetTargetHealthHeight"]+UnitFrameDB["TargetTargetPowerHeight"]+4) end
	if Parent.Health then Parent.Health:SetHeight(UnitFrameDB["TargetTargetHealthHeight"]) end
	if MoveHandle.TargetTarget then MoveHandle.TargetTarget:SetHeight(UnitFrameDB["TargetTargetHealthHeight"]+UnitFrameDB["TargetTargetPowerHeight"]+4) end
end

function Module:UpdatePowerHeight()
	if Parent then Parent:SetHeight(UnitFrameDB["TargetTargetPowerHeight"]+UnitFrameDB["TargetTargetHealthHeight"]+4) end
	if Parent.Power then Parent.Power:SetHeight(UnitFrameDB["TargetTargetPowerHeight"]) end
	if MoveHandle.TargetTarget then MoveHandle.TargetTarget:SetHeight(UnitFrameDB["TargetTargetPowerHeight"]+UnitFrameDB["TargetTargetHealthHeight"]+4) end
end

function Module:BuildHealthBar(self)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(DB.Statusbar)
	Health:SetHeight(14)
	Health:SetWidth(self:GetWidth())
	Health:SetPoint("TOP", 0, 0)
	Health.Shadow = S.MakeShadow(Health, 3)
	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetTexture(DB.Statusbar)
	Health.BG:SetAllPoints()
	Health.BG:SetVertexColor(0.1, 0.1, 0.1)
	Health.BG.multiplier = 0.2
	
	Health.frequentUpdates = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.Smooth = true
	Health.colorTapping = true

	self.Health = Health
	Module:UpdateWidth()
	Module:UpdateHealthHeight()
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
	Module:UpdateWidth()
	Module:UpdatePowerHeight()
end

function Module:BuildTags(self)
	local Name = S.MakeFontString(self.Health, 9)
	Name:SetPoint("LEFT", 0, 5)
	self:Tag(Name, "[name]")
	local HPTag = S.MakeFontString(self.Health, 7)
	HPTag:SetPoint("RIGHT", self.Health, 7, -5)
	self:Tag(HPTag, "[Sora:hp]")
end

function Module:BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildTargetTarget(self, ...)
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
	Module:BuildTags(self)
	Module:BuildRaidIcon(self)
end

function Module:OnInitialize()
	if not UnitFrameDB["TargetEnable"] then return end
	oUF:RegisterStyle("TargetTarget", BuildTargetTarget)
	oUF:SetActiveStyle("TargetTarget")
	DB.TargetTarget = oUF:Spawn("targettarget", "oUF_SoraTargetTarget")
	MoveHandle.TargetTarget = S.MakeMoveHandle(DB.TargetTarget, "目标的目标框体", "TargetTarget")
end