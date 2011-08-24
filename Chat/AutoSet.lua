----------------
--  命名空间  --
----------------

local _, SR = ...
cfg = SR.ChatConfig




local AutoSet = true
if not AutoSet then return end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	for i = 1, NUM_CHAT_WINDOWS do
		local ChatFrame = _G["ChatFrame"..i]
		ChatFrame:SetFont(cfg.Font, 12, "THINOUTLINE") 
		ChatFrame:ClearAllPoints()
		ChatFrame:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",10,30)
		ChatFrame:SetWidth(360)
		ChatFrame:SetHeight(100)
		ChatFrame:SetFrameLevel(8)
		FCF_SetLocked(ChatFrame, true)
	end
	f:UnregisterEvent("PLAYER_LOGIN")
end)
