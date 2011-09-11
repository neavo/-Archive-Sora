----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig

if not cfg.AutoSet then return end


-- Event 
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function()
	ChatFrame1:SetFont(cfg.Font, 11, "THINOUTLINE")
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 30)
	ChatFrame1:SetWidth(320)
	ChatFrame1:SetHeight(100)
	FCF_SetLocked(ChatFrame1, true)
	Event:UnregisterEvent("PLAYER_ENTERING_WORLD")
end)
