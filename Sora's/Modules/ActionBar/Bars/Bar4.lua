-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar4")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:OnInitialize()
	C = ActionBarDB
	MultiBarLeft:SetParent(Bar)
	
	if C["ExtraBarLayout"] == 1 then
		Bar:SetSize(C["ButtonSize"], C["ButtonSize"]*12+3*11)
	end
	if C["ExtraBarLayout"] == 2 then
		Bar:SetSize(C["ButtonSize"]*6+5*3, C["ButtonSize"]*2+3)
	end
	MoveHandle.LeftBar = S.MakeMoveHandle(Bar, "侧边栏", "LeftBar")
end

function Module:OnEnable()
	local Button = nil
	for i = 1, 12 do
		Button = _G["MultiBarLeftButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		
		if C["ExtraBarLayout"] == 1 then
			if i == 1 then
				Button:SetPoint("TOPLEFT", Bar, 0, 0)
			else
				Button:SetPoint("TOP", _G["MultiBarLeftButton"..i-1], "BOTTOM", 0, -3)
			end
		end
		if C["ExtraBarLayout"] == 2 then
			if i == 1 then
				Button:SetPoint("TOPLEFT", Bar, 0, 0)
			elseif i == 7 then
				Button:SetPoint("TOP", _G["MultiBarLeftButton"..i-6], "BOTTOM", 0, -3)
			else
				Button:SetPoint("LEFT", _G["MultiBarLeftButton"..i-1], "RIGHT", 3, 0)	
			end
		end
		
		Button.HideFrame = CreateFrame("Frame", nil, Button)
		Button.HideFrame:SetAllPoints()
		Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		Button.HideFrame:EnableMouse(true)
		Button.HideFrame:Hide()
	end
end

function S.LeftBarFade()
	local Button = nil
	if MultiBarLeftButton1:GetAlpha() > 0.9 then
		for i = 1, 12 do
			Button = _G["MultiBarLeftButton"..i]
			UIFrameFadeOut(Button, 0.3, 1, 0)
			Button.HideFrame:Show()
		end
	else
		for i = 1, 12 do
			Button = _G["MultiBarLeftButton"..i]
			UIFrameFadeIn(Button, 0.3, 0, 1)
			Button.HideFrame:Hide()
		end
	end
end