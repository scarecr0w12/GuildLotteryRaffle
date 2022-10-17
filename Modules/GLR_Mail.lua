GLR_M = {}

local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")
local DoHook = LibStub("AceHook-3.0")
local MAX_MAIL_SHOWN = 50
local mailIndex
local numUnshownItems
local lastNumGold
local wait
local button
local Postal_OpenAllMenuButton
local firstMailDaysLeft
local StartReply = false
local EventRegistered = false
local Mailed = false
local MailCount = 0
local reply = { ["Lottery"] = {}, ["Raffle"] = {}, }
local DidReply = false
local DebugReply = false
local chat = DEFAULT_CHAT_FRAME

function GLR_M:Dump()
	-- for t, v in pairs(reply) do
		
	-- end
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

local function GetMoneyValue(Total, color)
	
	Total = tonumber(Total)
	local Gold = tostring(math.floor(Total))
	local Silver = tostring(math.floor(math.fmod(Total * 100, 100)))
	local Copper = tostring(math.floor(math.fmod(Total * 10000, 100)))
	
	if tonumber(Copper) == 0 then
		if tonumber(Silver) == 0 then
			if tonumber(Gold) > 0 then
				Gold = CommaValue(Gold)
				if color then
					Total = Gold .. L["Value_Gold_Short_Colored"]
				else
					Total = Gold .. L["Value_Gold_Short"]
				end
			else
				if color then
					Total = Gold .. L["Value_Gold_Short_Colored"] .. " " .. Silver .. L["Value_Silver_Short_Colored"] .. " " .. Copper .. L["Value_Copper_Short_Colored"]
				else
					Total = Gold .. L["Value_Gold_Short"] .. " " .. Silver .. L["Value_Silver_Short"] .. " " .. Copper .. L["Value_Copper_Short"]
				end
			end
		else
			if tonumber(Gold) == 0 then
				if color then
					Total = Silver .. L["Value_Silver_Short_Colored"]
				else
					Total = Silver .. L["Value_Silver_Short"]
				end
			else
				Gold = CommaValue(Gold)
				if color then
					Total = Gold .. L["Value_Gold_Short_Colored"] .. " " .. Silver .. L["Value_Silver_Short_Colored"]
				else
					Total = Gold .. L["Value_Gold_Short"] .. " " .. Silver .. L["Value_Silver_Short"]
				end
			end
		end
	else
		if tonumber(Silver) == 0 then
			if tonumber(Gold) == 0 then
				if color then
					Total = Copper .. L["Value_Copper_Short_Colored"]
				else
					Total = Copper .. L["Value_Copper_Short"]
				end
			else
				Gold = CommaValue(Gold)
				if color then
					Total = Gold .. L["Value_Gold_Short_Colored"] .. " " .. Copper .. L["Value_Copper_Short_Colored"]
				else
					Total = Gold .. L["Value_Gold_Short"] .. " " .. Copper .. L["Value_Copper_Short"]
				end
			end
		else
			if tonumber(Gold) == 0 then
				if color then
					Total = Silver .. L["Value_Silver_Short_Colored"] .. " " .. Copper .. L["Value_Copper_Short_Colored"]
				else
					Total = Silver .. L["Value_Silver_Short"] .. " " .. Copper .. L["Value_Copper_Short"]
				end
			else
				Gold = CommaValue(Gold)
				if color then
					Total = Gold .. L["Value_Gold_Short_Colored"] .. " " .. Silver .. L["Value_Silver_Short_Colored"] .. " " .. Copper .. L["Value_Copper_Short_Colored"]
				else
					Total = Gold .. L["Value_Gold_Short"] .. " " .. Silver .. L["Value_Silver_Short"] .. " " .. Copper .. L["Value_Copper_Short"]
				end
			end
		end
	end
	return Total
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

-- Frame to refresh the Inbox
-- I'm cheap so instead of trying to track 60 or so seconds since the
-- last CheckInbox(), I just call CheckInbox() every 10 seconds
local GLR_RefreshFrame = CreateFrame("Frame", nil, MailFrame)
GLR_RefreshFrame:Hide()
GLR_RefreshFrame:SetScript("OnShow", function(self)
	self.time = 10
	self.mode = nil
end)
GLR_RefreshFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if self.time <= 0 then
		if self.mode == nil then
			self.time = 10
			GLR:Print(L["Mail Scan - Refreshing"])
			GLR:RegisterEvent("MAIL_INBOX_UPDATE")
			CheckInbox()
			GLR_RefreshFrame:OnEvent()
		else
			self:Hide()
			GLR_M:OpenAll(true)
		end
	end
end)

local function noop() end
local function DisableInbox(disable)
	if disable then
		if not GLR:IsHooked("InboxFrame_OnClick") then
			GLR:RawHook("InboxFrame_OnClick", noop, true)
			for i = 1, 7 do
				_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(1)
			end
		end
		GLR_UI.GLR_ScanMailButton:Disable()
	else
		if glrCharacter.Data.Settings.General.ReplyToSender then
			if MailCount == 0 then
				if GLR:IsHooked("InboxFrame_OnClick") then
					GLR:Unhook("InboxFrame_OnClick")
					for i = 1, 7 do
						_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(nil)
					end
				end
				if DidReply then
					local timestamp = GetTimeStamp()
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - DisableInbox() - Replied To Senders")
					DidReply = false
				end
				DebugReply = false
				GLR_UI.GLR_ScanMailButton:Enable()
				GLR_UI.GLR_ScanMailButtonText:SetText(L["Scan Mail Button"])
				C_Timer.After(0.5, function(self) GLR:Print(L["Mail Scan - Complete"]) end)
			end
		else
			if GLR:IsHooked("InboxFrame_OnClick") then
				GLR:Unhook("InboxFrame_OnClick")
				for i = 1, 7 do
					_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(nil)
				end
			end
			GLR_UI.GLR_ScanMailButton:Enable()
		end
	end
end

local MailSentFrame = CreateFrame("Frame", nil, MailFrame)
MailSentFrame:Hide()

