-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Bar5")

function S.RightBarFade()
	if MultiBarRightButton1:GetAlpha() > 0.9 then
		for i = 1, 12 do
			local Button = _G["MultiBarRightButton"..i]
			UIFrameFadeOut(Button, 0.3, 1, 0)
			Button.HideFrame:Show()
		end
	else
		for i = 1, 12 do
			local Button = _G["MultiBarRightButton"..i]
			UIFrameFadeIn(Button, 0.3, 0, 1)
			Button.HideFrame:Hide()
		end
	end
end

function Module:OnEnable()
	local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
	if ActionBarDB.ExtraBarLayout == 1 then
		Bar:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize*12+3*11)
	elseif ActionBarDB.ExtraBarLayout == 2 then
		Bar:SetSize(ActionBarDB.ButtonSize*6+5*3, ActionBarDB.ButtonSize*2+3)
	end
	MultiBarRight:SetParent(Bar)
	MultiBarRight:ClearAllPoints()
	MultiBarRight.SetPoint = function() end
	MoveHandle.RightBar = S.MakeMoveHandle(Bar, "侧边栏", "RightBar")

	for i = 1, 12 do
		local Button = _G["MultiBarRightButton"..i]
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		if i == 1 then
			Button:SetPoint("TOPRIGHT", Bar, 0, 0)
		elseif ActionBarDB.ExtraBarLayout == 1 then
			Button:SetPoint("TOP", _G["MultiBarRightButton"..i-1], "BOTTOM", 0, -3)
		elseif ActionBarDB.ExtraBarLayout == 2 and i == 7 then
			Button:SetPoint("TOP", _G["MultiBarRightButton"..i-6], "BOTTOM", 0, -3)
		elseif ActionBarDB.ExtraBarLayout == 2 then
			Button:SetPoint("RIGHT", _G["MultiBarRightButton"..i-1], "LEFT", -3, 0)	
		end
		Button.HideFrame = CreateFrame("Frame", nil, Button)
		Button.HideFrame:SetAllPoints()
		Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		Button.HideFrame:EnableMouse(true)
		Button.HideFrame:Hide()
	end
end
