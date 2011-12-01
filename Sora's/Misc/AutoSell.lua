-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("MERCHANT_SHOW")
Event:SetScript("OnEvent", function(self)
	local Cost = 0
	for BagID = 0, 4 do
		for SlotID = 1, GetContainerNumSlots(BagID) do
			local Link = GetContainerItemLink(BagID, SlotID)
			if Link then
				local p = select(11, GetItemInfo(Link))*select(2, GetContainerItemInfo(BagID, SlotID))
				if select(3, GetItemInfo(Link)) == 0 and p > 0 then
					UseContainerItem(BagID, SlotID)
					PickupMerchantItem()
					Cost = Cost + p
				end
			end
		end
	end
	if Cost > 0 then
		local g, s, c = math.floor(Cost/10000) or 0, math.floor((Cost%10000)/100) or 0, Cost%100
		DEFAULT_CHAT_FRAME:AddMessage("共售出：".." |cffffffff"..g.."|cffffc125 G|r".." |cffffffff"..s.."|cffc7c7cf S|r".." |cffffffff"..c.."|cffeda55f C|r"..".", 255, 255, 255)
	end
end)