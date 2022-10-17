GLR_U = {}

-- Purpose of this file is to centralize all functions into one lua file that relate to updating information that GLR uses.

--Global variables
glrRosterTotal = 0
glrMultiRosterTotal = 0

--Globally used tables
glrRoster = {} --Table used to hold list of guild members for adding players to a Lottery/Raffle event. Made global so other parts of the mod can access it (the GLR_Mail.lua file)
glrMultiGuildRoster = {} --Same as glrRoster but used to combine guild Rosters if Multi-Guild is enabled.
glrLinkedNames = {}
glrLinkedGuilds = {}

--Temporary Name and Guild table used to hold true/false status until reload/logout
glrTempNames = {}
glrTempGuilds = {}
GLR_RemoveNonExistingPlayersTable = {}

GLR_Global_Variables = {
	false,						-- [1] Becomes True once the mod has finished the initial ADDON_LOADED processedGuilds
	true,						-- [2] Global variable for the mod to check/change when updating displayed information, allows for better performance. Defaults to true on login but immediately changes when updating UI.
	false,						-- [3] Becomes True if the user Aborts a Event Draw, stopping the process.
	GetLocale(),				-- [4] Becomes the users Locale
	{ false, false, false },	-- [5] Global Debug Variable for various uses.
	{ false, false, },			-- [6] Lottery | Raffle - Draw In Progress status.
}

local Variables = {
	false,				-- [1] Determines whether the mod has preformed the initial check for Invalid Entries
	false,				-- [2] Becomes True when the user preforms the "/glr checkinvalid" command, telling the mod to print to chat certain confirmation messages
}
local DebugVariables = {	-- As new variables are required, more will be added for Debug Tracing
	false,					-- [1] glrHistory.GuildRoster Table
	false,					-- [2] glrRoster Table
	false,					-- [3] glrMultiGuildRoster Table
}

local chat = DEFAULT_CHAT_FRAME
local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")
local glrLinkedNamesCount = 0
local glrLinkedGuildsCount = 0
local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
local profile = {
	bordercolor = {1, 0.87, 0, 1},
	bgcolor = {0, 0, 0, 0},
}

function GLR_U:UpdateBorderColor()
	GLR_UI.GLR_MainFrame:SetBackdropBorderColor(unpack(profile.bordercolor))
end

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

local function RemoveNonExistingPlayers(EventType)
	local state = EventType
	local Advanced = glrCharacter.Data.Settings.General.AdvancedTicketDraw
	if Variables[2] then
		local count = #GLR_RemoveNonExistingPlayersTable
		if count > 1 then
			chat:AddMessage("Removing " .. count .. " " .. state .. " Entries")
		elseif count == 1 then
			chat:AddMessage("Removing " .. count .. " " .. state .. " Entry")
		end
	end
	for i = 1, #GLR_RemoveNonExistingPlayersTable do
		if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
		local count = 1
		local tickets = 0
		local name = GLR_RemoveNonExistingPlayersTable[i]
		if not Advanced then
			for j = 1, #glrCharacter[state].Entries.TicketNumbers[name] do
				table.insert(glrCharacter[state].TicketPool, glrCharacter[state].Entries.TicketNumbers[name][j])
				tickets = tickets + 1
				if state == "Lottery" then
					if glrCharacter.Event[state].SecondPlace ~= L["Winner Guaranteed"] then
						count = 2
					end
				end
			end
		else
			tickets = glrCharacter[state].Entries.Tickets[name].NumberOfTickets
			if state == "Lottery" then
				if glrCharacter.Event[state].SecondPlace ~= L["Winner Guaranteed"] then
					count = 2
				end
			end
		end
		for j = 1, tickets do
			if glrCharacter[state].Entries.Tickets[name].Given == nil then break end
			if glrCharacter[state].Entries.Tickets[name].Sold == nil then break end
			if glrCharacter[state].Entries.Tickets[name].Given > 0 then
				glrCharacter[state].Entries.Tickets[name].Given = glrCharacter[state].Entries.Tickets[name].Given - 1
			else
				if glrCharacter[state].Entries.Tickets[name].Sold > 0 then
					if glrCharacter.Event[state].TicketsSold == 0 then break end
					glrCharacter[state].Entries.Tickets[name].Sold = glrCharacter[state].Entries.Tickets[name].Sold - 1
				else break end
			end
		end
		for j = 1, tickets do
			if Advanced then
				if state == "Lottery" then
					if glrCharacter.Event[state].SecondPlace ~= L["Winner Guaranteed"] then
						glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - 2
					else
						glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - 1
					end
				else
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - 1
				end
			end
			if glrCharacter.Event[state].GiveAwayTickets > 0 then
				glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - 1
			else
				if glrCharacter.Event[state].TicketsSold > 0 then
					glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
				else break end
			end
		end
		local message = string.gsub(string.gsub(L["GLR - Core - Invalid Player Entry Detected"], "%%n", name), "%%e", state)
		print("|cffffdf00" .. message .. "|r")
		for j = 1, #glrCharacter[state].Entries.Names do
			if name == glrCharacter[state].Entries.Names[j] then
				table.remove(glrCharacter[state].Entries.Names, j)
				break
			end
		end
		sort(glrCharacter[state].Entries.Names)
		sort(glrCharacter[state].TicketPool)
		glrCharacter[state].Entries.TicketNumbers[name] = nil
		glrCharacter[state].Entries.Tickets[name] = nil
		glrCharacter[state].Entries.TicketRange[name] = nil
	end
	GLR_RemoveNonExistingPlayersTable = {}
end

local CheckCount = 0

