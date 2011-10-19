-- Engines
local S, _, _, DB = unpack(select(2, ...))
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")

local function StyleButton(Button, Checked) 
    local name = Button:GetName()
	
    local Icon = _G[name.."Icon"]
    local Count = _G[name.."Count"]
    local Border = _G[name.."Border"]
    local HotKey = _G[name.."HotKey"]
    local Cooldown = _G[name.."Cooldown"]
    local Name = _G[name.."Name"]
    local Flash = _G[name.."Flash"]
    local NormalTexture = _G[name.."NormalTexture"]
	local IconTexture = _G[name.."IconTexture"]
 
    Button.Highlight = Button:CreateTexture(nil, "OVERLAY")
    Button.Highlight:SetTexture(1, 1, 1, 0.3)
    Button.Highlight:SetPoint("TOPLEFT", 2, -2)
    Button.Highlight:SetPoint("BOTTOMRIGHT", -2, 2)
    Button:SetHighlightTexture(Button.Highlight)
 
    Button.Pushed = Button:CreateTexture(nil, "OVERLAY")
    Button.Pushed:SetTexture(0.1, 0.1, 0.1, 0.5)
	Button.Pushed:SetPoint("TOPLEFT", 2, -2)
	Button.Pushed:SetPoint("BOTTOMRIGHT", -2, 2)
    Button:SetPushedTexture(Button.Pushed)
	
	if Checked then
		Button.Checked = Button:CreateTexture(nil, "OVERLAY")
		Button.Checked:SetTexture(1, 1, 1, 0.3)
		Button.Checked:SetPoint("TOPLEFT", 2, -2)
		Button.Checked:SetPoint("BOTTOMRIGHT", -2, 2)
		Button:SetCheckedTexture(Button.Checked)
	end
end

local function Style(self)
	local name = self:GetName()
	
	if name:match("MultiCast") then return end 
	
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Name = _G[name.."Name"]
	local NormalTexture  = _G[name.."NormalTexture"]
 
	Flash:SetTexture("")
	self:SetNormalTexture("")
 
	Border:Hide()
	Border = nil
 
	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 2, 2)
	Count:SetFont(DB.Font, ActionBarDB.CountFontSize, "THINOUTLINE")
 
	if Name and ActionBarDB.HideMacroName then
		Name:SetText("")
		Name:Hide()
		Name.Show = function() end
	end
 
	if not Icon.Shadow then
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Icon.Shadow = S.MakeTexShadow(self, Icon, 4)
	end

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 1, -1)
	HotKey:SetFont(DB.Font, ActionBarDB.HotkeyFontSize, "THINOUTLINE")
	HotKey.ClearAllPoints = function() end
	HotKey.SetPoint = function() end
 
	if ActionBarDB.HideHotKey then
		HotKey:SetText("")
		HotKey:Hide()
		HotKey.Show = function() end
	end
end

-- rescale cooldown spiral to fix texture.
for _, value in ipairs({"ActionButton", "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton", "MultiCastActionButton"}) do
	for index = 1, 12 do
		local Button = _G[value..tostring(index)]
		local Cooldown = _G[value..tostring(index).."Cooldown"]
 
		if Button == nil or Cooldown == nil then break end
		
		Cooldown:ClearAllPoints()
		Cooldown:SetPoint("TOPLEFT", 2, -2)
		Cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
	end
end

local function StyleSmallButton(Button, Icon, name)
	local Flash	 = _G[name.."Flash"]
	Button:SetNormalTexture("")
	Button.SetNormalTexture = function() end
	
	Flash:SetTexture(DB.Button)
	
	if not Icon.Shadow then
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Icon.Shadow = S.MakeTexShadow(Button, Icon, 4)
	end
end

