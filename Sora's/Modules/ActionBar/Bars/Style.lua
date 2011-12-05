-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Style")

local _G = _G
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

local function Style(self)
	local name = self:GetName()
	
	if name:match("MultiCast") then return end 
	if name:match("ExtraActionButton") then return end
	
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Name = _G[name.."Name"]
	local NormalTexture = _G[name.."NormalTexture"]
	
	if  _G[name.."FloatingBG"] then
		_G[name.."FloatingBG"]:Hide()
	end
	
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 	
	Border = function() end
 
	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 2, 2)
	Count:SetFont(DB.Font, ActionBarDB.FontSize, "THINOUTLINE")
 
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
	HotKey:SetFont(DB.Font, ActionBarDB.FontSize, "THINOUTLINE")
	HotKey.ClearAllPoints = function() end
	HotKey.SetPoint = function() end
 
	if ActionBarDB.HideHotKey then
		HotKey:SetText("")
		HotKey:Hide()
		HotKey.Show = function() end
	end
 
	if NormalTexture then
		NormalTexture:ClearAllPoints()
		NormalTexture:SetAllPoints()
	end
end

local function StyleSmallButton(NormalTexture, Button, Icon, IsPet)
	local Name = Button:GetName()
	
	Button:SetNormalTexture("")
	Button.SetNormalTexture = function() end
	
	local Flash	 = _G[Name.."Flash"]
	Flash:SetTexture("Interface\\Addons\\QulightUI\\Root\\Media\\button_hover")
	
	if not Icon.Shadow then
		S.MakeTexShadow(Button, Icon, 3)
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:ClearAllPoints()
		Icon:SetPoint("TOPLEFT", Button, 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
		if IsPet then
			local AutoCastable = _G[Name.."AutoCastable"]
			AutoCastable:ClearAllPoints()
			AutoCastable:SetPoint("TOPLEFT", -12, 12)
			AutoCastable:SetPoint("BOTTOMRIGHT", 12, -12)
		end
	end
	
	if _G[Name.."Shine"] then
		local Shine  = _G[Name.."Shine"]
		Shine:ClearAllPoints()
		Shine:SetAllPoints()
	end
	
	if NormalTexture then
		NormalTexture:ClearAllPoints()
		NormalTexture:SetAllPoints()
	end
end

function StyleShift()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local Button  = _G["ShapeshiftButton"..i]
		local Icon  = _G["ShapeshiftButton"..i.."Icon"]
		local NormalTexture  = _G["ShapeshiftButton"..i.."NormalTexture"]
		StyleSmallButton(NormalTexture, Button, Icon, false)
	end
end

function StylePet()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		local Icon = _G["PetActionButton"..i.."Icon"]
		local NormalTexture = _G["PetActionButton"..i.."NormalTexture2"]
		StyleSmallButton(NormalTexture, Button, Icon, true)
	end
end

local function updatehotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. "HotKey"]
	local text = hotkey:GetText()
	
	text = replace(text, "(s%-)", "S")
	text = replace(text, "(a%-)", "A")
	text = replace(text, "(c%-)", "C")
	text = replace(text, "(Mouse Button )", "M")
	text = replace(text, "(Mouse Wheel Up)", "MU")
	text = replace(text, "(Mouse Wheel Down)", "MD")
	text = replace(text, "(Middle Mouse)", "M3")
	text = replace(text, "(Num Pad )", "N")
	text = replace(text, "(Page Up)", "PU")
	text = replace(text, "(Page Down)", "PD")
	text = replace(text, "(Spacebar)", "SpB")
	text = replace(text, "(Insert)", "Ins")
	text = replace(text, "(Home)", "Hm")
	text = replace(text, "(Delete)", "Del")
	
	if hotkey:GetText() == _G["RANGE_INDICATOR"] then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

-- rescale cooldown spiral to fix texture.
local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "ShapeshiftButton", "PetActionButton", "MultiCastActionButton"}
for _, name in ipairs( buttonNames ) do
	for index = 1, 12 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]
 
		if ( button == nil or cooldown == nil ) then
			break
		end
		
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don"t have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			Style(_G["SpellFlyoutButton"..i])
			StyleButton(_G["SpellFlyoutButton"..i],true)
			_G["SpellFlyoutButton"..i]:SetFrameLevel(_G["SpellFlyoutButton"..i]:GetParent():GetFrameLevel() + 5)
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
local function styleflyout(self)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	

	

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

-- rework the mouseover, pushed, checked texture to match  theme.
do
	for i = 1, 12 do
		StyleButton(_G["ActionButton"..i],true)
		StyleButton(_G["MultiBarBottomLeftButton"..i],true)
		StyleButton(_G["MultiBarBottomRightButton"..i],true)
		StyleButton(_G["MultiBarLeftButton"..i],true)
		StyleButton(_G["MultiBarRightButton"..i],true)
	end
		 
	for i=1, 10 do
		StyleButton(_G["ShapeshiftButton"..i],true)
		StyleButton(_G["PetActionButton"..i],true)
	end
end

hooksecurefunc("ActionButton_Update", Style)
hooksecurefunc("ActionButton_UpdateHotkeys", updatehotkey)
hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)

if select(2, UnitClass("player"))== "SHAMAN" and MultiCastActionBarFrame then
	hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout", function(Flyout)
		Flyout.top:SetTexture(nil)
		Flyout.middle:SetTexture(nil)
		local last = nil
		
		for _, Button in ipairs(Flyout.buttons) do
			local Icon = select(1, Button:GetRegions())
			Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			Icon:SetDrawLayer("ARTWORK")
			Icon:SetPoint("TOPLEFT", 2, -2)
			Icon:SetPoint("BOTTOMRIGHT", -2, 2)		
			if not InCombatLockdown() then
				Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
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
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		if index == 1 then
			Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", ActionBarDB.ButtonSize+3*2, 0)
		elseif index == 2 then
			Button:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", 3, 0)
		elseif index == 3 then
			Button:SetPoint("LEFT", MultiCastSlotButton1, "RIGHT", 3, 0)
		elseif index == 4 then
			Button:SetPoint("LEFT", MultiCastSlotButton3, "RIGHT", 3, 0)		
		end
		StyleButton(Button)
	end
	hooksecurefunc("MultiCastSlotButton_Update", function(self, slot) StyleTotemSlotButton(self, tonumber(string.match(self:GetName(), "MultiCastSlotButton(%d)"))) end)

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
	hooksecurefunc("MultiCastSummonSpellButton_Update", function(Button)
		if not Button then return end
		local Icon = select(1, Button:GetRegions())
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Icon:SetPoint("TOPLEFT", 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", -2, 2)
		Button.Shadow = S.MakeTexShadow(Button, Icon, 4)
		Button:GetNormalTexture():SetTexture(nil)
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
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
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		Button:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 3, 0)	
		_G[Button:GetName().."Highlight"]:SetTexture(nil)
		_G[Button:GetName().."NormalTexture"]:SetTexture(nil)
		StyleButton(Button)
	end)
end

if ExtraActionBarFrame then
	ExtraActionBarFrame:SetParent(UIParent)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("BOTTOM", 0, 340)
	ExtraActionBarFrame.SetPoint = function() end
end