local function CheckForNonexistingPlayers()
	local timestamp = GetTimeStamp()
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local NameTable = glrRoster
	if status then
		NameTable = glrMultiGuildRoster
	end
	if NameTable[1] == nil then
		if CheckCount <= 6 then
			CheckCount = CheckCount + 1
			C_Timer.After(5, CheckForNonexistingPlayers)
		end
		return
	end
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		for i = 1, #glrCharacter.Lottery.Entries.Names do
			local continue = true
			local name = glrCharacter.Lottery.Entries.Names[i]
			for j = 1, #NameTable do
				local check = string.sub(NameTable[j], 1, string.find(NameTable[j], "%[") - 1)
				if check == nil then continue = false break end
				if name == check then
					continue = false
					break
				end
			end
			if continue then
				for j = 1, #GLR_RemoveNonExistingPlayersTable do
					if name == GLR_RemoveNonExistingPlayersTable[j] then
						continue = false
						break
					end
				end
				if continue then
					table.insert(GLR_RemoveNonExistingPlayersTable, name)
				end
			end
		end
		if GLR_RemoveNonExistingPlayersTable[1] ~= nil then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CheckForNonexistingPlayers() - State: [LOTTERY] Found: [" .. tostring(#GLR_RemoveNonExistingPlayersTable) .. "] Invalid Entries.")
			RemoveNonExistingPlayers("Lottery")
		elseif Variables[2] then
			chat:AddMessage("No Invalid Lottery Entries Were Found.")
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CheckForNonexistingPlayers() State: [LOTTERY] - No Invalid Entries Were Found.")
		end
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		for i = 1, #glrCharacter.Raffle.Entries.Names do
			local continue = true
			local name = glrCharacter.Raffle.Entries.Names[i]
			for j = 1, #NameTable do
				local check = string.sub(NameTable[j], 1, string.find(NameTable[j], "%[") - 1)
				if check == nil then continue = false break end
				if name == check then
					continue = false
					break
				end
			end
			if continue then
				for j = 1, #GLR_RemoveNonExistingPlayersTable do
					if name == GLR_RemoveNonExistingPlayersTable[j] then
						continue = false
						break
					end
				end
				if continue then
					table.insert(GLR_RemoveNonExistingPlayersTable, name)
				end
			end
		end
		if GLR_RemoveNonExistingPlayersTable[1] ~= nil then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CheckForNonexistingPlayers() - State: [RAFFLE] - Found: [" .. #GLR_RemoveNonExistingPlayersTable "] Invalid Entries.")
			RemoveNonExistingPlayers("Raffle")
		elseif Variables[2] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CheckForNonexistingPlayers() - State: [RAFFLE] - No Invalid Entries Were Found.")
			chat:AddMessage("No Invalid Raffle Entries Were Found.")
		end
	end
	GLR_U:UpdateInfo()
end

local CheckComplete = false
local CheckPass = false

local function CheckForNonexistingPlayersBuffer()
	if CheckPass then
		if Variables[1] then
			if CheckComplete then
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CheckForNonexistingPlayersBuffer() - Beginning Check for Non-Existing Player Entries.")
				CheckForNonexistingPlayers()
			end
		end
		if not CheckComplete then
			CheckComplete = true
			C_Timer.After(5, CheckForNonexistingPlayersBuffer)
		end
	end
	if not GLR_Global_Variables[1] then
		if not CheckPass then
			CheckPass = true
			C_Timer.After(5, CheckForNonexistingPlayersBuffer)
		end
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


--[[
	Values:
		Total - Number value that's converted into the Gold, Silver, and Copper values and returned. Ex: 0.0101 returns as 0G 01S 01C
		Event - String to track what's changed. "Lottery" will also require the Check boolean to round a value.
		Check - Boolean value used to gate certain values from being rounded.
		Round - Number value retrieved from the users saved variables (or done manually if certain values need to bypass user setting)
]]
function GLR_U:GetMoneyValue(Total, Event, Check, Round, Target, IsString, Color, IsToolTip)
	
	if IsString == nil then IsString = true end
	if Color == nil then Color = false end
	if Round == nil then Round = 1 end
	if IsToolTip == nil then IsToolTip = false end
	
	if Target ~= nil then
		if Target ~= "NA" then
			if Event == "Lottery" and Check then
				if glrHistory.TransferData[Target].Data.Settings.RoundValue ~= nil then
					Round = glrHistory.TransferData[Target].Data.Settings.RoundValue
				end
			end
		end
	end
	
	local color = 2
	if Color then
		color = 1
	end
	
	local Gold = math.floor(Total)
	local Silver = math.floor((Total * 10000 / 100) % 100)
	local Copper = math.floor(Total * 10000 % 100)
	
	if Event ~= nil and Check ~= nil then
		if Event == "Lottery" and Check then
			
			if Round == 2 or Round == 3 then
				
				if Copper > 0 then
					if Round == 3 then
						Copper = math.floor(Copper)
					else
						local _, m = math.modf(Total * 10000 % 100, 100)
						if m >= 0.5 then
							Copper = math.ceil(Copper + 0.5)
						else
							Copper = math.floor(Copper)
						end
					end
				end
				
				if Silver > 0 then
					if Round == 3 then
						Silver = math.floor(Silver)
					else
						if Copper >= 95 then
							Silver = math.ceil(Silver + 0.5)
							Copper = 0
						else
							Silver = math.floor(Silver)
						end
					end
				end
				
				if Gold > 0 then
					if Round == 3 then
						Gold = math.floor(Gold)
					else
						if Silver >= 95 then
							Gold = math.ceil(Gold + 0.5)
							Silver = 0
							Copper = 0
						else
							Gold = math.floor(Gold)
						end
					end
				end
				
			end
			
		end
	end
	
	if IsString then
		
		Gold = tostring(Gold)
		Silver = tostring(Silver)
		Copper = tostring(Copper)
		
		local t = {
			[1] = {
				[1] = L["Value_Gold_Short_Colored"],
				[2] = L["Value_Silver_Short_Colored"],
				[3] = L["Value_Copper_Short_Colored"],
			},
			[2] = {
				[1] = L["Value_Gold_Short"],
				[2] = L["Value_Silver_Short"],
				[3] = L["Value_Copper_Short"],
			},
		}
		
		if Target ~= nil then
			t[1] = {
				[1] = string.lower(L["Value_Gold_Short_Colored"]),
				[2] = string.lower(L["Value_Silver_Short_Colored"]),
				[3] = string.lower(L["Value_Copper_Short_Colored"]),
			}
		end
		
		local function GetColorScheme(text, value)
			local v = {
				[1] = { [1] = "", [2] = "|CFFFFFFFF", },
				[2] = { [1] = "", [2] = "|r", },
			}
			local use = 1
			if value then use = 2 end
			text = v[1][use] .. text .. v[2][use]
			return text
		end
		
		if tonumber(Copper) == 0 then
			if tonumber(Silver) == 0 then
				if tonumber(Gold) > 0 then
					Gold = CommaValue(Gold)
					Total = GetColorScheme(Gold, IsToolTip) .. t[color][1]
				else
					Total = GetColorScheme(Gold, IsToolTip) .. t[color][1] .. " " .. GetColorScheme(Silver, IsToolTip) .. t[color][2] .. " " .. GetColorScheme(Copper, IsToolTip) .. t[color][3]
				end
			else
				if tonumber(Gold) == 0 then
					Total = GetColorScheme(Silver, IsToolTip) .. t[color][2]
				else
					Gold = CommaValue(Gold)
					Total = GetColorScheme(Gold, IsToolTip) .. t[color][1] .. " " .. GetColorScheme(Silver, IsToolTip) .. t[color][2]
				end
			end
		else
			if tonumber(Silver) == 0 then
				if tonumber(Gold) == 0 then
					Total = GetColorScheme(Copper, IsToolTip) .. t[color][3]
				else
					Gold = CommaValue(Gold)
					Total = GetColorScheme(Gold, IsToolTip) .. t[color][1] .. " " .. GetColorScheme(Copper, IsToolTip) .. t[color][3]
				end
			else
				if tonumber(Gold) == 0 then
					Total = GetColorScheme(Silver, IsToolTip) .. t[color][2] .. " " .. GetColorScheme(Copper, IsToolTip) .. t[color][3]
				else
					Gold = CommaValue(Gold)
					Total = GetColorScheme(Gold, IsToolTip) .. t[color][1] .. " " .. GetColorScheme(Silver, IsToolTip) .. t[color][2] .. " " .. GetColorScheme(Copper, IsToolTip) .. t[color][3]
				end
			end
		end
		return Total
	else
		if Silver < 10 then
			Silver = "0" .. tostring(Silver)
		end
		if Copper < 10 then
			Copper = "0" .. tostring(Copper)
		end
		Total = tonumber(Gold .. "." .. Silver .. Copper)
		return Total
	end
