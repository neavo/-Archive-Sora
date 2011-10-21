-- Focuser v0.51 by slizen
local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any

local function SetFocusHotkey(frame)
	frame:SetAttribute(modifier.."-type"..mouseButton, "focus")
end

local function CreateFrame_Hook(type, name, parent, template)
	if name and template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end
end

hooksecurefunc("CreateFrame", CreateFrame_Hook)

local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
f:SetAttribute("type1", "macro")
f:SetAttribute("macrotext", "/focus mouseover")
SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton")

local duf = {
	PetFrame,
	PartyMemberFrame1,
	PartyMemberFrame2,
	PartyMemberFrame3,
	PartyMemberFrame4,
	PartyMemberFrame1PetFrame,
	PartyMemberFrame2PetFrame,
	PartyMemberFrame3PetFrame,
	PartyMemberFrame4PetFrame,
	PartyMemberFrame1TargetFrame,
	PartyMemberFrame2TargetFrame,
	PartyMemberFrame3TargetFrame,
	PartyMemberFrame4TargetFrame,
	TargetFrame,
	TargetFrameToT,
	TargetFrameToTTargetFrame,
}

for i, frame in pairs(duf) do
	SetFocusHotkey(frame)
end