----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig




local AutoSet = true
if not AutoSet then return end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
	ChatFrame1:SetFont(cfg.Font, 12, "THINOUTLINE") 
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",10,30)
	ChatFrame1:SetWidth(340)
	ChatFrame1:SetHeight(100)
	ChatFrame1:SetFrameLevel(8)
	FCF_SetLocked(ChatFrame1, true)
	f:UnregisterEvent("PLAYER_LOGIN")
end)