local function MailSuccess()
	if Mailed and MailCount >= 1 then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSuccess() - Remaining: [" .. MailCount .. "]")
		Mailed = false
	elseif MailCount == 0 then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSuccess() - Finished.")
		--Only need to know when Confirmation Mails have been sent so lets no longer listen for this event when we're done Scanning the mailbox. It'll be reactivated if we get more mail to scan.
		MailSentFrame:UnregisterEvent("MAIL_SEND_SUCCESS")
		MailSentFrame:SetScript("OnEvent", nil)
		EventRegistered = false
	end
end

local working = false
local function SendReply()
	working = true
	local doBreak = false
	for state, _ in pairs(reply) do
		for entry, _ in pairs(reply[state]) do
			if not reply[state][entry].Sent then
				local t = {}
				-- local recipient = reply[state][entry].Name
				-- local tickets = reply[state][entry].Bought
				-- local amount = reply[state][entry].Value
				-- local total = reply[state][entry].Current
				local MailMoney = GetMoneyValue(reply[state][entry].Value, false)
				local difference = tonumber(glrCharacter.Event[state].MaxTickets) - reply[state][entry].Current
				local MailMessage = L["GLR - Mail Scan - Mail Body"]
				local ReplyEvent = L[state]
				local subject, _ = string.gsub(L["GLR - Mail Scan - Mail Subject"], "%%e", ReplyEvent)
				local TotalGold
				if state == "Raffle" then
					TotalGold = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
					TotalGold = GetMoneyValue(TotalGold, false)
					t[1] = string.sub(MailMessage, 1, string.find(MailMessage, "%{") - 1)
					t[2] = string.sub(MailMessage, string.find(MailMessage, "%}") + 1)
					MailMessage, _ = string.gsub(string.gsub(table.concat({t[1], t[2]}, ""), "%[", ""), "%]", "")
				elseif state == "Lottery" then
					TotalGold = glrCharacter.Event.Lottery.TicketsSold * tonumber(glrCharacter.Event.Lottery.TicketPrice) + tonumber(glrCharacter.Event.Lottery.StartingGold)
					TotalGold = GetMoneyValue(TotalGold, false)
					t[1] = string.sub(MailMessage, 1, string.find(MailMessage, "%[") - 1)
					t[2] = string.sub(MailMessage, string.find(MailMessage, "%]") + 1)
					MailMessage, _ = string.gsub(string.gsub(table.concat({t[1], t[2]}, ""), "%{", ""), "%}", "")
				end
				MailMessage, _ = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(MailMessage, "%%s", reply[state][entry].Name), "%%e", ReplyEvent), "%%t", reply[state][entry].Bought), "%%m", MailMoney), "%%f", reply[state][entry].Current), "%%x", difference), "%%j", TotalGold)
				if glrCharacter.Data.Settings.General.ToggleChatInfo then
					local message, _ = string.gsub(string.gsub(L["GLR - Mail Scan - Confirmation Chat Message"], "%%e", ReplyEvent), "%%r", reply[state][entry].Name)
					GLR:Print(message)
				end
				SendMail(reply[state][entry].Name, subject, MailMessage)
				reply[state][entry].Sent = true
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SendReply() - Sent Mail To: [" .. reply[state][entry].Name .. "] - MailCount: [" .. MailCount .. "]")
				if not GLR_ReleaseState then --Only does this for non-release state updates (ie: alpha/beta updates)
					GLR:Print("Sent Reply to: " .. reply[state][entry].Name .. " MailCount: " .. MailCount)
				end
				MailCount = MailCount - 1
				doBreak = true
				break
			end
		end
		if doBreak then break end
	end
	if MailCount >= 1 then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SendReply() - Continuing Reply Mail Function")
		C_Timer.After(1, function(self) working = false end)
		--return SendReply()
	end
end
MailSentFrame:SetScript("OnShow", function(self)
	self.time = 2.5
	if glrCharacter.Data.Settings.General.ReplyToSender then
		if MailCount >= 1 and self.time < 1.0 then
			self.time = 2.5
		end
	else
		self:Hide()
	end
end)
MailSentFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if MailCount >= 1 then
		if self.time <= 0 then
			if StartReply then
				self.time = 2.5
				if not working then
					local timestamp = GetTimeStamp()
					if not DebugReply then
						DebugReply = true
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - Starting Reply Mail Function")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - Continuing Reply Mail Function")
					end
					SendReply()
				end
			end
		end
	else
		if StartReply then
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - MailCount is ZERO")
			C_Timer.After(1, function(self)
				DisableInbox(false)
			end)
			self:Hide()
		end
	end
end)
MailSentFrame:SetScript("OnEvent", function(self, event)
	if StartReply then
		local timestamp = GetTimeStamp()
		if event == "MAIL_SEND_SUCCESS" then
			Mailed = true
			self:Show()
		elseif event == "MAIL_FAILED" then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnEvent() - FAILED TO SEND MAIL")
			self:Show()
		end
		if Mailed and MailCount >= 1 then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSuccess() - Remaining: [" .. MailCount .. "]")
			Mailed = false
		elseif MailCount == 0 then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSuccess() - Finished.")
			--Only need to know when Confirmation Mails have been sent so lets no longer listen for this event when we're done Scanning the mailbox. It'll be reactivated if we get more mail to scan.
			MailSentFrame:UnregisterEvent("MAIL_SEND_SUCCESS")
			MailSentFrame:UnregisterEvent("MAIL_FAILED")
			--MailSentFrame:SetScript("OnEvent", nil)
			EventRegistered = false
			StartReply = false
		end
	end
end)
--[[
MailSentFrame:SetScript("OnUpdate", function(self, elapsed) --Causes the AddOn to send a confirmation mail once per 2 seconds
	self.time = self.time - elapsed
	if MailSentFrame:IsVisible() and MailCount >= 1 then
		if self.time <= 0 then
			if self.mode == nil then
				if not Mailed then
					Mailed = true
					self.time = 2
					local timestamp = GetTimeStamp()
					if not DebugReply then
						DebugReply = true
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - Starting Reply Mail Function")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - Continuing Reply Mail Function")
					end
					if not working then
						SendReply()
					end
				end
			else
				self:Hide()
			end
		end
	elseif MailSentFrame:IsVisible() and MailCount == 0 then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSentFrame:OnUpdate() - MailCount is ZERO")
		C_Timer.After(1, function(self)
			DisableInbox(false)
		end)
		self:Hide()
	end
end)
--]]

