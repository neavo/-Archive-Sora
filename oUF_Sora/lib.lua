local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg
local cast = ns.cast
local lib = CreateFrame("Frame")  
local _, playerClass = UnitClass("player")
  
--status bar filling fix (from oUF_Mono)
local fixStatusbar = function(BG)
	BG:GetStatusBarTexture():SetHorizTile(false)
	BG:GetStatusBarTexture():SetVertTile(false)
end
  
-- backdrop func
lib.gen_backdrop = function(self)
	self:SetBackdrop({
		edgeFile = cfg.Solid, edgeSize = 1, 
		insets = { left = 1, right = 1, top = 1, bottom = 1},
	})
	self:SetBackdropBorderColor(0,0,0,0.8)
end

lib.gen_castbackdrop = function(self)
	self:SetBackdrop({
		bgFile = cfg.backdrop_texture, 
		edgeFile = cfg.Solid, edgeSize = 1, 
		insets = { left = 1, right = 1, top = 1, bottom = 1},
	})
	self:SetBackdropColor(0,0,0,0.6)
	self:SetBackdropBorderColor(0,0,0,1)
end

local function MakeShadow(Frame)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", 5, 0)
	Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex, edgeSize = 5, 
	})
	Shadow:SetBackdropBorderColor(0,0,0,1)
	return Shadow
end

local function MakeBorder(Frame)
	local Border = CreateFrame("Frame", nil, Frame)
	Border:SetFrameLevel(1)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Border:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1, 
	})
	Border:SetBackdropBorderColor(0,0,0,1)
	return Border
end

-- Right Click Menu
lib.spawnMenu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if cunit == "Vehicle" then
		cunit = "Pet"
	end

	if unit == "party" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	elseif unit == "raid" then
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1,nil,FriendsDropDown,"cursor")		
	end
end
  
--fontstring func
lib.gen_fontstring = function(self, name, size, outline)
	local fs = self:CreateFontString(nil, "OVERLAY")
	fs:SetFont(name, size, outline)
	return fs
end  
  
--gen healthbar func
lib.gen_hpbar = function(self)
	-- Statusbar
	local Statusbar = CreateFrame("StatusBar", nil, self)
	Statusbar:SetStatusBarTexture(cfg.statusbar_texture)
	Statusbar:GetStatusBarTexture():SetHorizTile(true)
	if self.mystyle == "player"  or self.mystyle == "target" or self.mystyle =="focus" then
		Statusbar:SetHeight(24)
	elseif self.mystyle == "tot"  or self.mystyle == "pet" or self.mystyle =="focustarget" then
		Statusbar:SetHeight(14)
	elseif self.mystyle == "party" or self.mystyle == "raid" then
		Statusbar:SetHeight(16)	
	end
	Statusbar:SetWidth(self:GetWidth())
	Statusbar:SetPoint("TOP",0,0)
	Statusbar:SetFrameLevel(4) 
	Statusbar.colorClass = true
	Statusbar.colorReaction = true

	local Shadow = MakeShadow(Statusbar)
	local Border = MakeBorder(Statusbar)
	if self.mystyle == "raid" then
		Shadow:SetPoint("TOPLEFT", -5, 5)
		Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	end

	-- BG
	local BG = Statusbar:CreateTexture(nil, "BACKGROUND")
	BG:SetTexture(cfg.statusbar_texture)
	BG:SetAllPoints(Statusbar)
	BG:SetVertexColor(0.1,0.1,0.1)
	BG.multiplier = .2

	self.Health = Statusbar
	self.Health.bg2 = BG
end
  
--gen 3D portrait func
lib.gen_portrait = function(self)
	local portrait = CreateFrame("PlayerModel", nil, self.Health)
	portrait:SetAlpha(0.3) 
	portrait.PostUpdate = function(self) 
		if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
			self:SetCamera(1)
		end	
	end
	portrait:SetAllPoints()
	portrait:SetFrameLevel(5)
	self.Portrait = portrait
	
	-- Event
	local Event = CreateFrame("Frame")
	Event:RegisterEvent("PLAYER_REGEN_DISABLED")
	Event:RegisterEvent("PLAYER_REGEN_ENABLED")
	Event:SetScript("OnEvent",function(self, event, ...)
		if event == "PLAYER_REGEN_DISABLED" then
			UIFrameFadeIn(portrait, 0.5, 0.3, 0)
		elseif event == "PLAYER_REGEN_ENABLED" then
			UIFrameFadeOut(portrait, 0.5, 0, 0.3)
		end
	end)

