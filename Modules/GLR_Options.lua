GLR_O = {}
GLR_O.PopupDialogs = {}

GLR_Debug_Give = false
local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")

GLR_GameExpansion = GetClientDisplayExpansionLevel() --Tells what version of WoW the player is running (ie: Classic or Retail. 0 for Classic, 7 and higher for Retail)
GLR_GameVersion = "RETAIL"

if GLR_GameExpansion < 7 then
	GLR_GameVersion = "RETAIL"
end

--Variables[7][5][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key] = value


local Variables = {
	{ 												-- [1] Various Numerica Values
		0,											--		[1]	View Player Lottery Tickets
		0,											--		[2]	View Player Raffle Tickets
		0,											--		[3] Number of Tickets a Player is Given (used when giving them)
	},												--
	{												-- [2] Class Colors (strings)
		["NA"] = "FF0000",							--		Error Catch
		["WARRIOR"] = "C79C6E",						--		Warrior
		["PALADIN"] = "F58CBA",						--		Paladin
		["HUNTER"] = "ABD473",						--		Hunter
		["ROGUE"] = "FFF569",						--		Rogue
		["PRIEST"] = "FFFFFF",						--		Priest
		["DEATHKNIGHT"] = "C41F3B",					--		Death Knight
		["SHAMAN"] = "0070DE",						--		Shaman
		["MAGE"] = "69CCF0",						--		Mage
		["WARLOCK"] = "9482C9",						--		Warlock
		["MONK"]  = "00FF96",						--		Monk
		["DRUID"]  = "FF7D0A",						--		Druid
		["DEMONHUNTER"]  = "A330C9",				--		Demon Hunter
	},												--
	{												-- [3] Giveaway Variables (certain ones for now)
		false,										--		[1] Initial GetValidEntries Check
		false,										--		[2] Giveaway is underway
		false,										--		[3] Confirm Giveaway
		false,										--		[4] Randomize Giveaway
		false,										--		[5] Randomize One Per Player Giveaway
		1,											--		[6] Select Event Key
		1,											--		[7] Select Type Key (Everyone/Rank)
		0,											--		[8] Select Online Type Key
		0,											--		[9] Max Possible Entries
		0,											--		[10] Randomize Cycles (# of times in function)
		0,											--		[11] Giveaway Progress (progress bar shown)
		0,											--		[12] Giveaway Total Progress (max progress possible)
		0,											--		[13] Number of Valid Entries
		"0",										--		[14] Giveaway Amount (string)
		1,											--		[15] Giveaway MultiGuild Key
		1,											--		[16] Select Faction Key
		"Alliance",									--		[17] Faction Result (of #16)
		"",											--		[18] Guild Name (Multi-Guild)
	},												--
	{												-- [4] Numeric Key Values
		0,											--		[1] Copy Lottery Profile
		0,											--		[2] Copy Raffle Profile
		0,											--		[3] Copy Lottery Message Profile
		0,											--		[4] Copy Raffle Message Profile
		0,											--		[5] Copy Both Message Profiles
		0,											--		[6] Select Lottery Transfer
		0,											--		[7] Select Raffle Transfer
		1,											--		[8] Show Format Key - Custom Messages
		1,											--		[9] Show Format Key - Custom Whispers
		1,											--		[10] Show Format Key - Preview Whisper
		0,											--		[11] Copy Lottery Whispers Profile
		0,											--		[12] Copy Raffle Whispers Profile
	},												--
	{												-- [5] General Confirmation Booleans (and boolean gates)
		false,										--		[1] Cancel Lottery
		false,										--		[2] Cancel Raffle
		false,										--		[3] Transfer Lottery
		false,										--		[4] Transfer Raffle
		false,										--		[5] Show Formats - Custom Messages
		false,										--		[6] MultiGuild Faction Check
		false,										--		[7] Show Formats - Custom Whispers
		false,										--		[8] Custom Whispers Get Variables gate
		false,										--		[9] Transfer Lottery Detected
		false,										--		[10] Transfer Raffle Detected
	},												--
	{												-- [6] Class Colors (numeric)
		[1] = "C79C6E",								-- 		[1] Warrior
		[2] = "F58CBA", 							-- 		[2] Paladin
		[3] = "ABD473",							 	--		[3] Hunter
		[4] = "FFF569", 							--		[4] Rogue
		[5] = "FFFFFF",							 	--		[5] Priest
		[6] = "C41F3B", 							--		[6] Death Knight
		[7] = "0070DE", 							--		[7] Shaman
		[8] = "69CCF0", 							--		[8] Mage
		[9] = "9482C9", 							--		[9] Warlock
		[10] = "00FF96",							--		[10] Monk
		[11] = "FF7D0A",							--		[11] Druid
		[12] = "A330C9"								--		[12] Demon Hunter
	},												--
	{												-- [7] Giveaway Tables
		{ ["Alliance"] = {}, ["Horde"] = {}, },		--		[1] Entry Table (checks if Entry is valid)
		{ ["Alliance"] = {}, ["Horde"] = {}, },		--		[2] Entry Check Table (used as save buffer when changing options)
		{ ["Alliance"] = {}, ["Horde"] = {}, },		--		[3] Guild Names
		{ ["Alliance"] = {}, ["Horde"] = {}, },		--		[4] Guild Ranks
		{ ["Alliance"] = {}, ["Horde"] = {}, },		--		[5] Select Guild Ranks
		{ [1] = "Alliance", [2] = "Horde" },		--		[6] Select Faction Table
		{ [1] = L["Lottery"], [2] = L["Raffle"] },	--		[7] Select Event Table
		{},											--		[8] Player Entry Table (used when checking a rank)
		{},											--		[9] Parse Entry Table (used as buffer when checking Entry Status)
		{},											--		[10] Final Entry Table (used when preforming the Giveaway)
	},												--
	{												-- [8] Various Tables
		{},											--		[1] Copy Lottery Profile Table
		{},											--		[2] Copy Lottery Message Profile Table
		{},											--		[3] Copy Raffle Profile Table
		{},											--		[4] Copy Raffle Message Profile Table
		{},											--		[5] Copy Both Events Message Profile Table
		{},											--		[6] Lottery Transfer Table
		{},											--		[7] Raffle Transfer Table
		{},											--		[8] Copy Lottery Whispers Profile Table
		{},											--		[9] Copy Raffle Whispers Profile Table
	},												--
	{												-- [9] Multi-Guild Variables.
		[1] = {										--
			[1] = 0,								--		[1] Linked Guilds. Numeric value is number of linked Guilds.
			[2] = true,								--		[2] Boolean tells whether to hide the Linked Guilds UI portion if Numeric value is zero.
			[3] = true,								--		[3] Boolean becomes false if number of potential Players is greater than zero.
		},											--
	},												--
	{												-- [10] Custom Whisper Variables
		[1] = {
			[1] = "%%version",
			[2] = "%%tickets_price",
			[3] = "%%tickets_max",
			[4] = "%%tickets_sold",
			[5] = "%%tickets_given",
			[6] = "%%tickets_total",
			[7] = "%%tickets_value",
			[8] = "%%event_name",
			[9] = "%%event_date",
			[10] = "%%reply_phrases",
			[11] = "%%mail_phrases",
			[12] = "%%reply_default",
			[13] = "%%mail_default",
			[14] = "%%tickets_current",
			[15] = "%%tickets_difference",
			[16] = "%%jackpot_total",
			[17] = "%%jackpot_guild",
			[18] = "%%jackpot_first",
			[19] = "%%jackpot_second",
			[20] = "%%jackpot_start",
			[21] = "%%percent_guild",
			[22] = "%%percent_second",
			[23] = "%%raffle_prizes",
			[24] = "%%raffle_first",
			[25] = "%%raffle_second",
			[26] = "%%raffle_third",
		},
		[2] = {
			["%%version"] = "%%version",
			["%%tickets_price"] = "%%tickets_price",
			["%%tickets_max"] = "%%tickets_max",
			["%%tickets_sold"] = "%%tickets_sold",
			["%%tickets_given"] = "%%tickets_given",
			["%%tickets_total"] = "%%tickets_total",
			["%%tickets_value"] = "%%tickets_value",
			["%%event_name"] = "%%event_name",
			["%%event_date"] = "%%event_date",
			["%%reply_phrases"] = "%%reply_phrases",
			["%%mail_phrases"] = "%%mail_phrases",
			["%%reply_default"] = "%%reply_default",
			["%%mail_default"] = "%%mail_default",
			["%%tickets_current"] = "%%tickets_current",
			["%%tickets_difference"] = "%%tickets_difference",
			["%%jackpot_total"] = "%%jackpot_total",
			["%%jackpot_guild"] = "%%jackpot_guild",
			["%%jackpot_first"] = "%%jackpot_first",
			["%%jackpot_second"] = "%%jackpot_second",
			["%%jackpot_start"] = "%%jackpot_start",
			["%%percent_guild"] = "%%percent_guild",
			["%%percent_second"] = "%%percent_second",
			["%%raffle_prizes"] = "%%raffle_prizes",
			["%%raffle_first"] = "%%raffle_first",
			["%%raffle_second"] = "%%raffle_second",
			["%%raffle_third"] = "%%raffle_third",
		},
		[3] = {
			["General"] = {
				["%%reply_phrases"] = true,
				["%%mail_phrases"] = true,
			},
			["Lottery"] = {
				["%%tickets_price"] = true,
				["%%tickets_max"] = true,
				["%%tickets_sold"] = true,
				["%%tickets_given"] = true,
				["%%tickets_total"] = true,
				["%%tickets_value"] = true,
				["%%event_name"] = true,
				["%%event_date"] = true,
				["%%tickets_current"] = true,
				["%%tickets_difference"] = true,
				["%%jackpot_total"] = true,
				["%%jackpot_guild"] = true,
				["%%jackpot_first"] = true,
				["%%jackpot_second"] = true,
				["%%jackpot_start"] = true,
				["%%percent_guild"] = true,
				["%%percent_second"] = true,
			},
			["Raffle"] = {
				["%%tickets_price"] = true,
				["%%tickets_max"] = true,
				["%%tickets_sold"] = true,
				["%%tickets_given"] = true,
				["%%tickets_total"] = true,
				["%%tickets_value"] = true,
				["%%event_name"] = true,
				["%%event_date"] = true,
				["%%tickets_current"] = true,
				["%%tickets_difference"] = true,
				["%%raffle_prizes"] = true,
				["%%raffle_first"] = true,
				["%%raffle_second"] = true,
				["%%raffle_third"] = true,
			},
		},
	}
}

local ClassColorStrings = {
	["NA"] = "FF0000",				-- Error Catch
	["WARRIOR"] = "C79C6E",			-- Warrior
	["PALADIN"] = "F58CBA",			-- Paladin
	["HUNTER"] = "ABD473",			-- Hunter
	["ROGUE"] = "FFF569",			-- Rogue
	["PRIEST"] = "FFFFFF",			-- Priest
	["DEATHKNIGHT"] = "C41F3B",		-- Death Knight
	["SHAMAN"] = "0070DE",			-- Shaman
	["MAGE"] = "69CCF0",			-- Mage
	["WARLOCK"] = "9482C9",			-- Warlock
	["MONK"]  = "00FF96",			-- Monk
	["DRUID"]  = "FF7D0A",			-- Druid
	["DEMONHUNTER"]  = "A330C9"		-- Demon Hunter
}

local chat = DEFAULT_CHAT_FRAME
local dialog = LibStub("AceConfigDialog-3.0")
local PlayerName = GetUnitName("PLAYER", false)
local _, _, classIndex = UnitClass("PLAYER")
local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
local GiveawayValuesTable = {
	[1] = L["GLR - UI > Config > Giveaway - Everyone"],
	[2] = L["GLR - UI > Config > Giveaway - By Rank"]
}
local GiveawayLastOnlineTable = {
	[0] = L["GLR - UI > Config > Giveaway - Everyone"],
	[1] = L["GLR - UI > Config > Giveaway - Currently Online"],
	[2] = L["GLR - UI > Config > Giveaway - 7 Days"],
	[3] = L["GLR - UI > Config > Giveaway - 14 Days"],
	[4] = L["GLR - UI > Config > Giveaway - 21 Days"],
	[5] = L["GLR - UI > Config > Giveaway - 28 Days"],
}

local GiveAwayText = L["GLR - UI > Config > Giveaway - Names Available"] .. ": " .. L["0"]
local GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. L["0"]
local PlayerInfo = glrHistory or {}
local CharacterInfo = glrCharacter or {}

GLR_DebugMaxEntries = 0
GLR_Debug_Table = {}

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
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 4,
		edgeSize = 13,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
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

local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
frame:SetSize(350, 75)
frame:SetPoint("CENTER", UIParent)
frame:SetFrameStrata("DIALOG")
frame:SetMovable(false)
frame:SetResizable(false)
frame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets,
})
frame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
frame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
frame:Hide()

local statusbar = CreateFrame("StatusBar", nil, frame)
statusbar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)
statusbar:SetWidth(200)
statusbar:SetHeight(19)
statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar:GetStatusBarTexture():SetHorizTile(false)
statusbar:GetStatusBarTexture():SetVertTile(false)
statusbar:SetStatusBarColor(0, 0, 1)
statusbar:SetMinMaxValues(0, Variables[3][12])
statusbar:SetValue(Variables[3][11])
local _, statMax = statusbar:GetMinMaxValues()

local statusbar_bg = statusbar:CreateTexture(nil, "OVERLAY")
statusbar_bg:SetTexture("Interface\\UNITPOWERBARALT\\WowUI_Horizontal_Frame")
statusbar_bg:SetPoint("CENTER", statusbar, 0, 1)
statusbar_bg:SetSize(275, 52)

local statusbar_barbg = statusbar:CreateTexture(nil, "BACKGROUND")
statusbar_barbg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar_barbg:SetAllPoints(statusbar)
statusbar_barbg:SetHeight(20)
statusbar_barbg:SetVertexColor(0, 0, 0)

local statusbar_value = statusbar:CreateFontString(nil, "OVERLAY")
statusbar_value:SetPoint("CENTER", statusbar)
statusbar_value:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
statusbar_value:SetJustifyH("LEFT")
statusbar_value:SetShadowOffset(1, -1)
statusbar_value:SetTextColor(0, 1, 0)
statusbar_value:SetText(statusbar:GetValue() .. "%")

local statusbar_text = statusbar:CreateFontString(nil, "OVERLAY")
statusbar_text:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -13)
statusbar_text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
statusbar_text:SetJustifyH("LEFT")
statusbar_text:SetShadowOffset(1, -1)
statusbar_text:SetTextColor(1, 1, 1)
statusbar_text:SetText("Giving Tickets to: ")

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

local function GetClassColor(name)
	
	local ClassColor = "NA"
	
	for f, v in pairs(glrHistory.GuildRoster) do
		local doBreak = false
		for g, e in pairs(glrHistory.GuildRoster[f]) do
			for i = 1, #glrHistory.GuildRoster[f][g] do
				local n = string.sub(glrHistory.GuildRoster[f][g][i], 1, string.find(glrHistory.GuildRoster[f][g][i], "%[") - 1)
				if name == n then
					local targetClass = string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%[") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%]") - 1)
					ClassColor = Variables[2][targetClass]
					doBreak = true
					break
				end
			end
			if doBreak then break end
		end
		if doBreak then break end
	end
	
	return ClassColor
	
end

--Returns the time formatted into either 19:30 or 7:30 PM.
--The value "text" should be the default time format sent through. IE: text = "19:30"
local function GetTimeFormat(text)
	if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
		local h = tonumber(string.sub(text, 1, string.find(text, "%:") - 1))
		local m = tonumber(string.sub(text, string.find(text, "%:") + 1))
		if h == 0 and m == 0 then
			text = "12:00 AM"
		else
			if m == 0 then
				m = "00"
			else
				m = tostring(m)
			end
			if h == 0 then
				text = "12:" .. tostring(m) .. " AM"
			else
				if h <= 11 then
					text = tostring(h) .. ":" .. m .. " AM"
				else
					h = h - 12
					text = tostring(h) .. ":" .. m .. " PM"
				end
			end
		end
	end
	return text
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

local function GetMultiGuildList(extra)
	local cross = glrCharacter.Data.Settings.General.CrossFactionEvents
	local faction, _ = UnitFactionGroup("PLAYER")
	local guild, _, _, _ = GetGuildInfo("PLAYER")
	if extra == nil then extra = false end
	local t = {}
	for f, tf in pairs(glrHistory.GuildStatus) do
		local continue = true
		if not cross and tostring(f) ~= faction then continue = false end
		if continue then
			local c = 1
			for g, tg in pairs(glrHistory.GuildStatus[f]) do
				continue = false
				if glrCharacter.Data.Settings.General.MultiGuild then
					if glrHistory.GuildStatus[f][g] then
						continue = true
					end
				elseif g == guild then
					continue = true
				end
				if continue then
					if Variables[7][3][f] == nil then Variables[7][3][f] = {} end
					for i = 1, #Variables[7][3][f] do
						if Variables[7][3][f][i] == g then
							continue = false
							break
						end
					end
					if continue then
						Variables[7][3][f][c] = g
						c = c + 1
					end
				end
			end
		end
	end
	sort(Variables[7][3])
	t = Variables[7][3]
	if not GLR_ReleaseState then
		if glrHistory.BulkDebug[FullPlayerName].GetMultiGuildList == nil then
			glrHistory.BulkDebug[FullPlayerName].GetMultiGuildList = {}
		end
		glrHistory.BulkDebug[FullPlayerName].GetMultiGuildList = t
	end
	if extra then
		local doBreak = false
		for f, tf in pairs(glrHistory.GuildRanks) do
			if t[f] ~= nil and t[f][1] ~= nil then
				for g = 1, #t[f] do-- c = 0
					local use = t[f][g]
					if use == nil then doBreak = true break end
					if glrHistory.GuildRanks[f][use] ~= nil then
						for i = 1, #glrHistory.GuildRanks[f][use] do
							local c = 0
							if Variables[7][4][f] == nil then Variables[7][4][f] = {} end
							if Variables[7][4][f][use] == nil then
								Variables[7][4][f][use] = {}
								Variables[7][1][f][use] = {}
								Variables[7][2][f][use] = {}
							end
							if Variables[7][4][f][use][i] == nil then
								Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]] = { ["Count"] = 0, ["State"] = false, ["Names"] = {}, }
								Variables[7][2][f][use][glrHistory.GuildRanks[f][use][i]] = { ["State"] = false, ["Check"] = false, ["Entered"] = false, }
								for n = 1, #glrHistory.GuildRoster[f][use] do
									local player_rank = string.sub(glrHistory.GuildRoster[f][use][n], string.find(glrHistory.GuildRoster[f][use][n], "%|") + 1, string.find(glrHistory.GuildRoster[f][use][n], "%}") - 1)
									if player_rank == glrHistory.GuildRanks[f][use][i] then
										table.insert(Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]].Names, glrHistory.GuildRoster[f][use][n])
										c = c + 1
									end
								end
								Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]].Count = c
								Variables[7][4][f][use][i] = glrHistory.GuildRanks[f][use][i]
								if Variables[7][5][f] == nil then Variables[7][5][f] = {} end
								if Variables[7][5][f][use] == nil then
									Variables[7][5][f][use] = {}
								end
								Variables[7][5][f][use][i] = false
							end
						end
					end
				end
			end
			if doBreak then break end
		end
	end
	
	return t
end

local function GetMultiGuildTables()
	local name = GetMultiGuildList(false)
	local doBreak = false
	for f, tf in pairs(glrHistory.GuildRanks) do
		if name[f] ~= nil and name[f][1] ~= nil then
			for g = 1, #name[f] do-- c = 0
				local use = name[f][g]
				if use == nil then doBreak = true break end
				if glrHistory.GuildRanks[f][use] ~= nil then
					for i = 1, #glrHistory.GuildRanks[f][use] do
						local c = 0
						if Variables[7][4][f] == nil then Variables[7][4][f] = {} end
						if Variables[7][4][f][use] == nil then
							Variables[7][4][f][use] = {}
							Variables[7][1][f][use] = {}
							Variables[7][2][f][use] = {}
						end
						if Variables[7][4][f][use][i] == nil then
							Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]] = { ["Count"] = 0, ["State"] = false, ["Names"] = {}, }
							Variables[7][2][f][use][glrHistory.GuildRanks[f][use][i]] = { ["State"] = false, ["Check"] = false, ["Entered"] = false, }
							for n = 1, #glrHistory.GuildRoster[f][use] do
								local player_rank = string.sub(glrHistory.GuildRoster[f][use][n], string.find(glrHistory.GuildRoster[f][use][n], "%|") + 1, string.find(glrHistory.GuildRoster[f][use][n], "%}") - 1)
								if player_rank == glrHistory.GuildRanks[f][use][i] then
									table.insert(Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]].Names, glrHistory.GuildRoster[f][use][n])
									c = c + 1
								end
							end
							Variables[7][1][f][use][glrHistory.GuildRanks[f][use][i]].Count = c
							Variables[7][4][f][use][i] = glrHistory.GuildRanks[f][use][i]
							if Variables[7][5][f] == nil then Variables[7][5][f] = {} end
							if Variables[7][5][f][use] == nil then
								Variables[7][5][f][use] = {}
							end
							Variables[7][5][f][use][i] = false
						end
					end
				end
			end
		end
		if doBreak then break end
	end
end

local function PreformGiveTickets(PlayerName, state, MaxTicket, dateTime, guaranteedWinner, PlayerTickets)
	
	local user = PlayerName
	if string.find(user, "%-") ~= nil then
		user = string.sub(user, 1, string.find(user, "%-") - 1)
	end
	statusbar_text:SetText("Giving Tickets to: " .. user)
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	
	if glrCharacter[state] == nil then
		glrCharacter[state] = {}
	end
	if glrCharacter[state].Entries == nil then
		glrCharacter[state].Entries = {}
	end
	if glrCharacter[state].Entries.TicketRange == nil then
		glrCharacter[state].Entries.TicketRange = {}
	end
	if glrCharacter[state].Entries.TicketRange[PlayerName] == nil then
		glrCharacter[state].Entries.TicketRange[PlayerName] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
	end
	
	if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
		
		if glrTemp[state][PlayerName] == nil then
			glrTemp[state][PlayerName] = {}
		end
		if glrTemp[state][PlayerName].TicketNumbers == nil then
			glrTemp[state][PlayerName].TicketNumbers = {}
		end
		if glrCharacter[state].Entries.TicketNumbers[PlayerName] ~= nil then
			glrTemp[state][PlayerName] = glrCharacter[state].Entries.TicketNumbers[PlayerName]
			glrTemp[state][PlayerName].NumberOfTickets = glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets
			glrTemp[state][PlayerName].TicketNumbers = glrCharacter[state].Entries.TicketNumbers[PlayerName]
		end
		if glrTemp[state][PlayerName].NumberOfTickets == nil then
			glrTemp[state][PlayerName].NumberOfTickets = 0
		end
		if glrTemp[state][PlayerName].TicketRange == nil then
			glrTemp[state][PlayerName].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
		end
		
		local FirstTicketNumberBought = true
		local LastTicketNumberBought = true
		
		if glrCharacter[state].Entries.Tickets[PlayerName] == nil then
			
			glrCharacter[state].Entries.Tickets[PlayerName] = {}
			glrCharacter[state].Entries.Tickets[PlayerName].Sold = 0
			glrCharacter[state].Entries.Tickets[PlayerName].Given = PlayerTickets
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = 0
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = PlayerTickets
			glrTemp[state][PlayerName].NumberOfTickets = PlayerTickets
			
			table.insert(glrCharacter[state].Entries.Names, PlayerName)
			
			if glrCharacter[state].Entries.TicketNumbers[PlayerName] == nil then
				
				local TicketNumber = glrCharacter.Event[state].LastTicketBought
				
				glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
				
				if glrCharacter[state].TicketPool[1] ~= nil then
					
					for i = 1, PlayerTickets do
						Variables[1][3] = Variables[1][3] + 1
						if glrCharacter[state].TicketPool[1] ~= nil then
							
							table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], glrCharacter[state].TicketPool[1])
							table.insert(glrTemp[state][PlayerName].TicketNumbers, glrCharacter[state].TicketPool[1])
							if FirstTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].LowestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
								glrTemp[state][PlayerName].TicketRange.LowestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
								FirstTicketNumberBought = false
							end
							if PlayerTickets == i and LastTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
								glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
								LastTicketNumberBought = false
							end
							table.remove(glrCharacter[state].TicketPool, 1)
							
						else
							
							if TicketNumber == 1000 or TicketNumber == 2000 or TicketNumber == 3000 or TicketNumber == 4000 or TicketNumber == 5000 or TicketNumber == 6000 or TicketNumber == 7000 or TicketNumber == 8000 or TicketNumber == 9000 then
								local TicketString = tostring(TicketNumber)
								table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], TicketString)
								table.insert(glrTemp[state][PlayerName].TicketNumbers, TicketString)
								if FirstTicketNumberBought then
									glrCharacter[state].Entries.TicketRange[PlayerName].LowestTicketNumber = TicketNumber
									glrTemp[state][PlayerName].TicketRange.LowestTicketNumber = TicketNumber
									FirstTicketNumberBought = false
								end
								if PlayerTickets == i and LastTicketNumberBought then
									glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = TicketNumber
									glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = TicketNumber
									LastTicketNumberBought = false
								end
								if guaranteedWinner then
									TicketNumber = TicketNumber + 1
								else
									TicketNumber = TicketNumber + 2
								end
								glrCharacter.Event[state].LastTicketBought = TicketNumber
							else
								local TicketString = tostring(TicketNumber)
								table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], TicketString)
								table.insert(glrTemp[state][PlayerName].TicketNumbers, TicketString)
								if FirstTicketNumberBought then
									glrCharacter[state].Entries.TicketRange[PlayerName].LowestTicketNumber = TicketNumber
									glrTemp[state][PlayerName].TicketRange.LowestTicketNumber = TicketNumber
									FirstTicketNumberBought = false
								end
								if PlayerTickets == i and LastTicketNumberBought then
									glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = TicketNumber
									glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = TicketNumber
									LastTicketNumberBought = false
								end
								if guaranteedWinner then
									glrCharacter.Event[state].LastTicketBought = TicketNumber + 1
									TicketNumber = TicketNumber + 1
								else
									glrCharacter.Event[state].LastTicketBought = TicketNumber + 2
									TicketNumber = TicketNumber + 2
								end
							end
							
						end
						
					end
					
					if glrCharacter[state].TicketPool[1] ~= nil then
						sort(glrCharacter[state].TicketPool)
					end
					
				else
					
					for i = 1, PlayerTickets do
						Variables[1][3] = Variables[1][3] + 1
						if TicketNumber == 1000 or TicketNumber == 2000 or TicketNumber == 3000 or TicketNumber == 4000 or TicketNumber == 5000 or TicketNumber == 6000 or TicketNumber == 7000 or TicketNumber == 8000 or TicketNumber == 9000 then
							local TicketString = tostring(TicketNumber)
							table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], TicketString)
							table.insert(glrTemp[state][PlayerName].TicketNumbers, TicketString)
							if FirstTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].LowestTicketNumber = TicketNumber
								glrTemp[state][PlayerName].TicketRange.LowestTicketNumber = TicketNumber
								FirstTicketNumberBought = false
							end
							if PlayerTickets == i and LastTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = TicketNumber
								glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = TicketNumber
								LastTicketNumberBought = false
							end
							if guaranteedWinner then
								TicketNumber = TicketNumber + 1
							else
								TicketNumber = TicketNumber + 2
							end
							glrCharacter.Event[state].LastTicketBought = TicketNumber
						else
							local TicketString = tostring(TicketNumber)
							table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], TicketString)
							table.insert(glrTemp[state][PlayerName].TicketNumbers, TicketString)
							if FirstTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].LowestTicketNumber = TicketNumber
								glrTemp[state][PlayerName].TicketRange.LowestTicketNumber = TicketNumber
								FirstTicketNumberBought = false
							end
							if PlayerTickets == i and LastTicketNumberBought then
								glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = TicketNumber
								glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = TicketNumber
								LastTicketNumberBought = false
							end
							if guaranteedWinner then
								glrCharacter.Event[state].LastTicketBought = TicketNumber + 1
								TicketNumber = TicketNumber + 1
							else
								glrCharacter.Event[state].LastTicketBought = TicketNumber + 2
								TicketNumber = TicketNumber + 2
							end
						end
						
					end
					
				end
				
				if glrCharacter[state].MessageStatus == nil then
					glrCharacter[state].MessageStatus = {}
				end
				if glrCharacter[state].MessageStatus[PlayerName] == nil then
					glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
				end
				
			end
			
		else
			
			local currentTickets = glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets
			local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
			local ticketChange = PlayerTickets + currentTickets
			local TicketNumber = glrCharacter.Event[state].LastTicketBought
			local holdTickets = {}
			
			if ticketChange > MaxTicket then
				ticketChange = MaxTicket
			end
			
			local ticketIncrease = ticketChange - currentTickets
			
			for i = 1, #glrTemp[state][PlayerName].TicketNumbers do
				
				local v = glrTemp[state][PlayerName].TicketNumbers[i]
				table.insert(holdTickets, v)
				
			end
			
			glrCharacter[state].Entries.TicketNumbers[PlayerName] = nil
			glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
			
			for i = 1, currentTickets do
				
				table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], holdTickets[1])
				table.remove(holdTickets, 1)
				
			end
			
			for i = 1, ticketIncrease do
				Variables[1][3] = Variables[1][3] + 1
				if glrCharacter[state].TicketPool[1] ~= nil then
					
					table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], glrCharacter[state].TicketPool[1])
					table.insert(glrTemp[state][PlayerName], glrCharacter[state].TicketPool[1])
					if ticketIncrease == i and LastTicketNumberBought then
						glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
						LastTicketNumberBought = false
					end
					table.remove(glrCharacter[state].TicketPool, 1)
					
				else
					
					local ts = tostring(TicketNumber)
					table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], ts)
					table.insert(glrTemp[state][PlayerName], ts)
					if ticketIncrease == i and LastTicketNumberBought then
						glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = TicketNumber
						LastTicketNumberBought = false
					end
					if guaranteedWinner then
						glrCharacter.Event[state].LastTicketBought = TicketNumber + 1
						TicketNumber = TicketNumber + 1
					else
						glrCharacter.Event[state].LastTicketBought = TicketNumber + 2
						TicketNumber = TicketNumber + 2
					end
					
				end
				
			end
			
			sort(glrCharacter[state].TicketPool)
			sort(glrCharacter[state].Entries.TicketNumbers[PlayerName])
			
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = ticketChange
			glrCharacter[state].Entries.Tickets[PlayerName].Given = ticketChange
			glrTemp[state][PlayerName].NumberOfTickets = ticketChange
			
			if glrCharacter[state].MessageStatus[PlayerName] == nil then
				
				if glrCharacter[state].MessageStatus == nil then
					glrCharacter[state].MessageStatus = {}
				end
				if glrCharacter[state].MessageStatus[PlayerName] == nil then
					glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
				end
				
			end
			
		end
		
	else
		
		if glrCharacter[state].Entries.Tickets[PlayerName] == nil then
			
			glrCharacter[state].Entries.Tickets[PlayerName] = {}
			glrCharacter[state].Entries.Tickets[PlayerName].Sold = 0
			glrCharacter[state].Entries.Tickets[PlayerName].Given = PlayerTickets
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = 0
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = PlayerTickets
			
			table.insert(glrCharacter[state].Entries.Names, PlayerName)
			
			glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
			
			if state == "Lottery" then
				if guaranteedWinner then
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
				else
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( PlayerTickets * 2 )
				end
			else
				glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
			end
			
			if glrCharacter[state].MessageStatus == nil then
				glrCharacter[state].MessageStatus = {}
			end
			
			if glrCharacter[state].MessageStatus[PlayerName] == nil then
				glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
			else
				glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = glrCharacter[state].MessageStatus[PlayerName].sentMessage, ["lastAlert"] = dateTime }
			end
			
			Variables[1][3] = Variables[1][3] + PlayerTickets
			
		else
			
			local currentTickets = glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets
			local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
			local ticketChange = PlayerTickets + currentTickets
			local TicketNumber = glrCharacter.Event[state].LastTicketBought
			
			if ticketChange > MaxTicket then
				ticketChange = MaxTicket
			end
			
			PlayerTickets = ticketChange - currentTickets
			
			if state == "Lottery" then
				if guaranteedWinner then
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
				else
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( PlayerTickets * 2 )
				end
			else
				glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
			end
			
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets + PlayerTickets
			glrCharacter[state].Entries.Tickets[PlayerName].Given = glrCharacter[state].Entries.Tickets[PlayerName].Given + PlayerTickets
			
			if glrCharacter[state].MessageStatus == nil then
				glrCharacter[state].MessageStatus = {}
			end
			
			if glrCharacter[state].MessageStatus[PlayerName] == nil then
				glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
			else
				glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = glrCharacter[state].MessageStatus[PlayerName].sentMessage, ["lastAlert"] = dateTime }
			end
			
			Variables[1][3] = Variables[1][3] + PlayerTickets
			
		end
		
	end
	
	Variables[3][11] = Variables[3][11] + 1
	
	statusbar:SetValue(Variables[3][11])
	local statVal = floor(statusbar:GetValue() / statMax * 100)
	statusbar_value:SetText(statVal .. "%")
	
	if Variables[3][11] == Variables[3][12] then
		C_Timer.After(1, function(self) statusbar_value:SetText("Finalizing...") end)
		C_Timer.After(1.5, function(self) statusbar_value:SetText("Finalizing.") end)
		C_Timer.After(2, function(self) statusbar_value:SetText("Finalizing..") end)
		C_Timer.After(2.5, function(self) statusbar_value:SetText("Finalizing...") end)
		C_Timer.After(3, function(self) statusbar_value:SetText("Finalizing.") end)
		C_Timer.After(3.5, function(self) statusbar_value:SetText("Finalizing..") end)
		C_Timer.After(4, function(self) statusbar_value:SetText("Finalizing...") GLR_U:UpdateInfo() end)
		C_Timer.After(5, function(self) statusbar_value:SetText("Finished.") end)
		if glrCharacter.Event[state].GiveAwayTickets == nil then
			glrCharacter.Event[state].GiveAwayTickets = Variables[1][3]
		else
			glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + Variables[1][3]
		end
		C_Timer.After(7.5, function(self) frame:Hide() end)
	end
	
