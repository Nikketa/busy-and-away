-- Create options panel.
local addon = {}
addon.panel = CreateFrame("Frame", nil, UIParent)
addon.panel:Hide()
addon.panel.name = "Busy and Away"

addon.childpanel = CreateFrame("Frame", nil, addon.panel)
addon.childpanel.name = "Help"
addon.childpanel.parent = addon.panel.name

-- Create addon slash command.
SLASH_BUSYANDAWAYB1 = "/baa"

function SlashCmdList.BUSYANDAWAYB(msg)
	if msg == "help" then
		InterfaceOptionsFrame_OpenToCategory(addon.childpanel)
		InterfaceOptionsFrame_OpenToCategory(addon.childpanel)
	else
		InterfaceOptionsFrame_OpenToCategory(addon.panel)
		InterfaceOptionsFrame_OpenToCategory(addon.panel)
	end
end

-- Main Panel
local title = addon.panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	  title:SetText("Busy and Away")
	  title:SetPoint("TOPLEFT", 20, -15)

local settings = addon.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	  settings:SetText("Settings")
	  settings:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -15)

local awaymsg = CreateFrame("CheckButton", nil, addon.panel, "OptionsBaseCheckButtonTemplate")
	  awaymsg:SetPoint("TOPLEFT", settings, "BOTTOMLEFT", 0, -10)
	  awaymsg:SetScript("OnClick", function(self)
		  if self:GetChecked() then
			  BusyAndAwayDB["settings"]["awaymsg"] = 1
		  else
			  BusyAndAwayDB["settings"]["awaymsg"] = 0
		  end
	  end)
	  awaymsg:SetScript("OnShow", function(self)
		  if BusyAndAwayDB["settings"]["awaymsg"] ~= 0 then
			  self:SetChecked()
		  end
	  end)

local awaymsglbl = awaymsg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	  awaymsglbl:SetText("Set AFK message to DND message")
	  awaymsglbl:SetPoint("LEFT", awaymsg, "RIGHT", 5, 1)

local bnawaymsg = CreateFrame("CheckButton", nil, addon.panel, "OptionsBaseCheckButtonTemplate")
	  bnawaymsg:SetPoint("TOPLEFT", awaymsg, "BOTTOMLEFT", 0, -5)
	  bnawaymsg:SetScript("OnClick", function(self)
		  if self:GetChecked() then
			  BusyAndAwayDB["settings"]["bnawaymsg"] = 1
		  else
			  BusyAndAwayDB["settings"]["bnawaymsg"] = 0
		  end
	  end)
	  bnawaymsg:SetScript("OnShow", function(self)
		  if BusyAndAwayDB["settings"]["bnawaymsg"] ~= 0 then
			  self:SetChecked()
		  end
	  end)

local bnawaymsglbl = bnawaymsg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	  bnawaymsglbl:SetText("Send AFK reply to BN whispers")
	  bnawaymsglbl:SetPoint("LEFT", bnawaymsg, "RIGHT", 5, 1)

local bnbusymsg = CreateFrame("CheckButton", nil, addon.panel, "OptionsBaseCheckButtonTemplate")
	  bnbusymsg:SetPoint("TOPLEFT", bnawaymsg, "BOTTOMLEFT", 0, -5)
	  bnbusymsg:SetScript("OnClick", function(self)
		  if self:GetChecked() then
			  BusyAndAwayDB["settings"]["bnbusymsg"] = 1
		  else
			  BusyAndAwayDB["settings"]["bnbusymsg"] = 0
		  end
	  end)
	  bnbusymsg:SetScript("OnShow", function(self)
		  if BusyAndAwayDB["settings"]["bnbusymsg"] ~= 0 then
			  self:SetChecked()
		  end
	  end)

local bnbusymsglbl = bnbusymsg:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	  bnbusymsglbl:SetText("Send DND reply to BN whispers")
	  bnbusymsglbl:SetPoint("LEFT", bnbusymsg, "RIGHT", 5, 1)

-- Help Panel
local childtitle = addon.childpanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	  childtitle:SetText("Busy and Away")
	  childtitle:SetPoint("TOPLEFT", 20, -15)

local help = addon.childpanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	  help:SetText("Help")
	  help:SetPoint("TOPLEFT", childtitle, "BOTTOMLEFT", 0, -15)

local text = addon.childpanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	  text:SetText("At the moment this addon is pretty straight forward and I don't anticipate anyone really having any questions. That being said, if you need assistance contact me via the addon page on Curse or WoW Interface or email me at addons@niketa.net.")
	  text:SetPoint("TOPLEFT", help, "BOTTOMLEFT", 0, -10)
	  text:SetJustifyH("LEFT")
	  text:CanWordWrap(true)
	  text:SetWidth(580)


InterfaceOptions_AddCategory(addon.panel)
InterfaceOptions_AddCategory(addon.childpanel)
