-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar5")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function S.RightBarFade()
	local Button = nil
	if MultiBarRightButton1:GetAlpha() > 0.9 then
		for i = 1, 12 do
			Button = _G["MultiBarRightButton"..i]
			UIFrameFadeOut(Button, 0.3, 1, 0)
			Button.HideFrame:Show()
		end
	else
		for i = 1, 12 do
			Button = _G["MultiBarRightButton"..i]
			UIFrameFadeIn(Button, 0.3, 0, 1)
			Button.HideFrame:Hide()
		end
	end
end

function Module:OnInitialize()
	C = ActionBarDB
	MultiBarRight:SetParent(Bar)
	
	if C["ExtraBarLayout"] == 1 then
		Bar:SetSize(C["ButtonSize"], C["ButtonSize"]*12+3*11)
	end
	if C["ExtraBarLayout"] == 2 then
		Bar:SetSize(C["ButtonSize"]*6+5*3, C["ButtonSize"]*2+3)
	end
	MoveHandle.RightBar = S.MakeMoveHandle(Bar, "侧边栏", "RightBar")
end

function Module:OnEnable()
	local Button = nil
	for i = 1, 12 do
		Button = _G["MultiBarRightButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()

		if C["ExtraBarLayout"] == 1 then
			if i == 1 then
				Button:SetPoint("TOPRIGHT", Bar, 0, 0)
			else
				Button:SetPoint("TOP", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, -3)
			end
		end
		if C["ExtraBarLayout"] == 2 then
			if i == 1 then
				Button:SetPoint("TOPRIGHT", Bar, 0, 0)
			elseif i == 7 then
				Button:SetPoint("TOP", _G["MultiBarRightButton"..i-6], "BOTTOM", 0, -3)
			else
				Button:SetPoint("RIGHT", _G["MultiBarRightButton"..i-1], "LEFT", -3, 0)	
			end
		end
		
		Button.HideFrame = CreateFrame("Frame", nil, Button)
		Button.HideFrame:SetAllPoints()
		Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		Button.HideFrame:EnableMouse(true)
		Button.HideFrame:Hide()
	end
end