end

local function ResetGiveAwayTable(full)
	if GLR_Global_Variables[6][1] or GLR_Global_Variables[6][2] then return end
	if not Variables[3][2] then
		if full then
			Variables[3][7] = 1
			Variables[3][8] = 0
			Variables[3][13] = 0
			Variables[3][14] = "0"
			GiveAwayText = L["GLR - UI > Config > Giveaway - Names Available"] .. ": " .. tostring(Variables[3][13])
			if Variables[3][4] then
				if Variables[3][5] then
					if tonumber(Variables[3][14]) > tonumber(Variables[3][13]) then
						Variables[3][14] = tostring(Variables[3][13])
						Variables[3][10] = Variables[3][13]
						GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13])
					else
						GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
					end
				else
					GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
				end
			else
				GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13] * tonumber(Variables[3][14]))
			end
			if not glrCharacter.Data.Settings.General.CrossFactionEvents then
				local faction, _ = UnitFactionGroup("PLAYER")
				for i = 1, #Variables[7][6] do
					if Variables[7][6][i] == faction then
						Variables[3][16] = i
						Variables[3][17] = Variables[7][6][Variables[3][16]]
						Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
						break
					end
				end
			else
				Variables[3][15] = 1
				Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
			end
		end
		for f, tf in pairs(Variables[7][1]) do
			for g, tg in pairs(Variables[7][1][f]) do
				if full then
					for i = 1, #Variables[7][5][f][g] do
						Variables[7][5][f][g][i] = false
					end
				end
				for r, tr in pairs(Variables[7][1][f][g]) do
					if full then
						Variables[7][1][f][g][r].State = false
						Variables[7][2][f][g][r].State = false
					end
					Variables[7][2][f][g][r].Check = false
					Variables[7][2][f][g][r].Entered = false
				end
			end
		end
		Variables[7][8] = {}
		Variables[7][9] = {}
	end
end

local function GiveEveryoneTickets(GiveTickets, state, randomize)
	
	local faction, _ = UnitFactionGroup("PLAYER")
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local PlayerNamesTable = GenerateRosterNames()
	local PlayerTickets = tonumber(GiveTickets)
	local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
	local dateTime = time()
	local guaranteedWinner = false
	local canSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat()
	Variables[1][3] = 0
	Variables[3][11] = 0
	
	statusbar:SetMinMaxValues(0, Variables[3][12])
	
	_, statMax = statusbar:GetMinMaxValues()
	frame:Show()
	
	if state == "Lottery" then
		if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
			guaranteedWinner = true
		end
	else
		guaranteedWinner = true
	end
	
	if glrTemp == nil then
		glrTemp = {}
	end
	if glrTemp[state] == nil then
		glrTemp[state] = {}
	end
	
	local message = string.gsub(string.gsub(L["GLR - Core - Ticket Giveaway"], "%%PlayerTickets", tostring(PlayerTickets)), "%%name", L[state])
	
	if randomize then
		message = string.gsub(string.gsub(L["GLR - Core - Random Ticket Giveaway"], "%%PlayerTickets", tostring(PlayerTickets)), "%%name", L[state])
	end
	
	if PlayerTickets == 1 then
		message = string.gsub(message, "%%word", L["GLR - Core - Ticket Giveaway Singular"])
	else
		message = string.gsub(message, "%%word", L["GLR - Core - Ticket Giveaway Plural"])
	end
	
	if Variables[3][7] == 2 then --If By Rank
		local steps = 10
		local ms = 0.25
		local done = false
		local RankList = {}
		local lt = {}
		local ts = ""
		
		if canSpeakInGuildChat then
			if not randomize then
				C_Timer.After(ms, function(self) SendChatMessage(L["Send Info GLR"] .. ": " .. L["GLR - Core - Ticket Giveaway Rank Based"], "GUILD") end)
			else
				C_Timer.After(ms, function(self) SendChatMessage(L["Send Info GLR"] .. ": " .. L["GLR - Core - Random Ticket Giveaway Rank Based"], "GUILD") end)
			end
		end
		
		for f, tf in pairs(Variables[7][1]) do
			for g, tg in pairs(Variables[7][1][f]) do
				for r, tr in pairs(Variables[7][1][f][g]) do
					if Variables[7][1][f][g][r].State then
						if RankList[r] == nil then
							table.insert(RankList, r)
						end
					end
				end
			end
		end
		
		sort(RankList)
		
		for i = 1, #RankList do --Recursive loop to search if multiple instances of the same Rank exist, and remove one of them. No break point in case more than two copies exist.
			for j = i + 1, #RankList do
				if RankList[i] == RankList[j] then
					table.remove(RankList, j)
				end
			end
		end
		
		for i = 1, #RankList do
			
			ts = RankList[1]
			table.remove(RankList, 1)
			
			for j = 1, steps do
				if not done then
					if RankList[1] == nil then
						break
					end
					if RankList[2] == nil then
						ts = strjoin(", & ", ts, RankList[1] .. ".")
						table.remove(RankList, 1)
					else
						ts = strjoin(", ", ts, RankList[1])
						table.remove(RankList, 1)
					end
				end
			end
			
			if not done then
				table.insert(lt, ts)
				ts = ""
			end
			
			if RankList[1] == nil then
				done = true
				break
			end
			
		end
		
		for i = 1, #lt do
			if lt[1] ~= nil then
				ms = ms + 0.25
				local msg = lt[1]
				if canSpeakInGuildChat then
					C_Timer.After(ms, function(self) SendChatMessage("GLR: " .. msg, "GUILD") end)
				end
				table.remove(lt, 1)
			end
		end
		
	end
	
	if canSpeakInGuildChat then
		SendChatMessage(L["Send Info GLR"] .. ": " .. message, "GUILD")
	else
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GiveEveryoneTickets() - Unable to Announce Giveaway. Reason: [MUTED]")
		GLR:Print("You are currently unable to speak in Guild Chat, the Giveaway was completed but NOT announced. Please contact your Guild Master to fix this.")
	end
	
	local div = Variables[3][12] / 20
	local timer = div / Variables[3][12]
	
	--[[
	local div = MaxPossible / 20
	local timer = (MaxPossible / 20) / MaxPossible
	timer = timer + ( div / MaxPossible )
	]]
	
	if not randomize then
		for i = 1, #Variables[7][10] do
			
			local PlayerName = Variables[7][10][i]
			C_Timer.After(timer, function(self)
				PreformGiveTickets(PlayerName, state, MaxTicket, dateTime, guaranteedWinner, PlayerTickets)
			end)
			
			timer = timer + ( div / Variables[3][12] )
			
			if Variables[7][9][i+1] == nil then
				Variables[3][2] = false
			end
			
		end
	else
		for i = 1, Variables[3][10] do
			
			local r = math.random(1, #Variables[7][10])
			
			local PlayerName = Variables[7][10][r]
			local Max = glrCharacter.Event[state].MaxTickets
			if glrCharacter[state].Entries.Tickets[Variables[7][10][r]] ~= nil then
				local newTotal = glrCharacter[state].Entries.Tickets[Variables[7][10][r]].NumberOfTickets + 1
				if newTotal == Max and not Variables[3][5] then
					table.remove(Variables[7][10], r)
				end
			elseif Max == 1 and not Variables[3][5] then
				table.remove(Variables[7][10], r)
			end
			
			C_Timer.After(timer, function(self)
				PreformGiveTickets(PlayerName, state, MaxTicket, dateTime, guaranteedWinner, 1)
			end)
			
			if Variables[3][5] then
				table.remove(Variables[7][10], r)
			end
			
			timer = timer + ( div / Variables[3][12] )
			
			if Variables[7][10][i+1] == nil then
				Variables[3][2] = false
			end
			
		end
	end
	
	C_Timer.After(timer + 2, function(self)
		ResetGiveAwayTable(true)
	end)
	
end

function GLR_O:Debug()
	DebugTable = {}
	DebugTable = { ["count"] = #Variables[7][9], ["names"] = Variables[7][9] }
end

local function GetTimeSinceLastLogin(UserTime)
	local days = math.floor((time() - UserTime)/86400)
	local check = 0
	if not glrCharacter.Data.Settings.General.MultiGuild then check = 1 end
	if Variables[3][8] == (1 + check) and days <= 7 then
		return true
	elseif Variables[3][8] == (2 + check) and days <= 14 then
		return true
	elseif Variables[3][8] == (3 + check) and days <= 21 then
		return true
	elseif Variables[3][8] == (4 + check) and days <= 28 then
		return true
	else
		return false
	end
end

local function GetTimeSinceLastLoginString(DateString)
	if string.find(DateString, "Online") then return true end
	local Years = tonumber(string.sub(DateString, 1, string.find(DateString, 'Y') - 1))
	local Months = tonumber(string.sub(DateString, string.find(DateString, 'Y') + 1, string.find(DateString, 'M') - 1))
	local Days = tonumber(string.sub(DateString, string.find(DateString, 'M') + 1, string.find(DateString, 'D') - 1))
	if Years == nil or Months == nil then return false end
	if Years >= 1 or Months >= 1 then return false end
	local check = 0
	if not glrCharacter.Data.Settings.General.MultiGuild then check = 1 end
	if Variables[3][8] == (1 + check) and Days <= 7 then
		return true
	elseif Variables[3][8] == (2 + check) and Days <= 14 then
		return true
	elseif Variables[3][8] == (3 + check) and Days <= 21 then
		return true
	elseif Variables[3][8] == (4 + check) and Days <= 28 then
		return true
	else
		return false
	end
end

local function PreviewMessage(message, state)
	local chatColor = string.format("%02X", ChatTypeInfo["GUILD"].r * 255) .. string.format("%02X", ChatTypeInfo["GUILD"].g * 255) .. string.format("%02X", ChatTypeInfo["GUILD"].b * 255)
	local showTimestamps = GetCVar("showTimestamps")
	local DateTime = ""
	local UserName = "[|r|cFF" .. Variables[6][classIndex] .. PlayerName .. "|r|cFF" .. chatColor .. "]: "
	if showTimestamps ~= "none" then
		DateTime = date(showTimestamps)
	end
	message = string.gsub(message, "%%lottery_reply", L["Detect Lottery"])
	message = string.gsub(message, "%%raffle_reply", L["Detect Raffle"])
	message = string.gsub(message, "%%version", GLR_CurrentVersionString)
	if state == "Lottery" or state == "Both" then
		if glrCharacter.Data.Settings.CurrentlyActiveLottery then
			local round = glrCharacter.Data.Settings.Lottery.RoundValue
			if string.find(message, "%%lottery_winchance") then
				local WinChanceTable = { [1] = "90%", [2] = "80%", [3] = "70%", [4] = "60%", [5] = "50%", [6] = "40%", [7] = "30%", [8] = "20%", [9] = "10%", [10] = "100%" }
				if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
					message = string.gsub(message, "%%lottery_winchance", WinChanceTable[glrCharacter.Data.Settings.Lottery.WinChanceKey])
				else
					message = string.gsub(message, "%%lottery_winchance", WinChanceTable[10])
				end
			end
			if string.find(message, "%%previous_winner") or string.find(message, "%%previous_jackpot") then
				local PreviousWinner = ""
				local PreviousValue = ""
				if glrCharacter.PreviousEvent.Lottery.Available then
					local doBreak = false
					local WinStatus = glrCharacter.PreviousEvent.Lottery.Settings.WonType
					local s = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.StartingGold)
					local tp = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.TicketPrice)
					local ts = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.TicketsSold)
					local gc = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.GuildCut)
					local sp = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.SecondPlace)
					local PreviousJackpot = 0
					if not WinStatus then
						PreviousJackpot = ( tp * ts + s ) * ( sp / 100 )
					elseif WinStatus then
						PreviousJackpot = ( tp * ts + s ) - ( ( tp * ts + s ) * ( gc / 100 ) )
					end
					for i = 1, #glrCharacter.PreviousEvent.Lottery.Data.Entries.Names do
						name = glrCharacter.PreviousEvent.Lottery.Data.Entries.Names[i]
						for j = 1, #glrCharacter.PreviousEvent.Lottery.Data.Entries.TicketNumbers[name] do
							if glrCharacter.PreviousEvent.Lottery.Data.Entries.TicketNumbers[name][j] == glrCharacter.PreviousEvent.Lottery.Data.Winner then
								local PreviousRound = glrCharacter.PreviousEvent.Lottery.Settings.RoundValue
								PreviousWinner = name
								doBreak = true
								break
							end
						end
						if doBreak then break end
					end
					if not doBreak then
						PreviousWinner = "No Winner!"
						PreviousJackpot = tp * ts + s
					end
					if WinStatus then
						PreviousValue = GLR_U:GetMoneyValue(PreviousJackpot, "Lottery", true, 1, "NA", true, true, true) .. "|cFF" .. chatColor
					else
						PreviousValue = GLR_U:GetMoneyValue(PreviousJackpot, "Lottery", true, PreviousRound, "NA", true, true, true) .. "|cFF" .. chatColor
					end
				else
					PreviousWinner = "No Winner!"
					PreviousValue = "0g"
				end
				message = string.gsub(message, "%%previous_winner", PreviousWinner)
				message = string.gsub(message, "%%previous_jackpot", PreviousValue)
			end
			if string.find(message, "%%lottery_guild") then
				local LotteryGuild = ( tonumber(glrCharacter.Event.Lottery.StartingGold) + tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) ) * ( tonumber(glrCharacter.Event.Lottery.GuildCut) / 100 )
				LotteryGuild = GLR_U:GetMoneyValue(LotteryGuild, "Lottery", true, round, "NA", true, true, true) .. "|cFF" .. chatColor
				message = string.gsub(message, "%%lottery_guild", LotteryGuild)
			end
			if string.find(message, "%%lottery_total") then
				local LotteryTotal = tonumber(glrCharacter.Event.Lottery.StartingGold) + ( tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) )
				LotteryTotal = GLR_U:GetMoneyValue(LotteryTotal, "Lottery", true, 1, "NA", true, true, true) .. "|cFF" .. chatColor
				message = string.gsub(message, "%%lottery_total", LotteryTotal)
			end
			if string.find(message, "%%lottery_price") and glrCharacter.Event.Lottery.TicketPrice ~= nil then
				local price = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Lottery.TicketPrice), "Lottery", true, 1, "NA", true, true, true) .. "|cFF" .. chatColor
				message = string.gsub(message, "%%lottery_price", price)
			end
			message = string.gsub(message, "%%lottery_max", glrCharacter.Event.Lottery.MaxTickets)
			message = string.gsub(message, "%%lottery_name", glrCharacter.Event.Lottery.EventName)
			local m = glrCharacter.Event.Lottery.Date
			if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
				local s = string.sub(m, 1, string.find(m, "%@") + 1)
				local t = GetTimeFormat(string.sub(m, string.find(m, "%:") - 2))
				m = s .. t
			end
			message = string.gsub(message, "%%lottery_date", m)
			if string.find(message, "%%lottery_winamount") then
				local s = tonumber(glrCharacter.Event.Lottery.StartingGold)
				local tp = tonumber(glrCharacter.Event.Lottery.TicketPrice)
				local ts = tonumber(glrCharacter.Event.Lottery.TicketsSold)
				local gc = tonumber(glrCharacter.Event.Lottery.GuildCut)
				local gold = "0g"
				if s ~= nil and tp ~= nil and ts ~= nil and gc ~= nil then
					gold = ( tp * ts + s ) - ( ( tp * ts + s ) * ( gc / 100 ) )
					gold = GLR_U:GetMoneyValue(gold, "Lottery", true, 1, "NA", true, true, true) .. "|cFF" .. chatColor
				end
				message = string.gsub(message, "%%lottery_winamount", gold)
			end
			local tickets = tostring(glrCharacter.Event.Lottery.TicketsSold)
			if tickets ~= nil then
				if glrCharacter.Event.Lottery.GiveAwayTickets > 0 then
					tickets = tostring( glrCharacter.Event.Lottery.TicketsSold + glrCharacter.Event.Lottery.GiveAwayTickets )
				end
				message = string.gsub(message, "%%lottery_tickets", tickets)
			end
			if string.len(message) > 255 then
				message = L["Configuration Panel Message Too Long"]
			end
		end
	end
	if state == "Raffle" or state == "Both" then
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
			local gold = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
			local tickets = tostring(glrCharacter.Event.Raffle.TicketsSold)
			local prizes = glrCharacter.Event.Raffle.FirstPlace
			if prizes == "%raffle_total" then
				prizes = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
			elseif prizes == "%raffle_half" then
				prizes = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
			elseif prizes == "%raffle_quarter" then
				prizes = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
			end
			if tonumber(prizes) ~= nil then
				prizes = GLR_U:GetMoneyValue(tonumber(prizes), "Raffle", true, 1, "NA", true, true, true)
			end
			if glrCharacter.Event.Raffle.SecondPlace ~= false then
				local second = glrCharacter.Event.Raffle.SecondPlace
				if second == "%raffle_total" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
				elseif second == "%raffle_half" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
				elseif second == "%raffle_quarter" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
				end
				if tonumber(second) ~= nil then
					second = GLR_U:GetMoneyValue(tonumber(second), "Raffle", true, 1, "NA", true, true, true)
				end
				prizes = prizes .. "|cFF" .. chatColor .. ",|r " .. second
			end
			if glrCharacter.Event.Raffle.ThirdPlace ~= false then
				local third = glrCharacter.Event.Raffle.SecondPlace
				if third == "%raffle_total" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
				elseif third == "%raffle_half" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
				elseif third == "%raffle_quarter" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
				end
				if tonumber(third) ~= nil then
					third = GLR_U:GetMoneyValue(tonumber(third), "Raffle", true, 1, "NA", true, true, true)
				end
				prizes = prizes .. "|cFF" .. chatColor .. ",|r " .. third
			end
			if string.find(message, "%%raffle_price") then
				local price = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, true, true) .. "|cFF" .. chatColor
				message = string.gsub(message, "%%raffle_price", price)
			end
			message = string.gsub(message, "%%raffle_max", glrCharacter.Event.Raffle.MaxTickets)
			message = string.gsub(message, "%%raffle_name", glrCharacter.Event.Raffle.EventName)
			local m = glrCharacter.Event.Raffle.Date
			if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
				local s = string.sub(m, 1, string.find(m, "%@") + 1)
				local t = GetTimeFormat(string.sub(m, string.find(m, "%:") - 2))
				m = s .. t
			end
			message = string.gsub(message, "%%raffle_date", m)
			message = string.gsub(message, "%%raffle_prizes", prizes)
			if gold ~= nil and string.find(message, "%%raffle_total") then
				gold = GLR_U:GetMoneyValue(gold, "Raffle", false, 1, "NA", true, true, true) .. "|cFF" .. chatColor
				message = string.gsub(message, "%%raffle_total", gold)
			end
			if tickets ~= nil then
				if glrCharacter.Event.Raffle.GiveAwayTickets > 0 then
					tickets = tostring( glrCharacter.Event.Raffle.TicketsSold + glrCharacter.Event.Raffle.GiveAwayTickets )
				end
				message = string.gsub(message, "%%raffle_tickets", tickets)
			end
			if string.len(message) > 255 then
				message = L["Configuration Panel Message Too Long"]
			end
		end
	end
	if message == "" or message == nil then
		return ""
	else
		return "|cFF" .. chatColor .. DateTime .. UserName .. message .. "|r"
	end
end