end

--------------------------------------------- ---------
---------------- UPDATE INFO ----------------
---------------------------------------------
------- USED TO UPDATE DISPLAYED INFO -------
---------------------------------------------

local InitialUpdate = false
function GLR_U:UpdateInfo(state)
	
	local CheckGuild = GLR_U:CheckGuildName()
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local GetMonth = GLR:GetCurrentMonth()
	local GetDay = GLR:GetCurrentDay()
	local GetYear = GLR:GetCurrentYear()
	local GetHour = GLR:GetCurrentHour()
	local GetMinute = GLR:GetCurrentMinute()
	local status = glrCharacter.Data.Settings.General.Status
	local EditCalendarEvents = glrCharacter.Data.Settings.General.CreateCalendarEvents
	if state == nil then state = true end
	
	if not InitialUpdate then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateInfo() - Preforming Initial Update of Display Info")
	end
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetText(GetMonth)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetText(GetDay)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetText(GetYear)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:SetText(GetHour)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetText(GetMinute)
	
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetText(GetMonth)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetText(GetDay)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetText(GetYear)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:SetText(GetHour)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetText(GetMinute)
	
	if CheckGuild then
		guildName, _, _, _ = GetGuildInfo("PLAYER")
	end
	
	if guildName == nil then
		guildName = "GLR - No Guild"
	end
	
	if glrCharacter.Data.Settings.General.GuildName == nil then
		glrCharacter.Data.Settings.General.GuildName = guildName
	end
	
	if glrCharacter.Data.Settings.CurrentlyActiveLottery == nil then
		glrCharacter.Data.Settings.CurrentlyActiveLottery = false
	elseif glrCharacter.Data.Settings.CurrentlyActiveLottery then
		if glrCharacter.Event.Lottery.GiveAwayTickets == nil then
			glrCharacter.Event.Lottery.GiveAwayTickets = 0
		end
		if glrCharacter.Event.Lottery.TicketsSold == nil or glrCharacter.Event.Lottery.GuildCut == nil or glrCharacter.Event.Lottery.MaxTickets == nil or glrCharacter.Event.Lottery.FirstTicketNumber == nil or glrCharacter.Event.Lottery.Date == nil or glrCharacter.Event.Lottery.EventName == nil or glrCharacter.Event.Lottery.TicketPrice == nil then
			glrCharacter.Data.Settings.CurrentlyActiveLottery = false
		end
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle == nil then
		glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
	elseif glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		if glrCharacter.Event.Raffle.GiveAwayTickets == nil then
			glrCharacter.Event.Raffle.GiveAwayTickets = 0
		end
		if glrCharacter.Event.Raffle.TicketsSold == nil or glrCharacter.Event.Raffle.MaxTickets == nil or glrCharacter.Event.Raffle.FirstTicketNumber == nil or glrCharacter.Event.Raffle.Date == nil or glrCharacter.Event.Raffle.EventName == nil or glrCharacter.Event.Raffle.TicketPrice == nil then
			glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
		end
	end
	
	if status == "Raffle" then -- Displays Raffle data
		
		if not glrCharacter.Data.Settings.CurrentlyActiveRaffle or glrCharacter.Data.Settings.CurrentlyActiveRaffle == nil then
			
			local cost = "0" .. string.lower(L["Value_Gold_Short_Colored"]) .. " 00" .. string.lower(L["Value_Silver_Short_Colored"]) .. " 00" .. string.lower(L["Value_Copper_Short_Colored"])
			
			GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetText(glrCharacter.Data.Defaults.LotteryDate)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetCursorPosition(0)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetText(glrCharacter.Data.Defaults.RaffleName)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetCursorPosition(0)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetText(glrCharacter.Data.Defaults.RaffleMaxTickets)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetText(cost)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetText(L["Raffle First Place"])
			GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetText(L["Raffle Second Place"])
			GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetText("")
			GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetText(L["Raffle Third Place"])
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetText(cost)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetCursorPosition(0)
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("0")
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("0")
			
			--Disable Certain Buttons
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Disable()
			
		else
			
			local tickets = glrCharacter.Event.Raffle.TicketsSold
			local cost = tonumber(glrCharacter.Event.Raffle.TicketPrice)
			local FreeTickets = glrCharacter.Event.Raffle.GiveAwayTickets
			local ticketsSold = glrCharacter.Event.Raffle.LastTicketBought - 1
			local value = cost * tickets
			
			local t = {
				[1] = {				-- Store Old Values to be displayed in Tooltip
					[1] = 0,		-- Ticket Value
					[2] = 0,		-- First Place
					[3] = 0,		-- Second Place
					[4] = 0,		-- Third Place
				},					
				[2] = {				
					[1] = false,	-- Ticket Value
					[2] = false,	-- First Place
					[3] = false,	-- Second Place
					[4] = false,	-- Third Place
				},					
			}
			
			if value > 9999999.9999 then
				t[1][1] = value
				t[2][1] = true
				value = 9999999.9999
			else
				t[1][1] = 0
				t[2][1] = false
			end
			
			if tickets == 0 and FreeTickets == 0 then
				ticketsSold = glrCharacter.Event.Raffle.FirstTicketNumber
			end
			
			cost = GLR_U:GetMoneyValue(cost, "Raffle", false, 1, "NA", true, true)
			value = GLR_U:GetMoneyValue(value, "Raffle", false, 1, "NA", true, true)
			
			GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetText(glrCharacter.Event.Raffle.Date)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetCursorPosition(0)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetText(glrCharacter.Event.Raffle.EventName)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetCursorPosition(0)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetText(CommaValue(glrCharacter.Event.Raffle.MaxTickets))
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetText(cost)
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetCursorPosition(0)
			if glrCharacter.Event.Raffle.FirstPlace then
				local first = glrCharacter.Event.Raffle.FirstPlace
				if first == "%raffle_total" then
					first = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
				elseif first == "%raffle_half" then
					first = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
				elseif first == "%raffle_quarter" then
					first = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
				end
				if tonumber(first) ~= nil then
					first = tonumber(first)
					if first > 9999999.9999 then
						t[1][2] = first
						t[2][2] = true
						first = 9999999.9999
					else
						t[1][2] = 0
						t[2][2] = false
					end
					first = GLR_U:GetMoneyValue(first, "Raffle", false, 1, "NA", true, true)
				end
				if t[2][2] then
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetText(L["Raffle First Place"] .. "|CFFFF0000*|r")
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_LEFT")
						GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("First Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(t[1][2], "Raffle", false, 1, "NA", true, true, true))
						GameTooltip:Show()
					end)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				else
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetScript("OnEnter", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetScript("OnLeave", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrize:SetText(L["Raffle First Place"])
				end
				GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetText(first)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetCursorPosition(0)
			end
			if glrCharacter.Event.Raffle.SecondPlace then
				local second = glrCharacter.Event.Raffle.SecondPlace
				if second == "%raffle_total" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
				elseif second == "%raffle_half" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
				elseif second == "%raffle_quarter" then
					second = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
				end
				if tonumber(second) ~= nil then
					second = tonumber(second)
					if second > 9999999.9999 then
						t[1][3] = second
						t[2][3] = true
						second = 9999999.9999
					else
						t[1][3] = 0
						t[2][3] = false
					end
					second = GLR_U:GetMoneyValue(second, "Raffle", false, 1, "NA", true, true)
				end
				if t[2][3] then
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetText(L["Raffle Second Place"] .. "|CFFFF0000*|r")
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_LEFT")
						GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Second Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(t[1][3], "Raffle", false, 1, "NA", true, true, true))
						GameTooltip:Show()
					end)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				else
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetScript("OnEnter", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetScript("OnLeave", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrize:SetText(L["Raffle Second Place"])
				end
				GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetText(second)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetCursorPosition(0)
			else
				GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetText("")
			end
			if glrCharacter.Event.Raffle.ThirdPlace then
				local third = glrCharacter.Event.Raffle.ThirdPlace
				if third == "%raffle_total" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
				elseif third == "%raffle_half" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5
				elseif third == "%raffle_quarter" then
					third = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25
				end
				if tonumber(third) ~= nil then
					third = tonumber(third)
					if third > 9999999.9999 then
						t[1][4] = third
						t[2][4] = true
						third = 9999999.9999
					else
						t[1][4] = 0
						t[2][4] = false
					end
					third = GLR_U:GetMoneyValue(third, "Raffle", false, 1, "NA", true, true)
				end
				if t[2][4] then
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetText(L["Raffle Third Place"] .. "|CFFFF0000*|r")
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_LEFT")
						GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Third Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(t[1][3], "Raffle", false, 1, "NA", true, true, true))
						GameTooltip:Show()
					end)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				else
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetScript("OnEnter", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetScript("OnLeave", nil)
					GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrize:SetText(L["Raffle Third Place"])
				end
				GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetText(third)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetCursorPosition(0)
			else
				GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetText("")
			end
			
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetText(value)
			if t[2][1] then
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales:SetText(L["Raffle Sales"] .. "|CFFFF0000*|r")
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Ticket Sales Value is greater than the Player Gold Cap.")
					GameTooltip:AddLine("Current Sales Value: " .. GLR_U:GetMoneyValue(t[1][1], "Raffle", false, 1, "NA", true, true, true))
					GameTooltip:Show()
				end)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			else
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetScript("OnEnter", nil)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetScript("OnLeave", nil)
				GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSales:SetText(L["Raffle Sales"])
			end
			GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketSalesEditBox:SetCursorPosition(0)
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText(CommaValue(glrCharacter.Event.Raffle.FirstTicketNumber))
			
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(CommaValue(ticketsSold))
			
			--Reenable Certain Buttons
			if GLR_Global_Variables[1] and not GLR_Global_Variables[6][2] then
				GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Enable()
				GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Enable()
				if not GLR_Global_Variables[6][1] then
					GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:Enable()
				end
				if not glrCharacter.Event.Raffle.SecondPlace or not glrCharacter.Event.Raffle.ThirdPlace then
					if not GLR_Global_Variables[6][1] then
						GLR_GoToAddRafflePrizes:Enable()
					end
				end
			end
			
		end
		
	elseif status == "Lottery" then -- Displays Lottery data
		
		local t = {
			[1] = {			-- Store Old Values to be Displayed
				[1] = 0,	-- Previous Lottery
				[2] = 0,	-- Previous Starting Amount
				[3] = 0,	-- Jackpot Value
				[4] = 0,	-- Starting Value
				[5] = 0,	-- Guild Value
				[6] = 0,	-- Second Value
			},
			[2] = false,	-- Jackpot Value
			[3] = false,	-- Starting Value
			[4] = false,	-- Guild Value
			[5] = false,	-- Second Value
		}
		
		if not glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveLottery == nil then
			
			local cost = "0" .. string.lower(L["Value_Gold_Short_Colored"]) .. " 00" .. string.lower(L["Value_Silver_Short_Colored"]) .. " 00" .. string.lower(L["Value_Copper_Short_Colored"])
			
			GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetText(glrCharacter.Data.Defaults.LotteryDate)
			GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetCursorPosition(0)
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetText(glrCharacter.Data.Defaults.LotteryName)
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetCursorPosition(0)
			if glrCharacter.Data.Settings.PreviousLottery.Jackpot > 0 then
				local v = glrCharacter.Data.Settings.PreviousLottery.Jackpot
				if v > 9999999.9999 then
					t[1][1] = v
					t[1][2] = v
					t[2] = true
					t[3] = true
					v = 9999999.9999
				end
				local previousStartingGold = GLR_U:GetMoneyValue(v, "Lottery", false, 1, "NA", true, true)
				
				if t[2] then
					GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"] .. "|CFFFF0000*|r")
					GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_LEFT")
						GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Jackpot Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Jackpot: " .. GLR_U:GetMoneyValue(t[1][1], "Lottery", true, 1, "NA", true, true, true))
						GameTooltip:Show()
					end)
					GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				else
					GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnEnter", nil)
					GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnLeave", nil)
					GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"])
				end
				
				if t[3] then
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"] .. "|CFFFF0000*|r")
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnEnter", function(self)
						GameTooltip:SetOwner(self, "ANCHOR_LEFT")
						GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Starting Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Starting Value: " .. GLR_U:GetMoneyValue(t[1][2], "Lottery", true, 1, "NA", true, true, true))
						GameTooltip:Show()
					end)
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnLeave", function(self)
						GameTooltip:Hide()
					end)
				else
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnEnter", nil)
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnLeave", nil)
					GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"])
				end
				
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetText(previousStartingGold)
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetText(previousStartingGold)
			else
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetText(cost)
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetText(cost)
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"])
				GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"])
			end
			GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetText("")
			GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetText("")
			GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetText("")
			GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetText(L["Second Place Text"])
			GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetText("")
			GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetText(L["Guild Amount Text"])
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("0")
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("0")
			
			--Disable Certain Buttons
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Disable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Disable()
			
		else
			
			local startingGold = tonumber(glrCharacter.Event.Lottery.StartingGold)
			local tickets = glrCharacter.Event.Lottery.TicketsSold
			local price = tonumber(glrCharacter.Event.Lottery.TicketPrice)
			local jackpotValue = startingGold + ( tickets * price )
			local FreeTickets = glrCharacter.Event.Lottery.GiveAwayTickets
			local ticketsSold = glrCharacter.Event.Lottery.LastTicketBought - 1
			local guaranteedWinner = false
			local Second = ""
			local GuildsAmount = tonumber(glrCharacter.Event.Lottery.GuildCut)
			local round = glrCharacter.Data.Settings.Lottery.RoundValue
			
			if glrCharacter.Event.Lottery.SecondPlace == L["Winner Guaranteed"] then
				guaranteedWinner = true
				Second = L["Winner Guaranteed"]
			else
				if tonumber(glrCharacter.Event.Lottery.SecondPlace) > 0 then
					Second = jackpotValue * (tonumber(glrCharacter.Event.Lottery.SecondPlace) / 100)
					if jackpotValue >= 0.0002 then
						if Second < 0.0001 then
							Second = 0.0001
						elseif Second > 9999999.9999 then
							t[5] = true
							t[1][6] = Second
							Second = 9999999.9999
						end
					else
						Second = 0
					end
				else
					Second = 0
				end
			end
			
			if GuildsAmount > 0 and jackpotValue >= 0.0002 then
				GuildsAmount = jackpotValue * (GuildsAmount / 100)
				if GuildsAmount < 0.0001 then
					GuildsAmount = 0.0001
				else
					if GuildsAmount > 9999999.9999 then
						t[4] = true
						t[1][5] = GuildsAmount
						GuildsAmount = 9999999.9999
					end
				end
			else
				GuildsAmount = 0
			end
			
			if not guaranteedWinner then
				if jackpotValue >= 0.0002 then
					if t[5] then
						--Don't want to display a value greater than 9,999,999g 99s 99c so no need to round
						Second = GLR_U:GetMoneyValue(Second, "Lottery", true, 1, "NA", true, true)
					else
						Second = GLR_U:GetMoneyValue(Second, "Lottery", true, round, "NA", true, true)
					end
				else
					Second = GLR_U:GetMoneyValue(Second, "Lottery", true, round, "NA", true, true)
				end
			end
			
			if t[4] then
				--Don't want to display a value greater than 9,999,999g 99s 99c so no need to round
				GuildsAmount = GLR_U:GetMoneyValue(GuildsAmount, "Lottery", true, 1, "NA", true, true)
			else
				GuildsAmount = GLR_U:GetMoneyValue(GuildsAmount, "Lottery", true, round, "NA", true, true)
			end
			
			price = GLR_U:GetMoneyValue(price, "Lottery", false, 1, "NA", true, true)
			
			if startingGold > 9999999.9999 then
				t[3] = true
				t[1][4] = startingGold
				startingGold = 9999999.9999
			else
				t[3] = false
				t[1][4] = 0
			end
			
			startingGold = GLR_U:GetMoneyValue(startingGold, "Lottery", false, 1, "NA", true, true)
			
			if jackpotValue > 9999999.9999 then
				t[2] = true
				t[1][3] = jackpotValue
				jackpotValue = 9999999.9999
			else
				t[2] = false
				t[1][3] = 0
			end
			
			jackpotValue = GLR_U:GetMoneyValue(jackpotValue, "Lottery", true, 1, "NA", true, true)
			
			if tickets == 0 and FreeTickets == 0 then
				ticketsSold = glrCharacter.Event.Lottery.FirstTicketNumber
			end
			
			GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetText(glrCharacter.Event.Lottery.Date)
			GLR_UI.GLR_LotteryInfo.GLR_LotteryDateEditBox:SetCursorPosition(0)
			
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetText(glrCharacter.Event.Lottery.EventName)
			GLR_UI.GLR_LotteryInfo.GLR_LotteryNameEditBox:SetCursorPosition(0)
			
			if t[3] then
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"] .. "|CFFFF0000*|r")
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Starting Value is greater than the Player Gold Cap.")
					GameTooltip:AddLine("Current Starting Value: " .. GLR_U:GetMoneyValue(t[1][4], "Lottery", true, 1, "NA", true, true, true))
					GameTooltip:Show()
				end)
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			else
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnEnter", nil)
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetScript("OnLeave", nil)
				GLR_UI.GLR_LotteryInfo.GLR_StartingGoldTitle:SetText(L["Starting Gold"])
			end
			GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetText(startingGold)
			GLR_UI.GLR_LotteryInfo.GLR_StartingGoldEditBox:SetCursorPosition(0)
			
			if t[2] then
				GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"] .. "|CFFFF0000*|r")
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Jackpot Value is greater than the Player Gold Cap.")
					GameTooltip:AddLine("Current Jackpot: " .. GLR_U:GetMoneyValue(t[1][3], "Lottery", true, 1, "NA", true, true, true))
					GameTooltip:Show()
				end)
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			else
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnEnter", nil)
				GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetScript("OnLeave", nil)
				GLR_UI.GLR_LotteryInfo.GLR_JackpotTitle:SetText(L["Jackpot"])
			end
			GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetText(jackpotValue)
			GLR_UI.GLR_LotteryInfo.GLR_JackpotEditBox:SetCursorPosition(0)
			
			GLR_UI.GLR_LotteryInfo.GLR_MaxTicketsEditBox:SetText(CommaValue(glrCharacter.Event.Lottery.MaxTickets))
			
			GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetText(price)
			GLR_UI.GLR_LotteryInfo.GLR_TicketPriceEditBox:SetCursorPosition(0)
			
			if t[5] then
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetText(L["Second Place Text"] .. "|CFFFF0000*|r")
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Second Place Value is greater than the Player Gold Cap.")
					GameTooltip:AddLine("Current Second Place Value: " .. GLR_U:GetMoneyValue(t[1][6], "Lottery", true, round, "NA", true, true, true))
					GameTooltip:Show()
				end)
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			else
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnEnter", nil)
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetScript("OnLeave", nil)
				GLR_UI.GLR_LotteryInfo.GLR_SecondPlace:SetText(L["Second Place Text"])
			end
			GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetText(Second)
			GLR_UI.GLR_LotteryInfo.GLR_SecondPlaceEditBox:SetCursorPosition(0)
			
			if t[4] then
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetText(L["Guild Amount Text"] .. "|CFFFF0000*|r")
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnEnter", function(self)
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine("Guilds Amount Value is greater than the Player Gold Cap.")
					GameTooltip:AddLine("Current Guild Amount Value: " .. GLR_U:GetMoneyValue(t[1][5], "Lottery", true, round, "NA", true, true, true))
					GameTooltip:Show()
				end)
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnLeave", function(self)
					GameTooltip:Hide()
				end)
			else
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnEnter", nil)
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetScript("OnLeave", nil)
				GLR_UI.GLR_LotteryInfo.GLR_GuildAmountText:SetText(L["Guild Amount Text"])
			end
			GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetText(GuildsAmount)
			GLR_UI.GLR_LotteryInfo.GLR_GuildAmountEditBox:SetCursorPosition(0)
			
			GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText(CommaValue(glrCharacter.Event.Lottery.FirstTicketNumber))
			if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(CommaValue(ticketsSold))
			else
				if not guaranteedWinner then
					ticketsSold = ((tickets + FreeTickets) * 10) + glrCharacter.Event.Lottery.FirstTicketNumber - 1
					if glrCharacter.Event.Lottery.TicketsSold == 0 and glrCharacter.Event.Lottery.GiveAwayTickets == 0 then
						ticketsSold = ticketsSold + 1
					end
				end
				GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(CommaValue(ticketsSold))
			end
			
			--Reenable Certain Buttons
			if GLR_Global_Variables[1] and not GLR_Global_Variables[6][1] then
				GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Enable()
				GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Enable()
				GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Enable()
				if not GLR_Global_Variables[6][2] then
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Enable()
				end
			end
			
		end
		
	end
	
	if glrCharacter.PreviousEvent.Lottery.Available then
		if glrCharacter.PreviousEvent.Lottery.Settings == nil then
			glrCharacter.PreviousEvent.Lottery.Available = false
		else
			if glrCharacter.PreviousEvent.Lottery.Settings.Date == nil then
				glrCharacter.PreviousEvent.Lottery.Available = false
			end
		end
	end
	if glrCharacter.PreviousEvent.Raffle.Available then
		if glrCharacter.PreviousEvent.Raffle.Settings == nil then
			glrCharacter.PreviousEvent.Raffle.Available = false
		else
			if glrCharacter.PreviousEvent.Raffle.Settings.Date == nil then
				glrCharacter.PreviousEvent.Raffle.Available = false
			end
		end
	end
	
	if glrCharacter.Data.Settings.Lottery.RollOverCheck then
		local RollOverTable = glrCharacter.Data.RollOver.Lottery.Names
		local CompareTable = glrCharacter.Lottery.Entries.Names
		for i = 1, #RollOverTable do
			local continue = true
			for j = 1, #CompareTable do
				if RollOverTable[i] == CompareTable[j] then
					continue = false
					break
				end
			end
			if continue then
				glrCharacter.Lottery.Entries.TicketNumbers[RollOverTable[i]] = {}
				glrCharacter.Lottery.Entries.TicketRange[RollOverTable[i]] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0, }
				glrCharacter.Lottery.Entries.Tickets[RollOverTable[i]] = { ["Given"] = 0, ["Sold"] = 0, ["NumberOfTickets"] = 0, }
				table.insert(glrCharacter.Lottery.Entries.Names, RollOverTable[i])
			end
		end
		glrCharacter.Data.Settings.Lottery.RollOverCheck = false
	end
	
	GLR_U:UpdateRosterTable()
	GLR_U:UpdateMultiGuildTable()
	GLR_U:PopulateMultiGuildTable()
	
	if GLR_UI.GLR_MainFrame:IsVisible() and GLR_Global_Variables[2] then
		GLR_Global_Variables[2] = false
		GLR:UpdatePlayersAndTotalTickets(state)
		GLR:UpdateNumberOfUnusedTickets()
	end
	
	GLR_U:CheckInvalidPlayers(false)
	
	if not InitialUpdate then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateInfo() - Initial Update of Display Info Completed")
		InitialUpdate = true
	end
	
