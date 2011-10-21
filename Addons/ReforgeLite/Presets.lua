-- Part of ReforgeLite by d07.RiV (Iroared)
-- All rights reserved

local L = ReforgeLiteLocale

----------------------------------------- CAP PRESETS ---------------------------------

function ReforgeLite:RatingPerPoint (stat, level)
  level = level or UnitLevel ("player")
  local factor
  if level <= 34 and (stat == self.STATS.DODGE or stat == self.STATS.PARRY) then
    factor = 0.5
  elseif level <= 10 then
    factor = 1 / 26
  elseif level <= 60 then
    factor = (level - 8) / 52
  elseif level <= 70 then
    factor = 82 / (262 - 3 * level)
  elseif level <= 80 then
    factor = (82 / 52) * math.pow (131 / 63, (level - 70) / 10)
  else
    factor = (82 / 52) * (131 / 63)
    if level == 81 then
      factor = factor * 1.31309
    elseif level == 82 then
      factor = factor * 1.72430
    elseif level == 83 then
      factor = factor * 2.26519
    elseif level == 84 then
      factor = factor * 2.97430
    elseif level == 85 then
      factor = factor * 3.90537
    end
  end
  if stat == self.STATS.DODGE or stat == self.STATS.PARRY then
    return factor * 13.8
  elseif stat == self.STATS.HIT then
    return factor * 9.37931
  elseif stat == self.STATS.SPELLHIT then
    return factor * 8
  elseif stat == self.STATS.HASTE then
    return factor * 10
  elseif stat == self.STATS.CRIT then
    return factor * 14
  elseif stat == self.STATS.EXP then
    return factor * 2.34483
  elseif stat == self.STATS.MASTERY then
    return factor * 14
  end
  return 0
end
function ReforgeLite:GetMeleeHitBonus ()
  return GetHitModifier () or 0
end
function ReforgeLite:GetSpellHitBonus ()
  return GetSpellHitModifier () or 0
end
function ReforgeLite:GetExpertiseBonus ()
  return GetExpertise () - math.floor (GetCombatRatingBonus (CR_EXPERTISE))
end
function ReforgeLite:GetNeededMeleeHit ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.max (0, 5 + 0.5 * diff)
  else
    return 2 + 2 * diff
  end
end
function ReforgeLite:GetNeededSpellHit ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.max (0, 4 + diff)
  else
    return 11 * diff - 16
  end
end
function ReforgeLite:GetNeededExpertiseSoft ()
  local diff = self.pdb.targetLevel
  return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
end
function ReforgeLite:GetNeededExpertiseHard ()
  local diff = self.pdb.targetLevel
  if diff <= 2 then
    return math.ceil (math.max (0, 5 + 0.5 * diff) / 0.25)
  else
    return math.ceil (14 / 0.25)
  end
end

ReforgeLite.capPresets = {
  {
    value = 1,
    name = L["Manual"],
    getter = nil
  },
  {
    value = 2,
    name = L["Melee hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 3,
    name = L["Spell hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.SPELLHIT) * (ReforgeLite:GetNeededSpellHit () - ReforgeLite:GetSpellHitBonus ())
    end
  },
  {
    value = 4,
    name = L["Melee DW hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () + 19 - ReforgeLite:GetMeleeHitBonus ())
    end
  },
  {
    value = 5,
    name = L["Expertise soft cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseSoft () - ReforgeLite:GetExpertiseBonus ())
    end
  },
  {
    value = 6,
    name = L["Expertise hard cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.EXP) * (ReforgeLite:GetNeededExpertiseHard () - ReforgeLite:GetExpertiseBonus ())
    end
  },
  {
    value = 7,
    name = L["Fury secondary hit cap"],
    getter = function ()
      return ReforgeLite:RatingPerPoint (ReforgeLite.STATS.HIT) * (ReforgeLite:GetNeededMeleeHit () - ReforgeLite:GetMeleeHitBonus () + 2)
    end
  },
}

----------------------------------------- WEIGHT PRESETS ------------------------------

local StatSpirit = 1
local StatDodge = 2
local StatParry = 3
local StatHit = 4
local StatCrit = 5
local StatHaste = 6
local StatExp = 7
local StatMastery = 8
local MeleeHitCap = 2
local SpellHitCap = 3
local MeleeDWHitCap = 4
local ExpSoftCap = 5
local ExpHardCap = 6
local FuryHitCap = 7
local AtLeast = 1
local AtMost = 2

local MeleeCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = MeleeHitCap
      }
    }
  },
  {
    stat = StatExp,
    points = {
      {
        method = AtLeast,
        preset = ExpSoftCap
      }
    }
  }
}
local RangedCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = MeleeHitCap
      }
    }
  }
}
local CasterCaps = {
  {
    stat = StatHit,
    points = {
      {
        method = AtLeast,
        preset = SpellHitCap
      }
    }
  }
}

