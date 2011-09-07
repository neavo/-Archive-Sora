----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ActionBarConfig

local MainBar = CreateFrame("Frame")
MainBar:SetPoint("TOPLEFT",ActionButton1,"LEFT", -10, -3)
MainBar:SetPoint("BOTTOMRIGHT",ActionButton12,"BOTTOMRIGHT", 10, -7)
MainBar:SetBackdrop({
	bgFile = cfg.bgFile,
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar:SetBackdropColor(0, 0, 0, 0.2)
MainBar:SetBackdropBorderColor(0, 0, 0, 1)

if cfg.ShowExtraBar then
	MainBar.Left = CreateFrame("Frame",nil,MainBar)
	MainBar.Left:SetPoint("TOPLEFT",MainBar,"TOPLEFT", -11, 0)
	MainBar.Left:SetPoint("BOTTOMRIGHT",MainBar,"BOTTOMLEFT", 2, 0)
	MainBar.Left:SetBackdrop({
		edgeFile = cfg.GlowTex, edgeSize = 3, 
	})
	MainBar.Left:SetBackdropBorderColor(0, 0, 0, 1)

	MainBar.Left:SetScript("OnMouseDown",function(self)
		if MultiBarLeftButton1:GetAlpha() < 0.1 then
			LeftBarFadeIn()
		elseif MultiBarLeftButton1:GetAlpha() > 0.9 then
			LeftBarFadeOut()
		end
	end)

	MainBar.Right = CreateFrame("Frame",nil,MainBar)
	MainBar.Right:SetPoint("TOPRIGHT",MainBar,"TOPRIGHT", 11, 0)
	MainBar.Right:SetPoint("BOTTOMLEFT",MainBar,"BOTTOMRIGHT", -2, 0)
	MainBar.Right:SetBackdrop({
		edgeFile = cfg.GlowTex, edgeSize = 3, 
	})
	MainBar.Right:SetBackdropBorderColor(0, 0, 0, 1)

	MainBar.Right:SetScript("OnMouseDown",function(self)
		if MultiBarRightButton1:GetAlpha() < 0.1 then
			RightBarFadeIn()
		elseif MultiBarRightButton1:GetAlpha() > 0.9 then
			RightBarFadeOut()
		end
	end)
else
	RightBarFadeOut()
	LeftBarFadeOut()
end