end

function GLR_U:CheckInvalidPlayers(state)
	
	if not state and not Variables[1] then
		Variables[1] = true
		C_Timer.After(5, CheckForNonexistingPlayersBuffer)
	elseif state and GLR_Global_Variables[1] and not Variables[2] then
		Variables[2] = true
		CheckForNonexistingPlayersBuffer()
		chat:AddMessage("Scanning for Invalid Entries...")
		C_Timer.After(10, function(self) Variables[2] = false end)
	end
	
end

function GLR_U:CheckGuildName()
	
	local GuildStatus = true
	
	if IsInGuild() then
		local test = GetGuildInfo("PLAYER")
		if test == nil then
			GuildStatus = false
		end
	end
	
	if GuildStatus then
		if GLR_GameVersion == "RETAIL" then
			C_GuildInfo.GuildRoster()
		else
			GuildRoster()
		end
	end
	
	return GuildStatus
	
end

---------------------------------------------
------------ UPDATE MINIMAP ICON ------------
---------------------------------------------
------------ TOGGLES MINIMAP ICON -----------
---------------------------------------------
local MinimapDebug = false
local MinimapDebugLogin = true
function GLR_U:UpdateMinimapIcon()
	
	local status = glrCharacter.Data.Settings.General.mini_map
	local X = 0
	local Y = 0
	
	if glrCharacter.Data.Settings.General.MinimapXOffset ~= nil then
		X = glrCharacter.Data.Settings.General.MinimapXOffset
	end
	if glrCharacter.Data.Settings.General.MinimapYOffset ~= nil then
		Y = glrCharacter.Data.Settings.General.MinimapYOffset
	end
	
	if not MinimapDebug and GLR_AddOnMessageTable_Debug ~= nil then
		MinimapDebug = true
		local timestamp = GetTimeStamp()
		if MinimapDebugLogin then
			MinimapDebugLogin = false
			table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - UpdateMinimapIcon() - Initialized Minimap Coords To: (" .. X .. ", " .. Y .. ")")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateMinimapIcon() - Changed Minimap Coords To: (" .. X .. ", " .. Y .. ")")
		end
		C_Timer.After(5, function(self) MinimapDebug = false end)
	end
	
	if status then
		GLR_UI.GLR_MinimapButton:Show()
	else
		GLR_UI.GLR_MinimapButton:Hide()
	end
	
	GLR_UI.GLR_MinimapButton:SetPoint("CENTER", Minimap, "CENTER", X, Y)
	
