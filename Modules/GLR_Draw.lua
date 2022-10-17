local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")
if not L then return end
GLR_D = {}
local Variables = {
	{ false, false, false, },		-- [1]	[PRIZE NAMES]			Becomes the name(s) of the First, Second, and/or Third Raffle Prizes when announcing them.
	{ false, false, false, },		-- [2]	[PRIZE EXISTS]			Becomes True if a Raffle Prize exists for First, Second, Third.
	{ false, false, false, },		-- [3]	[WINNERS ANNOUNCED]		First / Second / Third Raffle Place. Becomes True as the mod announces the associated winners.
	{ "", "", "", },				-- [4]	[RAFFLE WINNERS]		Becomes the Name of the First / Second / Third Place Raffle Winners.
	{ "NA", "NA", "NA", },			-- [5]	[RAFFLE TICKETS]		The First / Second / Third Place Winning Ticket number.
	{ "NA",	"NA", },				-- [6]	[PREVIOUS TICKET]		Used to store the Lottery Winning Ticket Number & Winner's Name to be placed in the Previous Event data.
	{ false, false, },				-- [7]	[DRAW COMPLETE]			Becomes True once the Lottery / Raffle Event Draw process is complete.
	false,							-- [8]	[BEGIN ANNOUNCE]		Once the mod starts announcing Raffle Winners, this becomes True and is false all other times.
	false,							-- [9]	[ABORT PRINTED]			If the user decides to Abort a Draw, this will become True once the Abort Message is printed; preventing multiple messages from appearing.
	false,							-- [10]	[LOTTERY WINNER]		Becomes True once a Winner has been found for the Lottery
	false,							-- [11]	[WINNER FOUND]			If a Lottery Winner ( FIRST ONLY ) is found, becomes True; telling the mod to clear certain Previous Event data to prevent the next Lottery's Starting Amount from being incorrect.
	{ 								-- [12]	[WIN TYPE]
		false,						--		[1] If a Lottery Winner ( FIRST ONLY ) is found, becomes True. Otherwise it stays False; telling the mod when reporting Previous Event data that the winning Jackpot was for Second Place or not at all (if no name found for the Winning Ticket)
		false, 						--		[2] Becomes true if #1 remains false, telling the mod no one won second place and should Rollover Player Names if the CarryOver setting is true
	},								--
	{ 								-- [13]	[JACKPOT LEFT & NUM TICKETS] 
		0,							--			(1) Becomes the Remaining Jackpot if no one wins First Place in a Lottery.
		0, 							--			(2) Becomes the number of Tickets generated when running Advanced Lottery / Raffle Draws.
	},								--
	false,							-- [14]	[ADVANCED]				Becomes True if the user is running the Advanced Draw for their Event.
	"",								-- [15]	[ADV. PREV. TICKET]		When searching for a Winner in Advanced Draws, if a winner isn't found this variable prevents the mod from picking the same number.
	false,							-- [16]	[RAFFLE BUFFER]			Acts as a buffer while the mod completes Advanced Raffle Draws.
	0,								-- [17]	[GENERATED NUM]			Becomes the number of Tickets the mod is required to generate during Advanced Draws.
	false,							-- [18]	[DEBUG PRINTED]			Used for Debug Tracing.
	false,							-- [19] [END OF EVENT MSG]		To prevent duplicate messages
	{								-- [20] [ADD RAFFLE PRIZES]
		{ false, false, },			--		[1] Becomes the Second and Third Prizes when adding to the Raffle
		{ "", "", },				--		[2] Acts as a buffer holding the ItemName and ItemLink for the new Second Place Prize
		{ "", "", },				--		[3] Acts as a buffer holding the ItemName and ItemLink for the new Third Place Prize
		false,						--		[4] Boolean gate. Becomes true while checking if the new prize is valid.
		{ false, false, },			--		[5] Tells whether a new Prize was added.
		{ false, false, },			--		[6] Becomes true as Prizes are added. If both are True then #7 becomes true.
		false,						--		[7] Becomes true if both a 2nd and 3rd Prize are added. Disabling the Add Prizes button.
		{ "", "", },				--		[8] String value. Used to display ingame the item or currency the player is adding (used as buffer).
		{ false, false, },			--		[9] Becomes True if #8 was maxed out at 10mil. Displaying additional Tooltip info.
		{ false, false, },			--		[10] True if Original Prize is greater than 10mil.
		{ 0, 0, },					--		[11] Becomes the value used in Tooltip Info if #10 is true
	},								--
	{								-- [21] Place to store names with Zero entries while the event is drawn. If the event is aborted, it re-adds the names.
		["Lottery"] = {},			--
		["Raffle"] = {},			--
	},								--
	{								-- [22] Advanced Lottery Ticket Generation and Assigning values
		{ false, false },			--		[1][1] Initial Starting Buffer - Boolean value that changes to True when the Ticket Generation starts.
		{							--		[1][2] Initial Assigning Buffer (same as #1 but for Assigning Tickets)
			0,						--		[2][1] Numeric Value starts at ZERO and increases as it generates Ticket Numbers.
			0,						--		[2][2] Numeric Value starts at the Lowest Ticket Number (ie: 1000, 2000, 3000, ...) and increases as the Tickets are Generated.
			1,						--		[2][3] Numeric Value starts at ONE. Increments as it goes to the next player to assign tickets to.
			0,						--		[2][4] Numeric Value becomes the number of Tickets to Generate in the current cycle. Never higher than 10,000
			0,						--		[2][5] Numeric Value becomes the number of Tickets that remain to Generate
			0,						--		[2][6] Numeric Value becomes the number of Tickets to Assign to a Player
			0,						--		[2][7] Numeric Value becomes the number of Tickets left to Assign to a Player
			0,						--		[2][8] Numeric Value becomes the number of Tickets to Assign in the current cycle. Never higher than 10,000
			0,						--		[2][9] Numeric Value starts at ZERO and increases as a Ticket Number is successfully assigned to a Player. Is used to determine how many have been assigned.
			0,						--		[2][10] Numeric Value becomes the Total number of Tickets to Assign to all Players for the current Event Draw.
			0,						--		[2][11] Numeric Value starts at ZERO and increases as Tickets are Assigned successfully. Is used to determine the Total number Assigned.
			"",						--		[2][12] String Value becomes either "Lottery" or "Raffle" to move the StatusBar Frame accordingly.
			0,						--		[2][13] Numeric Value becomes the Lowest Ticket Number. Used as the low end in math.random()
			0,						--		[2][14] Numeric Value becomes the Highest Ticket Number. Used as the high end in math.random()
			false,					--		[2][15] Boolean Value becomes true if the Event is Guaranteed a Winner.
			0,						--		[2][16] Numeric Value becomes the Lowest Ticket Number. Increases when assigning Tickets in Guaranteed Winner Events.
		},							--
		false,						--		[3] Boolean Value starts at false and becomes True once it has determined the number of Tickets to Assign to the current Player.
		{ false, false, },			--		[4] (1) Boolean starts at false and becomes True once all Ticket Numbers are Generated. (2) Boolean starts at false and becomes True once all Ticket Numbers are Assigned.
	},								--
	true,							-- [23] Can Speak in Guild Chat. Becomes false during (or before) Event Draw if the host can't talk in Guild Chat.
	{								-- [24] Number of Month
		[1] = L["January Short"],	--
		[2] = L["February Short"],	--
		[3] = L["March Short"],		--
		[4] = L["April Short"],		--
		[5] = L["May Short"],		--
		[6] = L["June Short"],		--
		[7] = L["July Short"],		--
		[8] = L["August Short"],	--
		[9] = L["September Short"],	--
		[10] = L["October Short"],	--
		[11] = L["November Short"],	--
		[12] = L["December Short"]	--
	},								--
	{								-- [25] Number of Day
		[1] = "st",					--
		[2] = "nd",					--
		[3] = "rd",					--
		[4] = "th",					--
		[5] = "th",					--
		[6] = "th",					--
		[7] = "th",					--
		[8] = "th",					--
		[9] = "th",					--
		[10] = "th",				--
		[11] = "th",				--
		[12] = "th",				--
		[13] = "th",				--
		[14] = "th",				--
		[15] = "th",				--
		[16] = "th",				--
		[17] = "th",				--
		[18] = "th",				--
		[19] = "th",				--
		[20] = "th",				--
		[21] = "st",				--
		[22] = "nd",				--
		[23] = "rd",				--
		[24] = "th",				--
		[25] = "th",				--
		[26] = "th",				--
		[27] = "th",				--
		[28] = "th",				--
		[29] = "th",				--
		[30] = "th",				--
		[31] = "st"					--
	}								--
}									--


local WinChanceTable = { [1] = 0.9, [2] = 0.8, [3] = 0.7, [4] = 0.6, [5] = 0.5, [6] = 0.4, [7] = 0.3, [8] = 0.2, [9] = 0.1, [10] = 1 }
local WinChanceKey = 5
local WinChanceVariable = 10

-- A place to house all local frames, decreasing the local upvalue footprint
local Frames = {
	[1] = {}, -- Frames
	[2] = {}, -- Buttons
	[3] = {}, -- Text
	[4] = {}, -- Edit Boxes
	[5] = {}, -- Checkbox
}

local BackdropProfile = {
	Buttons = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		insets = { left = 5 , right = 5 , top = 5 , bottom = 5 },
	}
}

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

local function AddRafflePrizeLink(text)
	if text and Frames[4].AddRaffleSecondPrizeEditBox:HasFocus() then
		Frames[4].AddRaffleSecondPrizeEditBox:SetText(text)
		Frames[4].AddRaffleSecondPrizeEditBox:SetCursorPosition(0)
		return true
	end
	if text and Frames[4].AddRaffleThirdPrizeEditBox:HasFocus() then
		Frames[4].AddRaffleThirdPrizeEditBox:SetText(text)
		Frames[4].AddRaffleThirdPrizeEditBox:SetCursorPosition(0)
		return true
	end
end

do
	hooksecurefunc("ChatEdit_InsertLink", AddRafflePrizeLink)
end

local function ConfirmAddNewPrizes(place)
	local text
	local use
	local allowInvalid = Frames[5].AllowInvalidItemsCheckButton:GetChecked()
	
	Variables[20][4] = true
	
	if place == "Second" then
		text = Frames[4].AddRaffleSecondPrizeEditBox:GetText()
		use = 2
	elseif place == "Third" then
		text = Frames[4].AddRaffleThirdPrizeEditBox:GetText()
		use = 3
	end
	
	local itemName, itemLink
	
	if tonumber(text) == nil then
		itemName, itemLink = GetItemInfo(text)
	end
	
	local function IsItemLinkCagedPet(t)
		local result = false
		if string.find(t, "battlepet:") ~= nil then
			result = true
		end
		return result
	end
	
	local function GetPetSpeciesIDFromLink(pet)
		pet = string.sub(pet, select(2, string.find(pet, "battlepet:")) + 1)	-- Parse out the first text up to colon + 1
		pet = string.sub(pet, 1, string.find(pet, ":") - 1)						-- The end of the ID will be a colon
		return tonumber(pet)
	end
	
	if not itemLink then
		if IsItemLinkCagedPet(text) then
			local isTradeable, name = IsPetTradeable(GetPetSpeciesIDFromLink(text))
			if isTradeable then
				itemLink = text
				itemName = name
			end
		end
	end
	
	if string.find(string.lower(text), "%%raffle_total") or string.find(string.lower(text), "%%raffle_half") or string.find(string.lower(text), "%%raffle_quarter") or tonumber(text) ~= nil then
		if tonumber(text) == nil then
			text = string.lower(text)
		elseif tonumber(text) ~= nil then
			if tonumber(text) < 0 then
				text = tostring(text * -1)
			end
			if tonumber(text) > 9999999.9999 then
				if use == 2 then
					Variables[20][8][1] = 9999999.9999
					Frames[3].SecondPlaceStringOverFlow:SetText("*")
				elseif use == 3 then
					Variables[20][8][2] = 9999999.9999
					Frames[3].ThirdPlaceStringOverFlow:SetText("*")
				end
			else
				if use == 2 then
					Variables[20][8][1] = tonumber(text)
					Frames[3].SecondPlaceStringOverFlow:SetText("")
				elseif use == 3 then
					Variables[20][8][2] = tonumber(text)
					Frames[3].ThirdPlaceStringOverFlow:SetText("")
				end
			end
			if use == 2 then
				Variables[20][8][1] = GLR_U:GetMoneyValue(Variables[20][8][1], "Raffle", false, 1, "NA", true, true)
			elseif use == 3 then
				Variables[20][8][2] = GLR_U:GetMoneyValue(Variables[20][8][2], "Raffle", false, 1, "NA", true, true)
			end
		end
		allowInvalid = true
	end
	
	if itemLink == nil and allowInvalid then
		itemLink = text
	end
	
	if itemName == nil and allowInvalid then
		local itemText = text
		local nameText
		local doTask
		local c = 0
		for v in string.gmatch(itemText, '%[') do
			doTask = "left"
			c = c + 1
		end
		for v in string.gmatch(itemText, '%]') do
			if doTask == "left" then
				doTask = "both"
			else
				doTask = "right"
			end
			c = c + 1
		end
		if c >= 1 then
			if doTask == "both" then
				nameText = string.sub(text, string.find(itemText, '%[') + 1, string.find(itemText, '%]') - 1)
			elseif doTask == "left" then
				nameText = string.sub(text, string.find(itemText, '%[') + 1)
			elseif doTask == "right" then
				nameText = string.sub(text, 1, string.find(itemText, '%]') - 1)
			end
		else
			nameText = itemText
		end
		itemName = nameText
	end
	
	if itemName then
		if use == 2 then
			Variables[20][2][1] = itemName
			Variables[20][5][1] = true
		elseif use == 3 then
			Variables[20][3][1] = itemName
			Variables[20][5][2] = true
		end
	end
	
	if itemLink then
		if use == 2 then
			Frames[2].ConfirmRaffleSecondPrize:Hide()
			Frames[4].AddRaffleSecondPrizeEditBox:SetText(itemLink)
			Frames[4].AddRaffleSecondPrizeEditBox:ClearFocus()
			Variables[20][2][2] = itemLink
			Variables[20][5][1] = true
		elseif use == 3 then
			Frames[2].ConfirmRaffleThirdPrize:Hide()
			Frames[4].AddRaffleThirdPrizeEditBox:SetText(itemLink)
			Frames[4].AddRaffleThirdPrizeEditBox:ClearFocus()
			Variables[20][3][2] = itemLink
			Variables[20][5][2] = true
		end
		Frames[3].InvalidItemText:SetText("")
	else
		if use == 2 then
			Frames[2].ConfirmRaffleSecondPrize:Hide()
			Frames[4].AddRaffleSecondPrizeEditBox:SetText("")
			Frames[4].AddRaffleSecondPrizeEditBox:ClearFocus()
			Variables[20][2][1] = ""
			Variables[20][2][2] = ""
			Variables[20][8][1] = ""
			Variables[20][5][1] = false
		elseif use == 3 then
			Frames[2].ConfirmRaffleThirdPrize:Hide()
			Frames[4].AddRaffleThirdPrizeEditBox:SetText("")
			Frames[4].AddRaffleThirdPrizeEditBox:ClearFocus()
			Variables[20][3][1] = ""
			Variables[20][3][2] = ""
			Variables[20][8][2] = ""
			Variables[20][5][2] = false
		end
		Frames[3].InvalidItemText:SetText(L["GLR - Core - Invalid Raffle Item"])
		if Frames[1].ConfirmAddRafflePrizesFrame:IsVisible() then
			Frames[1].ConfirmAddRafflePrizesFrame:Hide()
		end
	end
	
	C_Timer.After(1, function(self) Variables[20][4] = false end)
	
end

local TooltipHook = false
local TooltipCheck = false
local function IsItemSoulbound(tooltip)
	if TooltipCheck then return end
	if not IsShiftKeyDown() then return end
	TooltipCheck = true --Boolean gate set to flip to false after one second, but only when the script has reached the end. Saves processing power.
	local use = 0
	local ItemText = ""
	local continue = false
	local GLR_ItemStatus = true
	local ItemOkay = true
	local textLeft = tooltip.textLeft
	if Frames[4].AddRaffleSecondPrizeEditBox:HasFocus() then
		ItemText = Frames[4].AddRaffleSecondPrizeEditBox:GetText()
		use = 2
	elseif Frames[4].AddRaffleThirdPrizeEditBox:HasFocus() then
		ItemText = Frames[4].AddRaffleThirdPrizeEditBox:GetText()
		use = 3
	end
	if not textLeft then
		textLeft = setmetatable({}, { __index = function(t, i)
			local tooltipName = tooltip:GetName()
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			C_Timer.After(1, function(self) TooltipCheck = false end)
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for j = 2, tooltip:NumLines() do
		local text = textLeft[j]:GetText()
		if tonumber(text) ~= nil then
			local ItemName = select(1, GetItemInfo(text))
			local bindType = select(14, GetItemInfo(text))
			if ItemText ~= "" then
				if string.find(ItemText, ItemName) and bindType ~= 1 then
					continue = true
					ItemOkay = false
					break
				elseif string.find(ItemText, ItemName) and bindType == 1 then
					GLR_ItemStatus = false
					ItemOkay = false
					break
				end
			end
		else
			if text == "Soulbound" then
				continue = true
				ItemOkay = false
				break
			elseif text == "Blizzard Account Bound" then
				GLR_ItemStatus = false
				ItemOkay = false
				break
			end
		end
	end
	for j = 2, tooltip:NumLines() do
		local text = textLeft[j]:GetText()
		if continue or not GLR_ItemStatus or ItemOkay then
			if text then
				if (text == ITEM_SOULBOUND) or (text == ITEM_BIND_QUEST) or not GLR_ItemStatus then
					if use == 2 then
						Frames[4].AddRaffleSecondPrizeEditBox:SetText("")
					elseif use == 3 then
						Frames[4].AddRaffleThirdPrizeEditBox:SetText("")
					end
					C_Timer.After(1, function(self) TooltipCheck = false end)
					return
				elseif ItemOkay and ItemText ~= "" then
					if use == 2 then
						Frames[4].AddRaffleSecondPrizeEditBox:ClearFocus()
					elseif use == 3 then
						Frames[4].AddRaffleThirdPrizeEditBox:ClearFocus()
					end
					C_Timer.After(1, function(self) TooltipCheck = false end)
					return
				end
			end
		end
	end
end

local function CheckItemTooltip()
	local itemTooltips = {
		"GameTooltip",
	}
	for i, tooltip in pairs(itemTooltips) do
		tooltip = _G[tooltip]
		if tooltip then
			if not TooltipHook then
				if IsShiftKeyDown() then
					tooltip:HookScript("OnTooltipSetItem", function(self) IsItemSoulbound(tooltip) TooltipHook = true end)
				end
			end
			itemTooltips[i] = nil
		end
	end
end

local function AddRafflePrizesEditBoxTextChanged(box)
	
	if IsShiftKeyDown() then
		CheckItemTooltip()
	end
	
	if Frames[1].ConfirmAddRafflePrizesFrame:IsVisible() then
		Frames[1].ConfirmAddRafflePrizesFrame:Hide()
	end
	
	if box == "Second" then
		if Frames[4].AddRaffleSecondPrizeEditBox:GetText() ~= nil and Frames[4].AddRaffleSecondPrizeEditBox:GetText() ~= "" then
			if not Variables[20][4] and not Variables[20][1][1] then
				Frames[2].ConfirmRaffleSecondPrize:Show()
			else
				Frames[2].ConfirmRaffleSecondPrize:Hide()
			end
		else
			Variables[20][5][1] = false
		end
		if Frames[4].AddRaffleSecondPrizeEditBox:GetText() == "" then
			Frames[2].ConfirmRaffleSecondPrize:Hide()
		end
	end
	
	if box == "Third" then
		if Frames[4].AddRaffleThirdPrizeEditBox:GetText() ~= nil and Frames[4].AddRaffleThirdPrizeEditBox:GetText() ~= "" then
			if not Variables[20][4] and not Variables[20][1][2] then
				Frames[2].ConfirmRaffleThirdPrize:Show()
			else
				Frames[2].ConfirmRaffleThirdPrize:Hide()
			end
		else
			Variables[20][5][2] = false
		end
		if Frames[4].AddRaffleThirdPrizeEditBox:GetText() == "" then
			Frames[2].ConfirmRaffleThirdPrize:Hide()
		end
	end
	
end

Frames[1].AddRafflePrizes = CreateFrame("Frame", "Frames[1].AddRafflePrizes", UIParent, "BackdropTemplate")

Frames[1].AddRafflePrizes:SetPoint("CENTER", UIParent, "CENTER")
Frames[1].AddRafflePrizes:SetSize(340, 125)
Frames[1].AddRafflePrizes:SetFrameStrata("FULLSCREEN")
Frames[1].AddRafflePrizes:EnableMouse(true)
Frames[1].AddRafflePrizes:SetMovable(true)
Frames[1].AddRafflePrizes:SetUserPlaced(true)
Frames[1].AddRafflePrizes:SetResizable(false)
Frames[1].AddRafflePrizes:RegisterForDrag("LeftButton")
Frames[1].AddRafflePrizes:SetScript("OnDragStart", Frames[1].AddRafflePrizes.StartMoving)
Frames[1].AddRafflePrizes:SetScript("OnDragStop", Frames[1].AddRafflePrizes.StopMovingOrSizing)
Frames[1].AddRafflePrizes:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets,
})
Frames[1].AddRafflePrizes:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
Frames[1].AddRafflePrizes:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
Frames[1].AddRafflePrizes:SetScript("OnShow", function(self)
	Variables[20][1][1] = glrCharacter.Event.Raffle.SecondPlace
	Variables[20][1][2] = glrCharacter.Event.Raffle.ThirdPlace
	Variables[20][7] = false
	if Variables[20][1][1] == false then
		Frames[4].AddRaffleSecondPrizeEditBox:Enable()
	else
		Variables[20][6][1] = true
		if tonumber(Variables[20][1][1]) ~= nil then
			if tonumber(Variables[20][1][1]) > 9999999.9999 then
				Variables[20][10][1] = true
				Variables[20][11][1] = tonumber(Variables[20][1][1])
				Variables[20][1][1] = GLR_U:GetMoneyValue(9999999.9999, "Raffle", true, 1, "NA", true, true)
			end
		end
		Frames[4].AddRaffleSecondPrizeEditBox:SetText(Variables[20][1][1])
		Frames[4].AddRaffleSecondPrizeEditBox:Disable()
	end
	if Variables[20][1][2] == false then
		Frames[4].AddRaffleThirdPrizeEditBox:Enable()
	else
		Variables[20][6][2] = true
		if tonumber(Variables[20][1][2]) ~= nil then
			if tonumber(Variables[20][1][2]) > 9999999.9999 then
				Variables[20][10][2] = true
				Variables[20][11][2] = tonumber(Variables[20][1][2])
				Variables[20][1][2] = GLR_U:GetMoneyValue(9999999.9999, "Raffle", true, 1, "NA", true, true)
			end
		end
		Frames[4].AddRaffleThirdPrizeEditBox:SetText(Variables[20][1][2])
		Frames[4].AddRaffleThirdPrizeEditBox:Disable()
	end
end)
Frames[1].AddRafflePrizes:Hide()

