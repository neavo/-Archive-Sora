-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Target")

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
	local UnitFrame = _G["oUF_SoraTarget"]
	if UnitFrame then
		UnitFrame:SetWidth(C["TargetWidth"])
		UnitFrame.Health:SetWidth(C["TargetWidth"])
		UnitFrame.Power:SetWidth(C["TargetWidth"])
	end
	if MoveHandle.Target then
		MoveHandle.Target:SetWidth(C["TargetWidth"])
	end
end

function Module:UpdateHeight()
	local UnitFrame = _G["oUF_SoraTarget"]
	if UnitFrame then
		UnitFrame:SetHeight(C["TargetHealthHeight"]+C["TargetPowerHeight"]+4)
		UnitFrame.Health:SetHeight(C["TargetHealthHeight"])
		UnitFrame.Power:SetHeight(C["TargetPowerHeight"])
	end
	if MoveHandle.Target then
		MoveHandle.Target:SetHeight(C["TargetHealthHeight"]+C["TargetPowerHeight"]+4)
	end
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

	self:Tag(HPTag, C["TargetTagMode"] == "Short" and "[Sora:color][Sora:hp]" or "[Sora:color][curhp] | [perhp]%")
	self:Tag(PPTag, C["TargetTagMode"] == "Short" and "[Sora:pp]" or "[curpp] | [perpp]%")	
end

function Module:UpdateCastbarWidth()
	local UnitFrame = _G["oUF_SoraTarget"]
	if UnitFrame then
		UnitFrame.CastbarPos:SetWidth(C["TargetCastbarWidth"])
		UnitFrame.Castbar:SetWidth(C["TargetCastbarWidth"]-C["TargetCastbarHeight"]-5)
	end
	if MoveHandle.TargetCastbar then
		MoveHandle.TargetCastbar:SetWidth(C["TargetCastbarWidth"])
	end
end

function Module:UpdateCastbarHeight()
	local UnitFrame = _G["oUF_SoraTarget"]
	if UnitFrame then
		UnitFrame.CastbarPos:SetHeight(C["TargetCastbarHeight"])
		UnitFrame.Castbar:SetSize(C["TargetCastbarWidth"]-C["TargetCastbarHeight"]-5, C["TargetCastbarHeight"])
		UnitFrame.Castbar.Icon:SetSize(C["TargetCastbarHeight"], C["TargetCastbarHeight"])
	end
	if MoveHandle.TargetCastbar then
		MoveHandle.TargetCastbar:SetHeight(C["TargetCastbarHeight"])
	end
end

function Module:BuildCastbar(self)
	if not C["TargetCastbarEnable"] then return end
	local CastbarPos = CreateFrame("Frame", nil, self)
	local Castbar = CreateFrame("StatusBar", nil, CastbarPos)
	Castbar:SetStatusBarTexture(DB.Statusbar)
	Castbar:SetStatusBarColor(95/255, 182/255, 255/255)
	Castbar:SetPoint("RIGHT")
	
	Castbar.Shadow = S.MakeShadow(Castbar, 3)
	Castbar.Shadow:SetBackdrop({
		bgFile = DB.Statusbar,insets = {left = 3, right = 3, top = 3, bottom = 3}, 
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	Castbar.Shadow:SetBackdropColor(0, 0, 0, 0.5)
	Castbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	
	Castbar.CastingColor = {95/255, 182/255, 255/255}
	Castbar.CompleteColor = {20/255, 208/255, 0/255}
	Castbar.FailColor = {255/255, 12/255, 0/255}
	Castbar.ChannelingColor = {95/255, 182/255, 255/255}

	Castbar.Text = S.MakeFontString(Castbar, 10)
	Castbar.Text:SetPoint("LEFT", 2, 0)
	
	Castbar.Time = S.MakeFontString(Castbar, 10)
	Castbar.Time:SetPoint("RIGHT", -2, 0)
	
	Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
	Castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Castbar.Icon:SetPoint("BOTTOMRIGHT", Castbar, "BOTTOMLEFT", -5, 0)
	Castbar.Icon.Shadow = S.MakeTexShadow(Castbar, Castbar.Icon, 3)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed
	
	self.Castbar = Castbar
	self.CastbarPos = CastbarPos
	Module:UpdateCastbarWidth()
	Module:UpdateCastbarHeight()
	MoveHandle.TargetCastbar = S.MakeMoveHandle(CastbarPos, "目标施法条", "TargetCastbar")
end

function Module:BuildAura(self)
	if C["TargetAuraMode"] == "None" then return end
	local Auras = CreateFrame("Frame", nil, self)
	Auras.onlyShowPlayer = (C["TargetAuraMode"] == "OnlyPlayer")
	Auras.initialAnchor = "TOPLEFT"
	Auras["growth-x"] = "RIGHT"
	Auras["growth-y"] = "DOWN"
	Auras.size = 20
	Auras.spacing = 5
	Auras.numBuffs = floor((self:GetWidth()+Auras.spacing)/(Auras.size+Auras.spacing))*2
	Auras.gap = true
	Auras.num = floor((self:GetWidth()+Auras.spacing)/(Auras.size+Auras.spacing))*3
	Auras:SetSize(self:GetWidth(), Auras.size*3+Auras.spacing*2)
	Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	Auras.PostCreateIcon = function(self, Button)
		Button.Shadow = S.MakeShadow(Button, 3)	
		Button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.icon:SetAllPoints()
		Button.count = S.MakeFontString(Button, 9)
		Button.count:SetPoint("TOPRIGHT", 3, 0)
	end
	Auras.PostUpdateIcon = function(self, unit, Button, index, offset, filter, isDebuff)
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
	self.Auras = Auras
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
	Module:SetRegisterForClicks(self)
	Module:BuildHealthBar(self)
	Module:BuildPowerBar(self)
	Module:UpdateWidth()
	Module:UpdateHeight()
	Module:BuildPortrait(self)
	Module:BuildTags(self)
	Module:BuildCastbar(self)
	Module:BuildAura(self)
	Module:BuildRaidIcon(self)
	Module:BuildCombatIcon(self)
end

function Module:OnInitialize()
	C = UnitFrameDB
	if not C["TargetEnable"] then return end
	oUF:RegisterStyle("Target", BuildTarget)
	oUF:SetActiveStyle("Target")
	DB.Target = oUF:Spawn("target", "oUF_SoraTarget")
	MoveHandle.Target = S.MakeMoveHandle(DB.Target, "目标框体", "Target")
end