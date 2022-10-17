GLR_C = {}

local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")

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

function GLR_C:CalendarToggle()
	
	local SavedStatus = glrCharacter.Data.Settings.General.CreateCalendarEvents
	local canEdit = false
	
	local v, b, d, t = GetBuildInfo()
	
	if tonumber(t) >= 80200 then
		canEdit = CanEditGuildEvent()
	end
	
	local timestamp = GetTimeStamp()
	
	if canEdit == nil then --In the unlikely event CanEditGuildEvent() returns nil.
		glrCharacter.Data.Settings.General.CreateCalendarEvents = false
		GLR:Print("Calendar Creation Variable returned NIL. Please report this to the AddOn Author.")
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CalendarToggle() - Unable to Create Calendar Events. Reason: [NIL]")
		return
	end
	
	if canEdit then
		if SavedStatus then
			glrCharacter.Data.Settings.General.CreateCalendarEvents = false
		else
			glrCharacter.Data.Settings.General.CreateCalendarEvents = true
		end
		if GLR_AddOnMessageTable_Debug ~= nil then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CalendarToggle() - Create Calendar Events State: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.CreateCalendarEvents)) .. "]")
		end
	else
		glrCharacter.Data.Settings.General.CreateCalendarEvents = false
		if tonumber(t) >= 80200 then
			GLR:Print(L["GLR - Error - Cant Create Calendar Events"])
			if GLR_AddOnMessageTable_Debug ~= nil then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CalendarToggle() - Unable to Create Calendar Events. Reason: [RANK]")
			end
		else
			GLR:Print("Calendar event creation is disabled in Classic")
			if GLR_AddOnMessageTable_Debug ~= nil then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CalendarToggle() - Unable to Create Calendar Events. Reason: [GAME]")
			end
		end
	end
	
end

function GLR_C:CreateAnnouncement(state)
	
	local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
	local canEdit = false
	local continue = false
	local year, month, day, hour, minute
	local AnnouncementTitle = ""
	local MaxTickets = ""
	local TicketPrice = ""
	local timestamp = GetTimeStamp()
	local v, b, d, t = GetBuildInfo()
	
	if tonumber(t) >= 80200 then
		C_Calendar.CloseEvent() --Closes Calendar Events if opened while mod is creating event.
		canEdit = CanEditGuildEvent()
		continue = true
	end
	
	if continue then
		if canEdit then
			
			if state == "Lottery" then
				AnnouncementTitle = L["GLR - Core - Calendar Lottery Title"]
			elseif state == "Raffle" then
				AnnouncementTitle = L["GLR - Core - Calendar Raffle Title"]
			end
			month = tostring(tonumber(string.sub(glrCharacter.Event[state].Date, 1, 2))) --Done like this to translate "07" into "7" as WoW doesn't like "07" for July
			day = tostring(tonumber(string.sub(glrCharacter.Event[state].Date, 4, 5)))
			year = "20" .. string.sub(glrCharacter.Event[state].Date, 7, 8)
			hour = string.sub(glrCharacter.Event[state].Date, 12, 13)
			minute = string.sub(glrCharacter.Event[state].Date, 15, 16)
			MaxTickets = glrCharacter.Event[state].MaxTickets
			TicketPrice = GLR_U:GetMoneyValue(glrCharacter.Event[state].TicketPrice, state, false)
			
			local AnnouncementDescription = string.gsub(string.gsub(string.gsub(L["GLR - Core - Calendar Guild Announcement"], "%%TicketPrice", TicketPrice), "%%MaxTickets", MaxTickets), "%%Player", FullPlayerName)
			
			C_Calendar.CreateGuildAnnouncementEvent()
			C_Calendar.EventSetDate(month,day,year)
			C_Calendar.EventSetTitle(AnnouncementTitle)
			C_Calendar.EventSetDescription(AnnouncementDescription)
			C_Calendar.EventSetTime(hour,minute)
			C_Calendar.EventSetType(5)
			C_Calendar.AddEvent()
			C_Calendar.CloseEvent()
			
			if GLR_AddOnMessageTable_Debug ~= nil then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CreateAnnouncement() - Created Calendar Event For: [" .. string.upper(state) .. "]")
			end
			
		else
			
			glrCharacter.Data.Settings.General.CreateCalendarEvents = false
			GLR:Print(L["GLR - Error - Cant Create Calendar Events"])
			
			if GLR_AddOnMessageTable_Debug ~= nil then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CreateAnnouncement() - Unable to Create Calendar Event. Reason: [RANK]")
			end
			
		end
	end
	
end