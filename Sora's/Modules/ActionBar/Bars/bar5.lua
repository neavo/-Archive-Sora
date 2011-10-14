-- Engines
local S, _, _, _ = unpack(select(2, ...))

local Bar = CreateFrame("Frame", "rABS_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
Bar:SetWidth(24*6+3*5)
Bar:SetHeight(24*2+3)
Bar:SetPoint("BOTTOMRIGHT", -5, 150)
MultiBarRight:SetParent(Bar)

for i=1, 12 do
	local Button = _G["MultiBarRightButton"..i]
	Button:SetSize(24, 24)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("TOPRIGHT", Bar, 0, 0)
	elseif i == 7 then
		Button:SetPoint("TOP", MultiBarRightButton1, "BOTTOM", 0, -3)	
	else
		Button:SetPoint("RIGHT", _G["MultiBarRightButton"..i-1], "LEFT", -3, 0)
	end
	Button.HideFrame = CreateFrame("Frame", nil, Button)
	Button.HideFrame:SetAllPoints()
	Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
	Button.HideFrame:EnableMouse(true)
	Button.HideFrame:Hide()
end

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
