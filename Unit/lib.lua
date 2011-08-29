local addon, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg
local cast = ns.cast
local lib = CreateFrame("Frame")  
local _, playerClass = UnitClass("player")
    
  -- FUNCTIONS
 
 local retVal = function(f, val1, val2, val3)
	if f.mystyle == "player" or f.mystyle == "target" then
		return val1
	elseif f.mystyle == "raid" or f.mystyle == "party" then
		return val3
	else
		return val2
	end
end
  
  --status bar filling fix (from oUF_Mono)
  local fixStatusbar = function(b)
    b:GetStatusBarTexture():SetHorizTile(false)
    b:GetStatusBarTexture():SetVertTile(false)
  end

  --backdrop table
  local backdrop_tab = { 
    bgFile = cfg.backdrop_texture, 
    edgeFile = cfg.backdrop_edge_texture,
    tile = false,
    tileSize = 0, 
    edgeSize = 5, 
    insets = { 
      left = 3, 
      right = 3, 
      top = 3, 
      bottom = 3,
    },
  }
  
-- backdrop func
lib.gen_backdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,1)
	f:SetBackdropBorderColor(0,0,0,0.8)
end

lib.gen_castbackdrop = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,1)
end
  
lib.gen_totemback = function(f)
	f:SetBackdrop(backdrop_tab);
	f:SetBackdropColor(0,0,0,0.6)
	f:SetBackdropBorderColor(0,0,0,0.8)
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
  lib.gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, outline)
    fs:SetShadowColor(0,0,0,0.8)
    fs:SetShadowOffset(1,-1)
    return fs
  end  
  
  --gen healthbar func
  lib.gen_hpbar = function(f)
    --statusbar
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(cfg.statusbar_texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetHeight(retVal(f,24,24,20))
	if f.mystyle == "tot"  or f.mystyle == "pet" or f.mystyle =="focustarget" then
		s:SetHeight(14)
	end
    s:SetWidth(f:GetWidth())
    s:SetPoint("TOP",0,0)
    s:SetFrameLevel(4) 
	s.colorClass = true
	s.colorReaction = true

	--helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(3)
    h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT", 5, -5)
    lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.statusbar_texture)
    b:SetAllPoints(s)
	b:SetVertexColor(0.1,0.1,0.1)
	b.multiplier = .2
	
	f.Health = s
	f.Health.bg2 = b
  end
  
  --gen hp strings func
lib.gen_hpstrings = function(f, unit)
    --creating helper frame here so our font strings don't inherit healthbar parameters
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f.Health)
    h:SetFrameLevel(15)
	
	local level , hpval , ppval , DeadInfo
	if f.mystyle == "player" and cfg.ShowPlayerName then
		level = lib.gen_fontstring(f.Health, cfg.font, 12, "THINOUTLINE")
		level:SetPoint("LEFT", f.Health, "LEFT", 0, 0)
		f:Tag(level, " [karma:level] [karma:color][name][karma:afkdnd]")
	elseif f.mystyle =="target" or f.mystyle =="focus"  then
		level = lib.gen_fontstring(f.Health, cfg.font, 12, "THINOUTLINE")
		level:SetPoint("LEFT", f.Health, "LEFT", 0, 0)
		f:Tag(level, " [karma:level] [karma:color][name]")
	elseif f.mystyle == "pet" or f.mystyle == "tot" or f.mystyle == "focustarget" then
		level = lib.gen_fontstring(f.Health, cfg.font, 10, "THINOUTLINE")
		level:SetPoint("LEFT", f.Health, "LEFT", 0, 5)
		f:Tag(level, "[name]")
	elseif f.mystyle=="raid" then
		level = lib.gen_fontstring(f.Health, cfg.font, 10, "THINOUTLINE")
		level:SetPoint("CENTER", f.Health, "CENTER", 0, 0)
		f:Tag(level, "[karma:color][name]")
	end

	if f.mystyle == "player" or f.mystyle == "target" or f.mystyle == "focus"  then
		hpval = lib.gen_fontstring(f.Health, cfg.font, 12, "THINOUTLINE")
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", 0, 0)
		f:Tag(hpval, "[karma:color][karma:hp] ")
	elseif f.mystyle == "pet" or f.mystyle == "tot" or f.mystyle == "focustarget" then
		hpval = lib.gen_fontstring(f.Health, cfg.font, 8, "THINOUTLINE")
		hpval:SetPoint("RIGHT", f.Health, "RIGHT", 7, -7)
		f:Tag(hpval, "[karma:hp] ")
	end
	
	if f.mystyle == "player" or f.mystyle == "target" or f.mystyle == "focus" then
		ppval = lib.gen_fontstring(f.Health, cfg.font, 9, "THINOUTLINE")
		ppval:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 3, -1)
		f:Tag(ppval, "[karma:pp]")
	end
	
	if f.mystyle =="raid" then
		DeadInfo = lib.gen_fontstring(f.Health, cfg.font, 8, "THINOUTLINE")
		DeadInfo:SetPoint("CENTER", f.Health, "CENTER", 0, -10)
		f:Tag(DeadInfo, "[karma:info]")
	end
