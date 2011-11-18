-- Engines
local S, C, L, DB = unpack(select(2, ...))

-- BuildICON
function S.BuildICON(IconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetSize(IconSize, IconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK") 
	Frame.Icon:SetAllPoints()
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	Frame.Shadow = S.MakeShadow(Frame, 3)
	
	Frame.Count = S.MakeFontString(Frame, 10)
	Frame.Count:SetPoint("BOTTOMRIGHT", 3, -1)
	
	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame) 
	Frame.Cooldown:SetAllPoints() 
	Frame.Cooldown:SetReverse(true)
	
	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetSize(Frame:GetWidth(), Frame:GetHeight()/10)
	Frame.Statusbar:SetPoint("BOTTOM", Frame, "TOP", 0, 2) 
	Frame.Statusbar:SetStatusBarTexture(DB.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = S.MakeShadow(Frame.Statusbar, 2)
	
	Frame.Statusbar.BG = Frame.Statusbar:CreateTexture(nil, "BACKGROUND")
	Frame.Statusbar.BG:SetAllPoints() 
	Frame.Statusbar.BG:SetTexture(DB.Statusbar)
	Frame.Statusbar.BG:SetVertexColor(0.1, 0.1, 0.1, 0.6)

	return Frame
end

-- BuildBAR
function S.BuildBAR(BarWidth, IconSize)
	local Frame = CreateFrame("Frame", nil, UIParent)
	Frame:SetSize(BarWidth, IconSize)
	
	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	Frame.Icon:SetSize(IconSize, IconSize)
	Frame.Icon:SetPoint("LEFT", -5, 0)
	
	Frame.Icon.Shadow = S.MakeShadow(Frame, 3)
	Frame.Icon.Shadow:SetPoint("TOPLEFT", Frame.Icon, -3, 3)
	Frame.Icon.Shadow:SetPoint("BOTTOMRIGHT", Frame.Icon, 3, -3)

	Frame.Statusbar = CreateFrame("StatusBar", nil, Frame)
	Frame.Statusbar:SetSize(Frame:GetWidth()-Frame:GetHeight()-5, Frame:GetHeight()/3)
	Frame.Statusbar:SetPoint("BOTTOMRIGHT") 
	Frame.Statusbar:SetStatusBarTexture(DB.Statusbar) 
	Frame.Statusbar:SetStatusBarColor(DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b, 0.9)
	Frame.Statusbar:SetMinMaxValues(0, 1) 
	Frame.Statusbar:SetValue(0) 	

	Frame.Statusbar.Shadow = S.MakeShadow(Frame.Statusbar, 3)

	Frame.Count = S.MakeFontString(Frame, 9)
	Frame.Count:SetPoint("BOTTOMRIGHT", Frame.Icon, "BOTTOMRIGHT", 3, -1) 

	Frame.Time = S.MakeFontString(Frame.Statusbar, 11)
	Frame.Time:SetPoint("RIGHT", 0, 5) 

	Frame.Spellname = S.MakeFontString(Frame.Statusbar, 11)
	Frame.Spellname:SetPoint("CENTER", -10, 5)
	
	return Frame
end