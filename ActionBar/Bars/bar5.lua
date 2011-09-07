local bar = CreateFrame("Frame","rABS_MultiBarRight",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(23*3+2*3)
bar:SetHeight(23*1+2*1)
bar:SetPoint("TOPLEFT", MultiBarBottomRightButton12, "TOPRIGHT", 5, 0)
MultiBarRight:SetParent(bar)

for i=1, 11 do
	local Button = _G["MultiBarRightButton"..i]
	Button:SetSize(23, 23)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("TOPRIGHT", bar, 0,0)
	elseif i == 4 or i == 7 or i == 10 then
		local Pre = _G["MultiBarRightButton"..i-3]
		Button:SetPoint("TOP", Pre, "BOTTOM", 0, -2)
	else
		local Pre = _G["MultiBarRightButton"..i-1]      
		Button:SetPoint("RIGHT", Pre, "LEFT", -3, 0)
	end
	Button:SetAlpha(0)
end

local HideFrame = CreateFrame("Frame",nil,rABS_MultiBarRight)
HideFrame:SetPoint("TOPLEFT", MultiBarRightButton1, "TOPLEFT", 0, 0)
HideFrame:SetPoint("BOTTOMRIGHT", MultiBarRightButton9, "BOTTOMRIGHT", 0, 5)
HideFrame:SetFrameLevel(5)
HideFrame:EnableMouse(true)

-- API
function RightBarFadeOut()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.3 then
			for i=1,3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 0.9 then
			for i=4,6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 1.5 then
			for i=7,9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 2.1 then
			for i=10,11 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer > 3 then
			HideFrame:Show()
			Updater:ClearAllPoints()
		end
	end)
end

function RightBarFadeIn()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.3 then
			for i=10,11 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 0.9 then
			for i=7,9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 1.5 then
			for i=4,6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 2.1 then
			for i=1,3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer > 3 then
			HideFrame:Hide()
			Updater:ClearAllPoints()
		end
	end)
end