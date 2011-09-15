----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig

local MainBar = CreateFrame("Frame", "MainBar", UIParent)
MainBar:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 5, -6)
MainBar:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", -5, -24)
MainBar:SetBackdrop({
	bgFile = cfg.bgFile,
	edgeFile = cfg.GlowTex, edgeSize = 3, 
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
MainBar:SetBackdropColor(0, 0, 0, 0.2)
MainBar:SetBackdropBorderColor(0, 0, 0, 0.8)

MainBar.Left = CreateFrame("Frame", nil, UIParent)
MainBar.Left:SetPoint("TOPLEFT",MainBar,"TOPLEFT", -11, 0)
MainBar.Left:SetPoint("BOTTOMRIGHT",MainBar,"BOTTOMLEFT", 2, 0)
MainBar.Left:SetBackdrop({
	edgeFile = cfg.GlowTex, edgeSize = 3, 
})
MainBar.Left:SetBackdropBorderColor(0, 0, 0, 0.8)

MainBar.Left:SetScript("OnMouseDown",function(self)
	if MainBar:GetAlpha() < 0.1 then
		UIFrameFadeIn(MainBar, 0.5, 0, 1)
		UIFrameFadeIn(ChatFrame1, 0.5, 0, 1)
		UIFrameFadeIn(_G["Chatbar"], 0.5, 0, 0.6)
	elseif MainBar:GetAlpha() > 0.9 then
		UIFrameFadeOut(MainBar, 0.5, 1, 0)
		UIFrameFadeOut(_G["Chatbar"], 0.5, 0.6, 0)
		for i=1, 3 do
			UIFrameFadeOut(_G["ChatFrame"..i], 0.5, 1, 0)
			UIFrameFadeOut(_G["ChatFrame"..i.."Tab"], 0.5, 1, 0)
		end
	end
end)

MainBar.Right = CreateFrame("Frame",nil,MainBar)
MainBar.Right:SetPoint("TOPRIGHT",MainBar,"TOPRIGHT", 11, 0)
MainBar.Right:SetPoint("BOTTOMLEFT",MainBar,"BOTTOMRIGHT", -2, 0)
MainBar.Right:SetBackdrop({
	edgeFile = cfg.GlowTex, edgeSize = 3, 
})
MainBar.Right:SetBackdropBorderColor(0, 0, 0, 0.8)

MainBar.Right:SetScript("OnMouseDown",function(self)
	if ChatFrame1:GetAlpha() < 0.1 then
		UIFrameFadeIn(ChatFrame1, 0.5, 0, 1)
	elseif ChatFrame1:GetAlpha() > 0.9 then
		UIFrameFadeOut(ChatFrame1, 0.5, 1, 0)
	end
end)