Frames[5].AllowInvalidItemsCheckButton = CreateFrame("CheckButton", "Frames[5].AllowInvalidItemsCheckButton", Frames[1].AddRafflePrizes, "UICheckButtonTemplate")
Frames[5].AllowInvalidItemsCheckButton:SetPoint("BOTTOMLEFT", Frames[1].AddRafflePrizes, "BOTTOMLEFT", 15, 15)
Frames[5].AllowInvalidItemsCheckButton:SetSize(25, 25)
_G[Frames[5].AllowInvalidItemsCheckButton:GetName() .. "Text"]:SetText(L["Allow Invalid Item Check Button"])
_G[Frames[5].AllowInvalidItemsCheckButton:GetName() .. "Text"]:SetFont(GLR_UI.Font, 14)
Frames[5].AllowInvalidItemsCheckButton:EnableMouse(true)
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
Frames[5].AllowInvalidItemsCheckButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Allow Invalid Item Check Button Tooltip"])
	GameTooltip:Show()
end)
Frames[5].AllowInvalidItemsCheckButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

Frames[1].ConfirmAddRafflePrizesFrame = CreateFrame("Frame", "Frames[1].ConfirmAddRafflePrizesFrame", Frames[1].AddRafflePrizes, "BackdropTemplate")

Frames[1].ConfirmAddRafflePrizesFrame:SetPoint("TOP", Frames[1].AddRafflePrizes, "BOTTOM", 0, -10)
Frames[1].ConfirmAddRafflePrizesFrame:SetSize(130, 50)
Frames[1].ConfirmAddRafflePrizesFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets,
})
Frames[1].ConfirmAddRafflePrizesFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
Frames[1].ConfirmAddRafflePrizesFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
Frames[1].ConfirmAddRafflePrizesFrame:Hide()

Frames[2].AddRafflePrizesCloseButton = CreateFrame("Button", "Frames[2].AddRafflePrizesCloseButton", Frames[1].AddRafflePrizes, "UIPanelCloseButton")
Frames[2].AddRafflePrizesCloseButton:SetPoint("TOPRIGHT", Frames[1].AddRafflePrizes, "TOPRIGHT")

Frames[4].AddRaffleSecondPrizeEditBox = CreateFrame("EditBox", "Frames[4].AddRaffleSecondPrizeEditBox", Frames[1].AddRafflePrizes, "InputBoxTemplate")
Frames[4].AddRaffleSecondPrizeEditBox:SetPoint("RIGHT", Frames[1].AddRafflePrizes, "RIGHT", -75, 20)
Frames[4].AddRaffleSecondPrizeEditBox:SetSize(120, 25)
Frames[4].AddRaffleSecondPrizeEditBox:SetAutoFocus(false)

Frames[4].AddRaffleThirdPrizeEditBox = CreateFrame("EditBox", "Frames[4].AddRaffleThirdPrizeEditBox", Frames[1].AddRafflePrizes, "InputBoxTemplate")
Frames[4].AddRaffleThirdPrizeEditBox:SetPoint("TOP", Frames[4].AddRaffleSecondPrizeEditBox, "BOTTOM")
Frames[4].AddRaffleThirdPrizeEditBox:SetSize(120, 25)
Frames[4].AddRaffleThirdPrizeEditBox:SetAutoFocus(false)

GLR_GoToAddRafflePrizes = CreateFrame("Button", "GLR_GoToAddRafflePrizes", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "GameMenuButtonTemplate")
GLR_GoToAddRafflePrizes:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton, "BOTTOM", 0, -5)
GLR_GoToAddRafflePrizes:SetSize(100, 26)
GLR_GoToAddRafflePrizes:SetScript("OnClick", function(self)
	if glrCharacter.Event.Raffle.SecondPlace == false or glrCharacter.Event.Raffle.ThirdPlace == false then
		Frames[1].AddRafflePrizes:Show()
	else
		GLR:Print("Raffle Events can only have up to 3 prizes.")
	end
end)
GLR_GoToAddRafflePrizes:SetScript("OnEnter", function(self)
	local second = glrCharacter.Event.Raffle.SecondPlace
	local third = glrCharacter.Event.Raffle.ThirdPlace
	local count = 0
	if not second then count = count + 1 end
	if not third then count = count + 1 end
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine("Add Raffle Prizes")
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Number of Prize slots availabe: " .. count)
	GameTooltip:Show()
end)
GLR_GoToAddRafflePrizes:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
GLR_GoToAddRafflePrizes:SetScript("OnShow", function(self)
	if glrCharacter.Event.Raffle.SecondPlace == false or glrCharacter.Event.Raffle.ThirdPlace == false then
		if GLR_Global_Variables[1] and not GLR_Global_Variables[6][1] and not GLR_Global_Variables[6][2] then
			GLR_GoToAddRafflePrizes:Enable()
		else
			GLR_GoToAddRafflePrizes:Disable()
		end
	else
		GLR_GoToAddRafflePrizes:Disable()
	end
end)
GLR_GoToAddRafflePrizes:Disable()

GLR_GoToAddRafflePrizes.Backdrop = CreateFrame("Frame", "BackdropFrames.GLR_BeginLotteryButton", GLR_GoToAddRafflePrizes, "BackdropTemplate")
	GLR_GoToAddRafflePrizes.Backdrop:SetAllPoints()
	GLR_GoToAddRafflePrizes.Backdrop.backdropInfo = BackdropProfile.Buttons
	GLR_GoToAddRafflePrizes.Backdrop:ApplyBackdrop()
	GLR_GoToAddRafflePrizes.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


Frames[2].ConfirmRaffleSecondPrize = CreateFrame("Button", "Frames[2].ConfirmRaffleSecondPrize", Frames[1].AddRafflePrizes, "GameMenuButtonTemplate")
Frames[2].ConfirmRaffleSecondPrize:SetPoint("LEFT", Frames[4].AddRaffleSecondPrizeEditBox, "RIGHT", 5, 0)
Frames[2].ConfirmRaffleSecondPrize:SetSize(60, 25)
Frames[2].ConfirmRaffleSecondPrize:SetScript("OnClick", function(self)
	ConfirmAddNewPrizes("Second")
	if tonumber(Frames[4].AddRaffleSecondPrizeEditBox:GetText()) ~= nil then
		Frames[4].AddRaffleSecondPrizeEditBox:SetText(Variables[20][8][1])
		Frames[4].AddRaffleSecondPrizeEditBox:SetCursorPosition(0)
		if Frames[3].SecondPlaceStringOverFlow:GetText() == "*" then
			Variables[20][9][1] = true
		else
			Variables[20][9][1] = false
		end
	end
end)
Frames[2].ConfirmRaffleSecondPrize:Hide()

	Frames[2].ConfirmRaffleSecondPrize.Backdrop = CreateFrame("Frame", "Frames[2].ConfirmRaffleSecondPrize.Backdrop", Frames[2].ConfirmRaffleSecondPrize, "BackdropTemplate")
	Frames[2].ConfirmRaffleSecondPrize.Backdrop:SetAllPoints()
	Frames[2].ConfirmRaffleSecondPrize.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].ConfirmRaffleSecondPrize.Backdrop:ApplyBackdrop()
	Frames[2].ConfirmRaffleSecondPrize.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


Frames[2].ConfirmRaffleThirdPrize = CreateFrame("Button", "Frames[2].ConfirmRaffleThirdPrize", Frames[1].AddRafflePrizes, "GameMenuButtonTemplate")
Frames[2].ConfirmRaffleThirdPrize:SetPoint("LEFT", Frames[4].AddRaffleThirdPrizeEditBox, "RIGHT", 5, 0)
Frames[2].ConfirmRaffleThirdPrize:SetSize(60, 25)
Frames[2].ConfirmRaffleThirdPrize:SetScript("OnClick", function(self)
	ConfirmAddNewPrizes("Third")
	if tonumber(Frames[4].AddRaffleThirdPrizeEditBox:GetText()) ~= nil then
		Frames[4].AddRaffleThirdPrizeEditBox:SetText(Variables[20][8][2])
		Frames[4].AddRaffleThirdPrizeEditBox:SetCursorPosition(0)
		if Frames[3].ThirdPlaceStringOverFlow:GetText() == "*" then
			Variables[20][9][2] = true
		else
			Variables[20][9][2] = false
		end
	end
end)
Frames[2].ConfirmRaffleThirdPrize:Hide()

	Frames[2].ConfirmRaffleThirdPrize.Backdrop = CreateFrame("Frame", "Frames[2].ConfirmRaffleThirdPrize.Backdrop", Frames[2].ConfirmRaffleThirdPrize, "BackdropTemplate")
	Frames[2].ConfirmRaffleThirdPrize.Backdrop:SetAllPoints()
	Frames[2].ConfirmRaffleThirdPrize.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].ConfirmRaffleThirdPrize.Backdrop:ApplyBackdrop()
	Frames[2].ConfirmRaffleThirdPrize.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


Frames[2].ConfirmAddRafflePrizes = CreateFrame("Button", "Frames[2].ConfirmAddRafflePrizes", Frames[1].AddRafflePrizes, "GameMenuButtonTemplate")
Frames[2].ConfirmAddRafflePrizes:SetPoint("BOTTOMRIGHT", Frames[1].AddRafflePrizes, "BOTTOMRIGHT", -15, 15)
Frames[2].ConfirmAddRafflePrizes:SetSize(100, 26)
Frames[2].ConfirmAddRafflePrizes:SetScript("OnClick", function(self)
	if Variables[20][5][1] or Variables[20][5][2] then
		Frames[3].InvalidItemText:SetText("")
		Frames[1].ConfirmAddRafflePrizesFrame:Show()
	else
		if Frames[1].ConfirmAddRafflePrizesFrame:IsVisible() then
			Frames[1].ConfirmAddRafflePrizesFrame:Hide()
		end
		Frames[3].InvalidItemText:SetText("No New Prizes Detected")
	end
end)
Frames[2].ConfirmAddRafflePrizes:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine("You will be asked to confirm the changes")
	GameTooltip:Show()
end)
Frames[2].ConfirmAddRafflePrizes:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

	Frames[2].ConfirmAddRafflePrizes.Backdrop = CreateFrame("Frame", "Frames[2].ConfirmAddRafflePrizes.Backdrop", Frames[2].ConfirmAddRafflePrizes, "BackdropTemplate")
	Frames[2].ConfirmAddRafflePrizes.Backdrop:SetAllPoints()
	Frames[2].ConfirmAddRafflePrizes.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].ConfirmAddRafflePrizes.Backdrop:ApplyBackdrop()
	Frames[2].ConfirmAddRafflePrizes.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


Frames[2].CheckConfirmAddRafflePrizes = CreateFrame("Button", "Frames[2].CheckConfirmAddRafflePrizes", Frames[1].ConfirmAddRafflePrizesFrame, "GameMenuButtonTemplate")
Frames[2].CheckConfirmAddRafflePrizes:SetPoint("CENTER", Frames[1].ConfirmAddRafflePrizesFrame)
Frames[2].CheckConfirmAddRafflePrizes:SetSize(100, 26)
Frames[2].CheckConfirmAddRafflePrizes:SetScript("OnClick", function(self)
	local continue = true
	if not Variables[20][5][1] and not Variables[20][5][2] then
		continue = false
	end
	if continue then
		local second = ""
		local third = ""
		local doSecond = false
		local doThird = false
		if not Variables[20][1][1] then
			if Variables[20][5][1] then
				Variables[20][6][1] = true
				glrCharacter.Event.Raffle.SecondPlace = Variables[20][2][2]
				second = Variables[20][2][2]
			end
		end
		if not Variables[20][1][2] then
			if Variables[20][5][2] then
				Variables[20][6][2] = true
				glrCharacter.Event.Raffle.ThirdPlace = Variables[20][3][2]
				third = Variables[20][3][2]
			end
		end
		if Variables[20][5][1] and Variables[20][5][2] then
			Variables[20][7] = true
		end
		GLR_U:UpdateInfo(false)
		SendChatMessage("--------------------------------------------------", "GUILD")
		local timer = 1
		C_Timer.After(timer, function(self) SendChatMessage("GLR: New Raffle Prizes have been added!", "GUILD") end)
		timer = timer + 0.3
		if Variables[20][5][1] then
			if tonumber(second) ~= nil then
				second = GLR_U:GetMoneyValue(tonumber(second), "Raffle", false, 1, "NA", true, false)
			elseif second == "%raffle_total" then
				second = "Total Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif second == "%raffle_half" then
				second = "Half of Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif second == "%raffle_quarter" then
				second = "Quarter of Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			end
			--local length = string.len("GLR: New Second Place Prize: " .. second)
			if string.len("GLR: New Second Place Prize: " .. second) <= 255 then
				C_Timer.After(timer, function(self) SendChatMessage("GLR: New Second Place Prize: " .. second, "GUILD") end)
			else
				C_Timer.After(timer, function(self) SendChatMessage("GLR: New Second Place Prize:", "GUILD") end)
				timer = timer + 0.3
				C_Timer.After(timer, function(self) SendChatMessage(second, "GUILD") end)
			end
			timer = timer + 0.3
		end
		if Variables[20][5][2] then
			if tonumber(third) ~= nil then
				third = GLR_U:GetMoneyValue(tonumber(third), "Raffle", false, 1, "NA", true, false)
			elseif third == "%raffle_total" then
				third = "Total Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif third == "%raffle_half" then
				third = "Half of Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif third == "%raffle_quarter" then
				third = "Quarter of Ticket Sales Value. Current Prize Value: " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			end
			if string.len("GLR: New Second Place Prize: " .. third) <= 255 then
				C_Timer.After(timer, function(self) SendChatMessage("GLR: New Third Place Prize: " .. third, "GUILD") end)
			else
				C_Timer.After(timer, function(self) SendChatMessage("GLR: New Third Place Prize:", "GUILD") end)
				timer = timer + 0.3
				C_Timer.After(timer, function(self) SendChatMessage(third, "GUILD") end)
			end
		end
		if Variables[20][6][1] and Variables[20][6][2] then
			Variables[20][7] = true
		end
		Frames[5].AllowInvalidItemsCheckButton:SetChecked(false)
		Frames[1].AddRafflePrizes:Hide()
	else
		Frames[3].InvalidItemText:SetText("No New Prizes Detected")
		Frames[1].ConfirmAddRafflePrizesFrame:Hide()
	end
end)
Frames[2].CheckConfirmAddRafflePrizes:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine("Confirm Add New Raffle Prizes")
	if Variables[20][5][1] then
		GameTooltip:AddLine(" ")
		local second = Variables[20][2][2]
		if second ~= nil and second ~= "" then
			if second == "%raffle_total" then
				second = "Total Ticket Sales Value"
			elseif second == "%raffle_half" then
				second = "Half of Ticket Sales Value"
			elseif second == "%raffle_quarter" then
				second = "Quarter of Ticket Sales Value"
			elseif tonumber(second) ~= nil then
				if Variables[20][9][1] then
					second = GLR_U:GetMoneyValue(tonumber(Variables[20][2][2]), "Raffle", false, 1, "NA", true, true, true)
				else
					second = GLR_U:GetMoneyValue(tonumber(second), "Raffle", false, 1, "NA", true, true, true)
				end
			end
			GameTooltip:AddLine("2nd Place: " .. second)
		end
	end
	if Variables[20][5][2] then
		if not Variables[20][5][1] then
			GameTooltip:AddLine(" ")
		end
		local third = Variables[20][3][2]
		if third ~= nil and third ~= "" then
			if third == "%raffle_total" then
				third = "Total Ticket Sales Value"
			elseif third == "%raffle_half" then
				third = "Half of Ticket Sales Value"
			elseif third == "%raffle_quarter" then
				third = "Quarter of Ticket Sales Value"
			elseif tonumber(third) ~= nil then
				if Variables[20][9][2] then
					third = GLR_U:GetMoneyValue(tonumber(Variables[20][3][2]), "Raffle", false, 1, "NA", true, true, true)
				else
					third = GLR_U:GetMoneyValue(tonumber(third), "Raffle", false, 1, "NA", true, true, true)
				end
			end
			GameTooltip:AddLine("3rd Place: " .. third)
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("WARNING: This action can't be undone.", 1, 0, 0, 1)
	GameTooltip:Show()
	if not Variables[20][5][1] and not Variables[20][5][2] then
		Frames[3].InvalidItemText:SetText("No New Prizes Detected")
		GameTooltip:Hide()
		Frames[1].ConfirmAddRafflePrizesFrame:Hide()
	end
end)
Frames[2].CheckConfirmAddRafflePrizes:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

	Frames[2].CheckConfirmAddRafflePrizes.Backdrop = CreateFrame("Frame", "Frames[2].CheckConfirmAddRafflePrizes.Backdrop", Frames[2].CheckConfirmAddRafflePrizes, "BackdropTemplate")
	Frames[2].CheckConfirmAddRafflePrizes.Backdrop:SetAllPoints()
	Frames[2].CheckConfirmAddRafflePrizes.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].CheckConfirmAddRafflePrizes.Backdrop:ApplyBackdrop()
	Frames[2].CheckConfirmAddRafflePrizes.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


Frames[3].CheckConfirmAddRafflePrizesText = Frames[2].CheckConfirmAddRafflePrizes:CreateFontString("ConfirmYesText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].CheckConfirmAddRafflePrizesText:SetPoint("CENTER", Frames[2].CheckConfirmAddRafflePrizes)
Frames[3].CheckConfirmAddRafflePrizesText:SetText(L["Confirm Action Button"])
Frames[3].CheckConfirmAddRafflePrizesText:SetFont(GLR_UI.ButtonFont, 11)

Frames[3].AddRafflePrizesTitleText = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].AddRafflePrizesTitleText", "OVERLAY", "GameFontNormalSmall")
Frames[3].AddRafflePrizesTitleText:SetPoint("TOP", Frames[1].AddRafflePrizes, "TOP", 0, -10)
Frames[3].AddRafflePrizesTitleText:SetText("Add Raffle Prizes")
Frames[3].AddRafflePrizesTitleText:SetFont(GLR_UI.Font, 12)

