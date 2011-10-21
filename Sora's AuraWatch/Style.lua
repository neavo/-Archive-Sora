----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local class = select(2, UnitClass("player")) 
local CLASS_COLORS = RAID_CLASS_COLORS[class]

local function MakeShadow(Frame, Size)
	local Shadow = CreateFrame("Frame", nil, Frame)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = cfg.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

-- BuildICON
function cfg.BuildICON(IconSize, ClickCast)
	local Frame = ClickCast and CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate") or CreateFrame("Frame", nil, UIParent)
	Frame:SetSize(IconSize, IconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetAllPoints()
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	Frame.Shadow = MakeShadow(Frame, 3)
	
	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 10, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	
	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame) 
	Frame.Cooldown:SetAllPoints() 
	Frame.Cooldown:SetReverse(true)
	
	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetSize(Frame:GetWidth(), Frame:GetHeight()/10)
	Frame.Statusbar:SetPoint("BOTTOM", Frame, "TOP", 0, 2) 
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = MakeShadow(Frame.Statusbar, 2)
	
	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(cfg.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(0.1, 0.1, 0.1, 0.6)
	
	if ClickCast then Frame:SetAttribute("type1","macro") end
	
	return Frame
end

-- BuildBAR
function cfg.BuildBAR(BarWidth, IconSize, ClickCast)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetSize(BarWidth, IconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Frame.Icon:SetSize(IconSize, IconSize)
	Frame.Icon:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMLEFT", -5, 0)
	
	Frame.Icon.Shadow = MakeShadow(Frame, 3)
	Frame.Icon.Shadow:SetPoint("TOPLEFT", Frame.Icon, -3, 3)
	Frame.Icon.Shadow:SetPoint("BOTTOMRIGHT", Frame.Icon, 3, -3)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetSize(Frame:GetWidth(), Frame:GetHeight()/3)
	Frame.Statusbar:SetPoint("BOTTOM") 
	Frame.Statusbar:SetStatusBarTexture(cfg.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(CLASS_COLORS.r, CLASS_COLORS.g, CLASS_COLORS.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = MakeShadow(Frame.Statusbar, 3)

	Frame.Count = Frame:CreateFontString(nil, "OVERLAY") 
	Frame.Count:SetFont(cfg.Font, 9, "THINOUTLINE") 
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Time:SetFont(cfg.Font, 11, "THINOUTLINE") 
	Frame.Time:SetPoint("RIGHT", 0, 5) 

	Frame.Spellname = Frame.Statusbar:CreateFontString(nil, "ARTWORK") 
	Frame.Spellname:SetFont(cfg.Font, 11, "THINOUTLINE") 
	Frame.Spellname:SetPoint("CENTER", -10, 5) 
	
	return Frame
end