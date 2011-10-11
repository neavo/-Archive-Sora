----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MiscConfig

local function UpdateGlow(button, id)
	local quality, texture
	local Border = _G[button:GetName().."NormalTexture"]
	
	if Border then
		Border:SetTexture(nil)
	end
	
	if id then
		quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(id))
	end

	if not button.Border then
		button.Border = CreateFrame("Frame", nil, button)
		button.Border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
		button.Border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
		button.Border:SetBackdrop({
			edgeFile = cfg.Solid, edgeSize = 1,
		})
	end

	if texture then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if r==1 then
				r, g, b = 0, 0, 0
			end
		end
		button.Border:SetBackdropBorderColor(r, g, b)
		button.Border:Show()
	else
		button.Border:Hide()
	end
end


local slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Ranged", "Tabard",
}

local updatechar = function(self)
	if CharacterFrame:IsShown() then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Character"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink("player", slotID)

			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local updateinspect = function(self)
	local unit = InspectFrame.unit
	if InspectFrame:IsShown() and unit then
		for key, slotName in ipairs(slots) do
			local slotID = key % 20
			local slotFrame = _G["Inspect"..slotName.."Slot"]
			local slotLink = GetInventoryItemLink(unit, slotID)
			UpdateGlow(slotFrame, slotLink)
		end
	end	
end


-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:RegisterEvent("UNIT_INVENTORY_CHANGED")
Event:SetScript("OnEvent", function(self, event, addon)
	if event == "UNIT_INVENTORY_CHANGED" then
		updatechar()
	elseif event == "ADDON_LOADED" then
		if addon == "Blizzard_InspectUI" then
			InspectFrame:HookScript("OnShow", function()
				Event:RegisterEvent("PLAYER_TARGET_CHANGED")
				Event:RegisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", updateinspect)
				updateinspect()
			end)
			InspectFrame:HookScript("OnHide", function()
				Event:UnregisterEvent("PLAYER_TARGET_CHANGED")
				Event:UnregisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", nil)
			end)
			Event:UnregisterEvent("ADDON_LOADED")
		end
	end
end)
CharacterFrame:HookScript("OnShow", updatechar)