Frames[3].GoToAddRafflePrizesText = GLR_GoToAddRafflePrizes:CreateFontString("Frames[3].GoToAddRafflePrizesText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].GoToAddRafflePrizesText:SetPoint("CENTER", GLR_GoToAddRafflePrizes)
Frames[3].GoToAddRafflePrizesText:SetText("Add Prizes")
Frames[3].GoToAddRafflePrizesText:SetFont(GLR_UI.ButtonFont, 11)

Frames[3].ConfirmAddRafflePrizesText = Frames[2].ConfirmAddRafflePrizes:CreateFontString("Frames[3].ConfirmAddRafflePrizesText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].ConfirmAddRafflePrizesText:SetPoint("CENTER", Frames[2].ConfirmAddRafflePrizes)
Frames[3].ConfirmAddRafflePrizesText:SetText("Okay")
Frames[3].ConfirmAddRafflePrizesText:SetFont(GLR_UI.ButtonFont, 11)

Frames[3].AddRaffleSecondPrizeText = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].AddRaffleSecondPrizeText", "OVERLAY", "GameFontNormalSmall")
Frames[3].AddRaffleSecondPrizeText:SetPoint("RIGHT", Frames[4].AddRaffleSecondPrizeEditBox, "LEFT", -15, 0)
Frames[3].AddRaffleSecondPrizeText:SetText(L["Set Second Place"] .. ":")
Frames[3].AddRaffleSecondPrizeText:SetFont(GLR_UI.Font, 14)

Frames[3].AddRaffleThirdPrizeText = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].AddRaffleThirdPrizeText", "OVERLAY", "GameFontNormalSmall")
Frames[3].AddRaffleThirdPrizeText:SetPoint("RIGHT", Frames[4].AddRaffleThirdPrizeEditBox, "LEFT", -15, 0)
Frames[3].AddRaffleThirdPrizeText:SetText(L["Set Third Place"] .. ":")
Frames[3].AddRaffleThirdPrizeText:SetFont(GLR_UI.Font, 14)

Frames[3].ConfirmRaffleSecondPrizeText = Frames[2].ConfirmRaffleSecondPrize:CreateFontString("Frames[3].ConfirmRaffleSecondPrizeText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].ConfirmRaffleSecondPrizeText:SetPoint("CENTER", Frames[2].ConfirmRaffleSecondPrize)
Frames[3].ConfirmRaffleSecondPrizeText:SetText(L["Confirm Add Raffle Item"])
Frames[3].ConfirmRaffleSecondPrizeText:SetFont(GLR_UI.ButtonFont, 11)

Frames[3].ConfirmRaffleThirdPrizeText = Frames[2].ConfirmRaffleThirdPrize:CreateFontString("Frames[3].ConfirmRaffleThirdPrizeText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].ConfirmRaffleThirdPrizeText:SetPoint("CENTER", Frames[2].ConfirmRaffleThirdPrize)
Frames[3].ConfirmRaffleThirdPrizeText:SetText(L["Confirm Add Raffle Item"])
Frames[3].ConfirmRaffleThirdPrizeText:SetFont(GLR_UI.ButtonFont, 11)

Frames[3].InvalidItemText = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].InvalidItemText", "OVERLAY", "GameFontNormalSmall")
Frames[3].InvalidItemText:SetPoint("TOP", Frames[1].AddRafflePrizes, "BOTTOM", 0, -5)
Frames[3].InvalidItemText:SetText("")
Frames[3].InvalidItemText:SetFont(GLR_UI.ButtonFont, 14)
Frames[3].InvalidItemText:SetTextColor(1, 0, 0, 1)

Frames[3].SecondPlaceStringOverFlow = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].SecondPlaceStringOverFlow", "OVERLAY", "GameFontNormalSmall")
Frames[3].SecondPlaceStringOverFlow:SetPoint("TOPLEFT", Frames[4].AddRaffleSecondPrizeEditBox, "TOPRIGHT", 0, 0)
Frames[3].SecondPlaceStringOverFlow:SetText("")
Frames[3].SecondPlaceStringOverFlow:SetFont(GLR_UI.ButtonFont, 14)
Frames[3].SecondPlaceStringOverFlow:SetTextColor(1, 0, 0, 1)

Frames[3].ThirdPlaceStringOverFlow = Frames[1].AddRafflePrizes:CreateFontString("Frames[3].ThirdPlaceStringOverFlow", "OVERLAY", "GameFontNormalSmall")
Frames[3].ThirdPlaceStringOverFlow:SetPoint("TOPLEFT", Frames[4].AddRaffleThirdPrizeEditBox, "TOPRIGHT", 0, 0)
Frames[3].ThirdPlaceStringOverFlow:SetText("")
Frames[3].ThirdPlaceStringOverFlow:SetFont(GLR_UI.ButtonFont, 14)
Frames[3].ThirdPlaceStringOverFlow:SetTextColor(1, 0, 0, 1)

---------------------------
------- ADD RAFFLE --------
---- PRIZE BOX SCRIPTS ----
---------------------------
Frames[4].AddRaffleSecondPrizeEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" then
		--Frames[4].AddRaffleSecondPrizeEditBox:SetCursorPosition(0)
		Frames[4].AddRaffleSecondPrizeEditBox:ClearFocus()
		Frames[4].AddRaffleThirdPrizeEditBox:SetFocus()
	elseif key == "ESCAPE" then
		--Frames[4].AddRaffleSecondPrizeEditBox:SetCursorPosition(0)
		Frames[4].AddRaffleSecondPrizeEditBox:ClearFocus()
	end
end)
Frames[4].AddRaffleSecondPrizeEditBox:SetScript("OnTextChanged", function(self)
	AddRafflePrizesEditBoxTextChanged("Second")
end)
Frames[4].AddRaffleSecondPrizeEditBox:SetScript("OnEditFocusGained", function(self)
	self:HighlightText(0, -1)
end)
Frames[4].AddRaffleSecondPrizeEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	if Variables[20][1][1] == false then
		GameTooltip:AddLine(L["Set Raffle Prize"])
		GameTooltip:AddLine(L["Set Raffle Second Place Prize P1"])
		GameTooltip:AddLine(" ")
		if Variables[20][9][1] then
			GameTooltip:AddLine("Maximum Displayed Value Reached.")
			GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(tonumber(Variables[20][2][2]), "Raffle", false, 1, "NA", true, true, true))
			GameTooltip:AddLine(" ")
		end
		GameTooltip:AddLine("Leave blank to not add a Second Place Prize.", 1, 0, 0, 1)
	else
		GameTooltip:AddLine("A Second Place Prize already exists.")
		if Variables[20][10][1] then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Current Second Place Prize Value: " .. GLR_U:GetMoneyValue(Variables[20][11][1], "Raffle", false, 1, "NA", true, true, true))
		end
	end
	GameTooltip:Show()
end)
Frames[4].AddRaffleSecondPrizeEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

Frames[4].AddRaffleThirdPrizeEditBox:SetScript("OnKeyDown", function(_, key)
	if key == "ENTER" or key == "TAB" or key == "ESCAPE" then
		Frames[4].AddRaffleThirdPrizeEditBox:SetCursorPosition(0)
		Frames[4].AddRaffleThirdPrizeEditBox:ClearFocus()
	end
end)
Frames[4].AddRaffleThirdPrizeEditBox:SetScript("OnTextChanged", function(self)
	AddRafflePrizesEditBoxTextChanged("Third")
end)
Frames[4].AddRaffleThirdPrizeEditBox:SetScript("OnEditFocusGained", function(self)
	self:HighlightText(0, -1)
end)
Frames[4].AddRaffleThirdPrizeEditBox:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	if Variables[20][1][2] == false then
		GameTooltip:AddLine(L["Set Raffle Prize"])
		GameTooltip:AddLine(L["Set Raffle Third Place Prize P1"])
		GameTooltip:AddLine(" ")
		if Variables[20][9][2] then
			GameTooltip:AddLine("Maximum Displayed Value Reached.")
			GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(tonumber(Variables[20][3][2]), "Raffle", false, 1, "NA", true, true, true))
			GameTooltip:AddLine(" ")
		end
		GameTooltip:AddLine("Leave blank to not add a Third Place Prize.", 1, 0, 0, 1)
	else
		GameTooltip:AddLine("A Third Place Prize already exists.")
		if Variables[20][10][2] then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Current Third Place Prize Value: " .. GLR_U:GetMoneyValue(Variables[20][11][2], "Raffle", false, 1, "NA", true, true, true))
		end
	end
	GameTooltip:Show()
end)
Frames[4].AddRaffleThirdPrizeEditBox:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

Frames[1].AddRafflePrizes:SetScript("OnHide", function(self)
	if Variables[20][7] then
		GLR_GoToAddRafflePrizes:Disable()
	end
	Variables[20][5][1] = false
	Variables[20][5][2] = false
	Frames[4].AddRaffleSecondPrizeEditBox:SetText("")
	Frames[4].AddRaffleThirdPrizeEditBox:SetText("")
	Frames[1].ConfirmAddRafflePrizesFrame:Hide()
end)
function GLR_D:ToggleEscapeKey()
	local status = glrCharacter.Data.Settings.General.ToggleEscape
	if status then
		Frames[1].AddRafflePrizes:SetScript("OnKeyDown", function(_, key)
			Frames[1].AddRafflePrizes:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				Frames[1].AddRafflePrizes:SetPropagateKeyboardInput(false)
				Frames[1].AddRafflePrizes:Hide()
			end
		end)
	else
		Frames[1].AddRafflePrizes:SetScript("OnKeyDown", function(_, key)
			Frames[1].AddRafflePrizes:SetPropagateKeyboardInput(true)
			if key == "ESCAPE" then
				Frames[1].AddRafflePrizes:SetPropagateKeyboardInput(true)
			end
		end)
	end
end

--Main UI Scripts
GLR_UI.GLR_MainFrame:SetScript("OnHide", function(self)
	GLR_UI.GLR_NewLotteryEventFrame:Hide()
	GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	GLR_UI.GLR_DonationFrame:Hide()
	Frames[1].AddRafflePrizes:Hide()
end)
GLR_UI.GLR_MainFrame.GLR_LotteryFrame:SetScript("OnShow", function(self)
	if GLR_Global_Variables[6][1] or GLR_Global_Variables[6][2] then
		if not GLR_Global_Variables[3] then
			GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Show()
		end
	end
	Frames[1].AddRafflePrizes:Hide()
end)
GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:SetScript("OnClick", function(self)
	if GLR_UI.GLR_AddPlayerToRaffleFrame:IsVisible() then
		GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	end
	if GLR_UI.GLR_EditPlayerInRaffleFrame:IsVisible() then
		GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
	end
	if Frames[1].AddRafflePrizes:IsVisible() then
		Frames[1].AddRafflePrizes:Hide()
	end
	if GLR_UI.GLR_NewRaffleEventFrame:IsVisible() == false then
		--Quick and dirty way to get font strings to show completely
		GLR_UI.GLR_NewRaffleEventFrame:Show()
		GLR_UI.GLR_NewRaffleEventFrame:Hide()
		GLR_UI.GLR_NewRaffleEventFrame:Show()
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GLR_NewRaffleEventFrame() - Showing New Raffle Event Frame")
	end
end)

---------------------------------
------- GENERATE TICKETS --------
------ FOR ADVANCED EVENTS ------
---------------------------------

	Frames[1].StatusBarFrame = CreateFrame("Frame", "Frames[1].StatusBarFrame", GLR_UI.GLR_MainFrame, "BackdropTemplate")

Frames[1].StatusBarFrame:SetPoint("TOP", GLR_UI.GLR_MainFrame, "BOTTOM", 0, -5)
Frames[1].StatusBarFrame:SetSize(280, 75)
Frames[1].StatusBarFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets,
})
Frames[1].StatusBarFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
Frames[1].StatusBarFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
Frames[1].StatusBarFrame:Hide()

local statusbar = CreateFrame("StatusBar", nil, Frames[1].StatusBarFrame)
statusbar:SetPoint("BOTTOM", Frames[1].StatusBarFrame, "BOTTOM", 0, 15)
statusbar:SetWidth(200)
statusbar:SetHeight(19)
statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar:GetStatusBarTexture():SetHorizTile(false)
statusbar:GetStatusBarTexture():SetVertTile(false)
statusbar:SetStatusBarColor(0, 0, 1)
statusbar:SetMinMaxValues(0, 0)
statusbar:SetValue(0)
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
statusbar_value:SetPoint("CENTER", statusbar, "CENTER", 0, 2)
statusbar_value:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
statusbar_value:SetJustifyH("LEFT")
statusbar_value:SetShadowOffset(1, -1)
statusbar_value:SetTextColor(0, 1, 0)
statusbar_value:SetText(statusbar:GetValue() .. "%")

local statusbar_text = statusbar:CreateFontString(nil, "OVERLAY")
statusbar_text:SetPoint("BOTTOM", statusbar, "TOP", 0, 13)
statusbar_text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
statusbar_text:SetJustifyH("LEFT")
statusbar_text:SetShadowOffset(1, -1)
statusbar_text:SetTextColor(1, 1, 1)
statusbar_text:SetText("Generating Tickets: ")

local statusbar_progressText = statusbar:CreateFontString(nil, "OVERLAY")
statusbar_progressText:SetPoint("LEFT", statusbar_text, "RIGHT", 1, 0) --statusbar_value
statusbar_progressText:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
statusbar_progressText:SetJustifyH("LEFT")
statusbar_progressText:SetShadowOffset(1, -1)
statusbar_progressText:SetTextColor(1, 1, 1)
statusbar_progressText:SetText("")


---------------------------------
---------------------------------
---------------------------------

local raffleTicketNumbersTable = {}
local raffleWinners = {}
local locale = GetLocale()
local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
RandomizationTable = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, }
local EventTickets = {}

local function AbortRollProcess(state, complete, abort)
	if abort == nil then abort = true end
	if complete == nil then complete = false end
	RandomizationTable = nil
	RandomizationTable = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, }
	glrCharacter.Data.Settings.General.AnnounceAutoAbort = false
	GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:Enable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:Enable()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:Enable()
	glrCharacter.Data.Settings.Lottery.RollOverCheck = false
	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	GLR_GoToAddRafflePrizes:Show()
	if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		GLR_UI.GLR_ScanMailButton:Enable()
		if glrCharacter.Data.Settings.CurrentlyActiveLottery then
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Enable()
		end
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
			GLR_GoToAddRafflePrizes:Enable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Enable()
		end
	end
	if state == "Lottery" then
		if Frames[1].StatusBarFrame:IsVisible() then
			Frames[1].StatusBarFrame:Hide()
		end
		if not complete then
			-- Re-adds players which had ZERO Tickets when the Draw commenced.
			for i = 1, #Variables[21][state] do
				glrCharacter[state].Entries.TicketNumbers[Variables[21][state][i]] = {}
				glrCharacter[state].Entries.TicketRange[Variables[21][state][i]] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0, }
				glrCharacter[state].Entries.Tickets[Variables[21][state][i]] = { ["Given"] = 0, ["Sold"] = 0, ["NumberOfTickets"] = 0, }
				table.insert(glrCharacter[state].Entries.Names, Variables[21][state][i])
			end
			GLR:UpdatePlayersAndTotalTickets()
		end
		GLR_Global_Variables[6][1] = false
	elseif state == "Raffle" then
		GLR_Global_Variables[6][2] = false
	end
	if abort then
		if Variables[23] then
			SendChatMessage(L["Abort Roll Message"], "GUILD")
		else
			GLR:Print(L["Automatic Abort Roll Message"])
		end
	end
end

local function GenerateTicket(firstTicket, lastTicket, state)
	local fT = tonumber(firstTicket)
	local lT = tonumber(lastTicket)
	local ticketNumber = tostring(math.random(fT, lT))
	local ta = {}
	local breakOut = false
	local doBreak = false
	local taCount = 0
	local count = lT * 20
	if glrCharacter[state].TicketPool ~= nil then
		for t, v in pairs(glrCharacter[state].TicketPool) do
			table.insert(ta, v)
			taCount = taCount + 1
		end
	end
	for i = 1, count do
		for j = 1, #ta do
			if ta[j] == ticketNumber then
				ticketNumber = tostring(math.random(fT, lT))
			end
		end
		for v = 1, #ta do
			if ta[v] ~= ticketNumber then
				doBreak = true
			elseif ta[v] == ticketNumber then
				doBreak = false
				ticketNumber = tostring(math.random(fT, lT))
			end
			if doBreak then
				break
			end
		end
		if taCount == 0 then
			doBreak = true
		end
		if doBreak then
			breakOut = true
			break
		end
	end
	if breakOut then
		return ticketNumber
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
GLR_Drag = {}
local function FindNumberRange(name)
	local low = nil
	local high = nil
	for i = 1, #RandomizationTable[4][name] do
		local check = tonumber(RandomizationTable[4][name][i])
		if low == nil then low = check end
		if high == nil then high = check end
		if i > 1 then
			if low > check then
				if high <= low then
					high = low
				end
				low = check
			elseif high < check then
				high = check
			end
		end
	end
	return tostring(low), tostring(high)
end

