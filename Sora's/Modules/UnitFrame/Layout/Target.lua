-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("TargetFrame")

local function BuildMenu(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if cunit == "Vehicle" then cunit = "Pet" end

	if unit == "party" or unit == "partypet" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local function BuildHealthBar(self)
	local Bar = CreateFrame("StatusBar", nil, self)
	Bar:SetStatusBarTexture(DB.Statusbar)
	Bar:SetHeight(UnitFrameDB.TargetHeight-2-4)
	Bar:SetWidth(self:GetWidth())
	Bar:SetPoint("TOP")
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
	Bar.Shadow = S.MakeShadow(Bar, 3)
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

local function BuildPortrait(self)
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

local function BuildTags(self)
	local Name = S.MakeFontString(self.Health, 11)
	Name:SetPoint("LEFT", 5, 0)
	self:Tag(Name, "[Sora:level] [Sora:color][name]")
	Name:SetAlpha(0)
	local HPTag = S.MakeFontString(self.Health, 11)
	HPTag:SetPoint("RIGHT", 0, 0)
	if UnitFrameDB.TargetTagMode == "Short" then
		self:Tag(HPTag, "[Sora:color][Sora:hp]")
	else
		self:Tag(HPTag, "[Sora:color][curhp] | [perhp]%")		
	end
	HPTag:SetAlpha(0)
	local PPTag = S.MakeFontString(self.Power, 9)
	PPTag:SetPoint("RIGHT", 0, 0)
	if UnitFrameDB.TargetTagMode == "Short" then
		self:Tag(PPTag, "[Sora:pp]")
	else
		self:Tag(PPTag, "[curpp] | [perpp]%")
	end
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
end

local function PostCreateIcon(self, Button)
	Button.Shadow = S.MakeShadow(Button, 3)	
	Button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Button.icon:SetAllPoints()	
	Button.count = S.MakeFontString(Button, 9)
	Button.count:SetPoint("TOPRIGHT", Button, 3, 0)
end
  
local function PostUpdateIcon(self, unit, Button, index, offset, filter, isDebuff)
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

local function BuildBuff(self)
	local Buffs = CreateFrame("Frame", nil, self)
	Buffs.onlyShowPlayer = (UnitFrameDB.TargetBuffMode == "OnlyPlayer")
	Buffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, 0)
	Buffs.initialAnchor = "TOPLEFT"
	Buffs["growth-x"] = "RIGHT"
	Buffs["growth-y"] = "DOWN"
	Buffs.size = 20
	Buffs.num = 18
	Buffs.spacing = 5
	Buffs:SetWidth(Buffs.size*6+Buffs.spacing*5)
	Buffs:SetHeight(Buffs.size*3+Buffs.spacing*2)
	Buffs.PostCreateIcon = PostCreateIcon
	Buffs.PostUpdateIcon = PostUpdateIcon
	self.Buffs = Buffs
end

local function BuildDebuff(self)
	local Debuffs = CreateFrame("Frame", nil, self)
	Debuffs.size = 20
	Debuffs.num = 27
	Debuffs.onlyShowPlayer = (UnitFrameDB.TargetDebuffMode == "OnlyPlayer")
	Debuffs.spacing = 5
	Debuffs:SetHeight(Debuffs.size*3+Debuffs.spacing*2)
	Debuffs:SetWidth(self:GetWidth())
	Debuffs:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -30)
	Debuffs.initialAnchor = "TOPLEFT"
	Debuffs["growth-x"] = "RIGHT"
	Debuffs["growth-y"] = "DOWN"
	Debuffs.PostCreateIcon = PostCreateIcon
	Debuffs.PostUpdateIcon = PostUpdateIcon
	self.Debuffs = Debuffs
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

local function BuildTargetFrame(self, ...)
	-- RegisterForClicks
	self.menu = BuildMenu
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:RegisterForClicks("AnyUp")
	
	-- Set Size and Scale
	self:SetSize(UnitFrameDB.TargetWidth, UnitFrameDB.TargetHeight)
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildPowerBar
	BuildPowerBar(self)
	
	-- BuildPortrait
	BuildPortrait(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildBuff
	if UnitFrameDB.TargetBuffMode ~= "None" then BuildBuff(self) end
	
	-- BuildDebuff
	if UnitFrameDB.TargetDebuffMode ~= "None" then BuildDebuff(self) end
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)
end

function Module:OnInitialize()
	if not UnitFrameDB.ShowTargetFrame then return end
	oUF:RegisterStyle("SoraTarget", BuildTargetFrame)
	oUF:SetActiveStyle("SoraTarget")
	DB.TargetFrame = oUF:Spawn("target")
	MoveHandle.TargetFrame = S.MakeMoveHandle(DB.TargetFrame, "目标框体", "TargetFrame")
end