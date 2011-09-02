----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig

if not cfg.AutoSet then return end


-- Event 
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent", function()
	ChatFrame1:SetFont(cfg.Font, 12, "THINOUTLINE") 
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",10,30)
	ChatFrame1:SetWidth(340)
	ChatFrame1:SetHeight(100)
	ChatFrame1:SetFrameLevel(8)
	FCF_SetLocked(ChatFrame1, true)
	Event:UnregisterEvent("PLAYER_LOGIN")
end)
