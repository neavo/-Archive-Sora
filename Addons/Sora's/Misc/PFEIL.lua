--[[

	[Player Frame] Equipped Item Level (PFEIL) - version 1.1 (4/10/11)
	Nephaliana(Ryan) - Frostmane (US)

	Change Log
	==========
	1.1		- Updated method of checking for two-handed weapons
					(Fixes localization and the major Titan's Grip issue).

	1.0		- Initial Release
	==========

]]--

local PFEIL = CreateFrame("Frame")

local PFEIL_EQUIPPED_ITEM_LEVEL = "已装备物品等级"
local PFEIL_EQUIPPED_ITEM_LEVEL_DESC = "已装备的物品的平均物品等级"

local ilvl
local slotList = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot"
}

PFEIL.UpdateItemLevel = function(self)
	local slotID
	local itemID
	local level
	local itemSubtype
	local sum = 0
	local count = #slotList -- the number of equippable items (one for every slot)
	local mh2h = false
	local oheqp = false

	for k,v in pairs(slotList) do -- Loop through the list of item slots
		slotID = GetInventorySlotInfo(v) -- Get which number is associated with the slot name
		itemID = GetInventoryItemID("player", slotID) -- Get the item id of the equipped item
		if itemID then -- If item exists (something is equipped)
			level, _, _, _, _, itemSubtype = select(4, GetItemInfo(itemID)) -- Grab its item level and item subtype
			if level then -- Can be assumed to be true -- ensures GetItemInfo returned values
				sum = sum + level -- Keep a running subtotal of item levels
				if v == "MainHandSlot" and itemSubtype == "INVTYPE_2HWEAPON" then -- If 2H item is equipped in main hand slot
					mh2h = true -- set the flag to be checked later
				elseif v == "SecondaryHandSlot" then -- If something is in the off-hand slot
					oheqp = true -- set the flag to be checked later
				end
			end
		end
	end

	if mh2h and not oheqp then -- If main hand weapon is a 2hander, and there is no off-hand weapon
		count = count - 1 -- Decrement count by one (removes penalty for missing off-hand)
	end									-- Valid except for TG fury warriors with only MH weapon (rare case, so we ignore it)

	ilvl = floor(sum / count) -- Find the average, truncate any fractional part

	return ilvl
end

PFEIL.GetEquippedItemLevel = function(self)
	return ilvl or self:UpdateItemLevel() -- Return the item level if it is already calculated, or calculate it now
end

PFEIL.SetItemLevel = function(self, statFrame, unit)
	-- If this is being called for someone besides the current player, leave the function early
	if ( unit ~= "player" ) then
		statFrame:Hide()
		return
	end
	_G[statFrame:GetName().."Label"]:SetText(format(STAT_FORMAT, PFEIL_EQUIPPED_ITEM_LEVEL)) -- Set the text for the stat label
	local text = _G[statFrame:GetName().."StatText"] -- Grab the frame that holds the text
	local eqpItemLevel = self:GetEquippedItemLevel() -- Get the equipped item level
	text:SetText(eqpItemLevel) -- Set the stat text to the equipped item level
	-- Set the tooltip values
	statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, PFEIL_EQUIPPED_ITEM_LEVEL).." "..eqpItemLevel..FONT_COLOR_CODE_CLOSE
	statFrame.tooltip2 = PFEIL_EQUIPPED_ITEM_LEVEL_DESC
end

-- Tell the game how to update the Equipped Item Level stat
PAPERDOLL_STATINFO["EQUIPPEDITEMLEVEL"] = {
	updateFunc = function(statFrame, unit) PFEIL:SetItemLevel(statFrame, unit) end
}

-- Add Equipped Item Level to the list of stats
for k,v in pairs(PAPERDOLL_STATCATEGORIES["GENERAL"].stats) do -- Loop through existing "General" stats
	if v == "ITEMLEVEL" then -- Find the Item Level stat
		tinsert(PAPERDOLL_STATCATEGORIES["GENERAL"].stats, k+1, "EQUIPPEDITEMLEVEL") -- Insert Equipped Item Level after it
		break
	end
end

PFEIL:SetScript("OnEvent", PFEIL.UpdateItemLevel) -- Update the stored average on event trigger
PFEIL:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")   -- Trigger when player's equipment changes