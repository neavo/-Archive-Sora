local bar = CreateFrame("Frame","rABS_MultiBarRight",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(24*12+3*11)
bar:SetHeight(24)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", -135, 18)
MultiBarRight:SetParent(bar)

for i=1, 12 do
	local Button = _G["MultiBarRightButton"..i]
	Button:SetSize(24, 24)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", bar, 0,0)
	elseif i == 4 or i == 7 then
		local previous = _G["MultiBarRightButton"..i-3]
		Button:SetPoint("BOTTOM", previous, "TOP", 0, 3)
	elseif i <= 9 then
		local previous = _G["MultiBarRightButton"..i-1]      
		Button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
	Button:SetAlpha(0)
end

local HideFrame = CreateFrame("Frame",nil,rABS_MultiBarRight)
HideFrame:SetPoint("TOPLEFT", MultiBarRightButton7, "TOPLEFT", -2, 2)
HideFrame:SetPoint("BOTTOMRIGHT", MultiBarRightButton3, "BOTTOMRIGHT", 2, -2)
HideFrame:SetFrameLevel(5)
HideFrame:EnableMouse(true)

-- API
function LeftBarFadeOut()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.5 then
			for i=7,9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 1.5 then
			for i=4,6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 2.5 then
			for i=1,3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer > 3 then
			HideFrame:Show()
			Updater:ClearAllPoints()
		end
	end)
end

function LeftBarFadeIn()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.5 then
			for i=1,3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 1.5 then
			for i=4,6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 2.5 then
			for i=7,9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer > 3 then
			HideFrame:Hide()
			Updater:ClearAllPoints()
		end
	end)
end