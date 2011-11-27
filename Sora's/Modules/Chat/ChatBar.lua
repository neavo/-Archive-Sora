-- Engines
local S, _, _, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ChatFramePanel", "AceTimer-3.0")

function Module:BuildChatbar()
	local Channel = {"/s ","/y ","/p ","/g ","/raid ","/1 ","/2 "}
	local Color = {
		{255/255, 255/255, 255/255}, 
		{255/255,  64/255,  64/255}, 
		{170/255, 170/255, 255/255}, 
		{ 64/255, 255/255,  64/255}, 
		{255/255, 127/255,   0/255}, 
		{210/255, 180/255, 140/255}, 
		{160/255, 120/255,  90/255}, 
		{255/255, 255/255,   0/255}, 
	}
	
	local PreButton = nil
	local Parent = CreateFrame("Frame", nil, UIParent)
	Parent:SetAlpha(0.3)
	for i = 1, 8 do
		local Button = nil
		if i <= 7 then
			Button = CreateFrame("Button", nil, Parent)
			Button:SetScript("OnClick", function()
				ChatFrame_OpenChat(Channel[i], chatFrame)
			end)
		end
		if i == 8 then
			Button = CreateFrame("Button", nil, Parent, "SecureActionButtonTemplate")
			Button:SetAttribute("*type*", "macro")
			Button:SetAttribute("macrotext", "/roll")
		end
		Button:SetSize((ChatFrame1:GetWidth()-6)/8, 10)
		Button:SetBackdrop({ 
			bgFile = DB.Statusbar, insets = {left = 2, right = 2, top = 2, bottom = 2}, 
			edgeFile = DB.GlowTex, edgeSize = 3, 
		})
		Button:SetBackdropColor(unpack(Color[i]))
		Button:SetBackdropBorderColor(0, 0, 0, 1)
		Button:SetScript("OnEnter", function(self)
			Parent:SetAlpha(1)
		end)
		Button:SetScript("OnLeave", function(self)
			Parent:SetAlpha(0.3)
		end)
		if i == 1 then
			Button:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, -11)
		else
			Button:SetPoint("LEFT", PreButton, "RIGHT", 0, 0)
		end
		
		PreButton = Button;
	end
end

function Module:OnEnable()
	Module:BuildChatbar()
end