--[[
GLR_M.GLR_UpdateFrame = CreateFrame("Frame") -- Made a global frame so the rest of the mod can access it.
GLR_M.GLR_UpdateFrame:Hide()
GLR_M.GLR_UpdateFrame:SetScript("OnShow", function(self)
	self.time = 2
	if self.time < 1.0 and not self.lootingMoney then
		-- Delay opening to 2 seconds to account for a nearly full
		-- inventory to respect the KeepFreeSpace setting
		self.time = 2
	end
	self.lootingMoney = nil
end)
GLR_M.GLR_UpdateFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if self.time <= 0 then
		self:Hide()
		GLR_M:ProcessNext()
	end
end)
]]

local function Continue()
	
	GLR_RefreshFrame:Hide()
	GLR_M.GLR_UpdateFrame:Hide()
	GLR:UnregisterEvent("UI_ERROR_MESSAGE")
	local timestamp = GetTimeStamp()
	
	if not glrCharacter.Data.Settings.General.ReplyToSender then
		GLR:Print(L["Mail Scan - Complete"])
		GLR_UI.GLR_ScanMailButtonText:SetText(L["Scan Mail Button"])
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Continue() - Process Complete. Resetting Mail Scan Button.")
		DisableInbox(false)
	else
		if MailCount >= 1 then
			GLR_UI.GLR_ScanMailButtonText:SetText("Replying...")
		end
		if not EventRegistered and MailCount >= 1 then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Continue() - Event Registered")
			MailSentFrame:RegisterEvent("MAIL_SEND_SUCCESS")
			MailSentFrame:RegisterEvent("MAIL_FAILED")
			--MailSentFrame:SetScript("OnEvent", MailSuccess)
			EventRegistered = true
		elseif not EventRegistered and MailCount == 0 then
			DisableInbox(false)
		end
		StartReply = true
		MailSentFrame:Show()
	end
	InboxFrame_Update()
	-- if event == "MAIL_CLOSED" or event == "PLAYER_LEAVING_WORLD" then
		-- GLR:UnregisterEvent("MAIL_CLOSED")
		-- GLR:UnregisterEvent("PLAYER_LEAVING_WORLD")
	-- end
end

local SubjectPatterns = {
	AHCancelled = gsub(AUCTION_REMOVED_MAIL_SUBJECT, "%%s", ".*"),
	AHExpired = gsub(AUCTION_EXPIRED_MAIL_SUBJECT, "%%s", ".*"),
	AHOutbid = gsub(AUCTION_OUTBID_MAIL_SUBJECT, "%%s", ".*"),
	AHSuccess = gsub(AUCTION_SOLD_MAIL_SUBJECT, "%%s", ".*"),
	AHWon = gsub(AUCTION_WON_MAIL_SUBJECT, "%%s", ".*"),
}

local function GetMailType(subject)
	if subject then
		for k, v in pairs(SubjectPatterns) do
			if subject:find(v) then return k end
		end
	end
	return "NonAHMail"
end

local function CountMoney()
	local numGold = 0
	for i = 1, GetInboxNumItems() do
		local _, _, sender, subject, money, CODAmount, _, hasItem, _, _, msgText, _, isGM = GetInboxHeaderInfo(i)
		numGold = numGold + money
	end
	return numGold
end

local function GetMoneyString(money)
	
	local total = money / 10000
	local gold = math.floor(total)
	local silver = math.floor(math.fmod(total * 100, 100))
	local copper = math.floor(math.fmod(total * 10000, 100))
	
	if copper < 10 then
		copper = "0" .. tostring(copper)
	else
		copper = tostring(copper)
	end
	if silver < 10 then
		silver = "0" .. tostring(silver)
	else
		silver = tostring(silver)
	end
	
	gold = tonumber(gold .. "." .. silver .. copper)
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetMoneyString() - Money: [" .. money .. "] - Became: [" .. gold .. "]")
	
	if gold > 0 then
		return gold
	else
		gold = 0
		return gold
	end
	
end