end

--Sets whether or not frames used by GLR can be closed with the Escape key.
--Frames that don't have a close button will always be able to close with the Escape key, this is done in the GLR_UI.lua file in the Scripts section.
function GLR_U:ToggleEscapeKey()
	
	local status = glrCharacter.Data.Settings.General.ToggleEscape
	
	if status then
		
		GLR_UI.GLR_MainFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_MainFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_MainFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_MainFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_NewLotteryEventFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_NewLotteryEventFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_NewLotteryEventFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_AddPlayerToLotteryFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_AddPlayerToLotteryFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
			end
			
		end)
		
		GLR_UI.GLR_EditPlayerInLotteryFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_EditPlayerInLotteryFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_EditPlayerInLotteryFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_NewRaffleEventFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_NewRaffleEventFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_NewRaffleEventFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_AddPlayerToRaffleFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_AddPlayerToRaffleFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_EditPlayerInRaffleFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_EditPlayerInRaffleFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_EditPlayerInRaffleFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
			end
		end)
		
		GLR_UI.GLR_DonationFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_DonationFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_DonationFrame:SetPropagateKeyboardInput(false)
				GLR_UI.GLR_DonationFrame:Hide()
			end
		end)
		
	elseif not status then
		
		GLR_UI.GLR_MainFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_MainFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_MainFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_NewLotteryEventFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_NewLotteryEventFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_AddPlayerToLotteryFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_AddPlayerToLotteryFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_AddPlayerToLotteryFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_EditPlayerInLotteryFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_EditPlayerInLotteryFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_EditPlayerInLotteryFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_NewRaffleEventFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_NewRaffleEventFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_AddPlayerToRaffleFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_AddPlayerToRaffleFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_AddPlayerToRaffleFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_EditPlayerInRaffleFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_EditPlayerInRaffleFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_EditPlayerInRaffleFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
		GLR_UI.GLR_DonationFrame:SetScript("OnKeyDown", function(_, key)
			GLR_UI.GLR_DonationFrame:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				GLR_UI.GLR_DonationFrame:SetPropagateKeyboardInput(true)
			end
		end)
		
	end
	
	GLR_D:ToggleEscapeKey()
	
