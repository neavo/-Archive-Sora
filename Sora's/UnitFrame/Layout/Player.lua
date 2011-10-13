-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local S, _, _, DB = unpack(select(2, ...))

local function MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
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

local function MakeFontString(Parent, fontsize)
	local tempText = Parent:CreateFontString(nil, "OVERLAY")
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
	Bar.Smooth = true
		
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

local function BuildClassPowerBar(self)
	local _, Class = UnitClass("player")
	if Class == "DEATHKNIGHT" then
		local Runes = CreateFrame("Frame")
		for i= 1, 6 do
			local Rune = CreateFrame("StatusBar", nil, self)
			Rune:SetSize((self:GetWidth()-15)/6, 3)
			Rune:SetStatusBarTexture(DB.Statusbar)			
			Rune.BG = Rune:CreateTexture(nil, "BACKGROUND")
			Rune.BG:SetAllPoints()
			Rune.BG:SetTexture(DB.Statusbar)
			Rune.BG:SetVertexColor(0.1, 0.1, 0.1)			
			Rune.Shadow = MakeShadow(Rune, 3)
			
			if i == 1 then
				Rune:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				Rune:SetPoint("LEFT", Runes[i-1], "RIGHT", 3, 0)
			end
			Runes[i] = Rune
		end
		self.Runes = Runes
	end
	if Class == "PALADIN" then
		local HolyPower = CreateFrame("Frame")
		for i = 1, 3 do
			local HolyShard = CreateFrame("StatusBar", nil, self)
			HolyShard:SetSize((self:GetWidth()-10)/3, 3)
			HolyShard:SetStatusBarTexture(DB.Statusbar)
			HolyShard:SetStatusBarColor(0.9, 0.95, 0.33)		
			HolyShard.Shadow = MakeShadow(HolyShard, 3)
			if i == 1 then
				HolyShard:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				HolyShard:SetPoint("TOPLEFT", HolyPower[i-1], "TOPRIGHT", 5, 0)
			end
			HolyPower[i] = HolyShard
		end
		self.HolyPower = HolyPower
		
		local function Override(self, event, unit, powerType)
			if self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER") then return end
			local HolyPower = self.HolyPower
			if HolyPower.PreUpdate then 
				HolyPower:PreUpdate(unit) 
			end	
			for i = 1, MAX_HOLY_POWER do
				if i <= UnitPower(unit, SPELL_POWER_HOLY_POWER) then
					HolyPower[i]:SetAlpha(1)
				else
					HolyPower[i]:SetAlpha(0.2)
				end
			end
		end
		self.HolyPower.Override = Override
	end
	if Class == "WARLOCK" then
		local SoulShards = CreateFrame("Frame")
		for i= 1, 3 do
			local SoulShard = CreateFrame("StatusBar", nil, self)
			SoulShard:SetSize((self:GetWidth()-10)/3, 3)
			SoulShard:SetStatusBarTexture(DB.Statusbar)
			SoulShard:SetStatusBarColor(0.86, 0.44, 1)	
			SoulShard.Shadow = MakeShadow(SoulShard, 3)
			if i == 1 then
				SoulShard:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				SoulShard:SetPoint("TOPLEFT", SoulShards[i-1], "TOPRIGHT", 5, 0)
			end
			SoulShards[i] = SoulShard
		end
		self.SoulShards = SoulShards
		
		local function Override(self, event, unit, powerType)
			if self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS") then return end
			local SoulShards = self.SoulShards
			for i = 1, SHARD_BAR_NUM_SHARDS do
				if i <= UnitPower(unit, SPELL_POWER_SOUL_SHARDS) then
					SoulShards[i]:SetAlpha(1)
				else
					SoulShards[i]:SetAlpha(0.3)
				end
			end
		end
		self.SoulShards.Override = Override
	end
	if Class == "DRUID" then
		local EclipseBar = CreateFrame("Frame", nil, self)
		EclipseBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 4)
		EclipseBar:SetHeight(3)
		EclipseBar:SetWidth(self:GetWidth())
		EclipseBar.Shadow = MakeShadow(EclipseBar, 3)
		EclipseBar.LunarBar = CreateFrame("StatusBar", nil, EclipseBar)
		EclipseBar.LunarBar:SetPoint("LEFT", 0, 0)
		EclipseBar.LunarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
		EclipseBar.LunarBar:SetStatusBarTexture(DB.Statusbar)
		EclipseBar.LunarBar:SetStatusBarColor(0, 0.1, 0.7)
		EclipseBar.SolarBar = CreateFrame("StatusBar", nil, EclipseBar)
		EclipseBar.SolarBar:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
		EclipseBar.SolarBar:SetSize(EclipseBar:GetWidth(), EclipseBar:GetHeight())
		EclipseBar.SolarBar:SetStatusBarTexture(DB.Statusbar)
		EclipseBar.SolarBar:SetStatusBarColor(1, 1, 0.13)
		EclipseBar.Text = MakeFontString(EclipseBar.SolarBar, 9)
		EclipseBar.Text:SetPoint("LEFT", EclipseBar.LunarBar:GetStatusBarTexture(), "RIGHT", -1, 0)
		self:Tag(EclipseBar.Text, "[pereclipse]")
		self.EclipseBar = EclipseBar
	end
	if Class == "SHAMAN" then
		oUF.colors.totems = {
			{ 233/255, 46/255,   16/255 }, 	-- fire
			{ 173/255, 217/255,  25/255 }, 	-- earth
			{  35/255, 127/255, 255/255 }, 	-- water
			{ 178/255,  53/255, 240/255 }, 	-- air
		}
		local TotemBar = CreateFrame("Frame", nil, self)
		for i = 1, 4 do
			local Totem = CreateFrame("Frame", nil, TotemBar)
			Totem:SetHeight(3)
			Totem:SetWidth((self.Health:GetWidth()-15)/4)
			Totem.StatusBar = CreateFrame("StatusBar", nil, Totem)
			Totem.StatusBar:SetAllPoints()
			Totem.StatusBar:SetStatusBarTexture(DB.Statusbar)	
			Totem.BG = Totem:CreateTexture(nil, "BACKGROUND")
			Totem.BG:SetAllPoints()
			Totem.BG:SetTexture(DB.Statusbar)
			Totem.BG:SetVertexColor(0.2, 0.2, 0.2, 0.8)
			Totem.Shadow = MakeShadow(Totem, 3)
			Totem.Text = MakeFontString(Totem, 8)
			Totem.Text.Colors = {
				{173/255, 217/255,  25/255}, 	-- earth
				{233/255,  46/255,  16/255}, 	-- fire
				{ 35/255, 127/255, 255/255}, 	-- water
				{178/255,  53/255, 240/255}, 	-- air
			}
			Totem.Text:SetPoint("CENTER", 0, 10)
			Totem.Text:SetTextColor(unpack(Totem.Text.Colors[i]))
			if i == 1 then
				Totem:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				Totem:SetPoint("TOPLEFT", TotemBar[i-1], "TOPRIGHT", 5, 0)
			end	
			TotemBar[i] = Totem
		end
		TotemBar.Destroy = true
		TotemBar.AbbreviateNames = true
		TotemBar.UpdateColors = true
		self.TotemBar = TotemBar
	end
	if Class == "ROGUE" or Class == "DRUID" then	
		local CPoints = CreateFrame("Frame", nil, self)	
		for i = 1, MAX_COMBO_POINTS do
			local CPoint = CreateFrame("StatusBar", nil, self)
			CPoint:SetSize((self:GetWidth() / 5)-5, 3)
			CPoint:SetStatusBarTexture(DB.Statusbar)
			CPoint:SetStatusBarColor(1, 0.9, 0)				
			CPoint.Shadow = MakeShadow(CPoint, 3)
			if i == 1 then
				CPoint:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 4)
			else
				CPoint:SetPoint("TOPLEFT", CPoints[i-1], "TOPRIGHT", 6, 0)
			end
			CPoints[i] = CPoint
		end
		self.CPoints = CPoints
		self.CPoints.unit = "player"
	end
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
	self:Tag(Name, "[Sora:color][name]")
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
	if UnitFrameDB.PlayerCastbarAlone then
		Castbar:SetHeight(20)
		Castbar:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 2, 30)
		Castbar:SetPoint("BOTTOMRIGHT", MultiBarBottomRightButton12, "TOPRIGHT", -30, 30)			
	else
		Castbar:SetHeight(10)
		Castbar:SetWidth(self:GetWidth()-70)
		Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -14)
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
	Castbar.Icon:SetSize(20, 20)
	Castbar.Icon:SetPoint("BOTTOMLEFT", Castbar, "BOTTOMRIGHT", 8, 0)
	Castbar.Icon.Shadow = MakeTexShadow(Castbar, Castbar.Icon, 3)

	--latency (only for player unit)
	Castbar.SafeZone = Castbar:CreateTexture(nil, "OVERLAY")
	Castbar.SafeZone:SetTexture(DB.Statusbar)
	Castbar.SafeZone:SetVertexColor(1, 0.1, 0, .6)
	Castbar.SafeZone:SetPoint("TOPRIGHT")
	Castbar.SafeZone:SetPoint("BOTTOMRIGHT")
	Castbar.Lag = MakeFontString(Castbar, 10)
	Castbar.Lag:SetPoint("CENTER", -2, 17)
	Castbar.Lag:Hide()
	self:RegisterEvent("UNIT_SPELLCAST_SENT", S.OnCastSent)

	Castbar.OnUpdate = S.OnCastbarUpdate
	Castbar.PostCastStart = S.PostCastStart
	Castbar.PostChannelStart = S.PostCastStart
	Castbar.PostCastStop = S.PostCastStop
	Castbar.PostChannelStop = S.PostChannelStop
	Castbar.PostCastFailed = S.PostCastFailed
	Castbar.PostCastInterrupted = S.PostCastFailed

	self.Castbar = Castbar
end

local function BuildRaidIcon(self)
	local RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self.Health, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
end

local function BuildCombatIcon(self)
	local Resting = self.Health:CreateTexture(nil, "OVERLAY")
	Resting:SetSize(24, 24)
	Resting:SetPoint("RIGHT", self.Health, "LEFT", -3, 0)
	self.Resting = Resting
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

local function BuildPlayerFrame(self, ...)
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
	
	-- BuildClassPowerBar
	BuildClassPowerBar(self)
	
	-- BuildPortrait
	BuildPortrait(self)
	
	-- BuildTags
	BuildTags(self)
	
	-- BuildCastbar
	if UnitFrameDB.ShowCastbar then BuildCastbar(self) end
	
	-- BuildRaidMark
	BuildRaidIcon(self)
	
	-- BuildCombatIcon
	BuildCombatIcon(self)

end

oUF:RegisterStyle("SoraPlayer", BuildPlayerFrame)
oUF:SetActiveStyle("SoraPlayer")
DB.PlayerFrame = oUF:Spawn("player")
DB.PlayerFrame:SetPoint("CENTER", UIParent, "CENTER", -270, -100)