local function PrepareNextLottery()
	
	if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
		for t, v in pairs(RandomizationTable[4]) do --Transfers the randomly given ticket numbers from memory to the save data file.
			local low, high = FindNumberRange(t)
			if GLR_Drag[t] == nil then GLR_Drag[t] = { ["Low"] = low, ["High"] = high, } end
			glrCharacter.Lottery.Entries.TicketRange[t].LowestTicketNumber = low
			glrCharacter.Lottery.Entries.TicketRange[t].HighestTicketNumber = high
		end
	end
	
	local text = date()
	local EventStatus = false
	local transfer = { ["Winner"] = Variables[6][1], ["WinnerName"] = Variables[6][2] }
	
	local timestamp = GetTimeStamp()
	local place = "NONE"
	if Variables[12][1] then
		place = "FIRST"
	elseif Variables[12][2] then
		place = "SECOND"
	end
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - PrepareNextLottery() - Winning Ticket: [" .. Variables[6][1] .. "] - Winner's Name: [" .. Variables[6][2] .. "] - Place: [" .. place .. "]" )
	
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then --Checks if a Raffle is currently Active before confirming that both Lottery/Raffle's are inactive, allowing you to change Multi-Guild status on your character (assuming no other events are active on other characters)
		EventStatus = true
	end
	
	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	
	if not Variables[11] then
		glrCharacter.Data.Settings.PreviousLottery.TicketsSold = glrCharacter.Event.Lottery.TicketsSold
		glrCharacter.Data.Settings.PreviousLottery.TicketPrice = tonumber(glrCharacter.Event.Lottery.TicketPrice)
		glrCharacter.Data.Settings.PreviousLottery.Jackpot = tonumber(Variables[13][1])
	elseif Variables[11] then
		glrCharacter.Data.Settings.PreviousLottery.TicketsSold = 0
		glrCharacter.Data.Settings.PreviousLottery.TicketPrice = 0
		glrCharacter.Data.Settings.PreviousLottery.Jackpot = 0
	end
	
	if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
		glrCharacter.Data.Defaults.LotteryDate = FormatNumber(date("*t",  GetServerTime()).day) .. Variables[25][date("*t",  GetServerTime()).day] .. " of " .. Variables[24][date("*t",  GetServerTime()).month] .. ", " .. date("*t",  GetServerTime()).year
	else
		glrCharacter.Data.Defaults.LotteryDate = Variables[24][date("*t",  GetServerTime()).month] .. " " .. FormatNumber(date("*t",  GetServerTime()).day) .. Variables[25][date("*t",  GetServerTime()).day] .. ", " .. date("*t",  GetServerTime()).year
	end
	
	local startingGold = GLR_U:GetMoneyValue(glrCharacter.Data.Settings.PreviousLottery.Jackpot, "Lottery", true, 1, "NA", true, true)
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
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("0")
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("0")
	
	for t, v in pairs(glrCharacter.Lottery) do
		if transfer[t] == nil then
			transfer[t] = {}
		end
		for key, val in pairs(glrCharacter.Lottery[t]) do
			if transfer[t][key] == nil then
				transfer[t][key] = {}
			end
			if tostring(key) == "TicketNumbers" then
				for k, v in pairs(glrCharacter.Lottery[t][key]) do
					if transfer[t][key][k] == nil then
						transfer[t][key][k] = {}
					end
				end
			else
				transfer[t][key] = glrCharacter.Lottery[t][key]
			end
		end
	end
	
	glrCharacter.PreviousEvent.Lottery.Data = transfer
	glrCharacter.PreviousEvent.Lottery.Settings = glrCharacter.Event.Lottery
	glrCharacter.PreviousEvent.Lottery.Settings.RoundValue = glrCharacter.Data.Settings.Lottery.RoundValue
	glrCharacter.PreviousEvent.Lottery.Settings.WonType = { [1] = Variables[12][1], [2] = Variables[12][2], }
	glrCharacter.PreviousEvent.Lottery.Settings.NoGuildCut = glrCharacter.Data.Settings.Lottery.NoGuildCut
	glrCharacter.PreviousEvent.Lottery.Settings.WinChanceKey = glrCharacter.Data.Settings.Lottery.WinChanceKey
	glrCharacter.PreviousEvent.Lottery.Available = true
	
	if glrCharacter.Data.Settings.Lottery.CarryOver and not Variables[12][1] and not Variables[12][2] then
		glrCharacter.Data.RollOver.Lottery.Names = glrCharacter.PreviousEvent.Lottery.Data.Entries.Names
		for i = 1, #glrCharacter.PreviousEvent.Lottery.Data.Entries.Names do
			glrCharacter.Data.RollOver.Lottery.Check[glrCharacter.PreviousEvent.Lottery.Data.Entries.Names[i]] = true
		end
	else
		glrCharacter.Data.RollOver.Lottery.Names = {}
		glrCharacter.Data.RollOver.Lottery.Check = {}
	end
	
	glrCharacter.Event.Lottery = nil
	glrCharacter.Event.Lottery = {}
	
	glrCharacter.Lottery.TicketPool = nil
	glrCharacter.Lottery.TicketPool = {}
	
	glrCharacter.Lottery.Entries.TicketRange = nil
	glrCharacter.Lottery.Entries.TicketRange = {}
	
	glrCharacter.Lottery.Entries.TicketNumbers = nil
	glrCharacter.Lottery.Entries.TicketNumbers = {}
	
	glrCharacter.Lottery.Entries.Tickets = nil
	glrCharacter.Lottery.Entries.Tickets = {}
	
	glrCharacter.Lottery.Entries.Names = nil
	glrCharacter.Lottery.Entries.Names = {}
	
	glrCharacter.Lottery.MessageStatus = nil
	glrCharacter.Lottery.MessageStatus = {}
	
	glrTemp.Lottery = nil
	glrTemp.Lottery = {}
	
	glrTempStatus = nil
	glrTempStatus = {}
	
	if glrHistory.ActiveEvents == nil then
		glrHistory.ActiveEvents = {}
	end
	
	if glrHistory.ActiveEvents[FullPlayerName] == nil then
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	else
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	end
	
	if GLR_UI.GLR_MainFrame:IsVisible() then
		GLR:UpdatePlayersAndTotalTickets()
		GLR:UpdateNumberOfUnusedTickets()
	end
	
	glrCharacter.Data.Settings.CurrentlyActiveLottery = false
	GLR_Global_Variables[2] = true
	C_Timer.After(5, function(self) GLR_U:UpdateInfo() end)
	
	GLR_Global_Variables[6][1] = false
	
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
	
	Variables[18] = false
	
	if not Variables[19] then
		glrCharacter.Data.Settings.Lottery.RollOverCheck = false
		if not Variables[14] then
			SendChatMessage(L["Lottery Draw Complete"], "GUILD")
		else
			SendChatMessage(L["Advanced Lottery Draw Complete"], "GUILD")
		end
		--To re-enable the buttons disabled during Event Draw
		C_Timer.After(5, function(self) AbortRollProcess("Lottery", true, false) end)
		Variables[19] = true
	end
	
end

local function PrepareNextRaffle()
	
	if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
		for t, v in pairs(RandomizationTable[4]) do --Transfers the randomly given ticket numbers from memory to the save data file.
			local low, high = FindNumberRange(t)
			glrCharacter.Raffle.Entries.TicketRange[t].LowestTicketNumber = low
			glrCharacter.Raffle.Entries.TicketRange[t].HighestTicketNumber = high
		end
	end
	
	local EventStatus = false
	local transfer = { ["FirstWinner"] = Variables[5][1], ["SecondWinner"] = Variables[5][2], ["ThirdWinner"] = Variables[5][3], ["FirstName"] = Variables[4][1], ["SecondName"] = Variables[4][2], ["ThirdName"] = Variables[4][3] }
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - PrepareNextRaffle() - Winning Ticket(s); FIRST [" .. Variables[5][1] .. "]; SECOND [" .. Variables[5][2] .. "]; THIRD [" .. Variables[5][3] .. "]" )
	
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then --Checks if a Raffle is currently Active before confirming that both Lottery/Raffle's are inactive, allowing you to change Multi-Guild status on your character (assuming no other events are active on other characters)
		EventStatus = true
	end
	
	GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Hide()
	
	if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
		glrCharacter.Data.Defaults.LotteryDate = FormatNumber(date("*t",  GetServerTime()).day) .. Variables[25][date("*t",  GetServerTime()).day] .. " of " .. Variables[24][date("*t",  GetServerTime()).month] .. ", " .. date("*t",  GetServerTime()).year
	else
		glrCharacter.Data.Defaults.LotteryDate = Variables[24][date("*t",  GetServerTime()).month] .. " " .. FormatNumber(date("*t",  GetServerTime()).day) .. Variables[25][date("*t",  GetServerTime()).day] .. ", " .. date("*t",  GetServerTime()).year
	end
	
	GLR_UI.GLR_RaffleInfo.GLR_RaffleDateEditBox:SetText("")
	GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetText(L["No Raffle Active"])
	GLR_UI.GLR_RaffleInfo.GLR_RaffleNameEditBox:SetCursorPosition(0)
	GLR_UI.GLR_RaffleInfo.GLR_RaffleMaxTicketsEditBox:SetText(glrCharacter.Data.Defaults.RaffleMaxTickets)
	GLR_UI.GLR_RaffleInfo.GLR_RaffleTicketPriceEditBox:SetText(GLR_U:GetMoneyValue(tonumber(glrCharacter.Data.Defaults.TicketPrice), "Lottery", true, 1, "NA", true, true))
	GLR_UI.GLR_RaffleInfo.GLR_RaffleFirstPlacePrizeEditBox:SetText("")
	GLR_UI.GLR_RaffleInfo.GLR_RaffleSecondPlacePrizeEditBox:SetText("")
	GLR_UI.GLR_RaffleInfo.GLR_RaffleThirdPlacePrizeEditBox:SetText("")
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText("0")
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("0")
	
	for t, v in pairs(glrCharacter.Raffle) do
		if transfer[t] == nil then
			transfer[t] = {}
		end
		for key, val in pairs(glrCharacter.Raffle[t]) do
			if transfer[t][key] == nil then
				transfer[t][key] = {}
			end
			if tostring(key) == "TicketNumbers" then
				for k, v in pairs(glrCharacter.Raffle[t][key]) do
					if transfer[t][key][k] == nil then
						transfer[t][key][k] = {}
					end
				end
			else
				transfer[t][key] = glrCharacter.Raffle[t][key]
			end
		end
	end
	
	glrCharacter.PreviousEvent.Raffle.Data = transfer
	glrCharacter.PreviousEvent.Raffle.Settings = glrCharacter.Event.Raffle
	glrCharacter.PreviousEvent.Raffle.Available = true
	
	glrCharacter.Data.Raffle.FirstPrizeData = nil
	glrCharacter.Data.Raffle.FirstPrizeData = {}
	glrCharacter.Data.Raffle.FirstPrizeData.ItemLink = {}
	glrCharacter.Data.Raffle.FirstPrizeData.ItemName = {}
	
	glrCharacter.Data.Raffle.SecondPrizeData = nil
	glrCharacter.Data.Raffle.SecondPrizeData = {}
	glrCharacter.Data.Raffle.SecondPrizeData.ItemLink = {}
	glrCharacter.Data.Raffle.SecondPrizeData.ItemName = {}
	
	glrCharacter.Data.Raffle.ThirdPrizeData = nil
	glrCharacter.Data.Raffle.ThirdPrizeData = {}
	glrCharacter.Data.Raffle.ThirdPrizeData.ItemName = {}
	glrCharacter.Data.Raffle.ThirdPrizeData.ItemLink = {}
	
	glrCharacter.Event.Raffle = nil
	glrCharacter.Event.Raffle = {}
	
	glrCharacter.Raffle.TicketPool = nil
	glrCharacter.Raffle.TicketPool = {}
	
	glrCharacter.Raffle.Entries.TicketRange = nil
	glrCharacter.Raffle.Entries.TicketRange = {}
	
	glrCharacter.Raffle.Entries.TicketNumbers = nil
	glrCharacter.Raffle.Entries.TicketNumbers = {}
	
	glrCharacter.Raffle.Entries.Tickets = nil
	glrCharacter.Raffle.Entries.Tickets = {}
	
	glrCharacter.Raffle.Entries.Names = nil
	glrCharacter.Raffle.Entries.Names = {}
	
	glrCharacter.Raffle.MessageStatus = nil
	glrCharacter.Raffle.MessageStatus = {}
	
	glrTemp.Raffle = nil
	glrTemp.Raffle = {}
	
	glrTempStatus = nil
	glrTempStatus = {}
	
	if glrHistory.ActiveEvents == nil then
		glrHistory.ActiveEvents = {}
	end
	
	if glrHistory.ActiveEvents[FullPlayerName] == nil then
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	else
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	end
	
	if GLR_UI.GLR_MainFrame:IsVisible() then
		GLR:UpdatePlayersAndTotalTickets()
		GLR:UpdateNumberOfUnusedTickets()
	end
	
	glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
	GLR_Global_Variables[2] = true
	C_Timer.After(5, function(self) GLR_U:UpdateInfo() end)
	
	GLR_Global_Variables[6][2] = false
	
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:Hide()
	
	if not Variables[19] then
		if not Variables[14] then
			C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Complete"], "GUILD") end)
		else
			C_Timer.After(1, function(self) SendChatMessage(L["Advanced Raffle Draw Complete"], "GUILD") end)
		end
		--To re-enable the buttons disabled during Event Draw
		C_Timer.After(5, function(self) AbortRollProcess("Raffle", true, false) end)
		Variables[19] = true
	end
	
end

---------------------------------------------
-------------- STARTS THE RAFFLE ------------
---------------------------------------------
--------- STARTS RAFFLE, EVEN BEFORE --------
------------ THE SET RAFFLE DATE ------------
---------------------------------------------

local function AnnounceRaffleWinners()
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	Variables[8] = true
	if not GLR_Global_Variables[3] then
		if not glrCharacter.Data.Settings.Raffle.InverseAnnounce then
			if not Variables[3][1] then
				C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce First Ticket"] .. CommaValue(Variables[5][1]), "GUILD") end)
				C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 First Winner Found"] .. Variables[4][1] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][1], "GUILD") end)
				C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				C_Timer.After(7, AnnounceRaffleWinners)
				Variables[3][1] = true
				return
			elseif not Variables[3][2] then
				if glrCharacter.Event.Raffle.SecondPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Second Ticket"] .. CommaValue(Variables[5][2]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Second Winner Found"] .. Variables[4][2] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][2], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				C_Timer.After(7, AnnounceRaffleWinners)
				Variables[3][2] = true
				return
			elseif not Variables[3][3] then
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Third Ticket"] .. CommaValue(Variables[5][3]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Third Winner Found"] .. Variables[4][3] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][3], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				Variables[7][2] = true
				Variables[3][3] = true
			end
		else
			if not Variables[3][3] then
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Third Ticket"] .. CommaValue(Variables[5][3]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Third Winner Found"] .. Variables[4][3] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][3], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				C_Timer.After(7, AnnounceRaffleWinners)
				Variables[3][3] = true
				return
			elseif not Variables[3][2] then
				if glrCharacter.Event.Raffle.SecondPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Second Ticket"] .. CommaValue(Variables[5][2]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Second Winner Found"] .. Variables[4][2] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][2], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				C_Timer.After(7, AnnounceRaffleWinners)
				Variables[3][2] = true
				return
			elseif not Variables[3][1] then
				C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce First Ticket"] .. CommaValue(Variables[5][1]), "GUILD") end)
				C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 First Winner Found"] .. Variables[4][1] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][1], "GUILD") end)
				C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				Variables[3][1] = true
				Variables[7][2] = true
			end
		end
	elseif not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AnnounceRaffleWinners() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AnnounceRaffleWinners() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
end

local function RaffleDrawThirdPlace()
	
	local firstTicket = glrCharacter.Event.Raffle.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Raffle.LastTicketBought - 1
	local thirdFound = false
	local prepareNext = false
	local doStep = glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners
	local continue = true
	local count = 0
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	for i = 1, #glrCharacter.Raffle.Entries.Names do
		count = count + 1
		if count == 4 then --Don't want to use up too much processing power if their are a lot of entries.
			break
		end
	end
	
	if glrCharacter.Event.Raffle.ThirdPlace ~= false then
		if Variables[2][1] and Variables[2][2] then
			for i = 1, #raffleTicketNumbersTable do
				if raffleTicketNumbersTable[i] == Variables[5][3] then
					for t, v in pairs(glrCharacter.Raffle.Entries.Names) do
						for j = 1, #glrCharacter.Raffle.Entries.TicketNumbers[v] do
							
							local tn = glrCharacter.Raffle.Entries.TicketNumbers[v][j]
							
							if tn == Variables[5][3] then
								
								if count >= 3 and doStep then
									for k = 1, #raffleWinners do
										if raffleWinners[k] == v then
											continue = false
										end
									end
								end
								
								if not GLR_Global_Variables[3] and continue then
									Variables[4][3] = v
									thirdFound = true
									prepareNext = true
									Variables[2][3] = true
									continue = false
									break
								elseif GLR_Global_Variables[3] and not Variables[9] then
									local timestamp = GetTimeStamp()
									if Variables[23] then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Manually Aborted")
									else
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Automatically Aborted")
									end
									C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
									Variables[9] = true
									continue = false
									break
								end
								
							end
						end
						
						if thirdFound or not continue then
							break
						end
						
					end
				end
				
				if thirdFound or not continue then
					break
				end
				
			end
		end
		
	elseif glrCharacter.Event.Raffle.thirdPlace == false then
		thirdFound = true
		prepareNext = true
		Variables[2][3] = true
	end
	
	if not thirdFound then
		if not GLR_Global_Variables[3] then
			if Variables[2][1] and Variables[2][2] then --Prevents redrawing a different ticket number while searching for a first and second place winner.
				Variables[5][3] = GenerateTicket(firstTicket, lastTicket, "Raffle")
			end
			C_Timer.After(1, RaffleDrawThirdPlace)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
	if thirdFound and prepareNext then
		if not GLR_Global_Variables[3] then
			local value3 = "true"
			return value3
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawThirdPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
end

local function RaffleDrawSecondPlace()
	
	local firstTicket = glrCharacter.Event.Raffle.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Raffle.LastTicketBought - 1
	local secondFound = false
	local prepareNext = false
	local doStep = glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners
	local continue = true
	local count = 0
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	for i = 1, #glrCharacter.Raffle.Entries.Names do
		count = count + 1
		if count == 3 then --Don't want to use up too much processing power if their are a lot of entries.
			break
		end
	end
	
	if glrCharacter.Event.Raffle.SecondPlace ~= false then
		if Variables[2][1] then
			for i = 1, #raffleTicketNumbersTable do
				if raffleTicketNumbersTable[i] == Variables[5][2] then
					for t, v in pairs(glrCharacter.Raffle.Entries.Names) do
						for j = 1, #glrCharacter.Raffle.Entries.TicketNumbers[v] do
							local tn = glrCharacter.Raffle.Entries.TicketNumbers[v][j]
							
							if tn == Variables[5][2] then
								
								if count >= 2 and doStep then
									for k = 1, #raffleWinners do
										if raffleWinners[k] == v then
											continue = false
										end
									end
								end
								
								if not GLR_Global_Variables[3] and continue then
									Variables[4][2] = v
									table.insert(raffleWinners, v)
									secondFound = true
									prepareNext = true
									Variables[2][2] = true
									continue = false
									break
								elseif GLR_Global_Variables[3] and not Variables[9] then
									local timestamp = GetTimeStamp()
									if Variables[23] then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Manually Aborted")
									else
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Automatically Aborted")
									end
									C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
									Variables[9] = true
									continue = false
									break
								end
								
							end
						end
						
						if secondFound or not continue then
							break
						end
						
					end
				end
				
				if secondFound or not continue then
					break
				end
				
			end
		end
		
	elseif glrCharacter.Event.Raffle.SecondPlace == false then
		secondFound = true
		prepareNext = true
		Variables[2][2] = true
	end
	
	if not secondFound then
		if not GLR_Global_Variables[3] then
			if Variables[2][1] then --Prevents redrawing a different ticket number while searching for a first place winner.
				Variables[5][2] = GenerateTicket(firstTicket, lastTicket, "Raffle")
			end
			C_Timer.After(1, RaffleDrawSecondPlace)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
	if secondFound and prepareNext then
		if not GLR_Global_Variables[3] then
			local value2 = "true"
			return value2
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawSecondPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
end

local function RaffleDrawFirstPlace()
	
	local firstTicket = glrCharacter.Event.Raffle.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Raffle.LastTicketBought - 1
	local firstFound = false
	local prepareNext = false
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	for i = 1, #raffleTicketNumbersTable do
		if raffleTicketNumbersTable[i] == Variables[5][1] then
			for t, v in pairs(glrCharacter.Raffle.Entries.Names) do
				for j = 1, #glrCharacter.Raffle.Entries.TicketNumbers[v] do
					
					local tn = glrCharacter.Raffle.Entries.TicketNumbers[v][j]
					
					if tn == Variables[5][1] then
						
						if not GLR_Global_Variables[3] then
							Variables[4][1] = v
							table.insert(raffleWinners, v)
							firstFound = true
							prepareNext = true
							Variables[2][1] = true
							break
						elseif GLR_Global_Variables[3] and not Variables[9] then
							local timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Automatically Aborted")
							end
							C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
							Variables[9] = true
							firstFound = true --While the process is aborted, we still need to break out of the loops
							break
						end
						
					end
				end
				
				if firstFound then
					break
				end
				
			end
		end
		
		if firstFound then
			break
		end
		
	end
	
	if not firstFound then
		if not GLR_Global_Variables[3] then
			Variables[5][1] = GenerateTicket(firstTicket, lastTicket, "Raffle")
			C_Timer.After(1, RaffleDrawFirstPlace)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
	if firstFound and prepareNext then
		if not GLR_Global_Variables[3] then
			local value1 = "true"
			return value1
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleDrawFirstPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
end

local function RaffleCompletionBuffer() --Acts as a buffer while the Mod searches for winning ticket numbers before erasing the raffle data.
	
	if not GLR_Global_Variables[3] then
		
		if Variables[2][1] then
			if Variables[2][2] then
				if Variables[2][3] then
					if not GLR_Global_Variables[3] then
						if not Variables[8] and not Variables[14] then
							AnnounceRaffleWinners()
						end
						if not Variables[7][2] then
							C_Timer.After(5, RaffleCompletionBuffer)
						end
					end
				end
			end
		end
		
		if not Variables[2][1] or not Variables[2][2] or not Variables[2][3] then
			if not Variables[7][2] then
				if not GLR_Global_Variables[3] then
					C_Timer.After(5, RaffleCompletionBuffer)
				end
			end
		end
		
	end
	
	if Variables[7][2] then
		--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
		Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
		--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
		--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
		if not Variables[23] then
			GLR_Global_Variables[3] = true
		end
		if not GLR_Global_Variables[3] then
			C_Timer.After(5, function(self)
				if not GLR_Global_Variables[3] then
					PrepareNextRaffle()
				elseif GLR_Global_Variables[3] and not Variables[9] then
					local timestamp = GetTimeStamp()
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleCompletionBuffer() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleCompletionBuffer() - Draw Process Automatically Aborted")
					end
					AbortRollProcess("Raffle")
					Variables[9] = true
				end
			end)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleCompletionBuffer() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleCompletionBuffer() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
end