local function AddPlayerTickets(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
	
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	local FirstTicketNumberBought = true
	local LastTicketNumberBought = true
	local timestamp = GetTimeStamp()
	
	glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
	
	if glrCharacter[state].TicketPool[1] ~= nil then
		
		for i = 1, PlayerTickets do
			
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
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(TicketNumber)
	
	if state == "Lottery" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	else
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	end
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	GLR_U:UpdateInfo()
	
	if glrCharacter[state].MessageStatus == nil then
		glrCharacter[state].MessageStatus = {}
	end
	if glrCharacter[state].MessageStatus[PlayerName] == nil then
		local dateTime = time()
		if not FreeTickets then
			glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
		else
			glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
		end
	end
	
	local vN = PlayerName
	local targetRealm
	local bypass = false
	local removed = false
	
	if string.find(string.lower(PlayerName), "-") ~= nil then
		targetRealm = string.sub(PlayerName, string.find(PlayerName, "-") + 1)
	else
		bypass = true
	end
	
	if PlayerRealmName == targetRealm and not bypass then
		vN = string.sub(PlayerName, 1, string.find(PlayerName, "-") - 1)
		removed = true
	end
	
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:AddPlayerTickets() - Successfully Added Entry For: [" .. PlayerName .. "]")
	
	if continue then
		
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:SendPlayerTheirTicketInfo() - Sent Player Ticket Info To: [" .. PlayerName .. "]")
		
	--elseif not continue then
		--local printed = false
		--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
		--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
		-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
			-- for i = 1, #glrHistory.GuildRoster[faction][key] do
				-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
				-- if removed then
					-- CompareText = string.sub(CompareText, 1, string.find(CompareText, '-') - 1)
				-- end
				-- if CompareText == vN then
					-- continue = true
					-- break
				-- end
			-- end
			-- if continue then
				-- break
			-- end
		-- end
		-- if continue then
			-- if not glrCharacter[state].MessageStatus[PlayerName]["sentMessage"] then
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:AddPlayerTickets() - WhoLib Search Started For: [" .. PlayerName .. "]")
				-- local target = GLR_Libs.WhoLib:UserInfo(vN, 
					-- {
						-- timeout = 1,
						-- Online,
						-- callback = function(target)
							-- GLR:CheckMultiGuildPlayerStatus(target, glrTemp, vN, state)
						-- end
					-- }
				-- )
			-- end
		-- end
		
	else
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
	end
	
end

local function AddPlayerTicketsAdvanced(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
	
	glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
	
	if state == "Lottery" then
		if guaranteedWinner then
			glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
		else
			glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( PlayerTickets * 2)
		end
	else
		glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
	end
	
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(TicketNumber)
	
	if state == "Lottery" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	else
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	end
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	GLR_U:UpdateInfo()
	
	if glrCharacter[state].MessageStatus == nil then
		glrCharacter[state].MessageStatus = {}
	end
	
	if glrCharacter[state].MessageStatus[PlayerName] == nil then
		local dateTime = time()
		if not FreeTickets then
			glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
		else
			glrCharacter[state].MessageStatus[PlayerName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
		end
	end
	
	local vN = PlayerName
	local targetRealm
	local bypass = false
	local removed = false
	
	if string.find(string.lower(PlayerName), "-") ~= nil then
		targetRealm = string.sub(PlayerName, string.find(PlayerName, "-") + 1)
	else
		bypass = true
	end
	
	if PlayerRealmName == targetRealm and not bypass then
		vN = string.sub(PlayerName, 1, string.find(PlayerName, "-") - 1)
		removed = true
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:AddPlayerTicketsAdvanced() - Successfully Added Entry For: [" .. PlayerName .. "]")
	
	if continue then
		
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:SendPlayerTheirTicketInfo() - Sent Player Ticket Info To: [" .. PlayerName .. "]")
		
	--elseif not continue and status then
		--local printed = false
		--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
		--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
		-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
			-- for i = 1, #glrHistory.GuildRoster[faction][key] do
				-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
				-- if removed then
					-- CompareText = string.sub(CompareText, 1, string.find(CompareText, '-') - 1)
				-- end
				-- if CompareText == vN then
					-- continue = true
					-- break
				-- end
			-- end
			-- if continue then
				-- break
			-- end
		-- end
		-- if continue then
			-- if not glrCharacter[state].MessageStatus[PlayerName]["sentMessage"] then
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:AddPlayerTicketsAdvanced() - WhoLib Search Started For: [" .. PlayerName .. "]")
				-- local target = GLR_Libs.WhoLib:UserInfo(vN, 
					-- {
						-- timeout = 1,
						-- Online,
						-- callback = function(target)
							-- GLR:CheckMultiGuildPlayerStatus(target, glrTemp, vN, state)
						-- end
					-- }
				-- )
			-- end
		-- end
		
	else
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
	end
	
end

local function EditPlayerTickets(PlayerName, PlayerTickets, guaranteedWinner, state, continue, ticketChange)
	
	local FirstTicketNumberBought = true
	local LastTicketNumberBought = true
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	
	for i = 1, PlayerTickets do
		
		if glrCharacter[state].TicketPool[1] ~= nil then
			
			table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], glrCharacter[state].TicketPool[1])
			table.insert(glrTemp[state][PlayerName], glrCharacter[state].TicketPool[1])
			if PlayerTickets == i and LastTicketNumberBought then
				glrCharacter[state].Entries.TicketRange[PlayerName].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
				glrTemp[state][PlayerName].TicketRange.HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
				LastTicketNumberBought = false
			end
			table.remove(glrCharacter[state].TicketPool, 1)
			
		else
			
			local ts = tostring(TicketNumber)
			table.insert(glrCharacter[state].Entries.TicketNumbers[PlayerName], ts)
			table.insert(glrTemp[state][PlayerName], ts)
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
	
	sort(glrCharacter[state].Entries.TicketNumbers[PlayerName])
	
	glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + PlayerTickets
	glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = ticketChange
	glrCharacter[state].Entries.Tickets[PlayerName].Sold = ticketChange
	glrTemp[state][PlayerName].NumberOfTickets = ticketChange
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(TicketNumber)
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	GLR_U:UpdateInfo()
	
	local state = "Lottery"
	local vN = PlayerName
	local targetRealm
	local bypass = false
	local removed = false
	
	if string.find(string.lower(PlayerName), "-") ~= nil then
		targetRealm = string.sub(PlayerName, string.find(PlayerName, "-") + 1)
	else
		bypass = true
	end
	
	if PlayerRealmName == targetRealm and not bypass then
		vN = string.sub(PlayerName, 1, string.find(PlayerName, "-") - 1)
		removed = true
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:EditPlayerTickets() - Successfully Edited Entry For: [" .. PlayerName .. "]")
	
	if continue then
		
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:SendPlayerTheirTicketInfo() - Sent Player Ticket Info To: [" .. PlayerName .. "]")
		
	--elseif not continue then
		
		--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
		--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
		-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
			-- for i = 1, #glrHistory.GuildRoster[faction][key] do
				-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
				-- if removed then
					-- CompareText = string.sub(CompareText, 1, string.find(CompareText, '-') - 1)
				-- end
				-- if CompareText == v then
					-- continue = true
					-- break
				-- end
			-- end
			-- if continue then
				-- break
			-- end
		-- end
		-- if continue then
			-- if not glrCharacter[state].MessageStatus[PlayerName].sentMessage then
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:EditPlayerTickets() - WhoLib Search Started For: [" .. PlayerName .. "]")
				-- local target = GLR_Libs.WhoLib:UserInfo(vN, 
					-- {
						-- timeout = 1,
						-- Online,
						-- callback = function(target)
							-- GLR:CheckMultiGuildPlayerStatus(target, glrTemp, vN, state)
						-- end
					-- }
				-- )
			-- end
		-- end
		
	else
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
	end
	
end

local function EditPlayerTicketsAdvanced(PlayerName, PlayerTickets, guaranteedWinner, state, continue, ticketChange)
	
	if state == "Lottery" then
		if guaranteedWinner then
			glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
		else
			glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( PlayerTickets * 2)
		end
	else
		glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + PlayerTickets
	end
	
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	
	glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + PlayerTickets
	glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = ticketChange
	glrCharacter[state].Entries.Tickets[PlayerName].Sold = ticketChange
	glrTemp[state][PlayerName].NumberOfTickets = ticketChange
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(TicketNumber)
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	GLR_U:UpdateInfo()
	
	local vN = PlayerName
	local targetRealm
	local bypass = false
	local removed = false
	
	if string.find(string.lower(PlayerName), "-") ~= nil then
		targetRealm = string.sub(PlayerName, string.find(PlayerName, "-") + 1)
	else
		bypass = true
	end
	
	if PlayerRealmName == targetRealm and not bypass then
		vN = string.sub(PlayerName, 1, string.find(PlayerName, "-") - 1)
		removed = true
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:EditPlayerTicketsAdvanced() - Successfully Edited Entry For: [" .. PlayerName .. "]")
	
	if continue then
		
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Mail:SendPlayerTheirTicketInfo() - Sent Player Ticket Info To: [" .. PlayerName .. "]")
		
	--elseif not continue then
		
		--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
		--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
		-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
			-- for i = 1, #glrHistory.GuildRoster[faction][key] do
				-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
				-- if removed then
					-- CompareText = string.sub(CompareText, 1, string.find(CompareText, '-') - 1)
				-- end
				-- if CompareText == v then
					-- continue = true
					-- break
				-- end
			-- end
			-- if continue then
				-- break
			-- end
		-- end
		-- if continue then
			-- if not glrCharacter[state].MessageStatus[PlayerName].sentMessage then
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - EditPlayerTicketsAdvanced() - WhoLib Search Started For: [" .. PlayerName .. "]")
				-- local target = GLR_Libs.WhoLib:UserInfo(vN, 
					-- {
						-- timeout = 1,
						-- Online,
						-- callback = function(target)
							-- GLR:CheckMultiGuildPlayerStatus(target, glrTemp, vN, state)
						-- end
					-- }
				-- )
			-- end
		-- end
		
	else
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
	end
	
end

local function MailSetTickets(sender, numTickets, raffle, moneyString)
	
	local faction, _ = UnitFactionGroup("PLAYER")
	local MultiGuild = glrCharacter.Data.Settings.General.MultiGuild
	local CurrentNumTickets = 0
	local ExtraGold = 0
	local ExtraTickets = 0
	local overLimit = 0
	local progress = true
	local continue = false
	local guaranteedWinner = false
	local ChatInfo = glrCharacter.Data.Settings.General.ToggleChatInfo
	local numTotalMembers, _, _ = GetNumGuildMembers()
	local dateTime = time()
	local state = "Lottery"
	
	if raffle == 1 then
		state = "Raffle"
	end
	
	local timestamp = GetTimeStamp()
	
	for i = 1, numTotalMembers do
		local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
		if sender == name then
			if isOnline then
				continue = true
			end
			break
		end
	end
	
	if glrTemp == nil then
		glrTemp = {}
	end
	
	if state == "Lottery" then
		if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
			guaranteedWinner = true
		end
	else
		guaranteedWinner = true
	end
	
	local maxTickets = tonumber(glrCharacter.Event[state].MaxTickets)
	local TicketCost = tonumber(glrCharacter.Event[state].TicketPrice)
	
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSetTickets() - Starting Process For: [" .. sender .. "]")
	
	if numTickets >= maxTickets then
		local ct = 0
		if glrCharacter[state].Entries.Tickets ~= nil then
			if glrCharacter[state].Entries.Tickets[sender] ~= nil then
				if glrCharacter[state].Entries.Tickets[sender].NumberOfTickets ~= nil then
					ct = glrCharacter[state].Entries.Tickets[sender].NumberOfTickets
					if maxTickets == ct then
						ExtraGold = numTickets * TicketCost
						ExtraTickets = numTickets
						numTickets = 0
					else
						local td = maxTickets - ct
						if numTickets > td then
							ExtraTickets = numTickets - maxTickets
							ExtraGold = ExtraTickets * TicketCost
							numTickets = td
						end
					end
				else
					if numTickets > maxTickets then
						ExtraTickets = numTickets - maxTickets
						ExtraGold = ExtraTickets * TicketCost
						numTickets = maxTickets
					end
				end
			else
				if numTickets > maxTickets then
					ExtraTickets = numTickets - maxTickets
					ExtraGold = ExtraTickets * TicketCost
					numTickets = maxTickets
				end
			end
		end
	end
	
	if ExtraTickets > 0 and ChatInfo then
		GLR:Print(sender .. " " .. L["Mail Scan Extra Ticket String 1"] .. " " .. ExtraGold .. " " .. L["Mail Scan Extra Ticket String 2"] .. ". " .. L["Mail Scan Extra Ticket String 3"] .. ".")
	end
	
	if glrTemp[state] == nil then
		glrTemp[state] = {}
	end
	if glrTemp[state][sender] == nil then
		glrTemp[state][sender] = {}
	end
	if glrTemp[state][sender].TicketNumbers == nil then
		glrTemp[state][sender].TicketNumbers = {}
	end
	if glrTemp[state][sender].NumberOfTickets == nil then
		glrTemp[state][sender].NumberOfTickets = 0
	end
	if glrCharacter[state].Entries == nil then
		glrCharacter[state].Entries = {}
	end
	if glrCharacter[state].Entries.TicketRange == nil then
		glrCharacter[state].Entries.TicketRange = {}
	end
	if glrCharacter[state].Entries.TicketRange[sender] == nil then
		glrCharacter[state].Entries.TicketRange[sender] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
	end
	if glrTemp[state][sender].TicketRange == nil then
		glrTemp[state][sender].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
	end
	
	if glrCharacter[state].Entries.Tickets[sender] == nil then
		
		glrCharacter[state].Entries.Tickets[sender] = {}
		glrCharacter[state].Entries.Tickets[sender].Given = 0
		glrCharacter[state].Entries.Tickets[sender].Sold = numTickets
		glrCharacter[state].Entries.Tickets[sender].NumberOfTickets = 0
		glrCharacter[state].Entries.Tickets[sender].NumberOfTickets = numTickets
		glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + numTickets
		
		table.insert(glrCharacter[state].Entries.Names, sender)
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSetTickets() - Scanned Mail. ADDING Player for Event: [" .. string.upper(tostring(state)) .. "] - Advanced: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.AdvancedTicketDraw)) .. "] - Player: [" .. sender .. "] - Tickets: [" .. numTickets .. "] - Online: [" .. string.upper(tostring(continue)) .. "] - Reply: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.ReplyToSender)) .. "]" )
		
		if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
			AddPlayerTickets(sender, numTickets, false, guaranteedWinner, state, continue)
		else
			AddPlayerTicketsAdvanced(sender, numTickets, false, guaranteedWinner, state, continue)
		end
		
	elseif glrCharacter[state].Entries.Tickets[sender] ~= nil then
		
		local currentTickets = glrCharacter[state].Entries.Tickets[sender].NumberOfTickets
		local ticketChange = numTickets + currentTickets
		local continueEdit = true
		
		if glrCharacter[state].Entries.Tickets[sender].Given == nil then
			glrCharacter[state].Entries.Tickets[sender].Given = 0
		end
		if glrCharacter[state].Entries.Tickets[sender].Sold == nil then
			glrCharacter[state].Entries.Tickets[sender].Sold = 0
		end
		
		if ticketChange > maxTickets then
			numTickets = 0
		elseif ticketChange == maxTickets then
			numTickets = maxTickets - currentTickets
			ticketChange = maxTickets
		end
		
		if numTickets == 0 then
			continueEdit = false
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSetTickets() - Scanned Mail. EDITING Player for Event: [" .. string.upper(tostring(state)) .. "] - Advanced: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.AdvancedTicketDraw)) .. "] - Player: [" .. sender .. "] - Tickets: [" .. numTickets .. "] - Online: [" .. string.upper(tostring(continue)) .. "] - Reply: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.ReplyToSender)) .. "]" )
		
		if continueEdit then
			
			if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				EditPlayerTickets(sender, numTickets, guaranteedWinner, state, continue, ticketChange)
			else
				EditPlayerTicketsAdvanced(sender, numTickets, guaranteedWinner, state, continue, ticketChange)
			end
			
		end
		
	end
	
	if glrCharacter.Data.Settings.General.ReplyToSender then -- Prevents sending confirmation mail when the price per ticket is greater than 30 copper (cost to mail) and the money received is greater than 30 copper as well.
		local money = tonumber(moneyString)
		if money > 0.003 then
			DidReply = true
			local timestamp = GetTimeStamp()
			if reply[state][sender] == nil then
				MailCount = MailCount + 1
				reply[state][sender] = { ["Name"] = sender, ["Bought"] = numTickets, ["Current"] = glrCharacter[state].Entries.Tickets[sender].NumberOfTickets, ["Value"] = moneyString, ["Sent"] = false, }
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSetTickets() - Adding Reply Mail for: [" .. sender .. "] - MailCount: [" .. MailCount .. "]")
			else
				if not reply[state][sender].Sent then
					reply[state][sender] = { ["Name"] = sender, ["Bought"] = reply[state][sender].Bought + numTickets, ["Current"] = glrCharacter[state].Entries.Tickets[sender].NumberOfTickets, ["Value"] = reply[state][sender].Value + moneyString, ["Sent"] = false, }
				else
					MailCount = MailCount + 1
					reply[state][sender] = { ["Name"] = sender, ["Bought"] = numTickets, ["Current"] = glrCharacter[state].Entries.Tickets[sender].NumberOfTickets, ["Value"] = moneyString, ["Sent"] = false, }
				end
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MailSetTickets() - Editing Reply Mail for: [" .. sender .. "] - MailCount: [" .. MailCount .. "]")
			end
		end
	end
	
