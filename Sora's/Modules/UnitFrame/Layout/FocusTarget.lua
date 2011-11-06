-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("FocusTargetFrame")

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
	Bar:SetHeight(14)
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

local function BuildTags(self)
	local Name = S.MakeFontString(self.Health, 9)
	Name:SetPoint("LEFT", 0, 5)
	self:Tag(Name, "[name]")
	local HPTag = S.MakeFontString(self.Health, 7)
	HPTag:SetPoint("RIGHT", self.Health, 7, -5)
	self:Tag(HPTag, "[Sora:hp]")
end

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildFocusTargetFrame(self, ...)
	-- RegisterForClicks
	self.menu = BuildMenu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")
	
	-- Set Size and Scale
	self:SetSize(60, 14)
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildTags
	BuildTags(self)

	-- BuildRaidMark
	BuildRaidIcon(self)

end

function Module:OnInitialize()
	if not (UnitFrameDB.ShowFocusFrame and UnitFrameDB.ShowFocusTarget) then return end
	oUF:RegisterStyle("SoraFocusTarget", BuildFocusTargetFrame)
	oUF:SetActiveStyle("SoraFocusTarget")
	DB.FocusTargetFrame = oUF:Spawn("focustarget")
	DB.FocusTargetFrame:SetPoint("BOTTOMLEFT", DB.FocusFrame, "TOPLEFT", 0, 10)
end