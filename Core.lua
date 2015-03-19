-- Event Frame
local events = CreateFrame("Frame")
	  events:RegisterEvent("ADDON_LOADED")
	  events:RegisterEvent("PLAYER_FLAGS_CHANGED")
	  events:RegisterEvent("CHAT_MSG_BN_WHISPER")
	  events:SetScript("OnEvent", function(self, event, ...)
		  return self[event] and self[event](self, event, ...)
	  end)

-- My Lazy Functions
local function Set(var, val)
	if BusyAndAwayDB["settings"][var] then
		BusyAndAwayDB["settings"][var] = val
	else
		BusyAndAwayDB[var] = val
	end
end

local function Grab(var)
	if BusyAndAwayDB["settings"][var] then
		return BusyAndAwayDB["settings"][var]
	else
		return BusyAndAwayDB[var]
	end
end

-- Hijack Blizz DND slash commands.
local SetPlayerDND = SlashCmdList["CHAT_DND"]

SLASH_BUSYANDAWAYA1, SLASH_BUSYANDAWAYA2 = "/busy", "/dnd"

function SlashCmdList.BUSYANDAWAYA(msg)
	Set("playermsg", msg)
	SetPlayerDND(Grab("playermsg"))
end

-- Event Handlers
function events:ADDON_LOADED()
	-- Create or clear DB.
	if not BusyAndAwayDB or (not UnitIsDND("player") and not UnitIsAFK("player")) then
		local away = BusyAndAwayDB and BusyAndAwayDB.settings.awaymsg or 1
		local bnaway = BusyAndAwayDB and BusyAndAwayDB.settings.bnawaymsg or 0
		local bnbusy = BusyAndAwayDB and BusyAndAwayDB.settings.bnbusymsg or 0
		BusyAndAwayDB = {settings = {awaymsg = away, bnawaymsg = bnaway, bnbusymsg = bnbusy}}
	end
end

function events:PLAYER_FLAGS_CHANGED()
	local dnd = UnitIsDND("player")
	local afk = UnitIsAFK("player")

	if dnd then
		Set("busy", 1) 
	elseif Grab("busy") and afk and Grab("playermsg") then -- Set AFK message to player's DND message.
		if Grab("awaymsg") ~= 0 and Grab("playermsg") ~= "" then
			if not Grab("away") then
				SendChatMessage("", "AFK")
			end
			Set("away", 1)
			SendChatMessage(Grab("playermsg"), "AFK")
		else
			Set("away", 1)
		end
	elseif not afk and not dnd then
		if Grab("busy") and Grab("away") then -- Restore DND message.
			Set("away", nil)
			SendChatMessage(Grab("playermsg"), "DND")
		elseif Grab("busy") then -- Cleared DND status.
			Set("busy", nil)
			Set("playermsg", nil)
		end
	end
end

function events:CHAT_MSG_BN_WHISPER(...)
	if Grab("playermsg") then
		if UnitIsDND("player") and Grab("bnbusymsg") ~= 0 then
			BNSendWhisper(select(14, ...), "does not wish to be disturbed: " .. (Grab("playermsg") ~= "" and Grab("playermsg") or "DND"))
		elseif UnitIsAFK("player") and Grab("bnawaymsg") ~= 0 then
			if Grab("awaymsg") ~= 0 and Grab("playermsg") ~= "" then
				BNSendWhisper(select(14, ...), "is Away: " .. Grab("playermsg"))
				if not Grab("away") then
					SendChatMessage("", "AFK")
				end
				Set("away", 1)
				SendChatMessage(Grab("playermsg"), "AFK")
			else
				BNSendWhisper(select(14, ...), "is Away: AFK")
				Set("away", 1)
				SendChatMessage("", "AFK")
			end
		end
	end
end
