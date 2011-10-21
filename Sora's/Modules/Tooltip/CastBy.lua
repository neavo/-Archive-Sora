local function addAuraSource(self, func, unit, index, filter)
   local caster = select(8, func(unit, index, filter))
   if caster then
      local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
      local castername = UnitName(caster)
      local partypet, raidpet, color
      if UnitIsPlayer(caster) then
         color = colors[select(2,UnitClass(caster))]
         castername = format("|cff%02X%02X%02X%s|r" , color.r*255, color.g*255, color.b*255, UnitName(caster))
      else
         if caster == "pet" or caster == "vehicle" then
            color = colors[select(2,UnitClass("player"))]
            castername = format("|cff%02X%02X%02X%s|r%s%s", color.r*255, color.g*255, color.b*255, UnitName("player"), "|cffC0C0C0的|r", UnitName(caster))
         else
            partypet = caster:match("^partypet(%d+)$")
            raidpet = caster:match("^raidpet(%d+)$")
            if partypet then
               color = colors[select(2,UnitClass("party"..partypet))]
               castername = format("|cff%02X%02X%02X%s|r%s%s" , color.r*255, color.g*255, color.b*255, UnitName("party"..partypet), "|cffC0C0C0的|r", UnitName(caster))
            elseif raidpet then
               color = colors[select(2,UnitClass("party"..raidpet))]
               castername = format("|cff%02X%02X%02X%s|r%s%s" , color.r*255, color.g*255, color.b*255, UnitName("raid"..raidpet), "|cffC0C0C0的|r", UnitName(caster))
            end
         end
      end
      self:AddDoubleLine("Cast by：", castername)
      self:Show()
   end
end

local funcs = {
   SetUnitAura = UnitAura,
   SetUnitBuff = UnitBuff,
   SetUnitDebuff = UnitDebuff,
}

for k, v in pairs(funcs) do
   hooksecurefunc(GameTooltip, k, function(self, unit, index, filter)
      addAuraSource(self, v, unit, index, filter)
   end)
end