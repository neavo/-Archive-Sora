-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("TargetTarget")

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
	local UnitFrame = _G["oUF_SoraTargetTarget"]
	if UnitFrame then
		UnitFrame:SetWidth(C["TargetTargetWidth"])
		UnitFrame.Health:SetWidth(C["TargetTargetWidth"])
		UnitFrame.Power:SetWidth(C["TargetTargetWidth"])		
	end
	if MoveHandle.TargetTarget then
		MoveHandle.TargetTarget:SetWidth(C["TargetTargetWidth"])
	end
end

function Module:UpdateHeight()
	local UnitFrame = _G["oUF_SoraTargetTarget"]
	if UnitFrame then
		UnitFrame:SetHeight(C["TargetTargetHealthHeight"]+C["TargetTargetPowerHeight"]+2)
		UnitFrame.Health:SetHeight(C["TargetTargetHealthHeight"])
		UnitFrame.Power:SetHeight(C["TargetTargetPowerHeight"])
	end
	if MoveHandle.TargetTarget then
		MoveHandle.TargetTarget:SetHeight(C["TargetTargetHealthHeight"]+C["TargetTargetPowerHeight"]+2)
	end
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
	Module:SetRegisterForClicks(self)
	Module:BuildHealthBar(self)
	Module:BuildPowerBar(self)
	Module:UpdateWidth()
	Module:UpdateHeight()
	Module:BuildTags(self)
	Module:BuildRaidIcon(self)
end

function Module:OnInitialize()
	C =	UnitFrameDB
	if not C["TargetEnable"] then return end
	oUF:RegisterStyle("TargetTarget", BuildTargetTarget)
	oUF:SetActiveStyle("TargetTarget")
	DB.TargetTarget = oUF:Spawn("targettarget", "oUF_SoraTargetTarget")
	MoveHandle.TargetTarget = S.MakeMoveHandle(DB.TargetTarget, "目标的目标框体", "TargetTarget")
end