end

--gen powerbar func
lib.gen_ppbar = function(self)
	-- statusbar
	local Statusbar = CreateFrame("StatusBar", nil, self)
	Statusbar:SetStatusBarTexture(cfg.statusbar_texture)
	Statusbar:GetStatusBarTexture():SetHorizTile(true)
	Statusbar:SetWidth(self:GetWidth())
	if self.mystyle == "target" or self.mystyle == "player" or self.mystyle == "focus" then
		Statusbar:SetHeight(6)
		Statusbar:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
	elseif self.mystyle == "party" or self.mystyle == "raid" then
		Statusbar:SetHeight(2)
		Statusbar:SetPoint("BOTTOM",self,"BOTTOM",0,0)	
	end
	Statusbar:SetFrameLevel(1)

	local Shadow = MakeShadow(Statusbar)
	local Border = MakeBorder(Statusbar)
	
	if self.mystyle == "raid" then
		Shadow:SetPoint("TOPLEFT", -5, 5)
		Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	end
	
	-- BG
	local BG = Statusbar:CreateTexture(nil, "BACKGROUND")
	BG:SetTexture(cfg.statusbar_texture)
	BG:SetAllPoints(Statusbar)
	BG:SetVertexColor(0.2,0.2,0.2)
	
	self.Power = Statusbar
	self.Power.BG = BG
end