end
  
  --gen powerbar func
  lib.gen_ppbar = function(f)
    --statusbar
	local s = CreateFrame("StatusBar", nil, f)
	s:SetStatusBarTexture(cfg.powerbar_texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	s:SetWidth(f:GetWidth())
	if f.mystyle == "target" or f.mystyle == "player" or f.mystyle == "focus" then
		s:SetHeight(12)
		s:SetPoint("TOP",f,"BOTTOM",4,3)
	elseif f.mystyle == "raid" then
		s:SetHeight(3)
		s:SetPoint("TOP",f,"BOTTOM",0,2)	
	end
	s:SetFrameLevel(1)
	--helper
	local h = CreateFrame("Frame", nil, s)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
    --bg
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(cfg.powerbar_texture)
    b:SetAllPoints(s)
    f.Power = s
    f.Power.bg = b
  end
  
  --gen combat and LFD icons
  lib.gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
	-- rest icon
    if f.mystyle == 'player' then
		f.Resting = h:CreateTexture(nil, 'OVERLAY')
		f.Resting:SetSize(20,20)
		f.Resting:SetPoint('TOPLEFT', -8, 16)
		f.Resting:SetTexture([[Interface\Addons\oUF_Karma\media\resting]])
		f.Resting:SetAlpha(0.75)
	end
    --Leader icon
    li = h:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, -4, 10)
    li:SetSize(16,16)
    f.Leader = li
    --Assist icon
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 8)
    ai:SetSize(12,12)
    f.Assistant = ai
    --ML icon
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:SetSize(16,16)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
  end

-- LFG Role Indicator
lib.gen_LFDRole = function(f)
	local h = CreateFrame("Frame",nil,f)
	h:SetAllPoints(f)
	h:SetFrameLevel(10)
	lfdi = h:CreateTexture(nil, "OVERLAY")
	lfdi:SetPoint('BOTTOM', f.Health, 'TOP', 15, -7)
	lfdi:SetSize(16,16)
	f.LFDRole = lfdi
end

	--gen raid mark icons
  lib.gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(0.8)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f, "TOP", 0, 2)
	local size = retVal(f, 16, 13, 12)
    ri:SetSize(size, size)
    f.RaidIcon = ri
  end
  
    --gen hilight texture
  lib.gen_highlight = function(f)
    local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
    end
    local OnLeave = function(f)
      UnitFrame_OnLeave(f)
      f.Highlight:Hide()
    end
    f:SetScript("OnEnter", OnEnter)
    f:SetScript("OnLeave", OnLeave)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(f.Health)
    hl:SetTexture(cfg.highlight_texture)
    hl:SetVertexColor(.5,.5,.5,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
  end
	
	-- Create Raid Threat Status Border
	function lib.CreateThreatBorder(self)
		
		local glowBorder = {edgeFile = cfg.backdrop_edge_texture, edgeSize = 5}
		self.Thtborder = CreateFrame("Frame", nil, self)
		self.Thtborder:SetPoint("TOPLEFT", self, "TOPLEFT", -6, 6)
		self.Thtborder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 6, -6)
		self.Thtborder:SetBackdrop(glowBorder)
		self.Thtborder:SetFrameLevel(1)
		self.Thtborder:Hide()	
	end
  
  	-- Raid Frames Threat Highlight
	function lib.UpdateThreat(self, event, unit)
	
		if (self.unit ~= unit) then return end
		
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Thtborder:Show()
			self.Thtborder:SetBackdropBorderColor(r, g, b, 1)
		else
			self.Thtborder:SetBackdropBorderColor(r, g, b, 0)
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