end

-- GLR_M.GLR_ReplyFrame = CreateFrame("Frame")
-- GLR_M.GLR_ReplyFrame:Hide()
-- GLR_M.GLR_ReplyFrame:SetScript("OnShow", function(self)
	-- self.time = 2
	-- if self.time < 1.0 then
		-- self.time = 2
	-- end
-- end)
-- GLR_M.GLR_ReplyFrame:SetScript("OnUpdate", function(self, elapsed)
	-- self.time = self.time - elapsed
	-- if self.time <= 0 then
		-- self:Hide()
		-- SendReply()
	-- end
-- end)

-- Frame to process opening mail
GLR_M.GLR_UpdateFrame = CreateFrame("Frame") -- Made a global frame so the rest of the mod can access it.
GLR_M.GLR_UpdateFrame:Hide()
GLR_M.GLR_UpdateFrame:SetScript("OnShow", function(self)
	self.time = 2
	if self.time < 1.0 and not self.lootingMoney then
		-- Delay opening to 2 seconds to account for a nearly full
		-- inventory to respect the KeepFreeSpace setting
		self.time = 2
	end
	self.lootingMoney = false
end)
GLR_M.GLR_UpdateFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if self.time <= 0 then
		self:Hide()
		GLR_M:ProcessNext()
	end