--gen hp strings func
lib.gen_hpstrings = function(self, unit)
	
	local level , hpval , ppval , DeadInfo
	if self.mystyle == "player" then
		level = lib.gen_fontstring(self.Health, cfg.font, 11, "THINOUTLINE")
		level:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
		self:Tag(level, "[Sora:color][name]")
		level:SetAlpha(0)
	elseif self.mystyle == "target" or self.mystyle =="focus" then
		level = lib.gen_fontstring(self.Health, cfg.font, 11, "THINOUTLINE")
		level:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
		self:Tag(level, "[Sora:level] [Sora:color][name]")
		level:SetAlpha(0)
	elseif self.mystyle == "pet" or self.mystyle == "tot" or self.mystyle == "focustarget" then
		level = lib.gen_fontstring(self.Health, cfg.font, 9, "THINOUTLINE")
		level:SetPoint("LEFT", self.Health, "LEFT", 0, 5)
		self:Tag(level, "[name]")
	elseif self.mystyle=="raid" then
		level = lib.gen_fontstring(self.Health, cfg.font, 9, "THINOUTLINE")
		level:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self:Tag(level, "[Sora:color][name]")
	elseif self.mystyle=="party" then
		level = lib.gen_fontstring(self.Health, cfg.font, 9, "THINOUTLINE")
		level:SetPoint("LEFT", self.Health, "LEFT", 5, 0)
		self:Tag(level, "[Sora:level] [Sora:color][name]")
	end

	if self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "focus" then
		hpval = lib.gen_fontstring(self.Health, cfg.font, 11, "THINOUTLINE")
		hpval:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
		self:Tag(hpval, "[Sora:color][Sora:hp]")
		hpval:SetAlpha(0)	
	elseif self.mystyle == "pet" or self.mystyle == "tot" or self.mystyle == "focustarget" then
		hpval = lib.gen_fontstring(self.Health, cfg.font, 7, "THINOUTLINE")
		hpval:SetPoint("RIGHT", self.Health, "RIGHT", 7, -5)
		self:Tag(hpval, "[Sora:hp]")
	elseif self.mystyle == "party" then
		hpval = lib.gen_fontstring(self.Health, cfg.font, 10, "THINOUTLINE")
		hpval:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
		self:Tag(hpval, "[Sora:color][Sora:hp]")
	end
	
	if self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "focus" then 
		ppval = lib.gen_fontstring(self.Power, cfg.font, 9, "THINOUTLINE")
		ppval:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
		self:Tag(ppval, "[Sora:pp]")
		ppval:SetAlpha(0)
	elseif self.mystyle == "party" then
		ppval = lib.gen_fontstring(self.Power, cfg.font, 7, "THINOUTLINE")
		ppval:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
		self:Tag(ppval, "[Sora:pp]")	
	end
	
	if self.mystyle == "raid" then
		DeadInfo = lib.gen_fontstring(self.Health, cfg.font, 7, "THINOUTLINE")
		DeadInfo:SetPoint("CENTER", self.Health, "CENTER", 0, -10)
		self:Tag(DeadInfo, "[Sora:info]")
	elseif self.mystyle == "party" then
		DeadInfo = lib.gen_fontstring(self.Health, cfg.font, 7, "THINOUTLINE")
		DeadInfo:SetPoint("CENTER", self.Health, "CENTER", 0, -10)
		self:Tag(DeadInfo, "[Sora:info]")
	end
	
	-- Event
	if self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "focus" then
		local Event = CreateFrame("Frame",nil,self.Power)
		Event:SetAllPoints(self.Power)
		Event:RegisterEvent("PLAYER_REGEN_DISABLED")
		Event:RegisterEvent("PLAYER_REGEN_ENABLED")
		Event:SetScript("OnEvent",function( _, event, ...)
			if event == "PLAYER_REGEN_DISABLED" then
				UIFrameFadeIn(level, 0.5, 0, 1)
				UIFrameFadeIn(hpval, 0.5, 0, 1)
				UIFrameFadeIn(ppval, 0.5, 0, 1)
			elseif event == "PLAYER_REGEN_ENABLED" then
				UIFrameFadeOut(level, 0.5, 1, 0)
				UIFrameFadeOut(hpval, 0.5, 1, 0)
				UIFrameFadeOut(ppval, 0.5, 1, 0)	
			end
		end)
		Event:SetScript("OnEnter",function()
			if not UnitAffectingCombat("player") then
				UIFrameFadeIn(self.Portrait, 0.5, 0.3, 0)
				UIFrameFadeIn(level, 0.5, 0, 1)
				UIFrameFadeIn(hpval, 0.5, 0, 1)
				UIFrameFadeIn(ppval, 0.5, 0, 1)
			end
		end)
		Event:SetScript("OnLeave",function()
			if not UnitAffectingCombat("player") then
				UIFrameFadeOut(self.Portrait, 0.5, 0, 0.3)
				UIFrameFadeOut(level, 0.5, 1, 0)
				UIFrameFadeOut(hpval, 0.5, 1, 0)
				UIFrameFadeOut(ppval, 0.5, 1, 0)
			end
		end)
	end
end
  
--gen combat and LFD icons
lib.gen_InfoIcons = function(self)
	local Border = CreateFrame("Frame",nil,self)
	Border:SetAllPoints(self)
	Border:SetFrameLevel(10)
	
	-- rest icon
	if self.mystyle == 'player' then
		self.Resting = Border:CreateTexture(nil, 'OVERLAY')
		self.Resting:SetSize(20,20)
		self.Resting:SetPoint("TOPRIGHT", Border, "TOPLEFT", 0, 16)
		self.Resting:SetTexture([[Interface\Addons\oUF_Karma\media\resting]])
		self.Resting:SetAlpha(0.75)
	end
	
	--Leader icon
	li = Border:CreateTexture(nil, "OVERLAY")
	li:SetPoint("TOPLEFT", self, -4, 10)
	li:SetSize(16,16)
	self.Leader = li
	
	--Assist icon
	ai = Border:CreateTexture(nil, "OVERLAY")
	ai:SetPoint("TOPLEFT", self, 0, 8)
	ai:SetSize(12,12)
	self.Assistant = ai
	
	--ML icon
	local ml = Border:CreateTexture(nil, 'OVERLAY')
	ml:SetSize(16,16)
	ml:SetPoint('LEFT', self.Leader, 'RIGHT')
	self.MasterLooter = ml
end

