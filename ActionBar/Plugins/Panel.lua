----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ActionBarConfig

local MainBar = CreateFrame("Frame")
MainBar:SetPoint("TOPLEFT",MultiBarBottomRightButton1,"TOPLEFT", -7, 7)
MainBar:SetPoint("BOTTOMRIGHT",ActionButton12,"BOTTOMRIGHT", 7, -7)
MainBar:SetBackdrop({
	bgFile = cfg.bgFile,
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar:SetBackdropColor(0,0,0,0.2)
MainBar:SetBackdropBorderColor(0,0,0,1)

MainBar.Left = CreateFrame("Frame",nil,MainBar)
MainBar.Left:SetPoint("TOPLEFT", MultiBarRightButton1, "BOTTOMLEFT", -3, -3)
MainBar.Left:SetPoint("BOTTOMRIGHT", MainBar, "BOTTOMLEFT", 0, 0)
MainBar.Left:SetBackdrop({
	bgFile = cfg.bgFile,
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar.Left:SetBackdropColor(0,0,0,0.8)
MainBar.Left:SetBackdropBorderColor(0,0,0,1)
MainBar.Left.Text = MainBar.Left:CreateFontString(nil,"OVERLAY")
MainBar.Left.Text:SetPoint("CENTER", MainBar.Left,"CENTER", 0, 0)
MainBar.Left.Text:SetFont(cfg.Font, 16, "THINOUTLINE")
MainBar.Left.Text:SetText("---")
MainBar.Left.Text:SetAlpha(0.8)

MainBar.Left:SetScript("OnEnter",function(self)
	self.Text:SetTextColor(1, 0, 0)
end)
MainBar.Left:SetScript("OnLeave",function(self)
	self.Text:SetTextColor(1, 1, 1)
end)
MainBar.Left:SetScript("OnMouseDown",function(self)
	if MultiBarRightButton1:GetAlpha() < 0.1 then
		LeftBarFadeIn()
	elseif MultiBarRightButton1:GetAlpha() > 0.9 then
		LeftBarFadeOut()
	end
end)


MainBar.Right = CreateFrame("Frame",nil,MainBar)
MainBar.Right:SetPoint("TOPRIGHT", MultiBarLeftButton3, "BOTTOMRIGHT", 3, -3)
MainBar.Right:SetPoint("BOTTOMLEFT", MainBar, "BOTTOMRIGHT", 0, 0)
MainBar.Right:SetBackdrop({
	bgFile = cfg.bgFile,
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar.Right:SetBackdropColor(0,0,0,0.8)
MainBar.Right:SetBackdropBorderColor(0,0,0,1)
MainBar.Right.Text = MainBar.Right:CreateFontString(nil,"OVERLAY")
MainBar.Right.Text:SetPoint("CENTER", MainBar.Right,"CENTER", 0, 0)
MainBar.Right.Text:SetFont(cfg.Font, 16, "THINOUTLINE")
MainBar.Right.Text:SetText("---")
MainBar.Right.Text:SetAlpha(0.8)

MainBar.Right:SetScript("OnEnter",function(self)
	self.Text:SetTextColor(1, 0, 0)
end)
MainBar.Right:SetScript("OnLeave",function(self)
	self.Text:SetTextColor(1, 1, 1)
end)
MainBar.Right:SetScript("OnMouseDown",function(self)
	if MultiBarLeftButton1:GetAlpha() < 0.1 then
		RightBarFadeIn()
	elseif MultiBarLeftButton1:GetAlpha() > 0.9 then
		RightBarFadeOut()
	end
end)