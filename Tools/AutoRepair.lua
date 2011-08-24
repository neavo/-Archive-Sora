-- Contemplate v2.3 by Aeyan & yMerchant v0.7 by YLeaf
local addon = CreateFrame('Frame')
addon:SetScript('OnEvent', function(self, event, ...) if self[event] then return self[event](self, ...) end end)
addon:RegisterEvent('PLAYER_REGEN_ENABLED')
addon:RegisterEvent('PLAYER_REGEN_DISABLED')
addon:RegisterEvent('MERCHANT_SHOW')

local autoName = true
local AutoSellJunk = true
local AutoRepair = true
local UseGuildBank = true
local CustomSellList = {
	--[itemID] = true,
	--[17058] = true, -- Fish Oil
}

local function formats(value)
	local str = ''
	if value > 9999 then
		str = str .. format('|c00ffd700%dg|r', floor(value / 10000))
	end
	if value > 99 then
		str = str .. format('|c00c7c7cf%ds|r', (floor(value / 100) % 100))
	end
	str = str .. format('|c00eda55f%dc|r', (floor(value) % 100))
	return str
end

function addon:PLAYER_REGEN_ENABLED()
	if autoName then SetCVar('nameplateShowEnemies', 0) end
end

function addon:PLAYER_REGEN_DISABLED()
	if autoName then SetCVar('nameplateShowEnemies', 1) end
end

function addon:MERCHANT_SHOW()
	if AutoSellJunk then
		for bag=0,4 do
			for slot=0,GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link then
					local id = tonumber(link:match'item:(%d+):')
					if (select(3, GetItemInfo(id)) == 0) or CustomSellList[id] then
						ShowMerchantSellCursor(1)
						UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
	if AutoRepair and CanMerchantRepair() then
		local cost, canRepair = GetRepairAllCost()
		if canRepair then
			local str = formats(cost)
			if UseGuildBank and IsInGuild() and CanGuildBankRepair() and (GetGuildBankWithdrawMoney() >= cost or (GetGuildBankWithdrawMoney() == -1 and GetGuildBankMoney() >= cost)) then
				RepairAllItems(1)
				str = '公会修理 ' .. str
			elseif GetMoney() >= cost then
				RepairAllItems()
				str = '自费修理 ' .. str
			else
				DEFAULT_CHAT_FRAME:AddMessage('修理花费 ' .. str)
				return
			end
			PlaySound('ITEM_REPAIR')
			DEFAULT_CHAT_FRAME:AddMessage(str)
		end
	end
end