local function GetValidEntries() -- [f][g][r] Refer to "Faction" "Guild" "Rank"
	
	if GLR_Global_Variables[6][1] or GLR_Global_Variables[6][2] then return end --Don't need to gather info while a Event Draw is in progress.
	
	local cross = glrCharacter.Data.Settings.General.CrossFactionEvents
	local multi = glrCharacter.Data.Settings.General.MultiGuild
	Variables[7][9] = {}
	local FoundCount = 0
	GLR_DebugMaxEntries = 0
	Variables[3][13] = 0
	Variables[3][9] = 0
	local faction, _ = UnitFactionGroup("PLAYER")
	local guild, _, _, _ = GetGuildInfo("PLAYER")
	local EventType
	if Variables[7][7][Variables[3][6]] == L["Lottery"] then
		EventType = "Lottery"
	elseif Variables[7][7][Variables[3][6]] == L["Raffle"] then
		EventType = "Raffle"
	end
	local timestamp = GetTimeStamp()
	if PlayerInfo[GuildRoster] == nil then PlayerInfo = glrHistory end
	if CharacterInfo == nil then CharacterInfo = {} end
	if CharacterInfo[EventType] == nil then
		CharacterInfo[EventType] = {}
		CharacterInfo[EventType] = glrCharacter[EventType]
	end
	if CharacterInfo.Event == nil then
		CharacterInfo.Event = glrCharacter.Event
	end
	if CharacterInfo.Data == nil then
		CharacterInfo.Data = {}
		CharacterInfo.Data = glrCharacter.Data
	end
	if CharacterInfo[EventType] == nil then CharacterInfo = glrCharacter end
	local MaxTickets = 0
	if CharacterInfo.Event[EventType] ~= nil then
		if CharacterInfo.Event[EventType].MaxTickets ~= nil then
			MaxTickets = tonumber(CharacterInfo.Event[EventType].MaxTickets)
		end
	end
	if MaxTickets == 0 then
		MaxTickets = tonumber(glrCharacter.Event[EventType].MaxTickets)
	end
	if not CharacterInfo.Data.Settings.General.MultiGuild then
		if Variables[3][17] ~= faction then
			for i = 1, #Variables[7][6] do
				if Variables[7][6][i] == faction then
					Variables[3][16] = i
					Variables[3][17] = Variables[7][6][Variables[3][16]]
					break
				end
			end
		end
		if Variables[3][18] ~= guild then
			-- if Variables[7][3][Variables[3][17]][1] == nil then
				-- GetMultiGuildList(false)
			-- end
			for i = 1, #Variables[7][3][Variables[3][17]] do
				if Variables[7][3][Variables[3][17]][i] == guild then
					Variables[3][15] = i
					Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
					break
				end
			end
		end
	end
	if CharacterInfo.Data.Settings.General.MultiGuild then
		for f, _ in pairs(PlayerInfo.GuildRoster) do
			for g, _ in pairs(PlayerInfo.GuildRoster[f]) do
				GLR_DebugMaxEntries = #PlayerInfo.GuildRoster[f][g] + GLR_DebugMaxEntries
			end
		end
	else
		GLR_DebugMaxEntries = #PlayerInfo.GuildRoster[faction][guild]
	end
	
	if CharacterInfo[EventType].Entries == nil then
		GLR:Print("Table was NIL. Please report this to the AddOn Author.")
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - CharacterInfo[" .. string.upper(tostring(EventType)) .. "].Entries was NIL" )
		if glrHistory.BulkDebug[FullPlayerName].GetValidEntries == nil then
			glrHistory.BulkDebug[FullPlayerName].GetValidEntries = {}
		end
		glrHistory.BulkDebug[FullPlayerName].GetValidEntries = CharacterInfo
		return
	end
	
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - Event: [" .. string.upper(tostring(EventType)) .. "] - Giveaway Type: [" .. string.upper(GiveawayValuesTable[Variables[3][7]]) .. "] - Online Status: [" .. string.upper(GiveawayLastOnlineTable[Variables[3][8]]) .. "] - Total Guild Members: [" .. GLR_DebugMaxEntries .. "]" )
	local CompareOnlineNumber = Variables[3][8]
	
	--Prevents it from incorrectly determining a Players eligibility if running a Multi-Guild Event.
	if CharacterInfo.Data.Settings.General.MultiGuild and CompareOnlineNumber > 0 then CompareOnlineNumber = CompareOnlineNumber + 1 end
	
	--Only need to do this if a Event is Active
	if Variables[7][7][Variables[3][6]] ~= L["GLR - UI > Config > Giveaway - No Event Active"] then
		GetMultiGuildTables()
		
		if Variables[3][7] == 2 then --Giveaway By Rank
			
			--Prevents it from erroring out with a invalid Guild Name
			if Variables[3][18] == "" then Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]] end
			
			--Tracks which Guild under which Faction it's processing, also tracks whether it's doing it for Everyone or By Rank
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - F-Key: [" .. string.upper(tostring(Variables[3][17])) .. "] G-Key: [" .. string.upper(tostring(Variables[3][18])) .. "] Key Value: " .. Variables[3][7] )
			
			--Cycles through the two Factions (Horde/Alliance)
			for f, tf in pairs(Variables[7][1]) do
				
				--Cycles through the available Guilds the Player has Data of
				for g, tg in pairs(Variables[7][1][f]) do
					
					--Cycles through the Ranks the selected Guild has
					for r, tr in pairs(Variables[7][1][f][g]) do
						
						--Determines whether or not it's already checked the Rank it's currently going through
						if Variables[7][1][f][g][r].State and Variables[7][2][f][g][r].State and not Variables[7][2][f][g][r].Check then
							
							timestamp = GetTimeStamp()
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - Checking Rank: [" .. string.upper(tostring(r)) .. "] Is Rank Checked? " .. string.upper(tostring(Variables[7][2][f][g][r].Check)) )
							
							--If Key equals ZERO it adds Everyone of that Rank
							if Variables[3][8] == 0 then
								
								if not Variables[7][2][f][g][r].Entered then
									local IncreaseCount = 0
									for i = 1, #Variables[7][1][f][g][r].Names do
										local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
										if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
											if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
												IncreaseCount = IncreaseCount + 1
												table.insert(Variables[7][8], name)
											end
										else
											IncreaseCount = IncreaseCount + 1
											table.insert(Variables[7][8], name)
										end
									end
									Variables[3][9] = Variables[3][9] + IncreaseCount
									Variables[3][13] = Variables[3][13] + IncreaseCount
									Variables[7][2][f][g][r].Entered = true
									timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - [" .. IncreaseCount .. "] Valid Entries Added. Current Total: [" .. Variables[3][13] .. "]")
								end
								
							--Else if Key doesn't equal ZERO it only adds those Last Online
							else
								
								local IncreaseCount = 0
								if not Variables[7][2][f][g][r].Entered then
									for i = 1, #Variables[7][1][f][g][r].Names do
										local UserTime = tonumber(string.sub(Variables[7][1][f][g][r].Names[i], string.find(Variables[7][1][f][g][r].Names[i], "%@") + 1, string.find(Variables[7][1][f][g][r].Names[i], "%$") - 1))
										if UserTime ~= nil then
											local valid = GetTimeSinceLastLogin(UserTime)
											if valid then
												local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
												if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
													if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
														IncreaseCount = IncreaseCount + 1
														table.insert(Variables[7][8], name)
													end
												else
													IncreaseCount = IncreaseCount + 1
													table.insert(Variables[7][8], name)
												end
											end
										else
											local DateString = string.sub(Variables[7][1][f][g][r].Names[i], string.find(Variables[7][1][f][g][r].Names[i], "%$") + 1, string.find(Variables[7][1][f][g][r].Names[i], "%!") - 1)
											local valid = GetTimeSinceLastLoginString(DateString)
											if valid then
												local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
												if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
													if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
														IncreaseCount = IncreaseCount + 1
														table.insert(Variables[7][8], name)
													end
												else
													IncreaseCount = IncreaseCount + 1
													table.insert(Variables[7][8], name)
												end
											end
										end
									end
									Variables[7][2][f][g][r].Entered = true
								end
								Variables[3][9] = Variables[3][9] + IncreaseCount
								Variables[3][13] = Variables[3][13] + IncreaseCount
								timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - [" .. IncreaseCount .. "] Valid Entries Added. Current Total: [" .. Variables[3][13] .. "]")
								
							end
							
							Variables[7][2][f][g][r].Check = true
							
						--Since it's already gone through the selected Rank, it now needs to remove those it already added
						elseif not Variables[7][1][f][g][r].State and Variables[7][2][f][g][r].State then
							
							local RemoveCount = 0
							for j = 1, #Variables[7][1][f][g][r].Names do
								local name = string.sub(Variables[7][1][f][g][r].Names[j], 1, string.find(Variables[7][1][f][g][r].Names[j], "%[") - 1)
								for i = 1, #Variables[7][8] do
									if name == Variables[7][8][i] then
										table.remove(Variables[7][8], i)
										RemoveCount = RemoveCount + 1
										break
									end
								end
							end
							if Variables[3][13] >= 1 then
								Variables[3][9] = Variables[3][9] - RemoveCount
								Variables[3][13] = Variables[3][13] - RemoveCount
							end
							Variables[7][2][f][g][r].State = false
							Variables[7][2][f][g][r].Check = false
							Variables[7][2][f][g][r].Entered = false
							
						end
						
					end
					
				end
				
			end
			
		else --Giveaway to Everyone
			
			--Cycles through the two Factions (Horde/Alliance)
			for f, tf in pairs(Variables[7][1]) do
				
				local continue = true
				if not cross and tostring(f) ~= faction then continue = false end
				
				--Need to stop it from going through if the current Faction doesn't match the Players when not doing a Cross-Faction Event
				if continue then
					
					--Cycles through the available Guilds the Player has Data of
					for g, tg in pairs(Variables[7][1][f]) do
						
						continue = true
						if not multi and tostring(g) ~= guild then continue = false end
						
						--Like above, need to stop it if criteria isn't met for non-Multi-Guild Events
						if continue then
							
							--Cycles through the Ranks the Guild has
							for r, tr in pairs(Variables[7][1][f][g]) do
								
								FoundCount = 0
								
								--If Key equals ZERO it adds Everyone of that Rank
								if Variables[3][8] == 0 then
									
									if not Variables[7][2][f][g][r].Entered then
										local IncreaseCount = 0
										for i = 1, #Variables[7][1][f][g][r].Names do
											local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
											if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
												if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
													IncreaseCount = IncreaseCount + 1
													table.insert(Variables[7][8], name)
												end
											else
												IncreaseCount = IncreaseCount + 1
												table.insert(Variables[7][8], name)
											end
										end
										Variables[3][9] = Variables[3][9] + IncreaseCount
										Variables[3][13] = Variables[3][13] + IncreaseCount
										FoundCount = IncreaseCount
										Variables[7][2][f][g][r].Entered = true
										timestamp = GetTimeStamp()
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - [" .. FoundCount .. "] Valid Entries Added. Current Total: [" .. Variables[3][13] .. "]")
									end
									
								--Else if Key doesn't equal ZERO it only adds those Last Online
								elseif not Variables[7][2][f][g][r].Check then
									
									if Variables[3][8] >= 1 then
										local IncreaseCount = 0
										if not Variables[7][2][f][g][r].Entered then
											for i = 1, #Variables[7][1][f][g][r].Names do
												local UserTime = tonumber(string.sub(Variables[7][1][f][g][r].Names[i], string.find(Variables[7][1][f][g][r].Names[i], "%@") + 1, string.find(Variables[7][1][f][g][r].Names[i], "%$") - 1))
												if UserTime ~= nil then
													local valid = GetTimeSinceLastLogin(UserTime)
													if valid then
														local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
														if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
															if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
																IncreaseCount = IncreaseCount + 1
																table.insert(Variables[7][8], name)
															end
														else
															IncreaseCount = IncreaseCount + 1
															table.insert(Variables[7][8], name)
														end
													end
												else
													local DateString = string.sub(Variables[7][1][f][g][r].Names[i], string.find(Variables[7][1][f][g][r].Names[i], "%$") + 1, string.find(Variables[7][1][f][g][r].Names[i], "%!") - 1)
													local valid = GetTimeSinceLastLoginString(DateString)
													if valid then
														local name = string.sub(Variables[7][1][f][g][r].Names[i], 1, string.find(Variables[7][1][f][g][r].Names[i], "%[") - 1)
														if CharacterInfo[EventType].Entries.Tickets[name] ~= nil then
															if CharacterInfo[EventType].Entries.Tickets[name].NumberOfTickets < MaxTickets then
																IncreaseCount = IncreaseCount + 1
																table.insert(Variables[7][8], name)
															end
														else
															IncreaseCount = IncreaseCount + 1
															table.insert(Variables[7][8], name)
														end
													end
												end
											end
											Variables[7][2][f][g][r].Entered = true
										end
										Variables[3][9] = Variables[3][9] + IncreaseCount
										Variables[3][13] = Variables[3][13] + IncreaseCount
										FoundCount = IncreaseCount
										timestamp = GetTimeStamp()
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - [" .. FoundCount .. "] Valid Entries Added. Current Total: [" .. Variables[3][13] .. "]")
									end
									Variables[7][1][f][g][r].State = true
									Variables[7][2][f][g][r].State = true
									Variables[7][2][f][g][r].Check = true
									
								end
								
							end
						end
					end
				end
			end
			
		end
	end
	
	timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetValidEntries() - Final Valid Entries Count: [" .. Variables[3][13] .. "/" .. GLR_DebugMaxEntries .. "] - Multi-Guild: [" .. string.upper(tostring(multi)) .. "] - Cross-Faction: [" .. string.upper(tostring(cross)) .. "]" )
	
	if tonumber(Variables[3][14]) > 0 then
		local EventType = ""
		if Variables[7][7][Variables[3][6]] == L["Lottery"] then
			EventType = "Lottery"
		elseif Variables[7][7][Variables[3][6]] == L["Raffle"] then
			EventType = "Raffle"
		end
		if not Variables[3][4] then
			if CharacterInfo.Event[EventType].MaxTickets ~= nil then
				if tonumber(Variables[3][14]) > tonumber(glrCharacter.Event[EventType].MaxTickets) then
					Variables[3][14] = glrCharacter.Event[EventType].MaxTickets
				end
			end
		end
	end
	
	sort(Variables[7][8])
	Variables[7][9] = Variables[7][8]
	GiveAwayText = L["GLR - UI > Config > Giveaway - Names Available"] .. ": " .. tostring(Variables[3][13])
	if Variables[3][4] then
		if Variables[3][5] then
			if tonumber(Variables[3][14]) > tonumber(Variables[3][13]) then
				Variables[3][10] = Variables[3][13]
				Variables[3][14] = tostring(Variables[3][13])
				GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13])
			else
				GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
			end
		else
			GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
		end
	else
		GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13] * tonumber(Variables[3][14]))
	end
end

local function CancelCurrentEvent(EventType)
	
	local state = EventType
	local dateTime = string.sub(date(), 1, string.find(date(), ":") - 4)
	local EventStatus = false
	local continue = false
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	
	if state == "Lottery" then
		if Variables[5][1] then
			continue = true
		end
	else
		if Variables[5][2] then
			continue = true
		end
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CancelCurrentEvent() - Attempting to Cancel Current [" .. string.upper(state) .. "] Event. Confirmation: [" .. string.upper(tostring(continue)) .. "]" )
	
	if continue then
		
		glrCharacter.Data.Defaults.LotteryDate = dateTime
		
		if state == "Lottery" then
			local startingGold = tostring(glrCharacter.Data.Settings.PreviousLottery.Jackpot)
			local jackpotGold = startingGold
			
			GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetText("")
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetText(L["No Lottery Active"])
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetCursorPosition(0)
			GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetText(startingGold)
			GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetText(jackpotGold)
			GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetText(glrCharacter.Data.Defaults.LotteryMaxTickets)
			GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetText(glrCharacter.Data.Defaults.TicketPrice)
			GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetText(glrCharacter.Data.Defaults.SecondCut)
			GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetText(glrCharacter.Data.Defaults.GuildCut)
			if glrHistory.TransferData[FullPlayerName].Data ~= nil then
				glrHistory.TransferData[FullPlayerName].Data.Settings.PreviousLottery = nil
				glrHistory.TransferData[FullPlayerName].Data.Settings.TicketSeries = nil
				glrHistory.TransferData[FullPlayerName].Data.Settings.WinChanceKey = nil
			end
		else
			GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetText(L["No Raffle Active"])
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetCursorPosition(0)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetText(glrCharacter.Data.Defaults.RaffleMaxTickets)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetText(glrCharacter.Data.Defaults.TicketPrice)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetText("")
			if glrHistory.TransferData[FullPlayerName].Data ~= nil then
				glrHistory.TransferData[FullPlayerName].Data.Settings.AllowMultipleRaffleWinners = nil
				glrHistory.TransferData[FullPlayerName].Data.Settings.RaffleSeries = nil
				glrHistory.TransferData[FullPlayerName].Data.Raffle = nil
			end
		end
		
		GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("0")
		GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("0")
		
		glrCharacter.Event[state] = nil
		glrCharacter.Event[state] = {}
		
		glrCharacter[state].TicketPool = nil
		glrCharacter[state].TicketPool = {}
		
		glrCharacter[state].Entries.TicketRange = nil
		glrCharacter[state].Entries.TicketRange = {}
		
		glrCharacter[state].Entries.TicketNumbers = nil
		glrCharacter[state].Entries.TicketNumbers = {}
		
		glrCharacter[state].Entries.Tickets = nil
		glrCharacter[state].Entries.Tickets = {}
		
		glrCharacter[state].Entries.Names = nil
		glrCharacter[state].Entries.Names = {}
		
		glrCharacter[state].MessageStatus = nil
		glrCharacter[state].MessageStatus = {}
		
		glrCharacter.Data.OtherStatus[state] = nil
		glrCharacter.Data.OtherStatus[state] = {}
		
		if glrHistory.TransferData[FullPlayerName][state] ~= nil and glrHistory.TransferData[FullPlayerName].Event ~= nil then
			glrHistory.TransferData[FullPlayerName][state] = nil
			glrHistory.TransferData[FullPlayerName].Event[state] = nil
		end
		
		glrHistory.TransferAvailable[state][FullPlayerName] = false
		
		glrTemp[state] = nil
		glrTemp[state] = {}
		
		glrTempStatus = nil
		glrTempStatus = {}
		
		if GLR_UI.GLR_MainFrame:IsVisible() then
			GLR:UpdatePlayersAndTotalTickets()
			GLR:UpdateNumberOfUnusedTickets()
		end
		
		if glrHistory.ActiveEvents == nil then
			glrHistory.ActiveEvents = {}
		end
		
		if state == "Lottery" then
			glrCharacter.Data.Settings.CurrentlyActiveLottery = false
			GLR_Global_Variables[6][1] = false
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Disable()
			GLR:Print(L["GLR - Core - Lottery Canceled Message"])
		else
			glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
			GLR_Global_Variables[6][2] = false
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Disable()
			GLR:Print(L["GLR - Core - Raffle Canceled Message"])
		end
		
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle or glrCharacter.Data.Settings.CurrentlyActiveLottery then --Checks if a Lottery/Raffle is currently Active before confirming that both Lottery/Raffle's are inactive, allowing you to change Multi-Guild status on your character (assuming no other events are active on other characters)
			EventStatus = true
		end
		
		if glrHistory.ActiveEvents[FullPlayerName] == nil then
			glrHistory.ActiveEvents[FullPlayerName] = EventStatus
		else
			glrHistory.ActiveEvents[FullPlayerName] = EventStatus
		end
		
		local LotteryStatus = tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)
		local RaffleStatus = tostring(glrCharacter.Data.Settings.CurrentlyActiveRaffle)
		C_ChatInfo.SendAddonMessage("GLR_CHECK", "%lottery_" .. LotteryStatus .. "!%raffle_" .. RaffleStatus, "GUILD")
		
		
		
		GLR_U:UpdateInfo(false)
		ResetGiveAwayTable(true)
		
	else
		GLR:Print(L["GLR - Core - Confirm Cancel False"])
	end
	
end

local function GetEventNames()
	local event = { [1] = L["Lottery"], [2] = L["Raffle"] }
	if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
		for i = 1, #event do
			if event[i] == L["Lottery"] then
				table.remove(event, i)
			end
		end
	end
	if not glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		for i = 1, #event do
			if event[i] == L["Raffle"] then
				table.remove(event, i)
			end
		end
	end
	return event
end

local function ViewPlayerTickets(state)
	
	local n = {}
	local tableTickets = {}
	local ticketString = ""
	local tableStrings = {}
	local c = 0
	local count = 1
	local count2 = 1
	local amount = 0
	local gold = 0
	local buffer = 3
	local scrollWidth = 172
	local scrollHeight = 0
	local name = L["GLR - Error - No Entries Found"]
	local value = 0
	local free = 0
	
	if glrCharacter[state].Entries.Names ~= nil then
		for k, v in pairs(glrCharacter[state].Entries.Names) do
			table.insert(n, v)
			c = c + 1
		end
	end
	
	if state == "Lottery" then
		value = Variables[1][1]
	else
		value = Variables[1][2]
	end
	
	sort(n)
	
	if c >= 1 and value >= 1 then
		
		name = n[value]
		local n = 0
		local s = 0
		
		free = glrCharacter[state].Entries.Tickets[name].Given
		amount = glrCharacter[state].Entries.Tickets[name].NumberOfTickets
		gold = tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter[state].Entries.Tickets[name].Sold
		
		for i = 1, amount do
			table.insert(tableTickets, glrCharacter[state].Entries.TicketNumbers[name][i])
			n = n + 1
		end
		
		for i = 1, #tableTickets do
			
			ticketString = strjoin(" ", ticketString, tableTickets[i])
			n = n - 1
			s = s + 1
			
			if s == 5 then
				table.insert(tableStrings, ticketString)
				ticketString = ""
				s = 0
			end
			
			if s ~= 5 and n == 0 and ticketString ~= "" then
				table.insert(tableStrings, ticketString)
				ticketString = ""
			end
			
		end
		
	end
	
	if name ~= L["GLR - Error - No Entries Found"] then
		
		local UserName = string.sub(name, 1, string.find(name, "%-") - 1)
		local t = {}
		if not glrCharacter.Data.Settings.General.MultiGuild then
			t = glrRoster
		else
			t = glrMultiGuildRoster
		end
		for i = 1, #t do
			local subText = string.sub(t[i], 1, string.find(t[i], '%[') - 1)
			local CN = string.sub(t[i], string.find(t[i], '%[') + 1, string.find(t[i], '%]') - 1)
			if subText == name then
				if Variables[2][CN] == nil then --Changes color to Red in event that it errors out.
					CN = "NA"
				end
				UserName = "|cff" .. Variables[2][CN] .. UserName .. "|r"
				break
			end
		end
		
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ViewPlayerTickets() - Attempting To View Tickets For Event: [" .. string.upper(state) .. "] - Name: [" .. name .. "] - Tickets Bought / Given: [" .. amount .. " / " .. free .. "]")
		
		local GetGold = GLR_U:GetMoneyValue(gold, state, true, 1)
		local User = string.gsub(L["Ticket Info Player Name"], "%%User", UserName)
		local AmountPurchased = string.gsub(L["Ticket Info Player Tickets"], "%%amount", amount)
		local GoldValue = string.gsub(L["Ticket Info Gold Value"], "%%money", GetGold)
		
		GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerName:SetText(User)
		GLR_UI.GLR_ViewPlayerTicketInfoFramePlayerTickets:SetText(AmountPurchased)
		GLR_UI.GLR_ViewPlayerTicketInfoFrameGoldValue:SetText(GoldValue)
		
		if GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings == nil then
			
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings = GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings or {}
			
		elseif GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings ~= nil then
			
			for i = 1, #GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings do
				
				local ClearText = GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings[count2][1]
				ClearText:SetText()
				count2 = count2 + 1
				
			end
			
		end
		
		for t, v in pairs(tableStrings) do
			
			if not GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings[t] then
				
				GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings[t] = { GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild:CreateFontString("GLR_PlayerNamesText" .. count, "OVERLAY", "GameFontWhiteTiny") }
				
			end
			
			local PlayerTickets = GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings[count][1]
			
			PlayerTickets:SetText(v)
			PlayerTickets:SetFont(GLR_Core.Font, 12)
			PlayerTickets:SetWordWrap(false)
			
			local sHeight = ( PlayerTickets:GetStringHeight() * 1.1 ) + 1.8
			
			if count == 1 then
				
				PlayerTickets:SetPoint("TOP", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild, "TOP", 0, -1)
				scrollHeight = scrollHeight + sHeight + 2
				
			else
				
				PlayerTickets:SetPoint("TOP", GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild.PlayerTicketsTextFontstrings[count - 1][1], "BOTTOM", 0, -buffer)
				scrollHeight = scrollHeight + sHeight
				
			end
			
			PlayerTickets:Show()
			
			count = count + 1
			
		end
		
		GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameChild:SetSize(scrollWidth, scrollHeight)
		
		local scrollMax = ( scrollHeight - 93 )
		
		if scrollMax < 0 then
			
			scrollMax = 0
			
			if GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:IsVisible() then
				GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:Hide()
			end
			
		else
			
			if not GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:IsVisible() then
				GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:Show()
			end
			
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(0)
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetMinMaxValues(0, scrollMax)
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetScript("OnValueChanged", function(self)
				GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:SetVerticalScroll(self:GetValue())
			end)
			
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:EnableMouseWheel(true)
			GLR_UI.GLR_ViewPlayerTicketInfoScrollFrame:SetScript("OnMouseWheel", function(_, delta)
				
				local current = GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:GetValue()
				
				if IsShiftKeyDown() and delta > 0 then
					GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(0)
				elseif IsShiftKeyDown() and delta < 0 then
					GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(scrollMax)
				elseif delta < 0 and current < scrollMax then
					if IsControlKeyDown() then
						GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(current + 60)
					else
						GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(current + 20)
					end
				elseif delta > 0 and current > 1 then
					if IsControlKeyDown() then
						GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(current - 60)
					else
						GLR_UI.GLR_ViewPlayerTicketInfoScrollFrameSlider:SetValue(current - 20)
					end
				end
				
			end)
			
		end
		
		--Quick and dirty way to get font strings to show completely
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Show()
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Hide()
		GLR_UI.GLR_ViewPlayerTicketInfoFrame:Show()
		
	end
	
end

local function NOOP() return end

