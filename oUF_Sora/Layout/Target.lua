----------------
--  命名空间  --
----------------

local _, ns = ...
local oUF = ns.oUF or oUF
local S, C, L, DB = unpack(select(2, ...))

local function MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({ edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

local function MakeTexShadow(Parent, Anchor, Size)
	local Border = CreateFrame("Frame", nil, Parent)
	Border:SetPoint("TOPLEFT", Anchor, -Size, Size)
	Border:SetPoint("BOTTOMRIGHT", Anchor, Size, -Size)
	Border:SetFrameLevel(1)
	Border:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Border:SetBackdropBorderColor(0, 0, 0, 1)
	return Border
end

local function MakeFontString(parent, fontsize)
	local tempText = parent:CreateFontString(nil, "OVERLAY")
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
	Bar:SetHeight(24)
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
	Bar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	Bar.Shadow = MakeShadow(Bar, 3)
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
	local Name = MakeFontString(self.Health, 11)
	Name:SetPoint("LEFT", 5, 0)
	self:Tag(Name, "[Sora:level] [Sora:color][name]")
	Name:SetAlpha(0)
	local HPTag = MakeFontString(self.Health, 11)
	HPTag:SetPoint("RIGHT", 0, 0)
	self:Tag(HPTag, "[Sora:color][Sora:hp]")
	HPTag:SetAlpha(0)
	local PPTag = MakeFontString(self.Power, 9)
	PPTag:SetPoint("RIGHT", 0, 0)
	self:Tag(PPTag, "[Sora:pp]")
	PPTag:SetAlpha(0)

	local PowerBar = self.Power
	PowerBar:RegisterEvent("PLAYER_REGEN_DISABLED")
	PowerBar:RegisterEvent("PLAYER_REGEN_ENABLED")
	PowerBar:SetScript("OnEvent", function(self, event, ...)
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
	PowerBar:SetScript("OnEnter", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeIn(self.Portrait, 0.5, 0.3, 0)
			UIFrameFadeIn(Name, 0.5, 0, 1)
			UIFrameFadeIn(HPTag, 0.5, 0, 1)
			UIFrameFadeIn(PPTag, 0.5, 0, 1)
		end
	end)
	PowerBar:SetScript("OnLeave", function()
		if not UnitAffectingCombat("player") then
			UIFrameFadeOut(self.Portrait, 0.5, 0, 0.3)
			UIFrameFadeOut(Name, 0.5, 1, 0)
			UIFrameFadeOut(HPTag, 0.5, 1, 0)
			UIFrameFadeOut(PPTag, 0.5, 1, 0)
		end
	end)
end

local function BuildCastbar(self)
	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(DB.Statusbar)
	Castbar:SetStatusBarColor(95/255, 182/255, 255/255, 1)
	if UnitFrameDB.TargetCastbarAlone then
		Castbar:SetHeight(14)
		Castbar:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 34, 60)
		Castbar:SetPoint("BOTTOMRIGHT", MultiBarBottomRightButton12, "TOPRIGHT", -20, 60)			
	else
		Castbar:SetHeight(10)
		Castbar:SetWidth(self:GetWidth()-70)
		Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -14)
	end
	
	Castbar.Shadow = MakeShadow(Castbar, 3)
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

	Castbar.Text = MakeFontString(Castbar, 10)
	Castbar.Text:SetPoint("LEFT", 2, 0)
	
	Castbar.Time = MakeFontString(Castbar, 10)
	Castbar.Time:SetPoint("RIGHT", -2, 0)
	
	Castbar.Icon = Castbar:CreateTexture(nil, "ARTWORK")
	Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	if UnitFrameDB.TargetCastbarAlone then
		Castbar.Icon:SetSize(14, 14)
	else
		Castbar.Icon:SetSize(20, 20)
	end
	Castbar.Icon:SetPoint("BOTTOMRIGHT", Castbar, "BOTTOMLEFT", -8, 0)
	Castbar.Icon.Shadow = MakeTexShadow(Castbar, Castbar.Icon, 3)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed

	self.Castbar = Castbar
end

local function PostCreateIcon(self, Button)
	Button.Shadow = MakeShadow(Button, 3)	
	Button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Button.icon:SetAllPoints()	
	Button.count = MakeFontString(Button, 9)
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
	Buff = CreateFrame("Frame", nil, self)
	Buff.onlyShowPlayer = UnitFrameDB.BuffOnlyShowPlayer
	Buff:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, 0)
	Buff.initialAnchor = "TOPLEFT"
	Buff["growth-x"] = "RIGHT"
	Buff["growth-y"] = "DOWN"
	Buff.size = 20
	Buff.num = 18
	Buff.spacing = 5
	Buff:SetWidth((Buff.size+Buff.spacing)*6-Buff.spacing)
	Buff:SetHeight((Buff.size+Buff.spacing)*3)
	Buff.PostCreateIcon = PostCreateIcon
	Buff.PostUpdateIcon = PostUpdateIcon

	self.Buffs = Buff
end

local function BuildDebuff(self)
	Debuff = CreateFrame("Frame", nil, self)
	Debuff.size = 20
	Debuff.num = 40
	Debuff.onlyShowPlayer = UnitFrameDB.DebuffOnlyShowPlayer
	Debuff.spacing = 5
	Debuff:SetHeight((Debuff.size+Debuff.spacing)*5)
	Debuff:SetWidth(self:GetWidth())
	Debuff:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -30)
	Debuff.initialAnchor = "TOPLEFT"
	Debuff["growth-x"] = "RIGHT"
	Debuff["growth-y"] = "DOWN"
	Debuff.PostCreateIcon = PostCreateIcon
	Debuff.PostUpdateIcon = PostUpdateIcon

	self.Debuffs = Debuff
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
	self:SetScale(UnitFrameDB.Scale)
	self:SetSize(220, 30)
	
	-- BuildHealthBar
	BuildHealthBar(self)
	
	-- BuildPowerBar
	BuildPowerBar(self)
	
	-- BuildPortrait
	BuildPortrait(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildCastbar
	if UnitFrameDB.ShowCastbar then BuildCastbar(self) end
	
	-- BuildBuff
	if UnitFrameDB.ShowTargetBuff then BuildBuff(self) end
	
	-- BuildDebuff
	if UnitFrameDB.ShowTargetDebuff then BuildDebuff(self) end
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function(slef, event, addon, ...)
	oUF:RegisterStyle("SoraTarget", BuildTargetFrame)
	oUF:SetActiveStyle("SoraTarget")
	ns.TargetFrame = oUF:Spawn("target")
	ns.TargetFrame:SetPoint("CENTER", UIParent, "CENTER", 270, -100)
end)