-- LFG Role Indicator
lib.gen_LFDRole = function(self)
	local Border = CreateFrame("Frame",nil,self)
	Border:SetAllPoints(self)
	Border:SetFrameLevel(10)
	lfdi = Border:CreateTexture(nil, "OVERLAY")
	lfdi:SetPoint('BOTTOM', self.Health, 'TOP', 15, -7)
	lfdi:SetSize(16,16)
	self.LFDRole = lfdi
end

--gen raid mark icons
lib.gen_RaidMark = function(self)
	local Border = CreateFrame("Frame", nil, self)
		Border:SetAllPoints(self)
		Border:SetFrameLevel(10)
		Border:SetAlpha(0.8)
	local ri = Border:CreateTexture(nil,'OVERLAY',Border)
	local size = 14
	ri:SetSize(size, size)
	ri:SetPoint("CENTER", self, "TOP", 0, 2)
	self.RaidIcon = ri
end
  
--gen hilight texture
lib.gen_highlight = function(self)
	local OnEnter = function(self)
		UnitFrame_OnEnter(self)
		self.Highlight:Show()
	end
	local OnLeave = function(self)
	  UnitFrame_OnLeave(self)
	  self.Highlight:Hide()
	end
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	local hl = self.Health:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(self.Health)
	hl:SetTexture(cfg.highlight_texture)
	hl:SetVertexColor(.5,.5,.5,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl
end
	
-- Create Raid Threat Status Border
function lib.CreateThreatBorder(self)
	
	local glowBorder = {edgeFile = cfg.GlowTex, edgeSize = 3}
	self.Thtborder = CreateFrame("Frame", nil, self)
	self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
	self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
	self.Thtborder:SetBackdrop(glowBorder)
	self.Thtborder:SetFrameLevel(1)
	self.Thtborder:Hide()
	
end
  
-- Raid Frames Threat Highlight
function lib.UpdateThreat(self, event, unit)

	if self.unit ~= unit then return end
	
	local status = UnitThreatSituation(unit)
	unit = unit or self.unit
	
	if status and status > 1 then
		local r, g, BG = GetThreatStatusColor(status)
		self.Thtborder:Show()
		self.Thtborder:SetBackdropBorderColor(r, g, BG, 1)
	else
		self.Thtborder:SetBackdropBorderColor(r, g, BG, 0)
		self.Thtborder:Hide()
	end
end
	
  
--gen castbar
local PostCastStart = function(castbar, unit)
    if unit ~= 'player' then
        if castbar.interrupt then
            castbar.Backdrop:SetBackdropBorderColor(1, .9, .4)
            castbar.Backdrop:SetBackdropColor(1, .9, .4)
        else
            castbar.Backdrop:SetBackdropBorderColor(0, 0, 0)
            castbar.Backdrop:SetBackdropColor(0, 0, 0)
        end
    end
end

--gen castbar
lib.gen_castbar = function(self)
	if not cfg.ShowCastbar then return end
	
	local cbColor = {95/255, 182/255, 255/255}
	local Statusbar = CreateFrame("StatusBar", "oUF_NevoCastbar"..self.mystyle, self)
	Statusbar:SetHeight(9)
	Statusbar:SetWidth(self:GetWidth())
	
	if self.mystyle == "player" then
		if cfg.CastbarAlone then
			Statusbar:SetHeight(20)
			Statusbar:SetPoint("BOTTOMLEFT",MultiBarBottomRightButton1,"TOPLEFT", -3, 10)
			Statusbar:SetPoint("BOTTOMRIGHT",MultiBarBottomRightButton12,"TOPRIGHT",-25, 10)			
		else
			Statusbar:SetWidth(self:GetWidth()-70)
			Statusbar:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",0, -15)
		end
	elseif self.mystyle == "target" then
		Statusbar:SetWidth(self:GetWidth()-70)
		Statusbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -15)
	elseif self.mystyle == "focus" then
		Statusbar:SetWidth(self:GetWidth()-70)
		Statusbar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 13)
	end
	
	Statusbar:SetStatusBarTexture(cfg.statusbar_texture)
	Statusbar:SetStatusBarColor(95/255, 182/255, 255/255,1)
	Statusbar:SetFrameStrata("HIGH")
	
	--color
	Statusbar.CastingColor = cbColor
	Statusbar.CompleteColor = {20/255, 208/255, 0/255}
	Statusbar.FailColor = {255/255, 12/255, 0/255}
	Statusbar.ChannelingColor = cbColor
	
	--Border
	local Border = CreateFrame("Frame", nil, Statusbar)
	Border:SetFrameLevel(0)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	lib.gen_castbackdrop(Border)
	
	--spell text
	local txt = lib.gen_fontstring(Statusbar, cfg.font, 10, "THINOUTLINE")
	txt:SetPoint("LEFT", 2, 0)
	txt:SetJustifyH("LEFT")
	
	--time
	local t = lib.gen_fontstring(Statusbar, cfg.font, 10, 'THINOUTLINE')
	t:SetPoint("RIGHT", -2, 0)
	txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
	
	--icon
	local i = Statusbar:CreateTexture(nil, "ARTWORK")
	i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	i:SetSize(20,20)
	if self.mystyle == "player" then 
		i:SetPoint("BOTTOMLEFT", Statusbar, "BOTTOMRIGHT", 8, 0)
	elseif self.mystyle == "target" then
		i:SetPoint("BOTTOMRIGHT", Statusbar, "BOTTOMLEFT", -8, 0)
	elseif self.mystyle == "focus" then 
		i:SetPoint("TOPLEFT", Statusbar, "TOPRIGHT", 8, 0)
	end
	
	--helper2 for icon
	local h2 = CreateFrame("Frame", nil, Statusbar)
	h2:SetFrameLevel(0)
	h2:SetPoint("TOPLEFT",i,"TOPLEFT", -1, 1)
	h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT", 1, -1)
	lib.gen_backdrop(h2)
	if self.mystyle == "player" then
		--latency (only for player unit)
		local z = Statusbar:CreateTexture(nil,"OVERLAY")
		z:SetTexture(cfg.statusbar_texture)
		z:SetVertexColor(1,0.1,0,.6)
		z:SetPoint("TOPRIGHT")
		z:SetPoint("BOTTOMRIGHT")
		Statusbar:SetFrameLevel(1)
		Statusbar.SafeZone = z
		-- custom latency display
		local l = lib.gen_fontstring(Statusbar, cfg.font, 10, "THINOUTLINE")
		l:SetPoint("CENTER", -2, 17)
		l:SetJustifyH("RIGHT")
		l:Hide()
		Statusbar.Lag = l
		self:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
	end
	Statusbar.OnUpdate = cast.OnCastbarUpdate
	Statusbar.PostCastStart = cast.PostCastStart
	Statusbar.PostChannelStart = cast.PostCastStart
	Statusbar.PostCastStop = cast.PostCastStop
	Statusbar.PostChannelStop = cast.PostChannelStop
	Statusbar.PostCastFailed = cast.PostCastFailed
	Statusbar.PostCastInterrupted = cast.PostCastFailed

	self.Castbar = Statusbar
	self.Castbar.Text = txt
	self.Castbar.Time = t
	self.Castbar.Icon = i
