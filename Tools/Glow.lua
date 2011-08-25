--------------------------
-- SyDurGlow.lua
-- Author: Sayoc
-- Date: 10.01.23
--------------------------
local  q, vl
local G = getfenv(0)
local items = {
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Ranged 11",
	"Tabard",}

----------------------------------- Quality Glow --------------------------------------

local function colorTable(val)
	if val == 100 then
		return 0.9, 0, 0
	elseif val == 99 then
		return 1, 1, 0
	else
		return GetItemQualityColor(val)
	end
end

local function createBorder(self)
	local bc = self:CreateTexture(nil, "OVERLAY")
	bc:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	bc:SetBlendMode("ADD")
	bc:SetAlpha(0.6)

	bc:SetWidth(73)
	bc:SetHeight(73)

	bc:SetPoint("CENTER", self)
	self.bc = bc
end

local function QualityGlow(frame, quality)
	if quality and quality > 1 then
		if not frame.bcthen then
			createBorder(frame)
		end
		local border = frame.bc
		if border then
			local r, g, b = colorTable(quality)
			border:SetVertexColor(r, g, b)
			border:Show()
		end
	elseif frame.bc then
		frame.bc:Hide()
	end
end

local function UpdataCharacterGlow()
	if not CharacterFrame:IsVisible()then return end
	for i, vl in pairs(items) do
		local key, index = string.split(" ", vl)
		q = GetInventoryItemQuality("player", i)
		local self = G["Character"..key.."Slot"]

		if GetInventoryItemBroken("player", i) then
			q = 100
		elseif index and GetInventoryAlertStatus(index) == 3 then
			q = 99
		end

		QualityGlow(self, q)
	end
end

local function UpdataInspectGlow()
	if not InspectFrame:IsVisible() then return end	
	for i, value in pairs(items) do
		local key, index = string.split(" ", value)
		local link = GetInventoryItemLink("target", i)
		local self = G["Inspect"..key.."Slot"]

		if link then
			q = select(3, GetItemInfo(link))
			QualityGlow(self, q)
		elseif(self.bc) then
			self.bc:Hide()
		end
	end
end

local hookCF = CreateFrame("Frame")
hookCF:SetParent("CharacterFrame")
hookCF:SetScript("OnShow", UpdataCharacterGlow)

InspectFrame_LoadUI()
hooksecurefunc("InspectUnit", UpdataInspectGlow)

----------------------------------- Event --------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_TARGET_CHANGED")

f:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_INVENTORY_CHANGED" then
		UpdataCharacterGlow()
		UpdataInspectGlow()
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdataInspectGlow()
	end	
end)