ReforgeLite.presets = {
  ["DEATHKNIGHT"] = {
    ["Blood"] = {
      tanking = "DEATHKNIGHT",
      weights = {
        0, 100 * 200, 100 * 200, 20, 0, 0, 40, 120
      },
    },
    ["Frost"] = {
      ["2H Weapon"] = {
        weights = {
          0, 0, 0, 190, 117, 138, 154, 124
        },
        caps = MeleeCaps,
      },
      ["Dual Wielding"] = {
        weights = {
          0, 0, 0, 220, 109, 168, 147, 138
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 50,
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Unholy"] = {
      weights = {
        0, 0, 0, 267, 126, 164, 98, 133
      },
      caps = MeleeCaps,
    },
  },
  ["DRUID"] = {
    ["Balance"] = {
      weights = {
        0, 0, 0, 240, 87, 215, 0, 145
      },
      caps = CasterCaps,
    },
    ["Feral Combat"] = {
      ["Bear"] = {
--          tanking = "DRUID",
        weights = {
          0, 88, 0, 15, 28, 4, 30, 48
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                preset = MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
                after = 15,
              },
              {
                preset = ExpHardCap,
              },
            },
          },
        },
      },
      ["Cat"] = {
        weights = {
          0, 0, 0, 117, 113, 113, 117, 115
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                preset = MeleeHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Restoration"] = {
      weights = {
        75, 0, 0, 0, 50, 65, 0, 60
      },
    },
  },
  ["HUNTER"] = {
    ["Beast Mastery"] = {
      weights = {
        0, 0, 0, 258, 231, 137, 0, 73
      },
      caps = RangedCaps,
    },
    ["Marksmanship"] = {
      weights = {
        0, 0, 0, 272, 184, 150, 0, 124
      },
      caps = RangedCaps,
    },
    ["Survival"] = {
      weights = {
        0, 0, 0, 272, 184, 150, 0, 124
      },
      caps = RangedCaps,
    },
  },
  ["MAGE"] = {
    ["Arcane"] = {
      weights = {
        0, 0, 0, 321, 134, 128, 0, 140
      },
      caps = CasterCaps,
    },
    ["Fire"] = {
      weights = {
        0, 0, 0, 272, 155, 159, 0, 130
      },
      caps = CasterCaps,
    },
    ["Frost"] = {
      weights = {
        0, 0, 0, 188, 84, 88, 0, 82
      },
      caps = CasterCaps,
    },
  },
  ["PALADIN"] = {
    ["Holy"] = {
      weights = {
        150, 0, 0, 0, 70, 80, 0, 60
      },
    },
    ["Protection"] = {
      tanking = "PALADIN",
      weights = {
        0, 100, 100, 0, 0, 0, 0, 80
      },
    },
    ["Retribution"] = {
      weights = {
        0, 0, 0, 269, 110, 78, 186, 116
      },
      caps = MeleeCaps,
    },
  },
  ["PRIEST"] = {
    ["Discipline"] = {
      weights = {
        160, 0, 0, 0, 80, 100, 0, 120
      },
    },
    ["Holy"] = {
      weights = {
        160, 0, 0, 0, 100, 150, 0, 140
      },
    },
    ["Shadow"] = {
      weights = {
        0, 0, 0, 192, 167, 200, 0, 184
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              preset = SpellHitCap,
            },
          },
        },
      },
    },
  },
  ["ROGUE"] = {
    ["Assassination"] = {
      weights = {
        0, 0, 0, 175, 90, 120, 110, 130
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
              after = 140,
            },
            {
              preset = SpellHitCap,
              after = 75,
            },
            {
              preset = MeleeDWHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Combat"] = {
      weights = {
        0, 0, 0, 193, 92, 152, 165, 119
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
              after = 137,
            },
            {
              preset = SpellHitCap,
              after = 109,
            },
            {
              preset = MeleeDWHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              method = AtLeast,
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Subtlety"] = {
      weights = {
        0, 0, 0, 140, 110, 135, 115, 90
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              preset = MeleeHitCap,
              after = 105,
            },
            {
              preset = SpellHitCap,
              after = 80,
            },
            {
              preset = MeleeDWHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
  },
  ["SHAMAN"] = {
    ["Elemental"] = {
      weights = {
        0, 0, 0, 174, 102, 160, 0, 133
      },
      caps = CasterCaps,
    },
    ["Enhancement"] = {
      weights = {
        0, 0, 0, 345, 126, 103, 215, 172
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
              after = 200,
            },
            {
              preset = SpellHitCap,
              after = 70,
            },
            {
              preset = MeleeDWHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              method = AtLeast,
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Restoration"] = {
      weights = {
        180, 0, 0, 0, 80, 120, 0, 110
      },
    },
  },
  ["WARLOCK"] = {
    ["Affliction"] = {
      weights = {
        0, 0, 0, 106, 74, 90, 0, 74
      },
      caps = CasterCaps,
    },
    ["Demonology"] = {
      weights = {
        0, 0, 0, 239, 116, 150, 0, 138
      },
      caps = CasterCaps,
    },
    ["Destruction"] = {
      weights = {
        0, 0, 0, 152, 78, 84, 0, 72
      },
      caps = CasterCaps,
    },
  },
  ["WARRIOR"] = {
    ["Arms"] = {
      weights = {
        0, 0, 0, 288, 145, 58, 129, 96
      },
      caps = {
        {
          stat = StatHit,
          points = {
            {
              method = AtLeast,
              preset = MeleeHitCap,
            },
          },
        },
        {
          stat = StatExp,
          points = {
            {
              preset = ExpSoftCap,
            },
          },
        },
      },
    },
    ["Fury"] = {
      ["Titan's Grip"] = {
        weights = {
          0, 0, 0, 247, 198, 137, 247, 157
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 205,
              },
              {
                preset = FuryHitCap,
                after = 150
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
      ["Single-Minded Fury"] = {
        weights = {
          0, 0, 0, 320, 202, 133, 229, 124
        },
        caps = {
          {
            stat = StatHit,
            points = {
              {
                method = AtLeast,
                preset = MeleeHitCap,
                after = 202,
              },
              {
                preset = FuryHitCap,
                after = 169
              },
              {
                preset = MeleeDWHitCap,
              },
            },
          },
          {
            stat = StatExp,
            points = {
              {
                method = AtLeast,
                preset = ExpSoftCap,
              },
            },
          },
        },
      },
    },
    ["Protection"] = {
      tanking = "WARRIOR",
      weights = {
        40, 100, 100, 0, 0, 0, 0, 40
      },
    },
  },
--  ["PvP (Arena)"] = {
--  },
}

function ReforgeLite:InitPresets ()
  self.presets["Custom"] = self.db.customPresets
  
  if PawnVersion then
    local PawnMap = {
      Spirit = true,
      DodgeRating = true,
      ParryRating
    }
    self.presets["Pawn scales"] = function ()
      if PawnCommon == nil or PawnCommon.Scales == nil then return {} end
      local result = {}
      for k, v in pairs (PawnCommon.Scales) do
        local preset = {leaf = "import"}
        preset.weights = {}
        local raw = v.Values or {}
        preset.weights[self.STATS.SPIRIT] = raw["Spirit"] or 0
        preset.weights[self.STATS.DODGE] = raw["DodgeRating"] or 0
        preset.weights[self.STATS.PARRY] = raw["ParryRating"] or 0
        preset.weights[self.STATS.HIT] = raw["HitRating"] or 0
        preset.weights[self.STATS.CRIT] = raw["CritRating"] or 0
        preset.weights[self.STATS.HASTE] = raw["HasteRating"] or 0
        preset.weights[self.STATS.EXP] = raw["ExpertiseRating"] or 0
        preset.weights[self.STATS.MASTERY] = raw["MasteryRating"] or 0
        local total = 0
        local average = 0
        for i = 1, #self.itemStats do
          if preset.weights[i] ~= 0 then
            total = total + 1
            average = average + preset.weights[i]
          end
        end
        if total > 0 and average > 0 then
          local factor = 1
          while factor * average / total < 10 do
            factor = factor * 100
          end
          while factor * average / total > 1000 do
            factor = factor / 10
          end
          for i = 1, #self.itemStats do
            preset.weights[i] = preset.weights[i] * factor
          end
          result[v.LocalizedName or k] = preset
        end
      end
      return result
    end
  end

  self.presetMenu = CreateFrame ("Frame", "ReforgeLitePresetMenu")
  self.presetMenu.info = {}
  self.presetMenu.initialize = function (menu, level)
    if not level then return end
    local info = menu.info
    wipe (info)
    local list = self.presets
    if level > 1 then
      list = UIDROPDOWNMENU_MENU_VALUE
    end
    info.notCheckable = true

    for k, v in pairs (list) do
      if type (v) == "function" then
        v = v ()
      end
      info.text = ((list == self.db.customPresets or v.leaf == "import") and k or L[k])
      info.value = v
      if v.caps or v.weights or v.leaf then
        info.func = function ()
          CloseDropDownMenus ()
          if v.leaf == "import" then
            self:SetStatWeights (v.weights, v.caps)
          else
            self:SetStatWeights (v.weights, v.caps or {})
          end
          self:SetTankingModel (v.tanking)
        end
        info.hasArrow = nil
        info.keepShownOnClick = nil
      else
        info.func = nil
        if next (v) then
          info.hasArrow = true
        else
          info.hasArrow = nil
        end
        info.keepShownOnClick = true
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end

  self.presetDelMenu = CreateFrame ("Frame", "ReforgeLitePresetDelMenu")
  self.presetDelMenu.info = {}
  self.presetDelMenu.initialize = function (menu, level)
    if level ~= 1 then return end
    local info = menu.info
    wipe (info)
    info.notCheckable = true
    for k, v in pairs (self.db.customPresets) do
      info.text = k
      info.func = function ()
        self.db.customPresets[k] = nil
        if next (self.db.customPresets) == nil then
          self.deletePresetButton:Disable ()
        end
      end
      UIDropDownMenu_AddButton (info, level)
    end
  end
end