local function RaffleStep4Buffer()
	
	if not GLR_Global_Variables[3] then
		if Variables[2][1] and Variables[2][2] and Variables[2][3] then
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - RaffleStep4Buffer() - Raffle Winners (Players) (1st / 2nd / 3rd): [" .. Variables[4][1] .. " / " .. Variables[4][2] .. " / " .. Variables[4][3] .. "]")
			RaffleCompletionBuffer()
		else
			C_Timer.After(5, RaffleStep4Buffer)
		end
	end
	
end

local function BeginRaffleDrawStep3()
	
	local firstTicket = glrCharacter.Event.Raffle.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Raffle.LastTicketBought - 1
	local count = glrCharacter.Event.Raffle.LastTicketBought * 10
	local continue = false
	local timestamp = GetTimeStamp()
	raffleTicketNumbersTable = {} --Clears the table in case another Raffle Roll is started before someone does a /reload
	Variables[5][1] = GenerateTicket(firstTicket, lastTicket, "Raffle")
	Variables[5][2] = GenerateTicket(firstTicket, lastTicket, "Raffle")
	Variables[5][3] = GenerateTicket(firstTicket, lastTicket, "Raffle")
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		
		if glrCharacter.Event.Raffle.SecondPlace == false then
			Variables[2][2] = true
		end
		if glrCharacter.Event.Raffle.ThirdPlace == false then
			Variables[2][3] = true
		end
		
		for t, v in pairs(glrCharacter.Raffle.Entries.Names) do
			for i = 1, #glrCharacter.Raffle.Entries.TicketNumbers[v] do
				table.insert(raffleTicketNumbersTable, glrCharacter.Raffle.Entries.TicketNumbers[v][i])
			end
		end
		
		sort(raffleTicketNumbersTable)
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep3() - Winning Ticket Numbers (1st / 2nd / 3rd): [" .. Variables[5][1] .. " / " .. Variables[5][2] .. " / " .. Variables[5][3] .. "]")
		
		local value1 = RaffleDrawFirstPlace()
		local value2 = "true"
		local value3 = "true"
		
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			value2 = RaffleDrawSecondPlace()
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			value3 = RaffleDrawThirdPlace()
		end
		
		RaffleStep4Buffer()
		
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep3() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep3() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end