local CustomTimeText = function(castbar, duration)
    if castbar.casting then
        castbar.Time:SetFormattedText("%.1f / %.1f", duration, castbar.max)
    elseif castbar.channeling then
        castbar.Time:SetFormattedText("%.1f / %.1f", castbar.max - duration, castbar.max)
    end
end

  --gen castbar
  lib.gen_castbar = function(f)
	if not cfg.Castbars then return end
	local cbColor = {95/255, 182/255, 255/255}
    local s = CreateFrame("StatusBar", "oUF_NevoCastbar"..f.mystyle, f)
    s:SetHeight(10)
    s:SetWidth(f:GetWidth()+2)
    if f.mystyle == "player" then
		s:SetWidth(f:GetWidth()-70)
		s:SetPoint("TOPRIGHT",f,"BOTTOMRIGHT",0, -16)
	elseif f.mystyle == "target" then
		s:SetWidth(f:GetWidth()-70)
		s:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -18)
	elseif f.mystyle == "focus" then
		s:SetWidth(f:GetWidth()-70)
		s:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", 0, 10)
	elseif f.mystyle == "focus" then
		s:SetPoint("BOTTOM",f,"TOP",15,10)
	else
		s:SetPoint("BOTTOM",f,"TOP",15,42)
    end
    s:SetStatusBarTexture(cfg.statusbar_texture)
    s:SetStatusBarColor(95/255, 182/255, 255/255,1)
	s:SetFrameLevel(9)
    --color
    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor
    --helper
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
    lib.gen_castbackdrop(h)
    --spark
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetTexture(spark)
	sp:SetBlendMode("ADD")
	sp:SetVertexColor(1, 1, 1, 1)
    sp:SetHeight(s:GetHeight()*2.5)
    sp:SetWidth(s:GetWidth()/18)
    --spell text
    local txt = lib.gen_fontstring(s, cfg.font, 12, "THINOUTLINE")
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    --time
    local t = lib.gen_fontstring(s, cfg.font, 12, 'THINOUTLINE')
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    --icon
    local i = s:CreateTexture(nil, "ARTWORK")
	i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	i:SetSize(20,20)
	if f.mystyle == "player" then 
		i:SetPoint("LEFT", s, "RIGHT", 8, 4)
	elseif f.mystyle == "target" then
		i:SetPoint("RIGHT", s, "LEFT", -8, 4)
	elseif f.mystyle == "focus" then 
		i:SetPoint("LEFT", s, "RIGHT", 8, -4)
	end
    --helper2 for icon
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
    lib.gen_backdrop(h2)
    if f.mystyle == "player" then
      --latency (only for player unit)
      local z = s:CreateTexture(nil,"OVERLAY")
      z:SetTexture(cfg.statusbar_texture)
      z:SetVertexColor(1,0.1,0,.6)
      z:SetPoint("TOPRIGHT")
      z:SetPoint("BOTTOMRIGHT")
	  s:SetFrameLevel(1)
      s.SafeZone = z
      -- custom latency display
      local l = lib.gen_fontstring(s, cfg.font, 10, "THINOUTLINE")
      l:SetPoint("CENTER", -2, 17)
      l:SetJustifyH("RIGHT")
	  l:Hide()
      s.Lag = l
      f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
    end
    s.OnUpdate = cast.OnCastbarUpdate
    s.PostCastStart = cast.PostCastStart
    s.PostChannelStart = cast.PostCastStart
    s.PostCastStop = cast.PostCastStop
    s.PostChannelStop = cast.PostChannelStop
    s.PostCastFailed = cast.PostCastFailed
    s.PostCastInterrupted = cast.PostCastFailed
	
    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
  end
  
  	-- Post Create Icon Function
	local myPostCreateIcon = function(self, button)
	
		self.showDebuffType = true
		self.disableCooldown = true
		button.cd.noOCC = true
		button.cd.noCooldownCount = true

		button.icon:SetTexCoord(.07, .93, .07, .93)
		button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
		button.overlay:SetTexture(cfg.debuffBorder)
		button.overlay:SetTexCoord(0,1,0,1)
		button.overlay.Hide = function(self) self:SetVertexColor(0.3, 0.3, 0.3) end
		
		
		button.time = lib.gen_fontstring(button, cfg.smallfont, 12, "OUTLINE")
		button.time:SetPoint("BOTTOM", button, 2, -6)
		button.time:SetJustifyH('CENTER')
		button.time:SetVertexColor(1,1,1)
		
		button.count = lib.gen_fontstring(button, cfg.smallfont, 15, "OUTLINE")
		button.count:ClearAllPoints()
		button.count:SetPoint("TOPRIGHT", button, 5, 3)
		button.count:SetJustifyH('RIGHT')
		button.count:SetVertexColor(1,1,1)	
		
    --helper
		local h = CreateFrame("Frame", nil, button)
		h:SetFrameLevel(0)
		h:SetPoint("TOPLEFT",-5,5)
		h:SetPoint("BOTTOMRIGHT",5,-5)
		lib.gen_backdrop(h)
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
	if(icon.debuff) then
		if(unit == "target") then	
			if (unitCaster == 'player' or unitCaster == 'vehicle') then
				icon.icon:SetDesaturated(false)                 
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don't desaturate debuffs
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

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		if s <= minute * 5 then
			return format("%d:%02d", floor(s/60), s % minute), s - floor(s)
		end
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