end

function GLR_U:UpdateRosterTable()
	
	if glrRosterTotal > 0 then
		glrRoster = {} -- Resets the Roster Table so as to prevent multiple names being inserted.
		glrRosterTotal = 0
	end
	
	if GLR_GameVersion == "RETAIL" then
		C_GuildInfo.GuildRoster()
	else
		GuildRoster()
	end
	
	local numTotalMembers, _, _ = GetNumGuildMembers()
	
	for i = 1, numTotalMembers do
		
		--local name, rank, rankIndex, level, class, _, _, _, online, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
		local name, rank, rankIndex, level, _, _, _, _, online, _, class, _, _, _, _, _, _ = GetGuildRosterInfo(i)
		local years, months, days, hours = GetGuildRosterLastOnline(i)
		local LastTime = ""
		
		if rank == nil then rank = "NA" end
		if online == nil then online = false end
		
		if years ~= nil then
			LastTime = tostring(years) .. "Y" .. tostring(months) .. "M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
		elseif months ~= nil then
			LastTime = "0Y" .. tostring(months) .. "M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
		elseif days ~= nil then
			LastTime = "0Y0M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
		elseif hours ~= nil then
			LastTime = "0Y0M0D" .. tostring(hours) .. "H"
		else
			LastTime = "Online"
		end
		
		if online then
			online = tostring(GetServerTime())
		else
			online = tostring(online)
		end
		
		if glrRoster[1] ~= nil then
			for j = 1, #glrRoster do
				local search = string.sub(glrRoster[j], 1, string.find(glrRoster[j], '%[') - 1)
				if search == name then
					if string.find(glrRoster[j], '%@') then
						local LastOnline = string.sub(glrRoster[j], string.find(glrRoster[j], '%@') + 1)
						if LastOnline ~= "false" then
							if online == "false" then
								online = LastOnline
							end
						end
					end
				end
			end
		end
		
		local text = name .. "[" .. class .. "](" .. level .. "){" .. rankIndex .. "|" .. rank .. "}@" .. online .. "$" .. LastTime .. "!"
		
		table.insert(glrRoster, text)
		
		glrRosterTotal = glrRosterTotal + 1
		
	end
	
	sort(glrRoster)
	
	if not DebugVariables[2] then
		DebugVariables[2] = true
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateRosterTable() - Updated glrRoster Table")
	end
	
