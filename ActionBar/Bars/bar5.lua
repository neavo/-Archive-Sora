local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(26*12+3*11)
bar:SetHeight(26)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 358, 18)
MultiBarLeft:SetParent(bar)

for i=1, 12 do
	local Button = _G["MultiBarLeftButton"..i]
	Button:SetSize(26, 26)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", bar, 0,0)
	elseif i == 4 or i == 7 then
		local previous = _G["MultiBarLeftButton"..i-3]
		Button:SetPoint("BOTTOM", previous, "TOP", 0, 3)
	elseif i <= 9 then
		local previous = _G["MultiBarLeftButton"..i-1]      
		Button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
	Button:SetAlpha(0)
end

local HideFrame = CreateFrame("Frame",nil,rABS_MultiBarLeft)
HideFrame:SetPoint("TOPLEFT", MultiBarLeftButton7, "TOPLEFT", -2, 2)
HideFrame:SetPoint("BOTTOMRIGHT", MultiBarLeftButton3, "BOTTOMRIGHT", 2, -2)
HideFrame:SetFrameLevel(5)
HideFrame:EnableMouse(true)

-- API
function RightBarFadeOut()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.5 then
			for i=7,9 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 1.5 then
			for i=4,6 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.5, 1, 0)
			end
		elseif Timer < 2.5 then
			for i=1,3 do
				local Button = _G["MultiBarLeftButton"..i]
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
		if Timer < 0.5 then
			for i=1,3 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 1.5 then
			for i=4,6 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer < 2.5 then
			for i=7,9 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.5, 0, 1)
			end
		elseif Timer > 3 then
			HideFrame:Hide()
			Updater:ClearAllPoints()
		end
	end)
end