-- Create Buff/Debuff Timer Function 
function CreateBuffTimer(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		if not self.first then
			self.timeLeft = self.timeLeft - self.elapsed
		else
			self.timeLeft = self.timeLeft - GetTime()
			self.first = false
		end
			
		if self.timeLeft > 0 and self.timeLeft <= 60*15 then -- Show time between 0 and 15 min
			local time = FormatTime(self.timeLeft)
			self.time:SetText(time)								
			if self.timeLeft >= 6 and self.timeLeft <= 60*5 then -- if Between 5 min and 6sec
				self.time:SetTextColor(0.95,0.95,0.95)
			elseif self.timeLeft > 3 and self.timeLeft < 6 then -- if Between 6sec and 3sec
				self.time:SetTextColor(0.95,0.70,0)
			elseif self.timeLeft <= 3 then -- Below 3sec
				self.time:SetTextColor(0.9, 0.05, 0.05)					
			else 
				self.time:SetTextColor(0.95,0.95,0.95) -- Fallback Color		
			end
		else
			self.time:Hide()
		end
		self.elapsed = 0
	end
end
  
-- Generates the Buffs
  lib.createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.onlyShowPlayer = cfg.buffsOnlyShowPlayer
    if f.mystyle == "target" then
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", 12, 0)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
		b.size = 20
		b.num = 18
		b.spacing = 5
		b:SetWidth((b.size+b.spacing)*6-b.spacing)
		b:SetHeight((b.size+b.spacing)*3)
    elseif f.mystyle == "player" then
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -5, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.size = 20
		b.num = 40
		b.spacing = 5
		b:SetHeight((b.size+b.spacing)*4)
		b:SetWidth(f:GetWidth())
	else
		b.num = 0
    end
    b.PostCreateIcon = myPostCreateIcon
    b.PostUpdateIcon = myPostUpdateIcon

    f.Buffs = b
  end

-- Generates the Debuffs
  lib.createDebuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
	b.num = 40
	b.onlyShowPlayer = cfg.debuffsOnlyShowPlayer
    b.spacing = 5
    b:SetHeight((b.size+b.spacing)*5)
    b:SetWidth(f:GetWidth())
    b:SetPoint("TOPLEFT", f.Power, "BOTTOMLEFT", 0, -30)
    b.initialAnchor = "TOPLEFT"
    b["growth-x"] = "RIGHT"
    b["growth-y"] = "DOWN"
    b.PostCreateIcon = myPostCreateIcon
    b.PostUpdateIcon = myPostUpdateIcon

    f.Debuffs = b
  end
 
-- raid post update
lib.PostUpdateRaidFrame = function(Health, unit, min, max)

	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	if disconnnected or dead or ghost then
		Health:SetValue(max)
		
		if(disconnnected) then
			Health:SetStatusBarColor(0,0,0,0.7)
		elseif(ghost) then
			Health:SetStatusBarColor(0,0,0,0.7)
		elseif(dead) then
			Health:SetStatusBarColor(0,0,0,0.7)
	end
	else
		Health:SetValue(min)
		if(unit == 'vehicle') then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
end

-- Eclipse Bar function
local eclipseBarBuff = function(self, unit)
	if self.hasSolarEclipse then
		self.eBarBG:SetBackdropBorderColor(1,1,.5,.7)
	elseif self.hasLunarEclipse then
		self.eBarBG:SetBackdropBorderColor(.2,.2,1,.7)
	else
		self.eBarBG:SetBackdropBorderColor(0,0,0,1)
	end
end

lib.addEclipseBar = function(self)
	if playerClass ~= "DRUID" then return end
	
	local eclipseBar = CreateFrame('Frame', nil, self)
	eclipseBar:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 2)
	eclipseBar:SetHeight(4)
	eclipseBar:SetWidth(self.Health:GetWidth())
	eclipseBar:SetFrameLevel(4)
	local h = CreateFrame("Frame", nil, eclipseBar)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	lib.gen_backdrop(h)
	eclipseBar.eBarBG = h

	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	lunarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	lunarBar:SetStatusBarTexture(cfg.statusbar_texture)
	lunarBar:SetStatusBarColor(0, .1, .7)
	lunarBar:SetFrameLevel(5)

	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	solarBar:SetSize(eclipseBar:GetWidth(), eclipseBar:GetHeight())
	solarBar:SetStatusBarTexture(cfg.statusbar_texture)
	solarBar:SetStatusBarColor(1,1,.13)
	solarBar:SetFrameLevel(5)

    local EBText = lib.gen_fontstring(solarBar, cfg.font, 10, "OUTLINE")
	EBText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 0)
	self:Tag(EBText, '[pereclipse]')
	
	eclipseBar.SolarBar = solarBar
	eclipseBar.LunarBar = lunarBar
	self.EclipseBar = eclipseBar
	self.EclipseBar.PostUnitAura = eclipseBarBuff
