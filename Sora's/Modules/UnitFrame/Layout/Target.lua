-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Target")
local Parent = nil

function Module:UpdateWidth(value)
	if Parent then Parent:SetWidth(value) end
	if Parent.Power then Parent.Health:SetWidth(value) end
	if Parent.Power then Parent.Power:SetWidth(value) end
end
function Module:UpdateHealthHeight(value)
	Parent:SetHeight(value+UnitFrameDB["TargetPowerHeight"]+4)
	Parent.Health:SetHeight(value)
end
function Module:UpdatePowerHeight(value)
	Parent:SetHeight(value+UnitFrameDB["TargetHealthHeight"]+4)
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
	Health.colorSmooth = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.Smooth = true
	Health.colorTapping = true
	
	self.Health = Health
	Module:UpdateWidth(UnitFrameDB["TargetWidth"])
	Module:UpdateHealthHeight(UnitFrameDB["TargetHealthHeight"])
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
	Module:UpdateWidth(UnitFrameDB["TargetWidth"])
	Module:UpdatePowerHeight(UnitFrameDB["TargetPowerHeight"])
end
function Module:BuildPortrait(self)
	local Portrait = CreateFrame("PlayerModel", nil, self.Health)
	Portrait:SetAlpha(0.3) 
	Portrait.PostUpdate = function(self) 
		if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
			self:SetCamera(1)
		end	
	end
	Portrait:SetAllPoints()
	Portrait:SetFrameLevel(self.Health:GetFrameLevel()+1)
	Portrait:RegisterEvent("PLAYER_REGEN_DISABLED")
	Portrait:RegisterEvent("PLAYER_REGEN_ENABLED")
	Portrait:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(self, 0.5, 0.3, 0)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(self, 0.5, 0, 0.3)
		end
	end)
	self.Portrait = Portrait
end
function Module:BuildTags(self)
	local Name = S.MakeFontString(self.Health, 11)
	Name:SetPoint("LEFT", 5, 0)
	self:Tag(Name, "[Sora:level] [Sora:color][name]")
	Name:SetAlpha(0)
	local HPTag = S.MakeFontString(self.Health, 11)
	HPTag:SetPoint("RIGHT", 0, 0)
	HPTag:SetAlpha(0)
	local PPTag = S.MakeFontString(self.Power, 9)
	PPTag:SetPoint("RIGHT", 0, 0)
	PPTag:SetAlpha(0)

	local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_REGEN_DISABLED")
	Event:RegisterEvent("PLAYER_REGEN_ENABLED")
	Event:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(Name, 0.5, 0, 1)
			UIFrameFadeIn(HPTag, 0.5, 0, 1)
			UIFrameFadeIn(PPTag, 0.5, 0, 1)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(Name, 0.5, 1, 0)
			UIFrameFadeOut(HPTag, 0.5, 1, 0)
			UIFrameFadeOut(PPTag, 0.5, 1, 0)	
		end
	end)
	self:HookScript("OnEnter", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeIn(self.Portrait, 0.5, 0.3, 0)
			UIFrameFadeIn(Name, 0.5, 0, 1)
			UIFrameFadeIn(HPTag, 0.5, 0, 1)
			UIFrameFadeIn(PPTag, 0.5, 0, 1)
		end
	end)
	self:HookScript("OnLeave", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeOut(self.Portrait, 0.5, 0, 0.3)
			UIFrameFadeOut(Name, 0.5, 1, 0)
			UIFrameFadeOut(HPTag, 0.5, 1, 0)
			UIFrameFadeOut(PPTag, 0.5, 1, 0)
		end
	end)

	self:Tag(HPTag, UnitFrameDB["TargetTagMode"] == "Short" and "[Sora:color][Sora:hp]" or "[Sora:color][curhp] | [perhp]%")
	self:Tag(PPTag, UnitFrameDB["TargetTagMode"] == "Short" and "[Sora:pp]" or "[curpp] | [perpp]%")	
end
function Module:BuildBuff(self)
	if UnitFrameDB["TargetBuffMode"] == "None" then return end
	local Buffs = CreateFrame("Frame", nil, self)
	Buffs.onlyShowPlayer = (UnitFrameDB["TargetBuffMode"] == "OnlyPlayer")
	Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	Buffs.initialAnchor = "TOPLEFT"
	Buffs["growth-x"] = "RIGHT"
	Buffs["growth-y"] = "DOWN"
	Buffs.size = 20
	Buffs.spacing = 5
	Buffs.num = floor((self:GetWidth()+Buffs.spacing)/(Buffs.size+Buffs.spacing))
	Buffs:SetSize(self:GetWidth(), Buffs.size)
	Buffs.PostCreateIcon = function(self, Button)
		Button.Shadow = S.MakeShadow(Button, 3)	
		Button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.icon:SetAllPoints()
		Button.count = S.MakeFontString(Button, 9)
		Button.count:SetPoint("TOPRIGHT", 3, 0)
	end
	self.Buffs = Buffs
end
function Module:BuildDebuff(self)
	if UnitFrameDB["TargetDebuffMode"] == "None" then return end
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs.onlyShowPlayer = (UnitFrameDB["TargetDebuffMode"] == "OnlyPlayer")
	Debuffs.size = 20
	Debuffs.spacing = 5
	Debuffs.num = floor((self:GetWidth()+Debuffs.spacing)/(Debuffs.size+Debuffs.spacing))*2
	Debuffs:SetSize(self:GetWidth(), Debuffs.size*2+Debuffs.spacing)
	Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -30)
	Debuffs.initialAnchor = "TOPLEFT"
	Debuffs["growth-x"] = "RIGHT"
	Debuffs["growth-y"] = "DOWN"
	Debuffs.PostCreateIcon = function(self, Button)
		Button.Shadow = S.MakeShadow(Button, 3)	
		Button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.icon:SetAllPoints()	
		Button.count = S.MakeFontString(Button, 9)
		Button.count:SetPoint("TOPRIGHT", 3, 0)
	end
	Debuffs.PostUpdateIcon = function(self, unit, Button, index, offset, filter, isDebuff)
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
	self.Debuffs = Debuffs
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

local function BuildTarget(self, ...)
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
	Module:BuildPortrait(self)
	Module:BuildTags(self)
	Module:BuildBuff(self)
	Module:BuildDebuff(self)
	Module:BuildRaidIcon(self)
	Module:BuildCombatIcon(self)
end

function Module:OnInitialize()
	if not UnitFrameDB["TargetEnable"] then return end
	oUF:RegisterStyle("Target", BuildTarget)
	oUF:SetActiveStyle("Target")
	DB.Target = oUF:Spawn("target", "oUF_SoraTarget")
	MoveHandle.Target = S.MakeMoveHandle(DB.Target, "目标框体", "Target")
end