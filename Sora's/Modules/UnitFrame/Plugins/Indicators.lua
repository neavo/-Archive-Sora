-- Engines
local _, ns = ...
local oUF = ns.oUF or oUF
local _, _, _, DB = unpack(select(2, ...))

local ClassList = {
	["DEATHKNIGHT"] = {
		nil,
		57330, -- 寒冬号角
	}, 
	["DRUID"] = {
		33763, -- Lifebloom
		8936, -- Regrowth
		774, -- Rejuvenation
		48438, -- Wild Growth
	}, 
	["HUNTER"] = {
		34477, -- Misdirection
	}, 
	["MAGE"] = {
		54646, -- Focus Magic
	}, 
	["PALADIN"] = {
		53563, -- Beacon of Light
		25771, -- Forbearance
	}, 
	["PRIEST"] = { 
		17, -- Power Word: Shield
		139, -- Renew
		33076, -- Prayer of Mending
		6788, -- Weakened Soul
	}, 
	["ROGUE"] = {
		57934, -- Tricks of the Trade
	}, 
	["SHAMAN"] = {
		974, -- Earth Shield
		61295, -- Riptide
	}, 
	["WARLOCK"] = {
		20707, -- Soulstone Resurrection
	}, 
	["WARRIOR"] = {
		50720, -- Vigilance
	}
}
local IndicatorList = ClassList[DB.MyClass]

do
	wipe(ClassList)
end

local function OnUpdate(self, elapsed)
	self.Timer = self.expires-GetTime()
	if self.Timer < 3 then
		self:SetBackdropColor(0.9, 0, 0)
	elseif self.Timer < 6 then
		self:SetBackdropColor(0.9, 0.7, 0)		
	else
		self:SetBackdropColor(0, 0.9, 0)
	end
end

local function Update(self, event, unit)
    if self.unit ~= unit then return end
	local Indicators = self.Indicators
	for key, value in pairs(IndicatorList) do
		local Name = GetSpellInfo(value)
		local Indicator = Indicators[key]
		if select(8, UnitBuff(unit, Name)) == "player" then
			Indicator.expires = select(7, UnitBuff(unit, Name))
			Indicator.Timer = 0
			Indicator:Show()
			Indicator:SetScript("OnUpdate", OnUpdate)
		elseif select(8, UnitDebuff(unit, Name)) == "player" then
			Indicator.expires = select(7, UnitDebuff(unit, Name))
			Indicator.Timer = 0
			Indicator:Show()
			Indicator:SetScript("OnUpdate", OnUpdate)
		else
			Indicator:Hide()
			Indicator:SetScript("OnUpdate", nil)			
		end
	end
end

local function Enable(self)
	if self.Indicators then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local function Disable(self)
	if self.Indicators then self:UnregisterEvent("UNIT_AURA", Update) end
end

oUF:AddElement("Indicators", Update, Enable, Disable)