end

-- SoulShard bar
lib.genShards = function(self)
	if playerClass ~= "WARLOCK" then return end
			local ssOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end
				local ss = self.SoulShards
				local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
				for i = 1, SHARD_BAR_NUM_SHARDS do
					if(i <= num) then
						ss[i]:SetAlpha(1)
					else
						ss[i]:SetAlpha(0.2)
					end
				end
			end
			
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		barFrame:SetHeight(8)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)

		for i= 1, 3 do
			local shard = CreateFrame("StatusBar", nil, barFrame)
			shard:SetSize((self.Health:GetWidth() / 3)-6, 8)
			shard:SetStatusBarTexture(cfg.statusbar_texture)
			shard:SetStatusBarColor(.86,.44, 1)
			shard:SetFrameLevel(4)
				
			local h = CreateFrame("Frame", nil, shard)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)

		if (i == 1) then
			shard:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 5)
		else
			shard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 6, 0)
		end
		barFrame[i] = shard
	end
	self.SoulShards = barFrame
	self.SoulShards.Override = ssOverride
			
end			

-- HolyPowerbar
lib.genHolyPower = function(self)
	if playerClass ~= "PALADIN" then return end
		local hpOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end
				
				local hp = self.HolyPower
				if(hp.PreUpdate) then hp:PreUpdate(unit) end
				
				local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
				for i = 1, MAX_HOLY_POWER do
					if(i <= num) then
						hp[i]:SetAlpha(1)
					else
						hp[i]:SetAlpha(0.2)
					end
				end
			end
			
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
		barFrame:SetHeight(8)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)

		for i = 1, 3 do
			local holyShard = CreateFrame("StatusBar", self:GetName().."_Holypower"..i, self)
			holyShard:SetHeight(8)
			holyShard:SetWidth((self.Health:GetWidth() / 3)-6, 6)
			holyShard:SetStatusBarTexture(cfg.statusbar_texture)
			holyShard:SetStatusBarColor(.9,.95,.33)
			holyShard:SetFrameLevel(4)
				
			local h = CreateFrame("Frame", nil, holyShard)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)
			
			if (i == 1) then
				holyShard:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 6)
			else
				holyShard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 6, 0)
			end
			barFrame[i] = holyShard
	end
	self.HolyPower = barFrame
	self.HolyPower.Override = hpOverride
