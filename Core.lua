-- __________ Busy and Away by Niketa-Moonrunner (US) / http://niketa.net / addons@niketa.net __________ --

SLASH_BUSYANDAWAY1 = "/baa"

function SlashCmdList.BUSYANDAWAY(msg, editbox)
	local cmd, arg = msg:match("^(%S*)%s*(.-)$")
	
	if cmd == "enable" then
		BAA_FLAGTYPE = 1
		print("|cffffff00Busy and Away:|r Your AFK message will be set to your DND message. Upon returning your DND message will still be restored.")
	elseif cmd == "disable" then
		BAA_FLAGTYPE = 2
		print("|cffffff00Busy and Away:|r Your AFK message will no longer be set to your DND message.")
	elseif cmd == "clear" then
		if UnitIsDND("Player") then
			ChatFrame1EditBox:SetText("/busy")
			ChatEdit_SendText(ChatFrame1EditBox)
		end
		BAA_DNDMSG = nil
		
		print("|cffffff00Busy and Away:|r Your DND message has been cleared.")
	else
		print("|cffffff00Busy and Away")
		print("To manually clear your DND message, use the command \"/baa clear\".")
		print("To set your AFK message to your busy message, use the command \"/baa enable\". Keep in mind that doing this only makes your AFK message match your DND message. When you come back from AFK, your DND will still be restored. To disable, use \"/baa disable\".")
	end
end

local f = CreateFrame("Frame")

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("PLAYER_FLAGS_CHANGED")

local flag

f:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "BusyAndAway" then
			print("|cffffff00Busy and Away:|r Use the command \"/baa\" for help and to set your preferences.")
			
			if not BAA_FLAGTYPE then
				BAA_FLAGTYPE = 1
				
			elseif BAA_FLAGTYPE == 1 then
				print("|cffffff00Busy and Away:|r Your AFK message will be set to your DND message. Upon returning your DND message will still be restored.")
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if not UnitIsDND("player") and BAA_DNDMSG then
			BAA_DNDMSG = nil
		end
	elseif event == "CHAT_MSG_SYSTEM" then
		local msg = ...
		
		if msg:find("You are now Busy:") then
			BAA_DNDMSG = msg:match(":%s(.*)")
		end
	elseif event == "PLAYER_FLAGS_CHANGED" then
		if UnitIsAFK("player") and BAA_DNDMSG then
			if BAA_FLAGTYPE == 1 then
				-- Need to /afk first to clear the afk and reset with the message.
				ChatFrame1EditBox:SetText("/afk")
				ChatEdit_SendText(ChatFrame1EditBox)
				
				ChatFrame1EditBox:SetText("/afk "..BAA_DNDMSG)
				ChatEdit_SendText(ChatFrame1EditBox)
			end
			
			flag = true			
		elseif not UnitIsAFK("player") and not UnitIsDND("player") and BAA_DNDMSG then
			if flag then
				ChatFrame1EditBox:SetText("/busy "..BAA_DNDMSG)
				ChatEdit_SendText(ChatFrame1EditBox)
				flag = nil
			else
				BAA_DNDMSG = nil
			end
		end
	end
end)