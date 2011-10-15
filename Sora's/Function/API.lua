-- Engines
local S, _, _, DB = unpack(select(2, ...))

function S.MakeShadow(Parent, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeTexShadow(Parent, Anchor, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetPoint("TOPLEFT", Anchor, -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Anchor, Size, -Size)
	Shadow:SetFrameLevel(1)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeFontString(Parent, FontSize)
	local Text = Parent:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, FontSize, "THINOUTLINE")
	return Text
end

function S.SVal(Val)
    if Val >= 1e6 then
        return ("%.1fm"):format(Val/1e6):gsub("%.?0+([km])$", "%1")
    elseif Val >= 1e4 then
        return ("%.1fk"):format(Val/1e3):gsub("%.?0+([km])$", "%1")
    else
        return Val
    end
end

function S.ToHex(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end

function S.FormatTime(Time)
	local Day = floor(Time/86400)
	local Hour = floor((Time-Day*86400)/3600)
	local Minute = floor((Time-Day*86400-Hour*3600)/60)
	local Second = floor((Time-Day*86400-Hour*3600-Minute*60)/60)
	if Time > 86400 then
		return Day.."d "..Hour.."m"		
	elseif Time > 3600 then
		return Hour.."h "..Minute.."m"
	elseif Time < 3600 and Time > 60 then
		return Minute.."m "..Second.."s"
	elseif Time < 60 and Time > 0 then	
		return Second.."s"
	else
		return "N/A"
	end
end

function S.FormatMemory(Memory)
	local M = format("%.2f", Memory/1024)
	local K = floor(Memory-floor(Memory/1024))
	if Memory > 1024 then
		return M.."m "	
	elseif Memory > 0 and Memory < 1024 then
		return K.."k"
	else
		return "N/A"
	end	
end

function S.MakeButton(Parent)
	local Button = CreateFrame("Button", nil, Parent)
	S.Reskin(Button)
	return Button
end






