-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Totembar")
local Bar = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")

function Module:StyleButton(Button)
	local Icon = _G[Button:GetName().."Icon"]
	local Border = _G[Button:GetName().."Border"]
	local Highlight = _G[Button:GetName().."Highlight"]
	local NormalTexture = _G[Button:GetName().."NormalTexture"]

	if Icon then
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
	end
	
	if Border then
		Border:SetTexture(nil)	
	end
	
	local HighlightTexture = Button:CreateTexture("Frame", nil, self)
	HighlightTexture:SetTexture(1, 1, 1, 0.3)
	HighlightTexture:SetPoint("TOPLEFT", 2, -2)
	HighlightTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	Button:SetHighlightTexture(HighlightTexture)

	local PushedTexture = Button:CreateTexture("Frame", nil, self)
	PushedTexture:SetTexture(0.1, 0.1, 0.1, 0.5)
	PushedTexture:SetPoint("TOPLEFT", 2, -2)
	PushedTexture:SetPoint("BOTTOMRIGHT", -2, 2)
	Button:SetHighlightTexture(PushedTexture)
	
	if Highlight then
		Highlight:SetTexture(nil)
	end
	
	if NormalTexture then
		NormalTexture:SetTexture(nil)
	end
	
	if not Button.Shadow then
		Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
	end
end

function Module:TotemTimer()
	local Color = {
		[EARTH_TOTEM_SLOT] = { 181/255, 073/255, 033/255 },
		[FIRE_TOTEM_SLOT] = { 074/255, 142/255, 041/255 },
		[WATER_TOTEM_SLOT] = { 057/255, 146/255, 181/255 },
		[AIR_TOTEM_SLOT] = { 132/255, 056/255, 231/255 }
	}
	local TotemTime = {}
	for i = 1, 4 do
		local Button = _G["MultiCastSlotButton"..i]
		local TimeFrame = CreateFrame("Frame", nil, UIParent)
		TimeFrame:SetAllPoints(Button)
		TimeFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		TimeFrame.Text = S.MakeFontString(TimeFrame, 10)
		TimeFrame.Text:SetPoint("BOTTOM", 0, 1)
		TimeFrame.Text:SetTextColor(unpack(Color[i]))
		tinsert(TotemTime, TimeFrame.Text)
	end
	TotemTime[1], TotemTime[2] = TotemTime[2], TotemTime[1]
	local Update = CreateFrame("Frame")
	Update:SetScript("OnUpdate", function(self, elapsed)
		for i = 1, 4 do	
			local haveTotem = GetTotemInfo(i)
			local TimeLeft = GetTotemTimeLeft(i)
			if not haveTotem or TimeLeft <= 0 then
				TotemTime[i]:SetText("")
			else
				TotemTime[i]:SetText(S.FormatTime(TimeLeft, true))
			end
		end
	end)
end

function Module:OnInitialize()
	C = ActionBarDB
end

function Module:OnEnable()
	if DB.MyClass == "SHAMAN" then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(DB.ActionBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
		
		hooksecurefunc("MultiCastActionButton_Update",function(Bar)
			if not InCombatLockdown() then
				Bar:SetAllPoints(Bar.slotButton)
			end
		end)
		
		Module:TotemTimer()
	end
end

hooksecurefunc("MultiCastSummonSpellButton_Update", function(Button)
	if Button and not Button.Shadow then
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
		Module:StyleButton(Button) 
	end
end)

hooksecurefunc("MultiCastRecallSpellButton_Update", function(Button)
	if Button and not Button.Shadow then
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		Button:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 3, 0)
		Module:StyleButton(Button) 
	end
end)

hooksecurefunc("MultiCastActionButton_Update", function(actionButton, actionId, actionIndex, slot)
	actionButton.overlayTex:SetTexture(nil)
	actionButton.overlayTex:Hide()
	actionButton:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
	if actionButton.slotButton then
		actionButton:ClearAllPoints()
		actionButton:SetAllPoints(actionButton.slotButton)
		actionButton:SetFrameLevel(actionButton.slotButton:GetFrameLevel()+1)
	end
	actionButton:SetBackdropColor(0, 0, 0, 0)
end)

hooksecurefunc("MultiCastSlotButton_Update", function(self, slot)
	if self and not self.Shadow then
		local index = tonumber(string.match(self:GetName(), "MultiCastSlotButton(%d)"))
		local Button = self
		Button.overlayTex:SetTexture(nil)
		Button.background:ClearAllPoints()
		Button.background:SetPoint("TOPLEFT", 2, -2)
		Button.background:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if index == 1 then
			Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", C["ButtonSize"]+3*2, 0)
		elseif index == 2 then
			Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", 3, 0)
		elseif index == 3 then
			Button:SetPoint("LEFT", MultiCastSlotButton1, "RIGHT", 3, 0)
		elseif index == 4 then
			Button:SetPoint("LEFT", MultiCastSlotButton3, "RIGHT", 3, 0)		
		end
		Module:StyleButton(Button) 
	end
end)

hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout", function(Flyout)
	Flyout.top:SetTexture(nil)
	Flyout.middle:SetTexture(nil)
	
	local last = nil
	for key, value in ipairs(Flyout.buttons) do
		if value and not value.Shadow then
			if not InCombatLockdown() then
				value:SetSize(C["ButtonSize"], C["ButtonSize"])
				value:ClearAllPoints()
				value:SetPoint("BOTTOM", last, "TOP", 0, 3)
			end
			if value:IsVisible() then
				last = value
			end
			value:SetBackdropBorderColor(Flyout.parent:GetBackdropBorderColor())
			Module:StyleButton(value) 
		end
	end
	
	Flyout.buttons[1]:SetPoint("BOTTOM")
	Flyout:ClearAllPoints()
	Flyout:SetPoint("BOTTOM", Flyout.parent, "TOP", 0, 4)
end)