GLR_O.PopupDialogs.OptionChanged = {
	text = "One or more changes made will not take effect until the user interface is reloaded.",
	OnAccept = function() ReloadUI() end,
	OnCancel = NOOP(),
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs["GLROPTIONCHANGED"] = StaticPopupDialogs["GLROPTIONCHANGED"] or GLR_O.PopupDialogs.OptionChanged

local function UpdateWhisperVariables(state)
	
	Variables[10][2]["%%version"] = GLR_CurrentVersionString
	Variables[10][2]["%%reply_default"] = L["Detect " .. state]
	Variables[10][2]["%%mail_default"] = string.lower(L[state])
	
	local function PharseVariable(var)
		if glrCharacter.Event[state] ~= nil then
			if state == "Lottery" then
				if var == "%%jackpot_total" then
					Variables[10][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_guild" then
					Variables[10][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].GuildCut)/100), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_first" then
					Variables[10][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) - (tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].GuildCut)/100), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_second" then
					if glrCharacter.Event[state].SecondPlace ~= L["Winner Guaranteed"] then
						Variables[10][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].SecondPlace)/100), state, true, 1, "NA", true, false, false)
					else
						Variables[10][2][var] = L["Winner Guaranteed"]
					end
					return
				elseif var == "%%jackpot_start" then
					Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event[state].StartingGold, state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%percent_guild" then
					Variables[10][2][var] = glrCharacter.Event[state].GuildCut
					return
				elseif var == "%%percent_second" then
					Variables[10][2][var] = glrCharacter.Event[state].SecondPlace
					return
				end
			elseif state == "Raffle" then
				if var == "%%raffle_prizes" then
					var = glrCharacter.Event[state].FirstPlace
					if glrCharacter.Event[state].SecondPlace ~= false then
						var = var .. ", " .. glrCharacter.Event[state].SecondPlace
						if glrCharacter.Event[state].ThirdPlace ~= false then
							var = var .. ", " .. glrCharacter.Event[state].ThirdPlace
						end
					end
					Variables[10][2]["%%raffle_prizes"] = var
					return
				elseif var == "%%raffle_first" then
					if glrCharacter.Event[state].FirstPlace == "%raffle_total" then
						Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event[state].FirstPlace == "%raffle_half" then
						Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event[state].FirstPlace == "%raffle_quarter" then
						Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
					elseif tonumber(glrCharacter.Event[state].FirstPlace) ~= nil then
						Variables[10][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].FirstPlace), "Raffle", false, 1, "NA", true, false)
					else
						Variables[10][2][var] = glrCharacter.Event[state].FirstPlace
					end
					return
				elseif var == "%%raffle_second" then
					if glrCharacter.Event[state].SecondPlace ~= false then
						if glrCharacter.Event[state].SecondPlace == "%raffle_total" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].SecondPlace == "%raffle_half" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].SecondPlace == "%raffle_quarter" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						elseif tonumber(glrCharacter.Event[state].SecondPlace) ~= nil then
							Variables[10][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].SecondPlace), "Raffle", false, 1, "NA", true, false)
						else
							Variables[10][2][var] = glrCharacter.Event[state].SecondPlace
						end
					end
					return
				elseif var == "%%raffle_third" then
					if glrCharacter.Event[state].ThirdPlace ~= false then
						if glrCharacter.Event[state].ThirdPlace == "%raffle_total" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].ThirdPlace == "%raffle_half" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].ThirdPlace == "%raffle_quarter" then
							Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						elseif tonumber(glrCharacter.Event[state].ThirdPlace) ~= nil then
							Variables[10][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].ThirdPlace), "Raffle", false, 1, "NA", true, false)
						else
							Variables[10][2][var] = glrCharacter.Event[state].ThirdPlace
						end
					end
					return
				end
			end
			if state ~= "NA" then
				if var == "%%reply_phrases" or var == "%%mail_phrases" then
					local o = "Commands"
					local s = ""
					if var == "%%mail_phrases" then
						o = "Mail"
					end
					for i = 1, #glrHistory.Settings[state][o] do
						if i == 1 then
							if o == "Commands" then
								s = "!" .. glrHistory.Settings[state][o][i]
							else
								s = '"' .. string.lower(glrHistory.Settings[state][o][i]) .. '"'
							end
						else
							if o == "Commands" then
								if glrHistory.Settings[state][o][i + 1] == nil then
									s = s .. ", or !" .. glrHistory.Settings[state][o][i]
								else
									s = s .. ", !" .. glrHistory.Settings[state][o][i]
								end
							else
								if glrHistory.Settings[state][o][i + 1] == nil then
									s = s .. ', or "' .. string.lower(glrHistory.Settings[state][o][i]) .. '"'
								else
									s = s .. ', "' .. string.lower(glrHistory.Settings[state][o][i]) .. '"'
								end
							end
						end
					end
					Variables[10][2][var] = s
					return
				elseif var == "%%tickets_max" then
					Variables[10][2][var] = glrCharacter.Event[state].MaxTickets
					return
				elseif var == "%%tickets_price" then
					Variables[10][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].TicketPrice), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%tickets_sold" then
					Variables[10][2][var] = glrCharacter.Event[state].TicketsSold
					return
				elseif var == "%%tickets_given" then
					Variables[10][2][var] = glrCharacter.Event[state].GiveAwayTickets
					return
				elseif var == "%%tickets_total" then
					Variables[10][2][var] = CommaValue(glrCharacter.Event[state].TicketsSold + glrCharacter.Event[state].GiveAwayTickets)
					return
				elseif var == "%%tickets_value" then
					Variables[10][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event[state].TicketsSold * tonumber(glrCharacter.Event[state].TicketPrice), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%event_name" then
					Variables[10][2][var] = glrCharacter.Event[state].EventName
					return
				elseif var == "%%event_date" then
					Variables[10][2][var] = glrCharacter.Event[state].Date
					return
				else
					if glrCharacter[state].Entries.Tickets[FullPlayerName] ~= nil then
						if var == "%%tickets_current" then
							Variables[10][2][var] = glrCharacter[state].Entries.Tickets[FullPlayerName].NumberOfTickets
							return
						elseif var == "%%tickets_difference" then
							Variables[10][2][var] = tonumber(glrCharacter.Event[state].MaxTickets) - glrCharacter[state].Entries.Tickets[FullPlayerName].NumberOfTickets
							return
						end
					else
						if var == "%%tickets_current" then
							Variables[10][2][var] = "0"
							return
						elseif var == "%%tickets_difference" then
							Variables[10][2][var] = glrCharacter.Event[state].MaxTickets
							return
						end
					end
				end
			end
		end
	end
	
	for t, v in pairs(Variables[10][3]) do
		if t == "General" then
			for k, e in pairs(Variables[10][3][t]) do
				if Variables[10][3][t][k] then
					PharseVariable(tostring(k))
					Variables[10][3][t][k] = false
				end
			end
		end
		if t == state then
			if glrCharacter.Data.Settings["CurrentlyActive" .. state] then
				for k, e in pairs(Variables[10][3][t]) do
					if Variables[10][3][t][k] then
						PharseVariable(tostring(k))
						Variables[10][3][t][k] = false
					end
				end
			else
				for k, e in pairs(Variables[10][3][t]) do
					Variables[10][2][k] = tostring(k)
					Variables[10][3][t][k] = true
				end
			end
		end
	end
	
end

local function ResetWhisperVariables(state)
	for t, v in pairs(Variables[10][3]) do
		if t == "General" or t == state then
			for k, e in pairs(Variables[10][3][t]) do
				Variables[10][3][t][k] = true
			end
		end
	end
end

local function WhisperPreview(message, state)
	
	local chatColor = string.format("%02X", ChatTypeInfo["WHISPER"].r * 255) .. string.format("%02X", ChatTypeInfo["WHISPER"].g * 255) .. string.format("%02X", ChatTypeInfo["WHISPER"].b * 255)
	local showTimestamps = GetCVar("showTimestamps")
	local DateTime = ""
	local UserName = "[|r|cFF" .. Variables[6][classIndex] .. PlayerName .. "|r|cFF" .. chatColor .. "]: "
	if showTimestamps ~= "none" then
		DateTime = date(showTimestamps)
	end
	local e = 1
	local eventDate
	local p1 = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", "%%raffle_first")
	local p2 = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", "%%raffle_second")
	local p3 = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", "%%raffle_third")
	local OldState = state
	
	local WinChanceTable = { [1] = "90", [2] = "80", [3] = "70", [4] = "60", [5] = "50", [6] = "40", [7] = "30", [8] = "20", [9] = "10", [10] = "100" }
	local WinChanceKeyValue = 5
	if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
		WinChanceKeyValue = glrCharacter.Data.Settings.Lottery.WinChanceKey
	else
		WinChanceKeyValue = 10
	end
	local WinChanceMessage, _ = string.gsub(L["Send Info Current Win Chance"], "%%c", WinChanceTable[WinChanceKeyValue])
	
	if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
		eventDate = glrCharacter.Event[state].Date
	else
		local s = string.sub(glrCharacter.Event[state].Date, 1, string.find(glrCharacter.Event[state].Date, "%@") + 1)
		local t = GetTimeFormat(string.sub(glrCharacter.Event[state].Date, string.find(glrCharacter.Event[state].Date, "%:") - 2))
		eventDate = s .. t
	end
	
	local t = {}
	
	local default = {
		[1] = { -- Lottery Defaults
			[1] = "--------------------------------------------------",
			[2] = L["Send Info Title"] .. "%version",
			[3] = L["Send Info Event Info 1"] .. ": %event_name " .. L["Send Info Event Info 2"] .. " %event_date",
			[4] = L["Send Info Tickets Purchased First Msg 1"] .. " %tickets_current " .. L["Send Info Tickets Purchased First Msg 2"] .. " %tickets_max " .. L["Send Info Tickets Purchased First Msg 3"],
			[5] = L["Send Info Can Purchase Tickets Part 1"] .. " %tickets_difference " .. L["Send Info Can Purchase Tickets Part 2"] .. " %tickets_price " .. L["Send Info Can Purchase Tickets Part 3"],
			[6] = L["Send Info Current Jackpot Part 1"] .. " %percent_guild%. " .. L["Send Info Current Jackpot Part 2"] .. " %jackpot_first",
			
		},
		[2] = { -- Raffle Defaults
			[1] = "--------------------------------------------------",
			[2] = L["Send Info Title"] .. "%version",
			[3] = L["Send Info Event Info 1"] .. ": %event_name " .. L["Send Info Event Info 2"] .. " %event_date",
			[4] = L["Send Info Tickets Purchased First Msg 1"] .. " %tickets_current " .. L["Send Info Tickets Purchased First Msg 2"] .. " %tickets_max " .. L["Send Info Tickets Purchased First Msg 3"],
			[5] = L["Send Info Can Purchase Tickets Part 1"] .. " %tickets_difference " .. L["Send Info Can Purchase Tickets Part 2"] .. " %tickets_price " .. L["Send Info Can Purchase Tickets Part 3"],
			[6] = L["Send Info Current Prizes"] .. ":",
			[7] = p1,
		},
		[3] = {
			[1] = "--------------------------------------------------",
		},
	}
	
	if state == "Raffle" then
		e = 2
		if glrCharacter.Event[state].SecondPlace then
			default[e][8] = p2
			if glrCharacter.Event[state].ThirdPlace then
				default[e][9] = p3
			end
		end
	end
	
	if Variables[4][10] == 2 then
		default[e][4] = L["Send Info No Tickets Purchased Part 1"] .. " " .. FullPlayerName .. ". " .. L["Send Info No Tickets Purchased Part 2"]
		default[e][5] = L["Send Info Can Purchase Tickets Part 1"] .. " %tickets_max " .. L["Send Info Can Purchase Tickets Part 2"] .. " %tickets_price " .. L["Send Info Can Purchase Tickets Part 3"]
		if state == "Lottery" then
			default[e][6] = L["Send Info Reply Lottery"]
			default[e][7] = L["Send Info Current Jackpot Part 1"] .. " %percent_guild%. " .. L["Send Info Current Jackpot Part 2"] .. " %jackpot_first"
			if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				default[e][8] = WinChanceMessage
			end
		else
			default[e][6] = L["Send Info Reply Raffle"]
			default[e][7] = L["Send Info Current Prizes"] .. ":"
			default[e][8] = p1
			if glrCharacter.Event[state].SecondPlace then
				default[e][9] = p2
				if glrCharacter.Event[state].ThirdPlace then
					default[e][10] = p3
				end
			end
		end
	else
		if state == "Lottery" then
			if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				default[e][7] = WinChanceMessage
			end
		end
	end
	
	if not glrCharacter.Data.Settings["CurrentlyActive" .. state] then
		e = 3
		table.insert(default[3], L["Send Info No Active " .. state])
		state = "NA"
	end
	
	for i = 1, #default[e] do
		table.insert(t, default[e][i])
	end
	
	for v in string.gmatch(message, "[^\n]+") do
		if v ~= nil then
			v = "GLR: " .. v
			if string.len(v) > 255 then
				for i = 1, ceil(string.len(v)/250) do
					if string.len(v) > 250 then
						local c = string.sub(v, 1, 250)
						v = "GLR: " .. string.sub(v, 250)
						table.insert(t, c)
					else
						table.insert(t, v)
					end
				end
			else
				table.insert(t, v)
			end
		end
	end
	
	for i = 1, #t do
		local m = t[i]
		for j = 1, #Variables[10][1] do
			m = string.gsub(m, Variables[10][1][j], Variables[10][2][Variables[10][1][j]])
		end
		t[i] = m
	end
	
	chat:AddMessage(" ")
	for i = 1, #t do
		chat:AddMessage("|cFF" .. chatColor .. DateTime .. UserName .. t[i] .. "|r")
		if t[i + 1] == nil then
			chat:AddMessage("|cFF" .. chatColor .. DateTime .. UserName .. "--------------------------------------------------" .. "|r")
		end
	end
	chat:AddMessage(" ")
	
	ResetWhisperVariables(OldState)
	
end

function GLR_O:OptionsTable()
	
	local options = {
		name = "Guild Lottery & Raffles",
		type = "group",
		handler = GLRoptions,
		args = {
			glrInfo = {
				order = 1,
				type = "group",
				name = L["Configuration Panel Information Tab"],
				childGroups = "tab",
				args = {
					Version = {
						order = 1,
						type = "description",
						name = "|cFF87CEFAv" .. GLR_CurrentVersionString .. "|r",
					},
					Version_Author = {
						order = 2,
						type = "description",
						name = "|cFFFFE300" .. L["Configuration Panel Mod Author"] .. " |r" .. "|cffffffffTempuseteri-Area52|r", 
					},
					Version_Previous_Authors = {
						order = 3,
						type = "description",
						name = "|cFFFFE300" .. L["Configuration Panel Previous Authors"] .. " |r" .. "|cffffffffReaper_029, Malaron|r",
					},
					General_Translators = {
						order = 4,
						type = "description",
						name = "|cFFFFE300" .. L["Configuration Panel Translators"] .. " |r" .. "|cffffffffSkoldgaster (Spanish [esES]), QCElysiums (French [frFR]), taka_qiao (Chinese [zhCN]).|r",
					},
					General_Toggle_Enable = {
						order = 5,
						type = "toggle",
						name = L["Configuration Panel Toggle GLR"],
						desc = L["Configuration Panel Toggle GLR Description"],
						width = "double",
						get = function()
							local status = glrCharacter.Data.Settings.General.enabled
							if not status then
								if GLR_UI.GLR_MainFrame:IsVisible() then
									GLR_UI.GLR_MainFrame:Hide()
								end
							end
							return glrCharacter.Data.Settings.General.enabled
						end,
						set = function(info, value)
							local timestamp = GetTimeStamp()
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_Enable() - Mod Status Changed To: [" .. string.upper(tostring(value)) .. "]" )
							glrCharacter.Data.Settings.General.enabled = value
						end,
					},
					SlashCommands_Header = {
						order = 6,
						type = "header",
						name = L["Configuration Panel Slash Command List"],
					},
					SlashCommands_GLR_GUI = {
						order = 7,
						type = "description",
						name = "|cFFFFE300/glr |r" .. "|cffffffffor|r" .. "|cFFFFE300 /glr open |r" .. "|cffffffff- " .. L["Configuration Panel Open GLR Command"] .. "|r",
					},
					SlashCommands_GLR_Help = {
						order = 8,
						type = "description",
						name = "|cFFFFE300/glr help |r" .. "|cffffffff- " .. L["Configuration Panel Help Command"] .. "|r",
					},
					SlashCommands_GLR_Config = {
						order = 9,
						type = "description",
						name = "|cFFFFE300/glr config |r" .. "|cffffffff- " .. L["Configuration Panel Config Command"] .. "|r",
					},
					SlashCommands_GLR_Events = {
						order = 10,
						type = "description",
						name = "|cFFFFE300/glr events |r" .. "|cffffffff- Brings you to the Events Configuration menu.|r",
					},
					SlashCommands_GLR_Profiles = {
						order = 11,
						type = "description",
						name = "|cFFFFE300/glr profiles |r" .. "|cffffffff- Brings you to the Profiles Configuration menu.|r",
					},
					SlashCommands_GLR_Messages = {
						order = 12,
						type = "description",
						name = "|cFFFFE300/glr messages |r" .. "|cffffffff- Brings you to the Messages Configuration menu.|r",
					},
					SlashCommands_GLR_Giveaways = {
						order = 13,
						type = "description",
						name = "|cFFFFE300/glr giveaway |r" .. "|cffffffff- Brings you to the Giveaway Configuration menu.|r",
					},
					SlashCommands_GLR_MinimapToggle = {
						order = 14,
						type = "description",
						name = "|cFFFFE300/glr minimap " .. string.lower(L["Toggle"]) .. " |r" .. "|cffffffff- Toggles the display of the Minimap Icon.|r",
					},
					SlashCommands_GLR_MinimapXY = {
						order = 15,
						type = "description",
						name = "|cFFFFE300/glr minimap (X,Y) |r" .. "|cffffffff- Sets the coordinates of the Minimap Icon.|r",
					},
					SlashCommands_GLR_AlertGuild = {
						order = 16,
						type = "description",
						name = "|cFFFFE300/glr alert |r" .. "|cffffffff- Alerts your Guild about any Active Event(s).|r",
					},
					SlashCommands_GLR_Export_Lottery = {
						order = 17,
						type = "description",
						name = "|cFFFFE300/glr export " .. string.lower(L["Lottery"]) .. " |r" .. "|cffffffff- " .. "Exports the previous Lottery Event data, allowing you to copy and paste a string into a spreadsheet." .. "|r",
					},
					SlashCommands_GLR_Export_Raffle = {
						order = 18,
						type = "description",
						name = "|cFFFFE300/glr export " .. string.lower(L["Raffle"]) .. " |r" .. "|cffffffff- " .. "Exports the previous Raffle Event data, allowing you to copy and paste a string into a spreadsheet." .. "|r",
					},
					SlashCommands_GLR_Status_Name = {
						order = 19,
						type = "description",
						name = "|cFFFFE300/glr status <name> |r" .. "|cffffffff- " .. "Displays basic information for any Active Event(s) on the specified Character." .. "|r",
					},
					General_spacer_1 = {
						order = 20,
						type = "description",
						name = " ",
					},
					HowTo_Header = {
						order = 21,
						type = "header",
						name = L["Configuration Panel How To Header"],
					},
					HowTo_Step_1 = {
						order = 22,
						type = "description",
						name = "|cFF87CEFA" .. L["Configuration Panel How To Step 1 P1"] .. "|r: " .. L["Configuration Panel How To Step 1 P2"],
					},
					HowTo_Step_2 = {
						order = 23,
						type = "description",
						name = "|cFF87CEFA" .. L["Configuration Panel How To Step 2 P1"] .. "|r: " .. L["Configuration Panel How To Step 2 P2"],
					},
					HowTo_Step_3 = {
						order = 24,
						type = "description",
						name = "|cFF87CEFA" .. L["Configuration Panel How To Step 3 P1"] .. "|r: " .. L["Configuration Panel How To Step 3 P2"],
					},
					HowTo_Step_4 = {
						order = 25,
						type = "description",
						name = "|cFF87CEFA" .. L["Configuration Panel How To Step 4 P1"] .. "|r: " .. L["Configuration Panel How To Step 4 P2"],
					},
				},
			},
			generalOptions = {
				order = 2,
				type = "group",
				name = L["Configuration Panel Options Tab"],
				childGroups = "tab",
				args = {
					ConfigTab = {
						order = 1,
						type = "group",
						name = L["Configuration Panel Options Tab Config"],
						childGroups = "tab",
						args = {
							Options_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Options Header"],
							},
							GeneralTab = {
								order = 2,
								type = "group",
								name = L["Configuration Panel Options Tab General"],
								childGroups = "tab",
								args = {
									General_Header = {
										order = 1,
										type = "header",
										name = L["Configuration Panel General Options Header"],
									},
									General_Execute_GLR = {
										order = 2,
										type = "execute",
										name = L["Configuration Panel Options Open GLR Button"],
										desc = L["Configuration Panel Options Open GLR Button Desc"],
										width = "full",
										func = function()
											InterfaceOptionsFrame_Show()
											if GLR_UI.GLR_MainFrame:IsVisible() == false then
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Execute_GLR() - Attempting To Show The Main UI")
												GLR:ShowGLRFrame()
											end
										end,
									},
									General_Toggle_Escape = {
										order = 3,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Escape Key"],
										desc = L["Configuration Panel Options Toggle Escape Key Desc"],
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.ToggleEscape
										end,
										set = function(info, value)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_Escape() - Value Set To: [" .. string.upper(tostring(value)) .. "]")
											glrCharacter.Data.Settings.General.ToggleEscape = value
											GLR_U:ToggleEscapeKey()
										end,
									},
									General_Toggle_ChatInfo = {
										order = 4,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Chat Info"],
										desc = L["Configuration Panel Options Toggle Chat Info Desc"],
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.ToggleChatInfo
										end,
										set = function(info, value)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_ChatInfo() - Value Set To: [" .. string.upper(tostring(value)) .. "]")
											glrCharacter.Data.Settings.General.ToggleChatInfo = value
										end,
									},
									General_Toggle_SendLargeInfo = {
										order = 5,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Full Ticket Info"],
										desc = L["Configuration Panel Options Toggle Full Ticket Info Desc"],
										width = "normal",
										get = function()
											if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
												glrCharacter.Data.Settings.General.SendLargeInfo = false
											end
											return glrCharacter.Data.Settings.General.SendLargeInfo
										end,
										set = function(info, value)
											local timestamp = GetTimeStamp()
											if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_SendLargeInfo() - Value Set To: [" .. string.upper(tostring(value)) .. "]")
												glrCharacter.Data.Settings.General.SendLargeInfo = value
											else
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_SendLargeInfo() - Unable To Set Value. Advanced Event Setting.")
												GLR:Print(L["Configuration Panel Options Toggle Full Ticket Info Failed"])
											end
										end,
									},
									General_Toggle_MultiGuild = {
										order = 6,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Multi Guild"],
										desc = L["Configuration Panel Options Toggle Multi Guild Desc"],
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.MultiGuild
										end,
										set = function(info, value)
											local status = false
											local ActiveEventOn = ""
											local OtherToonActive = false
											if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
												status = true
											end
											if not status then --Checks your other characters to see if they have events running, preventing you from un/linking your guild while a event is active.
												if glrHistory.ActiveEvents ~= nil then
													for name, event in pairs(glrHistory.ActiveEvents) do
														if event then
															status = true
															OtherToonActive = true
															ActiveEventOn = tostring(name)
															break
														end
													end
												end
											end
											if not status then --Prevents changing this value while a Lottery/Raffle is active
												glrCharacter.Data.Settings.General.MultiGuild = value
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_MultiGuild() - Set Multi-Guild Status: [" .. string.upper(tostring(value)) .. "]")
												if glrHistory.MultiGuildStatus[FullPlayerName] ~= nil then
													glrHistory.MultiGuildStatus[FullPlayerName] = value
												end
												local continue = true
												for i = 1, 4 do
													local f = _G['StaticPopup' .. tostring(i)]
													if f:IsVisible() then
														continue = false
														break
													end
												end
												if continue then
													StaticPopup_Show("GLROPTIONCHANGED")
												end
												Variables[5][9] = false
												Variables[5][10] = false
											else
												local timestamp = GetTimeStamp()
												if not OtherToonActive then
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_MultiGuild() - Unable to change Multi-Guild Link Status. Multiple Active Events Detected.")
													GLR:Print(L["Configuration Panel Options Toggle Multi Guild Failed"])
												else
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_MultiGuild() - Unable to change Multi-Guild Link Status. Event Detected: [" .. ActiveEventOn .. "]")
													local message = string.gsub(L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"], "%%name", ActiveEventOn)
													GLR:Print(message)
												end
											end
											GLR_U:GetLinkedNames()
											GLR_U:GetLinkedGuilds()
											GLR_U:UpdateMultiGuildTable()
										end,
									},
									General_Toggle_CrossFactionEvents = {
										order = 7,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Cross Faction"],
										desc = L["Configuration Panel Options Toggle Cross Faction Desc"],
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.CrossFactionEvents
										end,
										set = function(info, value)
											local lottery = glrCharacter.Data.Settings.CurrentlyActiveLottery
											local raffle = glrCharacter.Data.Settings.CurrentlyActiveRaffle
											local timestamp = GetTimeStamp()
											if not lottery and not raffle then --Prevents changing this value while a Lottery/Raffle is active
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_CrossFactionEvents() - Set Cross-Faction Status: [" .. string.upper(tostring(value)) .. "]")
												glrCharacter.Data.Settings.General.CrossFactionEvents = value
												glrHistory.CrossFaction[FullPlayerName] = value
												Variables[5][9] = false
												Variables[5][10] = false
											else
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_CrossFactionEvents() - Unable To Change Cross-Faction Status. Active Event Detected. Lottery: [" .. string.upper(tostring(lottery)) .. "] - Raffle: [" .. string.upper(tostring(raffle)) .. "]")
												GLR:Print(L["Configuration Panel Options Toggle Cross Faction Failed"])
											end
										end,
									},
									General_Toggle_AutomatedLoginMessages = {
										order = 8,
										type = "toggle",
										name = "Disable Messages",
										desc = "Disable Login Messages\n\nIf enabled, you will no longer automatically message players upon logging in.",
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.DisableLoginMessages
										end,
										set = function(info, value)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_AutomatedLoginMessages() - Set Automatic Login Messages: [" .. string.upper(tostring(value)) .. "]")
											glrCharacter.Data.Settings.General.DisableLoginMessages = value
											local continue = true
											for i = 1, 4 do
												local f = _G['StaticPopup' .. tostring(i)]
												if f:IsVisible() then
													continue = false
													break
												end
											end
											if continue then
												StaticPopup_Show("GLROPTIONCHANGED")
											end
										end,
									},
									General_Toggle_AdvancedDraw = {
										order = 09,
										type = "toggle",
										name = "|cFF87CEFABeta:|r Advanced Draw",
										desc = "|cffff0000Attention: This feature is CPU intensive the larger your Event!|r\n\n|cff00ffffThis feature completely changes how your Events work and can only be changed while no Event is active.|r\n\nRunning Events with this active will cause players to not receive any ticket numbers until Event Draw.\nAt Event Draw ticket numbers will be randomly assigned to players and a winning ticket number selected.\n\nLottery win chance for non-guaranteed winner Events defaults to 50% unless Win Chance is changed (Event Settings).\n\nEvent Ticket Information will be available for export after Event Draw.",
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.AdvancedTicketDraw
										end,
										set = function(info, value)
											local lottery = glrCharacter.Data.Settings.CurrentlyActiveLottery
											local raffle = glrCharacter.Data.Settings.CurrentlyActiveRaffle
											local timestamp = GetTimeStamp()
											if not lottery and not raffle then --Prevents changing this value while a Lottery/Raffle is active
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_AdvancedDraw() - Set Advanced Event Status: [" .. string.upper(tostring(value)) .. "]")
												local faction, _ = UnitFactionGroup("PLAYER")
												glrHistory.DrawState[faction][FullPlayerName] = value
												glrCharacter.Data.Settings.General.AdvancedTicketDraw = value
												Variables[5][9] = false
												Variables[5][10] = false
											else
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_AdvancedDraw() - Unable To Change Advanced Event Status. Active Event Detected. Lottery: [" .. string.upper(tostring(lottery)) .. "] - Raffle: [" .. string.upper(tostring(raffle)) .. "]")
												GLR:Print(L["Configuration Panel Options Toggle Randomize Tickets Failed"])
											end
										end,
									},
									General_Toggle_CalendarEvents = {
										order = 10,
										type = "toggle",
										name = L["Configuration Panel Options Toggle Calendar Events"],
										desc = L["Configuration Panel Options Toggle Calendar Events Desc"],
										hidden = function(self) if string.lower(GLR_GameVersion) == "retail" then return false else return true end end,
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.CreateCalendarEvents
										end,
										set = function(info, value)
											--Don't need additional Debug tracking here as it's inside the GLR_C:Toggle() function.
											GLR_C:CalendarToggle()
										end,
									},
									General_Toggle_ReplyToSender = {
										order = 11,
										type = "toggle",
										name = "Confirmation Mail",
										desc = "When scanning your mailbox for valid entries, with this option enabled, the AddOn will send a confirmation reply.\nDo be aware that enabling this feature will consume the normal rate of 30 copper per reply.\nReplies are lumped into one mail per sender to reduce cost.",
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.ReplyToSender
										end,
										set = function(_, value)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_ReplyToSender() - Set Reply-To-Sender Status: [" .. string.upper(tostring(value)) .. "]")
											glrCharacter.Data.Settings.General.ReplyToSender = value
										end,
									},
									General_Description_Spacer = {
										order = 12,
										type = "description",
										name = "",
										width = "full",
									},
									General_Select_TimeFormat = {
										order = 13,
										type = "select",
										name = "Time Format",
										desc = "Changes how Time Tormats are displayed in:\n- Guild Alerts\n- Ticket Info Messages\n- More Coming Soon™",
										width = "normal",
										style = "dropdown",
										values = function()
											local t = { [1] = "19:30", [2] = "7:30 PM" }
											return t
										end,
										get = function()
											return glrCharacter.Data.Settings.General.TimeFormatKey
										end,
										set = function(_, key)
											glrCharacter.Data.Settings.General.TimeFormatKey = key
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Select_TimeFormat() - Set Time Format Key To: [" .. tostring(key) .. "]")
										end,
									},
									General_Select_DateFormat = {
										order = 14,
										type = "select",
										name = "Date Format",
										width = "normal",
										desc = function(self)
											local text = "Change how Date Formats are displayed.\n\n|cFF87CEFA MM/DD/YY |r-> Displays as %mmddyy\n\n|cFF87CEFA DD/MM/YY |r-> Displays as %ddmmyy"
											local t = date("*t", GetServerTime())
											local mm = tonumber(t.month)
											local dd = tonumber(t.day)
											local yy = string.sub(t.year, 3)
											if mm < 10 then
												mm = "0" .. tostring(mm)
											end
											if dd < 10 then
												dd = "0" .. tostring(dd)
											end
											local mdy = mm .. "/" .. dd .. "/" .. yy
											local dmy = dd .. "/" .. mm .. "/" .. yy
											text = string.gsub(string.gsub(text, "%%mmddyy", mdy), "%%ddmmyy", dmy)
											return text
										end,
										style = "dropdown",
										values = function()
											local t = { [1] = "MM/DD/YY", [2] = "DD/MM/YY" }
											return t
										end,
										get = function()
											return glrCharacter.Data.Settings.General.DateFormatKey
										end,
										set = function(_, key)
											local function ChangeDateFormat(state)
												local previous = glrCharacter.Data.Settings.General.DateFormatKey
												local Month
												local Day
												local EventDate = glrCharacter.Event[state].Date
												local Remaining = string.sub(EventDate, 7)
												local New
												if previous == 1 then --Change to DD/MM/YY Format
													Month = string.sub(EventDate, 1, 2)
													Day = string.sub(EventDate, 4, 5)
													New = Day .. "/" .. Month .. "/" .. Remaining
												elseif previous == 2 then --Change to MM/DD/YY Format
													Month = string.sub(EventDate, 4, 5)
													Day = string.sub(EventDate, 1, 2)
													New = Month .. "/" .. Day .. "/" .. Remaining
												end
												glrCharacter.Event[state].Date = New
											end
											if glrCharacter.Data.Settings.CurrentlyActiveLottery then
												ChangeDateFormat("Lottery")
											end
											if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
												ChangeDateFormat("Raffle")
											end
											glrCharacter.Data.Settings.General.DateFormatKey = key
											GLR_U:UpdateInfo(false)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Select_DateFormat() - Set Date Format Key To: [" .. tostring(key) .. "]")
										end,
									},
									General_Range_TimeBetweenAlerts = {
										order = 20,
										type = "range",
										name = L["Configuration Panel Options Time Between Alerts"],
										desc = L["Configuration Panel Options Time Between Alerts Desc"],
										width = "full",
										min = 30,
										max = 600,
										step = 1,
										get = function()
											return glrCharacter.Data.Settings.General.TimeBetweenAlerts
										end,
										set = function(info, value)
											glrCharacter.Data.Settings.General.TimeBetweenAlerts = value
										end,
									},
								},
							},
							General_MinimapTab = {
								order = 3,
								type = "group",
								name = L["Configuration Panel Options Tab Minimap"],
								childGroups = "tab",
								args = {
									General_Minimap_Header = {
									 order = 1,
									 type = "header",
									 name = L["Configuration Panel Options Minimap Header"],
									},
									General_Toggle_Minimap = {
										order = 2,
										type = "toggle",
										name = L["Configuration Panel Options Minimap Toggle"],
										desc = L["Configuration Panel Options Minimap Toggle Desc"],
										width = "double",
										get = function()
											return glrCharacter.Data.Settings.General.mini_map
										end,
										set = function(_, value)
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_Minimap() - Minimap Icon Status Changed To: [" .. string.upper(tostring(value)) .. "]" )
											glrCharacter.Data.Settings.General.mini_map = value
											GLR_U:UpdateMinimapIcon()
										end,
									},
									General_Toggle_MinimapEdge = {
										order = 3,
										type = "toggle",
										name = "Stick Icon Edge",
										desc = "When dragging the Icon along the Minimap border, with this enabled, the Icon edge will travel along the Minimap Edge.\nWith this disabled the Icon's center will travel along the Minimap Edge.",
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.MinimapEdge
										end,
										set = function(_, value)
											glrCharacter.Data.Settings.General.MinimapEdge = value
											local timestamp = GetTimeStamp()
											table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - General_Toggle_MinimapEdge() - Set Minimap Edge State: [" .. string.upper(tostring(value)) .. "]")
										end,
									},
									General_Range_MinimapX = {
										order = 4,
										type = "range",
										name = L["Configuration Panel Options Minimap X Range"],
										desc = L["Configuration Panel Options Minimap X Range Desc"],
										width = "full",
										min = -math.floor( Minimap:GetSize() / 2 + ( GLR_UI.GLR_MinimapButton:GetSize() / 2 ) ),
										max = math.floor( Minimap:GetSize() / 2 + ( GLR_UI.GLR_MinimapButton:GetSize() / 2 ) ),
										step = 0.1,
										get = function()
											local n = tonumber(string.format("%.1f", glrCharacter.Data.Settings.General.MinimapXOffset))
											return n
										end,
										set = function(info, value)
											glrCharacter.Data.Settings.General.MinimapXOffset = value
											GLR_U:UpdateMinimapIcon()
										end,
									},
									General_Range_MinimapY = {
										order = 5,
										type = "range",
										name = L["Configuration Panel Options Minimap Y Range"],
										desc = L["Configuration Panel Options Minimap Y Range Desc"],
										width = "full",
										min = -math.floor( Minimap:GetSize() / 2 + ( GLR_UI.GLR_MinimapButton:GetSize() / 2 ) ),
										max = math.floor( Minimap:GetSize() / 2 + ( GLR_UI.GLR_MinimapButton:GetSize() / 2 ) ),
										step = 0.1,
										get = function ()
											local n = tonumber(string.format("%.1f", glrCharacter.Data.Settings.General.MinimapYOffset))
											return n
										end,
										set = function(info, value)
											glrCharacter.Data.Settings.General.MinimapYOffset = value
											GLR_U:UpdateMinimapIcon()
										end,
									},
								},
							},
							MultiGuildsTab = {
								order = 4,
								type = "group",
								name = L["Configuration Panel Options Tab Multi-Guild"],
								childGroups = "tab",
								args = {
									MultiGuilds_Header = {
										order = 1,
										type = "header",
										name = L["Configuration Panel Options Guild Header"],
									},
									MultiGuilds_Description = {
										order = 2,
										type = "description",
										name = L["Configuration Panel Options Multi-Guild Description"],
										width = "full",
									},
									MultiGuilds_NoGuilds_Header = {
										order = 3,
										type = "header",
										name = "",
										hidden = function(self)
											local t = { ["Alliance"] = {}, ["Horde"] = {}, }
											local count = 0
											for f, v in pairs(glrHistory.GuildFaction) do
												for e, g in pairs(glrHistory.GuildFaction[f]) do
													if t[f][g] == nil then
														t[f][g] = tostring(e)
														count = count + 1
													end
												end
											end
											if count >= 2 then return true else return false end
										end,
										name = "Multi-Guilds: No Guilds Detected",
									},
									MultiGuilds_NoGuilds_Description = {
										order = 4,
										type = "description",
										hidden = function(self)
											local t = { ["Alliance"] = {}, ["Horde"] = {}, }
											local count = 0
											local doBreak = false
											for f, v in pairs(glrHistory.GuildFaction) do
												for e, g in pairs(glrHistory.GuildFaction[f]) do
													if t[f][g] == nil then
														t[f][g] = tostring(e)
														count = count + 1
													end
												end
											end
											if count >= 2 then return true else return false end
										end,
										name = "No valid Guilds were detected. Before Multi-Guild Events can function, at least two different Guilds must exist.",
										width = "full",
									},
									MultiGuilds_LinkedGuilds = {
										order = 8,
										type = "multiselect",
										--hidden = function(self) return Variables[9][1][2] end,
										hidden = function(self)
											local t = {}
											local c = 0
											local n = 1
											for k, v in pairs(glrHistory.CharacterGuilds) do
												if t[glrHistory.CharacterGuilds[k]] == nil then
													t[n] = glrHistory.CharacterGuilds[k]
													n = n + 1
												end
											end
											for k, v in pairs(glrHistory.GuildStatus) do
												for i = 1, #t do
													if glrHistory.GuildStatus[k][t[i]] ~= nil then
														if glrHistory.GuildStatus[k][t[i]] then
															c = c + 1
														end
													end
												end
											end
											if c >= 2 then Variables[9][1][2] = false else Variables[9][1][2] = true end
											return Variables[9][1][2]
										end,
										name = L["Configuration Panel Options Multi-Guild Linked Guilds"],
										desc = L["Configuration Panel Options Multi-Guild Tooltip"],
										width = "full",
										values = glrTempGuilds,
										get = function(info, key)
											local guild = string.sub(glrTempGuilds[key], 1, string.find(glrTempGuilds[key], '-') - 2)
											local doBreak = false
											Variables[9][1][1] = 0
											Variables[9][1][2] = false
											for i = 1, #glrHistory.Names do
												local name = glrHistory.Names[i]
												if glrHistory.CharacterGuilds[name] == guild then
													for t, v in pairs(glrHistory.CharacterGuilds) do
														if glrHistory.CharacterGuilds[name] == v then
															Variables[9][1][1] = Variables[9][1][1] + 1
															local faction = glrHistory.PlayerFaction[name]
															local status = glrHistory.MultiGuildStatus[name]
															glrHistory.GuildStatus[faction][v] = status
															local GuildName = glrHistory.GuildStatus[faction][v]
															if status then
																doBreak = true
																return glrHistory.GuildStatus[faction][v]
															end
														end
													end
												end
												if doBreak then
													break
												end
												if Variables[9][1][1] > 0 then Variables[9][1][2] = false Variables[9][1][3] = false end
											end
										end,
										set = function(info, key, value)
											local guild = string.sub(glrTempGuilds[key], 1, string.find(glrTempGuilds[key], '-') - 2)
											local status = false
											local ActiveEventOn = ""
											local OtherToonActive = false
											if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
												status = true
											end
											if not status then --Checks your other characters to see if they have events running, preventing you from un/linking your guild while a event is active.
												if glrHistory.ActiveEvents ~= nil then
													for t, v in pairs(glrHistory.ActiveEvents) do
														if v then
															status = true
															OtherToonActive = true
															ActiveEventOn = tostring(t)
															break
														end
													end
												end
											end
											local timestamp = GetTimeStamp()
											if not status then --Prevents changing this value while a Lottery/Raffle is active
												for i = 1, #glrHistory.Names do
													local name = glrHistory.Names[i]
													if glrHistory.CharacterGuilds[name] == guild then
														for t, v in pairs(glrHistory.CharacterGuilds) do
															if glrHistory.CharacterGuilds[name] == v then
																local faction = glrHistory.PlayerFaction[name]
																glrHistory.MultiGuildStatus[name] = value
																glrHistory.GuildStatus[faction][v] = value
																table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_LinkedGuilds() - Setting Link Status. Character: [" .. name .. "] - Guild: [" .. glrHistory.CharacterGuilds[name] .. "] - Link: [" .. string.upper(tostring(value)) .. "]")
																local continue = true
																for i = 1, 4 do
																	local f = _G['StaticPopup' .. tostring(i)]
																	if f:IsVisible() then
																		continue = false
																		break
																	end
																end
																if continue then
																	StaticPopup_Show("GLROPTIONCHANGED")
																end
															end
														end
														if name == FullPlayerName then
															glrCharacter.Data.Settings.General.MultiGuild = value
															local continue = true
															for i = 1, 4 do
																local f = _G['StaticPopup' .. tostring(i)]
																if f:IsVisible() then
																	continue = false
																	break
																end
															end
															if continue then
																StaticPopup_Show("GLROPTIONCHANGED")
															end
														end
													end
												end
											else
												if not OtherToonActive then
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_LinkedGuilds() - Unable to change Multi-Guild Link Status. Multiple Active Events Detected.")
													GLR:Print(L["Configuration Panel Options Toggle Multi Guild Failed"])
												else
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_LinkedGuilds() - Unable to change Multi-Guild Link Status. Event Detected: [" .. ActiveEventOn .. "]")
													local message = string.gsub(L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"], "%%name", ActiveEventOn)
													GLR:Print(message)
												end
											end
											GLR_U:GetLinkedNames()
											GLR_U:GetLinkedGuilds()
										end,
									},
									MultiGuilds_PlayerNames = {
										order = 9,
										type = "multiselect",
										--hidden = function(self) return Variables[9][1][3] end,
										hidden = function(self)
											for t, v in pairs(glrTempNames) do
												if glrTempNames[t] ~= nil then
													Variables[9][1][3] = false
													break
												else Variables[9][1][3] = true end
											end
											return Variables[9][1][3]
										end,
										name = L["Configuration Panel Options Multi-Guild Linked Characters"],
										desc = L["Configuration Panel Options Multi-Guild Tooltip"],
										width = "full",
										values = glrTempNames,
										get = function(info, key)
											local name = glrTempNames[key]
											-- for t, v in pairs(glrTempNames) do
												-- if glrTempNames[t] ~= nil then
													-- Variables[9][1][3] = false
													-- break
												-- end
											-- end
											return glrHistory.MultiGuildStatus[name]
										end,
										set = function(info, key, value)
											local name = glrTempNames[key]
											local status = false
											local ActiveEventOn = ""
											local OtherToonActive = false
											if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
												status = true
											end
											if not status then --Checks your other characters to see if they have events running, preventing you from un/linking your guild while a event is active.
												if glrHistory.ActiveEvents ~= nil then
													for t, v in pairs(glrHistory.ActiveEvents) do
														if v then
															status = true
															OtherToonActive = true
															ActiveEventOn = tostring(t)
															break
														end
													end
												end
											end
											local timestamp = GetTimeStamp()
											if not status then --Prevents changing this value while a Lottery/Raffle is active
												if name ~= nil then
													glrHistory.MultiGuildStatus[name] = value
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_PlayerNames() - Setting Link Status. Character: [" .. name .. "] - Guild: [" .. glrHistory.CharacterGuilds[name] .. "] - Link: [" .. string.upper(tostring(value)) .. "]")
													if name == FullPlayerName then
														glrCharacter.Data.Settings.General.MultiGuild = value
													end
													local continue = true
													for i = 1, 4 do
														local f = _G['StaticPopup' .. tostring(i)]
														if f:IsVisible() then
															continue = false
															break
														end
													end
													if continue then
														StaticPopup_Show("GLROPTIONCHANGED")
													end
												end
											else
												if not OtherToonActive then
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_PlayerNames() - Unable to change Multi-Guild Link Status. Multiple Active Events Detected.")
													GLR:Print(L["Configuration Panel Options Toggle Multi Guild Failed"])
												else
													table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MultiGuilds_PlayerNames() - Unable to change Multi-Guild Link Status. Event Detected: [" .. ActiveEventOn .. "]")
													local message = string.gsub(L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"], "%%name", ActiveEventOn)
													GLR:Print(message)
												end
											end
											GLR_U:GetLinkedNames()
											GLR_U:GetLinkedGuilds()
										end,
									},
								},
							},
							TransferDataTab = {
								order = 5,
								type = "group",
								name = L["Configuration Panel Options Tab Transfer"],
								childGroups = "tree",
								args = {
									TransferData_Header = {
										order = 1,
										type = "header",
										name = L["Configuration Panel Options Transfer Header"],
									},
									TransferData_Lottery = {
										order = 2,
										type = "group",
										name = L["Lottery"],
										childGroups = "tree",
										args = {
											TransferData_Select_Lottery_Names = {
												order = 1,
												type = "select",
												name = function(info) return string.gsub(L["Configuration Panel Options Transfer Select Name"], "%%event", L["Lottery"]) end,
												desc = function(info) return string.gsub(L["Configuration Panel Options Transfer Select Name Desc"], "%%event", L["Lottery"]) end,
												style = "dropdown",
												width = "normal",
												values = function()
													local status = glrCharacter.Data.Settings.General.MultiGuild
													local errors = { ["Names"] = {}, ["Class"] = {}, ["Reasons"] = { ["Advanced"] = {}, ["Faction"] = {}, ["Guild"] = {}, ["Multi"] = {}, ["Chance"] = {}, }, }
													local t = {}
													local c = 0
													Variables[8][6] = {}
													local timestamp = GetTimeStamp()
													if glrHistory.TransferAvailable.Lottery ~= nil then
														if glrHistory.TransferAvailable.Lottery[FullPlayerName] ~= nil then
															for id, val in pairs(glrHistory.TransferAvailable.Lottery) do
																local continue = false
																local doError = true
																if id ~= FullPlayerName then
																	if glrHistory.TransferAvailable.Lottery[id] then
																		if glrHistory.MultiGuildStatus[id] == status then
																			if glrHistory.CharacterGuilds[FullPlayerName] == glrHistory.CharacterGuilds[id] or status then
																				local doContinue = true
																				if glrHistory.PlayerFaction[FullPlayerName] == glrHistory.PlayerFaction[id] or glrHistory.CrossFaction[FullPlayerName] == glrHistory.CrossFaction[id] then
																					if glrHistory.PlayerFaction[FullPlayerName] ~= glrHistory.PlayerFaction[id] then
																						doContinue = false
																					end
																					if glrHistory.CrossFaction[FullPlayerName] ~= glrHistory.CrossFaction[id] then
																						doContinue = false
																					end
																				else doContinue = false end
																				if doContinue then
																					if glrHistory.DrawState[glrHistory.PlayerFaction[id]][id] == glrHistory.DrawState[glrHistory.PlayerFaction[FullPlayerName]][FullPlayerName] then
																						if glrHistory.DrawState[glrHistory.PlayerFaction[id]][id] then
																							if glrHistory.TransferData[id].Data.Settings.WinChanceKey == glrCharacter.Data.Settings.Lottery.WinChanceKey then
																								continue = true
																								doError = false
																								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - ADDED Event originating from [" .. tostring(id) .. "]")
																							else
																								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [WINCHANCE]")
																							end
																						else
																							continue = true
																							doError = false
																						end
																					else
																						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [ADVANCEDEVENT]")
																					end
																				else
																					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [FACTION]")
																				end
																			else
																				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [GUILDNAME]")
																			end
																		else
																			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [MULTIGUILD]")
																		end
																	end
																end
																if continue then
																	table.insert(t, id)
																	c = c + 1
																	Variables[8][6][c] = id
																end
																if doError then
																	if glrHistory.TransferAvailable.Lottery[id] and FullPlayerName ~= tostring(id) then
																		table.insert(errors.Names, tostring(id))
																		if glrHistory.MultiGuildStatus[id] ~= status then
																			table.insert(errors.Reasons.Multi, tostring(id))
																		end
																		if glrHistory.CharacterGuilds[FullPlayerName] ~= glrHistory.CharacterGuilds[id] and not status then
																			table.insert(errors.Reasons.Guild, tostring(id))
																		end
																		if glrHistory.PlayerFaction[FullPlayerName] ~= glrHistory.PlayerFaction[id] or glrHistory.CrossFaction[FullPlayerName] ~= glrHistory.CrossFaction[id] then
																			--GLR:Print("Player: " .. glrHistory.PlayerFaction[FullPlayerName] .. " - Target: " .. glrHistory.PlayerFaction[id])
																			--GLR:Print("Player: " .. tostring(glrHistory.CrossFaction[FullPlayerName]) .. " - Target: " .. tostring(glrHistory.CrossFaction[id]))
																			table.insert(errors.Reasons.Faction, tostring(id))
																		end
																		if glrHistory.DrawState[glrHistory.PlayerFaction[id]][id] ~= glrHistory.DrawState[glrHistory.PlayerFaction[FullPlayerName]][FullPlayerName] then
																			table.insert(errors.Reasons.Advanced, tostring(id))
																		end
																		if glrHistory.TransferData[id].Data.Settings.WinChanceKey ~= glrCharacter.Data.Settings.Lottery.WinChanceKey then
																			table.insert(errors.Reasons.Chance, tostring(id))
																		end
																	end
																end
															end
														else
															table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - [ glrHistory.TransferAvailable.Lottery[FullPlayerName] ] Table NIL")
														end
													else
														table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - [ glrHistory.TransferAvailable.Lottery ] Table NIL")
													end
													local msgs = {}
													local text = "Potential Lottery Event(s) Detected, Originating From:"
													if #errors.Names > 0 then
														local list = { [1] = "Faction", [2] = "Multi", [3] = "Guild", [4] = "Advanced", [5] = "Chance" }
														local errorMsgs = {
															["Multi"] = "Multi-Guild",
															["Guild"] = "Guild Name",
															["Faction"] = "Cross-Faction",
															["Advanced"] = "Advanced Draw",
															["Chance"] = "Win Chance",
														}
														for i = 1, #errors.Names do
															local prepare = ""
															local compare = ""
															local color = "NA"
															for k, v in pairs(glrHistory.PlayerClass) do
																local doBreak = false
																for id, val in pairs(glrHistory.PlayerClass[k]) do
																	if tostring(id) == errors.Names[i] then
																		color = val
																		doBreak = true
																		break
																	end
																end
																if doBreak then break end
															end
															errors.Class[errors.Names[i]] = color
															if i == 1 then
																if errors.Names[i + 1] == nil then
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r"
																else
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r,"
																end
															else
																if errors.Names[i + 1] == nil then
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r"
																else
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r,"
																end
															end
															if string.len(text .. prepare) > 255 then
																table.insert(msgs, text)
																text = prepare
															else
																text = text .. prepare
															end
															if errors.Names[i + 1] == nil then
																table.insert(msgs, text)
															end
														end
														for i = 1, #errors.Names do
															table.insert(msgs, " ")
															text = "The Character|cFF" .. ClassColorStrings[errors.Class[errors.Names[i]]] .. " " .. errors.Names[i] .. "|r has these settings, which are different from yours: | "
															for e = 1, #list do
																for j = 1, #errors.Reasons[list[e]] do
																	if errors.Reasons[list[e]][j] == errors.Names[i] then
																		text = text .. errorMsgs[list[e]] .. " | "
																	end
																end
															end
															table.insert(msgs, text)
														end
													end
													if #errors.Names > 0 and not Variables[5][9] then
														chat:AddMessage(" ")
														for i = 1, #msgs do
															chat:AddMessage(msgs[i])
														end
														chat:AddMessage(" ")
														chat:AddMessage("Type|cfff7ff4d /glr status <name>|r for detailed information about their Event(s).")
														chat:AddMessage(" ")
													end
													if c == 0 then
														if #errors.Names > 0 and not Variables[5][9] then
															if not Variables[5][9] then
																Variables[5][9] = true
																GLR:Print("Detected [" .. #errors.Names .. "] potential Lottery Event(s) to transfer. Please insure all Config settings match from the originating Character. See above for additional information.")
															end
															local timestamp = GetTimeStamp()
															table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - Detected [" .. c .. "] potential Event(s) to transfer.")
														end
														table.insert(t, L["GLR - Error - No Entries Found"])
														return t
													else
														local d = 1
														if #errors.Names > 0 then
															if not Variables[5][9] then
																Variables[5][9] = true
																d = d + #errors.Names - c
																GLR:Print("Detected an additional [" .. d .. "] potential Lottery Event(s) to transfer. Please insure all Config settings match from the originating Character. See above for additional information.")
															end
															local timestamp = GetTimeStamp()
															table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Lottery_Names() - Detected an additional [" .. d .. "] potential Event(s) to transfer.")
														end
														sort(Variables[8][6])
														sort(t)
														return t
													end
												end,
												get = function()
													return Variables[4][6]
												end,
												set = function(_, key)
													Variables[4][6] = key
												end,
											},
											TransferData_Toggle_ConfirmLottery = {
												order = 2,
												type = "toggle",
												name = L["GLR - UI > Config - Confirm Action"],
												hidden = function(self) if Variables[8][6][1] ~= nil then if Variables[8][6][1] == L["GLR - Error - No Entries Found"] then return true else return false end else return true end end,
												get = function()
													return Variables[5][3]
												end,
												set = function(info, val)
													Variables[5][3] = val
												end,
											},
											TransferData_Execute_Lottery = {
												order = 3,
												type = "execute",
												name = L["Configuration Panel Options Transfer Data"],
												desc = function(info) return string.gsub(L["Configuration Panel Options Transfer Data Desc"], "%%event", L["Lottery"]) end,
												hidden = function(self) if Variables[5][3] then return false else return true end end,
												width = "normal",
												func = function()
													if Variables[5][3] and Variables[4][6] ~= 0 then
														local name = Variables[8][6][Variables[4][6]]
														if name ~= L["GLR - Error - No Entries Found"] then
															if not glrHistory.TransferStatus.Lottery[name] then
																glrHistory.TransferStatus.Lottery[name] = true
																glrHistory.TransferAvailable.Lottery[name] = false
																glrCharacter.Event.Lottery = glrHistory.TransferData[name].Event.Lottery
																glrCharacter.Lottery = glrHistory.TransferData[name].Lottery
																glrCharacter.Data.Settings.PreviousLottery = glrHistory.TransferData[name].Data.Settings.PreviousLottery
																glrCharacter.Data.Settings.General.TicketSeries = glrHistory.TransferData[name].Data.Settings.TicketSeries
																glrCharacter.Data.OtherStatus.Lottery = glrHistory.TransferData[name].Data.OtherStatus.Lottery
																glrCharacter.Data.Settings.Lottery.NoGuildCut = glrHistory.TransferData[name].Data.Settings.NoGuildCut
																glrCharacter.Data.Settings.Lottery.WinChanceKey = glrHistory.TransferData[name].Data.Settings.WinChanceKey
																glrCharacter.Data.Settings.General.DateFormatKey = glrHistory.TransferData[name].Data.Settings.DateFormatKey
																glrCharacter.Data.Settings.CurrentlyActiveLottery = true
																glrHistory.TransferData[name].Data.Settings.NoGuildCut = nil
																glrHistory.TransferData[name].Data.OtherStatus.Lottery = nil
																glrHistory.TransferData[name].Data.Settings.PreviousLottery = nil
																glrHistory.TransferData[name].Data.Settings.TicketSeries = nil
																glrHistory.TransferData[name].Lottery = nil
																glrHistory.TransferData[name].Event.Lottery = nil
																Variables[5][3] = false
																GLR_U:UpdateInfo(true)
																if not glrHistory.TransferAvailable.Lottery[name] and not glrHistory.TransferAvailable.Raffle[name] then
																	glrHistory.ActiveEvents[name] = false
																end
																local timestamp = GetTimeStamp()
																table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Execute_Lottery() - Transfer Of Event Data From: [" .. name .. "] - Complete." )
																local message = string.gsub(L["Configuration Panel Options Transfer Completed"], "%%name", name)
																GLR:Print(message)
															end
														end
													end
												end,
											},
										},
									},
									TransferData_Raffle = {
										order = 3,
										type = "group",
										name = L["Raffle"],
										childGroups = "tree",
										args = {
											TransferData_Select_Raffle_Names = {
												order = 1,
												type = "select",
												name = function(info) return string.gsub(L["Configuration Panel Options Transfer Select Name"], "%%event", L["Raffle"]) end,
												desc = function(info) return string.gsub(L["Configuration Panel Options Transfer Select Name Desc"], "%%event", L["Raffle"]) end,
												style = "dropdown",
												width = "normal",
												values = function()
													local status = glrCharacter.Data.Settings.General.MultiGuild
													local errors = { ["Names"] = {}, ["Class"] = {}, ["Reasons"] = { ["Advanced"] = {}, ["Faction"] = {}, ["Guild"] = {}, ["Multi"] = {}, }, }
													local t = {}
													local c = 0
													Variables[8][7] = {}
													if glrHistory.TransferAvailable.Raffle ~= nil then
														if glrHistory.TransferAvailable.Raffle[FullPlayerName] ~= nil then
															for id, val in pairs(glrHistory.TransferAvailable.Raffle) do
																local continue = false
																local doError = true
																if id ~= FullPlayerName then
																	if glrHistory.TransferAvailable.Raffle[id] then
																		local timestamp = GetTimeStamp()
																		if glrHistory.MultiGuildStatus[id] == status then
																			if glrHistory.CharacterGuilds[FullPlayerName] == glrHistory.CharacterGuilds[id] or status then
																				local doContinue = true
																				if glrHistory.PlayerFaction[FullPlayerName] == glrHistory.PlayerFaction[id] or glrHistory.CrossFaction[FullPlayerName] == glrHistory.CrossFaction[id] then
																					if glrHistory.PlayerFaction[FullPlayerName] ~= glrHistory.PlayerFaction[id] then
																						doContinue = false
																					end
																					if glrHistory.CrossFaction[FullPlayerName] ~= glrHistory.CrossFaction[id] then
																						doContinue = false
																					end
																				else doContinue = false end
																				if doContinue then
																					if glrHistory.DrawState[glrHistory.PlayerFaction[id]][id] == glrHistory.DrawState[glrHistory.PlayerFaction[FullPlayerName]][FullPlayerName] then
																						continue = true
																						doError = false
																						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - ADDED Event originating from [" .. tostring(id) .. "]")
																					else
																						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [ADVANCEDEVENT]")
																					end
																				else
																					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [FACTION]")
																				end
																			else
																				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [GUILDNAME]")
																			end
																		else
																			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - UNABLE to add Event originating from [" .. tostring(id) .. "] due to [MULTIGUILD]")
																		end
																	end
																end
																if continue then
																	table.insert(t, id)
																	c = c + 1
																	Variables[8][7][c] = id
																end
																if doError then
																	if glrHistory.TransferAvailable.Raffle[id] and FullPlayerName ~= tostring(id) then
																		table.insert(errors.Names, tostring(id))
																		if glrHistory.MultiGuildStatus[id] ~= status then
																			table.insert(errors.Reasons.Multi, tostring(id))
																		end
																		if glrHistory.CharacterGuilds[FullPlayerName] ~= glrHistory.CharacterGuilds[id] and not status then
																			table.insert(errors.Reasons.Guild, tostring(id))
																		end
																		if glrHistory.PlayerFaction[FullPlayerName] ~= glrHistory.PlayerFaction[id] or glrHistory.CrossFaction[FullPlayerName] ~= glrHistory.CrossFaction[id] then
																			table.insert(errors.Reasons.Faction, tostring(id))
																		end
																		if glrHistory.DrawState[glrHistory.PlayerFaction[id]][id] ~= glrHistory.DrawState[glrHistory.PlayerFaction[FullPlayerName]][FullPlayerName] then
																			table.insert(errors.Reasons.Advanced, tostring(id))
																		end
																	end
																end
															end
														end
													end
													local msgs = {}
													local text = "Potential Raffle Event(s) Detected, Originating From:"
													if #errors.Names > 0 then
														local list = { [1] = "Faction", [2] = "Multi", [3] = "Guild", [4] = "Advanced" }
														local errorMsgs = {
															["Multi"] = "Multi-Guild",
															["Guild"] = "Guild Name",
															["Faction"] = "Cross-Faction",
															["Advanced"] = "Advanced Draw",
														}
														for i = 1, #errors.Names do
															local prepare = ""
															local compare = ""
															local color = "NA"
															for k, v in pairs(glrHistory.PlayerClass) do
																local doBreak = false
																for id, val in pairs(glrHistory.PlayerClass[k]) do
																	if tostring(id) == errors.Names[i] then
																		color = val
																		doBreak = true
																		break
																	end
																end
																if doBreak then break end
															end
															errors.Class[errors.Names[i]] = color
															if i == 1 then
																if errors.Names[i + 1] == nil then
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r"
																else
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r,"
																end
															else
																if errors.Names[i + 1] == nil then
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r"
																else
																	prepare = "|cFF" .. ClassColorStrings[color] .. " " .. errors.Names[i] .. "|r,"
																end
															end
															if string.len(text .. prepare) > 255 then
																table.insert(msgs, text)
																text = prepare
															else
																text = text .. prepare
															end
															if errors.Names[i + 1] == nil then
																table.insert(msgs, text)
															end
														end
														for i = 1, #errors.Names do
															table.insert(msgs, " ")
															text = "The Character|cFF" .. ClassColorStrings[errors.Class[errors.Names[i]]] .. " " .. errors.Names[i] .. "|r has these settings, which are different from yours: | "
															for e = 1, #list do
																for j = 1, #errors.Reasons[list[e]] do
																	if errors.Reasons[list[e]][j] == errors.Names[i] then
																		text = text .. errorMsgs[list[e]] .. " | "
																	end
																end
															end
															table.insert(msgs, text)
														end
													end
													if #errors.Names > 0 and not Variables[5][10] then
														chat:AddMessage(" ")
														for i = 1, #msgs do
															chat:AddMessage(msgs[i])
														end
														chat:AddMessage(" ")
														chat:AddMessage("Type|cfff7ff4d /glr status <name>|r for detailed information about their Event(s).")
														chat:AddMessage(" ")
													end
													if c == 0 then
														if #errors.Names > 0 and not Variables[5][10] then
															if not Variables[5][10] then
																Variables[5][10] = true
																GLR:Print("Detected [" .. #errors.Names .. "] potential Raffle Event(s) to transfer. Please insure all Config settings match from the originating Character. See above for additional information.")
															end
															local timestamp = GetTimeStamp()
															table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - Detected [" .. c .. "] potential Event(s) to transfer.")
														end
														table.insert(t, L["GLR - Error - No Entries Found"])
														return t
													else
														local d = 1
														if #errors.Names > 0 then
															if not Variables[5][10] then
																Variables[5][10] = true
																d = d + #errors.Names - c
																GLR:Print("Detected an additional [" .. d .. "] potential Raffle Event(s) to transfer. Please insure all Config settings match from the originating Character. See above for additional information.")
															end
															local timestamp = GetTimeStamp()
															table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Select_Raffle_Names() - Detected an additional [" .. d .. "] potential Event(s) to transfer.")
														end
														sort(Variables[8][6])
														sort(t)
														return t
													end
												end,
												get = function()
													return Variables[4][7]
												end,
												set = function(_, key)
													Variables[4][7] = key
												end,
											},
											TransferData_Toggle_ConfirmRaffle = {
												order = 2,
												type = "toggle",
												name = L["GLR - UI > Config - Confirm Action"],
												width = "normal",
												hidden = function(self) if Variables[8][7][1] ~= nil then if Variables[8][7][1] == L["GLR - Error - No Entries Found"] then return true else return false end else return true end end,
												get = function()
													return Variables[5][4]
												end,
												set = function(info, val)
													Variables[5][4] = val
												end,
											},
											TransferData_Execute_Raffle = {
												order = 3,
												type = "execute",
												name = L["Configuration Panel Options Transfer Data"],
												desc = function(info) return string.gsub(L["Configuration Panel Options Transfer Data Desc"], "%%event", L["Raffle"]) end,
												width = "normal",
												hidden = function(self) if Variables[5][4] then return false else return true end end,
												func = function()
													if Variables[5][4] and Variables[4][7] ~= 0 then
														local name = Variables[8][7][Variables[4][7]]
														if name ~= L["GLR - Error - No Entries Found"] then
															if not glrHistory.TransferStatus.Raffle[name] then
																glrHistory.TransferStatus.Raffle[name] = true
																glrHistory.TransferAvailable.Raffle[name] = false
																glrCharacter.Event.Raffle = glrHistory.TransferData[name].Event.Raffle
																glrCharacter.Raffle = glrHistory.TransferData[name].Raffle
																glrCharacter.Data.Raffle = glrHistory.TransferData[name].Data.Raffle
																glrCharacter.Data.Settings.General.RaffleSeries = glrHistory.TransferData[name].Data.Settings.RaffleSeries
																glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners = glrHistory.TransferData[name].Data.Settings.AllowMultipleRaffleWinners
																glrCharacter.Data.OtherStatus.Raffle = glrHistory.TransferData[name].Data.OtherStatus.Raffle
																glrCharacter.Data.Settings.CurrentlyActiveRaffle = true
																glrHistory.TransferData[name].Data.OtherStatus.Raffle = nil
																glrHistory.TransferData[name].Data.Settings.AllowMultipleRaffleWinners = nil
																glrHistory.TransferData[name].Data.Settings.RaffleSeries = nil
																glrHistory.TransferData[name].Data.Raffle = nil
																glrHistory.TransferData[name].Raffle = nil
																glrHistory.TransferData[name].Event.Raffle = nil
																Variables[5][4] = false
																GLR_U:UpdateInfo(true)
																if not glrHistory.TransferAvailable.Lottery[name] and not glrHistory.TransferAvailable.Raffle[name] then
																	glrHistory.ActiveEvents[name] = false
																end
																local timestamp = GetTimeStamp()
																table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - TransferData_Execute_Raffle() - Transfer Of Event Data From: [" .. name .. "] - Complete." )
																local message = string.gsub(L["Configuration Panel Options Transfer Completed"], "%%name", name)
																GLR:Print(message)
															end
														end
													end
												end,
											},
										},
									},
								},
							},
							ExportDataSettingsTab = {
								order = 6,
								type = "group",
								name = "Export",
								childGroups = "tree",
								args = {
									ExportDataSettings_Header = {
										order = 1,
										type = "header",
										name = "Export Data Settings",
									},
									ExportDataSettings_Select_ExportType = {
										order = 3,
										type = "select",
										name = "Exported Format",
										desc = "Supported Formats:\n\n- Simple Display\nFormated to display relevant data of a single Event\n\n- Complex Display\nFormated to allow for display of data from multiple Events",
										style = "dropdown",
										width = "normal",
										values = function()
											local t = { [1] = "Simple", [2] = "Complex" }
											return t
										end,
										get = function()
											return glrCharacter.Data.Settings.General.ExportTypeKey
										end,
										set = function(_, key)
											glrCharacter.Data.Settings.General.ExportTypeKey = key
											local continue = true
											for i = 1, 4 do
												local f = _G['StaticPopup' .. tostring(i)]
												if f:IsVisible() then
													continue = false
													break
												end
											end
											if continue then
												StaticPopup_Show("GLROPTIONCHANGED")
											end
										end,
									},
									ExportDataSettings_Select_ValueFormat = {
										order = 4,
										type = "select",
										name = "Value Format",
										desc = "Determines how values are displayed when exported.",
										style = "dropdown",
										width = "normal",
										values = function()
											local t = { [1] = "100g 57s 01c", [2] = "100.5701" }
											return t
										end,
										get = function()
											return glrCharacter.Data.Settings.General.ExportFormatKey
										end,
										set = function(_, key)
											glrCharacter.Data.Settings.General.ExportFormatKey = key
										end,
									},
									ExportDataSettings_Spacer_1 = {
										order = 10,
										type = "description",
										name = "",
										width = "full",
									},
									ExportDataSettings_Toggle_ExportDataHeader = {
										order = 11,
										type = "toggle",
										name = "Export Header",
										desc = "When exporting previous Event Data, the header for this information is exported by default. Disabling this option will prevent the Header from being exported.",
										width = "normal",
										get = function()
											return glrCharacter.Data.Settings.General.ExportHeader
										end,
										set = function(info, value)
											glrCharacter.Data.Settings.General.ExportHeader = value
										end,
									},
								},
							},
						},
					},
					TicketInfoTab = {
						order = 2,
						type = "group",
						name = L["Configuration Panel Options Tab Ticket Info"],
						childGroups = "tab",
						args = {
							TicketInfo_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Ticket Info Header"],
							},
							TicketInfo_Select_LotteryPlayer = {
								order = 2,
								type = "select",
								name = L["Configuration Panel Ticket Info Select Lottery Player"],
								desc = L["Configuration Panel Ticket Info Select Lottery Player Desc"],
								style = "dropdown",
								width = "normal",
								values = function()
									local t = {}
									local c = 0
									if glrCharacter ~= nil then
										if glrCharacter.Lottery ~= nil then
											if glrCharacter.Lottery.Entries ~= nil then
												if glrCharacter.Lottery.Entries.Names ~= nil then
													if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
														for id, val in pairs(glrCharacter.Lottery.Entries.Names) do
															table.insert(t, val)
															c = c + 1
														end
													end
												end
											end
										end
									end
									if c == 0 then
										table.insert(t, L["GLR - Error - No Entries Found"])
										return t
									else
										sort(t)
										return t
									end
								end,
								get = function()
									return Variables[1][1]
								end,
								set = function(_, key)
									Variables[1][1] = key
								end,
							},
							TicketInfo_View_LotteryPlayer = {
								order = 3,
								type = "execute",
								name = L["Configuration Panel Ticket Info Lottery Button"],
								desc = L["Configuration Panel Ticket Info Lottery Button Desc"],
								width = "normal",
								func = function()
									if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
										ViewPlayerTickets("Lottery")
									else
										GLR:Print("Viewing Player Ticket Numbers isn't possible with Advanced Ticket Draw enabled.")
									end
								end,
							},
							TicketInfo_Spacer = {
								order = 4,
								type = "description",
								name = "",
							},
							TicketInfo_Select_RafflePlayer = {
								order = 5,
								type = "select",
								name = L["Configuration Panel Ticket Info Select Raffle Player"],
								desc = L["Configuration Panel Ticket Info Select Raffle Player Desc"],
								style = "dropdown",
								width = "normal",
								values = function()
									local t = {}
									local c = 0
									if glrCharacter ~= nil then
										if glrCharacter.Raffle ~= nil then
											if glrCharacter.Raffle.Entries ~= nil then
												if glrCharacter.Raffle.Entries.Names ~= nil then
													for id, val in pairs(glrCharacter.Raffle.Entries.Names) do
														table.insert(t, val)
														c = c + 1
													end
												end
											end
										end
									end
									if c == 0 then
										table.insert(t, L["GLR - Error - No Entries Found"])
										return t
									else
										sort(t)
										return t
									end
								end,
								get = function()
									return Variables[1][2]
								end,
								set = function(_, key)
									Variables[1][2] = key
								end,
							},
							TicketInfo_View_RafflePlayer = {
								order = 6,
								type = "execute",
								name = L["Configuration Panel Ticket Info Raffle Button"],
								desc = L["Configuration Panel Ticket Info Raffle Button Desc"],
								width = "normal",
								func = function()
									if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
										ViewPlayerTickets("Raffle")
									else
										GLR:Print("Viewing Player Ticket Numbers isn't possible with Advanced Ticket Draw enabled.")
									end
								end,
							},
						},
					},
				},
			},
			eventSettings = {
				order = 3,
				type = "group",
				name = L["Configuration Panel Events Tab"],
				childGroups = "tree",
				args = {
					eventSettings_Header = {
						order = 0,
						type = "header",
						name = "Event Settings",
					},
					lotterySettings = {
						order = 1,
						type = "group",
						name = L["Configuration Panel Options Lottery Header"],
						childGroups = "tab",
						args = {
							Lottery_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Options Lottery Header"],
								width = "full",
							},
							Lottery_Button_Cancel = {
								order = 2,
								type = "execute",
								name = L["Configuration Panel Options Cancel Lottery"],
								desc = L["Configuration Panel Options Cancel Lottery Desc"],
								width = "normal",
								func = function()
									if glrCharacter.Data.Settings.CurrentlyActiveLottery then
										CancelCurrentEvent("Lottery")
										Variables[5][1] = false
									end
								end,
							},
							Lottery_Toggle_ConfirmCancel = {
								order = 3,
								type = "toggle",
								name = L["GLR - UI > Config > Events - Confirm Cancel"],
								desc = L["GLR - UI > Config > Events - Confirm Cancel Desc"],
								width = "normal",
								get = function()
									local status = glrCharacter.Data.Settings.CurrentlyActiveLottery
									if not status then
										return false
									end
									return Variables[5][1]
								end,
								set = function(info, value)
									if glrCharacter.Data.Settings.CurrentlyActiveLottery then
										Variables[5][1] = value
									end
								end,
							},
							Lottery_Event_Spacer_0 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
							},
							Lottery_Toggle_CarryOver = {
								order = 5,
								type = "toggle",
								name = "Player Rollover",
								desc = "In the event no one wins the Jackpot and no one wins Second Place, with this option enabled, all Player Names will rollover into your next Lottery Event. Starting at zero tickets.\n|cffff0000This option can only be changed while no Lottery Event is active.|r",
								width = "normal",
								get = function()
									return glrCharacter.Data.Settings.Lottery.CarryOver
								end,
								set = function(info, val)
									local timestamp = GetTimeStamp()
									if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
										glrCharacter.Data.Settings.Lottery.CarryOver = val
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Toggle_CarryOver() - Set Carry Over Status: [" .. string.upper(tostring(val)) .. "]")
									else
										GLR:Print("Carry Over setting can't be changed while a Lottery Event is Active.")
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Toggle_CarryOver() - Unable To Change Carry Over Status. Event Active.")
									end
								end,
							},
							Lottery_Toggle_NoGuildCut = {
								order = 6,
								type = "toggle",
								name = L["Configuration Panel No Guild Cut on No Winner"],
								desc = L["Configuration Panel No Guild Cut on No Winner Desc"],
								width = "normal",
								get = function()
									return glrCharacter.Data.Settings.Lottery.NoGuildCut
								end,
								set = function(info, val)
									local timestamp = GetTimeStamp()
									if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Toggle_NoGuildCut() - Set No Guild Cut Status: [" .. string.upper(tostring(val)) .. "]")
										glrCharacter.Data.Settings.Lottery.NoGuildCut = val
									else
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Toggle_NoGuildCut() - Unable To Change No Guild Cut Status. Event Active.")
									end
								end,
							},
							Lottery_Select_RoundValue = {
								order = 7,
								type = "select",
								name = "Round Values",
								desc = "Rounds certain values either up or down. The Jackpot is never rounded.\n\nThis affects Jackpot Winners and the amount given to the Guild.\n\nCan only change while no Lottery Event is Active.",
								width = "normal",
								style = "dropdown",
								values = function()
									local t = { [1] = "Don't Round Values", [2] = "Round Values Up", [3] = "Round Values Down" }
									return t
								end,
								get = function()
									return glrCharacter.Data.Settings.Lottery.RoundValue
								end,
								set = function(_, key)
									local timestamp = GetTimeStamp()
									if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Select_RoundValue() - Set Round Value Status: [" .. key .. "]")
										glrCharacter.Data.Settings.Lottery.RoundValue = key
									else
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Select_RoundValue() - Unable To Change Round Value Status. Event Active.")
										GLR:Print("Unable to change Round Value status. Lottery Event is Active.")
									end
								end,
							},
							Lottery_Select_WinChance = {
								order = 8,
								type = "select",
								name = "Win Chance",
								desc = "Lottery Win Chance can only be modified when Advanced Ticket Draw is enabled and no Lottery Event is currently active.\nWin Chance is always 50% for non-Advanced Events.\nGuaranteeing a winner will always override this setting.\n\nWin Chance only affects the chance that a ticket number assigned to a Player is chosen as the winning number.\n\nModifying Event Win Chance is done by changing how many tickets a player receives.\nEX: At Event Draw, the total number of tickets created is 10x the total amount of Sold and Given Tickets. If the Win Chance is 70% then for every Ticket a Player has, they will receive SEVEN and the other THREE are not assigned to a Player.",
								width = "normal",
								style = "dropdown",
								values = function()
									local t = { [1] = "90%", [2] = "80%", [3] = "70%", [4] = "60%", [5] = "50%", [6] = "40%", [7] = "30%", [8] = "20%", [9] = "10%" }
									return t
								end,
								get = function()
									if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
										glrCharacter.Data.Settings.Lottery.WinChanceKey = 5
									end
									return glrCharacter.Data.Settings.Lottery.WinChanceKey
								end,
								set = function(_, key)
									local timestamp = GetTimeStamp()
									if not glrCharacter.Data.Settings.CurrentlyActiveLottery and glrCharacter.Data.Settings.General.AdvancedTicketDraw then
										glrCharacter.Data.Settings.Lottery.WinChanceKey = key
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Select_WinChance() - Changed Event Win Chance. Key: [" .. key .. "]")
										Variables[5][9] = false
									else
										if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
											glrCharacter.Data.Settings.Lottery.WinChanceKey = 5
										end
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Select_WinChance() - Unable to Set Event Win Chance. Event Status: [" .. string.upper(tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)) .. "] - Advanced: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.AdvancedTicketDraw)) .. "]")
										GLR:Print("Win Chance can only be changed while both Advanced Ticket Draw is enabled, and no Lottery Event is active.")
									end
								end,
							},
							Lottery_Event_Spacer_1 = {
								order = 9,
								type = "description",
								name = "",
								width = "full",
							},
							Lottery_Execute_Export = {
								order = 10,
								type = "execute",
								name = L["GLR - UI > Config > Events > Data Export - Button"],
								width = "normal",
								desc = function(info) return string.gsub(L["GLR - UI > Config > Events > Data Export - Button Tooltip"], "%%e", L["Lottery"]) end,
								hidden = function(self) if glrCharacter.PreviousEvent.Lottery.Available then return false else return true end end,
								func = function()
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Execute_Export() - Creating Data String for Export of Lottery Event")
									GLR:ExportData("Lottery")
								end,
							},
							Lottery_Event_Spacer_2 = {
								order = 11,
								type = "description",
								name = "",
								width = "full",
							},
							Lottery_Header_MailSettings = {
								order = 12,
								type = "header",
								name = L["GLR - Config - Events - Mail Header"],
								width = "full",
							},
							Lottery_List_MailDetection = {
								order = 13,
								type = "description",
								name = function(info)
									local text = "Current Mail Detection Phrases:\n"
									for i = 1, #glrHistory.Settings.Lottery.Mail do
										if i == 1 then
											text = text .. '"' .. glrHistory.Settings.Lottery.Mail[i] .. '"'
										else
											text = text .. ', "' .. glrHistory.Settings.Lottery.Mail[i] .. '"'
										end
									end
									return text
								end,
								width = "full",
							},
							Lottery_Input_MailDetection = {
								order = 14,
								type = "input",
								name = "Mail Detection Phrases:",
								desc = "A comma separated list the AddOn will look for when scanning your mailbox.\nList can't have matching entries for your Raffle phrases.\nPhrases are NOT case sensitive, but are exact.\nDefault phrases can't be removed.",
								width = "full",
								get = function(info)
									local text = ""
									for i = 1, #glrHistory.Settings.Lottery.Mail do
										if i == 1 then
											text = glrHistory.Settings.Lottery.Mail[i]
										else
											text = text .. ", " .. glrHistory.Settings.Lottery.Mail[i]
										end
									end
									return text
								end,
								set = function(info, value)
									local text = string.gsub(value, ',%s', ',')
									local t = { [1] = L["Lottery"], [2] = L["Guild Lottery"], }
									--Because there exists the possiblity the Host might be using a client not of the same language as a Player, the default English Detection Phrase must be added automatically.
									if GetLocale() ~= "enUS" then
										t = { [1] = L["Lottery"], [2] = L["Guild Lottery"], [3] = "Lottery", [4] = "Guild Lottery", }
									end
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Input_MailDetection() - Processing Values: [" .. tostring(value) .. "]")
									for v in string.gmatch(text, "[^,]+") do
										if v ~= nil then
											local check = string.lower(v)
											--Need to prevent people from potentially adding certain phrases to the Lottery detection phrase for non-English speaking users.
											if check ~= "raffle" and check ~= "guild raffle" and check ~= string.lower(L["Raffle"]) and check ~= string.lower(L["Guild Raffle"]) then
												table.insert(t, v)
											end
										end
									end
									if #t > 2 then --Only need to check if there's more than the default phrases
										for i = 1, #t do --Time to check for multiple instances of the same phrase and remove them.
											if t[i] ~= nil then
												local check = string.lower(t[i])
												for j = i + 1, #t do
													if t[j] ~= nil then
														if check == string.lower(t[j]) then
															table.remove(t, j)
														end
													end
												end
											end
										end
									end
									for i = 1, #glrHistory.Settings.Raffle.Mail do --Next, time to check the list of Raffle phrases and remove duplicates.
										local check = string.lower(glrHistory.Settings.Raffle.Mail[i])
										for j = 1, #t do
											if check == string.lower(t[j]) then
												table.remove(t, j)
											end
										end
									end
									glrHistory.Settings.Lottery.Mail = t
								end,
							},
							Lottery_Header_CommandDetection = {
								order = 15,
								type = "header",
								name = L["GLR - Config - Events - Command Header"],
								width = "full",
							},
							Lottery_List_CommandDetection = {
								order = 16,
								type = "description",
								name = function(info)
									local text = "Current Command Detection Phrases:\n"
									for i = 1, #glrHistory.Settings.Lottery.Commands do
										if i == 1 then
											text = text .. '"' .. glrHistory.Settings.Lottery.Commands[i] .. '"'
										else
											text = text .. ', "' .. glrHistory.Settings.Lottery.Commands[i] .. '"'
										end
									end
									return text
								end,
								width = "full",
							},
							Lottery_Input_CommandDetection = {
								order = 17,
								type = "input",
								name = "Command Detection Phrases:",
								desc = "A comma separated list the AddOn will look for when scanning your chat.\n- List can't have matching entries for your Raffle phrases.\n- Phrases are NOT case sensitive, but are exact.\n- Default phrases can't be removed.\n- Prefixes such as ! and ? are not required.",
								width = "full",
								get = function(info)
									local text = ""
									for i = 1, #glrHistory.Settings.Lottery.Commands do
										if i == 1 then
											text = glrHistory.Settings.Lottery.Commands[i]
										else
											text = text .. ", " .. glrHistory.Settings.Lottery.Commands[i]
										end
									end
									return text
								end,
								set = function(info, value)
									local text = string.gsub(value, ',%s', ',')
									local t = { [1] = string.lower(L["Lottery"]), }
									--Because there exists the possiblity the Host might be using a client not of the same language as a Player, the default English Detection Phrase must be added automatically.
									if GetLocale() ~= "enUS" then
										t = { [1] = "lottery", [2] = string.lower(L["Lottery"]), }
									end
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Lottery_Input_CommandDetection() - Processing Values: [" .. tostring(value) .. "]")
									for v in string.gmatch(text, "[^,]+") do
										if v ~= nil then
											local check = string.lower(v)
											--Need to prevent people from potentially adding "raffle" to the Lottery detection phrase for non-English speaking users.
											if check ~= "raffle" and check ~= string.lower(L["Raffle"]) then
												table.insert(t, v)
											end
										end
									end
									if #t > 1 then --Only need to check if there's more than the default phrases
										for i = 1, #t do --Time to check for multiple instances of the same phrase and remove them.
											if i == 1 then
												--Time to search for white spaces, special characters, punctuations and remove them, ie: "!lot tery" will be converted to "lottery"
												for j = 1, #t do
													t[j] = string.gsub(t[j], '[%p%c%s]', "")
													--t[j] = string.gsub(t[j], " ", "")
												end
											end
											if t[i] ~= nil then
												local check = string.lower(t[i])
												for j = i + 1, #t do
													if t[j] ~= nil then
														if check == string.lower(t[j]) then
															table.remove(t, j)
														end
													end
												end
											end
										end
									end
									for i = 1, #glrHistory.Settings.Raffle.Commands do --Next, time to check the list of Raffle phrases and remove duplicates.
										local check = string.lower(glrHistory.Settings.Raffle.Commands[i])
										for j = 1, #t do
											if check == string.lower(t[j]) then
												table.remove(t, j)
											end
										end
									end
									glrHistory.Settings.Lottery.Commands = t
								end,
							},
						},
					},
					raffleSettings = {
						order = 2,
						type = "group",
						name = L["Configuration Panel Options Raffle Header"],
						childGroups = "tab",
						args = {
							Raffle_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Options Raffle Header"],
							},
							Raffle_Button_Cancel = {
								order = 2,
								type = "execute",
								name = L["Configuration Panel Options Cancel Raffle"],
								desc = L["Configuration Panel Options Cancel Raffle Desc"],
								width = "normal",
								func = function()
									if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
										CancelCurrentEvent("Raffle")
										Variables[5][2] = false
									end
								end,
							},
							Raffle_Toggle_ConfirmCancel = {
								order = 3,
								type = "toggle",
								name = L["GLR - UI > Config > Events - Confirm Cancel"],
								desc = L["GLR - UI > Config > Events - Confirm Cancel Desc"],
								width = "normal",
								get = function()
									local status = glrCharacter.Data.Settings.CurrentlyActiveRaffle
									if not status then
										return false
									end
									return Variables[5][2]
								end,
								set = function(info, value)
									if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
										Variables[5][2] = value
									end
								end,
							},
							Raffle_Spacer_1 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
							},
							Raffle_Toggle_MultipleWinners = {
								order = 5,
								type = "toggle",
								name = L["Configuration Panel Options Allow Multiple Raffle Winners"],
								desc = L["Configuration Panel Options Allow Multiple Raffle Winners Desc"],
								width = "double",
								get = function()
									return glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners
								end,
								set = function(info, value)
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Raffle_Toggle_MultipleWinners() - Set Force Multiple Winners: [" .. string.upper(tostring(value)) .. "]")
									glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners = value
								end,
							},
							Raffle_Toggle_InverseAnnouncement = {
								order = 6,
								type = "toggle",
								name = L["GLR - UI > Config > Events > Raffle - Inverse Announce Order"],
								desc = L["GLR - UI > Config > Events > Raffle - Inverse Announce Order Tooltip"],
								width = "double",
								get = function()
									return glrCharacter.Data.Settings.Raffle.InverseAnnounce
								end,
								set = function(info, val)
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Raffle_Toggle_InverseAnnouncement() - Set Raffle Announce Order: [" .. string.upper(tostring(val)) .. "]")
									glrCharacter.Data.Settings.Raffle.InverseAnnounce = val
								end
							},
							Raffle_Spacer_2 = {
								order = 9,
								type = "description",
								name = "",
								width = "full",
							},
							Raffle_Execute_Export = {
								order = 10,
								type = "execute",
								name = L["GLR - UI > Config > Events > Data Export - Button"],
								desc = function(info) return string.gsub(L["GLR - UI > Config > Events > Data Export - Button Tooltip"], "%%e", L["Raffle"]) end,
								hidden = function(self) if glrCharacter.PreviousEvent.Raffle.Available then return false else return true end end,
								func = function()
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - Raffle_Execute_Export() - Creating Data String for Export of Raffle Event")
									GLR:ExportData("Raffle")
								end,
							},
							Raffle_Spacer_3 = {
								order = 11,
								type = "description",
								name = "",
								width = "full",
							},
							Raffle_Header_MailSettings = {
								order = 12,
								type = "header",
								name = L["GLR - Config - Events - Mail Header"],
								width = "full",
							},
							Raffle_List_MailDetection = {
								order = 13,
								type = "description",
								name = function(info)
									local text = "Current Detection Phrases:\n"
									for i = 1, #glrHistory.Settings.Raffle.Mail do
										if i == 1 then
											text = text .. '"' .. glrHistory.Settings.Raffle.Mail[i] .. '"'
										else
											text = text .. ', "' .. glrHistory.Settings.Raffle.Mail[i] .. '"'
										end
									end
									return text
								end,
								width = "full",
							},
							Raffle_Input_MailDetection = {
								order = 14,
								type = "input",
								name = "Mail Detection Phrases:",
								desc = "A comma separated list the AddOn will look for when scanning your mailbox.\nList can't have matching entries for your Lottery phrases.\nPhrases are NOT case sensitive, but are exact.\nDefault phrases can't be removed.",
								width = "full",
								get = function(info)
									local text = ""
									for i = 1, #glrHistory.Settings.Raffle.Mail do
										if i == 1 then
											text = glrHistory.Settings.Raffle.Mail[i]
										else
											text = text .. ", " .. glrHistory.Settings.Raffle.Mail[i]
										end
									end
									return text
								end,
								set = function(info, value)
									local text = string.gsub(value, ',%s', ',')
									local t = { [1] = L["Raffle"], [2] = L["Guild Raffle"], }
									--Because there exists the possiblity the Host might be using a client not of the same language as a Player, the default English Detection Phrase must be added automatically.
									if GetLocale() ~= "enUS" then
										t = { [1] = L["Raffle"], [2] = L["Guild Raffle"], [3] = "Raffle", [4] = "Guild Raffle", }
									end
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Raffle_Input_MailDetection() - Processing Values: [" .. tostring(value) .. "]")
									for v in string.gmatch(text, "[^,]+") do
										if v ~= nil then
											local check = string.lower(v)
											--Need to prevent people from potentially adding "lottery" to the Raffle detection phrase for non-English speaking users.
											if check ~= "lottery" and check ~= "guild lottery" and check ~= string.lower(L["Lottery"]) and check ~= string.lower(L["Guild Lottery"]) then
												table.insert(t, v)
											end
										end
									end
									if #t > 2 then --Only need to check if there's more than the default phrases
										for i = 1, #t do --Time to check for multiple instances of the same phrase and remove them.
											if t[i] ~= nil then
												local check = string.lower(t[i])
												for j = i + 1, #t do
													if t[j] ~= nil then
														if check == string.lower(t[j]) then
															table.remove(t, j)
														end
													end
												end
											end
										end
										for i = 1, #glrHistory.Settings.Lottery.Mail do --Next, time to check the list of Lottery phrases and remove duplicates.
											local check = string.lower(glrHistory.Settings.Lottery.Mail[i])
											for j = 1, #t do
												if check == string.lower(t[j]) then
													table.remove(t, j)
												end
											end
										end
									end
									glrHistory.Settings.Raffle.Mail = t
								end,
							},
							Raffle_Header_CommandDetection = {
								order = 15,
								type = "header",
								name = L["GLR - Config - Events - Command Header"],
								width = "full",
							},
							Raffle_List_CommandDetection = {
								order = 16,
								type = "description",
								name = function(info)
									local text = "Current Command Detection Phrases:\n"
									for i = 1, #glrHistory.Settings.Raffle.Commands do
										if i == 1 then
											text = text .. '"' .. glrHistory.Settings.Raffle.Commands[i] .. '"'
										else
											text = text .. ', "' .. glrHistory.Settings.Raffle.Commands[i] .. '"'
										end
									end
									return text
								end,
								width = "full",
							},
							Raffle_Input_CommandDetection = {
								order = 17,
								type = "input",
								name = "Command Detection Phrases:",
								desc = "A comma separated list the AddOn will look for when scanning your chat.\n- List can't have matching entries for your Lottery phrases.\n- Phrases are NOT case sensitive, but are exact.\n- Default phrases can't be removed.\n- Prefixes such as ! and ? are not required.",
								width = "full",
								get = function(info)
									local text = ""
									for i = 1, #glrHistory.Settings.Raffle.Commands do
										if i == 1 then
											text = glrHistory.Settings.Raffle.Commands[i]
										else
											text = text .. ", " .. glrHistory.Settings.Raffle.Commands[i]
										end
									end
									return text
								end,
								set = function(info, value)
									local text = string.gsub(value, ',%s', ',')
									local t = { [1] = string.lower(L["Raffle"]), }
									--Because there exists the possiblity the Host might be using a client not of the same language as a Player, the default English Detection Phrase must be added automatically.
									if GetLocale() ~= "enUS" then
										t = { [1] = "raffle", [2] = string.lower(L["Raffle"]), }
									end
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Raffle_Input_CommandDetection() - Processing Values: [" .. tostring(value) .. "]")
									for v in string.gmatch(text, "[^,]+") do
										if v ~= nil then
											local check = string.lower(v)
											--Need to prevent people from potentially adding "lottery" to the Raffle detection phrase for non-English speaking users.
											if check ~= "lottery" and check ~= string.lower(L["Lottery"]) then
												table.insert(t, v)
											end
										end
									end
									if #t > 1 then --Only need to check if there's more than the default phrases
										for i = 1, #t do --Time to check for multiple instances of the same phrase and remove them.
											if i == 1 then
												--Time to search for white spaces, special characters, punctuations and remove them, ie: "!raf fle" will be converted to "raffle"
												for j = 1, #t do
													t[j] = string.gsub(t[j], '[%p%c%s]', "")
													--t[j] = string.gsub(t[j], " ", "")
												end
											end
											if t[i] ~= nil then
												local check = string.lower(t[i])
												for j = i + 1, #t do
													if t[j] ~= nil then
														if check == string.lower(t[j]) then
															table.remove(t, j)
														end
													end
												end
											end
										end
									end
									for i = 1, #glrHistory.Settings.Lottery.Commands do --Next, time to check the list of Raffle phrases and remove duplicates.
										local check = string.lower(glrHistory.Settings.Lottery.Commands[i])
										for j = 1, #t do
											if check == string.lower(t[j]) then
												table.remove(t, j)
											end
										end
									end
									glrHistory.Settings.Raffle.Commands = t
								end,
							},
						},
					},
				},
			},
			profileOptions = {
				order = 4,
				type = "group",
				name = L["Configuration Panel Profiles Tab"],
				childGroups = "tab",
				args = {
					general_ProfileHeader = {
						order = 1,
						type = "header",
						name = L["Configuration Panel Options Profile Header"],
					},
					general_Raffle_ProfileDescription = {
						order = 2,
						type = "description",
						name = L["Configuration Panel Options Profile Desc"],
						width = "full",
					},
					LotteryProfileTab = {
						order = 3,
						type = "group",
						name = L["Lottery"],
						childGroups = "tab",
						args = {
							LotteryProfile_Select = {
								order = 1,
								type = "select",
								name = L["Configuration Panel Options Profile Copy"],
								desc = L["Configuration Panel Options Profile Copy Lottery Desc"],
								style = "dropdown",
								width = "normal",
								values = function()
									local c = 0
									Variables[8][1] = {}
									if glrHistory ~= nil then
										if glrHistory.Profile ~= nil then
											if glrHistory.Profile.Lottery ~= nil then
												for id, val in pairs(glrHistory.Profile.Lottery) do
													if id ~= FullPlayerName then
														table.insert(Variables[8][1], id)
														c = c + 1
													end
												end
											end
										end
									end
									if c >= 1 then
										sort(Variables[8][1])
										return Variables[8][1]
									else
										table.insert(Variables[8][1], L["GLR - Error - No Entries Found"])
										return Variables[8][1]
									end
								end,
								get = function()
									return Variables[4][1]
								end,
								set = function(_, key)
									Variables[4][1] = key
									local name = Variables[8][1][key]
									if name ~= L["GLR - Error - No Entries Found"] then
										for t, v in pairs(glrHistory.Profile.Lottery[name]) do
											glrHistory.Profile.Lottery[FullPlayerName][t] = glrHistory.Profile.Lottery[name][t]
										end
										GLR:Print("Copied Lottery Event Profile from: " .. name)
										local timestamp = GetTimeStamp()
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryProfile_Select() - Copied Profile From: [" .. name .. "]")
									end
								end,
							},
							LotteryProfile_Spacer_1 = {
								order = 2,
								type = "description",
								name = "",
								width = "full",
							},
							LotteryProfile_StartingAmount = {
								order = 3,
								type = "input",
								name = L["Configuration Panel Options Lottery Profile Starting Gold"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"] .. "\n" .. L["Configuration Panel Options Profile Value Continued"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.StartingGold
								end,
								set = function(info, value)
									local number = tonumber(value)
									if number == nil then
										number = "0.0000"
									else
										if number > 0 then
											number = string.format("%.4f", tostring(number))
										else
											number = "0.0000"
										end
									end
									glrCharacter.Data.Settings.Profile.Lottery.StartingGold = number
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryProfile_StartingAmount() - Changed Lottery Profile Start Amount: [" .. number .. "]")
								end,
							},
							LotteryProfile_Spacer_2 = {
								order = 4,
								type = "description",
								name = "",
								width = "normal",
							},
							LotteryProfile_MaxTickets = {
								order = 5,
								type = "input",
								name = L["Configuration Panel Options Profile Max Tickets"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.MaxTickets
								end,
								set = function(info, value)
									local text = tonumber(value)
									if text == nil then
										text = "0"
									else
										if text >= 0 and text <= 50000 then
											text = tostring(text)
										else
											if text > 50000 then
												text = "50000"
											else
												text = "0"
											end
										end
									end
									glrCharacter.Data.Settings.Profile.Lottery.MaxTickets = text
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryProfile_MaxTickets() - Changed Lottery Profile Max Tickets: [" .. text .. "]")
								end,
							},
							LotteryProfile_Spacer_3 = {
								order = 6,
								type = "description",
								name = "",
								width = "full",
							},
							LotteryProfile_TicketPrice = {
								order = 7,
								type = "input",
								name = L["Configuration Panel Options Profile Ticket Price"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"] .. "\n" .. L["Configuration Panel Options Profile Value Continued"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.TicketPrice
								end,
								set = function(info, value)
									local number = tonumber(value)
									if number == nil then
										number = "0.0000"
									else
										if number > 0 then
											number = string.format("%.4f", tostring(number))
										else
											number = "0.0000"
										end
									end
									glrCharacter.Data.Settings.Profile.Lottery.TicketPrice = number
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryProfile_TicketPrice() - Changed Lottery Profile Ticket Price: [" .. number .. "]")
								end,
							},
							LotteryProfile_Spacer_4 = {
								order = 8,
								type = "description",
								name = "",
								width = "normal",
							},
							LotteryProfile_SecondPlace = {
								order = 9,
								type = "input",
								name = L["Configuration Panel Options Lottery Profile Second Place"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.SecondPlace
								end,
								set = function(info, value)
									local text = tonumber(value)
									local compare = tonumber(glrCharacter.Data.Settings.Profile.Lottery.GuildCut)
									if text == nil then
										text = "0"
									else
										compare = text + compare
										if text >= 0 and text <= 100 and compare <= 100 then
											text = tostring(text)
										else
											text = "0"
										end
									end
									glrCharacter.Data.Settings.Profile.Lottery.SecondPlace = text
									local timestamp = GetTimeStamp()
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryProfile_SecondPlace() - Changed Lottery Profile Ticket Price: [" .. text .. "]")
								end,
							},
							LotteryProfile_Spacer_5 = {
								order = 10,
								type = "description",
								name = "",
								width = "full",
							},
							LotteryProfile_GuildCut = {
								order = 11,
								type = "input",
								name = L["Configuration Panel Options Lottery Profile Guild Cut"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.GuildCut
								end,
								set = function(info, value)
									local text = tonumber(value)
									local compare = tonumber(glrCharacter.Data.Settings.Profile.Lottery.SecondPlace)
									if text == nil then
										text = "0"
									else
										compare = text + compare
										if text >= 0 and text <= 100 and compare <= 100 then
											text = tostring(text)
										else
											text = "0"
										end
									end
									glrCharacter.Data.Settings.Profile.Lottery.GuildCut = text
								end,
							},
							LotteryProfile_Spacer_6 = {
								order = 12,
								type = "description",
								name = "",
								width = "normal",
							},
							LotteryProfile_GuaranteeWinner = {
								order = 13,
								type = "toggle",
								name = L["Configuration Panel Options Lottery Profile Guarantee Winner"],
								desc = L["Configuration Panel Options Lottery Profile Toggle Desc"],
								width = "normal",
								get = function()
									return glrCharacter.Data.Settings.Profile.Lottery.Guaranteed
								end,
								set = function(_, value)
									glrCharacter.Data.Settings.Profile.Lottery.Guaranteed = value
								end
							},
						},
					},
					RaffleProfileTab = {
						order = 4,
						type = "group",
						name = L["Raffle"],
						childGroups = "tab",
						args = {
							RaffleProfile_Select = {
								order = 1,
								type = "select",
								name = L["Configuration Panel Options Profile Copy"],
								desc = L["Configuration Panel Options Profile Copy Raffle Desc"],
								style = "dropdown",
								width = "normal",
								values = function()
									local c = 0
									Variables[8][3] = {}
									if glrHistory ~= nil then
										if glrHistory.Profile ~= nil then
											if glrHistory.Profile.Raffle ~= nil then
												for id, val in pairs(glrHistory.Profile.Raffle) do
													if id ~= FullPlayerName then
														table.insert(Variables[8][3], id)
														c = c + 1
													end
												end
											end
										end
									end
									if c >= 1 then
										sort(Variables[8][3])
										return Variables[8][3]
									else
										table.insert(Variables[8][3], L["GLR - Error - No Entries Found"])
										return Variables[8][3]
									end
								end,
								get = function()
									return Variables[4][2]
								end,
								set = function(_, key)
									Variables[4][2] = key
									local name = Variables[8][3][key]
									if name ~= L["GLR - Error - No Entries Found"] then
										for t, v in pairs(glrHistory.Profile.Raffle[name]) do
											glrHistory.Profile.Raffle[FullPlayerName][t] = glrHistory.Profile.Raffle[name][t]
										end
										GLR:Print("Copied Raffle Event Profile from: " .. name)
										local timestamp = GetTimeStamp()
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleProfile_Select() - Copied Profile From: [" .. name .. "]")
									end
								end,
							},
							RaffleProfile_Spacer_1 = {
								order = 2,
								type = "description",
								name = "",
								width = "full",
							},
							RaffleProfile_MaxTickets = {
								order = 3,
								type = "input",
								name = L["Configuration Panel Options Profile Max Tickets"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Raffle.MaxTickets
								end,
								set = function(info, value)
									local text = tonumber(value)
									if text == nil then
										text = "0"
									else
										if text >= 0 and text <= 50000 then
											text = tostring(text)
										else
											if text > 50000 then
												text = "50000"
											else
												text = "0"
											end
										end
									end
									glrCharacter.Data.Settings.Profile.Raffle.MaxTickets = text
								end,
							},
							RaffleProfile_Spacer_2 = {
								order = 4,
								type = "description",
								name = "",
								width = "normal",
							},
							RaffleProfile_TicketPrice = {
								order = 5,
								type = "input",
								name = L["Configuration Panel Options Profile Ticket Price"],
								desc = L["Configuration Panel Options Profile Enter Amount Desc"] .. "\n" .. L["Configuration Panel Options Profile Value Continued"],
								width = "0.75",
								get = function()
									return glrCharacter.Data.Settings.Profile.Raffle.TicketPrice
								end,
								set = function(info, value)
									local number = tonumber(value)
									if number == nil then
										number = "0.0000"
									else
										if number > 0 then
											number = string.format("%.4f", tostring(number))
										else
											number = "0.0000"
										end
									end
									glrCharacter.Data.Settings.Profile.Raffle.TicketPrice = number
								end,
							},
							RaffleProfile_Spacer_3 = {
								order = 6,
								type = "description",
								name = "",
								width = "full",
							},
							RaffleProfile_InvalidItems = {
								order = 7,
								type = "toggle",
								name = L["Configuration Panel Options Raffle Profile Invalid Items"],
								desc = L["Configuration Panel Options Raffle Profile Toggle Desc"],
								width = "normal",
								get = function()
									return glrCharacter.Data.Settings.Profile.Raffle.InvalidItems
								end,
								set = function(_, value)
									glrCharacter.Data.Settings.Profile.Raffle.InvalidItems = value
								end,
							},
						},
					},
					MessageProfileTab = {
						order = 5,
						type = "group",
						name = L["Configuration Panel Message Tab"],
						childGroups = "tree",
						args = {
							LotteryMessageProfileTab = {
								order = 1,
								type = "group",
								name = L["Lottery"],
								childGroups = "tab",
								args = {
									SelectLotteryMessageProfile = {
										order = 1,
										type = "select",
										name = L["Configuration Panel Options Profile Copy"],
										desc = L["Configuration Panel Message Profile Copy Lottery Desc"],
										style = "dropdown",
										width = "normal",
										values = function()
											local c = 0
											Variables[8][2] = {}
											if glrHistory ~= nil then
												if glrHistory.Profile ~= nil then
													if glrHistory.Profile.Messages ~= nil then
														if glrHistory.Profile.Messages.Lottery ~= nil then
															for id, val in pairs(glrHistory.Profile.Messages.Lottery) do
																if id ~= FullPlayerName then
																	table.insert(Variables[8][2], id)
																	c = c + 1
																end
															end
														end
													end
												end
											end
											if c >= 1 then
												sort(Variables[8][2])
												return Variables[8][2]
											else
												table.insert(Variables[8][2], L["GLR - Error - No Entries Found"])
												return Variables[8][2]
											end
										end,
										get = function()
											return Variables[4][3]
										end,
										set = function(_, key)
											Variables[4][3] = key
											local name = Variables[8][2][key]
											if name ~= L["GLR - Error - No Entries Found"] then
												for i = 1, #glrHistory.Profile.Messages.Lottery[name] - 1 do
													glrHistory.Profile.Messages.Lottery[FullPlayerName][i] = glrHistory.Profile.Messages.Lottery[name][i]
													glrCharacter.Data.Messages.GuildAlerts.Lottery[i] = glrHistory.Profile.Messages.Lottery[name][i]
												end
												GLR:Print("Copied Lottery Message Profile from: " .. name)
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SelectLotteryMessageProfile() - Copied Profile From: [" .. name .. "]")
											end
										end,
									},
								},
							},
							RaffleMessageProfileTab = {
								order = 2,
								type = "group",
								name = L["Raffle"],
								childGroups = "tab",
								args = {
									SelectRaffleMessageProfile = {
										order = 1,
										type = "select",
										name = L["Configuration Panel Options Profile Copy"],
										desc = L["Configuration Panel Message Profile Copy Raffle Desc"],
										style = "dropdown",
										width = "normal",
										values = function()
											local c = 0
											Variables[8][4] = {}
											if glrHistory ~= nil then
												if glrHistory.Profile ~= nil then
													if glrHistory.Profile.Messages ~= nil then
														if glrHistory.Profile.Messages.Raffle ~= nil then
															for id, val in pairs(glrHistory.Profile.Messages.Raffle) do
																if id ~= FullPlayerName then
																	table.insert(Variables[8][4], id)
																	c = c + 1
																end
															end
														end
													end
												end
											end
											if c >= 1 then
												sort(Variables[8][4])
												return Variables[8][4]
											else
												table.insert(Variables[8][4], L["GLR - Error - No Entries Found"])
												return Variables[8][4]
											end
										end,
										get = function()
											return Variables[4][4]
										end,
										set = function(_, key)
											Variables[4][4] = key
											local name = Variables[8][4][key]
											if name ~= L["GLR - Error - No Entries Found"] then
												for i = 1, #glrHistory.Profile.Messages.Raffle[name] - 1 do
													glrHistory.Profile.Messages.Raffle[FullPlayerName][i] = glrHistory.Profile.Messages.Raffle[name][i]
													glrCharacter.Data.Messages.GuildAlerts.Raffle[i] = glrHistory.Profile.Messages.Raffle[name][i]
												end
												GLR:Print("Copied Raffle Message Profile from: " .. name)
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SelectRaffleMessageProfile() - Copied Profile From: [" .. name .. "]")
											end
										end,
									},
								},
							},
							BothMessageProfileTab = {
								order = 3,
								type = "group",
								name = L["Both"],
								childGroups = "tab",
								args = {
									SelectBothMessageProfile = {
										order = 1,
										type = "select",
										name = L["Configuration Panel Options Profile Copy"],
										desc = L["Configuration Panel Message Profile Copy Both Desc"],
										style = "dropdown",
										width = "normal",
										values = function()
											local c = 0
											Variables[8][5] = {}
											if glrHistory ~= nil then
												if glrHistory.Profile ~= nil then
													if glrHistory.Profile.Messages ~= nil then
														if glrHistory.Profile.Messages.Both ~= nil then
															for id, val in pairs(glrHistory.Profile.Messages.Both) do
																if id ~= FullPlayerName then
																	table.insert(Variables[8][5], id)
																	c = c + 1
																end
															end
														end
													end
												end
											end
											if c >= 1 then
												sort(Variables[8][5])
												return Variables[8][5]
											else
												table.insert(Variables[8][5], L["GLR - Error - No Entries Found"])
												return Variables[8][5]
											end
										end,
										get = function()
											return Variables[4][5]
										end,
										set = function(_, key)
											Variables[4][5] = key
											local name = Variables[8][5][key]
											if name ~= L["GLR - Error - No Entries Found"] then
												for i = 1, #glrHistory.Profile.Messages.Both[name] - 1 do
													glrHistory.Profile.Messages.Both[FullPlayerName][i] = glrHistory.Profile.Messages.Both[name][i]
													glrCharacter.Data.Messages.GuildAlerts.Both[i] = glrHistory.Profile.Messages.Both[name][i]
												end
												GLR:Print("Copied Both (used when Lottery & Raffle Events are both active) Message Profile from: " .. name)
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SelectBothMessageProfile() - Copied Profile From: [" .. name .. "]")
											end
										end,
									},
								},
							},
						},
					},
					WhispersProfileTab = {
						order = 6,
						type = "group",
						name = L["Configuration Panel Whispers Tab"],
						childGroups = "tree",
						args = {
							LotteryWhispersProfileTab = {
								order = 1,
								type = "group",
								name = L["Lottery"],
								childGroups = "tab",
								args = {
									SelectLotteryWhispersProfile = {
										order = 1,
										type = "select",
										name = L["Configuration Panel Options Profile Copy"],
										desc = L["Configuration Panel Whispers Profile Copy Lottery Desc"],
										style = "dropdown",
										width = "normal",
										values = function()
											local c = 0
											Variables[8][8] = {}
											if glrHistory ~= nil then
												if glrHistory.Whispers ~= nil then
													for id, val in pairs(glrHistory.Whispers) do
														if id ~= FullPlayerName then
															table.insert(Variables[8][8], id)
															c = c + 1
														end
													end
												end
											end
											if c >= 1 then
												sort(Variables[8][8])
												return Variables[8][8]
											else
												table.insert(Variables[8][8], L["GLR - Error - No Entries Found"])
												return Variables[8][8]
											end
										end,
										get = function()
											return Variables[4][11]
										end,
										set = function(_, key)
											Variables[4][11] = key
											local name = Variables[8][8][key]
											if name ~= L["GLR - Error - No Entries Found"] then
												glrHistory.Whispers[FullPlayerName][1] = glrHistory.Whispers[name][1]
												glrHistory.Whispers[FullPlayerName][3][1] = glrHistory.Whispers[name][3][1]
												GLR:Print("Copied Lottery Whisper Profile from: " .. name)
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SelectLotteryWhispersProfile() - Copied Profile From: [" .. name .. "]")
											end
										end,
									},
								},
							},
							RaffleWhispersProfileTab = {
								order = 2,
								type = "group",
								name = L["Raffle"],
								childGroups = "tab",
								args = {
									SelectRaffleWhispersProfile = {
										order = 1,
										type = "select",
										name = L["Configuration Panel Options Profile Copy"],
										desc = L["Configuration Panel Whispers Profile Copy Raffle Desc"],
										style = "dropdown",
										width = "normal",
										values = function()
											local c = 0
											Variables[8][9] = {}
											if glrHistory ~= nil then
												if glrHistory.Whispers ~= nil then
													for id, val in pairs(glrHistory.Whispers) do
														if id ~= FullPlayerName then
															table.insert(Variables[8][9], id)
															c = c + 1
														end
													end
												end
											end
											if c >= 1 then
												sort(Variables[8][9])
												return Variables[8][9]
											else
												table.insert(Variables[8][9], L["GLR - Error - No Entries Found"])
												return Variables[8][9]
											end
										end,
										get = function()
											return Variables[4][12]
										end,
										set = function(_, key)
											Variables[4][12] = key
											local name = Variables[8][9][key]
											if name ~= L["GLR - Error - No Entries Found"] then
												glrHistory.Whispers[FullPlayerName][2] = glrHistory.Whispers[name][2]
												glrHistory.Whispers[FullPlayerName][3][2] = glrHistory.Whispers[name][3][2]
												GLR:Print("Copied Raffle Whisper Profile from: " .. name)
												local timestamp = GetTimeStamp()
												table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SelectRaffleWhispersProfile() - Copied Profile From: [" .. name .. "]")
											end
										end,
									},
								},
							},
						},
					},
				},
			},
			messageOptions = {
				order = 5,
				type = "group",
				name = L["Configuration Panel Message Tab"],
				childGroups = "tab",
				args = {
					GuildAlertMessageTab_Header = {
						order = 0,
						type = "header",
						name = "Custom Guild Alert Messages",
					},
					GuildAlertMessageTab_Execute_ShowFormats = {
						order = 2,
						type = "execute",
						name = function(info) if Variables[5][5] then return "Hide Formats" else return "Show Formats" end end,
						desc = function(info)
							if Variables[5][5] then
								return "Hide the available Formats"
							else
								return "Show the available Formats"
							end
						end,
						func = function()
							if Variables[5][5] then
								Variables[5][5] = false
							else
								Variables[5][5] = true
							end
						end,
					},
					GuildAlertMessageTab_List_ShowFormatType = {
						order = 3,
						type = "select",
						name = "Format Type",
						values = function()
							local t = { [1] = L["Lottery"], [2] = L["Raffle"] }
							return t
						end,
						get = function()
							return Variables[4][8]
						end,
						set = function(_, key)
							Variables[4][8] = key
						end,
					},
					GuildAlertMessageTab_List_ShowFormats = {
						order = 4,
						type = "description",
						name = function(info)
							local msg = ""
							if Variables[4][8] == 1 then
								msg = string.gsub(L["Configuration Panel Message Tab Formats Lottery"], "%%vs", GLR_CurrentVersionString)
							else
								msg = string.gsub(L["Configuration Panel Message Tab Formats Raffle"], "%%vs", GLR_CurrentVersionString)
							end
							return msg
						end,
						hidden = function(self) if Variables[5][5] then return false else return true end end,
						width = "full",
					},
					GuildAlertMessageTab_Lottery = {
						order = 5,
						type = "group",
						name = L["Configuration Panel Message Tab Guild Alert (L) Config"],
						childGroups = "tree",
						args = {
							GuildAlert_Lottery_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Message Tab Guild Alert (L) Name"],
							},
							GuildAlert_Lottery_Enable = {
								order = 2,
								type = "toggle",
								name = L["Configuration Panel Message Enable Lottery"],
								width = "full",
								get = function()
									return glrCharacter.Data.Messages.GuildAlerts.Lottery[8]
								end,
								set = function(info, val)
									glrCharacter.Data.Messages.GuildAlerts.Lottery[8] = val
								end,
							},
							GuildAlert_Lottery_Settings = {
								order = 3,
								type = "group",
								name = L["Configuration Panel Message Settings"],
								desc = L["Configuration Panel Message Settings Desc"],
								childGroups = "tab",
								args = {
									GuildAlert_Lottery_1 = {
										order = 1,
										type = "input",
										name = L["Configuration Panel Message One"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[1]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[1] = val
											end
										end,
									},
									GuildAlert_Lottery_2 = {
										order = 2,
										type = "input",
										name = L["Configuration Panel Message Two"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[2]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[2] = val
											end
										end,
									},
									GuildAlert_Lottery_3 = {
										order = 3,
										type = "input",
										name = L["Configuration Panel Message Three"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[3]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[3] = val
											end
										end,
									},
									GuildAlert_Lottery_4 = {
										order = 4,
										type = "input",
										name = L["Configuration Panel Message Four"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[4]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[4] = val
											end
										end,
									},
									GuildAlert_Lottery_5 = {
										order = 5,
										type = "input",
										name = L["Configuration Panel Message Five"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[5]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[5] = val
											end
										end,
									},
									GuildAlert_Lottery_6 = {
										order = 6,
										type = "input",
										name = L["Configuration Panel Message Six"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[6]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[6] = val
											end
										end,
									},
									GuildAlert_Lottery_7 = {
										order = 7,
										type = "input",
										name = L["Configuration Panel Message Seven"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Lottery[7]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Lottery[7] = val
											end
										end,
									},
								},
							},
							GuildAlert_Lottery_Preview = {
								order = 4,
								type = "group",
								name = L["Configuration Panel Preview"],
								childGroups = "tab",
								args = {
									GuildAlert_Lottery_Preview_Header = {
										order = 0,
										type = "header",
										name = L["Configuration Panel Message Preview"],
									},
									GuildAlert_Lottery_Preview_1 = {
										order = 1,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[1], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[1], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_2 = {
										order = 2,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[2], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[2], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_3 = {
										order = 3,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[3], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[3], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_4 = {
										order = 4,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[4], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[4], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_5 = {
										order = 5,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[5], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[5], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_6 = {
										order = 6,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[6], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[6], "Lottery") end,
									},
									GuildAlert_Lottery_Preview_7 = {
										order = 7,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[7], "Lottery") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Lottery[7], "Lottery") end,
									},
								},
							},
						},
					},
					GuildAlertMessageTab_Raffle = {
						order = 5,
						type = "group",
						name = L["Configuration Panel Message Tab Guild Alert (R) Config"],
						childGroups = "tree",
						args = {
							GuildAlert_Raffle_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Message Tab Guild Alert (R) Name"],
							},
							GuildAlert_Raffle_Enable = {
								order = 2,
								type = "toggle",
								name = L["Configuration Panel Message Enable Raffle"],
								width = "full",
								get = function()
									return glrCharacter.Data.Messages.GuildAlerts.Raffle[9]
								end,
								set = function(info, val)
									glrCharacter.Data.Messages.GuildAlerts.Raffle[9] = val
								end,
							},
							GuildAlert_Raffle_Settings = {
								order = 3,
								type = "group",
								name = L["Configuration Panel Message Settings"],
								desc = L["Configuration Panel Message Settings Desc"],
								childGroups = "tab",
								args = {
									GuildAlert_Raffle_1 = {
										order = 1,
										type = "input",
										name = L["Configuration Panel Message One"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[1]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[1] = val
											end
										end,
									},
									GuildAlert_Raffle_2 = {
										order = 2,
										type = "input",
										name = L["Configuration Panel Message Two"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[2]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[2] = val
											end
										end,
									},
									GuildAlert_Raffle_3 = {
										order = 3,
										type = "input",
										name = L["Configuration Panel Message Three"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[3]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[3] = val
											end
										end,
									},
									GuildAlert_Raffle_4 = {
										order = 4,
										type = "input",
										name = L["Configuration Panel Message Four"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[4]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[4] = val
											end
										end,
									},
									GuildAlert_Raffle_5 = {
										order = 5,
										type = "input",
										name = L["Configuration Panel Message Five"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[5]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[5] = val
											end
										end,
									},
									GuildAlert_Raffle_6 = {
										order = 6,
										type = "input",
										name = L["Configuration Panel Message Six"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[6]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[6] = val
											end
										end,
									},
									GuildAlert_Raffle_7 = {
										order = 7,
										type = "input",
										name = L["Configuration Panel Message Seven"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[7]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[7] = val
											end
										end,
									},
									GuildAlert_Raffle_8 = {
										order = 8,
										type = "input",
										name = L["Configuration Panel Message Eight"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Raffle[8]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Raffle[8] = val
											end
										end,
									},
								},
							},
							GuildAlert_Raffle_Preview = {
								order = 4,
								type = "group",
								name = L["Configuration Panel Preview"],
								childGroups = "tab",
								args = {
									GuildAlert_Raffle_Preview_Header = {
										order = 0,
										type = "header",
										name = L["Configuration Panel Message Preview"],
									},
									GuildAlert_Raffle_Preview_1 = {
										order = 1,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[1], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[1], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_2 = {
										order = 2,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[2], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[2], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_3 = {
										order = 3,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[3], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[3], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_4 = {
										order = 4,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[4], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[4], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_5 = {
										order = 5,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[5], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[5], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_6 = {
										order = 6,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[6], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[6], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_7 = {
										order = 7,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[7], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[7], "Raffle") end,
									},
									GuildAlert_Raffle_Preview_8 = {
										order = 8,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[8], "Raffle") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Raffle[8], "Raffle") end,
									},
								},
							},
						},
					},
					GuildAlertMessageTab_Both = {
						order = 6,
						type = "group",
						name = L["Configuration Panel Message Tab Guild Alert (B) Config"],
						childGroups = "tree",
						args = {
							GuildAlert_Both_Header = {
								order = 1,
								type = "header",
								name = L["Configuration Panel Message Tab Guild Alert (B) Name"],
							},
							GuildAlert_Both_Enable = {
								order = 2,
								type = "toggle",
								name = L["Configuration Panel Message Enable Both"],
								desc = L["Configuration Panel Message Enable Both Desc"],
								width = "full",
								get = function()
									if not glrCharacter.Data.Messages.GuildAlerts.Lottery[8] then
										glrCharacter.Data.Messages.GuildAlerts.Both[12] = false
									end
									if not glrCharacter.Data.Messages.GuildAlerts.Raffle[9] then
										glrCharacter.Data.Messages.GuildAlerts.Both[12] = false
									end
									return glrCharacter.Data.Messages.GuildAlerts.Both[12]
								end,
								set = function(info, val)
									local lottery = glrCharacter.Data.Messages.GuildAlerts.Lottery[8]
									local raffle = glrCharacter.Data.Messages.GuildAlerts.Raffle[8]
									if lottery and raffle then
										glrCharacter.Data.Messages.GuildAlerts.Both[12] = val
									end
								end,
							},
							GuildAlert_Both_Settings = {
								order = 3,
								type = "group",
								name = L["Configuration Panel Message Settings"],
								desc = L["Configuration Panel Message Settings Desc"],
								childGroups = "tab",
								args = {
									GuildAlert_Both_1 = {
										order = 1,
										type = "input",
										name = L["Configuration Panel Message One"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[1]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[1] = val
											end
										end,
									},
									GuildAlert_Both_2 = {
										order = 2,
										type = "input",
										name = L["Configuration Panel Message Two"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[2]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[2] = val
											end
										end,
									},
									GuildAlert_Both_3 = {
										order = 3,
										type = "input",
										name = L["Configuration Panel Message Three"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[3]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[3] = val
											end
										end,
									},
									GuildAlert_Both_4 = {
										order = 4,
										type = "input",
										name = L["Configuration Panel Message Four"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[4]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[4] = val
											end
										end,
									},
									GuildAlert_Both_5 = {
										order = 5,
										type = "input",
										name = L["Configuration Panel Message Five"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[5]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[5] = val
											end
										end,
									},
									GuildAlert_Both_6 = {
										order = 6,
										type = "input",
										name = L["Configuration Panel Message Six"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[6]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[6] = val
											end
										end,
									},
									GuildAlert_Both_7 = {
										order = 7,
										type = "input",
										name = L["Configuration Panel Message Seven"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[7]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[7] = val
											end
										end,
									},
									GuildAlert_Both_8 = {
										order = 8,
										type = "input",
										name = L["Configuration Panel Message Eight"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[8]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[8] = val
											end
										end,
									},
									GuildAlert_Both_9 = {
										order = 9,
										type = "input",
										name = L["Configuration Panel Message Nine"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[9]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[9] = val
											end
										end,
									},
									GuildAlert_Both_10 = {
										order = 10,
										type = "input",
										name = L["Configuration Panel Message Ten"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[10]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[10] = val
											end
										end,
									},
									GuildAlert_Both_11 = {
										order = 11,
										type = "input",
										name = L["Configuration Panel Message Eleven"],
										width = "full",
										get = function()
											return glrCharacter.Data.Messages.GuildAlerts.Both[11]
										end,
										set = function(info, val)
											local text = string.len(val)
											if text > 255 then
												GLR:Print(L["Configuration Panel Message Too Long"])
											else
												glrCharacter.Data.Messages.GuildAlerts.Both[11] = val
											end
										end,
									},
								},
							},
							GuildAlert_Both_Preview = {
								order = 4,
								type = "group",
								name = L["Configuration Panel Preview"],
								childGroups = "tab",
								args = {
									GuildAlert_Both_Preview_Header = {
										order = 0,
										type = "header",
										name = L["Configuration Panel Message Preview"],
									},
									GuildAlert_Both_Preview_1 = {
										order = 1,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[1], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[1], "Both") end,
									},
									GuildAlert_Both_Preview_2 = {
										order = 2,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[2], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[2], "Both") end,
									},
									GuildAlert_Both_Preview_3 = {
										order = 3,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[3], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[3], "Both") end,
									},
									GuildAlert_Both_Preview_4 = {
										order = 4,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[4], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[4], "Both") end,
									},
									GuildAlert_Both_Preview_5 = {
										order = 5,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[5], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[5], "Both") end,
									},
									GuildAlert_Both_Preview_6 = {
										order = 6,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[6], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[6], "Both") end,
									},
									GuildAlert_Both_Preview_7 = {
										order = 7,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[7], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[7], "Both") end,
									},
									GuildAlert_Both_Preview_8 = {
										order = 8,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[8], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[8], "Both") end,
									},
									GuildAlert_Both_Preview_9 = {
										order = 9,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[9], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[9], "Both") end,
									},
									GuildAlert_Both_Preview_10 = {
										order = 10,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[10], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[10], "Both") end,
									},
									GuildAlert_Both_Preview_11 = {
										order = 11,
										type = "description",
										hidden = function(self) local msg = PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[11], "Both") if msg == "" then return true else return false end end,
										name = function(info) return PreviewMessage(glrCharacter.Data.Messages.GuildAlerts.Both[11], "Both") end,
									},
								},
							},
						},
					},
				},
			},
			whisperOptions = {
				order = 6,
				type = "group",
				name = L["Configuration Panel Whispers Tab"],
				childGroups = "tab",
				args = {
					WhispersHeader_Header = {
						order = 0,
						type = "header",
						name = "Whispers Customization",
					},
					-- WhispersHeader_Description = {
						-- order = 1,
						-- type = "description",
						-- name = "Here you can add messages sent to Players via Whisper. The default messages are always sent to the Player.",
						-- width = "full",
					-- },
					Whispers_Formats_Execute = {
						order = 2,
						type = "execute",
						name = function(info) if Variables[5][7] then return "Hide Formats" else return "Show Formats" end end,
						desc = function(info)
							if Variables[5][7] then
								return "Hide the available Formats"
							else
								return "Show the available Formats"
							end
						end,
						func = function()
							if Variables[5][7] then
								Variables[5][7] = false
							else
								Variables[5][7] = true
							end
						end,
					},
					Whispers_FormatType_List = {
						order = 3,
						type = "select",
						name = "Format Type",
						values = function()
							local t = { [1] = L["Lottery"], [2] = L["Raffle"] }
							return t
						end,
						get = function()
							return Variables[4][9]
						end,
						set = function(_, key)
							Variables[4][9] = key
						end,
					},
					Whispers_ShowFormats_List = {
						order = 4,
						type = "description",
						name = function(info)
							local msg = ""
							if Variables[4][9] == 1 then
								msg = string.gsub(L["Configuration Panel Whispers Tab Formats Lottery"], "%%vs", GLR_CurrentVersionString)
							else
								msg = string.gsub(L["Configuration Panel Whispers Tab Formats Raffle"], "%%vs", GLR_CurrentVersionString)
							end
							return msg
						end,
						width = "full",
						hidden = function(self) if Variables[5][7] then return false else return true end end,
					},
					WhispersTab_Lottery = {
						order = 10,
						type = "group",
						name = "Lottery",
						childGroups = "tab",
						args = {
							Whispers_Lottery_Enable = {
								order = 0,
								type = "toggle",
								name = "Enable Custom Whisper Messages for Lottery Events",
								desc = "Custom Whispers only affect messages sent to Players when they request info, not when adding new Players to your Event.",
								width = "full",
								get = function()
									return glrHistory.Whispers[FullPlayerName][1]
								end,
								set = function(info, val)
									glrHistory.Whispers[FullPlayerName][1] = val
								end,
							},
							Whispers_Lottery_Preview_Execute = {
								order = 1,
								type = "execute",
								name = "Preview",
								width = "normal",
								desc = "Prints to chat a preview of what a whisper from you will look like.",
								func = function()
									UpdateWhisperVariables("Lottery")
									WhisperPreview(glrHistory.Whispers[FullPlayerName][3][1], "Lottery")
								end,
							},
							Whispers_Lottery_PreviewType_List = {
								order = 3,
								type = "select",
								name = "Preview Type",
								desc = "Select which type of message you'd like to Preview.\n\n|cFF87CEFAEntered|r -> View the message as though you're already entered your own Event.\n\n|cFF87CEFANot Entered|r -> View the message as though you've yet to enter the Event.",
								values = function()
									local t = { [1] = "Entered", [2] = "Not Entered" }
									return t
								end,
								get = function()
									return Variables[4][10]
								end,
								set = function(_, key)
									Variables[4][10] = key
								end,
							},
							Whispers_Lottery_Settings_Input = {
								order = 10,
								type = "input",
								multiline = 15,
								name = "Messages:",
								desc = function(self)
									local text = L["GLR - Core - Whisper Default"] .. "\n\n" .. L["GLR - Core - Whisper Description"]
									local price = "1g"
									if glrCharacter.Data.Settings.CurrentlyActiveLottery then
										price = GLR_U:GetMoneyValue(glrCharacter.Event.Lottery.TicketPrice, "Lottery", false, 1, "NA", true, false)
									end
									text = string.gsub(string.gsub(string.gsub(text, "%%tp", price), "%%md", string.lower(L["Lottery"])), "%%e", L["Lottery"])
									return text
								end,
								width = "full",
								get = function()
									local faction, _ = UnitFactionGroup("PLAYER")
									return glrHistory.Whispers[FullPlayerName][3][1]
								end,
								set = function(info, val)
									glrHistory.Whispers[FullPlayerName][3][1] = val
								end,
							},
						},
					},
					WhispersTab_Raffle = {
						order = 11,
						type = "group",
						name = "Raffle",
						childGroups = "tab",
						args = {
							Whispers_Raffle_Enable = {
								order = 0,
								type = "toggle",
								name = "Enable Custom Whisper Messages for Raffle Events",
								desc = "Custom Whispers only affect messages sent to Players when they request info, not when adding new Players to your Event.",
								width = "full",
								get = function()
									return glrHistory.Whispers[FullPlayerName][2]
								end,
								set = function(info, val)
									glrHistory.Whispers[FullPlayerName][2] = val
								end,
							},
							Whispers_Raffle_Preview_Execute = {
								order = 1,
								type = "execute",
								name = "Preview",
								desc = "Prints to chat a preview of what a whisper from you will look like.",
								width = "normal",
								func = function()
									UpdateWhisperVariables("Raffle")
									WhisperPreview(glrHistory.Whispers[FullPlayerName][3][2], "Raffle")
								end,
							},
							Whispers_Raffle_PreviewType_List = {
								order = 3,
								type = "select",
								name = "Preview Type",
								desc = "Select which type of message you'd like to Preview.\n\n|cFF87CEFAEntered|r -> View the message as though you're already entered your own Event.\n\n|cFF87CEFANot Entered|r -> View the message as though you've yet to enter the Event.",
								values = function()
									local t = { [1] = "Entered", [2] = "Not Entered" }
									return t
								end,
								get = function()
									return Variables[4][10]
								end,
								set = function(_, key)
									Variables[4][10] = key
								end,
							},
							Whispers_Raffle_Settings_Input = {
								order = 10,
								type = "input",
								multiline = 15,
								name = "Messages:",
								desc = function(self)
									local text = L["GLR - Core - Whisper Default"] .. "\n\n" .. L["GLR - Core - Whisper Description"]
									local price = "1g"
									if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
										price = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketPrice, "Raffle", false, 1, "NA", true, false)
									end
									text = string.gsub(string.gsub(string.gsub(text, "%%tp", price), "%%md", string.lower(L["Raffle"])), "%%e", L["Raffle"])
									return text
								end,
								width = "full",
								get = function()
									return glrHistory.Whispers[FullPlayerName][3][2]
								end,
								set = function(info, val)
									glrHistory.Whispers[FullPlayerName][3][2] = val
								end,
							},
						},
					},
				},
			},
			giveawayOptions = {
				order = 7,
				type = "group",
				name = L["Configuration Panel Giveaway Tab"],
				childGroups = "tab",
				args = {
					Giveaway_Settings_Header = {
						order = 0,
						type = "header",
						name = "Ticket Giveaway",
					},
					Giveaway_Settings_Select_Event = {
						order = 2,
						type = "select",
						name = L["GLR - UI > Config > Giveaway - Select Event"],
						values = function()
							Variables[7][7] = { [1] = L["Lottery"], [2] = L["Raffle"] }
							if not glrCharacter.Data.Settings.CurrentlyActiveLottery then
								for i = 1, #Variables[7][7] do
									if Variables[7][7][i] == L["Lottery"] then
										table.remove(Variables[7][7], i)
									end
								end
							end
							if not glrCharacter.Data.Settings.CurrentlyActiveRaffle then
								for i = 1, #Variables[7][7] do
									if Variables[7][7][i] == L["Raffle"] then
										table.remove(Variables[7][7], i)
									end
								end
							end
							if not glrCharacter.Data.Settings.CurrentlyActiveLottery and not glrCharacter.Data.Settings.CurrentlyActiveRaffle then
								Variables[7][7] = { [1] = L["GLR - UI > Config > Giveaway - No Event Active"] }
								Variables[3][6] = 1
							end
							return Variables[7][7]
						end,
						get = function()
							if Variables[7][7][Variables[3][6]] ~= L["GLR - UI > Config > Giveaway - No Event Active"] then
								if not Variables[3][1] then
									Variables[3][1] = true
									GetValidEntries()
								end
							end
							return Variables[3][6]
						end,
						set = function(_, key)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								ResetGiveAwayTable(true)
								Variables[3][6] = key
								Variables[3][8] = 0
								if glrCharacter.Data.Settings.General.MultiGuild then Variables[3][7] = 1 end
								Variables[3][15] = 1
								Variables[3][3] = false
								Variables[3][14] = "0"
								Variables[3][13] = 0
								Variables[7][3] = { ["Alliance"] = {}, ["Horde"] = {}, }
								Variables[7][4] = { ["Alliance"] = {}, ["Horde"] = {}, }
								Variables[7][5] = { ["Alliance"] = {}, ["Horde"] = {}, }
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Select_Type = {
						order = 3,
						type = "select",
						name = L["GLR - UI > Config > Giveaway - Type"],
						desc = L["GLR - UI > Config > Giveaway - Type Desc"],
						style = "dropdown",
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						values = function()
							return GiveawayValuesTable
						end,
						get = function()
							return Variables[3][7]
						end,
						set = function(_, key)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								Variables[3][7] = key
								ResetGiveAwayTable(false)
								GiveAwayText = L["GLR - UI > Config > Giveaway - Names Available"] .. ": " .. tostring(Variables[3][13])
								if Variables[3][4] then
									if Variables[3][5] then
										if tonumber(Variables[3][14]) > tonumber(Variables[3][13]) then
											Variables[3][14] = tostring(Variables[3][13])
											Variables[3][10] = Variables[3][13]
											GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13])
										else
											GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
										end
									else
										GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
									end
								else
									GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13] * tonumber(Variables[3][14]))
								end
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Select_Type() - Set Giveaway Online State: [" .. tostring(key) .. "]")
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Select_Online = {
						order = 4,
						type = "select",
						name = L["GLR - UI > Config > Giveaway - Online"],
						desc = L["GLR - UI > Config > Giveaway - Online Desc"],
						style = "dropdown",
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						values = function()
							GiveawayLastOnlineTable = {
								[0] = L["GLR - UI > Config > Giveaway - Everyone"],
								[1] = L["GLR - UI > Config > Giveaway - Currently Online"],
								[2] = L["GLR - UI > Config > Giveaway - 7 Days"],
								[3] = L["GLR - UI > Config > Giveaway - 14 Days"],
								[4] = L["GLR - UI > Config > Giveaway - 21 Days"],
								[5] = L["GLR - UI > Config > Giveaway - 28 Days"],
							}
							if glrCharacter.Data.Settings.General.MultiGuild then table.remove(GiveawayLastOnlineTable, 1) end
							return GiveawayLastOnlineTable
						end,
						get = function()
							return Variables[3][8]
						end,
						set = function(_, key)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								Variables[3][8] = key
								ResetGiveAwayTable(false)
								GiveAwayText = L["GLR - UI > Config > Giveaway - Names Available"] .. ": " .. tostring(Variables[3][13])
								if Variables[3][4] then
									if Variables[3][5] then
										if tonumber(Variables[3][14]) > tonumber(Variables[3][13]) then
											Variables[3][14] = tostring(Variables[3][13])
											Variables[3][10] = Variables[3][13]
											GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13])
										else
											GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
										end
									else
										GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
									end
								else
									GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][13] * tonumber(Variables[3][14]))
								end
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Select_Online() - Set Giveaway Online State: [" .. tostring(key) .. "]")
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Spacer_0 = {
						order = 5,
						type = "description",
						name = "",
						width = "full",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
					},
					Giveaway_Settings_Input_Amount = {
						order = 6,
						type = "input",
						name = L["GLR - UI > Config > Giveaway - Tickets"],
						desc = function(info) return string.gsub(L["GLR - UI > Config > Giveaway - Tickets Desc"], "%%t", Variables[3][14]) end,
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						get = function()
							return Variables[3][14]
						end,
						set = function(info, val)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								ResetGiveAwayTable(false)
								local EventType = ""
								if Variables[7][7][Variables[3][6]] == L["Lottery"] then
									EventType = "Lottery"
								elseif Variables[7][7][Variables[3][6]] == L["Raffle"] then
									EventType = "Raffle"
								end
								local text = tonumber(val)
								if text == nil then
									text = "0"
								else
									if text >= 0 then
										if string.find(val, '%.') then
											text = string.sub(val, 1, string.find(val, '%.') - 1)
										else
											text = tostring(text)
										end
									else
										text = "0"
									end
								end
								local MaxTickets = tonumber(glrCharacter.Event[EventType].MaxTickets)
								if tonumber(val) ~= nil and MaxTickets ~= nil then
									if tonumber(val) > MaxTickets then
										if not Variables[3][4] then
											text = tostring(MaxTickets)
										else
											if Variables[3][5] then
												if tonumber(val) > Variables[3][9] then
													text = tostring(Variables[3][9])
												end
											else
												local TOTAL = Variables[3][9] * MaxTickets
												if tonumber(val) > TOTAL then
													text = tostring(TOTAL)
												end
											end
										end
									end
								end
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Input_Amount() - Set Giveaway Input Amount: [" .. tostring(text) .. "]")
								Variables[3][14] = text
								Variables[3][10] = tonumber(text)
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Spacer_1 = {
						order = 7,
						type = "description",
						name = "",
						width = "full",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
					},
					Giveaway_Settings_Toggle_Randomize = {
						order = 8,
						type = "toggle",
						name = "Randomize Giveaway",
						desc = "By enabling the Randomize Giveaway option. The number of Tickets you wish to give will be divided randomly amongst the people you wish to give them to.\nThis process assigns one Ticket at a time to a randomly selected Player.",
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						get = function()
							return Variables[3][4]
						end,
						set = function(info, val)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Toggle_Randomize() - Set Randomize Giveawayd State: [" .. string.upper(tostring(val)) .. "]")
								Variables[3][4] = val
								if not val then
									Variables[3][5] = false
								end
								ResetGiveAwayTable(false)
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Toggle_OneTicketPerPlayer = {
						order = 9,
						type = "toggle",
						name = "One Per Player",
						desc = "This option can only be enabled when Randomize Giveaway is enabled.\n\nWith this enabled, the number of Tickets you wish to give to Players is also the number of Players to receive a single Ticket.",
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] or not Variables[3][4] then return true else return false end end,
						get = function()
							return Variables[3][5]
						end,
						set = function(info, val)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Toggle_OneTicketPerPlayer() - Set Randomize One Ticket Per Player State: [" .. string.upper(tostring(val)) .. "]")
								Variables[3][5] = val
								if val then
									if tonumber(Variables[3][13]) ~= nil then
										if tonumber(Variables[3][14]) > tonumber(Variables[3][13]) then
											Variables[3][14] = tostring(Variables[3][13])
											Variables[3][10] = Variables[3][13]
											GiveAwayTotalTicketsText = L["GLR - UI > Config > Giveaway - Total Tickets To Give"] .. ": " .. tostring(Variables[3][14])
										end
									end
								end
							end
						end,
					},
					Giveaway_Settings_Toggle_Confirm = {
						order = 10,
						type = "toggle",
						name = L["GLR - UI > Config - Confirm Action"],
						width = "normal",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] or Variables[3][14] == "0" or Variables[3][13] == 0 then return true else return false end end,
						get = function()
							return Variables[3][3]
						end,
						set = function(info, val)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Toggle_Confirm() - Set Giveaway Confirm State: [" .. string.upper(tostring(val)) .. "]")
								Variables[3][3] = val
							end
						end,
					},
					Giveaway_Settings_Execute_Giveaway = {
						order = 11,
						type = "execute",
						name = L["GLR - UI > Config > Giveaway - Start"],
						desc = L["GLR - UI > Config > Giveaway - Start Desc"],
						width = "normal",
						hidden = function(self) if Variables[3][3] then return false else return true end end,
						func = function()
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								if not Variables[3][4] then
									Variables[3][12] = Variables[3][13]
								else
									Variables[3][12] = tonumber(Variables[3][14])
								end
								Variables[3][2] = true
								Variables[7][10] = Variables[7][9]
								if Variables[7][7][Variables[3][6]] == L["Lottery"] then
									GiveEveryoneTickets(Variables[3][14], "Lottery", Variables[3][4])
								elseif Variables[7][7][Variables[3][6]] == L["Raffle"] then
									GiveEveryoneTickets(Variables[3][14], "Raffle", Variables[3][4])
								end
								GetMultiGuildTables()
								Variables[3][4] = false
								Variables[3][3] = false
								Variables[3][5] = false
								Variables[3][14] = "0"
								Variables[3][8] = 0
								Variables[3][7] = 1
							end
						end,
					},
					Giveaway_Settings_Spacer_2 = {
						order = 12,
						type = "description",
						name = "",
						width = "full",
					},
					Giveaway_Settings_Execute_GetValidEntries = {
						order = 13,
						type = "execute",
						name = "Get Valid Entries",
						width = "normal",
						hidden = function(self) if GLR_Debug_Give then return false else return true end end,
						func = function()
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Execute_GetValidEntries() - Performed Manual Execution of GetValidEntries")
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Desc_AvailableEntries = {
						order = 14,
						type = "description",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						name = function(info)
							return GiveAwayText
						end,
						width = "full",
					},
					Giveaway_Settings_Desc_TotalTicketsToGive = {
						order = 15,
						type = "description",
						hidden = function(self) if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true else return false end end,
						name = function(info)
							return GiveAwayTotalTicketsText
						end,
						width = "full",
					},
					Giveaway_Settings_Spacer_3 = {
						order = 16,
						type = "description",
						name = "",
						width = "full",
					},
					Giveaway_Settings_Select_Faction = {
						order = 17,
						type = "select",
						name = "Select Faction",
						style = "dropdown",
						width = "normal",
						hidden = function(self)	if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true elseif Variables[3][7] == 2 and glrCharacter.Data.Settings.General.MultiGuild and glrCharacter.Data.Settings.General.CrossFactionEvents then return false else return true end end,
						values = function()
							return Variables[7][6]
						end,
						get = function()
							return Variables[3][16]
						end,
						set = function(_, key)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								Variables[3][17] = Variables[7][6][key]
								Variables[3][16] = key
								Variables[3][15] = 1
								Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Select_Faction() - Set Giveaway Faction State: [" .. string.upper(Variables[3][17]) .. "]")
							end
						end,
					},
					Giveaway_Settings_Select_Guild_MultiGuild = {
						order = 18,
						type = "select",
						name = L["GLR - UI > Config > Giveaway - Select Guild"],
						desc = L["GLR - UI > Config > Giveaway - Select Guild Desc"],
						style = "dropdown",
						width = "normal",
						hidden = function(self)	if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true elseif Variables[3][7] == 2 and glrCharacter.Data.Settings.General.MultiGuild then return false else return true end end,
						values = function()
							local name = GetMultiGuildList(true)
							if not glrCharacter.Data.Settings.General.CrossFactionEvents and not Variables[5][6] then
								local faction, _ = UnitFactionGroup("PLAYER")								
								for i = 1, #Variables[7][6] do
									if Variables[7][6][i] == faction then
										Variables[3][16] = i
										Variables[3][17] = Variables[7][6][Variables[3][16]]
										Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
										Variables[5][6] = true
										break
									end
								end
							end
							return name[Variables[3][17]]
						end,
						get = function()
							return Variables[3][15]
						end,
						set = function(_, key)	
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								Variables[3][15] = key
								Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Giveaway_Settings_Select_Guild_MultiGuild() - Set Giveaway Multi-Guild State: [" .. Variables[3][18] .. "]")
							end
						end,
					},
					Giveaway_Settings_Spacer_4 = {
						order = 19,
						type = "description",
						name = "",
						width = "full",
					},
					Giveaway_Settings_Desc_GuildInfoLastUpdated = {
						order = 20,
						type = "description",
						name = function(info)
							local data = "No Data Available"
							if glrHistory.LastUpdated[Variables[3][17]][Variables[3][18]] ~= nil then
								data = glrHistory.LastUpdated[Variables[3][17]][Variables[3][18]]
							end
							return "Last Updated: " .. data
						end,
						hidden = function(self)	if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true elseif Variables[3][7] == 2 and glrCharacter.Data.Settings.General.MultiGuild then return false else return true end end,
						width = "full",
					},
					Giveaway_Settings_Select_Ranks_MultiGuild = {
						order = 21,
						type = "multiselect",
						name = L["GLR - UI > Config > Giveaway - Select Rank"],
						desc = L["GLR - UI > Config > Giveaway - Select Ranks Desc"],
						hidden = function(self)	if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true elseif Variables[3][7] == 2 and glrCharacter.Data.Settings.General.MultiGuild then return false else return true end end,
						values = function()
							if GLR_GameVersion == "RETAIL" then
								C_GuildInfo.GuildRoster()
							else
								GuildRoster()
							end
							local names = GetMultiGuildList(true)
							for t, v in pairs(glrHistory.GuildRanks) do
								if Variables[7][4][t] == nil then Variables[7][4][t] = {} end
								if Variables[7][5][t] == nil then Variables[7][5][t] = {} end
								for j = 1, #names[t] do
									local name = names[t][j]
									if glrHistory.GuildRanks[t][name] ~= nil then
										for i = 1, #glrHistory.GuildRanks[t][name] do
											if Variables[7][4][t][name] == nil then
												Variables[7][4][t][name] = {}
											end
											if Variables[7][4][t][name][i] == nil then
												Variables[7][4][t][name][i] = glrHistory.GuildRanks[t][name][i]
												if Variables[7][5][t][name] == nil then
													Variables[7][5][t][name] = {}
												end
												Variables[7][5][t][name][i] = false
											end
										end
									end
								end
							end
							return Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]]
						end,
						get = function(info, key)
							return Variables[7][5][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]
						end,
						set = function(info, key, value)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								ResetGiveAwayTable(false)
								Variables[7][1][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]].State = value
								if value then
									Variables[7][2][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]].State = value
								end
								Variables[7][5][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key] = value
								GetValidEntries()
							end
						end,
					},
					Giveaway_Settings_Select_Ranks_SingleGuild = {
						order = 22,
						type = "multiselect",
						name = L["GLR - UI > Config > Giveaway - Select Rank"],
						desc = L["GLR - UI > Config > Giveaway - Select Ranks Desc"],
						hidden = function(self)	if Variables[7][7][Variables[3][6]] == L["GLR - UI > Config > Giveaway - No Event Active"] then return true elseif Variables[3][7] == 2 and not glrCharacter.Data.Settings.General.MultiGuild then return false else return true end end,
						values = function()
							if GLR_GameVersion == "RETAIL" then
								C_GuildInfo.GuildRoster()
							else
								GuildRoster()
							end
							local faction, _ = UnitFactionGroup("PLAYER")
							local guild, _, _, _ = GetGuildInfo("PLAYER")
							local names = GetMultiGuildList(true)
							if Variables[3][17] ~= faction then
								for i = 1, #Variables[7][6] do
									if Variables[7][6][i] == faction then
										Variables[3][16] = i
										Variables[3][17] = Variables[7][6][Variables[3][16]]
										break
									end
								end
							end
							if Variables[3][18] ~= guild then
								for i = 1, #Variables[7][3][Variables[3][17]] do
									if Variables[7][3][Variables[3][17]][i] == guild then
										Variables[3][15] = i
										Variables[3][18] = Variables[7][3][Variables[3][17]][Variables[3][15]]
										break
									end
								end
							end
							if Variables[7][4][faction] == nil then Variables[7][4][faction] = {} end
							if Variables[7][5][faction] == nil then Variables[7][5][faction] = {} end
							for j = 1, #names[faction] do
								local name = names[faction][j]
								if glrHistory.GuildRanks[faction][name] ~= nil then
									for i = 1, #glrHistory.GuildRanks[faction][name] do
										if Variables[7][4][faction][name] == nil then
											Variables[7][4][faction][name] = {}
										end
										if Variables[7][4][faction][name][i] == nil then
											Variables[7][4][faction][name][i] = glrHistory.GuildRanks[faction][name][i]
											if Variables[7][5][faction][name] == nil then
												Variables[7][5][faction][name] = {}
											end
											Variables[7][5][faction][name][i] = false
										end
									end
								end
							end
							return Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]]
						end,
						get = function(info, key)
							return Variables[7][5][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]
						end,
						set = function(info, key, value)
							if not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] and GLR_Global_Variables[1] then
								Variables[7][1][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]].State = value
								if value then
									Variables[7][2][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][Variables[7][4][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key]].State = value
								end
								Variables[7][5][Variables[3][17]][Variables[7][3][Variables[3][17]][Variables[3][15]]][key] = value
							end
						end,
					},
				},
			},
		},
	}
	return options
end