local bar = CreateFrame("Frame","rABS_MultiBarLeft",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(22*3+2*3)
bar:SetHeight(22*1+2*1)
bar:SetPoint("TOPRIGHT", MultiBarBottomRightButton1, "TOPLEFT", -5, 0)
MultiBarLeft:SetParent(bar)

for i=1, 11 do
	local Button = _G["MultiBarLeftButton"..i]
	Button:SetSize(22, 22)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("TOPLEFT", bar, 0,0)
	elseif i == 4 or i == 7 or i == 10 then
		local Pre = _G["MultiBarLeftButton"..i-3]
		Button:SetPoint("TOP", Pre, "BOTTOM", 0, -2)
	else
		local Pre = _G["MultiBarLeftButton"..i-1]      
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	end
	Button:SetAlpha(0)
end

local HideFrame = CreateFrame("Frame",nil,rABS_MultiBarLeft)
HideFrame:SetPoint("TOPLEFT", MultiBarLeftButton1, "TOPLEFT", 0, 0)
HideFrame:SetPoint("BOTTOMRIGHT", MultiBarLeftButton9, "BOTTOMRIGHT", 0, 5)
HideFrame:SetFrameLevel(5)
HideFrame:EnableMouse(true)

-- API
function LeftBarFadeOut()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate",function(self,elapsed)
		Timer = Timer + elapsed
		if Timer < 0.1 then
			for i=1,3 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
			end
		elseif Timer < 0.5 then
			for i=4,6 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
			end
		elseif Timer < 0.9 then
			for i=7,9 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
			end
		elseif Timer < 1.3 then
			for i=10,11 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
			end
		elseif Timer > 1.7 then
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
		if Timer < 0.1 then
			for i=10,11 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
			end
		elseif Timer < 0.5 then
			for i=7,9 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
			end
		elseif Timer < 0.9 then
			for i=4,6 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
			end
		elseif Timer < 1.3 then
			for i=1,3 do
				local Button = _G["MultiBarLeftButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
			end
		elseif Timer > 1.7 then
			HideFrame:Hide()
			Updater:ClearAllPoints()
		end
	end)
end