-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("MERCHANT_SHOW")
Event:SetScript("OnEvent", function(self)

	-- 自动出售垃圾
	local c = 0
	for b=0,4 do
		for s=1,GetContainerNumSlots(b) do
			local l = GetContainerItemLink(b, s)
			if l then
				local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
				if select(3, GetItemInfo(l))==0 and p>0 then
					UseContainerItem(b, s)
					PickupMerchantItem()
					c = c+p
				end
			end
		end
	end
	if c>0 then
		local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
		DEFAULT_CHAT_FRAME:AddMessage("共售出：".." |cffffffff"..g.."|cffffc125 G|r".." |cffffffff"..s.."|cffc7c7cf S|r".." |cffffffff"..c.."|cffeda55f C|r"..".",255,255,255)
	end
	
	-- 自动修理
	if CanMerchantRepair() then
		local cost, possible = GetRepairAllCost()
		if cost>0 then
			local c = cost%100
			local s = math.floor((cost%10000)/100)
			local g = math.floor(cost/10000)
			if IsInGuild() then
				local guildMoney = GetGuildBankWithdrawMoney()
				if guildMoney > GetGuildBankMoney() then
					guildMoney = GetGuildBankMoney()
				end
				if guildMoney > cost and CanGuildBankRepair() then
					RepairAllItems(1)
					DEFAULT_CHAT_FRAME:AddMessage("|cffffff00您修理装备花费了公会：|r"..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
					return
				end
			end
			if possible then
				RepairAllItems()
				DEFAULT_CHAT_FRAME:AddMessage("|cffffff00您修理装备花费了：|r"..format(GOLD_AMOUNT_TEXTURE, g, 0, 0).." "..format(SILVER_AMOUNT_TEXTURE, s, 0, 0).." "..format(COPPER_AMOUNT_TEXTURE, c, 0, 0),255,255,255)
			else
				DEFAULT_CHAT_FRAME:AddMessage("您没有足够的金币以完成修理！",255,0,0)
			end
		end
	end
end)

-- 按住Alt一次购买一组
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if IsAltKeyDown() then
		local itemLink = GetMerchantItemLink(self:GetID())
		if not itemLink then
			return
		end
		local maxStack = select(8, GetItemInfo(itemLink))
		if maxStack and maxStack > 1 then
			BuyMerchantItem(self:GetID(), GetMerchantItemMaxStack(self:GetID()))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end