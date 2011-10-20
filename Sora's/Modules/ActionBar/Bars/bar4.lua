-- Engines
local S, _, _, _ = unpack(select(2, ...))

local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
Bar:SetWidth(24*6+3*5)
Bar:SetHeight(24*2+3)
MultiBarLeft:SetParent(Bar)
MultiBarLeft:ClearAllPoints()
MultiBarLeft.SetPoint = function() end
MoveHandle.LeftBar = S.MakeMoveHandle(Bar, "侧边栏", "LeftBar")

for i=1, 12 do
	local Button = _G["MultiBarLeftButton"..i]
	Button:SetSize(24, 24)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("TOPLEFT", Bar, 0, 0)
	elseif i == 7 then
		Button:SetPoint("TOP", MultiBarLeftButton1, "BOTTOM", 0, -3)	
	else
		Button:SetPoint("LEFT", _G["MultiBarLeftButton"..i-1], "RIGHT", 3, 0)
	end
	Button.HideFrame = CreateFrame("Frame", nil, Button)
	Button.HideFrame:SetAllPoints()
	Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
	Button.HideFrame:EnableMouse(true)
	Button.HideFrame:Hide()
end

function S.LeftBarFade()
	if MultiBarLeftButton1:GetAlpha() > 0.9 then
		for i = 1, 12 do
			local Button = _G["MultiBarLeftButton"..i]
			UIFrameFadeOut(Button, 0.3, 1, 0)
			Button.HideFrame:Show()
		end
	else
		for i = 1, 12 do
			local Button = _G["MultiBarLeftButton"..i]
			UIFrameFadeIn(Button, 0.3, 0, 1)
			Button.HideFrame:Hide()
		end
	end
end