--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function StyleFlyout(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then buttons = numSlots break end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if (SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end

	if self:GetAttribute("flyoutDirection") ~= nil then
		local SetPoint, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		if strfind(SetPoint, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end
		end
	end
end

-- rework the mouseover, pushed, checked texture to match theme.
for i = 1, 12 do
	StyleButton(_G["ActionButton"..i], true)
	StyleButton(_G["MultiBarBottomLeftButton"..i], true)
	StyleButton(_G["MultiBarBottomRightButton"..i], true)
	StyleButton(_G["MultiBarLeftButton"..i], true)
	StyleButton(_G["MultiBarRightButton"..i], true)
end	 
for i=1, 10 do
	StyleButton(_G["ShapeshiftButton"..i], true)
	StyleButton(_G["PetActionButton"..i], true)
end
for i=1, NUM_SHAPESHIFT_SLOTS do
	local Button  = _G["ShapeshiftButton"..i]
	local Icon  = _G["ShapeshiftButton"..i.."Icon"]
	StyleSmallButton(Button, Icon, "ShapeshiftButton"..i)
end
for i=1, NUM_PET_ACTION_SLOTS do
	local Button  = _G["PetActionButton"..i]
	local Icon  = _G["PetActionButton"..i.."Icon"]
	StyleSmallButton(Button, Icon, "PetActionButton"..i)
end
hooksecurefunc("ActionButton_Update", Style)
hooksecurefunc("ActionButton_UpdateFlyout", StyleFlyout)


-- Totem Bar
if select(2, UnitClass("player"))== "SHAMAN" and MultiCastActionBarFrame then
	hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout", function(Flyout)
		-- remove blizzard flyout texture
		Flyout.top:SetTexture(nil)
		Flyout.middle:SetTexture(nil)
		
		-- Skin buttons
		local last = nil
		
		for _, Button in ipairs(Flyout.buttons) do
			local Icon = select(1, Button:GetRegions())
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetDrawLayer("ARTWORK")
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", -2, 2)		
			if not InCombatLockdown() then
				Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
				Button:ClearAllPoints()
				Button:SetPoint("BOTTOM", last, "TOP", 0, 3)
				Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
			end
			if Button:IsVisible() then last = Button end
			Button:SetBackdropBorderColor(Flyout.parent:GetBackdropBorderColor())
			StyleButton(Button)		
		end
		
		Flyout.buttons[1]:SetPoint("BOTTOM")	
		Flyout:ClearAllPoints()
		Flyout:SetPoint("BOTTOM", Flyout.parent, "TOP", 0, 4)
	end)

	local function StyleTotemSlotButton(Button, index)
		Button.overlayTex:SetTexture(nil)
		Button.background:ClearAllPoints()
		Button.background:SetPoint("TOPLEFT", 2, -2)
		Button.background:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.Shadow = S.MakeTexShadow(Button, Button.background, 4)
		Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
		Button:ClearAllPoints()
		if index < 3 then
			Button:SetPoint("BOTTOM", _G["MultiBarBottomRightButton"..index+4], "TOP", 0, 5)
		else
			Button:SetPoint("BOTTOM", _G["MultiBarBottomLeftButton"..index-2], "TOP", 0, 5)			
		end
		StyleButton(Button)
	end
	hooksecurefunc("MultiCastSlotButton_Update", function(self, slot) StyleTotemSlotButton(self, tonumber(string.match(self:GetName(), "MultiCastSlotButton(%d)"))) end)

	-- Skin the actual totem buttons
	local function StyleTotemActionButton(Button, index)
		local Icon = select(1, Button:GetRegions())
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.overlayTex:SetTexture(nil)
		Button.overlayTex:Hide()
		Button:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
		if Button.slotButton then
			Button:ClearAllPoints()
			Button:SetAllPoints(Button.slotButton)
			Button:SetFrameLevel(Button.slotButton:GetFrameLevel()+1)
		end
		Button:SetBackdropColor(0, 0, 0, 0)
		StyleButton(Button, true)
	end
	hooksecurefunc("MultiCastActionButton_Update", function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton, actionIndex) end)

	-- Skin the summon and recall buttons
	hooksecurefunc("MultiCastSummonSpellButton_Update", function(Button)
		if not Button then return end
		local Icon = select(1, Button:GetRegions())
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
		Button:GetNormalTexture():SetTexture(nil)
		Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
		Button:ClearAllPoints()
		Button:SetPoint("BOTTOM", MultiBarBottomRightButton4, "TOP", 0, 5)
		_G[Button:GetName().."Highlight"]:SetTexture(nil)
		_G[Button:GetName().."NormalTexture"]:SetTexture(nil)
		StyleButton(Button)
	end)
	hooksecurefunc("MultiCastRecallSpellButton_Update", function(Button)
		if not Button then return end
		local Icon = select(1, Button:GetRegions())
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
		Button:GetNormalTexture():SetTexture(nil)
		Button:SetSize(ActionBarDB.ActionBarButtonSize, ActionBarDB.ActionBarButtonSize)
		Button:ClearAllPoints()
		Button:SetPoint("BOTTOM", MultiBarBottomLeftButton3, "TOP", 0, 5)
		_G[Button:GetName().."Highlight"]:SetTexture(nil)
		_G[Button:GetName().."NormalTexture"]:SetTexture(nil)
		StyleButton(Button)
	end)
end
