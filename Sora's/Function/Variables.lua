-- Engines
local _, _, _, DB = unpack(select(2, ...))

DB.MyClass = select(2, UnitClass("player"))
DB.MyClassColor = RAID_CLASS_COLORS[DB.MyClass]