end

-- runebar
lib.genRunes = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end

	local runeFrame = CreateFrame("Frame", nil, self)
	runeFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
	runeFrame:SetHeight(8)
	runeFrame:SetWidth(self:GetWidth())
	runeFrame:SetFrameLevel(4)
	
	for i= 1, 6 do
		local rune = CreateFrame("StatusBar", nil, runeFrame)
		rune:SetSize((self.Health:GetWidth() / 6)-6, 6)
		rune:SetStatusBarTexture(cfg.statusbar_texture)
		rune:SetFrameLevel(8)
		
			local h = CreateFrame("Frame", nil, rune)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)

			if (i == 1) then
				rune:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 3, 6)
			else
				rune:SetPoint("TOPLEFT", runeFrame[i-1], "TOPRIGHT", 6, 0)
			end

		runeFrame[i] = rune
	end
	self.Runes = runeFrame
end

-- ReadyCheck
lib.ReadyCheck = function(self)
	if cfg.RCheckIcon then
		rCheck = self.Health:CreateTexture(nil, "OVERLAY")
		rCheck:SetSize(14, 14)
		rCheck:SetPoint("BOTTOMLEFT", self.Health, "TOPRIGHT", -13, -12)
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

		self:RegisterForClicks"AnyUp"
		
		self.RaidDebuffs = CreateFrame('Frame', nil, self)
		self.RaidDebuffs:SetHeight(20)
		self.RaidDebuffs:SetWidth(20)
		self.RaidDebuffs:SetPoint('CENTER', self)
		self.RaidDebuffs:SetFrameStrata'HIGH'

		self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		self.RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		self.RaidDebuffs.icon:SetAllPoints(self.RaidDebuffs)
			
		local overlay = self.RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		overlay:SetTexture("Interface\\AddOns\\NevoUI\\UnitFrame\\media\\iconborder")
		overlay:SetPoint('TOPLEFT', self.RaidDebuffs, -1, 1)
		overlay:SetPoint('BOTTOMRIGHT', self.RaidDebuffs, 1, -1)
		
		self.RaidDebuffs.time = self.RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		self.RaidDebuffs.time:SetFont(STANDARD_TEXT_FONT, 12, 'THINOUTLINE')
		self.RaidDebuffs.time:SetPoint('CENTER', self.RaidDebuffs, 'CENTER', 0, 0)
		self.RaidDebuffs.time:SetTextColor(1, .9, 0)

		self.RaidDebuffs.count = self.RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		self.RaidDebuffs.count:SetFont(STANDARD_TEXT_FONT, 8, 'OUTLINE')
		self.RaidDebuffs.count:SetPoint('BOTTOMRIGHT', self.RaidDebuffs, 'BOTTOMRIGHT', 2, 0)
		self.RaidDebuffs.count:SetTextColor(1, .9, 0)	
	end
end

-- oUF_HealPred
lib.HealPred = function(self)
	if not cfg.ShowIncHeals then return end
	
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(self:GetWidth())
	mhpb:SetStatusBarTexture(cfg.statusbar_texture)
	mhpb:SetStatusBarColor(1, 1, 1, 0.4)
	mhpb:SetFrameLevel(1)

	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(self:GetWidth())
	ohpb:SetStatusBarTexture(cfg.statusbar_texture)
	ohpb:SetStatusBarColor(1, 1, 1, 0.4)
	mhpb:SetFrameLevel(1)
	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
	}
end

