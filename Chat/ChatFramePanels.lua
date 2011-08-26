----------------
--  ÃüÃû¿Õ¼ä  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig




for i = 1, NUM_CHAT_WINDOWS do

	local parent

	parent = _G["ChatFrame"..i]	
	local chatframe = CreateFrame("Frame",nil,parent)
	chatframe:SetPoint("TOPLEFT",parent,"TOPLEFT",-5,8)
	chatframe:SetPoint("BOTTOMRIGHT",parent,"BOTTOMRIGHT",5,-8)
	chatframe:SetFrameLevel("0")
	chatframe:SetBackdrop( { 
		bgFile = cfg.bgFile,
		edgeFile = cfg.edgeFile, edgeSize = 3, 
		insets = { left = 4, right = 4, top = 4, bottom = 5 }
	})
	chatframe:SetBackdropColor(1,1,1,0.6)
	chatframe:SetBackdropBorderColor(0,0,0,0.8)
	local editbox = CreateFrame("Frame",nil,chatframe)
	editbox:SetHeight(23)
	editbox:SetPoint("TOPLEFT",chatframe,"BOTTOMLEFT",0,2)
	editbox:SetPoint("TOPRIGHT",chatframe,"BOTTOMRIGHT",0,2)
	editbox:SetFrameLevel("1")
	editbox:SetBackdrop( { 
		bgFile = cfg.bgFile,
		edgeFile = cfg.edgeFile, edgeSize = 3, 
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	editbox:SetBackdropColor(1,1,1,0.6)
	editbox:SetBackdropBorderColor(0,0,0,0.8)
	
end






