-- A simple quick chatbar,with low memory cost :)
-- Creat Date : July,20,2011
-- Email : Neavo7@gmail.com
-- Version : 0.1

----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig



local Channel = {"/s ","/y ","/p ","/g ","/raid ","/1 ","/2 "}
local Color = {
	{255/255, 255/255, 255/255, 0.8},
	{255/255,  64/255,  64/255, 0.8},
	{170/255, 170/255, 255/255, 0.8},
	{ 64/255, 255/255,  64/255, 0.8},
	{255/255, 127/255,   0/255, 0.8},
	{210/255, 180/255, 140/255, 0.8},
	{160/255, 120/255,  90/255, 0.8},
	{255/255, 255/255,   0/255, 0.8},
}

local Chatbar = CreateFrame("Frame","Chatbar",UIParent)
Chatbar:SetWidth(160)
Chatbar:SetHeight(16)
Chatbar:SetPoint("BOTTOM", ChatFrame1, "TOP", 125, 7)
Chatbar:SetScale(0.9)

for i=1,7 do
	local frame = CreateFrame("Button", "ChatBarButton"..i , Chatbar)
	frame:SetWidth(20)
	frame:SetHeight(Chatbar:GetHeight())
	if i == 1 then
		frame:SetPoint("LEFT",Chatbar,"LEFT",0,0)
	else
		frame:SetPoint("LEFT","ChatBarButton"..i-1,"RIGHT",0,0)
	end
	frame:SetBackdrop( { 
		bgFile = cfg.Statusbar,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
		edgeFile = cfg.edgeFile, edgeSize = 4, 
	}) 
	frame:SetBackdropColor(unpack(Color[i]))
	frame:SetBackdropBorderColor(0,0,0,1)	
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", function() 
		ChatFrame_OpenChat(Channel[i], chatFrame)
	end)
end

-- Roll --
local roll = CreateFrame("Button",nil, Chatbar, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetWidth(20)
roll:SetHeight(Chatbar:GetHeight())
roll:SetPoint("RIGHT",Chatbar,"RIGHT",0,0)
roll:SetBackdrop( { 
	bgFile = cfg.Statusbar,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
	edgeFile = cfg.edgeFile, edgeSize = 4, 
})
roll:SetBackdropColor(unpack(Color[8]))
roll:SetBackdropBorderColor(0,0,0,1)	
roll:RegisterForClicks("AnyUp")