local function AdvancedRaffleDrawWinners()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
		Variables[7][2] = true
	end
	
	if not GLR_Global_Variables[3] then
		if not glrCharacter.Data.Settings.Raffle.InverseAnnounce then --Announce 1st -> 2nd -> 3rd
			if not Variables[3][1] then
				C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce First Ticket"] .. CommaValue(Variables[5][1]), "GUILD") end)
				C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 First Winner Found"] .. Variables[4][1] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][1], "GUILD") end)
				C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				Variables[3][1] = true
				C_Timer.After(7, AdvancedRaffleDrawWinners)
			elseif not Variables[3][2] then
				if glrCharacter.Event.Raffle.SecondPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Second Ticket"] .. CommaValue(Variables[5][2]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Second Winner Found"] .. Variables[4][2] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][2], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
					C_Timer.After(7, AdvancedRaffleDrawWinners)
				else
					C_Timer.After(2, AdvancedRaffleDrawWinners)
				end
				Variables[3][2] = true
			elseif not Variables[3][3] then
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Third Ticket"] .. CommaValue(Variables[5][3]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Third Winner Found"] .. Variables[4][3] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][3], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				Variables[7][2] = true
				Variables[3][3] = true
			end
		else
			if not Variables[3][3] then
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Third Ticket"] .. CommaValue(Variables[5][3]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Third Winner Found"] .. Variables[4][3] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][3], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
					C_Timer.After(7, AdvancedRaffleDrawWinners)
				else
					C_Timer.After(2, AdvancedRaffleDrawWinners)
				end
				Variables[3][3] = true
			elseif not Variables[3][2] then
				if glrCharacter.Event.Raffle.SecondPlace ~= false then
					C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce Second Ticket"] .. CommaValue(Variables[5][2]), "GUILD") end)
					C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 Second Winner Found"] .. Variables[4][2] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][2], "GUILD") end)
					C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
					C_Timer.After(7, AdvancedRaffleDrawWinners)
				else
					C_Timer.After(2, AdvancedRaffleDrawWinners)
				end
				Variables[3][2] = true
			elseif not Variables[3][1] then
				C_Timer.After(0.5, function(self) SendChatMessage(L["Raffle Draw Step 5 Announce First Ticket"] .. CommaValue(Variables[5][1]), "GUILD") end)
				C_Timer.After(1, function(self) SendChatMessage(L["Raffle Draw Step 5 First Winner Found"] .. Variables[4][1] .. L["Raffle Draw Step 5 Winner Found Fixed Variable"] .. Variables[1][1], "GUILD") end)
				C_Timer.After(1.5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				Variables[3][1] = true
				Variables[7][2] = true
			end
		end
	end
	
	if Variables[7][2] then
		if not GLR_Global_Variables[3] then
			C_Timer.After(5, function(self)
				if not GLR_Global_Variables[3] then
					PrepareNextRaffle()
				elseif GLR_Global_Variables[3] and not Variables[9] then
					local timestamp = GetTimeStamp()
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawWinners() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawWinners() - Draw Process Automatically Aborted")
					end
					AbortRollProcess("Raffle")
					Variables[9] = true
				end
			end)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawWinners() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawWinners() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
			Variables[9] = true
		end
	end
	
end

local function AdvancedRaffleDrawBuffer() --Buffer while the AddOn generates the Winning Ticket(s)
	local timestamp = GetTimeStamp()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		if Variables[16] then
			Variables[4][1] = RandomizationTable[2][Variables[5][1]]
			if glrCharacter.Event.Raffle.SecondPlace ~= false then
				Variables[4][2] = RandomizationTable[2][Variables[5][2]]
			end
			if glrCharacter.Event.Raffle.ThirdPlace ~= false then
				Variables[4][3] = RandomizationTable[2][Variables[5][3]]
			end
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Raffle Winners (Players) (1st / 2nd / 3rd): [" .. Variables[4][1] .. " / " .. Variables[4][2] .. " / " .. Variables[4][3] .. "]")
			C_Timer.After(5, function(self)
				if not GLR_Global_Variables[3] then
					AdvancedRaffleDrawWinners()
				elseif GLR_Global_Variables[3] and not Variables[9] then
					timestamp = GetTimeStamp()
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Automatically Aborted")
					end
					AbortRollProcess("Raffle")
					Variables[9] = true
				end
			end)
		else
			C_Timer.After(1, function(self)
				if not GLR_Global_Variables[3] then
					AdvancedRaffleDrawBuffer()
				elseif GLR_Global_Variables[3] and not Variables[9] then
					timestamp = GetTimeStamp()
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Automatically Aborted")
					end
					AbortRollProcess("Raffle")
					Variables[9] = true
				end
			end)
		end
	elseif not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawBuffer() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
end

local function AdvancedRaffleDrawTickets()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	local first = glrCharacter.Event.Raffle.FirstTicketNumber
	local last = glrCharacter.Event.Raffle.LastTicketBought - 1
	local continue = false
	local check = false
	Variables[5][1] = tostring(math.random(first, last))
	
	if glrCharacter.Event.Raffle.SecondPlace ~= false then
		Variables[5][2] = tostring(math.random(first, last))
	else
		Variables[2][2] = true
	end
	if glrCharacter.Event.Raffle.ThirdPlace ~= false then
		Variables[5][3] = tostring(math.random(first, last))
	else
		Variables[2][3] = true
	end
	
	while true do --Generates up to three different Winning Ticket Numbers.
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			if Variables[17] == 1 then break end --Only one total Ticket was sold/given so why check since ticket numbers will be the same for up to three prizes?
			if Variables[5][1] == Variables[5][2] then
				Variables[5][2] = tostring(math.random(first, last))
			end
			if glrCharacter.Event.Raffle.ThirdPlace ~= false then
				if Variables[5][1] == Variables[5][3] or Variables[5][2] == Variables[5][3] then
					Variables[5][3] = tostring(math.random(first, last))
				end
				if Variables[5][1] ~= Variables[5][2] and Variables[5][1] ~= Variables[5][3] and Variables[5][2] ~= Variables[5][3] or Variables[17] == 2 then continue = true break end
			else
				if Variables[5][1] ~= Variables[5][2] then continue = true break end
			end
		else continue = true break end
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawTickets() - Winning Ticket Numbers (1st / 2nd / 3rd): [" .. Variables[5][1] .. " / " .. Variables[5][2] .. " / " .. Variables[5][3] .. "]")
	
	if glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners then
		local total = #glrCharacter.Raffle.Entries.Names
		local FP = RandomizationTable[2][Variables[5][1]]
		local SP = "GLR_2"
		local TP = "GLR_3"
		local CT = 1
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			SP = RandomizationTable[2][Variables[5][2]]
			CT = CT + 1
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			TP = RandomizationTable[2][Variables[5][3]]
			CT = CT + 1
		end
		while true do
			if SP ~= "GLR_2" then
				if FP == SP then
					Variables[5][2] = tostring(math.random(first, last))
					SP = RandomizationTable[2][Variables[5][2]]
				end
			end
			if TP ~= "GLR_3" then
				if FP == TP or SP == TP then
					Variables[5][3] = tostring(math.random(first, last))
					TP = RandomizationTable[2][Variables[5][3]]
				end
			end
			if total < CT then check = true break end
			if FP ~= SP and FP ~= TP and SP ~= TP then check = true break end
		end
	else check = true end
	
	if continue and check then Variables[16] = true end
	
	if not GLR_Global_Variables[3] then
		AdvancedRaffleDrawBuffer()
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawTickets() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDrawTickets() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end

local function RaffleDrawAnnounceRoll()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 4 Announce Roll"], "GUILD") end)
		C_Timer.After(0.4, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
		C_Timer.After(10.6, function(self)
			if not GLR_Global_Variables[3] then
				if not Variables[14] then
					BeginRaffleDrawStep3()
				else
					AdvancedRaffleDrawTickets()
				end
			elseif GLR_Global_Variables[3] and not Variables[9] then
				local timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Raffle")
				Variables[9] = true
			end
		end)
	elseif GLR_Global_Variables[3] and not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end

local function BeginRaffleDrawStep2()
	
	local ticketPool = {}
	local numberOfInvalidTickets = 0
	local lowestTicketNumber = CommaValue(glrCharacter.Event.Raffle.FirstTicketNumber)
	local highestTicketNumber = CommaValue(glrCharacter.Event.Raffle.LastTicketBought - 1)
	local timestamp = GetTimeStamp()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		
		if glrCharacter.Raffle.TicketPool ~= nil then
			for t, v in pairs(glrCharacter.Raffle.TicketPool) do
				numberOfInvalidTickets = numberOfInvalidTickets + 1
			end
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Number of Invalid Tickets: [" .. numberOfInvalidTickets .. "]")
		
		if numberOfInvalidTickets > 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(string.gsub(L["Draw Step 2 Invalid Tickets"], "%%unsold", CommaValue(numberOfInvalidTickets)), "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(string.gsub(string.gsub(L["Draw Step 2"], "%%low", lowestTicketNumber), "%%high", highestTicketNumber), "GUILD") end)
		else
			C_Timer.After(0.2, function(self) SendChatMessage(string.gsub(string.gsub(L["Draw Step 2"], "%%low", lowestTicketNumber), "%%high", highestTicketNumber), "GUILD") end)
		end
		
		C_Timer.After(12, function(self)
			if not GLR_Global_Variables[3] then
				RaffleDrawAnnounceRoll()
			elseif GLR_Global_Variables[3] and not Variables[9] then
				timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Raffle")
				Variables[9] = true
			end
		end)
		
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep2() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end

local function AdvancedRaffleDraw()
	
	local numberOfTickets = CommaValue(glrCharacter.Event.Raffle.TicketsSold)
	local ticketValue = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
	local first = CommaValue(glrCharacter.Event.Raffle.FirstTicketNumber)
	local last = CommaValue(tostring(glrCharacter.Event.Raffle.LastTicketBought - 1))
	local timestamp = GetTimeStamp()
	Variables[1][1] = glrCharacter.Event.Raffle.FirstPlace
	Variables[1][2] = false
	Variables[1][3] = false
	Variables[17] = glrCharacter.Event.Raffle.TicketsSold + glrCharacter.Event.Raffle.GiveAwayTickets
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		
		local TicketValue = GLR_U:GetMoneyValue(ticketValue, "Raffle", false)
		
		if tonumber(glrCharacter.Event.Raffle.FirstPlace) ~= nil then
			Variables[1][1] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.FirstPlace), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_total" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_half" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_quarter" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
		end
		
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.SecondPlace) ~= nil then
				Variables[1][2] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.SecondPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_total" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_half" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_quarter" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				Variables[1][2] = glrCharacter.Event.Raffle.SecondPlace
			end
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.ThirdPlace) ~= nil then
				Variables[1][3] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.ThirdPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_total" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_half" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_quarter" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				Variables[1][3] = glrCharacter.Event.Raffle.ThirdPlace
			end
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDraw() - Ticket Value: [" .. TicketValue .. "] - Tickets Generated: [" .. Variables[22][2][1] .. "] - Assigned: [" .. Variables[22][2][11] .. "] - Prizes (1 / 2 / 3): [" .. Variables[1][1] .. " / " .. tostring(Variables[1][2]) .. " / " .. tostring(Variables[1][3]) .. "]" )
		
		local ms = 0.3
		
		SendChatMessage(string.gsub(string.gsub(L["Draw Step 1"], "%%TicketsSold", CommaValue(numberOfTickets)), "%%money", TicketValue), "GUILD")
		
		if glrCharacter.Event.Raffle.GiveAwayTickets ~= nil then
			if glrCharacter.Event.Raffle.GiveAwayTickets > 0 then
				local GivenTickets = CommaValue(glrCharacter.Event.Raffle.GiveAwayTickets)
				local message = L["Send Info GLR"] .. ": " .. string.gsub(L["Draw Given Tickets"], "%%t", CommaValue(GivenTickets))
				C_Timer.After(ms, function(self) SendChatMessage(message, "GUILD") end)
				ms = ms + 0.3
			end
		end
		
		C_Timer.After(ms, function(self) SendChatMessage(L["Raffle Draw Step 1"] .. ":", "GUILD") end)
		ms = ms + 0.3
		
		C_Timer.After(ms, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", Variables[1][1]), "GUILD") end)
		ms = ms + 0.3
		
		if Variables[2][2] ~= false then
			C_Timer.After(ms, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", Variables[1][2]), "GUILD") end)
			if Variables[2][3] ~= false then
				ms = ms + 0.3
			end
		end
		if Variables[2][3] ~= false then
			C_Timer.After(ms, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", Variables[1][3]), "GUILD") end)
		end
		
		local message, _ = string.gsub(string.gsub(L["Advanced Draw Step 1"], "%%f", first), "%%l", last)
		local tickets, _ = string.gsub(string.gsub(L["Advanced Draw Step 1 Totals"], "%%t", CommaValue(Variables[17])), "%%c", CommaValue(Variables[22][2][10]))
		C_Timer.After(5.3, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
		C_Timer.After(5.6, function(self) SendChatMessage(tickets, "GUILD") end)
		C_Timer.After(5.9, function(self) SendChatMessage(message, "GUILD") end)
		
		C_Timer.After(6.2, function(self)
			if not GLR_Global_Variables[3] then
				RaffleDrawAnnounceRoll()
			elseif GLR_Global_Variables[3] and not Variables[9] then
				timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDraw() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDraw() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Raffle")
				Variables[9] = true
			end
		end)
		
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDraw() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedRaffleDraw() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end

local function BeginRaffleDrawStep1()
	
	local ticketValue = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
	local numberOfTickets = glrCharacter.Event.Raffle.TicketsSold
	Variables[1][1] = glrCharacter.Event.Raffle.FirstPlace
	Variables[1][2] = false
	Variables[1][3] = false
	
	local TicketValue = GLR_U:GetMoneyValue(ticketValue, "Raffle", false)
	local timestamp = GetTimeStamp()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			Variables[1][2] = glrCharacter.Event.Raffle.SecondPlace
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			Variables[1][3] = glrCharacter.Event.Raffle.ThirdPlace
		end
		
		if tonumber(glrCharacter.Event.Raffle.FirstPlace) ~= nil then
			Variables[1][1] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.FirstPlace), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_total" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_half" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_quarter" then
			Variables[1][1] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
		end
		
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.SecondPlace) ~= nil then
				Variables[1][2] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.SecondPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_total" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_half" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_quarter" then
				Variables[1][2] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				Variables[1][2] = glrCharacter.Event.Raffle.SecondPlace
			end
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.ThirdPlace) ~= nil then
				Variables[1][3] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.ThirdPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_total" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_half" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_quarter" then
				Variables[1][3] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				Variables[1][3] = glrCharacter.Event.Raffle.ThirdPlace
			end
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep1() - Ticket Value: [" .. TicketValue .. "] - Prizes (1 / 2 / 3): [" .. Variables[1][1] .. " / " .. tostring(Variables[1][2]) .. " / " .. tostring(Variables[1][3]) .. "]" )
		
		C_Timer.After(0.2, function(self) SendChatMessage(string.gsub(string.gsub(L["Draw Step 1"], "%%TicketsSold", CommaValue(numberOfTickets)), "%%money", TicketValue), "GUILD") end)
		
		if glrCharacter.Event.Raffle.GiveAwayTickets ~= nil then
			if glrCharacter.Event.Raffle.GiveAwayTickets > 0 then
				local GivenTickets = tostring(glrCharacter.Event.Raffle.GiveAwayTickets)
				C_Timer.After(0.4, function(self) SendChatMessage(L["Send Info GLR"] .. ": " .. string.gsub(L["Draw Given Tickets"], "%%t", CommaValue(GivenTickets)), "GUILD") end)
			end
		end
		
		C_Timer.After(0.6, function(self) SendChatMessage(L["Raffle Draw Step 1"] .. ":", "GUILD") end)
		C_Timer.After(0.8, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", Variables[1][1]), "GUILD") end)
		
		if Variables[1][2] ~= false then
			C_Timer.After(1, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", Variables[1][2]), "GUILD") end)
		end
		if Variables[1][3] ~= false then
			C_Timer.After(1.2, function(self) SendChatMessage(string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", Variables[1][3]), "GUILD") end)
		end
		
		C_Timer.After(13.2, function(self)
			if not GLR_Global_Variables[3] then
				BeginRaffleDrawStep2()
			elseif GLR_Global_Variables[3] and not Variables[9] then
				timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep1() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep1() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Raffle")
				Variables[9] = true
			end
		end)
		
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep1() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginRaffleDrawStep1() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
		Variables[9] = true
	end
	
end


---------------------------------------------
------------- STARTS THE LOTTERY ------------
---------------------------------------------
-------- STARTS LOTTERY, EVEN BEFORE --------
----------- THE SET LOTTERY DATE ------------
---------------------------------------------

local function LotteryCompletionBuffer() --Acts as a buffer while the Mod searches for winning ticket numbers before erasing the Lottery data.
	
	local timestamp = GetTimeStamp()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not Variables[18] then
		Variables[18] = true
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Started Buffer Function")
	end
	
	if Variables[10] then
		if not GLR_Global_Variables[3] then
			C_Timer.After(3, function(self) Variables[7][1] = true end)
			if not Variables[7][1] then
				C_Timer.After(5, function(self)
					if not GLR_Global_Variables[3] then
						LotteryCompletionBuffer()
					elseif GLR_Global_Variables[3] and not Variables[9] then
						timestamp = GetTimeStamp()
						if Variables[23] then
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
						else
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
						end
						AbortRollProcess("Lottery")
						Variables[9] = true
					end
				end)
			end
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not Variables[10] then
		if not Variables[7][1] then
			if not GLR_Global_Variables[3] then
				C_Timer.After(5, function(self)
					if not GLR_Global_Variables[3] then
						LotteryCompletionBuffer()
					elseif GLR_Global_Variables[3] and not Variables[9] then
						timestamp = GetTimeStamp()
						if Variables[23] then
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
						else
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
						end
						AbortRollProcess("Lottery")
						Variables[9] = true
					end
				end)
			elseif GLR_Global_Variables[3] and not Variables[9] then
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
				end
				C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
				Variables[9] = true
			end
		end
	end
	
	if Variables[7][1] then
		if not GLR_Global_Variables[3] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Buffer Function Complete")
			C_Timer.After(7, function(self)
				if not GLR_Global_Variables[3] then
					PrepareNextLottery()
				elseif GLR_Global_Variables[3] and not Variables[9] then
					timestamp = GetTimeStamp()
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
					end
					AbortRollProcess("Lottery")
					Variables[9] = true
				end
			end)
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryCompletionBuffer() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
end

local function LotteryDrawSearchSecondPlace() --Only does this step if no winner is guaranteed and no one won first place.
	
	local firstTicket = glrCharacter.Event.Lottery.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Lottery.LastTicketBought
	local winningTicket = tostring(math.random(firstTicket, lastTicket))
	local jackpotGold = tonumber(glrCharacter.Event["Lottery"]["StartingGold"]) + ( glrCharacter.Event["Lottery"]["TicketsSold"] * tonumber(glrCharacter.Event["Lottery"]["TicketPrice"]) )
	local guildPercent = (tonumber(glrCharacter.Event.Lottery.GuildCut) / 100) * jackpotGold
	local secondPercent = (tonumber(glrCharacter.Event.Lottery.SecondPlace) / 100) * jackpotGold
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	local ticketNumbersTable = {}
	local ticketPool = {}
	local winnerFound = false
	local prepareNext = false
	local redraw = false
	Variables[12][1] = false
	Variables[13][1] = Variables[13][1] - secondPercent
	Variables[6][1] = winningTicket
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Searching for Second Place Winner. Winning Ticket: " .. winningTicket)
	
	for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
		for i = 1, #glrCharacter.Lottery.Entries.TicketNumbers[v] do
			table.insert(ticketNumbersTable, glrCharacter.Lottery.Entries.TicketNumbers[v][i])
		end
	end
	
	for t, v in pairs(glrCharacter.Lottery.TicketPool) do
		table.insert(ticketPool, v)
	end
	
	if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
		Variables[13][1] = 0.0001
	end
	
	if secondPercent < 0.0001 and secondPercent ~= 0 then
		secondPercent = 0.0001
	end
	
	if guildPercent < 0.0001 and guildPercent ~= 0 then
		guildPercent = 0.0001
	end
	
	local remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
	local secondValue = GLR_U:GetMoneyValue(secondPercent, "Lottery", true, round)
	local guildValue = GLR_U:GetMoneyValue(guildPercent, "Lottery", true, round)
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	for i = 1, #ticketNumbersTable do
		if ticketNumbersTable[i] == winningTicket then
			for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
				for j = 1, #glrCharacter.Lottery.Entries.TicketNumbers[v] do
					local tn = glrCharacter.Lottery.Entries.TicketNumbers[v][j]
					if tn == winningTicket then
						if not GLR_Global_Variables[3] then
							C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
							C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Announce Second Place Winning Ticket"], "%%t", winningTicket), "GUILD") end)
							C_Timer.After(3, function(self) SendChatMessage(string.gsub(string.gsub(L["Lottery Draw Step 6 Winner Found"], "%%v", v), "%%g", secondValue), "GUILD") end)
							C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
							C_Timer.After(5, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Next Lottery Starts"], "%%g", remainingValue), "GUILD") end)
							C_Timer.After(6, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
							Variables[6][2] = v
							Variables[10] = true
							Variables[12][2] = true
							winnerFound = true
							prepareNext = true
						elseif GLR_Global_Variables[3] and not Variables[9] then
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Automatically Aborted")
							end
							C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
							Variables[9] = true
						end
					end
				end
			end
		end
	end
	
	if not winnerFound then
		for i = 1, #ticketPool do --If the winning ticket number wasn't assigned to a person, it redoes the ticket draw.
			if ticketPool[i] == winningTicket then
				if not GLR_Global_Variables[3] then
					redraw = true
					C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
					C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Unused Ticket Found"], "%%t", winningTicket), "GUILD") end)
					C_Timer.After(3, function(self) SendChatMessage(L["Lottery Draw Unused Ticket Redraw"], "GUILD") end)
					C_Timer.After(13, LotteryDrawSearchSecondPlace)
					winnerFound = true
				elseif GLR_Global_Variables[3] and not Variables[9] then
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Automatically Aborted")
					end
					C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
					Variables[9] = true
				end
			end
		end
	end
	
	if not winnerFound and not redraw then
		Variables[12][2] = false --Prevents the %previous_jackpot variable from showing the second place value of the Jackpot since no one won.
		if not GLR_Global_Variables[3] then
			if glrCharacter.Data.Settings.Lottery.NoGuildCut then
				guildPercent = 0
			end
			Variables[13][1] = jackpotGold - guildPercent
			if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
				Variables[13][1] = 0.0001
			end
			remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", false, 1)
			C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 No Winner Found"], "%%t", winningTicket), "GUILD") end)
			C_Timer.After(3, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 No Second Place"], "%%g", remainingValue), "GUILD") end)
			C_Timer.After(4, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			Variables[10] = true
			prepareNext = true
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if prepareNext then
		if not GLR_Global_Variables[3] then
			LotteryCompletionBuffer()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchSecondPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
end

local function LotteryDrawSearchFirstPlace(winningTicket) --Searches for a valid First Place Winner.
	
	local jackpotGold = tonumber(glrCharacter.Event["Lottery"]["StartingGold"]) + ( glrCharacter.Event["Lottery"]["TicketsSold"] * tonumber(glrCharacter.Event["Lottery"]["TicketPrice"]) )
	local guildPercent = (tonumber(glrCharacter.Event.Lottery.GuildCut) / 100) * jackpotGold
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	local winnerFound = false
	local prepareNext = false
	local bypass = false
	local ticketNumbersTable = {}
	local secondPercent = 1
	if tonumber(glrCharacter.Event.Lottery.SecondPlace) ~= nil then
		secondPercent = tonumber(glrCharacter.Event.Lottery.SecondPlace)
	end
	if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
		if tonumber(glrCharacter.Event.Lottery.SecondPlace) == 0 then
			bypass = true -- Since Second Place is 0% of the Jackpot, why attempt a draw for it?
		end
	elseif glrCharacter.Event.Lottery.SecondPlace == L["Winner Guaranteed"] then
		winnerFound = true --Prevents the mod from attempting to draw a second place ticket since a winner is guaranteed
	end
	
	Variables[6][1] = winningTicket
	
	for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
		for i = 1, #glrCharacter.Lottery.Entries.TicketNumbers[v] do
			table.insert(ticketNumbersTable, glrCharacter.Lottery.Entries.TicketNumbers[v][i])
		end
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Searching for First Place Winner. Winning Ticket: " .. winningTicket .. " Is Winner Guaranteed? " .. string.upper(tostring(bypass)) )
	
	sort(ticketNumbersTable)
	
	if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
		Variables[13][1] = 0.0001
	end
	
	if guildPercent < 0.0001 and guildPercent ~= 0 then
		guildPercent = 0.0001
	end
	
	local remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
	local guildValue = GLR_U:GetMoneyValue(guildPercent, "Lottery", true, round)
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if secondPercent > 0 then
		for i = 1, #ticketNumbersTable do
			if ticketNumbersTable[i] == winningTicket then
				for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
					for j = 1, #glrCharacter.Lottery.Entries.TicketNumbers[v] do
						local tn = glrCharacter.Lottery.Entries.TicketNumbers[v][j]
						if tn == winningTicket then
							if not GLR_Global_Variables[3] then
								C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
								C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 Announce Winning Ticket"], "%%t", winningTicket), "GUILD") end)
								C_Timer.After(3, function(self) SendChatMessage(string.gsub(string.gsub(L["Lottery Draw Step 5 Winner Found"], "%%v", v), "%%g", remainingValue), "GUILD") end)
								C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
								C_Timer.After(5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
								Variables[6][2] = v
								Variables[12][1] = true
								Variables[11] = true
								Variables[10] = true
								winnerFound = true
								prepareNext = true
							elseif GLR_Global_Variables[3] and not Variables[9] then
								if Variables[23] then
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Manually Aborted")
								else
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Automatically Aborted")
								end
								C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
								Variables[9] = true
							end
						end
					end
				end
			end
		end
	end
	
	if not winnerFound and secondPercent == 0 then --Only does this if no Winner Guaranteed, Second Place % is zero
		if not GLR_Global_Variables[3] then
			for i = 1, #ticketNumbersTable do
				if ticketNumbersTable[i] == winningTicket then
					for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
						for j = 1, #glrCharacter.Lottery.Entries.TicketNumbers[v] do
							local tn = glrCharacter.Lottery.Entries.TicketNumbers[v][j]
							if tn == winningTicket then
								C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
								C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 Announce Winning Ticket"], "%%t", winningTicket), "GUILD") end)
								C_Timer.After(3, function(self) SendChatMessage(string.gsub(string.gsub(L["Lottery Draw Step 5 Winner Found"], "%%v", v), "%%g", remainingValue), "GUILD") end)
								C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
								C_Timer.After(5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
								Variables[12][1] = true
								Variables[11] = true
								Variables[10] = true
								winnerFound = true
								prepareNext = true
							end
						end
					end
				end
			end
			if not Variables[10] then
				C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 No Winner Found"], "%%t", winningTicket), "GUILD") end)
				if glrCharacter.Data.Settings.Lottery.NoGuildCut then
					guildValue = 0
					Variables[13][1] = jackpotGold
				end
				C_Timer.After(3, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
				C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Next Lottery Starts"], "%%g", remainingValue), "GUILD") end)
				Variables[10] = true
				winnerFound = true
				prepareNext = true
			end
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not winnerFound then --Only does this if no one won the Jackpot but someone can win Second Place.
		if not bypass then
			if not GLR_Global_Variables[3] then
				C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 No Winner Found"], "%%t", winningTicket), "GUILD") end)
				C_Timer.After(3, function(self) SendChatMessage(L["Lottery Draw Step 5 Draw Second Place"], "GUILD") end)
				Variables[12][2] = true
				C_Timer.After(13, function(self)
					if not GLR_Global_Variables[3] then
						LotteryDrawSearchSecondPlace()
					elseif GLR_Global_Variables[3] and not Variables[9] then
						timestamp = GetTimeStamp()
						if Variables[23] then
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Manually Aborted")
						else
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Automatically Aborted")
						end
						AbortRollProcess("Lottery")
						Variables[9] = true
					end
				end)
			elseif GLR_Global_Variables[3] and not Variables[9] then
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Automatically Aborted")
				end
				C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
				Variables[9] = true
			end
		end
	end
	
	if prepareNext then
		if not GLR_Global_Variables[3] then
			LotteryCompletionBuffer()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchFirstPlace() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
end

local function LotteryDrawSearchInvalidTickets() --Is the first part of the Event Draw where the Winning Ticket number is generated. This allows the mod to search for potentially invalid tickets (one's that were sold but taken back and therefore still generated)
	
	local firstTicket = glrCharacter.Event.Lottery.FirstTicketNumber
	local lastTicket = glrCharacter.Event.Lottery.LastTicketBought - 1
	local ticketPool = {}
	local continue = false
	local ticketNotFound = true
	local count = 0
	local winningTicket = tostring(math.random(firstTicket, lastTicket))
	
	local timestamp = GetTimeStamp()
	
	for t, v in pairs(glrCharacter.Lottery.TicketPool) do
		table.insert(ticketPool, v)
		count = count + 1
	end
	
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchInvalidTickets() - Searching for Invalid Tickets. Winning Ticket: " .. winningTicket .. " Invalid Ticket Count: " .. count)
	
	if count == 0 then
		continue = true
	end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if count >= 1 then
		for i = 1, #ticketPool do --If the winning ticket number wasn't assigned to a person, it redoes the ticket draw.
			count = count - 1
			if count == 0 then
				continue = true
			end
			if ticketPool[i] == winningTicket then
				if not GLR_Global_Variables[3] then
					ticketNotFound = false
					C_Timer.After(0.2, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
					C_Timer.After(0.4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Unused Ticket Found"], "%%t", winningTicket), "GUILD") end)
					C_Timer.After(0.6, function(self) SendChatMessage(L["Lottery Draw Unused Ticket Redraw"], "GUILD") end)
					C_Timer.After(10, function(self)
						if not GLR_Global_Variables[3] then
							LotteryDrawSearchInvalidTickets()
						elseif GLR_Global_Variables[3] and not Variables[9] then
							timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchInvalidTickets() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchInvalidTickets() - Draw Process Automatically Aborted")
							end
							AbortRollProcess("Lottery")
							Variables[9] = true
						end
					end)
				elseif GLR_Global_Variables[3] and not Variables[9] then
					if Variables[23] then
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchInvalidTickets() - Draw Process Manually Aborted")
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawSearchInvalidTickets() - Draw Process Automatically Aborted")
					end
					C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
					Variables[9] = true
				end
				break
			end
		end
	end
	
	if count == 0 and continue and ticketNotFound and not GLR_Global_Variables[3] then
		LotteryDrawSearchFirstPlace(winningTicket)
	end
	
end

local function AdvancedLotteryFindSecond(first, last) --Will only do this if no one won the Jackpot but someone has a chance at Second Place
	
	local jackpotGold = tonumber(glrCharacter.Event.Lottery.StartingGold) + ( glrCharacter.Event.Lottery.TicketsSold * tonumber(glrCharacter.Event.Lottery.TicketPrice) )
	local guildPercent = (tonumber(glrCharacter.Event.Lottery.GuildCut) / 100) * jackpotGold
	local secondPercent = (tonumber(glrCharacter.Event.Lottery.SecondPlace) / 100) * jackpotGold
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	local winnerFound = false
	local prepareNext = false
	local found = false
	local winner
	local ticket = tostring(math.random(first, last))
	Variables[13][1] = Variables[13][1] - secondPercent
	
	if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
		Variables[13][1] = 0.0001
	end
	
	if secondPercent < 0.0001 and secondPercent ~= 0 then
		secondPercent = 0.0001
	end
	
	if guildPercent < 0.0001 and guildPercent ~= 0 then
		guildPercent = 0.0001
	end
	
	local remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
	local secondValue = GLR_U:GetMoneyValue(secondPercent, "Lottery", true, round)
	local guildValue = GLR_U:GetMoneyValue(guildPercent, "Lottery", true, round)
	local timestamp = GetTimeStamp()
	
	Variables[12][1] = false -- Denotes a First Place winner wasn't found in the Previous Event data table.
	
	while true do -- Prevents the AddOn from drawing the same Winning Ticket Number for Second Place as was selected for the Jackpot.
		if ticket == Variables[15] then
			ticket = tostring(math.random(first, last))
		else break end
	end
	
	Variables[6][1] = ticket
	
	if RandomizationTable[1][ticket] then
		winner = RandomizationTable[2][ticket]
		Variables[6][2] = winner
		found = true
	else
		--No First, nor Second, Place winner found.
		Variables[12][2] = false
	end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if found then
		if not GLR_Global_Variables[3] then
			C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Announce Second Place Winning Ticket"], "%%t", CommaValue(ticket)), "GUILD") end)
			C_Timer.After(3, function(self) SendChatMessage(string.gsub(string.gsub(L["Lottery Draw Step 6 Winner Found"], "%%v", winner), "%%g", secondValue), "GUILD") end)
			C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
			C_Timer.After(5, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Next Lottery Starts"], "%%g", remainingValue), "GUILD") end)
			C_Timer.After(6, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			Variables[10] = true
			Variables[12][2] = true
			winnerFound = true
			prepareNext = true
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not winnerFound then
		if not GLR_Global_Variables[3] then
			if glrCharacter.Data.Settings.Lottery.NoGuildCut then
				guildPercent = 0
			end
			Variables[13][1] = jackpotGold - guildPercent
			if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
				Variables[13][1] = 0.0001
			end
			remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
			C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 No Winner Found"], "%%t", CommaValue(ticket)), "GUILD") end)
			C_Timer.After(3, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 No Second Place"], "%%g", remainingValue), "GUILD") end)
			C_Timer.After(4, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			Variables[10] = true
			prepareNext = true
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not GLR_Global_Variables[3] then
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Second Place Found: [" .. string.upper(tostring(found)) .. "] - Transferred Winning Ticket Number: [" .. Variables[6][1] .. "] - Winner: [" .. Variables[6][2] .. "] - Value: [" .. secondPercent ..  "]")
	end
	
	if prepareNext then
		if not GLR_Global_Variables[3] then
			LotteryCompletionBuffer()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindSecond() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
end

local function AdvancedLotteryFindWinner()
	
	local found = false
	local first = glrCharacter.Event.Lottery.FirstTicketNumber
	local last = glrCharacter.Event.Lottery.LastTicketBought - 1
	local winner
	local winnerFound = false
	local jackpotGold = tonumber(glrCharacter.Event.Lottery.StartingGold) + ( glrCharacter.Event.Lottery.TicketsSold * tonumber(glrCharacter.Event.Lottery.TicketPrice) )
	local guildPercent = (tonumber(glrCharacter.Event.Lottery.GuildCut) / 100) * jackpotGold
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	local bypass = false
	local noSecond = false
	local secondPercent = 1
	local timestamp = GetTimeStamp()
	if tonumber(glrCharacter.Event.Lottery.SecondPlace) ~= nil then
		secondPercent = tonumber(glrCharacter.Event.Lottery.SecondPlace)
	end
	
	local ticket = tostring(math.random(first, last))
	
	if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
		if tonumber(glrCharacter.Event.Lottery.SecondPlace) == 0 then
			bypass = true -- Since Second Place is 0% of the Jackpot, why attempt a draw for it?
		end
	elseif glrCharacter.Event.Lottery.SecondPlace == L["Winner Guaranteed"] then
		noSecond = true --Prevents the mod from attempting to draw a second place ticket since a winner is guaranteed
	end
	
	if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
		Variables[13][1] = 0.0001
	end
	
	if guildPercent < 0.0001 and guildPercent ~= 0 then
		guildPercent = 0.0001
	end
	
	local remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
	local guildValue = GLR_U:GetMoneyValue(guildPercent, "Lottery", true, round)
	
	if RandomizationTable[1][ticket] then
		winner = RandomizationTable[2][ticket]
		Variables[6][2] = winner
		found = true
		Variables[12][1] = true
	end
	
	Variables[6][1] = ticket
	Variables[15] = ticket
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if found then
		if not GLR_Global_Variables[3] then
			C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 Announce Winning Ticket"], "%%t", CommaValue(ticket)), "GUILD") end)
			C_Timer.After(3, function(self) SendChatMessage(string.gsub(string.gsub(L["Lottery Draw Step 5 Winner Found"], "%%v", winner), "%%g", remainingValue), "GUILD") end)
			C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
			C_Timer.After(5, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			Variables[10] = true
			Variables[11] = true
			winnerFound = true
			prepareNext = true
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not Variables[10] and secondPercent == 0 then --Only does this if no Winner Guaranteed, Second Place % is zero
		if not GLR_Global_Variables[3] then
			C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 No Winner Found"], "%%t", CommaValue(ticket)), "GUILD") end)
			if glrCharacter.Data.Settings.Lottery.NoGuildCut then
				guildValue = 0
				Variables[13][1] = jackpotGold
			end
			C_Timer.After(3, function(self) SendChatMessage(string.gsub(L["Lottery Draw Guilds Take"], "%%g", guildValue), "GUILD") end)
			C_Timer.After(4, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 6 Next Lottery Starts"], "%%g", remainingValue), "GUILD") end)
			Variables[10] = true
			winnerFound = true
			prepareNext = true
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
	if not winnerFound then --Only does this if no one won the Jackpot but someone can win Second Place.
		if not bypass then
			if not GLR_Global_Variables[3] then
				C_Timer.After(1, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				C_Timer.After(2, function(self) SendChatMessage(string.gsub(L["Lottery Draw Step 5 No Winner Found"], "%%t", CommaValue(ticket)), "GUILD") end)
				C_Timer.After(3, function(self) SendChatMessage(L["Lottery Draw Step 5 Draw Second Place"], "GUILD") end)
				C_Timer.After(13, function(self) AdvancedLotteryFindSecond(first, last) end)
			elseif GLR_Global_Variables[3] and not Variables[9] then
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Automatically Aborted")
				end
				C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
				Variables[9] = true
			end
		end
	end
	
	if not GLR_Global_Variables[3] then
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Winner Found? " .. string.upper(tostring(found)) .. " - Transferred Winning Ticket Number: " .. Variables[6][1] )
	end
	
	if prepareNext then
		if not GLR_Global_Variables[3] then
			LotteryCompletionBuffer()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryFindWinner() - Draw Process Automatically Aborted")
			end
			C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
			Variables[9] = true
		end
	end
	
end

local function BeginLotteryDrawStep4() --Announces the amount the Guild and Second Place will receive.
	
	local secondPercent = glrCharacter.Event.Lottery.SecondPlace
	local jackpotGold = tonumber(glrCharacter.Event["Lottery"]["StartingGold"]) + ( glrCharacter.Event["Lottery"]["TicketsSold"] * tonumber(glrCharacter.Event["Lottery"]["TicketPrice"]) )
	local guildPercent = (tonumber(glrCharacter.Event.Lottery.GuildCut) / 100) * jackpotGold
	local round = glrCharacter.Data.Settings.Lottery.RoundValue
	local secondValue = ""
	local ms = 0.3
	Variables[13][1] = jackpotGold - guildPercent
	
	if secondPercent ~= L["Winner Guaranteed"] then
		secondPercent = (tonumber(secondPercent) / 100) * jackpotGold
		if secondPercent < 0.0001 and secondPercent ~= 0 then
			secondPercent = 0.0001
		end
		secondValue = GLR_U:GetMoneyValue(secondPercent, "Lottery", true, round)
	end
	
	if Variables[13][1] < 0.0001 and Variables[13][1] ~= 0 then
		Variables[13][1] = 0.0001
	end
	
	if guildPercent < 0.0001 and guildPercent ~= 0 then
		guildPercent = 0.0001
	end
	
	local remainingValue = GLR_U:GetMoneyValue(Variables[13][1], "Lottery", true, 1)
	local guildValue = GLR_U:GetMoneyValue(guildPercent, "Lottery", true, round)
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if Variables[23] then
		
		local GuildCutStatus = glrCharacter.Data.Settings.Lottery.NoGuildCut
		local PlayerRollOverStatus = glrCharacter.Data.Settings.Lottery.CarryOver
		
		if secondPercent == L["Winner Guaranteed"] and guildPercent > 0 then
			C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 Condition 1 Part 1"] .. " " .. guildValue .. L["Lottery Draw Step 4 Condition 1 Part 2"] .. ": " .. remainingValue .. ".", "GUILD") end)
			ms = ms + 0.3
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent == 0 and secondPercent > 0 then
			C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 Fixed Variable 2"] .. " " .. remainingValue .. ". " .. L["Lottery Draw Step 4 Fixed Variable 3"] .. ": " .. secondValue .. ".", "GUILD") end)
			ms = ms + 0.3
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent > 0 and secondPercent > 0 then
			C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 Fixed Variable 2"] .. " " .. remainingValue .. ". " .. L["Lottery Draw Step 4 Fixed Variable 3"] .. ": " .. secondValue .. ".", "GUILD") end)
			ms = ms + 0.3
		end
		
		if GuildCutStatus then
			if secondPercent ~= L["Winner Guaranteed"] and guildPercent > 0 and secondPercent > 0 then
				C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 No Guild Cut 1"], "GUILD") end)
				ms = ms + 0.3
			elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent > 0 and secondPercent == 0 then
				C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 No Guild Cut 2"], "GUILD") end)
				ms = ms + 0.3
			end
		end
		
		if PlayerRollOverStatus then
			if secondPercent ~= L["Winner Guaranteed"] then
				C_Timer.After(ms, function(self) SendChatMessage("GLR: If no one wins the Jackpot, and no one wins Second Place, all Players entered will carry over to the next Event with zero starting Tickets.", "GUILD") end)
				ms = ms + 0.3
			end
		end
		
	end
	
	if not GLR_Global_Variables[3] then
		if Variables[23] then
			C_Timer.After(ms, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
			ms = ms + 0.3
			C_Timer.After(ms, function(self) SendChatMessage(L["Lottery Draw Step 4 Announce Roll"], "GUILD") end)
			ms = ms + 10
		end
		C_Timer.After(ms, function(self)
			if not GLR_Global_Variables[3] then
				if not Variables[14] then
					LotteryDrawSearchInvalidTickets()
				else
					AdvancedLotteryFindWinner()
				end
			elseif GLR_Global_Variables[3] and not Variables[9] then
				local timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginLotteryDrawStep4() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginLotteryDrawStep4() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Lottery")
				Variables[9] = true
			end
		end)
	elseif GLR_Global_Variables[3] and not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginLotteryDrawStep4() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - BeginLotteryDrawStep4() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
		Variables[9] = true
	end
	
end

local function LotteryDrawGuildAndSecond() --Announces the percentage that the Guild and Second Place will receive.
	
	local guildPercent = tonumber(glrCharacter.Event.Lottery.GuildCut)
	local secondPercent = glrCharacter.Event.Lottery.SecondPlace
	
	if secondPercent ~= L["Winner Guaranteed"] then
		secondPercent = tonumber(secondPercent)
	end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if Variables[23] then
		if secondPercent == L["Winner Guaranteed"] and guildPercent > 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 1"] .. guildPercent .. L["Lottery Draw Step 3 Fixed Variable 1"], "GUILD") end)
		elseif secondPercent == L["Winner Guaranteed"] and guildPercent == 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 2"], "GUILD") end)
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent > 0 and secondPercent > 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 3 Guild Part"] .. guildPercent .. L["Lottery Draw Step 3 Fixed Variable 1"], "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 3"] .. secondPercent .. L["Lottery Draw Step 3 Fixed Variable 1"], "GUILD") end)
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent == 0 and secondPercent == 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Fixed Variable 3"], "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(L["Lottery Draw Step 3 Fixed Variable 2"], "GUILD") end)
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent == 0 and secondPercent > 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Fixed Variable 3"], "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 3"] .. secondPercent .. L["Lottery Draw Step 3 Fixed Variable 1"], "GUILD") end)
		elseif secondPercent ~= L["Winner Guaranteed"] and guildPercent > 0 and secondPercent == 0 then
			C_Timer.After(0.2, function(self) SendChatMessage(L["Lottery Draw Step 3 Condition 3 Guild Part"] .. guildPercent .. L["Lottery Draw Step 3 Fixed Variable 1"], "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(L["Lottery Draw Step 3 Fixed Variable 2"], "GUILD") end)
		end
	end
	
	C_Timer.After(12.4, function(self)
		if not GLR_Global_Variables[3] then
			BeginLotteryDrawStep4()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawGuildAndSecond() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawGuildAndSecond() - Draw Process Automatically Aborted")
			end
			AbortRollProcess("Lottery")
			Variables[9] = true
		end
	end)
	
end

local function LotteryDrawCountInvalidTickets() --If any Invalid Tickets exist, will announce as such.
	
	local ticketPool = {}
	local numberOfInvalidTickets = 0
	local lowestTicketNumber = glrCharacter.Event.Lottery.FirstTicketNumber
	local highestTicketNumber = glrCharacter.Event.Lottery.LastTicketBought - 1
	if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
		highestTicketNumber = CommaValue(glrCharacter.Event.Lottery.LastTicketBought - 1)
	end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	-- If Invalid Tickets exist in any way they'll be reported to Guild Chat
	if glrCharacter.Lottery.TicketPool ~= nil then
		if glrCharacter.Lottery.TicketPool[1] ~= nil then
			numberOfInvalidTickets = #glrCharacter.Lottery.TicketPool
		end
	end
	
	local timestamp = GetTimeStamp()
	if not GLR_Global_Variables[3] then
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawCountInvalidTickets() - Number of Invalid Tickets: " .. numberOfInvalidTickets)
	end
	
	if Variables[23] then
		if numberOfInvalidTickets > 0 then
			local message_1 = string.gsub(L["Draw Step 2 Invalid Tickets"], "%%unsold", CommaValue(numberOfInvalidTickets))
			local message_2 = string.gsub(string.gsub(L["Draw Step 2"], "%%low", lowestTicketNumber), "%%high", highestTicketNumber)
			C_Timer.After(0.2, function(self) SendChatMessage(message_1, "GUILD") end)
			C_Timer.After(0.4, function(self) SendChatMessage(message_2, "GUILD") end)
		else
			local message = string.gsub(string.gsub(L["Draw Step 2"], "%%low", lowestTicketNumber), "%%high", highestTicketNumber)
			C_Timer.After(0.2, function(self) SendChatMessage(message, "GUILD") end)
		end
	end
	
	if not GLR_Global_Variables[3] then
		C_Timer.After(12.2, function(self)
			if not GLR_Global_Variables[3] then
				LotteryDrawGuildAndSecond()
			elseif GLR_Global_Variables[3] and not Variables[9] then
				timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawCountInvalidTickets() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawCountInvalidTickets() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Lottery")
				Variables[9] = true
			end
		end)
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawCountInvalidTickets() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawCountInvalidTickets() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
		Variables[9] = true
	end
	
end

local function AdvancedLotteryStep1() --Generates the required number of Tickets and assigns them at random to entered players. Also announces as such to the Guild.
	
	local first = CommaValue(glrCharacter.Event.Lottery.FirstTicketNumber)
	local last = CommaValue(Variables[17] + glrCharacter.Event.Lottery.FirstTicketNumber - 1)
	local jackpotValue = GLR_U:GetMoneyValue(tostring(tonumber(glrCharacter.Event["Lottery"]["StartingGold"]) + ( glrCharacter.Event["Lottery"]["TicketsSold"] * tonumber(glrCharacter.Event["Lottery"]["TicketPrice"]) )), "Lottery", true, 1)
	local numberOfTickets = CommaValue(glrCharacter.Event.Lottery.TicketsSold)
	local message = string.gsub(string.gsub(L["Draw Step 1"], "%%TicketsSold", numberOfTickets), "%%money", jackpotValue)
	local timestamp = GetTimeStamp()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if Variables[23] and not GLR_Global_Variables[3] then
		C_Timer.After(0.2, function(self) SendChatMessage(message, "GUILD") end)
	end
	
	if not GLR_Global_Variables[3] then
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryStep1() - Number of Tickets Required: " .. Variables[17] .. " - Generated: " .. Variables[22][2][1] .. " Assigned: " .. Variables[22][2][11])
		
		-- If Tickets were given away it'll report to Guild Chat the number Given.
		if glrCharacter.Event.Lottery.GiveAwayTickets ~= nil then
			if glrCharacter.Event.Lottery.GiveAwayTickets > 0 and Variables[23] then
				local GivenTickets = tostring(glrCharacter.Event.Lottery.GiveAwayTickets)
				local message = L["Send Info GLR"] .. ": " .. string.gsub(L["Draw Given Tickets"], "%%t", CommaValue(GivenTickets))
				C_Timer.After(0.4, function(self) SendChatMessage(message, "GUILD") end)
			end
		end
		
	end
	
	if not GLR_Global_Variables[3] then
		
		if Variables[23] then
			local WinChanceValue = tostring(WinChanceTable[WinChanceKey] * 100)
			local message, _ = string.gsub(string.gsub(L["Advanced Draw Step 1"], "%%f", first), "%%l", last)
			local tickets, _ = string.gsub(string.gsub(L["Advanced Draw Step 1 Totals"], "%%t", CommaValue(Variables[22][2][1])), "%%c", CommaValue(Variables[22][2][11]))
			local chance, _ = string.gsub(L["Advanced Draw Step 1 Win Chance"], "%%c", WinChanceValue)
			C_Timer.After(0.6, function(self) SendChatMessage(chance, "GUILD") end)
			C_Timer.After(0.8, function(self) SendChatMessage(tickets, "GUILD") end)
			C_Timer.After(1, function(self) SendChatMessage(message, "GUILD") end)
		end
		C_Timer.After(12.8, function(self)
			if not GLR_Global_Variables[3] then
				LotteryDrawGuildAndSecond()
			elseif GLR_Global_Variables[3] and not Variables[9] then
				timestamp = GetTimeStamp()
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryStep1() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryStep1() - Draw Process Automatically Aborted")
				end
				AbortRollProcess("Lottery")
				Variables[9] = true
			end
		end)
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryStep1() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AdvancedLotteryStep1() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
		Variables[9] = true
	end
	
end

local function LotteryDrawAnnounceTickets() --Announces number of Tickets Sold & Given away.
	
	local jackpotGold = tostring(tonumber(glrCharacter.Event["Lottery"]["StartingGold"]) + ( glrCharacter.Event["Lottery"]["TicketsSold"] * tonumber(glrCharacter.Event["Lottery"]["TicketPrice"]) ))
	local jackpotValue = GLR_U:GetMoneyValue(jackpotGold, "Lottery", true, 1)
	local numberOfTickets = CommaValue(glrCharacter.Event.Lottery.TicketsSold)
	local message = string.gsub(string.gsub(L["Draw Step 1"], "%%TicketsSold", numberOfTickets), "%%money", jackpotValue)
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if Variables[23] then
		C_Timer.After(0.2, function(self) SendChatMessage(message, "GUILD") end)
	end
	
	if glrCharacter.Event.Lottery.GiveAwayTickets ~= nil then
		if glrCharacter.Event.Lottery.GiveAwayTickets > 0 and Variables[23] then
			local GivenTickets = tostring(glrCharacter.Event.Lottery.GiveAwayTickets)
			C_Timer.After(0.4, function(self) SendChatMessage(L["Send Info GLR"] .. ": " .. string.gsub(L["Draw Given Tickets"], "%%t", CommaValue(GivenTickets)), "GUILD") end)
		end
	end
	
	C_Timer.After(12.2, function(self)
		if not GLR_Global_Variables[3] then
			LotteryDrawCountInvalidTickets()
		elseif GLR_Global_Variables[3] and not Variables[9] then
			local timestamp = GetTimeStamp()
			if Variables[23] then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawAnnounceTickets() - Draw Process Manually Aborted")
			else
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - LotteryDrawAnnounceTickets() - Draw Process Automatically Aborted")
			end
			AbortRollProcess("Lottery")
			Variables[9] = true
		end
	end)
	
end

local AssignTicketsProgress = 0
local AssignTicketsProgressStep = 10

local function shuffle(array)
	local input = array
	local output = {}
	for i = #input, 1, -1 do
		local j = math.random(i)
		input[i], input[j] = input[j], input[i]
		table.insert(output, input[i])
	end
	return output
end

local function AssignTickets()
	
	-- Win Chance Values to Percentage: [1] = "90%", [2] = "80%", [3] = "70%", [4] = "60%", [5] = "50%", [6] = "40%", [7] = "30%", [8] = "20%", [9] = "10%"
	-- Each value determines the number of additional Tickets to generate, thereby adjusting the Win Chance
	-- Formula to generate the Total Number of Tickets is: n = Variables[17] * 10
	-- Formula to generate the Number of Tickets to Assign Per Player is: n = NumberOfTickets * WinChanceVariable * WinChanceTable[WinChanceKey]
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		
		local function FindNewNumberRange(n)
			for t, v in pairs(RandomizationTable[1]) do
				if not RandomizationTable[1][t] then
					if n < tonumber(t) then
						n = tonumber(t)
						break
					end
				end
			end
			return n
		end
		--Only need to set the number of tickets to assign once per player.
		if not Variables[22][3] then
			-- How many Tickets to assign to said Player
			Variables[22][2][6] = glrCharacter[Variables[22][2][12]].Entries.Tickets[RandomizationTable[3][Variables[22][2][3]]].NumberOfTickets
			if Variables[22][2][12] == "Lottery" then
				-- Modifed number to Assign if not a Guaranteed Winner Event
				Variables[22][2][6] = Variables[22][2][6] * WinChanceVariable * WinChanceTable[WinChanceKey]
			end
			-- New Player variables assigned, don't need to do so again.
			Variables[22][3] = true
		end
		
		--Starts at Zero when assigning tickets to a new Player, used to determine how many have successfully been assigned and how many are left to assign, capping at 10K per cycle.
		if Variables[22][2][9] == 0 then
			Variables[22][2][7] = Variables[22][2][6]
			if Variables[22][2][6] > 10000 then
				Variables[22][2][8] = 10000
			else
				Variables[22][2][8] = Variables[22][2][6]
			end
		elseif Variables[22][2][9] > 0 and Variables[22][2][9] < Variables[22][2][6] then
			local compare = Variables[22][2][6] - Variables[22][2][9]
			if compare > 10000 then
				Variables[22][2][8] = 10000
			else
				Variables[22][2][8] = compare
			end
		end
		local doBreak = 0
		-- Do this if not a Guaranteed Winner Event
		-- Begins attempting to assign tickets to the selected Player. Never does more than 10K attempts per cycle.
		for j = 1, Variables[22][2][8] do
			if Variables[22][2][9] == Variables[22][2][6] then break end
			local low = Variables[22][2][13]
			local r = tostring(math.random(low, Variables[22][2][2]))
			if not Variables[22][2][15] then
				if Variables[22][2][12] == "Raffle" and RandomizationTable[1][r] then
					--Because Raffles can never have any "empty" tickets, need to remove *some* randomness to save on the time it takes to assign all tickets.
					--It will only do this if the total tickets assigned is 97% of the total to assign.
					local v = math.floor(statusbar:GetValue() / Variables[22][2][10] * 1000) / 10
					if v >= 99.8 and RandomizationTable[3][Variables[22][2][3] + 1] == nil then
						--By this point only one person is left that needs tickets assigned so lets just hand out the remaining tickets
						for t, v in pairs(RandomizationTable[1]) do
							if not RandomizationTable[1][t] then
								doBreak = doBreak + 1
								r = tostring(t)
								break
							end
						end
					elseif v >= 97 then
						low = FindNewNumberRange(low)
						for i = 1, 50 do
							r = tostring(math.random(low, Variables[22][2][2]))
							if not RandomizationTable[1][r] then
								doBreak = doBreak + 1
								break
							end
						end
					end
				end
			else
				r = tostring(Variables[22][2][16])
			end
			if not RandomizationTable[1][r] then
				if Variables[22][2][15] then
					Variables[22][2][16] = Variables[22][2][16] + 1
				end
				Variables[22][2][9] = Variables[22][2][9] + 1
				Variables[22][2][11] = Variables[22][2][11] + 1
				Variables[22][2][7] = Variables[22][2][7] - 1
				RandomizationTable[1][r] = true
				RandomizationTable[2][r] = RandomizationTable[3][Variables[22][2][3]]
				if RandomizationTable[4][RandomizationTable[3][Variables[22][2][3]]] == nil then
					RandomizationTable[4][RandomizationTable[3][Variables[22][2][3]]] = {}
				end
				table.insert(RandomizationTable[4][RandomizationTable[3][Variables[22][2][3]]], r)
			end
			if doBreak >= 50 then break end
		end
		--Need to reset certain Variables once the player has received all of their tickets.
		if Variables[22][2][7] == 0 then
			Variables[22][2][3] = Variables[22][2][3] + 1
			Variables[22][2][9] = 0
			Variables[22][3] = false
		end
		
		if Variables[22][2][11] < Variables[22][2][10] then
			statusbar:SetValue(Variables[22][2][11])
			local v = math.floor(statusbar:GetValue() / Variables[22][2][10] * 1000) / 10
			statusbar_value:SetText(v .. "%")
			C_Timer.After(0.2, AssignTickets)
			AssignTicketsProgressStep = AssignTicketsProgressStep - 1
			if AssignTicketsProgressStep == 0 then
				AssignTicketsProgressStep = 5
				AssignTicketsProgress = AssignTicketsProgress + 1
				if AssignTicketsProgress == 1 then
					statusbar_progressText:SetText(".")
				elseif AssignTicketsProgress == 2 then
					statusbar_progressText:SetText("..")
				elseif AssignTicketsProgress == 3 then
					statusbar_progressText:SetText("...")
					AssignTicketsProgress = 0
				end
			end
		else
			statusbar:SetValue(Variables[22][2][10])
			statusbar_value:SetText("100%")
			statusbar_progressText:SetText("")
			AssignTicketsProgressStep = 10
			Variables[22][4][2] = true
		end
	elseif GLR_Global_Variables[3] and not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AssignTickets() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AssignTickets() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess(Variables[22][2][12]) end)
		Variables[9] = true
	end
	
end

local function GenerateTickets()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		for i = 1, Variables[22][2][4] do
			Variables[22][2][1] = Variables[22][2][1] + 1
			RandomizationTable[1][tostring(Variables[22][2][2])] = false
			Variables[22][2][5] = floor(Variables[22][2][5] - 1)
			if Variables[22][2][5] > 0 then
				Variables[22][2][2] = Variables[22][2][2] + 1
			end
		end
		if Variables[22][2][5] > 0 and Variables[22][2][5] >= 10000 then
			Variables[22][2][4] = 10000
		elseif Variables[22][2][5] > 0 and Variables[22][2][5] <= 10000 then
			Variables[22][2][4] = Variables[22][2][5]
		end
		if Variables[22][2][5] > 0 then
			C_Timer.After(0.2, GenerateTickets)
			statusbar:SetValue(Variables[22][2][1])
			local v = math.floor(statusbar:GetValue() / Variables[17] * 100)
			statusbar_value:SetText(v .. "%")
		else
			statusbar:SetValue(Variables[17])
			statusbar_value:SetText("100%")
			Variables[22][4][1] = true
		end
	elseif GLR_Global_Variables[3] and not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GenerateTickets() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GenerateTickets() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess(Variables[22][2][12]) end)
		Variables[9] = true
	end
	
end

local function GenerateTicketsBuffer()
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		if Variables[17] == 0 then
			Variables[17] = glrCharacter.Event[Variables[22][2][12]].TicketsSold + glrCharacter.Event[Variables[22][2][12]].GiveAwayTickets
		end
		if not Variables[22][1][1] then
			SendChatMessage("GLR: Generating & Assigning Ticket Numbers. This process may take some time.", "GUILD")
			--RandomizationTable[3]
			if Variables[22][2][12] == "Lottery" then
				
				WinChanceKey = glrCharacter.Data.Settings.Lottery.WinChanceKey
				if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
					Variables[17] = Variables[17] * WinChanceVariable
					WinChanceVariable = 10
				else
					-- Since a Winner is guaranteed, need to set the Key to 10 so it'll report as 100% to Guild Chat
					Variables[22][2][15] = true
					WinChanceKey = 10
					WinChanceVariable = 1
				end
				
				Variables[22][2][10] = Variables[17] * WinChanceTable[WinChanceKey]
				
				Frames[1].StatusBarFrame:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame, "BOTTOM", 0, -5)
				
			elseif Variables[22][2][12] == "Raffle" then
				
				Variables[22][2][10] = Variables[17]
				Variables[22][2][15] = true
				
				Frames[1].StatusBarFrame:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_RaffleFrame, "BOTTOM", 0, -5)
				
			end
			
			if Variables[17] > 10000 then
				Variables[22][2][4] = 10000
			else
				Variables[22][2][4] = Variables[17]
			end
			
			Variables[22][2][5] = Variables[17]
			Variables[22][2][3] = 1
			Variables[22][2][11] = 0
			Variables[22][3] = false
			
		end
		if Variables[22][4][1] then
			if not Variables[22][1][2] then
				Variables[22][1][2] = true
				statusbar:SetMinMaxValues(0, Variables[22][2][10])
				statusbar:SetValue(0)
				statusbar_value:SetText("0%")
				statusbar_text:SetText("Assigning Tickets:")
				C_Timer.After(1, AssignTickets)
			end
			if Variables[22][4][2] then
				C_Timer.After(5, function(self)
					if Variables[22][2][12] == "Lottery" then
						AdvancedLotteryStep1()
					else
						AdvancedRaffleDraw()
					end
					Frames[1].StatusBarFrame:Hide()
				end)
			else
				C_Timer.After(5, GenerateTicketsBuffer)
			end
		else
			if not Variables[22][1][1] then
				Variables[22][1][1] = true
				
				RandomizationTable = { [1] = {}, [2] = {}, [3] = glrCharacter[Variables[22][2][12]].Entries.Names, [4] = {}, }
				RandomizationTable[3] = shuffle(RandomizationTable[3])
				Variables[22][2][2] = glrCharacter.Event[Variables[22][2][12]].FirstTicketNumber
				Variables[22][2][13] = glrCharacter.Event[Variables[22][2][12]].FirstTicketNumber
				Variables[22][2][16] = glrCharacter.Event[Variables[22][2][12]].FirstTicketNumber
				Variables[22][2][1] = 0
				
				statusbar:SetMinMaxValues(0, Variables[17])
				statusbar:SetValue(0)
				statusbar_value:SetText("0%")
				statusbar_text:SetText("Generating Tickets:")
				Frames[1].StatusBarFrame:Show()
				
				C_Timer.After(1, GenerateTickets)
				C_Timer.After(5, GenerateTicketsBuffer)
			else
				C_Timer.After(5, GenerateTicketsBuffer)
			end
		end
	elseif GLR_Global_Variables[3] and not Variables[9] then
		local timestamp = GetTimeStamp()
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GenerateTicketsBuffer() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GenerateTicketsBuffer() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess(Variables[22][2][12]) end)
		Variables[9] = true
	end
	
end

local function InitiateRaffleRoll()
	
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:Disable() --Need to prevent a new event being started while a draw is active.
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Disable()
	GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
	GLR_GoToAddRafflePrizes:Hide()
	
	AssignTicketsProgress = 0
	statusbar_progressText:SetText("")
	
	glrCharacter.Data.Settings.General.AnnounceAutoAbort = true
	
	if GLR_UI.GLR_NewRaffleEventFrame:IsVisible() then
		GLR_UI.GLR_NewRaffleEventFrame:Hide()
	end
	
	local raffleStatus = glrCharacter.Data.Settings.CurrentlyActiveRaffle
	RandomizationTable = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, }
	raffleWinners = {} --Resets the table if entries exist
	EventTickets = {}
	GLR_Global_Variables[3] = false
	Variables[1][1] = false
	Variables[1][2] = false
	Variables[1][3] = false
	Variables[2][1] = false
	Variables[2][2] = false
	Variables[2][3] = false
	Variables[3][1] = false
	Variables[3][2] = false
	Variables[3][3] = false
	Variables[4][1] = ""
	Variables[4][2] = ""
	Variables[4][3] = ""
	Variables[7][2] = false
	Variables[8] = false
	Variables[9] = false
	Variables[14] = glrCharacter.Data.Settings.General.AdvancedTicketDraw
	Variables[17] = 0
	Variables[19] = false
	Variables[22][1][1] = false
	Variables[22][1][2] = false
	Variables[22][2][1] = 0
	Variables[22][2][2] = 0
	Variables[22][2][12] = "Raffle"
	Variables[22][2][15] = false
	Variables[22][4][1] = false
	Variables[22][4][2] = false
	
	if Frames[1].AddRafflePrizes:IsVisible() then Frames[1].AddRafflePrizes:Hide() end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if raffleStatus and glrCharacter.Event.Raffle ~= nil then --Prevents starting a non-existent raffle draw
		if glrCharacter.Event.Raffle.TicketsSold >= 1 or glrCharacter.Event.Raffle.GiveAwayTickets >= 1 then
			
			GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Show()
			local timestamp = GetTimeStamp()
			
			if not GLR_Global_Variables[3] then
				
				if glrCharacter.Event.Raffle.FirstPlace ~= false then Variables[2][1] = true end
				if glrCharacter.Event.Raffle.SecondPlace ~= false then Variables[2][2] = true end
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then Variables[2][3] = true end
				
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Started Event Draw. Advanced: [" .. string.upper(tostring(Variables[14])) .. "] - Tickets Sold: [" .. glrCharacter.Event.Raffle.TicketsSold .. "] - Tickets Given Away: [" .. glrCharacter.Event.Raffle.GiveAwayTickets .. "]")
				GLR_Global_Variables[6][2] = true --Prevents a raffle draw from occuring while one's in progress
				SendChatMessage("--------------------------------------------------", "GUILD")
				C_Timer.After(0.3, function(self) SendChatMessage(L["GLR Title with Version"] .. GLR_CurrentVersionString, "GUILD") end)
				if not Variables[14] then
					C_Timer.After(0.6, function(self) SendChatMessage(L["Begin Raffle Draw"], "GUILD") end)
				else
					C_Timer.After(0.6, function(self) SendChatMessage(L["Begin Advanced Raffle Draw"], "GUILD") end)
				end
				C_Timer.After(0.9, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				if not Variables[14] then
					C_Timer.After(15, function(self)
						if not GLR_Global_Variables[3] then
							BeginRaffleDrawStep1()
						elseif GLR_Global_Variables[3] and not Variables[9] then
							timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Automatically Aborted")
							end
							AbortRollProcess("Raffle")
							Variables[9] = true
						end
					end)
				else
					C_Timer.After(5, function(self)
						if not GLR_Global_Variables[3] then
							GenerateTicketsBuffer()
						elseif GLR_Global_Variables[3] and not Variables[9] then
							timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Automatically Aborted")
							end
							AbortRollProcess("Raffle")
							Variables[9] = true
						end
					end)
				end
			elseif GLR_Global_Variables[3] and not Variables[9] then
				if Variables[23] then
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Manually Aborted")
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateRaffleRoll() - Draw Process Automatically Aborted")
				end
				C_Timer.After(5, function(self) AbortRollProcess("Raffle") end)
				Variables[9] = true
			end
			
		end
		
	else
		GLR:Print(L["No Raffle Active"])
	end
	
end

local function InitiateLotteryRoll()
	
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:Disable() --Don't want to clear the data mid draw.
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Disable()
	GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	
	AssignTicketsProgress = 0
	statusbar_progressText:SetText("")
	
	glrCharacter.Data.Settings.General.AnnounceAutoAbort = true
	
	if GLR_UI.GLR_NewLotteryEventFrame:IsVisible() then
		GLR_UI.GLR_NewLotteryEventFrame:Hide()
	end
	
	if GLR_GoToAddRafflePrizes:IsVisible() then
		GLR_GoToAddRafflePrizes:Hide()
	end
	
	local lotteryStatus = glrCharacter.Data.Settings["CurrentlyActiveLottery"]
	local timestamp = GetTimeStamp()
	local update = false
	RandomizationTable = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, } --Resets table for Advanced Ticket Draws
	EventTickets = {}
	GLR_Global_Variables[3] = false
	Variables[6][1] = "NA"
	Variables[6][2] = "NA"
	Variables[7][1] = false
	Variables[9] = false
	Variables[10] = false
	Variables[11] = false
	Variables[12][1] = false
	Variables[12][2] = false
	Variables[13][1] = 0
	Variables[13][2] = 0
	Variables[14] = glrCharacter.Data.Settings.General.AdvancedTicketDraw
	Variables[17] = 0
	Variables[19] = false
	Variables[22][1][1] = false
	Variables[22][1][2] = false
	Variables[22][2][1] = 0
	Variables[22][2][2] = 0
	Variables[22][2][12] = "Lottery"
	Variables[22][2][15] = false
	Variables[22][4][1] = false
	Variables[22][4][2] = false
	
	glrCharacter.Data.Settings.Lottery.RollOverCheck = true
	
	local t = {}
	
	for i = 1, #glrCharacter.Lottery.Entries.Names do
		if glrCharacter.Lottery.Entries.Tickets[glrCharacter.Lottery.Entries.Names[i]].NumberOfTickets == 0 then
			glrCharacter.Lottery.Entries.TicketNumbers[glrCharacter.Lottery.Entries.Names[i]] = nil
			glrCharacter.Lottery.Entries.TicketRange[glrCharacter.Lottery.Entries.Names[i]] = nil
			glrCharacter.Lottery.Entries.Tickets[glrCharacter.Lottery.Entries.Names[i]] = nil
			table.insert(t, glrCharacter.Lottery.Entries.Names[i])
			table.insert(Variables[21].Lottery, glrCharacter.Lottery.Entries.Names[i])
			if not update then update = true end
		end
	end
	
	if glrCharacter.Data.Settings.Lottery.CarryOver then
		glrCharacter.Data.RollOver.Lottery.Names = glrCharacter.Lottery.Entries.Names
	else
		glrCharacter.Data.RollOver.Lottery = { ["Names"] = {}, ["Check"] = {}, }
	end
	
	if #t > 0 then
		for i = 1, #t do
			if t[i] ~= nil then
				local check = string.lower(t[i])
				for j = 1, #glrCharacter.Lottery.Entries.Names do
					if glrCharacter.Lottery.Entries.Names[j] ~= nil then
						if check == string.lower(glrCharacter.Lottery.Entries.Names[j]) then
							table.remove(glrCharacter.Lottery.Entries.Names, j)
							break
						end
					end
				end
			end
		end
	end
	
	if update then GLR:UpdatePlayersAndTotalTickets(true) end
	
	--While extremely unlikely, need to cover the eventuality that a Host might be muted during the event Draw.
	Variables[23] = C_GuildInfo.CanSpeakInGuildChat()
	--If the Host is unable to speak in Guild Chat the Draw is automatically aborted.
	--While it's impossible for the Host to START the Draw if they're muted, if they BECOME muted during a Draw it needs to be aborted.
	if not Variables[23] then
		GLR_Global_Variables[3] = true
	end
	
	if not GLR_Global_Variables[3] then
		if lotteryStatus and glrCharacter.Event.Lottery ~= nil then --Prevents starting a non-existent lottery draw
			if glrCharacter.Event.Lottery.TicketsSold >= 1 or glrCharacter.Event.Lottery.GiveAwayTickets >= 1 then
				GLR_UI.GLR_MainFrame.GLR_AbortRollProcessButton:Show()
				GLR_Global_Variables[6][1] = true --Prevents a lottery draw from occuring while one's in progress
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Started Event Draw. Advanced: [" .. string.upper(tostring(Variables[14])) .. "] - Tickets Sold: [" .. glrCharacter.Event.Lottery.TicketsSold .. "] - Tickets Given Away: [" .. glrCharacter.Event.Lottery.GiveAwayTickets .. "]")
				if Variables[23] then
					SendChatMessage("--------------------------------------------------", "GUILD")
					C_Timer.After(0.3, function(self) SendChatMessage(L["GLR Title with Version"] .. GLR_CurrentVersionString, "GUILD") end)
					if not Variables[14] then
						C_Timer.After(0.6, function(self) SendChatMessage(L["Begin Lottery Draw"], "GUILD") end)
					else
						C_Timer.After(0.6, function(self) SendChatMessage(L["Begin Advanced Lottery Draw"], "GUILD") end)
					end
					C_Timer.After(0.9, function(self) SendChatMessage("--------------------------------------------------", "GUILD") end)
				end
				if not Variables[14] then
					C_Timer.After(15, function(self)
						if not GLR_Global_Variables[3] then
							LotteryDrawAnnounceTickets()
						elseif GLR_Global_Variables[3] and not Variables[9] then
							timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Automatically Aborted")
							end
							AbortRollProcess("Lottery")
							Variables[9] = true
						end
					end)
				else
					C_Timer.After(5, function(self)
						if not GLR_Global_Variables[3] then
							GenerateTicketsBuffer()
						elseif GLR_Global_Variables[3] and not Variables[9] then
							timestamp = GetTimeStamp()
							if Variables[23] then
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Manually Aborted")
							else
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Automatically Aborted")
							end
							AbortRollProcess("Lottery")
							Variables[9] = true
						end
					end)
				end
			end
		else
			GLR:Print(L["No Lottery Active"])
		end
	elseif GLR_Global_Variables[3] and not Variables[9] then
		if Variables[23] then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Manually Aborted")
		else
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - InitiateLotteryRoll() - Draw Process Automatically Aborted")
		end
		C_Timer.After(5, function(self) AbortRollProcess("Lottery") end)
		Variables[9] = true
	end
	
end

-- local function AutoStartLotteryRoll()
	-- local t = GetServerTime()
	-- local Repeat = false
	-- if t ~= nil then
		-- local c = date("*t", t)
		-- if glrCharacter.Data.Settings.CurrentlyActiveLottery then
			-- local m = tonumber(string.sub(glrCharacter.Event.Lottery.Date, 1, 2))
			-- local d = tonumber(string.sub(glrCharacter.Event.Lottery.Date, 4, 5))
			-- local y = tonumber("20" .. string.sub(glrCharacter.Event.Lottery.Date, 7, 8))
			-- local h = tonumber(string.sub(glrCharacter.Event.Lottery.Date, 12, 13))
			-- local mn = tonumber(string.sub(glrCharacter.Event.Lottery.Date, 15, 16))
			-- if y == tonumber(c.year) then
				-- if m == tonumber(c.month) then
					-- if d == tonumber(c.day) then
						-- local dif = h - tonumber(c.hour)
						-- if dif == 0 then
							-- if mn == 0 then
								-- GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()
								-- InitiateLotteryRoll()
							-- else
								-- if mn == tonumber(c.min) then
									-- GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()
									-- InitiateLotteryRoll()
								-- else
									-- dif = mn - tonumber(c.min)
								-- end
							-- end
						-- else
							-- C_Timer.After(3600, function(self) AutoStartLotteryRoll() end)
						-- end
					-- end
				-- end
			-- end
		-- else
			-- C_Timer.After(60, function(self) AutoStartLotteryRoll() end)
		-- end
	-- else
		-- C_Timer.After(10, function(self) AutoStartLotteryRoll() end)
	-- end
-- end

-- do
	-- AutoStartLotteryRoll()
-- end

--Confirm Start Raffle Roll Button Settings
Frames[2].GLR_StartRaffleButton = CreateFrame("Button", "Frames[2].GLR_StartRaffleButton", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder, "GameMenuButtonTemplate")
Frames[2].GLR_StartRaffleButton:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder, "CENTER")
Frames[2].GLR_StartRaffleButton:SetSize(100, 26)
Frames[2].GLR_StartRaffleButton:SetScript("OnClick", function(self)
	InitiateRaffleRoll()
	GLR_UI.GLR_ScanMailButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_ConfirmStartRaffleBorder:Hide()
end)
Frames[2].GLR_StartRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm Start Raffle Button Tooltip"])
	GameTooltip:AddLine(L["Confirm Start Raffle Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
Frames[2].GLR_StartRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

	Frames[2].GLR_StartRaffleButton.Backdrop = CreateFrame("Frame", "Frames[2].GLR_StartRaffleButton.Backdrop", Frames[2].GLR_StartRaffleButton, "BackdropTemplate")
	Frames[2].GLR_StartRaffleButton.Backdrop:SetAllPoints()
	Frames[2].GLR_StartRaffleButton.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].GLR_StartRaffleButton.Backdrop:ApplyBackdrop()
	Frames[2].GLR_StartRaffleButton.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


--Confirm Start Lottery Roll Button Settings
Frames[2].GLR_StartLotteryButton = CreateFrame("Button", "Frames[2].GLR_StartLotteryButton", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder, "GameMenuButtonTemplate")
Frames[2].GLR_StartLotteryButton:SetPoint("CENTER", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder, "CENTER")
Frames[2].GLR_StartLotteryButton:SetSize(100, 26)
Frames[2].GLR_StartLotteryButton:SetScript("OnClick", function(self)
	InitiateLotteryRoll()
	GLR_UI.GLR_ScanMailButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Disable()
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_ConfirmStartLotteryBorder:Hide()
end)
Frames[2].GLR_StartLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm Start Lottery Button Tooltip"])
	GameTooltip:AddLine(L["Confirm Start Lottery Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
Frames[2].GLR_StartLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

	Frames[2].GLR_StartLotteryButton.Backdrop = CreateFrame("Frame", "Frames[2].GLR_StartLotteryButton.Backdrop", Frames[2].GLR_StartLotteryButton, "BackdropTemplate")
	Frames[2].GLR_StartLotteryButton.Backdrop:SetAllPoints()
	Frames[2].GLR_StartLotteryButton.Backdrop.backdropInfo = BackdropProfile.Buttons
	Frames[2].GLR_StartLotteryButton.Backdrop:ApplyBackdrop()
	Frames[2].GLR_StartLotteryButton.Backdrop:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))


--Confirm Start Lottery Roll Button String & Settings
Frames[3].GLR_StartLotteryButtonText = Frames[2].GLR_StartLotteryButton:CreateFontString("Frames[3].GLR_StartLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].GLR_StartLotteryButtonText:SetPoint("CENTER", Frames[2].GLR_StartLotteryButton)
Frames[3].GLR_StartLotteryButtonText:SetText(L["Confirm Start Button"])
Frames[3].GLR_StartLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Start Raffle Roll Button String & Settings
Frames[3].GLR_StartRaffleButtonText = Frames[2].GLR_StartRaffleButton:CreateFontString("Frames[3].GLR_StartRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
Frames[3].GLR_StartRaffleButtonText:SetPoint("CENTER", Frames[2].GLR_StartRaffleButton)
Frames[3].GLR_StartRaffleButtonText:SetText(L["Confirm Start Button"])
Frames[3].GLR_StartRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

local function CheckLocale()
	locale = GetLocale()
	if locale == nil then
		C_Timer.After(1, CheckLocale)
	else
		if locale == "frFR" then
			Frames[2].GLR_StartLotteryButton:SetSize(135, 26)
			Frames[2].GLR_StartRaffleButton:SetSize(135, 26)
		end
	end
end

if locale == nil then
	CheckLocale()
else
	if locale == "frFR" then
		Frames[2].GLR_StartLotteryButton:SetSize(135, 26)
		Frames[2].GLR_StartRaffleButton:SetSize(135, 26)
	end
end