end

-- Post Create Icon Function
local myPostCreateIcon = function(self, button)

	self.showDebuffType = false
	self.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	button.icon:SetTexCoord(.07, .93, .07, .93)
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)	
	
	button.time = lib.gen_fontstring(button, cfg.smallfont, 9, "OUTLINE")
	button.time:SetPoint("BOTTOM", button, 1, -5)
	button.time:SetVertexColor(1,1,1)
	
	button.count = lib.gen_fontstring(button, cfg.smallfont, 9, "OUTLINE")
	button.count:ClearAllPoints()
	button.count:SetPoint("TOPRIGHT", button, 3, 0)
	button.count:SetJustifyH('RIGHT')
	button.count:SetVertexColor(1,1,1)	
	
	local Shadow = MakeShadow(button)
	Shadow:ClearAllPoints()
	Shadow:SetPoint("TOPLEFT", 1, 0)
	Shadow:SetPoint("BOTTOMRIGHT", 5, -5)
	local Border = MakeBorder(button)
end
  
-- Post Update Icon Function
local myPostUpdateIcon = function(self, unit, icon, index, offset, filter, isDebuff)

	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	
	if duration and duration > 0 then
		icon.time:Show()
		icon.timeLeft = expirationTime	
		icon:SetScript("OnUpdate", CreateBuffTimer)			
	else
		icon.time:Hide()
		icon.timeLeft = math.huge
		icon:SetScript("OnUpdate", nil)
	end
		
	-- Desaturate non-Player Debuffs
	if icon.debuff then
		if unit == "target" then	
			if unitCaster == 'player' or unitCaster == 'vehicle' then
				icon.icon:SetDesaturated(false)                 
			elseif not UnitPlayerControlled(unit) then -- If Unit is Player Controlled don't desaturate debuffs
				icon:SetBackdropColor(0, 0, 0)
				icon.overlay:SetVertexColor(0.3, 0.3, 0.3)      
				icon.icon:SetDesaturated(true)  
			end
		end
	end
	
	-- Right Click Cancel Buff/Debuff
	icon:SetScript('OnMouseUp', function(self, mouseButton)
		if mouseButton == 'RightButton' then
			CancelUnitBuff('player', index)
	end end)
	
	icon.first = true
