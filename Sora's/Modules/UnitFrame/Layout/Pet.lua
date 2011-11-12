-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Pet")
local Parent = nil

function Module:UpdateWidth(value)
	if Parent then Parent:SetWidth(value) end
	if Parent.Power then Parent.Health:SetWidth(value) end
	if Parent.Power then Parent.Power:SetWidth(value) end
end
function Module:UpdateHealthHeight(value)
	Parent:SetHeight(value+UnitFrameDB["PetPowerHeight"]+4)
	Parent.Health:SetHeight(value)
end
function Module:UpdatePowerHeight(value)
	Parent:SetHeight(value+UnitFrameDB["PetHealthHeight"]+4)
	Parent.Power:SetHeight(value)
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
	Health.colorReaction = true
	Health.Smooth = true
	
	self.Health = Health
	Module:UpdateWidth(UnitFrameDB["PetWidth"])
	Module:UpdateHealthHeight(UnitFrameDB["PetHealthHeight"])
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
	Module:UpdateWidth(UnitFrameDB["PetWidth"])
	Module:UpdatePowerHeight(UnitFrameDB["PetPowerHeight"])
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

local function BuildPet(self, ...)
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
	if not UnitFrameDB["PlayerEnable"] then return end
	oUF:RegisterStyle("Pet", BuildPet)
	oUF:SetActiveStyle("Pet")
	DB.Pet = oUF:Spawn("pet", "oUF_SoraPet")
	MoveHandle.Pet = S.MakeMoveHandle(DB.Pet, "宠物框体", "Pet")
end