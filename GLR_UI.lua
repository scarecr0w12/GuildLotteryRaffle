GLR_UI = {}

local GLR_VersionString = GetAddOnMetadata("GuildLotteryRaffle", "Version")
local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")
local chat = DEFAULT_CHAT_FRAME
-- GLR_ReleaseState Info
-- True: Full, Official Release
-- False: Alpha/Beta Release and used to trigger full Debug logging.
GLR_ReleaseState = true
GLR_ReleaseType = "alpha"
GLR_ReleaseNumber = "1"

local profile = {
	frames = {
		outside = {
			bgFile = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 13,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		},
		inside = {
			bgFile = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 13,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		},
		dropdown = {
			bgFile = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 13,
			insets = {left = 2, right = 2, top = 2, bottom = 2},
		},
	},
	buttons = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
	},
	colors = {
		frames = {
			outside = {
				bordercolor = {1, 0.87, 0, 1},
				bgcolor = {0, 0, 0, 0.5},
			},
			inside = {
				bordercolor = {1, 0.87, 0, 1},
				bgcolor = {0, 0, 0, 0.25},
			},
			dropdown = {
				bordercolor = {1, 0.87, 0, 1},
				bgcolor = {0, 0, 0, 1},
			},
		},
		buttons = {
			bordercolor = {1, 0.87, 0, 1},
			bgcolor = {0, 0, 0, 0.5},
		},
	},
}

local function FormatNumber(n)
	if n ~= nil then
		if n < 10 then
			n = "0" .. tostring(n)
		end
		return n
	else return "NA" end
end

local function GetTimeStamp()
	local t = GetServerTime()
	if t ~= nil then
		local d = date("*t", t)
		d.month = FormatNumber(d.month)
		d.day = FormatNumber(d.day)
		d.year = FormatNumber(d.year)
		d.hour = FormatNumber(d.hour)
		d.min = FormatNumber(d.min)
		d.sec = FormatNumber(d.sec)
		local s = d.month .. "/" .. d.day .. "/" .. d.year .. " - " .. d.hour .. ":" .. d.min .. "." .. d.sec
		return s
	else
		return "NA"
	end
end

local function CommaValue(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

local function GenerateRosterNames()
	local t = {}
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if glrRosterTotal == 0 then
		if not status then
			GLR_U:UpdateRosterTable()
		else
			GLR_U:PopulateMultiGuildTable()
		end
	end
	if not status then
		for i = 1, #glrRoster do
			local text = glrRoster[i]
			local playerName = string.sub(text, 1, string.find(text, '%[') - 1)
			local playerLevel = string.sub(text, string.find(text, '%(') + 1, string.find(text, '%)') - 1)
			playerName = strjoin(".", playerName, playerLevel)
			table.insert(t, playerName)
		end
	else
		for i = 1, #glrMultiGuildRoster do
			local text = glrMultiGuildRoster[i]
			local playerName = string.sub(text, 1, string.find(text, '%[') - 1)
			local playerLevel = string.sub(text, string.find(text, '%(') + 1, string.find(text, '%)') - 1)
			playerName = strjoin(".", playerName, playerLevel)
			table.insert(t, playerName)
		end
	end
	sort(t)
	return t
end

local function CompleteDonation()
	
	local price = tonumber(glrCharacter.Event.Lottery.TicketPrice)
	local sold = glrCharacter.Event.Lottery.TicketsSold
	local gold = GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText()
	local silver = GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText()
	local copper = GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:GetText()
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	
	if tonumber(copper) < 10 and copper ~= "00" then
		copper = "0" .. copper
	end
	if tonumber(silver) < 10 and silver ~= "00" then
		silver = "0" .. silver
	end
	
	local total = tonumber(gold .. "." .. silver .. copper)
	local start = tonumber(glrCharacter.Event.Lottery.StartingGold)
	
	local jackpot = (price * sold) + start + total
	
	local guildcut = tonumber(glrCharacter.Event.Lottery.GuildCut) / 100
	
	local Takeaway = jackpot
	local SP = glrCharacter.Event.Lottery.SecondPlace
	if SP == L["Winner Guaranteed"] then SP = 0 else SP = tonumber(SP) end
	local second = tonumber(jackpot) * ( SP / 100 )
	
	if guildcut ~= nil then
		if guildcut > 0 then
			Takeaway = Takeaway - ( Takeaway * guildcut )
		end
	end
	
	Takeaway = GLR_U:GetMoneyValue(Takeaway, "Lottery", true, 1)
	jackpot = GLR_U:GetMoneyValue(jackpot, "Lottery", true, 1)
	if SP ~= L["Winner Guaranteed"] then
		second = GLR_U:GetMoneyValue(second, "Lottery", true, round)
	else second = L["Winner Guaranteed"] end
	start = tostring(start + total)
	
	total = tostring(total) --Prased so it can be used in the Debug Tracing information.
	
	glrCharacter.Event.Lottery.StartingGold = start
	
	if GLR_AddOnMessageTable_Debug ~= nil then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CompleteDonation() - Money Donated: [" .. total .. "] - New Starting Amount: [" .. start .. "] - New Total Jackpot: [" .. jackpot .. "] - Takeaway / Second: [" .. Takeaway .. " / " .. second .. "]")
	end
	
	GLR_U:UpdateInfo()
	
	GLR_UI.GLR_DonationFrame:Hide()
	
	local message = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(L["Send Donation Info To Guild"], "%%Amount", gold), "%%Silver", silver), "%%Copper", copper), "%%new", jackpot), "%%q", Takeaway)
	local canSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat()
	
	if canSpeakInGuildChat then
		SendChatMessage(L["Send Info GLR"] .. ": " .. message, "GUILD")
	else
		if GLR_AddOnMessageTable_Debug ~= nil then
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CompleteDonation() - Unable to Announce Lottery Donation. Reason: [MUTED]")
		end
		GLR:Print("You are currently unable to speak in Guild Chat, the Lottery Donation was completed but NOT announced. Please contact your Guild Master to fix this.")
	end
	
	GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("")
	GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
	GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
	
end

GLR_UI.Font = "Interface\\AddOns\\GuildLotteryRaffle\\Fonts\\PT_Sans_Narrow.TTF"
GLR_UI.ButtonFont = "Interface\\AddOns\\GuildLotteryRaffle\\Fonts\\Intro_Black.TTF"
GLR_UI.VersionChecked = false
GLR_UI.VersionCheckRegistered = false

if GLR_Global_Variables[4] ~= nil then
	if GLR_Global_Variables[4] == "zhCN" then
		GLR_UI.Font = "FONTS\\ARKai_T.TTF"
		GLR_UI.ButtonFont = "FONTS\\ARKai_T.TTF"
	end
end

--------------------------- ---------
--------- FRAMES ----------
---------------------------

--Main Frame & Settings
GLR_UI.GLR_MainFrame = CreateFrame("Frame", "GLR_MainFrame", UIParent, "BackdropTemplate") --BasicFrameTemplateWithInset
GLR_UI.GLR_MainFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_MainFrame:SetSize(600, 500)
GLR_UI.GLR_MainFrame:SetFrameStrata("HIGH")
GLR_UI.GLR_MainFrame:EnableMouse(true)
GLR_UI.GLR_MainFrame:SetMovable(true)
GLR_UI.GLR_MainFrame:SetUserPlaced(true)
GLR_UI.GLR_MainFrame:SetResizable(false)
GLR_UI.GLR_MainFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_MainFrame:SetScript("OnDragStart", GLR_UI.GLR_MainFrame.StartMoving)
GLR_UI.GLR_MainFrame:SetScript("OnDragStop", GLR_UI.GLR_MainFrame.StopMovingOrSizing)
GLR_UI.GLR_MainFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_MainFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_MainFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_MainFrame:Hide()

local GLR_MainFrameCloseButton = CreateFrame("Button", "GLR_MainFrameCloseButton", GLR_UI.GLR_MainFrame, "UIPanelCloseButton")
GLR_MainFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_MainFrame, "TOPRIGHT")

--Lottery Frame & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame = CreateFrame("Frame", "GLR_LotteryFrame", GLR_UI.GLR_MainFrame)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame:SetPoint("CENTER", GLR_UI.GLR_MainFrame)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame:SetSize(600, 500)

--Raffle Frame & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame = CreateFrame("Frame", "GLR_RaffleFrame", GLR_UI.GLR_MainFrame)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame:SetPoint("CENTER", GLR_UI.GLR_MainFrame)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame:SetSize(600, 500)

--Lottery Info Frame & Settings
GLR_UI.GLR_LotteryInfo = CreateFrame("Frame", "GLR_LotteryInfo", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "BackdropTemplate") --InsetFrameTemplate3
GLR_UI.GLR_LotteryInfo:SetPoint("TOPRIGHT", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "TOPRIGHT", -20, -46)
GLR_UI.GLR_LotteryInfo:SetSize(340, 230)
GLR_UI.GLR_LotteryInfo:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_LotteryInfo:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_LotteryInfo:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Raffle Info Frame & Settings
GLR_UI.GLR_RaffleInfo = CreateFrame("Frame", "GLR_RaffleInfo", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "BackdropTemplate")
GLR_UI.GLR_RaffleInfo:SetPoint("TOPRIGHT", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "TOPRIGHT", -20, -46)
GLR_UI.GLR_RaffleInfo:SetSize(340, 230)
GLR_UI.GLR_RaffleInfo:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_RaffleInfo:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_RaffleInfo:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Player Names Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder = CreateFrame("Frame", "GLR_PlayerNamesBorder", GLR_UI.GLR_MainFrame, "BackdropTemplate")
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:SetPoint("BOTTOMLEFT", GLR_UI.GLR_MainFrame, "BOTTOMLEFT", 20, 20)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:SetSize(250, 170)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Ticket Number Range Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder = CreateFrame("Frame", "GLR_TicketNumberRangeBorder", GLR_UI.GLR_MainFrame, "BackdropTemplate")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:SetPoint("BOTTOMRIGHT", GLR_UI.GLR_MainFrame, "BOTTOMRIGHT", -20, 20)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:SetSize(200, 50)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Number of Unused Tickets Range Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder = CreateFrame("Frame", "GLR_NumberOfUnusedTicketsRangeBorder", GLR_UI.GLR_MainFrame, "BackdropTemplate")
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder, "TOP", 0, 50)
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:SetSize(130, 40)
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Confirm Start Lottery Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder = CreateFrame("Frame", "GLR_ConfirmStartLotteryBorder", GLR_UI.GLR_MainFrame.GLR_LotteryFrame) --, "TranslucentFrameTemplate")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "LEFT", 122, 30)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:SetSize(1, 1)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()

--Confirm Start Raffle Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder = CreateFrame("Frame", "GLR_ConfirmStartRaffleBorder", GLR_UI.GLR_MainFrame.GLR_RaffleFrame) --, "TranslucentFrameTemplate")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "LEFT", 122, 30)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:SetSize(1, 1)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:Hide()

--Confirm Abort Lottery/Raffle Roll Process Border Frame & Settings
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder = CreateFrame("Frame", "GLR_ConfirmAbortRollProcessBorder", GLR_UI.GLR_MainFrame) --, "TranslucentFrameTemplate")
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetPoint("CENTER", GLR_UI.GLR_MainFrame, "LEFT", 122, 30)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetSize(1, 1)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()

--New Lottery Event Frame & Settings
GLR_UI.GLR_NewLotteryEventFrame = CreateFrame("Frame", "GLR_NewLotteryEventFrame", UIParent, "BackdropTemplate")

GLR_UI.GLR_NewLotteryEventFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_NewLotteryEventFrame:SetSize(350, 365)
GLR_UI.GLR_NewLotteryEventFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_NewLotteryEventFrame:EnableMouse(true)
GLR_UI.GLR_NewLotteryEventFrame:SetMovable(true)
GLR_UI.GLR_NewLotteryEventFrame:SetUserPlaced(true)
GLR_UI.GLR_NewLotteryEventFrame:SetResizable(false)
GLR_UI.GLR_NewLotteryEventFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnDragStart", GLR_UI.GLR_NewLotteryEventFrame.StartMoving)
GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnDragStop", GLR_UI.GLR_NewLotteryEventFrame.StopMovingOrSizing)
GLR_UI.GLR_NewLotteryEventFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_NewLotteryEventFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_NewLotteryEventFrame:Hide()

local GLR_NewLotteryEventFrameCloseButton = CreateFrame("Button", "GLR_NewLotteryEventFrameCloseButton", GLR_UI.GLR_NewLotteryEventFrame, "UIPanelCloseButton")
GLR_NewLotteryEventFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_NewLotteryEventFrame, "TOPRIGHT")

--New Raffle Event Frame & Settings
GLR_UI.GLR_NewRaffleEventFrame = CreateFrame("Frame", "GLR_NewRaffleEventFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_NewRaffleEventFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_NewRaffleEventFrame:SetSize(370, 365)
GLR_UI.GLR_NewRaffleEventFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_NewRaffleEventFrame:EnableMouse(true)
GLR_UI.GLR_NewRaffleEventFrame:SetMovable(true)
GLR_UI.GLR_NewRaffleEventFrame:SetUserPlaced(true)
GLR_UI.GLR_NewRaffleEventFrame:SetResizable(false)
GLR_UI.GLR_NewRaffleEventFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnDragStart", GLR_UI.GLR_NewRaffleEventFrame.StartMoving)
GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnDragStop", GLR_UI.GLR_NewRaffleEventFrame.StopMovingOrSizing)
GLR_UI.GLR_NewRaffleEventFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_NewRaffleEventFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_NewRaffleEventFrame:Hide()

local GLR_NewRaffleEventFrameCloseButton = CreateFrame("Button", "GLR_NewRaffleEventFrameCloseButton", GLR_UI.GLR_NewRaffleEventFrame, "UIPanelCloseButton")
GLR_NewRaffleEventFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_NewRaffleEventFrame, "TOPRIGHT")

--Add Player To Lottery Frame & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame = CreateFrame("Frame", "GLR_AddPlayerToLotteryFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_AddPlayerToLotteryFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_AddPlayerToLotteryFrame:SetSize(275, 150)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_AddPlayerToLotteryFrame:EnableMouse(true)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetMovable(true)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetUserPlaced(true)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetResizable(false)
GLR_UI.GLR_AddPlayerToLotteryFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnDragStart", GLR_UI.GLR_AddPlayerToLotteryFrame.StartMoving)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnDragStop", GLR_UI.GLR_AddPlayerToLotteryFrame.StopMovingOrSizing)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_AddPlayerToLotteryFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_AddPlayerToLotteryFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()

local GLR_EditPlayerInLotteryFrameCloseButton = CreateFrame("Button", "GLR_EditPlayerInLotteryFrameCloseButton", GLR_UI.GLR_AddPlayerToLotteryFrame, "UIPanelCloseButton")
GLR_EditPlayerInLotteryFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_AddPlayerToLotteryFrame, "TOPRIGHT")

--Edit Player in Lottery Frame & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame = CreateFrame("Frame", "GLR_EditPlayerInLotteryFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_EditPlayerInLotteryFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_EditPlayerInLotteryFrame:SetSize(350, 160)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_EditPlayerInLotteryFrame:EnableMouse(true)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetMovable(true)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetUserPlaced(true)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetResizable(false)
GLR_UI.GLR_EditPlayerInLotteryFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_EditPlayerInLotteryFrame:SetScript("OnDragStart", GLR_UI.GLR_EditPlayerInLotteryFrame.StartMoving)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetScript("OnDragStop", GLR_UI.GLR_EditPlayerInLotteryFrame.StopMovingOrSizing)
GLR_UI.GLR_EditPlayerInLotteryFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_EditPlayerInLotteryFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_EditPlayerInLotteryFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()

local GLR_EditPlayerInLotteryFrameCloseButton = CreateFrame("Button", "GLR_EditPlayerInLotteryFrameCloseButton", GLR_UI.GLR_EditPlayerInLotteryFrame, "UIPanelCloseButton")
GLR_EditPlayerInLotteryFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_EditPlayerInLotteryFrame, "TOPRIGHT")

--Add Player To Raffle Frame & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame = CreateFrame("Frame", "GLR_AddPlayerToRaffleFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_AddPlayerToRaffleFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_AddPlayerToRaffleFrame:SetSize(275, 150)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_AddPlayerToRaffleFrame:EnableMouse(true)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetMovable(true)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetUserPlaced(true)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetResizable(false)
GLR_UI.GLR_AddPlayerToRaffleFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnDragStart", GLR_UI.GLR_AddPlayerToRaffleFrame.StartMoving)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnDragStop", GLR_UI.GLR_AddPlayerToRaffleFrame.StopMovingOrSizing)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_AddPlayerToRaffleFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_AddPlayerToRaffleFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()

local GLR_AddPlayerToRaffleFrameCloseButton = CreateFrame("Button", "GLR_AddPlayerToRaffleFrameCloseButton", GLR_UI.GLR_AddPlayerToRaffleFrame, "UIPanelCloseButton")
GLR_AddPlayerToRaffleFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_AddPlayerToRaffleFrame, "TOPRIGHT")

