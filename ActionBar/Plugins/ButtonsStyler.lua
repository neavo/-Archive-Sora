----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ActionBarConfig
 
local function SetIconTexture(self, crop)
	if crop == 1 then self:SetTexCoord(.1, .9, .1, .9) end
	self:SetPoint("TOPLEFT", 2, -2)
	self:SetPoint("BOTTOMRIGHT", -2, 2)
end

local function SetOverlay(self)
	if self and not _G[self:GetName().."Overlay"] then
		local Overlay = CreateFrame("Frame", self:GetName().."Overlay", self)
		Overlay:SetPoint("TOPLEFT", -3, 3)
		Overlay:SetPoint("BOTTOMRIGHT", 3, -3)
		Overlay:SetBackdrop({edgeFile = cfg.GlowTex , edgeSize = 5})
		Overlay:SetBackdropBorderColor(0,0,0,1)
	end
end

local function SetNormalTexture(self)
	if self then
		self:SetTexture(cfg.Texture)
		self:SetPoint("TOPLEFT")
		self:SetPoint("BOTTOMRIGHT")
		self:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
	end
end

local function SetPushedTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.pushed.r, cfg.colors.pushed.g, cfg.colors.pushed.b)
end

local function SetHighlightTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.highlight.r, cfg.colors.highlight.g, cfg.colors.highlight.b)
end

local function SetCheckedTexture(self)
	self:SetTexture(cfg.Texture)
	self:SetVertexColor(cfg.colors.checked.r, cfg.colors.checked.g, cfg.colors.checked.b)
end

local function SetTextures(self, checked)
	SetIconTexture(_G[self:GetName().."Icon"], 1)
	SetOverlay(self)
	SetNormalTexture(self:GetNormalTexture())
	SetPushedTexture(self:GetPushedTexture())
	SetHighlightTexture(self:GetHighlightTexture())
	if checked == 1 then SetCheckedTexture(self:GetCheckedTexture()) end
end

local function ActionButtons(self)
	_G[self:GetName().."Border"]:Hide()
	_G[self:GetName().."Flash"]:Hide()
	local hk = _G[self:GetName().."HotKey"]
		hk:SetFont(cfg.Font, cfg.HotkeyFontSize, "THINOUTLINE")
		hk:SetPoint("TOPRIGHT")
	local name = _G[self:GetName().."Name"]
	name:SetFont(cfg.Font, cfg.NameFontSize, "THINOUTLINE")
	if cfg.HideMacroName then
		name:Hide()
 	end
	local count = _G[self:GetName().."Count"]
		count:SetFont(cfg.Font, cfg.CountFontSize, "THINOUTLINE")
	SetTextures(self, 1)
end
 
function VehicleButtons(self)
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		local hk = _G["VehicleMenuBarActionButton"..i.."HotKey"]
	hk:SetFont(cfg.Font, cfg.HotkeyFontSize, "THINOUTLINE")
	hk.SetPoint = hk:SetPoint("TOPLEFT")
	end
end
 
local function MultiCastSlotButtons(self,slot)
	self:SetNormalTexture(cfg.Texture)
	local tex = self:GetNormalTexture()
	tex:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
	SetHighlightTexture(self:GetHighlightTexture())
	self.overlayTex.SetTexture = function() end
	self.overlayTex.Show = function() end
	self.overlayTex:Hide()
end

local function MultiCastSpellButtons(self)
	_G[self:GetName().."Highlight"]:Hide()
	SetTextures(self)
	local hk = _G[self:GetName().."HotKey"]
	hk:SetFont(cfg.Font, cfg.HotkeyFontSize, "THINOUTLINE")
	hk:SetPoint("TOPRIGHT")
end

local function FlyoutSlotSpells(self, slot, ...)
	local numSpells = select("#", ...) + 1
	for i = 1, numSpells do
		self.buttons[i]:SetNormalTexture(cfg.Texture)
		local it, ht, nt = self.buttons[i]:GetRegions()
		if i ~= 1 then
			SetIconTexture(it, 1)
		else
			SetIconTexture(it)
		end
		SetHighlightTexture(ht)
		nt:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
	end
 end

