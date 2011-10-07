local API = CreateFrame("Frame")

local Bar = CreateFrame("Frame", "rABS_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
Bar:SetWidth(22*3+2*3)
Bar:SetHeight(22*1+2*1)
Bar:SetPoint("TOPLEFT", MultiBarBottomRightButton12, "TOPRIGHT", 5, 0)
MultiBarRight:SetParent(Bar)

for i=1, 12 do
	local Button = _G["MultiBarRightButton"..i]
	Button:SetSize(22, 22)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("TOPRIGHT", Bar, 0, 0)
	elseif i == 4 or i == 7 or i == 10 then
		local Pre = _G["MultiBarRightButton"..i-3]
		Button:SetPoint("TOP", Pre, "BOTTOM", 0, -2)
	elseif i == 12 then
		Button:Hide()
	else
		local Pre = _G["MultiBarRightButton"..i-1]      
		Button:SetPoint("RIGHT", Pre, "LEFT", -3, 0)
	end
	Button.HideFrame = CreateFrame("Frame", nil, Button)
	Button.HideFrame:SetAllPoints()
	Button.HideFrame:SetFrameLevel(Button:GetFrameLevel()+1)
	Button.HideFrame:EnableMouse(true)
	Button.HideFrame:Hide()
end

function API.FadeOut()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate", function(self, elapsed)
		Timer = Timer + elapsed
		if Timer < 0.1 then
			for i=1, 3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
				Button.HideFrame:Show()
			end
		elseif Timer < 0.3 then
			for i=4, 6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
				Button.HideFrame:Show()
			end
		elseif Timer < 0.9 then
			for i=7, 9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
				Button.HideFrame:Show()
			end
		elseif Timer < 1.3 then
			for i=10, 11 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeOut(Button, 0.3, 1, 0)
				Button.HideFrame:Show()
			end
		elseif Timer > 1.7 then
			self:SetScript("OnUpdate", nil)
		end
	end)
end

function API.FadeIn()
	local Timer = 0
	local Updater = CreateFrame("Frame")
	Updater:SetScript("OnUpdate", function(self, elapsed)
		Timer = Timer + elapsed
		if Timer < 0.1 then
			for i=10, 11 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
				Button.HideFrame:Hide()
			end
		elseif Timer < 0.5 then
			for i=7, 9 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
				Button.HideFrame:Hide()
			end
		elseif Timer < 0.9 then
			for i=4, 6 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
				Button.HideFrame:Hide()
			end
		elseif Timer < 1.3 then
			for i=1, 3 do
				local Button = _G["MultiBarRightButton"..i]
				UIFrameFadeIn(Button, 0.3, 0, 1)
				Button.HideFrame:Hide()
			end
		elseif Timer > 1.7 then
			self:SetScript("OnUpdate", nil)
		end
	end)
end

----------------
--  命名空间  --
----------------

local _, SR = ...
SR.RightBar = API