--Edit Player in Raffle Frame & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame = CreateFrame("Frame", "GLR_EditPlayerInRaffleFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_EditPlayerInRaffleFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_EditPlayerInRaffleFrame:SetSize(350, 160)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetFrameStrata("DIALOG")
GLR_UI.GLR_EditPlayerInRaffleFrame:EnableMouse(true)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetMovable(true)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetUserPlaced(true)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetResizable(false)
GLR_UI.GLR_EditPlayerInRaffleFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_EditPlayerInRaffleFrame:SetScript("OnDragStart", GLR_UI.GLR_EditPlayerInRaffleFrame.StartMoving)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetScript("OnDragStop", GLR_UI.GLR_EditPlayerInRaffleFrame.StopMovingOrSizing)
GLR_UI.GLR_EditPlayerInRaffleFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_EditPlayerInRaffleFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_EditPlayerInRaffleFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()

local GLR_EditPlayerInRaffleFrameCloseButton = CreateFrame("Button", "GLR_EditPlayerInRaffleFrameCloseButton", GLR_UI.GLR_EditPlayerInRaffleFrame, "UIPanelCloseButton")
GLR_EditPlayerInRaffleFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_EditPlayerInRaffleFrame, "TOPRIGHT")

--View Player Ticket Info Frame & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFrame = CreateFrame("Frame", "GLR_ViewPlayerTicketInfoFrame", UIParent, "BackdropTemplate")
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetSize(240, 220)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetFrameStrata("FULLSCREEN_DIALOG")
GLR_UI.GLR_ViewPlayerTicketInfoFrame:EnableMouse(true)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetMovable(true)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetUserPlaced(true)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetResizable(false)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetScript("OnDragStart", GLR_UI.GLR_ViewPlayerTicketInfoFrame.StartMoving)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetScript("OnDragStop", GLR_UI.GLR_ViewPlayerTicketInfoFrame.StopMovingOrSizing)
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()

local GLR_ViewPlayerTicketInfoFrameCloseButton = CreateFrame("Button", "GLR_ViewPlayerTicketInfoFrameCloseButton", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "UIPanelCloseButton")
GLR_ViewPlayerTicketInfoFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "TOPRIGHT")

--View Player Ticket Info Border Frame & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder = CreateFrame("Frame", "GLR_ViewPlayerTicketInfoBorder", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "BackdropTemplate")
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder:SetPoint("BOTTOMLEFT", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "BOTTOMLEFT", 12, 10)
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder:SetSize(200, 120)
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder:SetBackdrop({
	bgFile = profile.frames.inside.bgFile,
	edgeFile = profile.frames.inside.edgeFile,
	edgeSize = profile.frames.inside.edgeSize,
	insets = profile.frames.inside.insets
})
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder:SetBackdropColor(unpack(profile.colors.frames.inside.bgcolor))
GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder:SetBackdropBorderColor(unpack(profile.colors.frames.inside.bordercolor))

--Donation Frame & Settings (increase Lottery Jackpot without adding players)
GLR_UI.GLR_DonationFrame = CreateFrame("Frame", "GLR_UI.GLR_DonationFrame", UIParent, "BackdropTemplate")

GLR_UI.GLR_DonationFrame:SetPoint("CENTER", UIParent, "CENTER")
GLR_UI.GLR_DonationFrame:SetSize(245, 90)
GLR_UI.GLR_DonationFrame:SetFrameStrata("FULLSCREEN")	--Set higher than the main frame so it appears above it when clicking the donation button
GLR_UI.GLR_DonationFrame:EnableMouse(true)
GLR_UI.GLR_DonationFrame:SetMovable(true)
GLR_UI.GLR_DonationFrame:SetUserPlaced(true)
GLR_UI.GLR_DonationFrame:SetResizable(false)
GLR_UI.GLR_DonationFrame:RegisterForDrag("LeftButton")
GLR_UI.GLR_DonationFrame:SetScript("OnDragStart", GLR_UI.GLR_DonationFrame.StartMoving)
GLR_UI.GLR_DonationFrame:SetScript("OnDragStop", GLR_UI.GLR_DonationFrame.StopMovingOrSizing)
GLR_UI.GLR_DonationFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_DonationFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_DonationFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_UI.GLR_DonationFrame:Hide()

local GLR_DonationFrameCloseButton = CreateFrame("Button", "GLR_DonationFrameCloseButton", GLR_UI.GLR_DonationFrame, "UIPanelCloseButton")
GLR_DonationFrameCloseButton:SetPoint("TOPRIGHT", GLR_UI.GLR_DonationFrame, "TOPRIGHT")

---------------------------
-------- END FRAMES -------
---------------------------

---------------------------
----- CREATE BUTTONS ------
---------------------------

--Debug Button
GLR_UI.GLR_MainFrame.GLR_DebugButton = CreateFrame("Button", "GLR_DebugButton", GLR_UI.GLR_MainFrame, "GameMenuButtonTemplate") --, "GameMenuButtonTemplate")

