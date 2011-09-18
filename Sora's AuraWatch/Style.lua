----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local class = select(2, UnitClass("player")) 
local CLASS_COLORS = RAID_CLASS_COLORS[class]


-- BuildICON
function cfg.BuildICON(iconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(iconSize)
	Frame:SetHeight(iconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetPoint("TOPLEFT", 2, -2)
	Frame.Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) 
	
	Frame.Shadow = CreateFrame("Frame", nil, Frame)
	Frame.Shadow:SetPoint("TOPLEFT", 1, -4)
	Frame.Shadow:SetPoint("BOTTOMRIGHT", 4, -4)
	Frame.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 5,
	})
	Frame.Shadow:SetBackdropBorderColor(0,0,0,1)
	Frame.Shadow:SetFrameLevel(0)
	
	Frame.Border = CreateFrame("Frame", nil, Frame)
	Frame.Border:SetPoint("TOPLEFT", 1, -1)
	Frame.Border:SetPoint("BOTTOMRIGHT", -1, 1)
	Frame.Border:SetBackdrop({ 
		edgeFile = cfg.Solid , edgeSize = 1,
	})
	Frame.Border:SetBackdropBorderColor(0,0,0,1)
	Frame.Border:SetFrameLevel(0)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	
	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate") 
	Frame.Cooldown:SetPoint("TOPLEFT", 2, -2) 
	Frame.Cooldown:SetPoint("BOTTOMRIGHT", -2, 2) 
	Frame.Cooldown:SetReverse(true)
		
	Frame:Hide()
	
	return Frame
end

-- BuildBAR
function cfg.BuildBAR(iconSize,barWidth)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetWidth(barWidth)
	Frame:SetHeight(iconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetWidth(iconSize)
	Frame.Icon:SetHeight(iconSize)
	Frame.Icon:SetPoint("RIGHT", Frame, "LEFT", 0, 0)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame) 
	Frame.Statusbar:SetAllPoints() 
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = CreateFrame("Frame", nil, Frame.Statusbar)
	Frame.Statusbar.Shadow:SetPoint("TOPLEFT", -(3+iconSize), 3)
	Frame.Statusbar.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	Frame.Statusbar.Shadow:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 3,
	})
	Frame.Statusbar.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Frame.Statusbar.Shadow:SetFrameLevel(0)

	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(cfg.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(1, 1, 1, 0.2) 
	
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 9, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Time:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Time:SetPoint("RIGHT", 0, 0) 

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Spellname:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Spellname:SetPoint("CENTER", -10, 1) 
	
	return Frame
end

SR.AuraWatchConfig = cfg