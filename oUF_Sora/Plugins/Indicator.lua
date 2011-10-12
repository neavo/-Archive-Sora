local _, ns = ...
local oUF = ns.oUF or oUF

local function SVal(val)
    if val >= 1e6 then
        return ("%.1fm"):format(val / 1e6):gsub("%.?0+([km])$", "%1")
    elseif val >= 1e4 then
        return ("%.1fk"):format(val / 1e3):gsub("%.?0+([km])$", "%1")
    else
        return val
    end
end

local function GetTime(expirationTime)
    if expirationTime - GetTime() > 0.5 then
        return ("|cffffff00"..numberize(expire).."|r")
    end
end

-- Priest
local pomCount = {"i","h","g","f","Z","Y"}
oUF.Tags["Indicator_pom"] = function(u) 
    local name, _,_, c, _,_,_, fromwho = UnitAura(u, GetSpellInfo(41635)) 
    if fromwho == "player" then
        if(c) then return "|cff66FFFF"..pomCount[c].."|r" end 
    else
        if(c) then return "|cffFFCF7F"..pomCount[c].."|r" end 
    end
end
oUF.TagEvents["Indicator_pom"] = "UNIT_AURA"

oUF.Tags["Indicator_rnw"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000".."M".."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900".."M".."|r"
        else
            return "|cff33FF33".."M".."|r"
        end
    end
end
oUF.TagEvents["Indicator_rnw"] = "UNIT_AURA"

oUF.Tags["Indicator_rnwTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(139))
    if(fromwho == "player") then return GetTime(expirationTime) end 
end
oUF.TagEvents["Indicator_rnwTime"] = "UNIT_AURA"

oUF.Tags["Indicator_pws"] = function(u) if UnitAura(u, GetSpellInfo(17)) then return "|cff33FF33".."M".."|r" end end
oUF.TagEvents["Indicator_pws"] = "UNIT_AURA"

oUF.Tags["Indicator_ws"] = function(u) if UnitDebuff(u, GetSpellInfo(6788)) then return "|cffFF9900".."M".."|r" end end
oUF.TagEvents["Indicator_ws"] = "UNIT_AURA"

oUF.Tags["Indicator_fw"] = function(u) if UnitAura(u, GetSpellInfo(6346)) then return "|cff8B4513".."M".."|r" end end
oUF.TagEvents["Indicator_fw"] = "UNIT_AURA"

oUF.Tags["Indicator_sp"] = function(u) if not UnitAura(u, GetSpellInfo(79107)) then return "|cff9900FF".."M".."|r" end end
oUF.TagEvents["Indicator_sp"] = "UNIT_AURA"

oUF.Tags["Indicator_fort"] = function(u) if not(UnitAura(u, GetSpellInfo(79105)) or UnitAura(u, GetSpellInfo(6307)) or UnitAura(u, GetSpellInfo(469))) then return "|cff00A1DE".."M".."|r" end end
oUF.TagEvents["Indicator_fort"] = "UNIT_AURA"

oUF.Tags["Indicator_pwb"] = function(u) if UnitAura(u, GetSpellInfo(81782)) then return "|cffEEEE00".."M".."|r" end end
oUF.TagEvents["Indicator_pwb"] = "UNIT_AURA"

-- Druid
local lbCount = { 4, 2, 3}
oUF.Tags["Indicator_lb"] = function(u) 
    local name, _,_, c,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(33763))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000"..lbCount[c].."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900"..lbCount[c].."|r"
        else
            return "|cffA7FD0A"..lbCount[c].."|r"
        end
    end
end
oUF.TagEvents["Indicator_lb"] = "UNIT_AURA"

oUF.Tags["Indicator_rejuv"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -2 then
            return "|cffFF0000".."M".."|r"
        elseif spellTimer > -4 then
            return "|cffFF9900".."M".."|r"
        else
            return "|cff33FF33".."M".."|r"
        end
    end
end
oUF.TagEvents["Indicator_rejuv"] = "UNIT_AURA"

oUF.Tags["Indicator_rejuvTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(774))
    if(fromwho == "player") then return GetTime(expirationTime) end 
end
oUF.TagEvents["Indicator_rejuvTime"] = "UNIT_AURA"

oUF.Tags["Indicator_regrow"] = function(u) if UnitAura(u, GetSpellInfo(8936)) then return "|cff00FF10".."M".."|r" end end
oUF.TagEvents["Indicator_regrow"] = "UNIT_AURA"

oUF.Tags["Indicator_wg"] = function(u) if UnitAura(u, GetSpellInfo(48438)) then return "|cff33FF33".."M".."|r" end end
oUF.TagEvents["Indicator_wg"] = "UNIT_AURA"

oUF.Tags["Indicator_motw"] = function(u) if not(UnitAura(u, GetSpellInfo(79060)) or UnitAura(u,GetSpellInfo(79063))) then return "|cff00A1DE".."M".."|r" end end
oUF.TagEvents["Indicator_motw"] = "UNIT_AURA"

-- Warrior
oUF.Tags["Indicator_stragi"] = function(u) if not(UnitAura(u, GetSpellInfo(6673)) or UnitAura(u, GetSpellInfo(57330)) or UnitAura(u, GetSpellInfo(8076))) then return "|cffFF0000".."M".."|r" end end
oUF.TagEvents["Indicator_stragi"] = "UNIT_AURA"

oUF.Tags["Indicator_vigil"] = function(u) if UnitAura(u, GetSpellInfo(50720)) then return "|cff8B4513".."M".."|r" end end
oUF.TagEvents["Indicator_vigil"] = "UNIT_AURA"

-- Shaman
oUF.Tags["Indicator_rip"] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return "|cff00FEBF".."M".."|r" end
end
oUF.TagEvents["Indicator_rip"] = "UNIT_AURA"

oUF.Tags["Indicator_ripTime"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(61295))
    if(fromwho == "player") then return GetTime(expirationTime) end 
end
oUF.TagEvents["Indicator_ripTime"] = "UNIT_AURA"

local earthCount = {"i","h","g","f","p","q","Z","Z","Y"}
oUF.Tags["Indicator_earth"] = function(u) 
    local c = select(4, UnitAura(u, GetSpellInfo(974))) if c then return "|cffFFCF7F"..earthCount[c].."|r" end 
end
oUF.TagEvents["Indicator_earth"] = "UNIT_AURA"

-- Paladin
oUF.Tags["Indicator_might"] = function(u) if not(UnitAura(u, GetSpellInfo(53138)) or UnitAura(u, GetSpellInfo(79102))) then return "|cffFF0000".."M".."|r" end end
oUF.TagEvents["Indicator_might"] = "UNIT_AURA"

oUF.Tags["Indicator_beacon"] = function(u)
    local name, _,_,_,_,_, expirationTime, fromwho = UnitAura(u, GetSpellInfo(53563))
    if not name then return end
    if(fromwho == "player") then
        local spellTimer = GetTime()-expirationTime
        if spellTimer > -30 then
            return "|cffFF00004|r"
        else
            return "|cffFFCC003|r"
        end
    else
        return "|cff996600Y|r" -- other pally"s beacon
    end
end
oUF.TagEvents["Indicator_beacon"] = "UNIT_AURA"

oUF.Tags["Indicator_forbearance"] = function(u) if UnitDebuff(u, GetSpellInfo(25771)) then return "|cffFF9900".."M".."|r" end end
oUF.TagEvents["Indicator_forbearance"] = "UNIT_AURA"

-- Warlock
oUF.Tags["Indicator_di"] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(85767)) 
    if fromwho == "player" then
        return "|cff6600FF".."M".."|r"
    elseif name then
        return "|cffCC00FF".."M".."|r"
    end
end
oUF.TagEvents["Indicator_di"] = "UNIT_AURA"

oUF.Tags["Indicator_ss"] = function(u) 
    local name, _,_,_,_,_,_, fromwho = UnitAura(u, GetSpellInfo(20707)) 
    if fromwho == "player" then
        return "|cff6600FFY|r"
    elseif name then
        return "|cffCC00FFY|r"
    end
end
oUF.TagEvents["Indicator_ss"] = "UNIT_AURA"

-- Mage
oUF.Tags["Indicator_int"] = function(u) if not(UnitAura(u, GetSpellInfo(1459))) then return "|cff00A1DE".."M".."|r" end end
oUF.TagEvents["Indicator_int"] = "UNIT_AURA"

oUF.Tags["Indicator_fmagic"] = function(u) if UnitAura(u, GetSpellInfo(54648)) then return "|cffCC00FF".."M".."|r" end end
oUF.TagEvents["Indicator_fmagic"] = "UNIT_AURA"

ns.classIndicators = {
    ["DRUID"] = {
        ["TL"] = "",
        ["TR"] = "[Indicator_motw]",
        ["BL"] = "[Indicator_regrow][Indicator_wg]",
        ["BR"] = "[Indicator_lb]",
        ["Cen"] = "[Indicator_rejuvTime]",
    },
    ["PRIEST"] = {
        ["TL"] = "[Indicator_pws][Indicator_ws]",
        ["TR"] = "[Indicator_fw][Indicator_sp][Indicator_fort]",
        ["BL"] = "[Indicator_rnw][Indicator_pwb]",
        ["BR"] = "[Indicator_pom]",
        ["Cen"] = "[Indicator_rnwTime]",
    },
    ["PALADIN"] = {
        ["TL"] = "[Indicator_forbearance]",
        ["TR"] = "[Indicator_might][Indicator_motw]",
        ["BL"] = "",
        ["BR"] = "[Indicator_beacon]",
        ["Cen"] = "",
    },
    ["WARLOCK"] = {
        ["TL"] = "",
        ["TR"] = "[Indicator_di]",
        ["BL"] = "",
        ["BR"] = "[Indicator_ss]",
        ["Cen"] = "",
    },
    ["WARRIOR"] = {
        ["TL"] = "[Indicator_vigil]",
        ["TR"] = "[Indicator_stragi][Indicator_fort]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["DEATHKNIGHT"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["SHAMAN"] = {
        ["TL"] = "[Indicator_rip]",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "[Indicator_earth]",
        ["Cen"] = "[Indicator_ripTime]",
    },
    ["HUNTER"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["ROGUE"] = {
        ["TL"] = "",
        ["TR"] = "",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    },
    ["MAGE"] = {
        ["TL"] = "",
        ["TR"] = "[Indicator_int]",
        ["BL"] = "",
        ["BR"] = "",
        ["Cen"] = "",
    }
}