end

local IsDone = false
function GLR_U:UpdateMultiGuildTable()
	
	if GLR_GameVersion == "RETAIL" then
		C_GuildInfo.GuildRoster()
	else
		GuildRoster()
	end
	
	if not IsDone then
		IsDone = true
		local t = {}
		local guildName, _, _, _ = GetGuildInfo("PLAYER")
		local faction, _ = UnitFactionGroup("PLAYER")
		local guild = glrCharacter.Data.Settings.General.GuildName
		local numTotalMembers, _, _ = GetNumGuildMembers()
		local counted = false
		
		if not DebugVariables[1] then --Only need to see when the mod initially updates the table.
			DebugVariables[1] = true
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateMultiGuildTable() - Updated glrHistory.GuildRoster Table")
		end
		
		if guildName ~= nil then
			if glrCharacter.Data.Settings.General.GuildName == nil then
				glrCharacter.Data.Settings.General.GuildName = guildName
				guild = guildName
			elseif glrCharacter.Data.Settings.General.GuildName ~= guildName then
				glrCharacter.Data.Settings.General.GuildName = guildName
				guild = guildName
			end
		else return end
		
		for i = 1, numTotalMembers do
			
			--local name, rank, rankIndex, level, class, _, _, _, online, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
			local name, rank, rankIndex, level, _, _, _, _, online, _, class, _, _, _, _, _, _ = GetGuildRosterInfo(i)
			local years, months, days, hours = GetGuildRosterLastOnline(i)
			local LastTime = ""
			
			if years ~= nil then
				LastTime = tostring(years) .. "Y" .. tostring(months) .. "M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
			elseif months ~= nil then
				LastTime = "0Y" .. tostring(months) .. "M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
			elseif days ~= nil then
				LastTime = "0Y0M" .. tostring(days) .. "D" .. tostring(hours) .. "H"
			elseif hours ~= nil then
				LastTime = "0Y0M0D" .. tostring(hours) .. "H"
			else
				LastTime = "Online"
			end
			
			-- local ClassName, ClassFile, ClassID = UnitClass(name)
			
			-- if ClassFile ~= nil then
				-- class = ClassFile
			-- else
				-- Set so any that return nil will instead have their name colored red so as not to error out.
				-- class = "NA"
			-- end
			
			online = tostring(online)
			
			local text = name .. "[" .. class .. "](" .. level .. "){" .. rankIndex .. "|" .. rank .. "}@" .. online .. "$" .. LastTime .. "!"
			
			table.insert(t, text)
			if not counted then
				counted = true
			end
			
		end
		
		sort(t)
		
		if counted then --Prevents clearing an already populated table when first logging in.
			
			if guild ~= nil then
				if glrHistory.GuildRoster[faction][guild] == nil then
					glrHistory.GuildRoster[faction][guild] = {}
					glrHistory.GuildRoster[faction][guild] = t
				else
					--Clears the table for new names (or those that have left your guild)
					glrHistory.GuildRoster[faction][guild] = t
				end
				local data = date()
				if glrHistory.LastUpdated[faction][guild] == nil then
					glrHistory.LastUpdated[faction][guild] = data
				else
					glrHistory.LastUpdated[faction][guild] = data
				end
			end
			
		end
		C_Timer.After(15, function(self) IsDone = false end)
	end
	