end
  
-- Generates the Buffs
lib.createBuffs = function(self)
	Buff = CreateFrame("Frame", nil, self)
	Buff.onlyShowPlayer = cfg.BuffOnlyShowPlayer
	if self.mystyle == "target" then
		Buff:SetPoint("TOPLEFT", self, "TOPRIGHT", 12, 0)
		Buff.initialAnchor = "TOPLEFT"
		Buff["growth-x"] = "RIGHT"
		Buff["growth-y"] = "DOWN"
		Buff.size = 20
		Buff.num = 18
		Buff.spacing = 5
		Buff:SetWidth((Buff.size+Buff.spacing)*6-Buff.spacing)
		Buff:SetHeight((Buff.size+Buff.spacing)*3)
	elseif self.mystyle == "focus" then
		Buff:SetPoint("TOPRIGHT", self, "TOPLEFT", -12, 0)
		Buff.initialAnchor = "TOPRIGHT"
		Buff["growth-x"] = "LEFT"
		Buff["growth-y"] = "DOWN"
		Buff.size = 20
		Buff.num = 18
		Buff.spacing = 5
		Buff:SetWidth((Buff.size+Buff.spacing)*6-Buff.spacing)
		Buff:SetHeight((Buff.size+Buff.spacing)*3)
	end
	Buff.PostCreateIcon = myPostCreateIcon
	Buff.PostUpdateIcon = myPostUpdateIcon

	self.Buffs = Buff
end

-- Generates the Debuffs
lib.createDebuffs = function(self)

	Debuff = CreateFrame("Frame", nil, self)
	Debuff.size = 20
	Debuff.num = 40
	Debuff.onlyShowPlayer = cfg.DebuffOnlyShowPlayer
	Debuff.spacing = 5
	Debuff:SetHeight((Debuff.size+Debuff.spacing)*5)
	Debuff:SetWidth(self:GetWidth())
	if self.mystyle == "target" then
		Debuff:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -30)
	elseif self.mystyle == "focus" then
		Debuff:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -10)
	elseif self.mystyle == "party" then
		Debuff:SetPoint("TOPLEFT", self.Power, "BOTTOMLEFT", 0, -5)
	end
	Debuff.initialAnchor = "TOPLEFT"
	Debuff["growth-x"] = "RIGHT"
	Debuff["growth-y"] = "DOWN"
	Debuff.PostCreateIcon = myPostCreateIcon
	Debuff.PostUpdateIcon = myPostUpdateIcon

	self.Debuffs = Debuff
end
 
-- raid post update
lib.PostUpdateRaidFrame = function(Health, unit, min, max)

	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	if disconnnected or dead or ghost then
		Health:SetValue(max)
		
		if disconnnectedthen then
			Health:SetStatusBarColor(0,0,0,0.7)
		elseif ghost then
			Health:SetStatusBarColor(0,0,0,0.7)
		elseif dead then
			Health:SetStatusBarColor(0,0,0,0.7)
	end
	else
		Health:SetValue(min)
		if unit == 'vehicle' then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
end

-- ReadyCheck
lib.ReadyCheck = function(self)
	if cfg.RCheckIcon then
		rCheck = self.Health:CreateTexture(nil, "OVERLAY")
		rCheck:SetSize(14, 14)
		rCheck:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self.ReadyCheck = rCheck
	end