-- Combo points
lib.RogueComboPoints = function(self)
	if(playerClass == "ROGUE" or playerClass == "DRUID") then
		
		local barFrame = CreateFrame("Frame", nil, self)
		barFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 5)
		barFrame:SetHeight(8)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)
		
		for i = 1, MAX_COMBO_POINTS do
			local point = CreateFrame("StatusBar", nil, barFrame)
			point:SetSize((self.Health:GetWidth() / 5)-5, 6)
			if i > 1 then point:SetPoint("LEFT", point[i - 1], "RIGHT") end
			point:SetStatusBarTexture(cfg.statusbar_texture)
			point:SetStatusBarColor(1.0, 0.9, 0)

			local h = CreateFrame("Frame", nil, point)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)

		if (i == 1) then
			point:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 5)
		else
			point:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 6, 0)
		end
		barFrame[i] = point
		end
		self.CPoints = barFrame
		self.CPoints.unit = "player"
	end
	
end

-- Addons/Plugins -------------------------------------------

-- Totem timer support (requires oUF_boring_totembar) 
lib.gen_TotemBar = function(self)
	if ( playerClass == "SHAMAN" ) then
		local TotemBar = CreateFrame("Frame", nil, self)
		TotemBar:SetPoint("TOP", self, "BOTTOM", 0, -4)
		TotemBar:SetWidth(self:GetWidth())
		TotemBar:SetHeight(8)

		TotemBar.Destroy = true
		TotemBar.AbbreviateNames = true
		TotemBar.UpdateColors = true
		
		oUF.colors.totems = {
			{ 233/255, 46/255, 16/255 }, -- fire
			{ 173/255, 217/255, 25/255 }, -- earth
			{ 35/255, 127/255, 255/255 }, -- water
			{ 178/255, 53/255, 240/255 }  -- air
		}

		for i = 1, 4 do
		local t = CreateFrame("Frame", nil, TotemBar)
			t:SetHeight(8)
			t:SetWidth(self.Health:GetWidth()/4 - 6)

			local bar = CreateFrame("StatusBar", nil, t)
			bar:SetAllPoints(t)
			bar:SetStatusBarTexture(cfg.statusbar_texture)
			t.StatusBar = bar

			local h = CreateFrame("Frame", nil, t)
			h:SetFrameLevel(1)
			h:SetPoint("TOPLEFT",-5,5)
			h:SetPoint("BOTTOMRIGHT",5,-5)
			lib.gen_totemback(h)
			
			if (i == 1) then
				t:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 3, 6)
			else
				t:SetPoint('TOPLEFT', TotemBar[i-1], "TOPRIGHT", 6, 0)
			end

			t.bg = t:CreateTexture(nil, "BORDER")
			t.bg:SetAllPoints(t)
			t.bg:SetTexture(cfg.backdrop_texture)
			t.bg.multiplier = 0.15
			t.bg:SetAlpha(0.6)
	
			local text = lib.gen_fontstring(t, cfg.smallfont, 8, "THINOUTLINE")
			text:SetPoint("CENTER",t,"TOP",0,8)
			text:SetFontObject"GameFontNormal"
			t.Text = text

			TotemBar[i] = t
		end
	self.TotemBar = TotemBar
	end
end

-- oUF_DebuffHighlight
lib.debuffHighlight = function(self)
	if cfg.enableDebuffHighlight then
		local dbh = self.Health:CreateTexture(nil, "OVERLAY")
		dbh:SetAllPoints(self.Health)
		dbh:SetTexture(cfg.debuffhighlight_texture)
		dbh:SetBlendMode("ADD")
		dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
		self.DebuffHighlight = dbh
		self.DebuffHighlightAlpha = 0.5
		self.DebuffHighlightFilter = true
	end
end

-- AuraWatch
local AWPostCreateIcon = function(AWatch, icon, spellID, name, self)
	icon.cd:SetReverse()
	local count = lib.gen_fontstring(icon, cfg.smallfont, 12, "OUTLINE")
	count:SetPoint("CENTER", icon, "BOTTOM", 3, 3)
	icon.count = count
	local h = CreateFrame("Frame", nil, icon)
	h:SetFrameLevel(4)
	h:SetPoint("TOPLEFT",-3,3)
	h:SetPoint("BOTTOMRIGHT",3,-3)
	lib.gen_backdrop(h)
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