end)

function GLR_RefreshFrame:OnEvent(event)
	local current, total = GetInboxNumItems()
	if current == MAX_MAIL_SHOWN or current == total then
		self.time = 3
		self.mode = 1
		GLR:UnregisterEvent("MAIL_INBOX_UPDATE")
	end
end
GLR_RefreshFrame:SetScript("OnEvent", GLR_RefreshFrame.OnEvent)

function GLR_M:OpenAll(isRecursive)
	if (not MailFrame:IsVisible()) then
		return
	end
	
	GLR_RefreshFrame:Hide()
	mailIndex, numUnshownItems = GetInboxNumItems()
	numUnshownItems = numUnshownItems - mailIndex
	lastNumGold = nil
	wait = false
	
	if mailIndex == 0 then
		Continue()
		return
	end
	firstMailDaysLeft = select(7, GetInboxHeaderInfo(1))
	
	DisableInbox(true)
	
	GLR_UI.GLR_ScanMailButtonText:SetText(L["Mail Scan - Processing"])
	
	GLR_M:ProcessNext()
end

function GLR_M:ProcessNext()
	
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
	local PlayerRealmName = string.sub(FullPlayerName, string.find(FullPlayerName, "-") + 1)
	local LotteryStatus = glrCharacter.Data.Settings.CurrentlyActiveLottery
	local RaffleStatus = glrCharacter.Data.Settings.CurrentlyActiveRaffle
	local continue = false
	local currentFirstMailDaysLeft = select(7, GetInboxHeaderInfo(1))
	if currentFirstMailDaysLeft ~= firstMailDaysLeft then
		return GLR_M:OpenAll(true)
	end
	if LotteryStatus == nil then
		LotteryStatus = false
	end
	if RaffleStatus == nil then
		RaffleStatus = false
	end
	
	if glrRosterTotal == 0 then
		if not status then
			GLR_U:UpdateRosterTable()
		else
			GLR_U:UpdateMultiGuildTable()
		end
	end
	
	if mailIndex > 0 then
		
		if wait then
			local goldCount = CountMoney()
			if lastNumGold ~= goldCount then
				wait = false
				mailIndex = mailIndex - 1
				return self:ProcessNext() -- Tail Call
			else
				GLR_M.GLR_UpdateFrame:Show()
				return
			end
		end
		
		local _, _, sender, subject, money, CODAmount, _, hasItem, _, _, msgText, _, isGM = GetInboxHeaderInfo(mailIndex)
		
		if sender ~= nil then
			
			local name = sender
			local skip = true
			
			if string.find(string.lower(name), "-") == nil then
				sender = strjoin("-", name, PlayerRealmName)
			end
			
			if not status then
				for i = 1, #glrRoster do --Does this if Multi-Guild is Disabled
					local test = string.sub(glrRoster[i], 1, string.find(glrRoster[i], '%[') - 1)
					if sender == test then
						continue = true
						skip = false
						break -- No need to continue searching a potentially large table once a name's found
					end
				end
			else
				for i = 1, #glrMultiGuildRoster do --Does this if Multi-Guild is Enabled
					local test = string.sub(glrMultiGuildRoster[i], 1, string.find(glrMultiGuildRoster[i], '%[') - 1)
					if sender == test then
						continue = true
						skip = false
						break -- No need to continue searching a potentially large table once a name's found
					end
				end
			end
			
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Scanning Mail. Skip: [" .. string.upper(tostring(skip)) .. "] - Sent By: [" .. sender .. "] - Subject: [" .. subject .. "] - Index: [" .. mailIndex .. "]")
			
			--Skip mail if it contains a CoD or it's from a GM or if the sender isn't from your Guild (or Multi-Guild)
			if (CODAmount and CODAmount > 0) or (isGM) or not continue then
				mailIndex = mailIndex - 1
				return self:ProcessNext() -- Tail call
			end
			
			--Filter by mail type
			local mailType = GetMailType(subject)
			if mailType == "NonAHMail" then
				
				if hasItem then
					--Skips mails with attachments
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Skipping Mail With Attachment. Index: [" .. mailIndex .. "]")
					mailIndex = mailIndex - 1
					return self:ProcessNext()
				end
				
				local doSkip = true
				local mailSubject = string.lower(subject)
				
				for state, entries in pairs(glrHistory.Settings) do
					if state == "Lottery" or state == "Raffle" then
						local doBreak = false
						if not RaffleStatus and not LotteryStatus then break end
						for i = 1, #glrHistory.Settings[state].Mail do
							local phrase = string.lower(glrHistory.Settings[state].Mail[i])
							if state == "Lottery" and LotteryStatus then --Still need to check for the English "lottery" and "raffle" in case of multi-language guild.
								if mailSubject == phrase or mailSubject == "lottery" then
									doSkip = false
									doBreak = true
									break
								end
							elseif state == "Raffle" and RaffleStatus then
								if mailSubject == phrase or mailSubject == "raffle" then
									doSkip = false
									doBreak = true
									break
								end
							end
						end
						if doBreak then break end
					end
				end
				
				if doSkip then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Skipping Mail With Subject: [" .. subject .. "] - Index: [" .. mailIndex .. "]")
					--if glrCharacter.Data.Settings.General.ToggleChatInfo then
						GLR:Print("Incorrect Subject Phrase Detected. Skipped Mail Sent By: [" .. sender .. "] - With Subject: [" .. subject .. "]")
					--end
					mailIndex = mailIndex - 1
					return self:ProcessNext() -- Tail Call
				end
				
			else
				--Skip AH Mail Types
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Skipping Auction House Mail. Index: [" .. mailIndex .. "]")
				mailIndex = mailIndex - 1
				return self:ProcessNext() -- Tail call
			end
			
			if money > 0 then
				
				if InboxFrame:IsVisible() then
					
					local raffle = 0
					local numTickets = 0
					local ticketPrice = 0
					local printSubject = ""
					local moneyString = GetMoneyString(money)
					local ChatInfo = glrCharacter.Data.Settings.General.ToggleChatInfo
					local continue = false
					local mailSubject = string.lower(subject)
					
					-- for i = 1, #glrHistory.Settings.Lottery.Mail do
						-- local phrase = string.lower(glrHistory.Settings.Lottery.Mail[i])
						-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - LOTTERY: Comparing Mail Subject: [" .. mailSubject .. "] - With: [" .. phrase .. "]")
						-- if mailSubject == phrase or mailSubject == "lottery" or mailSubject == "lottery - souk" then
							-- raffle = 0
							-- printSubject = L["Lottery"]
							-- ticketPrice = tonumber(glrCharacter.Event.Lottery.TicketPrice)
							-- continue = true
							-- break
						-- end
					-- end
					-- if not continue then
						-- for i = 1, #glrHistory.Settings.Raffle.Mail do
							-- local phrase = string.lower(glrHistory.Settings.Raffle.Mail[i])
							-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - RAFFLE: Comparing Mail Subject: [" .. mailSubject .. "] - With: [" .. phrase .. "]")
							-- if mailSubject == phrase or mailSubject == "raffle" then
								-- raffle = 1
								-- printSubject = L["Raffle"]
								-- ticketPrice = tonumber(glrCharacter.Event.Raffle.TicketPrice)
								-- continue = true
								-- break
							-- end
						-- end
					-- end
					
					for state, entries in pairs(glrHistory.Settings) do
						if state == "Lottery" or state == "Raffle" then
							local doBreak = false
							for i = 1, #glrHistory.Settings[state].Mail do
								local phrase = string.lower(glrHistory.Settings[state].Mail[i])
								if state == "Lottery" then --Still need to check for the English "lottery" and "raffle" in case of multi-language guild.
									if mailSubject == phrase or mailSubject == "lottery" then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Found Matching Mail Subject: [" .. mailSubject .. "] - Key: [" .. phrase .. "]")
										if ChatInfo and not GLR_ReleaseState then
											GLR:Print("Found Matching Mail Subject: [" .. mailSubject .. "] - Key: [" .. phrase .. "]")
										end
										raffle = 0
										printSubject = L["Lottery"]
										ticketPrice = tonumber(glrCharacter.Event.Lottery.TicketPrice)
										continue = true
										doBreak = true
										break
									end
								elseif state == "Raffle" then
									if mailSubject == phrase or mailSubject == "raffle" then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Found Matching Mail Subject: [" .. mailSubject .. "] - Key: [" .. phrase .. "]")
										if ChatInfo and not GLR_ReleaseState then
											GLR:Print("Found Matching Mail Subject: [" .. mailSubject .. "] - Key: [" .. phrase .. "]")
										end
										raffle = 1
										printSubject = L["Raffle"]
										ticketPrice = tonumber(glrCharacter.Event.Raffle.TicketPrice)
										continue = true
										doBreak = true
										break
									end
								end
							end
							if doBreak then break end
						end
					end
					
					if not continue then --Mail Subject was processed but did not match.
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Mail Sent By [" .. sender .. "] Detected as Invalid.")
						mailIndex = mailIndex - 1
						return self:ProcessNext() -- Tail Call
					end
					
					local totalTickets = moneyString / ticketPrice
					for i = 1, totalTickets do --Even if someone is short by 1 copper, it will not count that ticket. So gold sent must be a 1 to 1 ratio (gold to ticket cost)
						numTickets = numTickets + 1
					end
					
					if ChatInfo then
						local SentMoney = GetMoneyValue(moneyString, true)
						local message = string.gsub(string.gsub(string.gsub(L["Mail Scan - Processing Format"], "%%sender", sender), "%%subject", printSubject), "%%money", SentMoney)
						GLR:Print(message)
					end
					
					if numTickets == 0 and ChatInfo then
						local ExtraMoney = GetMoneyValue(moneyString, true)
						local message = string.gsub(string.gsub(L["Mail Scan - Extra Tickets"], "%%sender", sender), "%%money", ExtraMoney)
						GLR:Print(message)
					else
						local ExtraAmount = (totalTickets - numTickets) * ticketPrice
						if ExtraAmount > 0 and ChatInfo then
							local ExtraMoney = GetMoneyValue(ExtraAmount, true)
							local message = string.gsub(string.gsub(L["Mail Scan - Extra Tickets"], "%%sender", sender), "%%money", ExtraMoney)
							GLR:Print(message)
						end
					end
					
					TakeInboxMoney(mailIndex)
					MailSetTickets(sender, numTickets, raffle, moneyString)
					
					lastNumGold = CountMoney()
					
					if msgText ~= nil then
						DeleteInboxItem(mailIndex)
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Detected mail with Text. Sender: [" .. sender .. "] - Deleting #[" .. mailIndex .. "]")
					end
					
					wait = true
					
					--GLR_M.GLR_UpdateFrame.lootingMoney = true
					GLR_M.GLR_UpdateFrame:Show()
					
				else
					
					GLR:Print(L["Mail Scan - Interrupted"])
					
				end
				
			else
				--Mail has no money, even if it's labeled "Lottery" or "Raffle" it skips
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Detected Valid Mail Subject, But Detected ZERO Money. Sender: [" .. sender .. "] - Subject: [" .. subject .. "] - Index: [" .. mailIndex .. "]")
				mailIndex = mailIndex - 1
				return self:ProcessNext() -- Tail call
			end
			
		else
			
			--Mail 'sender' name returned nil and would therefore cause a error, forces the scan to skip that mail. The user may click the Scan button again to attempt to process it again.
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ProcessNext() - Sender was NIL. Index: [" .. mailIndex .. "]")
			mailIndex = mailIndex - 1
			return self:ProcessNext() -- Tail call
			
		end
		
	else--if mailIndex == 0 and MailCount == 0 then
		
		local numItems, totalItems = GetInboxNumItems()
		if numUnshownItems ~= totalItems - numItems then
			return GLR_M:OpenAll(true) -- Tail call
		elseif totalItems > numItems and numItems < MAX_MAIL_SHOWN then
			GLR_RefreshFrame:Show()
			return
		end
		
		Continue()
		
	end
end

--[[
    local postmaster = {
        ['Der Postmeister'] = true,
        ['The Postmaster'] = true,
    }
    local f=CreateFrame("Frame")
    f:SetScript("OnEvent", function(self,event)
        for i=GetInboxNumItems(),1,-1 do
            local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned, textCreated, canReply, isGM =GetInboxHeaderInfo(i)
            if(postmaster[sender]) then
                if(money and money >0) then
                    TakeInboxMoney(i)
                end
                if(hasItem) then
                    for j = 1, ATTACHMENTS_MAX_RECEIVE do
                        local name, texture, count, quality, canUse = GetInboxItem(i, j)
                        if(name) then
                            TakeInboxItem(i,j)
                        end
                    end
                end
                C_Timer.After(5, function() DeleteInboxItem(i) end)
            end
        end
    end
    f:RegisterEvent("MAIL_INBOX_UPDATE")
]]