end

function GLR_U:PopulateMultiGuildTable() --Used to populate the table the mod will now use (if Multi-Guild is enabled) for allowing player entry into a Lottery/Raffle.
	
	local processedGuilds = { ["Alliance"] = {}, ["Horde"] = {} }
	local CrossFaction = glrCharacter.Data.Settings.General.CrossFactionEvents
	local faction = glrHistory.PlayerFaction[FullPlayerName]
	
	if faction == nil then return end
	
	if glrMultiRosterTotal > 0 then
		glrMultiGuildRoster = {} --Clears the multiguild table in case people have joined/left the currently logged in players Guild.
		glrMultiRosterTotal = 0
		glrRosterTotal = 0
	end
	
	for i = 1, #glrHistory.Names do
		
		local continue = false
		local name = glrHistory.Names[i]
		local status = glrHistory.MultiGuildStatus[name]
		local guild = glrHistory.CharacterGuilds[name]
		local UserFaction = glrHistory.PlayerFaction[name]
		local guildstatus = false
		
		if glrHistory.GuildStatus[UserFaction] ~= nil then
			if glrHistory.GuildStatus[UserFaction][guild] ~= nil then
				guildstatus = glrHistory.GuildStatus[UserFaction][guild]
				continue = true
			end
		end
		
		glrRosterTotal = glrRosterTotal + 1
		glrMultiRosterTotal = glrMultiRosterTotal + 1
		
		if continue then
			if glrHistory.GuildRoster[UserFaction][guild] ~= nil then
				if status and guildstatus and processedGuilds[UserFaction][guild] == nil then
					for key, val in pairs(glrHistory.GuildRoster) do
						if glrHistory.GuildRoster[key] ~= nil then
							if glrHistory.GuildRoster[key][guild] ~= nil then
								if CrossFaction then
									if glrHistory.GuildRoster[key][guild] ~= nil then
										processedGuilds[UserFaction][guild] = true
										for j = 1, #glrHistory.GuildRoster[key][guild] do
											table.insert(glrMultiGuildRoster, glrHistory.GuildRoster[key][guild][j])
										end
									end
								else
									if key == faction then
										processedGuilds[UserFaction][guild] = true
										for j = 1, #glrHistory.GuildRoster[key][guild] do
											table.insert(glrMultiGuildRoster, glrHistory.GuildRoster[key][guild][j])
										end
									end
								end
							end
						end
					end
				end
			end
		end
		
	end
	
	-- local found = false
	-- local n = 1
	-- for i = 1, #glrMultiGuildRoster do
		-- local name = string.sub(glrMultiGuildRoster[i], 1, string.find(glrMultiGuildRoster[i], "%[") - 1)
		-- if name == "Tannadra-Area52" then
			-- found = true
			-- n = i
			-- break
		-- end
	-- end
	
	-- if found then
		-- print("Found: '"..glrMultiGuildRoster[n].."'")
	-- else
		-- print("Didn't find name")
	-- end
	
	--print("Roster Table Updated")
	
	sort(glrMultiGuildRoster)
	
	if not DebugVariables[3] then
		DebugVariables[3] = true
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateMultiGuildTable() - Initialized PopulateMultiGuildTable Table")
	end
	
end

function GLR_U:GetLinkedNames()
	
	if glrLinkedNamesCount > 0 then
		glrLinkedNames = {}
		glrLinkedNamesCount = 0
	end
	
	for i = 1, #glrHistory.Names do
		
		local name = glrHistory.Names[i]
		
		if glrHistory.MultiGuildStatus[name] then
			glrLinkedNames[name] = name
			glrLinkedNamesCount = glrLinkedNamesCount + 1
			if glrTempNames[name] == nil then
				glrTempNames[name] = name
			end
		end
		
	end
	
	sort(glrLinkedNames)
	sort(glrTempNames)
	
end

function GLR_U:GetLinkedGuilds()
	
	if glrLinkedGuildsCount > 0 then
		glrLinkedGuilds = {}
		glrLinkedGuildsCount = 0
	end
	
	for i = 1, #glrHistory.Names do
		
		local name = glrHistory.Names[i]
		local guild = glrHistory.CharacterGuilds[name]
		local faction = glrHistory.PlayerFaction[name]
		
		if guild ~= nil then
			--if guild ~= false then
				if glrHistory.MultiGuildStatus[name] then
					if glrLinkedGuilds[guild] == nil then
						glrLinkedGuilds[guild] = guild
						glrLinkedGuildsCount = glrLinkedGuildsCount + 1
					end
					if glrTempGuilds[guild] == nil then
						if faction == "Alliance" then
							glrTempGuilds[guild] = guild .. " - |cff0000ff" .. faction .. "|r"
						elseif faction == "Horde" then
							glrTempGuilds[guild] = guild .. " - |cffff0000" .. faction .. "|r"
						end
					end
				end
			--end
		end
		
	end
	
	sort(glrLinkedGuilds)
	sort(glrTempGuilds)
	
end