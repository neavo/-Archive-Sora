----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig

if not cfg.AutoSet then return end

-- Event 
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, event, ...)
    FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, 11) 
    ChatFrame1:ClearAllPoints()
    ChatFrame1:SetPoint("BOTTOMLEFT", 5, 23)
    ChatFrame1:SetWidth(320)
    ChatFrame1:SetHeight(100)
    ChatFrame1:SetUserPlaced(true)
	for i=1,10 do local cf = _G["ChatFrame"..i] FCF_SetWindowAlpha(cf, 0) end
    FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end)