end

-- raid debuffs
lib.raidDebuffs = function(self)
	if cfg.showRaidDebuffs then
		self:SetBackdrop(backdrop)
		self:SetBackdropColor(0, 0, 0)

		self:SetScript("OnEnter", UnitFrame_OnEnter)
		self:SetScript("OnLeave", UnitFrame_OnLeave)

		self:RegisterForClicks("AnyUp")
		
		self.RaidDebuffs = CreateFrame("Frame", nil, self)
		self.RaidDebuffs:SetHeight(18)
		self.RaidDebuffs:SetWidth(18)
		self.RaidDebuffs:SetPoint("CENTER", self)
		self.RaidDebuffs:SetFrameStrata("HIGH")

		self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, "OVERLAY")
		self.RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		self.RaidDebuffs.icon:SetAllPoints(self.RaidDebuffs)
		
		self.RaidDebuffs.time = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
		self.RaidDebuffs.time:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
		self.RaidDebuffs.time:SetPoint("CENTER", self.RaidDebuffs, "CENTER", 0, 0)
		self.RaidDebuffs.time:SetTextColor(1, .9, 0)

		self.RaidDebuffs.count = self.RaidDebuffs:CreateFontString(nil, "OVERLAY")
		self.RaidDebuffs.count:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
		self.RaidDebuffs.count:SetPoint("BOTTOMRIGHT", self.RaidDebuffs, "BOTTOMRIGHT", 2, 0)
		self.RaidDebuffs.count:SetTextColor(1, .9, 0)	
	end
end

-- AuraWatch
local AWPostCreateIcon = function(AWatch, icon, spellID, name, self)
	icon.cd:SetReverse()
	local count = lib.gen_fontstring(icon, cfg.smallfont, 12, "OUTLINE")
	count:SetPoint("CENTER", icon, "BOTTOM", 3, 3)
	icon.count = count
	local Border = CreateFrame("Frame", nil, icon)
	Border:SetFrameLevel(4)
	Border:SetPoint("TOPLEFT", -1, 1)
	Border:SetPoint("BOTTOMRIGHT", 1, -1)
	lib.gen_backdrop(Border)
end
lib.createAuraWatch = function(self, unit)
	if cfg.showAuraWatch then
		local auras = {}
		local spellIDs = {
			DEATHKNIGHT = {
			},
			DRUID = {
				33763, -- Lifebloom
				8936, -- Regrowth
				774, -- Rejuvenation
				48438, -- Wild Growth
			},
			HUNTER = {
				34477, -- Misdirection
			},
			MAGE = {
				54646, -- Focus Magic
			},
			PALADIN = {
				53563, -- Beacon of Light
				25771, -- Forbearance
			},
			PRIEST = { 
				17, -- Power Word: Shield
				139, -- Renew
				33076, -- Prayer of Mending
				6788, -- Weakened Soul
			},
			ROGUE = {
				57934, -- Tricks of the Trade
			},
			SHAMAN = {
				974, -- Earth Shield
				61295, -- Riptide
			},
			WARLOCK = {
				20707, -- Soulstone Resurrection
			},
			WARRIOR = {
				50720, -- Vigilance
			},
		}
		
		auras.onlyShowPresent = true
		auras.anyUnit = true
		auras.PostCreateIcon = AWPostCreateIcon
		-- Set any other AuraWatch settings
		auras.icons = {}

		for i, sid in pairs(spellIDs[playerClass]) do
			local icon = CreateFrame("Frame", nil, self)
			icon.spellID = sid
			-- set the dimensions and positions
			icon:SetWidth(12)
			icon:SetHeight(12)
			icon:SetFrameLevel(5)
			if i == 1 then
				icon:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
			elseif i == 2 then
				icon:SetPoint("TOPRIGHT", self, "TOPRIGHT", 1, 1)
			elseif i == 3 then
				icon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", -1, -1)
			elseif i == 4 then
				icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
			end
			
			auras.icons[sid] = icon
		end
		self.AuraWatch = auras
	end
end

--hand the lib to the namespace for further usage
ns.lib = lib