--New Lottery Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton = CreateFrame("Button", "GLR_NewLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--New Raffle Button
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton = CreateFrame("Button", "GLR_NewRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")

--Begin Lottery Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton = CreateFrame("Button", "GLR_BeginLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--Begin Raffle Button
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton = CreateFrame("Button", "GLR_BeginRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")

--Alert Guild Button
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton = CreateFrame("Button", "GLR_AlertGuildButton", GLR_UI.GLR_MainFrame, "GameMenuButtonTemplate")

--Add Player to Lottery Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton = CreateFrame("Button", "GLR_AddPlayerToLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--Add Player to Raffle Button
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton = CreateFrame("Button", "GLR_AddPlayerToRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")

--Edit Player in Lottery Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton = CreateFrame("Button", "GLR_EditPlayerInLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--Edit Player in Raffle Button
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton = CreateFrame("Button", "GLR_EditPlayerInRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")

--Open Interface Options Button
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton = CreateFrame("Button", "GLR_OpenInterfaceOptionsButton", GLR_UI.GLR_MainFrame, "GameMenuButtonTemplate")

--Go To Lottery Button
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton = CreateFrame("Button", "GLR_GoToLotteryButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")

--Go To Raffle Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton = CreateFrame("Button", "GLR_GoToRaffleButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--Start New Lottery Button
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton = CreateFrame("Button", "GLR_StartNewLotteryButton", GLR_UI.GLR_NewLotteryEventFrame, "GameMenuButtonTemplate")

--Start New Raffle Button
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton = CreateFrame("Button", "GLR_StartNewRaffleButton", GLR_UI.GLR_NewRaffleEventFrame, "GameMenuButtonTemplate")

--Confirm New Lottery Button
--GLR_UI.GLR_NewLotteryEventFrame.GLR_ConfirmNewLotteryFrame.GLR_ConfirmNewLotteryButton = CreateFrame("Button", "GLR_ConfirmNewLotteryButton", GLR_UI.GLR_NewLotteryEventFrame.GLR_ConfirmNewLotteryFrame, "GameMenuButtonTemplate")

--Confirm New Raffle Button
--GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmNewRaffleFrame.GLR_ConfirmNewRaffleButton = CreateFrame("Button", "GLR_ConfirmNewRaffleButton", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmNewRaffleFrame, "GameMenuButtonTemplate")

--Confirm Add Raffle Item Buttons
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton = CreateFrame("Button", "GLR_ConfirmRaffleItemOneButton", GLR_UI.GLR_NewRaffleEventFrame, "GameMenuButtonTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton = CreateFrame("Button", "GLR_ConfirmRaffleItemTwoButton", GLR_UI.GLR_NewRaffleEventFrame, "GameMenuButtonTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton = CreateFrame("Button", "GLR_ConfirmRaffleItemThreeButton", GLR_UI.GLR_NewRaffleEventFrame, "GameMenuButtonTemplate")

--Abort Lottery/Raffle Roll Process Button
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton = CreateFrame("Button", "GLR_AbortRollProcessButton", GLR_UI.GLR_MainFrame, "GameMenuButtonTemplate")

--Confirm Abort Lottery/Raffle Roll Process Button
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton = CreateFrame("Button", "GLR_ConfirmAbortRollProcessButton", GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder, "GameMenuButtonTemplate")

--Scan Mail Button
GLR_UI.GLR_ScanMailButton = CreateFrame("Button", "GLR_ScanMailButton", InboxFrame, "GameMenuButtonTemplate")

--Donation Button
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton = CreateFrame("Button", "GLR_DonationButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "GameMenuButtonTemplate")

--Confirm Donation
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton = CreateFrame("Button", "GLR_ConfirmDonationButton", GLR_UI.GLR_DonationFrame, "GameMenuButtonTemplate")

---------------------------
------- END BUTTONS -------
---------------------------

---------------------------
----- BUTTON SETTINGS -----
---------------------------

--Debug Button Settings
--[[
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame, "TOP", 0, 10)
local ButtonHighlightTexture = CreateFrame("Button", "ButtonHighlightTexture", GLR_UI.GLR_MainFrame.GLR_DebugButton)
ButtonHighlightTexture:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-Button-Glow")
ButtonHighlightTexture:SetSize(GLR_UI.GLR_MainFrame.GLR_DebugButton:GetWidth(), GLR_UI.GLR_MainFrame.GLR_DebugButton:GetHeight())
ButtonHighlightTexture:SetAllPoints(GLR_UI.GLR_MainFrame.GLR_DebugButton)
--]]

--New Lottery Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetPoint("TOPLEFT", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "TOPLEFT", 20, -46)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_AddPlayerToLotteryFrame:IsVisible() then
		GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInLotteryFrame:IsVisible() then
		GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	end
	if GLR_UI.GLR_NewLotteryEventFrame:IsVisible() == false then
		--Quick and dirty way to get font strings to show completely
		GLR_UI.GLR_NewLotteryEventFrame:Show()
		GLR_UI.GLR_NewLotteryEventFrame:Hide()
		GLR_UI.GLR_NewLotteryEventFrame:Show()
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GLR_NewLotteryEventFrame() - Showing New Lottery Event Frame")
	end
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Start New Lottery Button Tooltip"])
	GameTooltip:AddLine(L["Start New Lottery Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:Disable()

--[[
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "TOP", 0, 10)
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetScript("OnClick", function(self, button)
	GLR:DoDebug()
end)
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetBackdrop({
	edgeFile = profile.buttons.edgeFile,
	edgeSize = profile.buttons.edgeSize,
})
GLR_UI.GLR_MainFrame.GLR_DebugButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--]]

--Begin Lottery Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetScript("OnClick", function(self)
	if not GLR_Global_Variables[6][1] and glrCharacter.Data.Settings.CurrentlyActiveLottery then
		if glrCharacter.Event.Lottery.TicketsSold >= 1 or glrCharacter.Event.Lottery.GiveAwayTickets >= 1 then
			local canSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat()
			if canSpeakInGuildChat then
				local Jackpot = tonumber(glrCharacter.Event.Lottery.StartingGold) + ( glrCharacter.Event.Lottery.TicketsSold * tonumber(glrCharacter.Event.Lottery.TicketPrice) )
				if Jackpot > 0 then
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Show()
				else chat:AddMessage("|cfff7ff4d" .. L["GLR - Error - No Jackpot"] .. "|r") end
			else
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GLR_StartLotteryButton() - Unable to Initiate Lottery Roll. Reason: [MUTED]")
				GLR:Print("You are currently unable to speak in Guild Chat, and therefore unable to start Event Rolls. Please contact your Guild Master to fix this.")
			end
		else
			chat:AddMessage("|cfff7ff4d" .. L["GLR - Error - Zero Entries"] .. "|r")
		end
	elseif GLR_Global_Variables[6][1] and glrCharacter.Data.Settings.CurrentlyActiveLottery then
		chat:AddMessage("")
		chat:AddMessage(L["Draw In Progress"])
		chat:AddMessage("")
	end
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Begin Lottery Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Disable()

--New Raffle Button Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetPoint("TOPLEFT", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "TOPLEFT", 20, -46)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetSize(100, 26)
--Moved OnClick Script to GLR_Draw.lua
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Start New Raffle Button Tooltip"])
	GameTooltip:AddLine(L["Start New Raffle Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:Disable()

--Begin Raffle Button Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetScript("OnClick", function(self)
	if not GLR_Global_Variables[6][2] and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		if glrCharacter.Event ~= nil then
			if glrCharacter.Event.Raffle ~= nil then
				if glrCharacter.Event.Raffle.TicketsSold >= 1 or glrCharacter.Event.Raffle.GiveAwayTickets >= 1 then
					local canSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat()
					if canSpeakInGuildChat then
						GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:Show()
					else
						local timestamp = GetTimeStamp()
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GLR_StartRaffleButton() - Unable to Initiate Raffle Roll. Reason: [MUTED]")
						GLR:Print("You are currently unable to speak in Guild Chat, and therefore unable to start Event Rolls. Please contact your Guild Master to fix this.")
					end
				else
					chat:AddMessage("|cfff7ff4d" .. L["GLR - Error - Zero Entries"] .. "|r")
				end
			end
		end
	elseif GLR_Global_Variables[6][2] and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		chat:AddMessage("")
		chat:AddMessage(L["Draw In Progress"])
		chat:AddMessage("")
	end
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Begin Raffle Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Disable()

--Alert Guild Button Settings
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetPoint("LEFT", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "RIGHT", 5, 0)
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetScript("OnClick", function(self)
	GLR:AlertGuild()
end)
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Alert Guild Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Add Player to Lottery Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_AlertGuildButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame:IsVisible() then
		GLR_UI.GLR_NewLotteryEventFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInLotteryFrame:IsVisible() then
		GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	end
	if GLR_UI.GLR_AddPlayerToLotteryFrame:IsVisible() == false then
		if glrCharacter.Data.Settings.CurrentlyActiveLottery == true then
			local status = glrCharacter.Data.Settings.General.MultiGuild
			if not status then
				GLR_U:UpdateRosterTable()
			else
				GLR_U:PopulateMultiGuildTable()
			end
			--Quick and dirty way to get font strings to show completely
			GLR_UI.GLR_AddPlayerToLotteryFrame:Show()
			GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
			GLR_UI.GLR_AddPlayerToLotteryFrame:Show()
		end
	end
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Player Button Tooltip"] .. L["Lottery"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Disable()

--Add Player to Raffle Button Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_AlertGuildButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame:IsVisible() then
		GLR_UI.GLR_NewRaffleEventFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInRaffleFrame:IsVisible() then
		GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
	end
	if GLR_UI.GLR_AddPlayerToRaffleFrame:IsVisible() == false then
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle == true then
			local status = glrCharacter.Data.Settings.General.MultiGuild
			if not status then
				GLR_U:UpdateRosterTable()
			else
				GLR_U:PopulateMultiGuildTable()
			end
			--Quick and dirty way to get font strings to show completely
			GLR_UI.GLR_AddPlayerToRaffleFrame:Show()
			GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
			GLR_UI.GLR_AddPlayerToRaffleFrame:Show()
		end
	end
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Player Button Tooltip"] .. L["Raffle"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Disable()

--Edit Player in Lottery Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_AddPlayerToLotteryFrame:IsVisible() then
		GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	end
	if GLR_UI.GLR_NewLotteryEventFrame:IsVisible() then
		GLR_UI.GLR_NewLotteryEventFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInLotteryFrame:IsVisible() == false then
		if glrCharacter.Data.Settings.CurrentlyActiveLottery == true then
			GLR_UI.GLR_EditPlayerInLotteryFrame:Show()
			GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
			GLR_UI.GLR_EditPlayerInLotteryFrame:Show()
		end
	end
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Player Button Tooltip"] .. L["Lottery"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Disable()

--Edit Player in Raffle Button Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_AddPlayerToRaffleFrame:IsVisible() then
		GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	end
	if GLR_UI.GLR_NewRaffleEventFrame:IsVisible() then
		GLR_UI.GLR_NewRaffleEventFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInRaffleFrame:IsVisible() == false then
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle == true then
			GLR_UI.GLR_EditPlayerInRaffleFrame:Show()
			GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
			GLR_UI.GLR_EditPlayerInRaffleFrame:Show()
		end
	end
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Player Button Tooltip"] .. L["Raffle"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Disable()

--Open Interface Options Button Settings
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_MainFrame:Hide()
	InterfaceOptionsFrame_OpenToCategory("Guild Lottery & Raffles")
	InterfaceOptionsFrame_OpenToCategory("Guild Lottery & Raffles")
	InterfaceOptionsFrame_OpenToCategory("Guild Lottery & Raffles")
end)
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Configure Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Go To Raffle Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame:Hide()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame:Show()
	GLR_Global_Variables[2] = true
	GLR:ToggleLotteryRaffle("toggle")
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Go To Lottery Button Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame:Hide()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame:Show()
	GLR_Global_Variables[2] = true
	GLR:ToggleLotteryRaffle("toggle")
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Start New Lottery Button Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetPoint("BOTTOMRIGHT", GLR_UI.GLR_NewLotteryEventFrame, "BOTTOMRIGHT", -15, 15)
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetSize(100, 26)
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Start Lottery Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Start New Raffle Button Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetPoint("BOTTOMRIGHT", GLR_UI.GLR_NewRaffleEventFrame, "BOTTOMRIGHT", -15, 15)
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetSize(100, 26)
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Start Raffle Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Abort Lottery/Raffle Roll Process Button Settings
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_AlertGuildButton, "BOTTOM", 0, -67)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:IsVisible() then
		GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
	else
		GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Show()
	end
end)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Abort Roll Process Button Tooltip"])
	GameTooltip:AddLine(L["Abort Roll Process Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()

--Confirm Abort Lottery/Raffle Roll Process Button Settings
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetScript("OnClick", function(self)
	GLR_Global_Variables[3] = true
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	GLR_GoToAddRafflePrizes:Show()
end)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm Abort Roll Process Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

--Scan Mail Button Settings
GLR_UI.GLR_ScanMailButton:SetPoint("BOTTOM", InboxFrame, "TOP", 0, 5)
GLR_UI.GLR_ScanMailButton:SetSize(100, 26)
GLR_UI.GLR_ScanMailButton:SetScript("OnClick", function(self)
	if GLR_Global_Variables[1] then
		GLR:Print(L["Mail Scan - Start"])
		GLR_M.GLR_UpdateFrame:Show()
		GLR_UI.GLR_ScanMailButton:Disable()
	else
		GLR:Print("Please wait until the AddOn has fully initialized.")
	end
end)
GLR_UI.GLR_ScanMailButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Mail Scan - Button Tooltip Line 1"])
	GameTooltip:AddLine(L["Mail Scan - Button Tooltip Line 2"])
	GameTooltip:AddLine(L["Mail Scan - Button Tooltip Line 3"], 1, 0, 0, 1)
	GameTooltip:Show()
end)
GLR_UI.GLR_ScanMailButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_ScanMailButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_ScanMailButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end
--Will enable it once the AddOn is fully initialized.
GLR_UI.GLR_ScanMailButton:Disable()

--Donation Button Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton, "BOTTOM", 0, -5)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetSize(100, 26)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_DonationFrame:Show()
	GLR_UI.GLR_DonationFrame:Hide()
	GLR_UI.GLR_DonationFrame:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Lottery Donation Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Disable()

--Confirm Donation Button Settings
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetPoint("BOTTOM", GLR_UI.GLR_DonationFrame, "BOTTOM", 0, 5)
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetSize(100, 26)
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetScript("OnClick", function(self)
	local continue = true
	local gold = GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText()
	local silver = GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText()
	local copper = GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:GetText()
	if copper == nil or copper == "" then
		continue = false
		GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
		GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetFocus()
	end
	if silver == nil or silver == "" then
		continue = false
		GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
		if continue then
			GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetFocus()
		end
	end
	if gold == nil or gold == "" then
		continue = false
		GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("0")
		if continue then
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetFocus()
		end
	end
	if continue then
		gold = tonumber(gold)
		if gold == nil then
			continue = false
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("")
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetFocus()
		end
		if continue then
			CompleteDonation()
		end
	end
end)
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetScript("OnEnter", function(self)
	local gold = GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText()
	local silver = GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText()
	local copper = GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:GetText()
	if gold == nil or gold == "" then
		gold = "0"
	else --Does this part in case someone's typed letters into the entry field and changes it back to zero.
		gold = tonumber(gold)
		if gold == nil then --They typed letters because tonumber() returns nil for letters
			gold = "0"
		else --They didn't type letters so lets convert back to string
			gold = tostring(gold)
		end
	end
	if silver == nil or silver == "" then
		silver = "00"
	else
		silver = tonumber(silver)
		if silver == nil then
			silver = "00"
		elseif silver < 10 then
			silver = "0" .. tostring(silver)
		else
			silver = tostring(silver)
		end
	end
	if copper == nil or copper == "" then
		copper = "00"
	else
		copper = tonumber(copper)
		if copper == nil then
			copper = "00"
		elseif copper < 10 then
			copper = "0" .. tostring(copper)
		else
			copper = tostring(copper)
		end
	end
	local money = tonumber(gold .. "." .. silver .. copper)
	local total = GLR_U:GetMoneyValue(money, "Lottery", false, 1, "NA", true, true, true)
	local text = string.gsub(L["Lottery Donation Confirmation Button Tooltip"], "%%amount", total)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(text)
	GameTooltip:AddLine(L["Lottery Donation Confirmation Button Tooltip Warning"], 1, 0, 0, 1)
	GameTooltip:Show()
end)
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end

---------------------------
--- END BUTTON SETTINGS ---
---------------------------

---------------------------
------ BUTTON STRING ------
--------- SETTINGS --------
---------------------------

--Debug Button String & Settings
--[[
GLR_UI.GLR_MainFrame.GLR_DebugButtonText = GLR_UI.GLR_MainFrame.GLR_DebugButton:CreateFontString("GLR_DebugButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_DebugButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_DebugButton)
GLR_UI.GLR_MainFrame.GLR_DebugButtonText:SetText("Debug")
GLR_UI.GLR_MainFrame.GLR_DebugButtonText:SetFont(GLR_UI.ButtonFont, 11)
--]]

--New Lottery Date Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:CreateFontString("GLR_NewLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButtonText:SetText(L["New Lottery Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--New Raffle Date Button String & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButtonText = GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:CreateFontString("GLR_NewRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButtonText:SetText(L["New Raffle Button"])
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Begin Lottery Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:CreateFontString("GLR_BeginLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButtonText:SetText(L["Begin Lottery Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Begin Raffle Button String & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButtonText = GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:CreateFontString("GLR_BeginRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButtonText:SetText(L["Begin Raffle Button"])
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Alert Guild Button String & Settings
GLR_UI.GLR_MainFrame.GLR_AlertGuildButtonText = GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:CreateFontString("GLR_AlertGuildButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_AlertGuildButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_AlertGuildButton)
GLR_UI.GLR_MainFrame.GLR_AlertGuildButtonText:SetText(L["Alert Guild Button"])
GLR_UI.GLR_MainFrame.GLR_AlertGuildButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Add Player to Lottery Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:CreateFontString("GLR_AddPlayerToLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButtonText:SetText(L["New Player Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Add Player to Raffle Button String & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButtonText = GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:CreateFontString("GLR_AddPlayerToRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButtonText:SetText(L["New Player Button"])
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Edit Player in Lottery Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:CreateFontString("GLR_EditPlayerInLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButtonText:SetText(L["Edit Players Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Edit Player in Raffle Button String & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButtonText = GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:CreateFontString("GLR_EditPlayerInRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButtonText:SetText(L["Edit Players Button"])
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Open Interface Options Button String & Settings
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButtonText = GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:CreateFontString("GLR_OpenInterfaceOptionsButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton)
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButtonText:SetText(L["Configure Button"])
GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Go To Raffle Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton:CreateFontString("GLR_GoToRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButtonText:SetText(L["Go To Raffle Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Go To Lottery Button String & Settings
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButtonText = GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton:CreateFontString("GLR_GoToLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButtonText:SetText(L["Go To Lottery Button"])
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Start New Lottery Button String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButtonText = GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:CreateFontString("GLR_StartNewLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButtonText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton)
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButtonText:SetText(L["Start New Lottery Button"])
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Start New Raffle Button String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButtonText = GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:CreateFontString("GLR_StartNewRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButtonText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton)
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButtonText:SetText(L["Start New Raffle Button"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Add Raffle Item One Button String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButtonText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:CreateFontString("GLR_ConfirmRaffleItemOneButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButtonText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButtonText:SetText(L["Confirm Add Raffle Item"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Add Raffle Item Two Button String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButtonText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:CreateFontString("GLR_ConfirmRaffleItemTwoButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButtonText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButtonText:SetText(L["Confirm Add Raffle Item"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Add Raffle Item Three Button String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButtonText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:CreateFontString("GLR_ConfirmRaffleItemThreeButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButtonText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButtonText:SetText(L["Confirm Add Raffle Item"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Abort Lottery/Raffle Roll Process Button String & Settings
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButtonText = GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:CreateFontString("GLR_AbortRollProcessButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButtonText:SetText(L["Abort Roll"])
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confrim Abort Lottery/Raffle Roll Process Button String & Settings
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButtonText = GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:CreateFontString("GLR_ConfirmAbortRollProcessButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton)
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButtonText:SetText(L["Confirm Abort Roll"])
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Scan Mail Button String & Settings
GLR_UI.GLR_ScanMailButtonText = GLR_UI.GLR_ScanMailButton:CreateFontString("GLR_ScanMailButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_ScanMailButtonText:SetPoint("CENTER", GLR_UI.GLR_ScanMailButton)
GLR_UI.GLR_ScanMailButtonText:SetText(L["Scan Mail Button"])
GLR_UI.GLR_ScanMailButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Donation Button String & Settings
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButtonText = GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:CreateFontString("GLR_DonationButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButtonText:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButtonText:SetText(L["Donation Button"])
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Donation Button String & Settings
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButtonText = GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton:CreateFontString("GLR_ConfirmDonationButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButtonText:SetPoint("CENTER", GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton)
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButtonText:SetText(L["Confirm Action Button"])
GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButtonText:SetFont(GLR_UI.ButtonFont, 11)

---------------------------
-------- END BUTTON -------
----- STRING SETTINGS -----
---------------------------

---------------------------
------- CREATE DROP -------
-------- DOWN MENUS -------
---------------------------

--Begin New Lottery Frame Drop Down Menus

--Menu for List of Months
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection = CreateFrame("Frame", "GLR_Lottery_ListOfMonthsSelection", GLR_UI.GLR_NewLotteryEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu = CreateFrame("Frame", "GLR_Lottery_ListOfMonthsSelectionMenu", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection, "BackdropTemplate")


--Menu for List of Days
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection = CreateFrame("Frame", "GLR_Lottery_ListOfDaysSelection", GLR_UI.GLR_NewLotteryEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu = CreateFrame("Frame", "GLR_Lottery_ListOfDaysSelectionMenu", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection, "BackdropTemplate")


--Menu for List of Years
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection = CreateFrame("Frame", "GLR_Lottery_ListOfYearsSelection", GLR_UI.GLR_NewLotteryEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu = CreateFrame("Frame", "GLR_Lottery_ListOfYearsSelectionMenu", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection, "BackdropTemplate")


--Menu for List of Hours
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection = CreateFrame("Frame", "GLR_Lottery_ListOfHoursSelection", GLR_UI.GLR_NewLotteryEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu = CreateFrame("Frame", "GLR_Lottery_ListOfHoursSelectionMenu", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection, "BackdropTemplate")


--Menu for List of Minutes
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection = CreateFrame("Frame", "GLR_Lottery_ListOfMinutesSelection", GLR_UI.GLR_NewLotteryEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu = CreateFrame("Frame", "GLR_Lottery_ListOfMinutesSelectionMenu", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection, "BackdropTemplate")


--Menu for List of Players to Edit
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection = CreateFrame("Frame", "GLR_Lottery_SelectPlayerSelection", GLR_UI.GLR_EditPlayerInLotteryFrame, "InsetFrameTemplate3")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu = CreateFrame("Frame", "GLR_Lottery_SelectPlayerSelectionMenu", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection, "BackdropTemplate")

--End Lottery Frame Drop Down Menus

--Begin Raffle Frame Drop Down Menus

--Menu for List of Months
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection = CreateFrame("Frame", "GLR_Raffle_ListOfMonthsSelection", GLR_UI.GLR_NewRaffleEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu = CreateFrame("Frame", "GLR_Raffle_ListOfMonthsSelectionMenu", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection, "BackdropTemplate")


--Menu for List of Days
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection = CreateFrame("Frame", "GLR_Raffle_ListOfDaysSelection", GLR_UI.GLR_NewRaffleEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu = CreateFrame("Frame", "GLR_Raffle_ListOfDaysSelectionMenu", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection, "BackdropTemplate")


--Menu for List of Years
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection = CreateFrame("Frame", "GLR_Raffle_ListOfYearsSelection", GLR_UI.GLR_NewRaffleEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu = CreateFrame("Frame", "GLR_Raffle_ListOfYearsSelectionMenu", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection, "BackdropTemplate")


--Menu for List of Hours
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection = CreateFrame("Frame", "GLR_Raffle_ListOfHoursSelection", GLR_UI.GLR_NewRaffleEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu = CreateFrame("Frame", "GLR_Raffle_ListOfHoursSelectionMenu", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection, "BackdropTemplate")


--Menu for List of Minutes
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection = CreateFrame("Frame", "GLR_Raffle_ListOfMinutesSelection", GLR_UI.GLR_NewRaffleEventFrame, "InsetFrameTemplate3")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu = CreateFrame("Frame", "GLR_Raffle_ListOfMinutesSelectionMenu", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection, "BackdropTemplate")


--Menu for List of Players to Edit
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection = CreateFrame("Frame", "GLR_Raffle_SelectPlayerSelection", GLR_UI.GLR_EditPlayerInRaffleFrame, "InsetFrameTemplate3")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu = CreateFrame("Frame", "GLR_Raffle_SelectPlayerSelectionMenu", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection, "BackdropTemplate")

--End Raffle Frame Drop Down Menus

---------------------------
--------- END DROP --------
-------- DOWN MENUS -------
---------------------------

---------------------------
------- SROLL FRAMES ------
------- & SLIDERS & -------
--------- CONTENT ---------
---------------------------

--Lottery Player Names Scroll Frame, Content Frame and Slider
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame = CreateFrame("ScrollFrame", "GLR_PlayerNamesScrollFrame", GLR_UI.GLR_MainFrame)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild = CreateFrame("Frame", "GLR_PlayerNamesScrollFrameChild", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider = CreateFrame("Slider", "GLR_PlayerNamesScrollFrameSlider", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame, "UIPanelScrollBarTemplate")

--Ticket Numbers Scroll Frame, Content Frame and Slider
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame = CreateFrame("ScrollFrame", "GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame", GLR_UI.GLR_ViewPlayerTicketInfoFrame)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild = CreateFrame("Frame", "GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider = CreateFrame("Slider", "GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame, "UIPanelScrollBarTemplate")

--Edit Player In Lottery Scroll Frame, Content Frame and Slider
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetSize(240, 160)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame = CreateFrame("ScrollFrame", "GLR_EditLotteryNameScrollFrame", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild = CreateFrame("Frame", "GLR_EditLotteryNameFrameChild", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider = CreateFrame("Slider", "GLR_EditLotteryNameFrameSlider", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu, "UIPanelScrollBarTemplate")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))

--Edit Player In Raffle Scroll Frame, Content Frame and Slider
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetSize(240, 160)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame = CreateFrame("ScrollFrame", "GLR_EditRaffleNameScrollFrame", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild = CreateFrame("Frame", "GLR_EditRaffleNameFrameChild", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider = CreateFrame("Slider", "GLR_EditRaffleNameFrameSlider", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu, "UIPanelScrollBarTemplate")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))

---------------------------
----------- END -----------
------ SCROLL FRAMES ------
---------------------------

---------------------------
------- CREATE FONT -------
--------- STRINGS ---------
---------------------------

--Begin Main Frame Font Strings

--Guild Lottery & Raffle Title String & Settings
GLR_UI.GLR_MainFrame.GLR_Title = GLR_UI.GLR_MainFrame:CreateFontString("GLR_Title", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_MainFrame.GLR_Title:SetPoint("TOP", GLR_UI.GLR_MainFrame, "TOP", 0, -6)
if GLR_ReleaseState then
	GLR_UI.GLR_MainFrame.GLR_Title:SetText(L["Guild Lottery & Raffles"] .. " " .. GLR_VersionString)
else
	if GLR_ReleaseType == "alpha" then
		GLR_UI.GLR_MainFrame.GLR_Title:SetText(L["Guild Lottery & Raffles"] .. " " .. GLR_VersionString .. "-a." .. GLR_ReleaseNumber)
	elseif GLR_ReleaseType == "beta" then
		GLR_UI.GLR_MainFrame.GLR_Title:SetText(L["Guild Lottery & Raffles"] .. " " .. GLR_VersionString .. "-b." .. GLR_ReleaseNumber)
	else
		GLR_UI.GLR_MainFrame.GLR_Title:SetText(L["Guild Lottery & Raffles"] .. " " .. GLR_VersionString .. "-nr." .. GLR_ReleaseNumber)
	end
end
GLR_UI.GLR_MainFrame.GLR_Title:SetFont(GLR_UI.Font, 12)

--Lottery Setting Frame Title String & Settings
GLR_UI.GLR_LotteryInfo.GLR_LotteryInfoTitle = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_LotteryInfoTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_LotteryInfoTitle:SetPoint("BOTTOM", GLR_UI.GLR_LotteryInfo, "TOP", 0, 2)
GLR_UI.GLR_LotteryInfo.GLR_LotteryInfoTitle:SetText(L["GLR - UI > Main - Lottery & Raffle Info"])
GLR_UI.GLR_LotteryInfo.GLR_LotteryInfoTitle:SetFont(GLR_UI.Font, 12)

--Raffle Setting Frame Title & String
GLR_UI.GLR_RaffleInfo.GLR_RaffleInfoTitle = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleInfoTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleInfoTitle:SetPoint("BOTTOM", GLR_UI.GLR_RaffleInfo, "TOP", 0, 2)
GLR_UI.GLR_RaffleInfo.GLR_RaffleInfoTitle:SetText(L["GLR - UI > Main - Lottery & Raffle Info"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleInfoTitle:SetFont(GLR_UI.Font, 12)

--Lottery Players Frame Title String & Settings
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorderTitle = GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder:CreateFontString("GLR_PlayerNamesBorderTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorderTitle:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder, "TOP", 0, 2)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorderTitle:SetText(L["GLR - UI > Main - Player Ticket Information"])
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorderTitle:SetFont(GLR_UI.Font, 12)

--Number of Unused Tickets Frame Title String & Settings
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderTitle = GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:CreateFontString("GLR_NumberOfUnusedTicketsRangeBorderTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderTitle:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder, "TOP", 0, 2)
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderTitle:SetText(L["GLR - UI > Main - Ticket Pool"])
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderTitle:SetFont(GLR_UI.Font, 12)

--Number of Unused Tickets String & Settings
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderAmount = GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:CreateFontString("GLR_NumberOfUnusedTicketsRangeBorderAmount", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderAmount:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder)
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderAmount:SetText("0")
GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderAmount:SetFont(GLR_UI.ButtonFont, 14)

--Ticket Number Range Frame Title String & Settings
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderTitle = GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:CreateFontString("GLR_TicketNumberRangeBorderTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderTitle:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder, "TOP", 0, 2)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderTitle:SetText(L["GLR - UI > Main - Ticket Number Range"])
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderTitle:SetFont(GLR_UI.Font, 12)

--Ticket Number Range Frame Dash String & Settings
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash = GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:CreateFontString("GLR_TicketNumberRangeBorderDash", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash:SetText("-")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash:SetFont(GLR_UI.ButtonFont, 14)

--Ticket Number Range Low String & Settings
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow = GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:CreateFontString("GLR_TicketNumberRangeBorderLow", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetPoint("RIGHT", GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash, "LEFT", -10, 0)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetFont(GLR_UI.ButtonFont, 14)

--Ticket Number Range High String & Settings
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh = GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorder:CreateFontString("GLR_TicketNumberRangeBorderHigh", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetPoint("LEFT", GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderDash, "RIGHT", 10, 0)
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("")
GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetFont(GLR_UI.ButtonFont, 14)

--Lottery Date String & Settings
GLR_UI.GLR_LotteryInfo.GLR_LotteryDate = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_LotteryDate", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_LotteryDate:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo, "TOPLEFT", 40, -15)
GLR_UI.GLR_LotteryInfo.GLR_LotteryDate:SetText(L["Lottery Date"])
GLR_UI.GLR_LotteryInfo.GLR_LotteryDate:SetFont(GLR_UI.Font, 12)

--Lottery Name String & Settings
GLR_UI.GLR_LotteryInfo.GLR_LotteryName = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_LotteryName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_LotteryName:SetPoint("LEFT", GLR_UI.GLR_LotteryInfo.GLR_LotteryDate, "LEFT", 160, 0)
GLR_UI.GLR_LotteryInfo.GLR_LotteryName:SetText(L["Lottery Name"])
GLR_UI.GLR_LotteryInfo.GLR_LotteryName:SetFont(GLR_UI.Font, 12)

--Lottery Starting Gold String & Settings
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_StartingGoldTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_LotteryDate, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"])
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetFont(GLR_UI.Font, 12)

--Jackpot String & Settings
GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_JackpotTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetPoint("LEFT", GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle, "LEFT", 160, 0)
GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"])
GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetFont(GLR_UI.Font, 12)

--Lottery Max Tickets String & Settings
GLR_UI.GLR_LotteryInfo.GLR_MaxTickets = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_MaxTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_MaxTickets:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_LotteryInfo.GLR_MaxTickets:SetText(L["Max Tickets"])
GLR_UI.GLR_LotteryInfo.GLR_MaxTickets:SetFont(GLR_UI.Font, 12)

--Lottery Ticket Price String & Settings
GLR_UI.GLR_LotteryInfo.GLR_TicketPrice = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_TicketPrice", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_TicketPrice:SetPoint("LEFT", GLR_UI.GLR_LotteryInfo.GLR_MaxTickets, "LEFT", 160, 0)
GLR_UI.GLR_LotteryInfo.GLR_TicketPrice:SetText(L["Ticket Price"])
GLR_UI.GLR_LotteryInfo.GLR_TicketPrice:SetFont(GLR_UI.Font, 12)

--Lottery Second Place String & Settings
GLR_UI.GLR_LotteryInfo.GLR_SecondPlace = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_SecondPlace", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_MaxTickets, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetText(L["Second Place Text"])
GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetFont(GLR_UI.Font, 12)

--Lottery Guilds Cut String & Settings
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText = GLR_UI.GLR_LotteryInfo:CreateFontString("GLR_GuildAmountText", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetPoint("LEFT", GLR_UI.GLR_LotteryInfo.GLR_SecondPlace, "LEFT", 160, 0)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetText(L["Guild Amount Text"])
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetFont(GLR_UI.Font, 12)

--Raffle Date String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleDate = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleDate", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleDate:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo, "TOPLEFT", 40, -15)
GLR_UI.GLR_RaffleInfo.GLR_RaffleDate:SetText(L["Raffle Date"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleDate:SetFont(GLR_UI.Font, 12)

--Raffle Name String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleName = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleName:SetPoint("LEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleDate, "LEFT", 160, 0)
GLR_UI.GLR_RaffleInfo.GLR_RaffleName:SetText(L["Raffle Name"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleName:SetFont(GLR_UI.Font, 12)

--Raffle Max Tickets String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleMaxTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleDate, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets:SetText(L["Max Tickets"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets:SetFont(GLR_UI.Font, 12)

--Raffle Ticket Price String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPrice = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleTicketPrice", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPrice:SetPoint("LEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets, "LEFT", 160, 0)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPrice:SetText(L["Ticket Price"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPrice:SetFont(GLR_UI.Font, 12)

--Raffle First Place Prize String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleFirstPlacePrize", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetText(L["Raffle First Place"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetFont(GLR_UI.Font, 12)

--Raffle Second Place Prize String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleSecondPlacePrize", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetPoint("LEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize, "LEFT", 160, 0)
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetText(L["Raffle Second Place"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetFont(GLR_UI.Font, 12)

--Raffle Third Place Prize String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleThirdPlacePrize", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize, "BOTTOMLEFT", 0, -40)
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetText(L["Raffle Third Place"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetFont(GLR_UI.Font, 12)

--Raffle Ticket Sales String & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales = GLR_UI.GLR_RaffleInfo:CreateFontString("GLR_RaffleTicketSales", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales:SetPoint("LEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize, "LEFT", 160, 0)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales:SetText(L["Raffle Sales"])
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales:SetFont(GLR_UI.Font, 12)

--End Main Frame Font Strings

--Begin New Lottery Frame Font Strings

--New Lottery Frame Title String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTitle = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTitle:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame, "TOP", 0, -6)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTitle:SetText(L["New Lottery Settings"])
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTitle:SetFont(GLR_UI.Font, 12)

--Select Date String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_SelectDateTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame, "TOP", 0, -40)
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle:SetText(L["Select Valid Lottery Date"])
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle:SetFont(GLR_UI.ButtonFont, 13)

--Select Hour String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectHourTitle = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_SelectHourTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectHourTitle:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection, "BOTTOMLEFT", 15, -15)
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectHourTitle:SetText(L["Hour"])
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectHourTitle:SetFont(GLR_UI.ButtonFont, 13)

--Select Minute String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectMinuteTitle = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_SelectMinuteTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectMinuteTitle:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection, "RIGHT", 10, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectMinuteTitle:SetText(L["Minute"])
GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectMinuteTitle:SetFont(GLR_UI.ButtonFont, 13)

--New Lottery Name String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryName = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryName:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection, "BOTTOMLEFT", 0, -50)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryName:SetText(L["Set Lottery Name"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryName:SetFont(GLR_UI.Font, 14)

--New Lottery Starting Gold String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGold = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryStartingGold", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGold:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryName, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGold:SetText(L["Set Starting Gold"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGold:SetFont(GLR_UI.Font, 14)

--New Lottery Max Tickets String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTickets = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryMaxTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTickets:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGold, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTickets:SetText(L["Set Maximum Tickets"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTickets:SetFont(GLR_UI.Font, 14)

--New Lottery Ticket Price String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketPrice = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryTicketPrice", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketPrice:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTickets, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketPrice:SetText(L["Set Ticket Price"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketPrice:SetFont(GLR_UI.Font, 14)

--New Lottery Second Place String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlace = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotterySecondPlace", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlace:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketPrice, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlace:SetText(L["Set Second Place Prize"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlace:SetFont(GLR_UI.Font, 14)

--New Lottery Guild Cut String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCut = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_NewLotteryGuildCut", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCut:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlace, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCut:SetText(L["Set Guild Cut"] .. ":")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCut:SetFont(GLR_UI.Font, 14)

--New Lottery Invalid Option String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption = GLR_UI.GLR_NewLotteryEventFrame:CreateFontString("GLR_InvalidOption", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame, "BOTTOM", 0, -5)
GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText("")
GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetFont(GLR_UI.ButtonFont, 14)
GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetTextColor(1, 0, 0, 1)

--End New Lottery Frame Font Strings

--Begin New Raffle Frame Font Strings

--New Raffle Frame Title String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewLotteryTitle = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewLotteryTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewLotteryTitle:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame, "TOP", 0, -6)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewLotteryTitle:SetText(L["New Raffle Settings"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewLotteryTitle:SetFont(GLR_UI.Font, 12)

--Select Date String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectDateTitle = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_SelectDateTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectDateTitle:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame, "TOP", 0, -40)
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectDateTitle:SetText(L["Select Valid Raffle Date"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectDateTitle:SetFont(GLR_UI.ButtonFont, 13)

--Select Hour String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectHourTitle = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_SelectHourTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectHourTitle:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection, "BOTTOMLEFT", 15, -15)
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectHourTitle:SetText(L["Hour"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectHourTitle:SetFont(GLR_UI.ButtonFont, 13)

--Select Minute String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectMinuteTitle = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_SelectMinuteTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectMinuteTitle:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection, "RIGHT", 10, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectMinuteTitle:SetText(L["Minute"])
GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectMinuteTitle:SetFont(GLR_UI.ButtonFont, 13)

--New Raffle Name String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleName = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleName:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection, "BOTTOMLEFT", 0, -50)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleName:SetText(L["Set Raffle Name"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleName:SetFont(GLR_UI.Font, 14)

--New Raffle Max Tickets String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTickets = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleMaxTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTickets:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleName, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTickets:SetText(L["Set Maximum Tickets"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTickets:SetFont(GLR_UI.Font, 14)

--New Raffle Ticket Price String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketPrice = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleTicketPrice", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketPrice:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTickets, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketPrice:SetText(L["Set Ticket Price"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketPrice:SetFont(GLR_UI.Font, 14)

--New Raffle First Place String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlace = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleFirstPlace", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlace:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketPrice, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlace:SetText(L["Set First Place"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlace:SetFont(GLR_UI.Font, 14)

--New Raffle Second Place String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlace = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleSecondPlace", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlace:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlace, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlace:SetText(L["Set Second Place"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlace:SetFont(GLR_UI.Font, 14)

--New Raffle Third Place String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlace = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_NewRaffleThirdPlace", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlace:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlace, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlace:SetText(L["Set Third Place"] .. ":")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlace:SetFont(GLR_UI.Font, 14)

--New Raffle Invalid Option String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption = GLR_UI.GLR_NewRaffleEventFrame:CreateFontString("GLR_InvalidOption", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame, "BOTTOM", 0, -5)
GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetFont(GLR_UI.ButtonFont, 14)
GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetTextColor(1, 0, 0, 1)

--End New Raffle Frame Font Strings

--Begin Add Player to Lottery Frame Font Strings

--Add Player Frame Title String & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTitle = GLR_UI.GLR_AddPlayerToLotteryFrame:CreateFontString("GLR_AddPlayerTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTitle:SetPoint("TOP", GLR_UI.GLR_AddPlayerToLotteryFrame, "TOP", 0, -6)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTitle:SetText(L["Add Player to Lottery"])
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTitle:SetFont(GLR_UI.Font, 12)

--Add Player Name String & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerName = GLR_UI.GLR_AddPlayerToLotteryFrame:CreateFontString("GLR_AddPlayerName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerName:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToLotteryFrame, "TOPLEFT", 20, -40)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerName:SetText(L["Type Player Name"])
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerName:SetFont(GLR_UI.Font, 14)

--Add Player Tickets String & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTickets = GLR_UI.GLR_AddPlayerToLotteryFrame:CreateFontString("GLR_AddPlayerTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTickets:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerName, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTickets:SetText(L["Add Player Tickets"])
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTickets:SetFont(GLR_UI.Font, 14)

--Player Exists/Exceed Tickets String & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters = GLR_UI.GLR_AddPlayerToLotteryFrame:CreateFontString("GLR_ExceededParameters", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetPoint("BOTTOM", GLR_UI.GLR_AddPlayerToLotteryFrame, "BOTTOM", 0, 43)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText("")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetFont(GLR_UI.ButtonFont, 13)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetTextColor(1, 0, 0, 1)

--End Add Player to Lottery Frame Font Strings

--Begin Add Player to Raffle Frame Font Strings

--Add Player Frame Title String & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTitle = GLR_UI.GLR_AddPlayerToRaffleFrame:CreateFontString("GLR_AddPlayerTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTitle:SetPoint("TOP", GLR_UI.GLR_AddPlayerToRaffleFrame, "TOP", 0, -6)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTitle:SetText(L["Add Player to Raffle"])
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTitle:SetFont(GLR_UI.Font, 12)

--Add Player Name String & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerName = GLR_UI.GLR_AddPlayerToRaffleFrame:CreateFontString("GLR_AddPlayerName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerName:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToRaffleFrame, "TOPLEFT", 20, -40)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerName:SetText(L["Type Player Name"])
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerName:SetFont(GLR_UI.Font, 14)

--Add Player Tickets String & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTickets = GLR_UI.GLR_AddPlayerToRaffleFrame:CreateFontString("GLR_AddPlayerTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTickets:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerName, "BOTTOMLEFT", 0, -11)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTickets:SetText(L["Add Player Tickets"])
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTickets:SetFont(GLR_UI.Font, 14)

--Player Exists/Exceed Tickets String & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters = GLR_UI.GLR_AddPlayerToRaffleFrame:CreateFontString("GLR_ExceededParameters", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetPoint("BOTTOM", GLR_UI.GLR_AddPlayerToRaffleFrame, "BOTTOM", 0, 43)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText("")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetFont(GLR_UI.ButtonFont, 13)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetTextColor(1, 0, 0, 1)

--End Add Player to Raffle Frame Font Strings

--Begin Edit Player in Lottery Frame Font Strings

--Edit Player Frame Title String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditLotteryPlayerTitle = GLR_UI.GLR_EditPlayerInLotteryFrame:CreateFontString("GLR_EditLotteryPlayerTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditLotteryPlayerTitle:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame, "TOP", 0, -6)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditLotteryPlayerTitle:SetText(L["Edit Players in Lottery"])
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditLotteryPlayerTitle:SetFont(GLR_UI.Font, 12)

--Select Player To Edit String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer = GLR_UI.GLR_EditPlayerInLotteryFrame:CreateFontString("GLR_SelectLotteryPlayer", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "TOPLEFT", 50, -35)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer:SetText(L["Select Player to Edit"])
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer:SetFont(GLR_UI.Font, 14)

--Selected Player Name To Edit String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer = GLR_UI.GLR_EditPlayerInLotteryFrame:CreateFontString("GLR_SelectedLotteryPlayer", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "LEFT", 15, 0)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer:SetText(L["Edit Player Name Below"])
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer:SetFont(GLR_UI.Font, 14)

--Selected Player Tickets To Edit String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets = GLR_UI.GLR_EditPlayerInLotteryFrame:CreateFontString("GLR_SelectedLotteryPlayerTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets:SetPoint("RIGHT", GLR_UI.GLR_EditPlayerInLotteryFrame, "RIGHT", -15, 0)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets:SetText(L["Edit Player Tickets Below"])
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets:SetFont(GLR_UI.Font, 14)

--Tickets Exceed Player Edit String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets = GLR_UI.GLR_EditPlayerInLotteryFrame:CreateFontString("GLR_ExceededLotteryTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetPoint("BOTTOM", GLR_UI.GLR_EditPlayerInLotteryFrame, "BOTTOM", 0, -18)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText("")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetFont(GLR_UI.ButtonFont, 14)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetTextColor(1, 0, 0, 1)

--End Edit Player in Lottery Frame Font Strings

--Begin Edit Player in Raffle Frame Font Strings

--Edit Player Frame Title String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditRafflePlayerTitle = GLR_UI.GLR_EditPlayerInRaffleFrame:CreateFontString("GLR_EditRafflePlayerTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditRafflePlayerTitle:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame, "TOP", 0, -6)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditRafflePlayerTitle:SetText(L["Edit Players in Raffle"])
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditRafflePlayerTitle:SetFont(GLR_UI.Font, 12)

--Select Player To Edit String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer = GLR_UI.GLR_EditPlayerInRaffleFrame:CreateFontString("GLR_SelectRafflePlayer", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "TOPLEFT", 50, -35)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer:SetText(L["Select Player to Edit"])
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer:SetFont(GLR_UI.Font, 14)

--Selected Player Name To Edit String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer = GLR_UI.GLR_EditPlayerInRaffleFrame:CreateFontString("GLR_SelectedRafflePlayer", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "LEFT", 15, 0)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer:SetText(L["Edit Player Name Below"])
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer:SetFont(GLR_UI.Font, 14)

--Selected Player Tickets To Edit String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets = GLR_UI.GLR_EditPlayerInRaffleFrame:CreateFontString("GLR_SelectedRafflePlayerTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets:SetPoint("RIGHT", GLR_UI.GLR_EditPlayerInRaffleFrame, "RIGHT", -15, 0)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets:SetText(L["Edit Player Tickets Below"])
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets:SetFont(GLR_UI.Font, 14)

--Tickets Exceed Player Edit String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets = GLR_UI.GLR_EditPlayerInRaffleFrame:CreateFontString("GLR_ExceededRaffleTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetPoint("BOTTOM", GLR_UI.GLR_EditPlayerInRaffleFrame, "BOTTOM", 0, -18)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText("")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetFont(GLR_UI.ButtonFont, 14)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetTextColor(1, 0, 0, 1)

--End Edit Player in Raffle Frame Font Strings

--Begin View Player Ticket Info Frame Font Strings

--View Player Ticket Info Frame Title String & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFrameTitle = GLR_UI.GLR_ViewPlayerTicketInfoFrame:CreateFontString("GLR_ViewPlayerTicketInfoFrameTitle", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_ViewPlayerTicketInfoFrameTitle:SetPoint("TOP", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "TOP", 0, -6)
GLR_UI.GLR_ViewPlayerTicketInfoFrameTitle:SetText(L["GLR - UI > Config > Options > Tickets - View Ticket Info Title"])
GLR_UI.GLR_ViewPlayerTicketInfoFrameTitle:SetFont(GLR_UI.Font, 12)

--View Player Ticket Info Frame Player Name String & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName = GLR_UI.GLR_ViewPlayerTicketInfoFrame:CreateFontString("GLR_ViewPlayerTicketInfoFramePlayerName", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName:SetPoint("TOPLEFT", GLR_UI.GLR_ViewPlayerTicketInfoFrame, "TOPLEFT", 20, -35)
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName:SetText(L["Ticket Info Player Name Default"])
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName:SetFont(GLR_UI.Font, 14)

--View Player Ticket Info Frame Player Tickets String & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets = GLR_UI.GLR_ViewPlayerTicketInfoFrame:CreateFontString("GLR_ViewPlayerTicketInfoFramePlayerTickets", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets:SetPoint("TOPLEFT", GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets:SetText(L["Ticket Info Player Tickets Default"])
GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets:SetFont(GLR_UI.Font, 14)

--View Player Ticket Info Frame Gold Value String & Settings
GLR_UI.GLR_ViewPlayerTicketInfoFrameGoldValue = GLR_UI.GLR_ViewPlayerTicketInfoFrame:CreateFontString("GLR_ViewPlayerTicketInfoFrameGoldValue", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_ViewPlayerTicketInfoFrameGoldValue:SetPoint("TOPLEFT", GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_ViewPlayerTicketInfoFrameGoldValue:SetText(L["Ticket Info Gold Value Default"])
GLR_UI.GLR_ViewPlayerTicketInfoFrameGoldValue:SetFont(GLR_UI.Font, 14)

--End View Player Ticket Info Frame Font Strings

--Begin Donation Frame Font Strings

--Donation Frame Description Font String & Settings
GLR_UI.GLR_DonationFrame.GLR_DonationText = GLR_UI.GLR_DonationFrame:CreateFontString("GLR_DonationText", "OVERLAY", "GameFontNormalSmall")
GLR_UI.GLR_DonationFrame.GLR_DonationText:SetPoint("TOP", GLR_UI.GLR_DonationFrame, "TOP", 0, -10)
GLR_UI.GLR_DonationFrame.GLR_DonationText:SetText(L["Donation Description Text"])
GLR_UI.GLR_DonationFrame.GLR_DonationText:SetFont(GLR_UI.Font, 14)

--End Donation Frame Font Strings

---------------------------
----------- END -----------
------- FONT STRINGS ------
---------------------------

---------------------------
-------- DROP DOWN --------
------- MENU STRINGS ------
---------------------------

--Begin Lottery Frame Drop Down Menu Strings

--Menu for List of Months String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:CreateFontString("GLR_Lottery_ListOfMonthsSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Days String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:CreateFontString("GLR_Lottery_ListOfDaysSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Years String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:CreateFontString("GLR_Lottery_ListOfYearsSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Hours String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:CreateFontString("GLR_Lottery_ListOfHoursSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Minutes String & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:CreateFontString("GLR_Lottery_ListOfMinutesSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Players to Edit String & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:CreateFontString("GLR_Lottery_SelectPlayerSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection, 4, 0)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetText("")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--End Lottery Frame Drop Down Menu Strings

--Begin Raffle Frame Drop Down Menu Strings

--Menu for List of Months String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:CreateFontString("GLR_Raffle_ListOfMonthsSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Days String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:CreateFontString("GLR_Raffle_ListOfDaysSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Years String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:CreateFontString("GLR_Raffle_ListOfYearsSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Hours String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:CreateFontString("GLR_Raffle_ListOfHoursSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Minutes String & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:CreateFontString("GLR_Raffle_ListOfMinutesSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetPoint("CENTER", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--Menu for List of Players to Edit String & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:CreateFontString("GLR_Lottery_SelectPlayerSelectionText", "OVERLAY", "GameFontWhiteTiny")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection, 4, 0)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetText("")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetFont(GLR_UI.ButtonFont, 12)

--End Raffle Frame Drop Down Menu Strings

---------------------------
--------- END DROP --------
------- DOWN STRINGS ------
---------------------------

---------------------------
-------- DROP DOWN --------
------ MENU SETTINGS ------
---------------------------

--Begin Lottery Frame Drop Down Menu Settings

--Menu for List of Months Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame, "TOPLEFT", 25, -70)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:SetSize(120, 20)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		else
			GLR:GetListOfMonths("Lottery")
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection, "BOTTOM")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetWidth(120)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Days Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection, "RIGHT", 5, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:SetSize(70, 20)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		else
			GLR:GetListOfDays("Lottery")
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection, "BOTTOM")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetFrameStrata("FULLSCREEN")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetWidth(70)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Years Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection, "RIGHT", 5, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:SetSize(100, 20)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		else
			GLR:GetListOfYears("Lottery")
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection, "BOTTOM")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetWidth(100)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Hours Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectHourTitle, "RIGHT", 5, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:SetSize(75, 20)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		else
			GLR:GetListOfHours("Lottery")
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Show()
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection, "BOTTOM")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetWidth(75)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Minutes Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectMinuteTitle, "RIGHT", 5, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:SetSize(75, 20)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		else
			GLR:GetListOfMinutes("Lottery")
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Show()
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection, "BOTTOM")
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetWidth(75)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Players to Edit in Lottery
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer, "RIGHT", 10, 0)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:SetSize(125, 20)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Hide()
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:IsVisible() then
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Hide()
		else
			GLR:GetListOfPlayersToEdit("Lottery")
			local list = GLR:GetListOfEntries()
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Show()
			local sMin, sMax = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:GetMinMaxValues()
			if list[1] == L["GLR - Error - No Entries Found"] then
				if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:IsVisible() == true then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Hide()
				end
			else
				if sMax == 0 then
					if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:IsVisible() == true then
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Hide()
					end
				elseif GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:IsVisible() == false then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Show()
				end
			end
		end
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "TOPRIGHT", 5, 0)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetWidth(125)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetScript("OnHide", function(self)
	if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText() ~= nil then
		GLR:SetPlayerToEditInEvent("Lottery")
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Hide()
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:Show()
	end
end)

--End Lottery Frame Drop Down Menu Settings

--Begin Raffle Frame Drop Down Menu Settings

--Menu for List of Months Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame, "TOPLEFT", 25, -70)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:SetSize(120, 20)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		else
			GLR:GetListOfMonths("Raffle")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection, "BOTTOM")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetWidth(120)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Days Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection, "RIGHT", 5, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:SetFrameStrata("FULLSCREEN")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:SetSize(70, 20)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		else
			GLR:GetListOfDays("Raffle")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection, "BOTTOM")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetWidth(70)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Years Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection, "RIGHT", 5, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:SetSize(100, 20)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		else
			GLR:GetListOfYears("Raffle")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Show()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection, "BOTTOM")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetWidth(100)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Hours Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectHourTitle, "RIGHT", 5, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:SetSize(75, 20)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		else
			GLR:GetListOfHours("Raffle")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Show()
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection, "BOTTOM")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetWidth(75)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Minutes Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectMinuteTitle, "RIGHT", 5, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:SetSize(75, 20)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		else
			GLR:GetListOfMinutes("Raffle")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Show()
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection, "BOTTOM")
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetWidth(75)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))

--Menu for List of Players to Edit in Raffle
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer, "RIGHT", 10, 0)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:SetSize(125, 20)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:SetScript("OnShow", function(self)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:Hide()
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:SetScript("OnMouseDown", function(_, button)
	if button == "LeftButton" then
		if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:IsVisible() then
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:Hide()
		else
			GLR:GetListOfPlayersToEdit("Raffle")
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:Show()
			local list = GLR:GetListOfEntries()
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Show()
			local sMin, sMax = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:GetMinMaxValues()
			if list[1] == L["GLR - Error - No Entries Found"] then
				if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:IsVisible() == true then
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Hide()
				end
			else
				if sMax == 0 then
					if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:IsVisible() == true then
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Hide()
					end
				elseif GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:IsVisible() == false then
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Show()
				end
			end
		end
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "TOPRIGHT", 5, 0)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetWidth(125)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetScript("OnHide", function(self)
	if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText() ~= nil then
		GLR:SetPlayerToEditInEvent("Raffle")
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:Hide()
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:Show()
	end
end)

--End Raffle Frame Drop Down Menu Settings

--Begin Add Player Name Drop Down Menu Settings

--These Drop Down Menu Settings can be found further down.

--End Add Player Name Drop Down Menu Settings

---------------------------
------ END DROP DOWN ------
------ MENU SETTINGS ------
---------------------------

---------------------------
------- CHECK BUTTON ------
---------------------------

--New Lottery Frame Guarantee Winner Check Button
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton = CreateFrame("CheckButton", "GLR_GuaranteeWinnerCheckButton", GLR_UI.GLR_NewLotteryEventFrame, "UICheckButtonTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_NewLotteryEventFrame, "BOTTOMLEFT", 15, 15)
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetName() .. "Text"]:SetText(L["Guarantee Winner Check Button"])
_G[GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:EnableMouse(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetScript("OnClick", function(self)
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Guarantee Winner Check Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Raffle Frame Allow Invalid Items Check Button
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton = CreateFrame("CheckButton", "GLR_AllowInvalidItemCheckButton", GLR_UI.GLR_NewRaffleEventFrame, "UICheckButtonTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_NewRaffleEventFrame, "BOTTOMLEFT", 15, 15)
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:GetName() .. "Text"]:SetText(L["Allow Invalid Item Check Button"])
_G[GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:EnableMouse(true)
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetScript("OnClick", function(self)
	if not GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:GetChecked() then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() ~= "" then
			GLR:ConfirmValidItem("First", true)
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() ~= "" then
			GLR:ConfirmValidItem("Second", true)
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() ~= "" then
			GLR:ConfirmValidItem("Third", true)
		end
	end
end)

--[[
Frames[5].AllowInvalidItemsCheckButton:SetScript("OnClick", function(self)
	if not Frames[5].AllowInvalidItemsCheckButton:GetChecked() then
		if not Variables[20][1][1] then
			ConfirmAddNewPrizes("Second")
		end
		if not Variables[20][1][2] then
			ConfirmAddNewPrizes("Third")
		end
	end
end)
]]

GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Allow Invalid Item Check Button Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Lottery: Add Player as Free Ticket Entry
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton = CreateFrame("CheckButton", "GLR_AddFreeLotteryTicketsCheckButton", GLR_UI.GLR_AddPlayerToLotteryFrame, "UICheckButtonTemplate")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_AddPlayerToLotteryFrame, "BOTTOMLEFT", 10, 10)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:GetName() .. "Text"]:SetText(L["Add Free Tickets"])
_G[GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:EnableMouse(true)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetScript("OnClick", function(self)
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Free Tickets Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Lottery: Edit Player as Free Ticket Entry
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton = CreateFrame("CheckButton", "GLR_EditFreeLotteryTicketsCheckButton", GLR_UI.GLR_EditPlayerInLotteryFrame, "UICheckButtonTemplate")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "BOTTOMLEFT", 10, 10)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:GetName() .. "Text"]:SetText(L["Edit Free Tickets"])
_G[GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:EnableMouse(true)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetScript("OnClick", function(self)
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Free Tickets Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Raffle: Add Player as Free Ticket Entry
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton = CreateFrame("CheckButton", "GLR_AddFreeRaffleTicketsCheckButton", GLR_UI.GLR_AddPlayerToRaffleFrame, "UICheckButtonTemplate")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_AddPlayerToRaffleFrame, "BOTTOMLEFT", 10, 10)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:GetName() .. "Text"]:SetText(L["Add Free Tickets"])
_G[GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:EnableMouse(true)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetScript("OnClick", function(self)
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Free Tickets Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Raffle: Edit Player as Free Ticket Entry
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton = CreateFrame("CheckButton", "GLR_EditFreeRaffleTicketsCheckButton", GLR_UI.GLR_EditPlayerInRaffleFrame, "UICheckButtonTemplate")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "BOTTOMLEFT", 10, 10)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetSize(25, 25)
_G[GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:GetName() .. "Text"]:SetText(L["Edit Free Tickets"])
_G[GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:EnableMouse(true)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetScript("OnClick", function(self)
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Free Tickets Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

---------------------------
----------- END -----------
------- CHECK BUTTON ------
---------------------------

---------------------------
-------- EDIT BOXES -------
---------------------------

--Debug Edit Box
--[[
GLR_UI.GLR_MainFrame.GLR_DebugEditBox = CreateFrame("EditBox", "GLR_DebugEditBox", GLR_UI.GLR_MainFrame.GLR_DebugButton, "InputBoxTemplate")
GLR_UI.GLR_MainFrame.GLR_DebugEditBox:SetPoint("BOTTOM", GLR_UI.GLR_MainFrame.GLR_DebugButton, "TOP", 0, 5)
GLR_UI.GLR_MainFrame.GLR_DebugEditBox:SetSize(100, 25)
GLR_UI.GLR_MainFrame.GLR_DebugEditBox:SetAutoFocus(false)
--]]

--Begin Main Frame Edit Boxes

--Lottery Date Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox = CreateFrame("EditBox", "GLR_LotteryDateEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_LotteryDate, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetEnabled(false)

--Lottery Name Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox = CreateFrame("EditBox", "GLR_LotteryNameEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_LotteryName, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetEnabled(false)

--Lottery Starting Gold Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox = CreateFrame("EditBox", "GLR_StartingGoldEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetEnabled(false)

--Jackpot Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox = CreateFrame("EditBox", "GLR_JackpotEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetEnabled(false)

--Max Tickets Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox = CreateFrame("EditBox", "GLR_MaxTicketsEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_MaxTickets, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetEnabled(false)
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Max Tickets Edit Box Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Ticket Price Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox = CreateFrame("EditBox", "GLR_TicketPriceEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_TicketPrice, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetEnabled(false)

--Second Place Lottery Prize Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox = CreateFrame("EditBox", "GLR_SecondPlaceEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_SecondPlace, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetEnabled(false)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnEnter", function(self)
	local msg = string.gsub(L["Jackpot Place Edit Box Tooltip"], "%%v", L["Second"])
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(msg)
	if tonumber(glrCharacter.Event.Lottery.SecondPlace) ~= nil then
		if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
			local msg2 = string.gsub(L["Percentage of Jackpot Tooltip"], "%%v", glrCharacter.Event.Lottery.SecondPlace)
			GameTooltip:AddLine(msg2)
		end
	end
	GameTooltip:Show()
end)
GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Guilds Amount Lottery Edit Box & Settings
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox = CreateFrame("EditBox", "GLR_GuildAmountEditBox", GLR_UI.GLR_LotteryInfo, "InputBoxTemplate")
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetSize(120, 25)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetAutoFocus(false)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetEnabled(false)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Jackpot Guild Place Edit Box Tooltip"])
	if tonumber(glrCharacter.Event.Lottery.GuildCut) ~= nil then
		if tonumber(glrCharacter.Event.Lottery.GuildCut) > 0 then
			local msg = string.gsub(L["Percentage of Jackpot Tooltip"], "%%v", glrCharacter.Event.Lottery.GuildCut)
			GameTooltip:AddLine(msg)
		end
	end
	GameTooltip:Show()
end)
GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Raffle Date Edit Box & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox = CreateFrame("EditBox", "GLR_RaffleDateEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleDate, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetEnabled(false)

--Raffle Name Edit Box & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox = CreateFrame("EditBox", "GLR_RaffleNameEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleName, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetEnabled(false)

--Raffle Max Tickets Edit Box & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox = CreateFrame("EditBox", "GLR_RaffleMaxTicketsEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTickets, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetEnabled(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Max Tickets Edit Box Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Raffle Ticket Price Edit Box & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox = CreateFrame("EditBox", "GLR_RaffleTicketPriceEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPrice, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetEnabled(false)

--Raffle First Place Prize
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox = CreateFrame("EditBox", "GLR_RaffleFirstPlacePrizeEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetEnabled(false)

--Raffle Second Place Prize
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox = CreateFrame("EditBox", "GLR_RaffleSecondPlacePrizeEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetEnabled(false)

--Raffle Third Place Prize
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox = CreateFrame("EditBox", "GLR_RaffleThirdPlacePrizeEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetEnabled(false)

--Raffle Sales Edit Box & Settings
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox = CreateFrame("EditBox", "GLR_RaffleTicketSalesEditBox", GLR_UI.GLR_RaffleInfo, "InputBoxTemplate")
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales, "BOTTOMLEFT", 0, -5)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetSize(120, 25)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetAutoFocus(false)
GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetEnabled(false)

--End Main Frame Edit Boxes

--Begin New Lottery Frame Edit Boxes

--New Lottery Name Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox = CreateFrame("EditBox", "GLR_NewLotteryNameEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection, "BOTTOMLEFT", 15, -45)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetSize(100, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Lottery Name"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Lottery Starting Gold Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox = CreateFrame("EditBox", "GLR_NewLotteryStartingGoldEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetSize(75, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetScript("OnEditFocusLost", function(self)
	local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText())
	if gold == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText("")
	else
		gold = math.floor(gold)
		if gold < 0 then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText("0")
		else
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Starting Gold Part 1"])
		GameTooltip:AddLine(L["Set Starting Gold Part 2"])
		GameTooltip:AddLine(L["Set Starting Gold Part 3"], 1, 0, 0)
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local StartingGoldIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("StartingGoldIcon", "ARTWORK")
StartingGoldIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox, "RIGHT")
StartingGoldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")

--New Lottery Starting Silver Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox = CreateFrame("EditBox", "GLR_NewLotteryStartingSilverEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetSize(20, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("00")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetScript("OnEditFocusLost", function(self)
	local silver = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText())
	if silver == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("00")
	else
		silver = math.floor(silver)
		if silver >= 100 then
			local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText())
			if gold == nil then
				gold = math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
			else
				gold = gold + math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
			end
		else
			if silver <= 0 then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("00")
			elseif silver <= 9 then
				silver = "0" .. tostring(silver)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
			else
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
			end
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetFocus()
	end
end)

local StartingSilverIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("StartingSilverIcon", "ARTWORK")
StartingSilverIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox, "RIGHT")
StartingSilverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")

--New Lottery Starting Copper Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox = CreateFrame("EditBox", "GLR_NewLotteryStartingCopperEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetSize(20, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText("00")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetScript("OnEditFocusLost", function(self)
	local copper = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText())
	if copper == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText("00")
	else
		copper = math.floor(copper)
		if copper >= 100 then
			local silver = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText())
			if silver == nil then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("01")
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText(copper)
			else
				silver = silver + math.floor(copper/100)
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText(copper)
				if silver >= 100 then
					local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText())
					if gold == nil then
						gold = math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
					else
						gold = gold + math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
					end
					silver = silver - (math.floor(silver/100) * 100)
					if silver == 0 then
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("00")
					else
						if silver <= 9 then
							silver = "0" .. tostring(silver)
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
					end
				else
					if silver <= 9 then
						silver = "0" .. tostring(silver)
					end
					GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
				end
			end
		else
			if copper <= 0 then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText("00")
			elseif copper <= 9 then
				copper = "0" .. tostring(copper)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText(copper)
			else
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText(copper)
			end
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetFocus()
	end
end)

local StartingCopperIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("StartingCopperIcon", "ARTWORK")
StartingCopperIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox, "RIGHT")
StartingCopperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")

--New Lottery Max Tickets Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox = CreateFrame("EditBox", "GLR_NewLotteryMaxTicketsEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetSize(100, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Maximum Lottery Tickets"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Lottery Ticket Gold Price Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox = CreateFrame("EditBox", "GLR_NewLotteryTicketGoldPriceEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetSize(75, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText())
	if gold == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText("")
	else
		gold = math.floor(gold)
		if gold < 0 then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText("0")
		else
			if gold > 9999999 then
				gold = 9999999
			end
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(gold)
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Lottery Ticket Price"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local LotteryTicketGoldIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("LotteryTicketGoldIcon", "ARTWORK")
LotteryTicketGoldIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox, "RIGHT")
LotteryTicketGoldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")

--New Lottery Ticket Silver Price Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox = CreateFrame("EditBox", "GLR_NewLotteryTicketSilverPriceEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetSize(20, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("00")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local silver = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText())
	if silver == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("00")
	else
		silver = math.floor(silver)
		if silver >= 100 then
			local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText())
			if gold == nil then
				gold = math.floor(silver/100)
				if gold > 9999999 then
					gold = 9999999
				end
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(gold)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
			else
				gold = gold + math.floor(silver/100)
				if gold > 9999999 then
					gold = 9999999
				end
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(gold)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
			end
		else
			if silver <= 0 then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("00")
			elseif silver <= 9 then
				silver = "0" .. tostring(silver)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
			else
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
			end
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetFocus()
	end
end)

local LotteryTicketSilverIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("LotteryTicketSilverIcon", "ARTWORK")
LotteryTicketSilverIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox, "RIGHT")
LotteryTicketSilverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")

--New Lottery Ticket Copper Price Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox = CreateFrame("EditBox", "GLR_NewLotteryTicketCopperPriceEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetSize(20, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText("00")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local copper = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText())
	if copper == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText("00")
	else
		copper = math.floor(copper)
		if copper >= 100 then
			local silver = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText())
			if silver == nil then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("01")
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText(copper)
			else
				silver = silver + math.floor(copper/100)
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText(copper)
				if silver >= 100 then
					local gold = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText())
					if gold == nil then
						gold = math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(gold)
					else
						gold = gold + math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(gold)
					end
					silver = silver - (math.floor(silver/100) * 100)
					if silver == 0 then
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("00")
					else
						if silver <= 9 then
							silver = "0" .. tostring(silver)
						end
						GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
					end
				else
					if silver <= 9 then
						silver = "0" .. tostring(silver)
					end
					GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
				end
			end
		else
			if copper <= 0 then
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText("00")
			elseif copper <= 9 then
				copper = "0" .. tostring(copper)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText(copper)
			else
				GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText(copper)
			end
		end
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetFocus()
	end
end)

local LotteryTicketCopperIcon = GLR_UI.GLR_NewLotteryEventFrame:CreateTexture("LotteryTicketCopperIcon", "ARTWORK")
LotteryTicketCopperIcon:SetPoint("LEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox, "RIGHT")
LotteryTicketCopperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")

--New Lottery Second Place Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox = CreateFrame("EditBox", "GLR_NewLotterySecondPlaceEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetSize(100, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetAutoFocus(false)
--GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:ClearFocus()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetScript("OnEditFocusLost", function(self)
	local text = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:GetText())
	if text == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetText("")
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Second Place Percent"])
		GameTooltip:AddLine(L["Set Lottery Percent Value"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Lottery Guild Cut Edit Box & Settings
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox = CreateFrame("EditBox", "GLR_NewLotteryGuildCutEditBox", GLR_UI.GLR_NewLotteryEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetSize(100, 25)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetAutoFocus(false)
--GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetNumeric(true)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetScript("OnEditFocusLost", function(self)
	local text = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:GetText())
	if text == nil then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetText("")
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Guild Cut Percent"])
		GameTooltip:AddLine(L["Set Lottery Percent Value"])
		if glrCharacter.Data.Settings.Lottery.NoGuildCut then
			GameTooltip:AddLine(L["No Guild Cut Enabled"], 1, 0, 0)
		end
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End New Lottery Frame Edit Boxes

--Begin New Raffle Frame Edit Boxes

--New Raffle Name Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox = CreateFrame("EditBox", "GLR_NewRaffleNameEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection, "BOTTOMLEFT", 15, -45)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetSize(100, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Raffle Name"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Raffle Max Tickets Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox = CreateFrame("EditBox", "GLR_NewRaffleMaxTicketsEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetSize(100, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetNumeric(true)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Maximum Raffle Tickets"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Raffle Ticket Gold Price Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox = CreateFrame("EditBox", "GLR_NewRaffleTicketGoldPriceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetSize(75, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local gold = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText())
	if gold == nil then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText("")
	else
		gold = math.floor(gold)
		if gold < 0 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText("0")
		else
			if gold > 9999999 then
				gold = 9999999
			end
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(gold)
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Raffle Ticket Price"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local RaffleTicketGoldIcon = GLR_UI.GLR_NewRaffleEventFrame:CreateTexture("RaffleTicketGoldIcon", "ARTWORK")
RaffleTicketGoldIcon:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox, "RIGHT")
RaffleTicketGoldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")

--New Raffle Ticket Silver Price Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox = CreateFrame("EditBox", "GLR_NewRaffleTicketSilverPriceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetSize(20, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText("00")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local silver = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText())
	if silver == nil then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText("00")
	else
		silver = math.floor(silver)
		if silver >= 100 then
			local gold = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText())
			if gold == nil then
				gold = math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				if gold > 9999999 then
					gold = 9999999
				end
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(gold)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
			else
				gold = gold + math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if gold > 9999999 then
					gold = 9999999
				end
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(gold)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
			end
		else
			if silver <= 0 then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText("00")
			elseif silver <= 9 then
				silver = "0" .. tostring(silver)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
			end
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetFocus()
	end
end)

local RaffleTicketSilverIcon = GLR_UI.GLR_NewRaffleEventFrame:CreateTexture("RaffleTicketSilverIcon", "ARTWORK")
RaffleTicketSilverIcon:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox, "RIGHT")
RaffleTicketSilverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")

--New Raffle Ticket Copper Price Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox = CreateFrame("EditBox", "GLR_NewRaffleTicketCopperPriceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetSize(20, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText("00")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetNumeric(true)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetScript("OnEditFocusLost", function(self)
	local copper = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText())
	if copper == nil then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText("00")
	else
		copper = math.floor(copper)
		if copper >= 100 then
			local silver = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText())
			if silver == nil then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText("01")
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText(copper)
			else
				silver = silver + math.floor(copper/100)
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText(copper)
				if silver >= 100 then
					local gold = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText())
					if gold == nil then
						gold = math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(gold)
					else
						gold = gold + math.floor(silver/100)
						if gold > 9999999 then
							gold = 9999999
						end
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(gold)
					end
					silver = silver - (math.floor(silver/100) * 100)
					if silver == 0 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText("00")
					else
						if silver <= 9 then
							silver = "0" .. tostring(silver)
						end
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
					end
				else
					if silver <= 9 then
						silver = "0" .. tostring(silver)
					end
					GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
				end
			end
		else
			if copper <= 0 then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText("00")
			elseif copper <= 9 then
				copper = "0" .. tostring(copper)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText(copper)
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText(copper)
			end
		end
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetFocus()
	end
end)

local RaffleTicketCopperIcon = GLR_UI.GLR_NewRaffleEventFrame:CreateTexture("RaffleTicketCopperIcon", "ARTWORK")
RaffleTicketCopperIcon:SetPoint("LEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox, "RIGHT")
RaffleTicketCopperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")

--New Raffle First Place Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox = CreateFrame("EditBox", "GLR_NewRaffleFirstPlaceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetSize(120, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnTextChanged", function(self)
	GLR:RaffleEditBoxTextChanged("First")
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Raffle Prize"])
		GameTooltip:AddLine(L["Set Raffle First Place Prize"])
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Raffle Second Place Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox = CreateFrame("EditBox", "GLR_NewRaffleSecondPlaceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetSize(120, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:ClearFocus()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnTextChanged", function(self)
	GLR:RaffleEditBoxTextChanged("Second")
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Raffle Prize"])
		GameTooltip:AddLine(L["Set Raffle Second Place Prize P1"])
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Set Raffle Second Place Prize P2"], 1, 0, 0, 1)
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--New Raffle Third Place Edit Box & Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox = CreateFrame("EditBox", "GLR_NewRaffleThirdPlaceEditBox", GLR_UI.GLR_NewRaffleEventFrame, "InputBoxTemplate")
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetSize(120, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetAutoFocus(false)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnTextChanged", function(self)
	GLR:RaffleEditBoxTextChanged("Third")
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnEnter", function(self)
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
	else
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
		GameTooltip:AddLine(L["Set Raffle Prize"])
		GameTooltip:AddLine(L["Set Raffle Third Place Prize P1"])
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Set Raffle Third Place Prize P2"], 1, 0, 0, 1)
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End New Raffle Frame Edit Boxes

--Begin Add Player To Lottery Frame Edit Boxes

--Add Player Name to Lottery Edit Box & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox = CreateFrame("EditBox", "GLR_AddPlayerNameToLotteryEditBox", GLR_UI.GLR_AddPlayerToLotteryFrame, "InputBoxTemplate")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetPoint("TOPRIGHT", GLR_UI.GLR_AddPlayerToLotteryFrame, "TOPRIGHT", -20, -35)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetSize(100, 25)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetAutoFocus(false)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:ClearFocus()
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetFocus()
	end
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetScript("OnTextChanged", function(self)
	local text = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:GetText()
	local isFocus = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:HasFocus()
	if isFocus then
		if text ~= "" and text ~= nil then
			GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetTextColor(1, 1, 1, 1)
			GLR:SelectPlayerNameForEntry("Lottery")
		else
			GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Lottery Player Name Part 1"])
	GameTooltip:AddLine(L["Add Lottery Player Name Part 2"])
	GameTooltip:AddLine(L["Add Lottery Player Name Part 3"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Add Player Lottery Tickets Edit Box & Settings
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox = CreateFrame("EditBox", "GLR_AddPlayerTicketsToLotteryEditBox", GLR_UI.GLR_AddPlayerToLotteryFrame, "InputBoxTemplate")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetSize(100, 25)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetAutoFocus(false)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetNumeric(true)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Lottery Player Tickets"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End Add Player to Lottery Frame Edit Boxes

--Begin Add Player to Raffle Frame Edit Boxes

--Add Player Name to Raffle Edit Box & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox = CreateFrame("EditBox", "GLR_AddPlayerNameToRaffleEditBox", GLR_UI.GLR_AddPlayerToRaffleFrame, "InputBoxTemplate")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetPoint("TOPRIGHT", GLR_UI.GLR_AddPlayerToRaffleFrame, "TOPRIGHT", -20, -35)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetSize(100, 25)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetAutoFocus(false)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:ClearFocus()
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetFocus()
	end
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetScript("OnTextChanged", function(self)
	local text = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:GetText()
	local isFocus = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:HasFocus()
	if isFocus then
		if text ~= "" and text ~= nil then
			GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetTextColor(1, 1, 1, 1)
			GLR:SelectPlayerNameForEntry("Raffle")
		else
			GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()
		end
	end
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Raffle Player Name Part 1"])
	GameTooltip:AddLine(L["Add Raffle Player Name Part 2"])
	GameTooltip:AddLine(L["Add Raffle Player Name Part 3"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Add Player Raffle Tickets Edit Box & Settings
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox = CreateFrame("EditBox", "GLR_AddPlayerTicketsToRaffleEditBox", GLR_UI.GLR_AddPlayerToRaffleFrame, "InputBoxTemplate")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetPoint("TOPLEFT", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox, "BOTTOMLEFT", 0, 0)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetSize(100, 25)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetAutoFocus(false)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetNumeric(true)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Add Raffle Player Tickets"])
	GameTooltip:Show()
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End Add Player to Raffle Frame Edit Boxes

--Begin Edit Player in Lottery Frame Edit Boxes

--Selected Player To Edit, Edit Box & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox = CreateFrame("EditBox", "GLR_SelectedPlayerEditBox", GLR_UI.GLR_EditPlayerInLotteryFrame, "InputBoxTemplate")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer, "BOTTOM", 0, -5)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetSize(125, 25)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetAutoFocus(false)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:ClearFocus()
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetFocus()
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnEditFocusLost", function(self)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:HighlightText(0, 0)
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnEditFocusGained", function(self)
	if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText() == "" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetTextColor(1, 1, 1, 1)
	elseif GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText() ~= "" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:HighlightText()
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnChar", function(self)
	local text = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
	if text ~= "" and text ~= nil then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetTextColor(1, 1, 1, 1)
		if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText() ~= nil then
			if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText() ~= "" then
				GLR:SelectPlayerNameToEdit("Lottery")
			end
		end
	else
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Lottery Selected Player"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Selected Player Tickets To Edit, Edit Box & Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox = CreateFrame("EditBox", "GLR_SelectedPlayerTicketsEditBox", GLR_UI.GLR_EditPlayerInLotteryFrame, "InputBoxTemplate")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets, "BOTTOM", 0, -5)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetSize(125, 25)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetNumeric(true)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Lottery Selected Player Tickets"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End Edit Player in Lottery Frame Edit Boxes

--Begin Edit Player in Raffle Frame Edit Boxes

--Selected Player To Edit, Edit Box & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox = CreateFrame("EditBox", "GLR_SelectedRafflePlayerEditBox", GLR_UI.GLR_EditPlayerInRaffleFrame, "InputBoxTemplate")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer, "BOTTOM", 0, -5)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetSize(125, 25)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetAutoFocus(false)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:ClearFocus()
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetFocus()
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnEditFocusLost", function(self)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:HighlightText(0, 0)
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnEditFocusGained", function(self)
	if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText() == "" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetTextColor(1, 1, 1, 1)
	elseif GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText() ~= "" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:HighlightText()
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnChar", function(self)
	local text = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
	if text ~= "" and text ~= nil then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetTextColor(1, 1, 1, 1)
		if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText() ~= nil then
			if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText() ~= "" then
				GLR:SelectPlayerNameToEdit("Raffle")
			end
		end
	else
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Lottery Selected Player"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--Selected Player Tickets To Edit, Edit Box & Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox = CreateFrame("EditBox", "GLR_SelectedRafflePlayerTicketsEditBox", GLR_UI.GLR_EditPlayerInRaffleFrame, "InputBoxTemplate")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets, "BOTTOM", 0, -5)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetSize(125, 25)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetAutoFocus(false)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetNumeric(true)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:ClearFocus()
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Edit Lottery Selected Player Tickets"])
	GameTooltip:Show()
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

--End Edit Player in Raffle Frame Edit Boxes

--Begin Donation Frame Edit Box

--Donation Gold Frame Edit Box
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox = CreateFrame("EditBox", "GLR_DonationGoldEditBox", GLR_UI.GLR_DonationFrame, "InputBoxTemplate")
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetPoint("CENTER", GLR_UI.GLR_DonationFrame, -35, 0)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetSize(75, 25)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetAutoFocus(false)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetNumeric(true)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetScript("OnEditFocusLost", function(self)
	local gold = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText())
	if gold == nil then
		GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("")
	else
		gold = math.floor(gold)
		if gold < 0 then
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("0")
		else
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText(gold)
		end
	end
end)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" or key == "ESCAPE" then
		local text = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText())
		if text == nil then
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("")
		end
		GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:ClearFocus()
		if key ~= "ESCAPE" then
			GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetFocus()
		end
	end
end)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Donation Edit Box Tooltip"])
	GameTooltip:Show()
end)
GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

local DonationGoldIcon = GLR_UI.GLR_DonationFrame:CreateTexture("DonationGoldIcon", "ARTWORK")
DonationGoldIcon:SetPoint("LEFT", GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox, "RIGHT")
DonationGoldIcon:SetTexture("Interface\\MoneyFrame\\UI-GoldIcon")

--Donation Silver Frame Edit Box
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox = CreateFrame("EditBox", "GLR_DonationSilverEditBox", GLR_UI.GLR_DonationFrame, "InputBoxTemplate")
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetPoint("LEFT", GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetSize(20, 25)
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetAutoFocus(false)
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetNumeric(true)
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetScript("OnEditFocusLost", function(self)
	local silver = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText())
	if silver == nil then
		GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
	else
		silver = math.floor(silver)
		if silver >= 100 then
			local gold = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText())
			if gold == nil then
				gold = math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText(gold)
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
			else
				gold = gold + math.floor(silver/100)
				silver = silver - (math.floor(silver/100) * 100)
				if silver <= 9 then
					silver = "0" .. tostring(silver)
				end
				GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText(gold)
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
			end
		else
			if silver <= 0 then
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
			elseif silver <= 9 then
				silver = "0" .. tostring(silver)
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
			else
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
			end
		end
	end
end)
GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" or key == "ESCAPE" then
		local text = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText())
		if text == nil then
			GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
		end
		GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:ClearFocus()
		if key ~= "ESCAPE" then
			GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetFocus()
		end
	end
end)

local DonationSilverIcon = GLR_UI.GLR_DonationFrame:CreateTexture("DonationSilverIcon", "ARTWORK")
DonationSilverIcon:SetPoint("LEFT", GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox, "RIGHT")
DonationSilverIcon:SetTexture("Interface\\MoneyFrame\\UI-SilverIcon")

--Donation Copper Frame Edit Box
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox = CreateFrame("EditBox", "GLR_DonationCopperEditBox", GLR_UI.GLR_DonationFrame, "InputBoxTemplate")
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetPoint("LEFT", GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox, "RIGHT", 21, 0)
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetSize(20, 25)
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetAutoFocus(false)
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetNumeric(true)
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetScript("OnEditFocusLost", function(self)
	local copper = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:GetText())
	if copper == nil then
		GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
	else
		copper = math.floor(copper)
		if copper >= 100 then
			local silver = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:GetText())
			if silver == nil then
				GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("01")
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText(copper)
			else
				silver = silver + math.floor(copper/100)
				copper = copper - (math.floor(copper/100) * 100)
				if copper <= 9 then
					copper = "0" .. tostring(copper)
				end
				GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText(copper)
				if silver >= 100 then
					local gold = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText())
					if gold == nil then
						gold = tostring(math.floor(silver/100))
						GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText(gold)
					else
						gold = tostring(gold + math.floor(silver/100))
						GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText(gold)
					end
					silver = silver - (math.floor(silver/100) * 100)
					if silver == 0 then
						GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText("00")
					else
						if silver <= 9 then
							silver = "0" .. tostring(silver)
						end
						GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
					end
				else
					if silver <= 9 then
						silver = "0" .. tostring(silver)
					end
					GLR_UI.GLR_DonationFrame.GLR_DonationSilverEditBox:SetText(silver)
				end
			end
		else
			if copper <= 0 then
				GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
			elseif copper <= 9 then
				copper = "0" .. tostring(copper)
				GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText(copper)
			else
				GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText(copper)
			end
		end
	end
end)
GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" or key == "ESCAPE" then
		local text = tonumber(GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:GetText())
		if text == nil then
			GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:SetText("00")
		end
		GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox:ClearFocus()
	end
end)

local DonationCopperIcon = GLR_UI.GLR_DonationFrame:CreateTexture("DonationCopperIcon", "ARTWORK")
DonationCopperIcon:SetPoint("LEFT", GLR_UI.GLR_DonationFrame.GLR_DonationCopperEditBox, "RIGHT")
DonationCopperIcon:SetTexture("Interface\\MoneyFrame\\UI-CopperIcon")

--End Donation Frame Edit Box

--Begin Add Player Name Drop Down Menu Settings

--Menu for Adding Player To Lottery
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu = CreateFrame("Frame", "GLR_AddPlayerNameToLotterySelectionMenu", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox, "BackdropTemplate")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetPoint("TOP", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox, "BOTTOM", -1, 1)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetFrameStrata("FULLSCREEN")
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetWidth(100)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()
	end
end)
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))
GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()

--Menu for Adding Player to Raffle
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu = CreateFrame("Frame", "GLR_AddPlayerNameToRaffleSelectionMenu", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox, "BackdropTemplate")

GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetPoint("TOP", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox, "BOTTOM", -1, 1)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetFrameStrata("FULLSCREEN")
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetWidth(100)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()
	end
end)
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))
GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()

--Menu for Editing Player in Lottery
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu = CreateFrame("Frame", "GLR_EditPlayerNameInLotterySelectionMenu", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox, "BackdropTemplate")

GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox, "BOTTOM", -1, 1)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetWidth(125)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	end
end)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()

--Menu for Editing Player in Raffle
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu = CreateFrame("Frame", "GLR_EditPlayerNameInRaffleSelectionMenu", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox, "BackdropTemplate")

GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox, "BOTTOM", -1, 1)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetWidth(125)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
	end
end)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetBackdrop({
	bgFile = profile.frames.dropdown.bgFile,
	edgeFile = profile.frames.dropdown.edgeFile,
	edgeSize = profile.frames.dropdown.edgeSize,
	insets = profile.frames.dropdown.insets
})
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetBackdropColor(unpack(profile.colors.frames.dropdown.bgcolor))
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetBackdropBorderColor(unpack(profile.colors.frames.dropdown.bordercolor))
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()

--End Add Player Name Drop Down Menu Settings

---------------------------
------ END EDIT BOXES -----
---------------------------

---------------------------
----- RAFFLE BUTTONS ------
---------------------------

--Placed these buttons here so they can anchor off the Edit Boxes
--Confirm Add Raffle Item One Button Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox, "TOPRIGHT", 5, -1)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:SetSize(60, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:SetScript("OnClick", function(self)
	GLR:ConfirmValidItem("First")
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Hide()

--Confirm Add Raffle Item Two Button Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox, "TOPRIGHT", 5, -1)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:SetSize(60, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:SetScript("OnClick", function(self)
	GLR:ConfirmValidItem("Second")
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Hide()

--Confirm Add Raffle Item Three Button Settings
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:SetPoint("TOPLEFT", GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox, "TOPRIGHT", 5, -1)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:SetSize(60, 25)
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:SetScript("OnClick", function(self)
	GLR:ConfirmValidItem("Third")
end)
--if GLR_GameVersion == "CLASSIC" then
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:SetBackdrop({
--		edgeFile = profile.buttons.edgeFile,
--		edgeSize = profile.buttons.edgeSize,
--	})
--	GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
--end
GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Hide()

---------------------------
------- SCROLL FRAME ------
--------- SETTINGS --------
---------------------------

--Player Names Scroll Frame Settings
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder.AnchorFrame = CreateFrame("Frame", "AnchorFrame", GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder.AnchorFrame:SetAllPoints(GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder)
--GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder.AnchorFrame:SetSize(1, 1)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:SetSize(225, 160)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_PlayerNamesBorder.AnchorFrame, "TOP", 0, -6)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:SetScrollChild(GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild)
--GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild:SetToplevel(true)
--View Player Ticket Info Scroll Frame Settings
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:SetSize(172, 110)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:SetPoint("TOP", GLR_UI.GLR_ViewPlayerTicketInfoFrame.GLR_ViewPlayerTicketInfoBorder, "TOP", -10, -6)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:SetScrollChild(GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild)

--Edit Player In Lottery Scroll Frame Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetSize(240, 150)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu, "TOP", 0, -5)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetScrollChild(GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild:SetAllPoints(GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame)

--Edit Player In Raffle Scroll Frame Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetSize(240, 150)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu, "TOP", 0, -5)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetScrollChild(GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild)

---------------------------
------- END SCROLL --------
----- FRAME SETTINGS ------
---------------------------

---------------------------
----- SLIDER SETTINGS -----
---------------------------

--Lottery Player Names Slider Frame Settings
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetOrientation("VERTICAL")
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetSize(15, 155)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetPoint("TOPLEFT", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame, "TOPRIGHT", -9, -16)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetPoint("BOTTOMLEFT", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame, "BOTTOMRIGHT", -9, 17)
GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:Hide()

--View Player Ticket Info Slider Frame Settings
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetOrientation("VERTICAL")
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetSize(15, 92)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetPoint("TOPLEFT", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame, "TOPRIGHT", 3, -15)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetPoint("BOTTOMLEFT", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame, "BOTTOMRIGHT", 3, 16)
GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:Hide()

--Edit Player In Lottery Slider Frame Settings
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetOrientation("VERTICAL")
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetSize(15, 160)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu, "TOPRIGHT", -20, -21)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetPoint("BOTTOMLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu, "BOTTOMRIGHT", -20, 20)
GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Hide()

--Edit Player In Raffle Slider Frame Settings
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetOrientation("VERTICAL")
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetSize(15, 160)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu, "TOPRIGHT", -20, -21)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetPoint("BOTTOMLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu, "BOTTOMRIGHT", -20, 20)
GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Hide()

---------------------------
----------- END -----------
----- SLIDER SETTINGS -----
---------------------------

---------------------------
---------- BEGIN ----------
---- BACKDROP SETTINGS ----
---------------------------

local BackdropFrames = {}
local BackdropProfile = {
	Buttons = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		insets = { left = 5 , right = 5 , top = 5 , bottom = 5 },
	}
}

--[[
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton.Backdrop = CreateFrame("Frame", "TestBackdrop", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "BackdropTemplate")
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton.Backdrop:SetAllPoints()
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton.Backdrop.backdropInfo = testprofile
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton.Backdrop:ApplyBackdrop()
]]

BackdropFrames.GLR_NewLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_NewLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_NewLotteryButton:SetAllPoints()
	BackdropFrames.GLR_NewLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_NewLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_NewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_NewRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_NewRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_NewRaffleButton:SetAllPoints()
	BackdropFrames.GLR_NewRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_NewRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_NewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_BeginLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_BeginLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_BeginLotteryButton:SetAllPoints()
	BackdropFrames.GLR_BeginLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_BeginLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_BeginLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_BeginRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_BeginRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_BeginRaffleButton:SetAllPoints()
	BackdropFrames.GLR_BeginRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_BeginRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_BeginRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_AlertGuildButton = CreateFrame("Frame", "BackdropFrames.GLR_AlertGuildButton", GLR_UI.GLR_MainFrame.GLR_AlertGuildButton, "BackdropTemplate")
	BackdropFrames.GLR_AlertGuildButton:SetAllPoints()
	BackdropFrames.GLR_AlertGuildButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_AlertGuildButton:ApplyBackdrop()
	BackdropFrames.GLR_AlertGuildButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_AddPlayerToLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_AddPlayerToLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_AddPlayerToLotteryButton:SetAllPoints()
	BackdropFrames.GLR_AddPlayerToLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_AddPlayerToLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_AddPlayerToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_AddPlayerToRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_AddPlayerToRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_AddPlayerToRaffleButton:SetAllPoints()
	BackdropFrames.GLR_AddPlayerToRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_AddPlayerToRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_AddPlayerToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_EditPlayerInLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_EditPlayerInLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_EditPlayerInLotteryButton:SetAllPoints()
	BackdropFrames.GLR_EditPlayerInLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_EditPlayerInLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_EditPlayerInLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_EditPlayerInRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_EditPlayerInRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_EditPlayerInRaffleButton:SetAllPoints()
	BackdropFrames.GLR_EditPlayerInRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_EditPlayerInRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_EditPlayerInRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_OpenInterfaceOptionsButton = CreateFrame("Frame", "BackdropFrames.GLR_OpenInterfaceOptionsButton", GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton, "BackdropTemplate")
	BackdropFrames.GLR_OpenInterfaceOptionsButton:SetAllPoints()
	BackdropFrames.GLR_OpenInterfaceOptionsButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_OpenInterfaceOptionsButton:ApplyBackdrop()
	BackdropFrames.GLR_OpenInterfaceOptionsButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_GoToLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_GoToLotteryButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_GoToLotteryButton:SetAllPoints()
	BackdropFrames.GLR_GoToLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_GoToLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_GoToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_GoToRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_GoToRaffleButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_GoToRaffleButton:SetAllPoints()
	BackdropFrames.GLR_GoToRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_GoToRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_GoToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_StartNewLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_StartNewLotteryButton", GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_StartNewLotteryButton:SetAllPoints()
	BackdropFrames.GLR_StartNewLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_StartNewLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_StartNewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_StartNewRaffleButton = CreateFrame("Frame", "BackdropFrames.GLR_StartNewRaffleButton", GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_StartNewRaffleButton:SetAllPoints()
	BackdropFrames.GLR_StartNewRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_StartNewRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_StartNewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ConfirmRaffleItemOneButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmRaffleItemOneButton", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmRaffleItemOneButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmRaffleItemOneButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmRaffleItemOneButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmRaffleItemOneButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ConfirmRaffleItemTwoButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmRaffleItemTwoButton", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmRaffleItemTwoButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmRaffleItemTwoButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmRaffleItemTwoButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmRaffleItemTwoButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ConfirmRaffleItemThreeButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmRaffleItemThreeButton", GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmRaffleItemThreeButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmRaffleItemThreeButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmRaffleItemThreeButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmRaffleItemThreeButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_AbortRollProcessButton = CreateFrame("Frame", "BackdropFrames.GLR_AbortRollProcessButton", GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton, "BackdropTemplate")
	BackdropFrames.GLR_AbortRollProcessButton:SetAllPoints()
	BackdropFrames.GLR_AbortRollProcessButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_AbortRollProcessButton:ApplyBackdrop()
	BackdropFrames.GLR_AbortRollProcessButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ConfirmAbortRollProcessButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmAbortRollProcessButton", GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmAbortRollProcessButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmAbortRollProcessButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmAbortRollProcessButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmAbortRollProcessButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ScanMailButton = CreateFrame("Frame", "BackdropFrames.GLR_ScanMailButton", GLR_UI.GLR_ScanMailButton, "BackdropTemplate")
	BackdropFrames.GLR_ScanMailButton:SetAllPoints()
	BackdropFrames.GLR_ScanMailButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ScanMailButton:ApplyBackdrop()
	BackdropFrames.GLR_ScanMailButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_DonationButton = CreateFrame("Frame", "BackdropFrames.GLR_DonationButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton, "BackdropTemplate")
	BackdropFrames.GLR_DonationButton:SetAllPoints()
	BackdropFrames.GLR_DonationButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_DonationButton:ApplyBackdrop()
	BackdropFrames.GLR_DonationButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))

	BackdropFrames.GLR_ConfirmDonationButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmDonationButton", GLR_UI.GLR_DonationFrame.GLR_ConfirmDonationButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmDonationButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmDonationButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmDonationButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmDonationButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))







---------------------------
--------- SCRIPTS ---------
---------------------------

--Lottery Frame
GLR_UI.GLR_MainFrame.GLR_LotteryFrame:SetScript("OnHide", function(self)
	GLR_UI.GLR_NewLotteryEventFrame:Hide()
	GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()
	GLR_UI.GLR_DonationFrame:Hide()
	if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] or GLR_Global_Variables[3] then
		GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	end
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
end)

--Raffle Frame
GLR_UI.GLR_MainFrame.GLR_RaffleFrame:SetScript("OnHide", function(self)
	GLR_UI.GLR_NewRaffleEventFrame:Hide()
	GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:Hide()
	if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] or GLR_Global_Variables[3] then
		GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	end
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame:SetScript("OnShow", function(self)
	if GLR_Global_Variables[6][1] or GLR_Global_Variables[6][2] then
		if not GLR_Global_Variables[3] then
			GLR_GoToAddRafflePrizes:Hide()
			GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Show()
		else
			if GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:IsVisible() then
				GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
			end
			GLR_GoToAddRafflePrizes:Show()
		end
	else
		GLR_GoToAddRafflePrizes:Show()
	end
end)

--New Lottery Frame Scripts
GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnShow", function(self)
	if not GLR_Global_Variables[6][1] then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetFocus()
		local gold = glrCharacter.Data.Settings.Profile.Lottery.StartingGold
		local tickets = glrCharacter.Data.Settings.Profile.Lottery.MaxTickets
		local price = glrCharacter.Data.Settings.Profile.Lottery.TicketPrice
		local second = tonumber(glrCharacter.Data.Settings.Profile.Lottery.SecondPlace)
		local guild = tonumber(glrCharacter.Data.Settings.Profile.Lottery.GuildCut)
		local guarantee = glrCharacter.Data.Settings.Profile.Lottery.Guaranteed
		if gold ~= nil and gold ~= "0" then
			if string.find(gold, "%.") == nil then
				gold = gold .. ".0000"
			end
			if string.sub(gold, string.find(gold, "%.") + 1, string.find(gold, "%.") + 1) == "" then
				gold = gold .. "0000"
			end
			if string.sub(gold, string.find(gold, "%.") + 2, string.find(gold, "%.") + 2) == "" then
				gold = gold .. "000"
			end
			if string.sub(gold, string.find(gold, "%.") + 3, string.find(gold, "%.") + 3) == "" then
				gold = gold .. "00"
			end
			if string.sub(gold, string.find(gold, "%.") + 4, string.find(gold, "%.") + 4) == "" then
				gold = gold .. "0"
			end
			local silver = string.sub(gold, string.find(gold, "%.") + 1, string.find(gold, "%.") + 2)
			local copper = string.sub(gold, string.find(gold, "%.") + 3, string.find(gold, "%.") + 4)
			gold = string.sub(gold, 1, string.find(gold, "%.") - 1)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText(gold)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText(silver)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText(copper)
		end
		if tickets ~= "0" then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetText(tickets)
		end
		if price ~= nil and price ~= "0" then
			if string.find(price, "%.") == nil then
				price = price .. ".0000"
			end
			if string.sub(price, string.find(price, "%.") + 1, string.find(price, "%.") + 1) == "" then
				price = price .. "0000"
			end
			if string.sub(price, string.find(price, "%.") + 2, string.find(price, "%.") + 2) == "" then
				price = price .. "000"
			end
			if string.sub(price, string.find(price, "%.") + 3, string.find(price, "%.") + 3) == "" then
				price = price .. "00"
			end
			if string.sub(price, string.find(price, "%.") + 4, string.find(price, "%.") + 4) == "" then
				price = price .. "0"
			end
			local silver = string.sub(price, string.find(price, "%.") + 1, string.find(price, "%.") + 2)
			local copper = string.sub(price, string.find(price, "%.") + 3, string.find(price, "%.") + 4)
			price = string.sub(price, 1, string.find(price, "%.") - 1)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText(price)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText(silver)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText(copper)
		end
		if second == nil then second = "0" end
		if second ~= "0" then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetText(second)
		end
		if guild == nil then guild = "0" end
		if guild ~= "0" then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetText(guild)
		end
		if guarantee then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetChecked(true)
		else
			GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetChecked(false)
		end
	else
		self:Hide()
	end
end)

--New Raffle Frame Script
GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnShow", function(self)
	if not GLR_Global_Variables[6][2] then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetFocus()
		local tickets = glrCharacter.Data.Settings.Profile.Raffle.MaxTickets
		local price = glrCharacter.Data.Settings.Profile.Raffle.TicketPrice
		local allow = glrCharacter.Data.Settings.Profile.Raffle.InvalidItems
		if tickets ~= nil and tickets ~= "0" then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetText(tickets)
		end
		if price ~= nil and price ~= "0" then
			if string.find(price, "%.") == nil then
				price = price .. ".0000"
			end
			if string.sub(price, string.find(price, "%.") + 1, string.find(price, "%.") + 1) == "" then
				price = price .. "0000"
			end
			if string.sub(price, string.find(price, "%.") + 2, string.find(price, "%.") + 2) == "" then
				price = price .. "000"
			end
			if string.sub(price, string.find(price, "%.") + 3, string.find(price, "%.") + 3) == "" then
				price = price .. "00"
			end
			if string.sub(price, string.find(price, "%.") + 4, string.find(price, "%.") + 4) == "" then
				price = price .. "0"
			end
			local silver = string.sub(price, string.find(price, "%.") + 1, string.find(price, "%.") + 2)
			local copper = string.sub(price, string.find(price, "%.") + 3, string.find(price, "%.") + 4)
			price = string.sub(price, 1, string.find(price, "%.") - 1)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText(price)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:SetText(silver)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:SetText(copper)
		end
		if allow then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetChecked(true)
		else
			GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetChecked(false)
		end
	else
		self:Hide()
	end
end)

--Add Player To Lottery Frame Script
GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnShow", function(self)
	if GLR_UI.GLR_ViewPlayerTicketInfoFrame:IsVisible() then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
	if not GLR_Global_Variables[6][1] then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetFocus()
	else
		self:Hide()
	end
end)
GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnHide", function(self)
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetTextColor(1, 1, 1, 1)
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText("")
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetText("")
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetText("")
	GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()
end)

--Add Player To Raffle Frame Script
GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnShow", function(self)
	if GLR_UI.GLR_ViewPlayerTicketInfoFrame:IsVisible() then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
	if not GLR_Global_Variables[6][2] then
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetFocus()
	else
		self:Hide()
	end
end)
GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnHide", function(self)
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetTextColor(1, 1, 1, 1)
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText("")
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetText("")
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetText("")
	GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()
end)

--Edit Player in Lottery Frame Script
GLR_UI.GLR_EditPlayerInLotteryFrame:SetScript("OnHide", function(self)
	if GLR_UI.GLR_ViewPlayerTicketInfoFrame:IsVisible() then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
	if not GLR_Global_Variables[6][1] then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetText("")
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetText("")
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetText("")
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText("")
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	else
		self:Hide()
	end
end)

--Edit Player in Raffle Frame Script
GLR_UI.GLR_EditPlayerInRaffleFrame:SetScript("OnHide", function(self)
	if GLR_UI.GLR_ViewPlayerTicketInfoFrame:IsVisible() then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
	if not GLR_Global_Variables[6][2] then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetText("")
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetText("")
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetText("")
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText("")
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
	else
		self:Hide()
	end
end)

--Donation Frame Script
GLR_UI.GLR_DonationFrame:SetScript("OnShow", function(self)
	if GLR_UI.GLR_ViewPlayerTicketInfoFrame:IsVisible() then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
	if not GLR_Global_Variables[6][1] then
		GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetFocus()
	else
		self:Hide()
	end
end)
GLR_UI.GLR_DonationFrame:SetScript("OnHide", function(_, key)
	local gold = GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:GetText()
	if gold ~= nil or gold ~= "" then 
		gold = tonumber(gold)
		if gold == nil then --Only want to clear the entered text if tonumber() returns nil as it does so with letters and not numbers
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:SetText("")
			GLR_UI.GLR_DonationFrame.GLR_DonationGoldEditBox:ClearFocus()
		end
	end
end)

--Confirm Start of Lottery Border Frame Script
GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()
	end
end)

--Confirm Start of Raffle Border Frame Script
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:Hide()
	end
end)

--Confirm Abort Lottery/Raffle Roll Process Border Frame Script
GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
	end
end)

--View Player Ticket Info Frame Script
GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetScript("OnKeyDown", function(_, key)
	GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:SetPropagateKeyboardInput(false)
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
	end
end)

--Abort Roll Process Button Script
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetScript("OnShow", function(self)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Hide()
end)
GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:SetScript("OnHide", function(self)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Show()
end)

--InboxFrame Script
--Disables the Scan Mail button to prevent its use on characters not in a guild (can't use the mod when not in a guild anyway, need to disable the button then)
--Taking it a bit further and only enabling it while a Lottery or Raffle event is active on that character.
InboxFrame:HookScript("OnShow", function(self)
	local guildName, _, _, server = GetGuildInfo("PLAYER")
	local lottery = glrCharacter.Data.Settings.CurrentlyActiveLottery
	local raffle = glrCharacter.Data.Settings.CurrentlyActiveRaffle
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if guildName == nil then
		GLR_UI.GLR_ScanMailButton:Disable()
	elseif guildName ~= nil then
		if GLR_Global_Variables[1] then
			if lottery or raffle then
				GLR_UI.GLR_ScanMailButton:Enable()
			elseif not lottery and not raffle then
				GLR_UI.GLR_ScanMailButton:Disable()
			end
		end
	end
	if status then
		if glrMultiGuildRoster[1] == nil then
			GLR_U:PopulateMultiGuildTable()
		end
	else
		if glrRoster[1] == nil then
			GLR_U:UpdateRosterTable()
		end
	end
end)

---------------------------
------- END SCRIPTS -------
---------------------------

---------------------------
------ MINIMAP ICON -------
---------------------------

GLR_UI.GLR_MinimapButton = CreateFrame("Button", "GLR_MinimapButton", Minimap)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonIcon = GLR_UI.GLR_MinimapButton:CreateTexture("GLR_MinimapButtonIcon", "BORDER")
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonBorder = GLR_UI.GLR_MinimapButton:CreateTexture("GLR_MinimapButtonBorder", "OVERLAY")

GLR_UI.GLR_MinimapButton:EnableMouse(true)
GLR_UI.GLR_MinimapButton:SetMovable(false)
GLR_UI.GLR_MinimapButton:SetFrameStrata("HIGH")
GLR_UI.GLR_MinimapButton:SetWidth(33)
GLR_UI.GLR_MinimapButton:SetHeight(33)
GLR_UI.GLR_MinimapButton:RegisterForDrag("LeftButton")
GLR_UI.GLR_MinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonDown")
GLR_UI.GLR_MinimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonIcon:SetWidth(20)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonIcon:SetHeight(20)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonIcon:SetPoint("CENTER", GLR_UI.GLR_MinimapButton)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonIcon:SetTexture("Interface\\ICONS\\INV_Misc_Coin_01")
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonBorder:SetWidth(52)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonBorder:SetHeight(52)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonBorder:SetPoint("TOPLEFT", GLR_UI.GLR_MinimapButton)
GLR_UI.GLR_MinimapButton.GLR_MinimapButtonBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
GLR_UI.GLR_MinimapButton:SetPoint("CENTER", Minimap, "CENTER", 0, 0)

GLR_UI.GLR_MinimapButton:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Left Click"] .. "|r - " .. L["Minimap Button Left Click Info"])
	GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Ctrl Left Click"] .. "|r - " .. L["Minimap Button Ctrl Left Click Info"])
	GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Right Click"] .. "|r - " .. L["Minimap Button Right Click Info"])
	GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Hold Left"] .. "|r - " .. L["Minimap Button Hold Left Info"])
	GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Shft Hold Left Click"] .. "|r - " .. L["Minimap Button Shft Hold Left Click Info"])
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		local msg, _ = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(L["Minimap Button Event Info"], "%%event", glrCharacter.Event.Lottery.Date), "%%amount", glrCharacter.Event.Lottery.TicketsSold), "%%free", glrCharacter.Event.Lottery.GiveAwayTickets), "%%c", "|cfffff7af"), "%%r", "|r")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Lottery Info"] .. "|r - " .. glrCharacter.Event.Lottery.EventName)
		GameTooltip:AddLine(msg)
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		local msg, _ = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(L["Minimap Button Event Info"], "%%event", glrCharacter.Event.Raffle.Date), "%%amount", glrCharacter.Event.Raffle.TicketsSold), "%%free", glrCharacter.Event.Raffle.GiveAwayTickets), "%%c", "|cfffff7af"), "%%r", "|r")
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cfffff7af" .. L["Minimap Button Raffle Info"] .. "|r - " .. glrCharacter.Event.Raffle.EventName)
		GameTooltip:AddLine(msg)
	end
	if GLR_UI.GLR_MinimapButton.isMoving == nil then GLR_UI.GLR_MinimapButton.isMoving = false end
	if not GLR_UI.GLR_MinimapButton.isMoving then
		GameTooltip:Show()
	end
end)
GLR_UI.GLR_MinimapButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
GLR_UI.GLR_MinimapButton:SetScript("OnClick", function(self, button)
	GLR:MinimapIconFunction(button)
end)
local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}
local DebugData = false
local function UpdateButtonPosition(self)
	--https://wow.gamepedia.com/GetMinimapShape
	local mx, my = Minimap:GetCenter()
	local cx, cy = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	--Any variable beginning with the letter "d" aside from "diagRadius" is a variable used for tracking Debug Information
	local dxr, dyr = Minimap:GetSize() or 100, 0
	local dMinimapShape = "NA"
	local dx = "NA"
	local dy = "NA"
	local dDiagRadius = "NA"
	local dRadius = "NA"
	local dAngle = "NA"
	local dq = "NA"
	if self.dragMode then
		local x, y = cx / scale - mx, cy / scale - my
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		glrCharacter.Data.Settings.General.MinimapXOffset = x
		glrCharacter.Data.Settings.General.MinimapYOffset = y
	else
		local mxr, myr = Minimap:GetSize() or 100, 0
		dxr = mxr
		dyr = myr
		if glrCharacter.Data.Settings.General.MinimapEdge then
			--Allows the Icon to travel at the edge of the minimap, remove line to have Icon travel via center of Icon at edge of minimap
			mxr = mxr + GLR_UI.GLR_MinimapButton:GetSize()
		end
		--local radius = mxr / 210
		local radius = mxr * 0.5
		local cx, cy = cx / scale, cy / scale
		local angle = math.atan2(cy - my, cx - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		local cos = math.cos(angle)
		local sin = math.sin(angle)
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		dMinimapShape = minimapShape
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x = cos*radius
			y = sin*radius
		else
			local diagRadius = math.sqrt(2*(radius)^2)-10
			x = math.max(-radius, math.min(cos*diagRadius, radius))
			y = math.max(-radius, math.min(sin*diagRadius, radius))
			dDiagRadius = diagRadius
		end
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		glrCharacter.Data.Settings.General.MinimapXOffset = x
		glrCharacter.Data.Settings.General.MinimapYOffset = y
		--Don't need a insanely long string of numbers
		dx = string.format("%.4f", tostring(x))
		dy = string.format("%.4f", tostring(y))
		dRadius = radius
		dAngle = angle
		dq = tostring(quadTable[q])
	end
	--Logs certain Debug information I need to gather to diagnose the issue (only fires once every 5 seconds while the function is called)
	if not DebugData and GLR_AddOnMessageTable_Debug ~= nil then
		DebugData = true
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateButtonPosition() - Changing Minimap Coords: (" .. dx .. ", " .. dy .. ") - Map Shape: [" .. dMinimapShape .. "] Map Size: (" .. dxr .. ", " .. dyr .. ") Quad-Table: " .. dq .. " Angle: " .. dAngle .. " Scale: " .. tostring(scale) .. " Radius: " .. dRadius .. " DiagRadius: " .. dDiagRadius)
		C_Timer.After(5, function(self) DebugData = false end)
	end
end
GLR_UI.GLR_MinimapButton:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	if IsShiftKeyDown() then
		self.dragMode = true
	else
		self.dragMode = nil
	end
	GameTooltip:Hide()
	GLR_UI.GLR_MinimapButton:SetScript("OnUpdate", UpdateButtonPosition)
	GLR_UI.GLR_MinimapButton.isMoving = true
end)
GLR_UI.GLR_MinimapButton:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	GLR_UI.GLR_MinimapButton:SetScript("OnUpdate", nil)
	GLR_UI.GLR_MinimapButton.isMoving = false
end)
GLR_UI.GLR_MinimapButton:Show()

local function CheckAddOnStatus()
	if not GLR_Global_Variables[1] then
		C_Timer.After(1, CheckAddOnStatus)
	else
		GLR_U:UpdateBorderColor()
	end
end

CheckAddOnStatus()