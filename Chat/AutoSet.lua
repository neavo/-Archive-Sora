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
	_G["ChatFrame1"]:SetFont(cfg.Font, 12, "THINOUTLINE") 
	_G["ChatFrame1"]:ClearAllPoints()
	_G["ChatFrame1"]:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",10,30)
	_G["ChatFrame1"]:SetWidth(360)
	_G["ChatFrame1"]:SetHeight(100)
	_G["ChatFrame1"]:SetFrameLevel(8)
	FCF_SetLocked(_G["ChatFrame1"], true)
	f:UnregisterEvent("PLAYER_LOGIN")
end)