local function FlyoutPageSpells(self)
	for i, spellId in next, TOTEM_MULTI_CAST_SUMMON_SPELLS do
	 if IsSpellKnown(spellId) then
		self.buttons[i]:SetNormalTexture(cfg.Texture)
		local it, ht, nt = self.buttons[i]:GetRegions()
		SetIconTexture(it, 1)
		SetHighlightTexture(ht)
		nt:SetVertexColor(cfg.colors.normal.r, cfg.colors.normal.g, cfg.colors.normal.b)
 	end
	end
 end

local function PetActionButtons()
	for i = 1, NUM_PET_ACTION_SLOTS do
		SetTextures(_G["PetActionButton"..i], 1)
	end
end

local function ShapeshiftButtons()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i.."Flash"]:Hide()
		SetTextures(_G["ShapeshiftButton"..i], 1)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i = 1, buttons do
		if _G["SpellFlyoutButton"..i] then
			local self = _G["SpellFlyoutButton"..i]
			local tex = self:GetNormalTexture()
			self:SetNormalTexture(cfg.Texture)
			SetTextures(self)
		end

	end
end

local function FlyoutButtons(self)
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	for i = 1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
end

-- the default function has a bug and once you move a button the alpha stays at 0.5, this gets fixed here
local function ActionButtons_fixgrid(button)
	local nt	= _G[button:GetName().."NormalTexture"]
	nt:SetVertexColor(cfg.colors.normal.r,cfg.colors.normal.g,cfg.colors.normal.b,1)
end
 
-- Key-binding shortcuts thx Tuller for this idea
local function updatehotkey(self, actionButtonType)
	local replace = string.gsub
	local hotkey = _G[self:GetName() .. 'HotKey']
	local	key = hotkey:GetText()
	key = replace(key, '(s%-)', 'S')
	key = replace(key, '(a%-)', 'A')
	key = replace(key, '(c%-)', 'C')
	key = replace(key, '(Mouse Button )', 'M')
	key = replace(key, '(Middle Mouse)', 'M3')
	key = replace(key, '(Mouse Wheel Down)', 'MWD')
	key = replace(key, '(Mouse Wheel Up)', 'MWU')
	key = replace(key, '(Num Pad )', 'N')
	key = replace(key, '(Page Up)', 'PU')
	key = replace(key, '(Page Down)', 'PD')
	key = replace(key, '(Spacebar)', 'SpB')
	key = replace(key, '(Insert)', 'Ins')
	key = replace(key, '(Home)', 'Hm')
	key = replace(key, '(Delete)', 'Del')
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(key)
	end
	if cfg.HideHotKey then
		hotkey:Hide()
	end
end

---------------------------------------------------
-- Hooks
---------------------------------------------------
hooksecurefunc("ActionButton_Update", ActionButtons)
hooksecurefunc("ActionButton_Update", VehicleButtons)
hooksecurefunc("ActionButton_ShowGrid", ActionButtons_fixgrid)
hooksecurefunc("PetActionBar_Update", PetActionButtons)
hooksecurefunc("ShapeshiftBar_UpdateState", ShapeshiftButtons)

SpellFlyout:HookScript("OnShow", SetupFlyoutButton)
hooksecurefunc("ActionButton_UpdateFlyout", FlyoutButtons)

if select(2, UnitClass("player"))=="SHAMAN" and MultiCastActionBarFrame then
	hooksecurefunc("MultiCastSlotButton_Update", MultiCastSlotButtons)
	hooksecurefunc("MultiCastActionButton_Update", MultiCastSlotButtons)
	hooksecurefunc("MultiCastSummonSpellButton_Update", MultiCastSpellButtons)
	hooksecurefunc("MultiCastRecallSpellButton_Update", MultiCastSpellButtons)
	MultiCastFlyoutFrame.top:Hide()
	MultiCastFlyoutFrame.middle:Hide()
	hooksecurefunc("MultiCastFlyoutFrame_LoadSlotSpells", FlyoutSlotSpells)
	hooksecurefunc("MultiCastFlyoutFrame_LoadPageSpells", FlyoutPageSpells)
end
