local _, ns = ...
local oUF = ns.oUF or oUF

local PrePriority = 0
local ZoneList = {}
local RaidDebuffList = {
	-- Baradin Hold
	[752] = {
		-- Demon Containment Unit
		{89354, 1},
		-- Argaloth
		{88942, 11}, -- Meteor Slash
		{88954, 12}, -- Consuming Darkness
		-- Occu'thar
		{96913, 21}, -- Searing Shadows
		-- Eye of Occu'thar
		{97028, 22}, -- Gaze of Occu'thar		
	},
	["AnyZone"] = {
	}
}

local Event = CreateFrame("Frame")
Event.Timer = 0
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Event:SetScript("OnEvent", function(self, event, ...)
    self:SetScript("OnUpdate", function(self, elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer < 5 then return end
		if IsInInstance() then
			SetMapToCurrentZone()
			local Zone = GetCurrentMapAreaID()
			ZoneList = RaidDebuffList["AnyZone"]
			if RaidDebuffList[Zone] then
				for _, value in pairs(RaidDebuffList[Zone]) do
					tinsert(ZoneList, value)
				end
			end
		else
			ZoneList = RaidDebuffList["AnyZone"]
		end
		self:SetScript("OnUpdate", nil)
	end)

    if event == "PLAYER_ENTERING_WORLD" then self:UnregisterEvent("PLAYER_ENTERING_WORLD") end
end)

local function ShouldBeShown(spellID)
	for key, value in pairs(ZoneList) do
		if value[1] == spellID and value[2] >= PrePriority then
			PrePriority = value[2]
			return true
		end
	end
	return false
end

local function Update(self, event, unit)
    if self.unit ~= unit then return end
	local RaidDebuff = self.RaidDebuff
	local index = 1
	local Flag = true
    while true do
		local name, _, icon, count, _, duration, expires, _, _, _, spellID  = UnitDebuff(unit, index)
		if not name then break end
		if ShouldBeShown(spellID) then
			if RaidDebuff.Icon then RaidDebuff.Icon:SetTexture(icon) end
			if RaidDebuff.Count then RaidDebuff.Count:SetText(count > 1 and count or nil) end
			if RaidDebuff.Cooldown then RaidDebuff.Cooldown:SetCooldown(expires-duration, duration) end
			RaidDebuff:Show()
			Flag = false
		end
		index = index + 1
	end
	if Flag and RaidDebuff:IsShown() then
		RaidDebuff:Hide()
		PrePriority = 0
		Update(self, event, unit)
	end
end

local function Enable(self)
	if self.RaidDebuff then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local function Disable(self)
	if self.RaidDebuff then self:UnregisterEvent("UNIT_AURA", Update) end
end

oUF:AddElement("RaidDebuff", Update, Enable, Disable)
