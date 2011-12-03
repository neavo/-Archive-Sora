 -------------- >reset frame
 --[[
   WorldStateUpFrame Mover by Sniffles
   
   Credits:
   blooblahguy (move func)
   tekkub (wow ui source)
--]]
-- Config
local font = [[Fonts\ARIALN.ttf]] -- ×Öów
local fsize = 16 -- ×Öów´óÐ¡
local _G = _G
local UIParent = UIParent
local function dummy() end

local function WorldStateAlwaysUpFrame_Update()   
   _G["WorldStateAlwaysUpFrame"]:ClearAllPoints()
   _G["WorldStateAlwaysUpFrame"].ClearAllPoints = dummy
   _G["WorldStateAlwaysUpFrame"]:SetPoint("TOP",UIParent,"TOP", 200, -55) -- Î»ÖÃ
   _G["WorldStateAlwaysUpFrame"].SetPoint = dummy
   local alwaysUpShown = 1   
   for i = alwaysUpShown, NUM_ALWAYS_UP_UI_FRAMES do   
      _G["AlwaysUpFrame"..i.."Text"]:SetFont(font, fsize)
   end
end
hooksecurefunc("WorldStateAlwaysUpFrame_Update", WorldStateAlwaysUpFrame_Update)