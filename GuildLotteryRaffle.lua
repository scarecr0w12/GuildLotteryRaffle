GLR = LibStub("AceAddon-3.0"):NewAddon("GuildLotteryRaffle", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
local GLR_VersionString = "301025"
local GLR_VersionCheck = "3.1.25"

--[[
As of December 30th. 2020
Retail: 90002
Classic: 11306
]]

--[[

Reference Table:
* [WORKS]				- No testing required, confirmed it works. If a version number is shown, this is the version of the mod the bug was fixed for.
* [NOT WORKING]			- Needs testing and potential debug trace information (in Account save file) read. If a version number is shown, this is the version of the mod the bug was first reported.
* [TESTING]				- Needs confirmation that the feature works (or doesn't, and needs fixing).
* [PARTLY CONFIRMED]	- See end of line for which part needs confirmation as to whether it works or not.
* [REPORTED]			- Used for tracking when bugs are first reported; is followed by a version number.
* [FIXED]				- Used for tracking when bugs are fixed; is followed by a version number.
* [NEW]					- Denotes a new feature that's ready for testing, a version number shown tells which version of the mod this feature became active.
* [WIP]					- Work In Progress. Means feature is not release ready and will only be accessible through unofficial Alpha/Beta releases. Testing only needed at user discretion.

====================================
=========== Need Testing ===========
====================================

[NEW : TESTING] : v3.1.21-a.6
* New Slash Command: /glr status <name>
	Returns Event data of specified Character, allowing you to view basic Event info from your other Characters.
	Accepts both Partial or Full Player names.
	Example: You have three Characters under the same Account, one called "Tannadra-Area52" another called "TempusEteri-Area52", and a third on the Dalaran Realm called "TempusEteri-Dalaran"
		* Typing the following into text chat: /glr status tan
			This will return Event info for Tannadra-Area52 (assuming you have an active Event on them).
		* If you type: /glr status tempus
			If both Characters of that name have an Active Event, then a standard error message will present itself: "Detected Multiple Partial Names with Active Event"
				You will have to specify which Character with something like: /glr status tempuseteri-a
					This will return Event info for TempusEteri-Area52
			If however only one Character has an Active Event then it will work correctly.

[BUG : NOT WORKING] : [REPORTED : v3.1.16]
* Blizzard blocked the /who search function from being accessed automatically by mods.
	This has removed the ability for this mod to automatically send notification messages to Players entered into your Event if said Event is a Multi-Guild Event and said Player isn't in your Guild.
	Testing is still required to see if the use of this feature is blocked when adding Players that're not in the Host Player's Guild. As this may be considered a "Player" action and not automatic by a mod.
		This can be done by following these steps:
			1. Have one or more Guilds Linked to your Guild to create a Multi-Guild Event.
			2. Create a Event (Lottery or Raffle, doesn't matter which).
			3. Ensure a Player you wish to enter into this Event is Online AND NOT in your Guild.
			4. Manually enter this Player into your Event (through the Main UI).
			5. Repeat step 3 for a new Player, else remove the already entered Player to clear their entry.
			6. Have this Player send you the appropriate amount through the Mail and activate the Mail Scan button.
			7. Repeat steps 3 through 6 except have the Player be OFFLINE when adding them to your Event.

[NEW : NOT WORKING] : v3.1.15-b.8
* New Tooltip: Added to the Confirm button when creating new Lottery Events.
	Will read out as: "This Events Jackpot Starts At: X" where X is the amount entered into the Starting Amount fields and includes, if available, the carried over amount of the previous Lottery Event.
	X is also parsed through the GetMoneyValue function, example: 10000.4362 becomes 10,000g 43s 62c

[NEW : NOT WORKING] : v3.1.15-b.4
* The Lottery Confirmation button tooltip on the Donation Frame info has been updated to include the Silver, and Copper, amounts.
	This can be tested by opening the Lottery Donation window and entering any amount in the Gold/Silver/Copper fields (zero is allowed). Followed by hovering over the Confirm button which will display a Tooltip with the entered amount.

====================================
========= Testing Complete =========
====================================



====================================
=========== New Features ===========
=============== And ================
========== Quality of Life =========
====================================

[NEW : WORKING] : v3.1.20-a.9 - v3.1.21-a.1
* Time Format: With this new setting, using the Guild Alert system or any Ticket Message Info will report the time as either the 24-hour clock or 12-hour.
	Example: Event is set for January 20th @ 17:30
		- Time Format [1] returns: 17:30
		- Time Format [2] returns: 5:30 PM

[NEW : WORKS] : v3.1.18-a.9
* Users can now set their Advanced Lottery Events Win Chance.
	Win Chance only affects the chance a entered Players Ticket will be drawn as the Winning Ticket.
	This is done by the following (only applies to Advanced Events, non-Advanced are un-altered):
		* For every ONE Ticket a Player either Purchases or Receives (aka: Free), at Event Draw TEN are created
		* Out of the TEN that're created, the Player will receive X amount depending on Win Chance
		* Example: If the Win Chance is 70%, the Player will receive SEVEN out of the TEN Tickets per ONE Ticket they have.
			NOTE: This does not bring their total Tickets up to EIGHT, but rather they now have SEVEN ACTUAL Tickets.
		* The remaining THREE Tickets are NOT assigned to anyone and are considered "BLANK" or "LOSING" Ticket Numbers
	WinChanceTable = { [1] = 0.9, [2] = 0.8, [3] = 0.7, [4] = 0.6, [5] = 0.5, [6] = 0.4, [7] = 0.3, [8] = 0.2, [9] = 0.1, [10] = 1 }
	The Win Chance formula uses the above table and a KEY from 1 to 10, along with another VARIABLE which stays at 10 for non-Guaranteed Winner Events and at 1 otherwise.
	The formula which determines how many Tickets the Player will receive at Event Draw is:
		n = NumberOfTickets * WinChanceTable[KEY] * VARIABLE

[NEW : WORKS] : v3.1.18-a.1
* Players can now add custom Command Detection phrases. The default !lottery and such phrases are kept.
	Command Detection phrases beginning with ! will always send the target player information about the current Lottery or Raffle Event. Phrases beginning with ? will always send the target player information about a requested Player's tickets, ie: "?lottery Player-B" will always send Player-A information about Player-B.
	These custom phrases can be configured in the Interface Panel under Event Settings.
	The Default !lottery, !raffle, ?lottery, and ?raffle phrases can't be removed.
	When adding new phrases the prefix is NOT required as a phrase is meant for both the ! and ? prefix system. As such making a phrase like "!event" will require the Player requesting information to type "!!event" to get said information.

[NEW : WORKS] : v3.1.15-b.4
* Lottery Donations should now display both the Total Jackpot and the amount a First Place Winner will win (Takeaway) after the Guilds Cut.
	Easy to test, simply preform a Lottery Donation and if the amounts displayed are correctly shown as being different then this change works.
		- In the event that your Lottery has a Guild Cut of ZERO then the amounts displayed will be identical.

[NEW : WORKS] : v3.1.15-b.7
* The Event Draw feature has been overhauled with a new table containing the variables the feature utilizes.
	Simply running multiple types of test events will confirm whether it's working or not.
		Event Types to test for complete coverage:
			- Lottery with NO WINNERS
			- Lottery with First Place Winner
			- Lottery with Second Place Winner
			- Raffle with THREE Prizes AND THREE Winners
			- Advanced Event Draws of the Above.

[BUG : WORKS] : [REPORTED : v3.1.15-b.6] - [FIXED : v3.1.15-b.7]
* The %previous_jackpot variable for Second Place was calculated incorrectly when using the Alert Guild feature. This has been fixed.

[NEW : WORKS] : v3.1.15-b.3
* New Chat Command: [ /glr check ] or [ /glr checkinvalid ] or [ /glr check-invalid ]
	* Doing this chat command will manually trigger the feature that checks for Invalid Entries in your Events (ie: Users that have left your Guild in anyway are removed).
		This feature is already done automatically upon Login or Reload but can now be triggered manually.
	* To test this feature one simply has to do one of the above Chat Commands.
		* You will receive a text notification in the Chat Frame stating that it's scanning for Invalid Entries, followed by a confirmation message stating one of the following:
			* If more than one entry is invalid: Removing X Entries
			* If only one entry is invalid: Removing 1 Entry
			* If no entries were invalid: No Invalid Entries Were Found.
	Receiving any of the three above messages will confirm this feature works.

[NEW : WORKS] v3.1.15-b.2
* New table containing current and future Variables. Having the mod simply launch and work properly will confirm that this works.
	Running the following script in game will print out the variables (some will be different than default and this is a good thing):
		/run GLR:DoDebug()

[NEW : WORKS] : v3.1.14
* Config > Event Profile > Description of Starting Amount (lottery) and Ticket Price (both) should look like:
	Enter a amount for the AddOn to remember to start all future Events with.
	Values less than one gold are read as: 0.0575 - This becomes 5 Silver and 75 Copper

[WORKS] : v3.1.14
* Setting a profile with a Ticket Price of 1.03546 should become 1.0455 in the Config area.
	Setting a profile with a Ticket Price / Starting Amount of the above for either Lottery/Raffle should allow a person creating new Events to automatically start with this Amount.
	Setting a profile with a Ticket Price / Starting Amount of 0 should cause the respective fields to automatically set to zero when creating new Events.

[NEW : WORKS] : v3.1.14
* Starting a new Event and leaving any field where an amount of money is entered as blank should give a more descriptive warning text.
	If two or more fields of the same type are empty it should display the correct "Value Must Be Zero or Higher" text.
		In the following order the text will be displayed:
			If more than one field is left blank: All Currency Fields Must Be Zero or Higher
			Blank Copper: Copper Value Must Be Zero or Higher
			Blank Silver: Silver Value Must Be Zero or Higher
			Blank Gold: Gold Value Must Be Zero or Higher

[NEW : WORKS] : v3.1.14
* The "/glr minimap" command has changed.
	"/glr minimap toggle" now toggles its visibility.
	"/glr minimap (x,y)" should now set the Minimap Icons coordinates in relation to the center of the minimap.
		The Parentheses and Comma are required for this to work.
		Example: /glr minimap (-15,20)
			This will change the Minimap Icon's position 15 to the left and 20 up from the center of the Minimap.

[NEW : WORKS] : v3.1.13
* Initialization Debug line changed to state which version of the Mod is run for better reading of the Debug table.

====================================
============ Known Bugs ============
====================================

[BUG : WORKS] : [REPORTED: v3.1.15-b.2] - [FIXED: v3.1.18]
* Giveaway Feature: Selecting the option to give Everyone Free Tickets was returning Zero Valid Entries. This should now be fixed. In the event it is not fixed, simply doing a /reload and uploading the ACCOUNT save file will provide newly added debug information to help trace the source of the bug.
	v3.1.15-b.8 - Added more information that's traced for debug purposes. Minor tweak to the logic behind how it gets the number of valid entries.
	Test Criteria: The number of Valid Entries should match under all conditions (Giveaway Type & Online Status)

[BUG : WORKS] : [REPORTED: v3.1.18-a.3] - [FIXED: v3.1.18-a.6]
* Having a Lottery Event where ticket prices started as 1 Copper would cause the AddOn to report the Guild Cut and Second Place as a percentage of that 1 Copper.
	IE: 1e-06G would mean 0.000001 Gold which is One-Hundredth of 1 Copper.
	Lottery Events should no longer report any value of less than 1 Copper.

[BUG : WORKS] : [REPORTED : v3.1.10] - [FIXED : v3.1.17]
* Localization for French language apparently isn't working.
	Potential fix has been made by converting data that used to be stored in the users local language into localization-independent language (English).
		This can be tested by Non-French speaking users by:
			* Running WoW in English with this mod enabled.
			* Exit WoW.
			* Open the Blizzard Battle.Net App
			* Open the Settings window (accessed by clicking the Blizzard Icon in the Top-Left)
			* Go to Game Settings
			* Change the Text Language of WoW to Français.
				- This will require a download.
			* Launch WoW after the download is complete, enter the game on a Character with this mod enabled.
				- If their are no errors and you're able to use the mod as normal then this has been fixed.
				- Even with no Lua errors, if the names displayed as Entries for your current Event are colored RED; this is an error on its own.
				- Upload the ACCOUNT save file if errors occur.

[BUG : WORKS] : [REPORTED : v3.1.16] - [FIXED : v3.1.17]
* Doing a fresh install of the mod would throw a one-time error upon logging in declaring the glrHistory.Debug table as nil. This is now fixed.

[BUG : WORKS] : [REPORTED : v3.1.16] - [FIXED : v3.1.18]
* Calendar Event creation was disabled accidently for everyone and unable to change. This was caused by inadvertantly calling the incorrect value to check against when determining if the user is running the current version of WoW.
	* Was thought to have been fixed in v3.1.17 and is now actually fixed for v3.1.18 - A certain variable was being called incorrectly.

[BUG : MAYBE WORKING] : [REPORTED : v3.1.15-b.6] - [FIXED : v3.1.15-b.7]
* LibWho Library was throwing errors. This bug had a low chance of occurring as certain functions within it called an API which will be deprecated in the next expansion.
	It'll be very hard to confirm this bug as fixed, as such it has been labeled as "MAYBE WORKING"
	Once the mod has been confirmed as working with the updated Library this will be moved to Known Bugs to keep a record of in the event it occurs again.
	The LibWho Library has been updated to the latest release version from https://www.wowace.com/projects/wholib/files
	Author Notes: The function name in the new Library File is located at line 928 called lib:ProcessWhoResults() Original source of error was the GetNumWhoResults() call.

[BUG : WORKS] : [REPORTED : v3.1.15-b.7] - [FIXED : v3.1.15-b.8]
* Under certain conditions, when creating Events, the "Please select a valid Date" error was presenting when it shouldn't.
	This turned out to be a case of the mod not correctly labeling the "bpyass" boolean to true when the Event is scheduled for the same day but the Hour selected was greater than the current Hour.

[BUG : WORKS] : [REPORTED : v3.1.15-b.1] - [FIXED : v3.1.15-b.2]
* Event Information for the Advanced Ticket Draw system wasn't being saved properly and was resulting in the Second Place Winner's Ticket Number being lost.
	This should be fixed.
	To make sure the mod is working properly. I'd suggest installing this version (v3.1.15-b.2) and running some test events on a character that currently has no active Events. Both the Regular and Advanced Ticket Draw.
		To thoroughly test it:
			* Create a Event. Max Tickets, Ticket Cost do not matter.
				* If creating the Event for the purpose of generating a winner, Guarantee Winner can be enabled.
			* Have at least 10 Total Tickets either Sold or Given, doesn't matter which as we're just creating a small buffer and giving the mod a chance to draw from both a First and Second Place Winner.
			* Run the Event Draw.
			* Once the Draw is complete. What we're looking for is making sure the Ticket Information for the Previous Event Winner (one you just finished) was saved properly so Create another Event then click the Alert Guild button (make sure you have the %previous_winner variable in your Alert Message).
			* Repeat the above until the following are met:
				* Regular Event Draw with a Winner
				* Regular Event Draw with NO Winner
				* Advanced Event Draw with a Winner
				* Advanced Event Draw with NO Winner
	* Once the above are complete then it's safe to complete any current Events. If any errors occur along the way, upload the Account AND Character save file after doing either a reload or logging out of WoW.

[BUG : WORKS] : [REPORTED : v3.1.13] - [FIXED : v3.1.15]
* Lottery Donation
	When donating values less than one gold the process would not finish. Needs testing on either Retail or Classic (when it works on one, it'll work on the other).

[FIXED] : v3.1.14
* Classic: Event with Ticket cost of 75 Silver. Add self with one ticket, then mail self with 1 Gold 50 Silver. Scan mailbox should detect two tickets worth.

[FIXED] : v3.1.14
* Currently no fix for the Minimap Icon issue where attempting to move it with the mouse causes it to get stuck in a tight circle centered on the minimap.
	However some Debug information has been added so doing so should give some information.

====================================
========= WORK IN PROGRESS =========
====================================

[WIP] - No features to test. No framework built yet.
* Give random people a number of tickets based on a value of donated money; or giveaway free tickets to random people.

How it will work:
	- Starts from a new frame. Possibly a dynamically changing (in size) frame based on information required.
	- User selects which active Event (Lottery or Raffle)
		- Need to tell if it's a Multi-Guild Event or not. If it is, need to gather rank information from linked guilds.
	- Need to determine if the tickets given are free or not (check box). If they aren't free a input box will appear

]]

GLR_Core = {}
--GLR_Libs = {}
GLR_Version = GetAddOnMetadata("GuildLotteryRaffle", "Version")
GLR_CurrentVersionString = GLR_Version
--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
--GLR_Libs.WhoLib = LibStub:GetLibrary("LibWho-2.0")
---------
-- |cfff7ff4d -The Color Code
-- 0.97, 1, 0.30 -The SetText Color Code

glrHistory = glrHistory or {}
glrCharacter = glrCharacter or {}
glrTemp = glrTemp or {} --Temp table that releases all info upon each login, used to hold Ticket Numbers to send to players
glrTempStatus = glrTempStatus or {}

GLR_Core.Font = "Interface\\AddOns\\GuildLotteryRaffle\\Fonts\\PT_Sans_Narrow.TTF"
GLR_Core.ButtonFont = "Interface\\AddOns\\GuildLotteryRaffle\\Fonts\\Intro_Black.TTF"

if GLR_Global_Variables[4] ~= nil then
	if GLR_Global_Variables[4] == "zhCN" then
		GLR_Core.Font = "FONTS\\ARKai_T.TTF"
		GLR_Core.ButtonFont = "FONTS\\ARKai_T.TTF"
	end
end

local raffleTicketNumbersTable = {}
local raffleWinners = {}
local scannedMailExtraGold = {}
glrUpdateTickets = {}
glrScannedMail = {}

GLR_CreateCalendarEvents = false

local Variables = {
	true,												-- [1]	[CRITICAL UPDATE]		Preforms a vital check of the mod. If the user has not restarted WoW when updating to a new version of the mod this will cause the #2 variable to become true; stopping the mod completely and preventing errors from occurring.
	false,												-- [2]	[STOP]					Becomes True if #1 variable is True AND their's a mismatch of the users version number with the current number; preventing errors from occurring. The user will have to Restart WoW at this point to continue using the mod.
	false,												-- [3]	[ADDON LOADED]			Becomes True once the mod has completed the GLR.Activation function.
	false,												-- [4]	[GUILD CHECK]			Becomes True during the Initialization process if GLR_U:CheckGuildName() comes back as True
	true,												-- [5]	[CLUB INFO]				When using ClubInfo, will be set to false. Allows for gathering of Guild Roster data in another format (currently not used, so left as true so it skips this process).
	false,												-- [6]	[FINAL GUILD CHECK]		Acts as a final boolean variable for the Initialization process and becomes True once that process is complete.
	0,													-- [7]	[INIT COUNT]			Numerical value that increases every second to allow for the Initialization process to not begin until at least 10 seconds have passed; this is due to the data that WoW provides not being available instantly upon Login.
	true,												-- [8]	[!MSG DETECT]			Used to determine whether the mod processes the detection of chat messages such as !lottery via Guild/Private Chat.
	true,												-- [9]	[?MSG DETECT]			Same as #8 but for detecting the ?lottery or ?raffle variable.
	"",													-- [10]	[FRAME STATE]			Determines which frame to show when displaying the main UI.
	"",													-- [11] [JACKPOT AMOUNT]		Becomes the new Starting Jackpot Amount for use in Tooltip information when creating new Lottery Events.
	{													-- [12] Class Colors
		["NA"] = "FF0000",								--		Error Catch
		["WARRIOR"] = "C79C6E",							--		Warrior
		["PALADIN"] = "F58CBA",							--		Paladin
		["HUNTER"] = "ABD473",							--		Hunter
		["ROGUE"] = "FFF569",							--		Rogue
		["PRIEST"] = "FFFFFF",							--		Priest
		["DEATHKNIGHT"] = "C41F3B",						--		Death Knight
		["SHAMAN"] = "0070DE",							--		Shaman
		["MAGE"] = "69CCF0",							--		Mage
		["WARLOCK"] = "9482C9",							--		Warlock
		["MONK"]  = "00FF96",							--		Monk
		["DRUID"]  = "FF7D0A",							--		Druid
		["DEMONHUNTER"]  = "A330C9",					--		Demon Hunter
	},													--
	{ 													-- [13] Certain Error Catching Variables
		0,												--		[1] - Error Count when checking New Lottery Event Info.
	},													--
	{													-- [14] Raffle Prizes for use in the Confirm button Tooltip
		false,											--		[1] First Place
		false,											--		[2] Second Place
		false,											--		[3] Third Place
	},													--
	false,												-- [15] Boolean gate. Becomes TRUE while it checks if Raffle Prizes are valid.
	{													-- [16] Acts as buffer for displaying New Raffle Prize values of over 10mil
		[1] = { false, false, false, },					--		[1] Becomes true if the entered value is greater than 10mil.
		[2] = { 0, 0, 0, },								--		[2] Becomes the original value entered, acting as a buffer.
	},													--
	{													-- [17] Custom Whisper Variables
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

local PlayerName = GetUnitName("PLAYER", false)
local FullPlayerName = (GetUnitName("PLAYER", false) .. "-" .. string.gsub(string.gsub(GetRealmName(), "-", ""), "%s+", ""))
local PlayerRealmName = string.sub(FullPlayerName, string.find(FullPlayerName, "-") + 1)

local L = LibStub("AceLocale-3.0"):GetLocale("GuildLotteryRaffle")
local chat = DEFAULT_CHAT_FRAME
local Initalizeation = CreateFrame("Frame")
local ScanMailFrame = CreateFrame("Frame")
local configUI = LibStub("AceConfig-3.0")
local dialog = LibStub("AceConfigDialog-3.0")
--Holds Raffle Prize Data when setting a new Raffle, which is then transfered to the save data file.
holdRaffleInfo = { ["FirstPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" }, ["SecondPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" }, ["ThirdPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" } }

local ClassColor = {
	["NA"] = { 1.0, 0, 0 }, --Catches any labeled as such, preventing errors.
	["WARRIOR"] = { 0.78, 0.61, 0.43 },
	["PALADIN"] = { 0.96, 0.55, 0.73 },
	["HUNTER"] = { 0.67, 0.83, 0.45 },
	["ROGUE"] = { 1.0, 0.96, 0.41 },
	["PRIEST"] = { 1.0, 1.0, 1.0 },
	["DEATHKNIGHT"] = { 0.77, 0.12, 0.23 },
	["SHAMAN"] = { 0.0, 0.44, 0.87 },
	["MAGE"] = { 0.41, 0.80, 0.94 },
	["WARLOCK"] = { 0.58, 0.51, 0.79 },
	["MONK"] = { 0, 1, 0.59 }, --{ 0.33, 0.54, 0.52 },
	["DRUID"] = { 1.0, 0.49, 0.04 },
	["DEMONHUNTER"] = { 0.64, 0.19, 0.79 },
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
		cache = {},
		check = {},
		scripts = {
			OnDragStart = true,
			OnDragStop = true,
			OnEnter = true,
			OnEvent = true,
			OnKeyDown = true,
			OnKeyUp = true,
			OnLeave = true,
			OnLoad = true,
			OnMouseDown = true,
			OnMouseUp = true,
			OnMouseWheel = true,
			OnReceiveDrag = true,
			OnSizeChanged = true,
			OnUpdate = true,
			OnClick = true,
		},
	},
	buttons = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		miniEdge = 4,
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

local BackdropProfile = {
	Buttons = {
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 13,
		insets = { left = 5 , right = 5 , top = 5 , bottom = 5 },
	}
}

local NewUpdateFrame = CreateFrame("Frame", "GLR_NewUpdateFrame", UIParent, "InsetFrameTemplate3")
NewUpdateFrame:SetPoint("CENTER", UIParent)
NewUpdateFrame:SetSize(190, 60)
NewUpdateFrame:EnableMouse(true)
NewUpdateFrame:SetResizable(false)
NewUpdateFrame:Hide()

local NewUpdateFrameCloseButton = CreateFrame("Button", "GLR_NewUpdateFrameCloseButton", NewUpdateFrame, "UIPanelCloseButton")
NewUpdateFrameCloseButton:SetPoint("TOPRIGHT", NewUpdateFrame, "TOPRIGHT", 3, 3)

local NewUpdateFrameTitle = NewUpdateFrame:CreateFontString("NewUpdateFrameTitle", "OVERLAY", "GameFontNormalSmall")
NewUpdateFrameTitle:SetPoint("TOP", NewUpdateFrame, "TOP", 0, -5)
NewUpdateFrameTitle:SetText(L["Guild Lottery & Raffles"])
NewUpdateFrameTitle:SetFont(GLR_Core.Font, 12)

local NewUpdateFrameText = NewUpdateFrame:CreateFontString("NewUpdateFrameText", "OVERLAY", "GameFontNormalSmall")
NewUpdateFrameText:SetPoint("CENTER", NewUpdateFrame, "CENTER", 0, -8)
NewUpdateFrameText:SetText(L["GLR - UI > UpdateFrame - New Update"] .. ".")
NewUpdateFrameText:SetFont(GLR_Core.ButtonFont, 14)

local function NewUpdate()
	NewUpdateFrame:Show()
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
				text = "12:" .. m .. " AM"
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

local function CheckForGivenOrSold()
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		local count = 0
		for i = 1, #glrCharacter.Lottery.Entries.Names do
			local name = glrCharacter.Lottery.Entries.Names[i]
			if glrCharacter.Lottery.Entries.Tickets[name].Given == nil then
				glrCharacter.Lottery.Entries.Tickets[name].Given = 0
			end
			if glrCharacter.Lottery.Entries.Tickets[name].Sold == nil then
				glrCharacter.Lottery.Entries.Tickets[name].Sold = glrCharacter.Lottery.Entries.Tickets[name].NumberOfTickets
				count = count + glrCharacter.Lottery.Entries.Tickets[name].Sold
			end
			if count > glrCharacter.Event.Lottery.TicketsSold then
				local diff = count - glrCharacter.Event.Lottery.TicketsSold
				glrCharacter.Lottery.Entries.Tickets[name].Sold = glrCharacter.Lottery.Entries.Tickets[name].Sold - diff
				glrCharacter.Lottery.Entries.Tickets[name].Given = diff
			end
		end
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		local count = 0
		for i = 1, #glrCharacter.Raffle.Entries.Names do
			local name = glrCharacter.Raffle.Entries.Names[i]
			if glrCharacter.Raffle.Entries.Tickets[name].Given == nil then
				glrCharacter.Raffle.Entries.Tickets[name].Given = 0
			end
			if glrCharacter.Raffle.Entries.Tickets[name].Sold == nil then
				glrCharacter.Raffle.Entries.Tickets[name].Sold = glrCharacter.Raffle.Entries.Tickets[name].NumberOfTickets
				count = count + glrCharacter.Raffle.Entries.Tickets[name].Sold
			end
			if count > glrCharacter.Event.Raffle.TicketsSold then
				local diff = count - glrCharacter.Event.Raffle.TicketsSold
				glrCharacter.Raffle.Entries.Tickets[name].Sold = glrCharacter.Raffle.Entries.Tickets[name].Sold - diff
				glrCharacter.Raffle.Entries.Tickets[name].Given = diff
			end
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
--GetMoneyValue(Total, Event, Check, Round, Target, IsString, Color)
local DataString = '"'
local function TrimString(value) --Trims the value string down so as not to display a value smaller than one copper. IE: 100.84526 becomes 100.8452 (doesn't round up)
	value = tostring(value)
	if string.find(value, "%.") ~= nil then
		local check = string.sub(value, string.find(value, "%.") + 5)
		if check ~= nil then
			if check ~= "" then
				value = string.sub(value, 1, string.find(value, "%.") + 4)
			end
		end
	end
	return value
end

local function GetDataString(ExportType)
	DataString = '"'
	local UnsoldTickets = 0
	local key = glrCharacter.Data.Settings.General.ExportTypeKey
	for i = 1, #glrCharacter.PreviousEvent[ExportType].Data.TicketPool do
		UnsoldTickets = UnsoldTickets + 1
	end
	local t = {}
	for i = 1, #glrCharacter.PreviousEvent[ExportType].Data.Entries.Names do
		table.insert(t, glrCharacter.PreviousEvent[ExportType].Data.Entries.Names[i])
	end
	sort(t)
	if ExportType == "Lottery" then
		local round = glrCharacter.PreviousEvent[ExportType].Settings.RoundValue
		local FirstStatus = glrCharacter.PreviousEvent[ExportType].Settings.WonType[1]
		local SecondStatus = glrCharacter.PreviousEvent[ExportType].Settings.WonType[2]
		local jackpotGold = tonumber(glrCharacter.PreviousEvent[ExportType].Settings.StartingGold) + tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice) * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold)
		local secondPlaceGold = glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace
		if tonumber(glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace) ~= nil then
			secondPlaceGold = ( tonumber(glrCharacter.PreviousEvent[ExportType].Settings.StartingGold) + tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice) * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) ) * ( tonumber(glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace) / 100 )
		end
		local startingGold = tonumber(glrCharacter.PreviousEvent[ExportType].Settings.StartingGold)
		local ticketPrice = tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice)
		local MaximumTickets = glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets
		local EventsName = glrCharacter.PreviousEvent[ExportType].Settings.EventName
		local jackpot = tostring(jackpotGold)
		local start = tostring(startingGold)
		local ticketPrices = ticketPrice
		local second = tostring(secondPlaceGold)
		if tonumber(secondPlaceGold) ~= nil and glrCharacter.Data.Settings.General.ExportFormatKey == 1 then
			second = GLR_U:GetMoneyValue(secondPlaceGold, "Lottery", true, round)
		end
		local GuildAmount = ( ( tonumber(glrCharacter.PreviousEvent[ExportType].Settings.StartingGold) + tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice) * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) ) * ( tonumber(glrCharacter.PreviousEvent[ExportType].Settings.GuildCut) / 100 ) )
		local GuildValue = GuildAmount
		local NoGuildAmount = glrCharacter.PreviousEvent[ExportType].Settings.NoGuildCut
		if glrCharacter.Data.Settings.General.ExportFormatKey == 1 then
			jackpot = GLR_U:GetMoneyValue(jackpotGold, "Lottery", true, 1)
			start = GLR_U:GetMoneyValue(startingGold, "Lottery", false)
			ticketPrices = GLR_U:GetMoneyValue(ticketPrice, "Lottery", false)
			GuildValue = GLR_U:GetMoneyValue(GuildAmount, "Lottery", true, round)
		else
			jackpot = TrimString(jackpot)
			start = TrimString(start)
			GuildValue = TrimString(GuildValue)
			second = TrimString(second)
		end
		local WonAmount = ""
		local WonValue = ""
		local EventDate = glrCharacter.PreviousEvent[ExportType].Settings.Date
		if glrCharacter.Data.Settings.General.ExportHeader then
			if key == 1 then
				DataString = '"' .. "Player Name" .. '","' .. "Date" .. '","' .. "Ticket Price" .. '","' .. "Tickets" .. '","' .. "Max Tickets" .. '","' .. "Starting Amount" .. '","' .. "Jackpot" .. '","' .. "Second Place" .. '","' .. "Ticket Series" .. '","' .. "Winning #" .. '","' .. "Unsold Tickets" .. '"'
				DataString = DataString .. '\n"' .. "Event Info For: " .. glrCharacter.PreviousEvent[ExportType].Settings.EventName .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.Date .. '","' .. ticketPrices .. '","' .. "Sold: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) .. " Given: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.GiveAwayTickets) .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets .. '","' .. start .. '","' .. jackpot .. '","' .. second .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.FirstTicketNumber) .. '","' .. glrCharacter.PreviousEvent[ExportType].Data.Winner .. '","' .. UnsoldTickets .. '"'
			else
				DataString =  '"' .. "Player Name" .. '","' .. "Date" .. '","' .. "Tickets Bought" .. '","' .. "Ticket Price" .. '","' .. "Tickets Given" .. '","' .. "Ticket Series" .. '","' .. "Max Tickets" .. '","' .. "Winning #" .. '","' .. "Winner" .. '","' .. "Starting Amount" .. '","' .. "Jackpot" .. '","' .. "Guild Cut" .. '","' .. "Second Place" .. '","' .. "Event Name" .. '"'
			end
			DataString = DataString .. '\n"'
		elseif key == 1 then
			DataString = '"' .. "Event Info For: " .. glrCharacter.PreviousEvent[ExportType].Settings.EventName .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.Date .. '","' .. ticketPrices .. '","' .. "Sold: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) .. " Given: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.GiveAwayTickets) .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets .. '","' .. start .. '","' .. jackpot .. '","' .. second .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.FirstTicketNumber) .. '","' .. glrCharacter.PreviousEvent[ExportType].Data.Winner .. '","' .. UnsoldTickets .. '"'
			DataString = DataString .. '\n"'
		end
		local WinnerFound = false
		local ValuesSaved = false
		for i = 1, #t do
			local Winner = false
			local name = t[i]
			local TicketsBought = "0"
			local TicketsGiven = "0"
			if glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Sold > 0 then
				TicketsBought = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Sold)
			end
			if glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given > 0 then
				TicketsGiven = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given)
			end
			local range = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.TicketRange[name].LowestTicketNumber) .. "-" .. tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.TicketRange[name].HighestTicketNumber)
			if not WinnerFound then -- Saves on processing power once the winner is found.
				if not ValuesSaved then
					ValuesSaved = true
					WonAmount = jackpotGold
					if FirstStatus then
						WonAmount = jackpotGold - (jackpotGold * (tonumber(glrCharacter.PreviousEvent[ExportType].Settings.GuildCut) / 100))
					elseif SecondStatus then
						WonAmount = jackpotGold * (tonumber(glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace) / 100)
					end
					if glrCharacter.Data.Settings.General.ExportFormatKey == 1 then
						if FirstStatus then
							WonValue = GLR_U:GetMoneyValue(WonAmount, "Lottery", true, 1)
						elseif SecondStatus then
							WonValue = GLR_U:GetMoneyValue(WonAmount, "Lottery", true, round)
						else
							WonValue = GLR_U:GetMoneyValue(WonAmount, "Lottery", true, 1)
						end
					else
						WonAmount = TrimString(WonAmount)
						WonValue = WonAmount
					end
				end
				if name == glrCharacter.PreviousEvent[ExportType].Data.WinnerName then
					Winner = true
					WinnerFound = true
				end
			end
			if Winner then
				if key == 1 then
					DataString = DataString .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","Winner!","' .. WonValue .. '"'
				else
					DataString = DataString .. name .. '","' .. EventDate .. '","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","' .. ticketPrices .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given) .. '","' .. range .. '","' .. MaximumTickets .. '","' .. glrCharacter.PreviousEvent[ExportType].Data.Winner .. '","' .. WonValue .. '","' .. start .. '","' .. jackpot .. '","' .. GuildValue .. '","' .. "-" .. '","' .. EventsName .. '"'
				end
			else
				if key == 1 then
					DataString = DataString .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","",""'
				else
					DataString = DataString .. name .. '","' .. EventDate .. '","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","' .. ticketPrices .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given) .. '","' .. range .. '","' .. MaximumTickets .. '","' .. "-" .. '","' .. "-" .. '","' .. "-" .. '","' .. "-" .. '","' .. "-" .. '","' .. "-" .. '","' .. EventsName .. '"'
				end
			end
			if t[i + 1] ~= nil then
				DataString = DataString .. '\n"'
			end
		end
		if key == 1 then
			DataString = DataString .. '\n"'
			if not WinnerFound and NoGuildAmount then
				GuildAmount = 0
			end
			if glrCharacter.Data.Settings.General.ExportFormatKey == 1 then
				GuildValue = GLR_U:GetMoneyValue(GuildAmount, "Lottery", true, round)
			else
				GuildValue = GuildAmount
			end
			DataString = DataString .. '","","","","","","","","","Guilds Cut:","' .. GuildValue .. '"'
		end
	elseif ExportType == "Raffle" then
		local function ParsePrize(prize)
			if string.lower(prize) == "%raffle_total" then
				prize = glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice)
			elseif string.lower(prize) == "%raffle_half" then
				prize = glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice) * 0.5
			elseif string.lower(prize) == "%raffle_quarter" then
				prize = glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold * tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice) * 0.25
			end
			if tonumber(prize) ~= nil then
				prize = GLR_U:GetMoneyValue(tonumber(prize), "Raffle", false, 1)
			end
			return prize
		end
		local First = ParsePrize(glrCharacter.PreviousEvent[ExportType].Settings.FirstPlace) .. " (" .. glrCharacter.PreviousEvent[ExportType].Data.FirstWinner .. ")"
		local Second = "None"
		local Third = "None"
		local Max = 1
		local EventDate = glrCharacter.PreviousEvent[ExportType].Settings.Date
		local TicketCost = tonumber(glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice)
		local MaxTicket = glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets
		local Event = glrCharacter.PreviousEvent[ExportType].Settings.EventName
		if glrCharacter.Data.Settings.General.ExportFormatKey == 1 then
			TicketCost = GLR_U:GetMoneyValue(TicketCost, "Lottery", false)
		else
			TicketCost = glrCharacter.PreviousEvent[ExportType].Settings.TicketPrice
		end
		if glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace ~= false then
			Second = ParsePrize(glrCharacter.PreviousEvent[ExportType].Settings.SecondPlace) .. " (" .. glrCharacter.PreviousEvent[ExportType].Data.SecondWinner .. ")"
			Max = Max + 1
		end
		if glrCharacter.PreviousEvent[ExportType].Settings.ThirdPlace ~= false then
			Third = ParsePrize(glrCharacter.PreviousEvent[ExportType].Settings.ThirdPlace) .. " (" .. glrCharacter.PreviousEvent[ExportType].Data.SecondWinner .. ")"
			Max = Max + 1
		end
		if glrCharacter.Data.Settings.General.ExportHeader then
			if key == 1 then
				DataString = '"' .. "Player Name" .. '","' .. "Date" .. '","' .. "Ticket Price" .. '","' .. "Tickets" .. '","' .. "Max Tickets" .. '","' .. "First Place (#)" .. '","' .. "Second Place (#)" .. '","' .. "Third Place (#)" .. '","' .. "Ticket Series" .. '","' .. "Winner(s)" .. '","' .. "Unsold Tickets" .. '"'
				DataString = DataString .. '\n"' .. "Event Info For: " .. Event .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.Date .. '","' .. TicketCost .. '","' .. "Sold: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) .. " Given: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.GiveAwayTickets) .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets .. '","' .. First .. '","' .. Second .. '","' .. Third .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.FirstTicketNumber) .. '","' .. Max .. '","' .. UnsoldTickets .. '"'
			else
				DataString = '"' .. "Player Name" .. '","' .. "Date" .. '","' .. "Tickets Bought" .. '","' .. "Ticket Price" .. '","' .. "Tickets Given" .. '","' .. "Ticket Series" .. '","' .. "Max Tickets" .. '","' .. "First Place (#)" .. '","' .. "Second Place (#)" .. '","' .. "Third Place (#)" .. '","' .. "Event Name" .. '"'
			end
		elseif key == 1 then
			DataString = '"' .. "Event Info For: " .. Event .. '","' .. EventDate .. '","' .. TicketCost .. '","' .. "Sold: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.TicketsSold) .. " Given: " .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.GiveAwayTickets) .. '","' .. glrCharacter.PreviousEvent[ExportType].Settings.MaxTickets .. '","' .. First .. '","' .. Second .. '","' .. Third .. '","' .. tostring(glrCharacter.PreviousEvent[ExportType].Settings.FirstTicketNumber) .. '","' .. Max .. '","' .. UnsoldTickets .. '"'
		end
		local Winner = false
		local c = 0
		local MultiplePrizes = ""
		for i = 1, #t do
			local MultipleFound = false
			local PrizeCount = 0
			local FirstFound = false
			local SecondFound = false
			local ThirdFound = false
			local name = t[i]
			local TicketsBought = "0"
			local TicketsGiven = "0"
			if glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Sold > 0 then
				TicketsBought = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Sold)
			end
			if glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given > 0 then
				TicketsGiven = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.Tickets[name].Given)
			end
			local range = tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.TicketRange[name].LowestTicketNumber) .. "-" .. tostring(glrCharacter.PreviousEvent[ExportType].Data.Entries.TicketRange[name].HighestTicketNumber)
			if not Winner then -- Saves on processing power once the winner is found.
				local continue = true
				if glrCharacter.PreviousEvent[ExportType].Data.FirstName == nil or glrCharacter.PreviousEvent[ExportType].Data.SecondName == nil or glrCharacter.PreviousEvent[ExportType].Data.ThirdName == nil then
					continue = false
				end
				if continue then
					if name == glrCharacter.PreviousEvent[ExportType].Data.FirstName then
						if MultiplePrizes == "" then
							MultiplePrizes = "First Place!"
						else
							MultiplePrizes = "First Place! - " .. MultiplePrizes
						end
						FirstFound = true
						PrizeCount = PrizeCount + 1
						c = c + 1
					end
					if name == glrCharacter.PreviousEvent[ExportType].Data.SecondName then
						if MultiplePrizes == "" then
							MultiplePrizes = "Second Place!"
						else
							MultiplePrizes = MultiplePrizes .. " - Second Place!"
						end
						SecondFound = true
						PrizeCount = PrizeCount + 1
						c = c + 1
					end
					if name == glrCharacter.PreviousEvent[ExportType].Data.ThirdName then
						if MultiplePrizes == "" then
							MultiplePrizes = "Third Place!"
						else
							MultiplePrizes = MultiplePrizes .. " - Third Place!"
						end
						ThirdFound = true
						PrizeCount = PrizeCount + 1
						c = c + 1
					end
					if PrizeCount > 1 then
						MultipleFound = true
					end
				end
			end
			if c == Max then
				Winner = true
			end
			if FirstFound and not MultipleFound then
				if key == 1 then
					DataString = DataString .. '\n"' .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","First Place!",""'
				else
					DataString = DataString .. '\n"' .. name .. '","' .. EventDate .. '","' .. TicketsBought .. '","' .. TicketCost .. '","' .. TicketsGiven .. '","' .. range .. '","' .. MaxTicket .. '","' .. First .. '","","","' .. Event .. '"'
				end
			elseif SecondFound and not MultipleFound then
				if key == 1 then
					DataString = DataString .. '\n"' .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","Second Place!",""'
				else
					DataString = DataString .. '\n"' .. name .. '","' .. EventDate .. '","' .. TicketsBought .. '","' .. TicketCost .. '","' .. TicketsGiven .. '","' .. range .. '","' .. MaxTicket .. '","","' .. Second .. '","","' .. Event .. '"'
				end
			elseif ThirdFound and not MultipleFound then
				if key == 1 then
					DataString = DataString .. '\n"' .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","Third Place!",""'
				else
					DataString = DataString .. '\n"' .. name .. '","' .. EventDate .. '","' .. TicketsBought .. '","' .. TicketCost .. '","' .. TicketsGiven .. '","' .. range .. '","' .. MaxTicket .. '","","","' .. Third .. '","' .. Event .. '"'
				end
			else
				if MultipleFound then
					if key == 1 then
						DataString = DataString .. '\n"' .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","' .. MultiplePrizes .. '",""'
					else
						DataString = DataString .. '\n"' .. name .. '","' .. EventDate .. '","' .. TicketsBought .. '","' .. TicketCost .. '","' .. TicketsGiven .. '","' .. range .. '","' .. MaxTicket .. '","","","' .. MultiplePrizes .. '","' .. Event .. '"'
					end
				else
					if key == 1 then
						DataString = DataString .. '\n"' .. name .. '","","","' .. TicketsBought .. " (" .. TicketsGiven .. ")" .. '","","","","","' .. range .. '","",""'
					else
						DataString = DataString .. '\n"' .. name .. '","' .. EventDate .. '","' .. TicketsBought .. '","' .. TicketCost .. '","' .. TicketsGiven .. '","' .. range .. '","' .. MaxTicket .. '","","","","' .. Event .. '"'
					end
				end
			end
		end
	end
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetDataString() - DataString Created. Event: [" .. string.upper(ExportType) .. "]")
	return DataString
end

function GLR:ExportData(ExportType)
	local function NOOP() return end
	StaticPopupDialogs["GLREXPORTLOTTERYDATA"] = StaticPopupDialogs["GLREXPORTLOTTERYDATA"] or {
		text = L["GLR - UI > StaticPopupDialog - Copy Text"],
		button1 = OKAY,
		hasEditBox = 1,
		OnShow = function(self, data)
			GetDataString(ExportType)
			self.editBox:SetScript('OnEditFocusGained', function(thisbox)
				thisbox:HighlightText(0, -1)
			end)
			self.editBox:SetText(DataString)
		end,
		OnHide = NOOP,
		OnAccept = NOOP,
		OnCancel = NOOP,
		EditBoxOnEscapePressed = function(self, ...) self:GetParent():Hide() end,
		EditBoxOnTextChanged = function(self, ...)
			self:SetText(DataString)
			self:SetFocus()
			self:HighlightText()
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1
	}
	StaticPopup_Show("GLREXPORTLOTTERYDATA")
end

local GLR_AddOnMessageTable = { ["Debug"] = {}, ["ActiveEvents"] = { ["Lottery"] = {}, ["Raffle"] = {} }, ["HasMod"] = { [1] = FullPlayerName .. "!" .. GLR_VersionString } }
GLR_AddOnMessageTable_Debug = { ["Data"] = {}, ["Messages"] = {} }
local GLR_AddOnMessages = CreateFrame("Frame")
local GLR_AddOnMessages_Debug = false
GLR_AddOnMessages:RegisterEvent("CHAT_MSG_ADDON")
GLR_AddOnMessages:SetScript("OnEvent", function(self, event, prefix, message, channel, sender)
	if Variables[2] then
		GLR_AddOnMessages:UnregisterAllEvents()
		return
	end
	if channel ~= "CHANNEL" then
		
		if event == "CHAT_MSG_ADDON" and channel == "GUILD" and message ~= nil and sender ~= nil then
			
			if prefix == "GLR_DEBUG" then
				
				if message == "RESET" then
					if GLR_AddOnMessages_Debug then
						GLR_AddOnMessages_Debug = false
						GLR:Print("Ready to send Reply Comm again.")
					end
					return
				end
				
				local continue = true
				local name = string.sub(message, 1, string.find(message, "%!") - 1)
				local version = string.sub(message, string.find(message, "%!") + 1, string.find(message, "%?") - 1)
				local status = string.sub(message, string.find(message, "%?") + 1, string.find(message, "%[") - 1)
				local lotterystate = string.sub(message, string.find(message, "%[") + 1, string.find(message, "%]") - 1)
				local rafflestate = string.sub(message, string.find(message, "%]") + 1, string.find(message, "%{") - 1)
				
				if GLR_AddOnMessageTable.Debug[name] == nil then
					GLR_AddOnMessageTable.Debug[name] = { ["Version"] = version, ["State"] = status, ["Lottery"] = lotterystate, ["Raffle"] = rafflestate, }
				else
					for t, v in pairs(GLR_AddOnMessageTable.Debug[name]) do
						local tt = { ["Version"] = version, ["State"] = status, ["Lottery"] = lotterystate, ["Raffle"] = rafflestate, }
						if GLR_AddOnMessageTable.Debug[name][t] ~= tt[t] then
							GLR_AddOnMessageTable.Debug[name][t] = tt[t]
						end
					end
				end
				
				GLR_AddOnMessageTable_Debug.Data = GLR_AddOnMessageTable.Debug
				
				if name ~= FullPlayerName and name ~= "RESET" then
					if not GLR_AddOnMessages_Debug then
						GLR:Print("Debug Comm Received from:\n" .. name .. "\nTheir Version: " .. version .. "\nAddOn Status: " .. status .. "\nLottery State: " .. lotterystate .. "\nRaffle State: " .. rafflestate)
						GLR:Print("Sending Reply Comm...")
						GLR_AddOnMessages_Debug = true
						status = tostring(glrCharacter.Data.Settings.General.enabled)
						lotterystate = tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)
						rafflestate = tostring(glrCharacter.Data.Settings.CurrentlyActiveRaffle)
						C_ChatInfo.SendAddonMessage("GLR_DEBUG", FullPlayerName .. "!" .. GLR_VersionString .. "?" .. status .. "[" .. lotterystate .. "]" .. rafflestate .. "{", "GUILD")
						C_Timer.After(5, function(self) GLR_AddOnMessages_Debug = false GLR:Print("Ready to send Reply Comm again.") end)
					end
				elseif name == FullPlayerName then
					GLR:Print("Comm Sent.")
				end
				
			end
			
			if prefix == "GLR_LOGIN" then
				for i = 1, #GLR_AddOnMessageTable.HasMod do
					local name = string.sub(GLR_AddOnMessageTable.HasMod[i], 1, string.find(GLR_AddOnMessageTable.HasMod[i], '%!') - 1)
					if name == sender and name ~= FullPlayerName then
						table.remove(GLR_AddOnMessageTable.HasMod, i)
						break
					end
				end
			end
			if prefix == "GLR_LOGOUT" then
				for i = 1, #GLR_AddOnMessageTable.HasMod do
					local name = string.sub(GLR_AddOnMessageTable.HasMod[i], 1, string.find(GLR_AddOnMessageTable.HasMod[i], '%!') - 1)
					if name == sender then
						table.remove(GLR_AddOnMessageTable.HasMod, i)
						break
					end
				end
			end
			if prefix == "GLR_HASMOD" then
				local continue = true
				for i = 1, #GLR_AddOnMessageTable.HasMod do
					local name = string.sub(GLR_AddOnMessageTable.HasMod[i], 1, string.find(GLR_AddOnMessageTable.HasMod[i], '%!') - 1)
					if name == sender then
						continue = false
						break
					end
				end
				if continue then
					local UserVersion = string.sub(message, 1, string.find(message, '?') - 1)
					table.insert(GLR_AddOnMessageTable.HasMod, sender .. "!" .. UserVersion)
					if tonumber(UserVersion) < tonumber(GLR_VersionString) then
						local AlertUser = "|cfff7ff4d" .. string.gsub(L["GLR - Comms - Others Version Outdated"], "%%name", sender) .. "|r"
						GLR:Print(AlertUser)
					elseif tonumber(UserVersion) > tonumber(GLR_VersionString) then
						local AlertUser = "|cfff7ff4d" ..  string.gsub(string.gsub(L["GLR - Comms - Your Version Outdated"], "%%version_current", GLR_Version), "%%version_new", string.sub(message, string.find(message, '?') + 1)) .. "|r"
						GLR:Print(AlertUser)
					end
					C_ChatInfo.SendAddonMessage("GLR_HASMOD", GLR_VersionString .. "?" .. GLR_Version, "GUILD")
				end
			end
			if prefix == "GLR_CHECK" then
				if string.find(message, "%%lottery_true") then
					local continue = true
					for i = 1, #GLR_AddOnMessageTable.ActiveEvents.Lottery do
						if GLR_AddOnMessageTable.ActiveEvents.Lottery[i] == sender then
							continue = false
							break
						end
					end
					if continue then
						table.insert(GLR_AddOnMessageTable.ActiveEvents.Lottery, sender)
					end
				elseif string.find(message, "%%lottery_false") then
					for i = 1, #GLR_AddOnMessageTable.ActiveEvents.Lottery do
						if GLR_AddOnMessageTable.ActiveEvents.Lottery[i] == sender then
							table.remove(GLR_AddOnMessageTable.ActiveEvents.Lottery, i)
						end
					end
				end
				if string.find(message, "%%raffle_true") then
					local continue = true
					for i = 1, #GLR_AddOnMessageTable.ActiveEvents.Raffle do
						if GLR_AddOnMessageTable.ActiveEvents.Raffle[i] == sender then
							continue = false
							break
						end
					end
					if continue then
						table.insert(GLR_AddOnMessageTable.ActiveEvents.Raffle, sender)
					end
				elseif string.find(message, "%%raffle_false") then
					for i = 1, #GLR_AddOnMessageTable.ActiveEvents.Raffle do
						if GLR_AddOnMessageTable.ActiveEvents.Raffle[i] == sender then
							table.remove(GLR_AddOnMessageTable.ActiveEvents.Raffle, i)
						end
					end
				end
				if GLR_AddOnMessageTable.ActiveEvents.Lottery[1] ~= nil then
					sort(GLR_AddOnMessageTable.ActiveEvents.Lottery)
				end
				if GLR_AddOnMessageTable.ActiveEvents.Raffle[1] ~= nil then
					sort(GLR_AddOnMessageTable.ActiveEvents.Raffle)
				end
			end
			
		end
	end
	
end)

--Purpose: To facilitate the transfer of the old Saved Data structure.
--Should be kept as a permanent function, to only be considered for removal at the launch of the next WoW Expansion after BfA.
local function GLR_TransferTables()
	local c = false
	if glrEvents ~= nil then
		if not c then c = true end
		for t, v in pairs(glrEvents) do
			if t == "Lottery" then
				for k, j in pairs(glrEvents[t]) do
					if k == "LotteryDate" then
						glrCharacter.Event.Lottery["Date"] = j
					elseif k == "LotteryName" then
						glrCharacter.Event.Lottery["EventName"] = j
					else
						glrCharacter.Event.Lottery[k] = j
					end
				end
			end
			if t == "Raffle" then
				for k, j in pairs(glrEvents[t]) do
					if k == "RaffleDate" then
						glrCharacter.Event.Raffle["Date"] = j
					elseif k == "RaffleName" then
						glrCharacter.Event.Raffle["EventName"] = j
					else
						glrCharacter.Event.Raffle[k] = j
					end
				end
			end
		end
	end
	if glrRaffleData ~= nil then
		if not c then c = true end
		glrCharacter.Data.Raffle = glrRaffleData
	end
	if glrProfile ~= nil then
		if not c then c = true end
		for t, v in pairs(glrProfile.Settings) do
			if t ~= "Profile" and t ~= "PreviousLottery" then
				glrCharacter.Data.Settings[t] = v
			elseif t == "Profile" then
				for k, j in pairs(glrProfile.Settings[t]) do
					for x, y in pairs(glrProfile.Settings[t][k]) do
						glrCharacter.Data.Settings[t][k][x] = y
					end
				end
			elseif t == "PreviousLottery" then
				for k, j in pairs(glrProfile.Settings[t]) do
					glrCharacter.Data.Settings[t][k] = j
				end
			end
		end
	end
	if glrLotteryEntries ~= nil then
		if not c then c = true end
		if glrLotteryEntries.Lottery ~= nil then
			glrCharacter.Lottery.Entries = glrLotteryEntries.Lottery
		end
	end
	if glrRaffleEntries ~= nil then
		if not c then c = true end
		if glrRaffleEntries.Raffle ~= nil then
			glrCharacter.Raffle.Entries = glrRaffleEntries.Raffle
		end
	end
	if glrTicketPool ~= nil then
		if not c then c = true end
		if glrTicketPool.Lottery ~= nil then
			glrCharacter.Lottery.TicketPool = glrTicketPool.Lottery
		end
		if glrTicketPool.Raffle ~= nil then
			glrCharacter.Raffle.TicketPool = glrTicketPool.Raffle
		end
	end
	if glrMessageStatus ~= nil then
		if not c then c = true end
		if glrMessageStatus.Lottery ~= nil then
			glrCharacter.Lottery.MessageStatus = glrMessageStatus.Lottery
		end
		if glrMessageStatus.Raffle ~= nil then
			glrCharacter.Raffle.MessageStatus = glrMessageStatus.Raffle
		end
	end
	if c then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GLR_TransferTables() - Data Transfer Complete")
	end
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

local function SendTicketHolderNotification(key, names, t, TargetName)
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local continue = true
	if status then
		local online = TargetName.Online
		if not online then
			continue = false
		end
	end
	if continue then
		local message = string.gsub(string.gsub(L["GLR - Core - Reply - Detect Other Event: Notify Player (short msg)"], "%%users", names), "%%e", t)
		local length = string.len(message)
		if length >= 255 then
			local LongMsg = string.gsub(L["GLR - Core - Reply - Detect Other Event: Notify Player (long msg)"], "%%e", t)
			local ta = {}
			local lt = {}
			local bypass = true
			local done = false
			local mnt = 0
			local nm = 0
			local steps = 4
			
			SendChatMessage(LongMsg, "WHISPER", nil, key)
			
			for v in string.gmatch(names, "[^, ]+") do
				table.insert(ta, v)
				mnt = mnt + 1
			end
			
			sort(ta)
			
			for i = 1, #ta do --Recursive loop to search if multiple instances of the same name exist, and remove one of them. No break point in case more than two copies exist.
				for j = i + 1, #ta do
					if ta[i] == ta[j] then
						table.remove(ta, j)
					end
				end
			end
			
			local ts = ta[1]
			table.remove(ta, 1)
			
			if mnt >= 10 then
				bypass = false
			end
			
			for i = 1, #ta do
				
				for j = 1, steps do
					if length > 0 or not done then
						if ta[1] == nil then
							break
						end
						if ta[2] == nil then
							ts = strjoin(", & ", ts, ta[1])
							table.remove(ta, 1)
						else
							ts = strjoin(", ", ts, ta[1])
							table.remove(ta, 1)
						end
					end
				end
				
				if not done then
					nm = nm + 1
					if not bypass then
						table.insert(lt, ts)
					end
					length = length - string.len(ts)
				end
				
				if bypass then
					SendChatMessage(ts, "WHISPER", nil, key)
				end
				
				if ta[1] == nil then
					done = true
				end
				
				if done then
					break
				end
				
				ts = ta[1]
				table.remove(ta, 1)
				
			end
			
			if not bypass then
				local ms = 0.25
				sort(lt)
				for i = 1, nm do
					C_Timer.After(ms, function(self)
						SendChatMessage(lt[1], "WHISPER", nil, key)
						table.remove(lt, 1)
					end)
					ms = ms + 0.25
					if lt[1] == nil then
						break
					end
				end
			end
			
		else
			local ta = {}
			
			for v in string.gmatch(names, "[^, ]+") do
				table.insert(ta, v)
			end
			
			for i = 1, #ta do --Recursive loop to search if multiple instances of the same name exist, and remove one of them. No break point in case more than two copies exist.
				for j = i + 1, #ta do
					if ta[i] == ta[j] then
						table.remove(ta, j)
					end
				end
			end
			
			sort(ta)
			
			local ts = ta[1]
			table.remove(ta, 1)
			
			for i = 1, #ta do
				if ta[i + 1] == nil then
					ts = strjoin(", & ", ts, ta[i])
					break
				else
					ts = strjoin(", ", ts, ta[i])
				end
			end
			
			local msg = string.gsub(string.gsub(L["GLR - Core - Reply - Detect Other Event: Notify Player (short msg)"], "%%users", ts), "%%e", t)
			
			SendChatMessage(msg, "WHISPER", nil, key)
		end
		glrCharacter.Data.OtherStatus[t][key] = nil
	end
end

local function SendRequestedInfo(sender, target, state)
	local continue = false
	local active = false
	local list = {}
	local c = 0
	if state == "Lottery" and glrCharacter.Data.Settings.CurrentlyActiveLottery then
		active = true
	elseif state == "Raffle" and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		active = true
	end
	if target ~= "" and active then
		if string.find(target, "-") then
			for t, v in pairs(glrCharacter[state].Entries.Names) do
				if v == target then
					continue = true
					break
				end
			end
			if not continue then
				local message = string.gsub(L["GLR - Core - Reply - Detect Other Event: No One Found"], "%%target", target)
				SendChatMessage(message, "WHISPER", nil, sender)
			end
		else
			for t, v in pairs(glrCharacter[state].Entries.Names) do
				if string.find(string.lower(v), string.lower(target)) then
					table.insert(list, v)
					c = c + 1
				end
			end
			if c == 1 then
				target = list[c]
				continue = true
			else
				if c == 0 then
					local message = string.gsub(L["GLR - Core - Reply - Detect Other Event: No One Found"], "%%target", target)
					SendChatMessage(message, "WHISPER", nil, sender)
				else
					local message = string.gsub(string.gsub(string.gsub(L["GLR - Core - Reply - Detect Other Event: Multiple Found"], "%%target", target), "%%event", string.lower(L[state])), "%%host", FullPlayerName)
					SendChatMessage(message, "WHISPER", nil, sender)
				end
			end
		end
	else
		if target == "" and active then
			local InvalidMessage = string.gsub(string.gsub(L["GLR - Core - Reply - Detect Other Event: No Valid Text"], "%%event", string.lower(L[state])), "%%host", PlayerName)
			SendChatMessage(InvalidMessage, "WHISPER", nil, sender)
		else
			local InactiveMessage = string.gsub(L["Send Info No Active Event"], "%%event", L[state])
			SendChatMessage("--------------------------------------------------", "WHISPER", nil, sender)
			SendChatMessage(InactiveMessage, "WHISPER", nil, sender)
			SendChatMessage("--------------------------------------------------", "WHISPER", nil, sender)
		end
	end
	if continue then
		local Tickets = tostring(glrCharacter[state].Entries.Tickets[target].NumberOfTickets)
		local LowEnd = tostring(glrCharacter[state].Entries.TicketRange[target].LowestTicketNumber)
		local HighEnd = tostring(glrCharacter[state].Entries.TicketRange[target].HighestTicketNumber)
		local message = ""
		
		if tonumber(Tickets) > 0 then
			message = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(L["GLR - Core - Reply - Detect Other Event: Target Found"], "%%target", target), "%%num", Tickets), "%%e", state), "%%low", LowEnd), "%%high", HighEnd)
		else
			message = string.gsub(L["GLR - Core - Reply - Detect Other Event: No One Found"], "%%target", target)
			if continue then
				message = string.sub(message, 1, string.find(message, "%."))
			end
		end
		
		if glrCharacter.Data.Settings.General.AdvancedTicketDraw and Tickets > 0 then
			message = string.sub(message, 1, string.find(message, "%."))
		end
		
		SendChatMessage(message, "WHISPER", nil, sender)
		
		if glrCharacter.Data.OtherStatus[state][target] == nil then
			glrCharacter.Data.OtherStatus[state][target] = { ["Requesters"] = sender, ["sentMessage"] = false }
		else
			local senders = glrCharacter.Data.OtherStatus[state][target].Requesters
			if senders ~= sender then
				if not string.find(string.lower(senders), string.lower(sender)) then
					senders = glrCharacter.Data.OtherStatus[state][target].Requesters .. ", " .. sender
				end
			end
			glrCharacter.Data.OtherStatus[state][target] = { ["Requesters"] = senders, ["sentMessage"] = false }
		end
		
		if glrCharacter.Data.OtherStatus ~= nil then
			if not glrCharacter.Data.OtherStatus[state][target].sentMessage then
				local names = glrCharacter.Data.OtherStatus[state][target].Requesters
				continue = false
				local check = false
				local TargetsRealm
				if string.find(string.lower(target), "-") ~= nil then
					TargetsRealm = string.sub(target, string.find(target, "-") + 1)
				end
				if PlayerRealmName == TargetsRealm then
					target = string.sub(target, 1, string.find(target, "-") - 1)
				end
				--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
				--if not glrCharacter.Data.Settings.General.MultiGuild then
				local numTotalMembers, _, _ = GetNumGuildMembers()
				for i = 1, numTotalMembers do
					local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
					if target == name then
						if isOnline then
							continue = true
						end
						break
					end
				end
				if continue then
					SendTicketHolderNotification(target, names, state, _)
				end
				-- else
					-- local faction, _ = UnitFactionGroup("PLAYER")
					-- for keys, vals in pairs(glrHistory.GuildRoster[faction]) do
						-- for i = 1, #glrHistory.GuildRoster[faction][keys] do
							-- local CompareText = string.sub(glrHistory.GuildRoster[faction][keys][i], 1, string.find(glrHistory.GuildRoster[faction][keys][i], '%[') - 1)
							-- if CompareText == target then
								-- check = true
								-- break
							-- end
						-- end
						-- if check then
							-- break
						-- end
					-- end
					-- if check then
						-- local timestamp = GetTimeStamp()
						-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SendRequestedInfo() - WhoLib Search Started For: [" .. target .. "]")
						-- local TargetName = GLR_Libs.WhoLib:UserInfo(user, 
							-- {
								-- timeout = 1,
								-- Online,
								-- callback = function(TargetName)
									-- SendTicketHolderNotification(target, names, state, TargetName)
								-- end
							-- }
						-- )
					-- end
				-- end
			end
		end
		
	end
	C_Timer.After(2, function(self) Variables[9] = true end)
end

---------------------------------------------
----------- SLASH COMMAND HANDLER -----------
---------------------------------------------
----- TELLS THE MOD WHAT TO LISTEN FOR ------
---------------------------------------------

function GLR:SlashCommands(input)
	
	local abort = false
	local text = string.lower(input)
	local invalid = true --Becomes false if a valid command is detected. Used to trigger the '/glr commands' section automatically if an invalid command is detected.
	
	if Variables[2] then
		abort = true
	end
	
	local command,value,_ = strsplit(" ", text)
	local timestamp = GetTimeStamp()
	if input ~= "" then
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - Detected Command: [" .. string.upper(command) .. "] - Full String: [" .. input .."] - ABORT [" .. string.upper(tostring(abort)) .. "]" )
	end
	
	if command == "build" then
		invalid = false
		local v, b, d, t = GetBuildInfo()
		GLR:Print("The current build of WoW is: " .. t)
	end
	
	if command == "debug" then
		invalid = false
		if string.find(text, " ") ~= nil then
			local subString = string.sub(text, string.find(text, " ") + 1)
			if subString == "run" then
				GLR:RunDebug()
			elseif subString == "send" then
				GLR:SendDebug()
			elseif subString == "command" then
				GLR:CommandDebug()
			end
		end
	end
	
	if not abort then
		
		local CheckGuild = GLR_U:CheckGuildName()
		
		if command == "show" or command == "open" or command == "" then
			invalid = false
			self:ShowGLRFrame()
		end
		
		if command == "abort" then
			if GLR_Global_Variables[6][1] or GLR_Global_Variables[6][2] then
				GLR_Global_Variables[3] = true
			end
		end
		
		if command == "help" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			
		end
		
		if command == "config" or command == "opt" or command == "options" or command == "option" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.general)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.general)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.general)
			
		end
		
		if command == "events" or command == "event" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.events)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.events)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.events)
			
		end
		
		if command == "profiles" or command == "profile" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
			
		end
		
		if command == "messages" or command == "message" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.messages)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.messages)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.messages)
			
		end
		
		if command == "giveaway" or command == "give" then
			
			invalid = false
			
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			
			if GLR_UI.GLR_MainFrame:IsVisible() == true then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			--Done twice to go to the correct config window, a 3rd time just in case
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.giveaway)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.giveaway)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.giveaway)
			
		end
		
		if command == "export" then
			local continue = false
			local complete = false
			local Export = "Lottery"
			local DoCommand = string.lower(string.sub(text, string.find(text, "export") + 7))
			if string.find(DoCommand, " ") ~= nil then
				DoCommand = string.gsub(DoCommand, " ", "")
			end
			if DoCommand == string.lower(L["Lottery"]) or DoCommand == "lottery" then
				Export = "Lottery"
				complete = true
				if glrCharacter.PreviousEvent.Lottery.Available then
					continue = true
				end
			elseif DoCommand == string.lower(L["Raffle"]) or DoCommand == "raffle" then
				Export = "Raffle"
				complete = true
				if glrCharacter.PreviousEvent.Raffle.Available then
					continue = true
				end
			end
			if continue then
				invalid = false
				timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - Doing Export of [" .. string.upper(Export) .. "] Event")
				GLR:ExportData(Export)
			elseif complete then
				invalid = false
				timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - INVALID Export Command. No Previous Event Data Available. String: [" .. text .. "]")
				local message = string.gsub("Invalid Command. No Previous %e Event Data Available.", "%%e", Export)
				GLR:Print(message)
			else
				timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - INVALID Export Command. Correct Usage Required. String: [" .. text .. "]")
				local message = string.gsub("Incomplete Command. Valid: /glr export %e", "%%e", string.lower(L[Export]))
				GLR:Print(message)
			end
		end
		
		if command == "minimap" then
			if string.find(text, " ") ~= nil then
				local subString = string.sub(text, string.find(text, " ") + 1)
				if string.find(subString, "%(") ~= nil and string.find(subString, "%)") ~= nil then
					if string.find(subString, "%,") ~= nil then
						local X = tonumber(string.sub(subString, string.find(subString, "%(") + 1, string.find(subString, "%,") - 1))
						local Y = tonumber(string.sub(subString, string.find(subString, "%,") + 1, string.find(subString, "%)") - 1))
						timestamp = GetTimeStamp()
						if X == nil or Y == nil then
							X = tostring(X)
							Y = tostring(Y)
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - FAILED To Change Minimap Coords: (" .. X .. ", " .. Y .. ") SubString: " .. subString)
						elseif X ~= nil and Y ~= nil then
							invalid = false
							glrCharacter.Data.Settings.General.MinimapXOffset = X
							glrCharacter.Data.Settings.General.MinimapYOffset = Y
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - SUCCESSFULLY Changed Minimap Coords To: (" .. X .. ", " .. Y .. ")")
						end
						GLR_U:UpdateMinimapIcon()
					end
				end
			end
			if string.find(text, " ") ~= nil then
				local subString = string.sub(text, string.find(text, " ") + 1)
				if string.find(subString, "%,") == nil and string.find(subString, "%(") == nil and string.find(subString, "%)") == nil then
					if string.find(subString, " ") then
						subString = string.sub(subString, 1, string.find(subString, " ") - 1)
					end
					if string.lower(subString) == string.lower(L["Toggle"]) or string.lower(subString) == "toggle" then
						invalid = false
						local value = glrCharacter.Data.Settings.General.mini_map
						if value == nil then value = false end -- In event that it's nil, let's change it to true so they'll see the minimap.
						if value then
							glrCharacter.Data.Settings.General.mini_map = false
						else
							glrCharacter.Data.Settings.General.mini_map = true
						end
						GLR_U:UpdateMinimapIcon()
					end
				end
			end
		end
		
		if command == "alert" or command == "guildalert" then
			invalid = false
			GLR:AlertGuild()
		end
		
		if command == "checkinvalid" or command == "check-invalid" or command == "check" then
			invalid = false
			GLR_U:CheckInvalidPlayers(true)
		end
		
		if command == "status" then
			invalid = false
			local continue = false
			local target = string.lower(string.sub(text, string.find(text, "status") + 7))
			if string.find(target, " ") ~= nil then
				target = string.gsub(target, " ", "")
			end
			
			chat:AddMessage(" ")
			
			local NameList = {}
			local LotteryList = {}
			local RaffleList = {}
			for i = 1, #glrHistory.Names do
				if glrHistory.ActiveEvents[glrHistory.Names[i]] ~= nil then
					if glrHistory.ActiveEvents[glrHistory.Names[i]] then
						table.insert(NameList, glrHistory.Names[i])
					end
				end
			end
			for i = 1, #NameList do
				if glrHistory.TransferAvailable.Lottery ~= nil then
					if glrHistory.TransferAvailable.Lottery[NameList[i]] then
						table.insert(LotteryList, NameList[i])
					end
				end
				if glrHistory.TransferAvailable.Raffle ~= nil then
					if glrHistory.TransferAvailable.Raffle[NameList[i]] then
						table.insert(RaffleList, NameList[i])
					end
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
								ClassColor = Variables[12][targetClass]
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
			
			if target ~= "" then
				
				local name = target
				
				if string.find(target, "-") then
					for t, v in pairs(NameList) do
						if v == target then
							continue = true
							break
						end
					end
				end
				if not continue then --In the event the person types out a near full name, should go ahead and search for the correct name.
					local count = 0
					local list = ""
					for t, v in pairs(NameList) do
						if string.find(string.lower(v), string.lower(target)) then
							count = count + 1
							list = v
							if count > 1 then
								--No need to continue searching for potential matches as more than ONE was found.
								break
							end
						end
					end
					if count == 0 then
						chat:AddMessage("Didn't find a valid Name with Active Event(s). Please use a partial or full Name from the following:")
					elseif count == 1 then
						target = list
						continue = true
					else
						chat:AddMessage("Detected Multiple Partial Names with Active Event(s). Please use a more accurate Name from the following:")
						chat:AddMessage(" ")
					end
				end
				
				if continue then
					local WinChanceTable = { [1] = 0.9, [2] = 0.8, [3] = 0.7, [4] = 0.6, [5] = 0.5, [6] = 0.4, [7] = 0.3, [8] = 0.2, [9] = 0.1, [10] = 1 }
					LotteryEvent = {
						false,				-- [1]		Event Active
						"",					-- [2]		Event Name
						"",					-- [3]		Event Date
						0,					-- [4]		Total Tickets (purchased)
						0,					-- [5]		Total Tickets (given)
						0,					-- [6]		Ticket Price
						"",					-- [7]		Maximum Tickets
						0,					-- [8]		Number of Entered Players
						"%",				-- [9]		Win Chance
						0,					-- [10]		Jackpot (after guild %)
						0,					-- [11]		Second Place (if no one wins Jackpot)
					}
					RaffleEvent = {
						false,				-- [1]		Event Active
						"",					-- [2]		Event Name
						"",					-- [3]		Event Date
						0,					-- [4]		Total Tickets (purchased)
						0,					-- [5]		Total Tickets (given)
						0,					-- [6]		Ticket Price
						"",					-- [7]		Maximum Tickets
						0,					-- [8]		Number of Entered Players
						0,					-- [9]		Ticket Value
					}
					--RetrieveMoneyValue(Total, Event, Check, Target, IsString)
					--GetMoneyValue(Total, Event, Check, Round, Target, IsString, Color)
					if glrHistory.TransferAvailable.Lottery[target] ~= nil then
						if glrHistory.TransferAvailable.Lottery[target] then
							LotteryEvent[1] = true
							LotteryEvent[2] = glrHistory.TransferData[target].Event.Lottery.EventName
							LotteryEvent[3] = glrHistory.TransferData[target].Event.Lottery.Date
							LotteryEvent[4] = CommaValue(glrHistory.TransferData[target].Event.Lottery.TicketsSold)
							LotteryEvent[5] = CommaValue(glrHistory.TransferData[target].Event.Lottery.GiveAwayTickets)
							LotteryEvent[6] = GLR_U:GetMoneyValue(tonumber(glrHistory.TransferData[target].Event.Lottery.TicketPrice), "Lottery", false, 1, "NA", true, true)
							LotteryEvent[7] = CommaValue(glrHistory.TransferData[target].Event.Lottery.MaxTickets)
							LotteryEvent[8] = tostring(#glrHistory.TransferData[target].Lottery.Entries.Names) --In the unlikely event it returns NIL
							if glrHistory.TransferData[target].Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
								LotteryEvent[9] = tostring(WinChanceTable[glrHistory.TransferData[target].Data.Settings.WinChanceKey] * 100) .. LotteryEvent[9]
							else
								LotteryEvent[9] = "100%"
							end
							local l =  ( tonumber(glrHistory.TransferData[target].Event.Lottery.TicketPrice) * glrHistory.TransferData[target].Event.Lottery.TicketsSold + tonumber(glrHistory.TransferData[target].Event.Lottery.StartingGold) )
							local g = ( tonumber(glrHistory.TransferData[target].Event.Lottery.GuildCut) / 100 ) * ( tonumber(glrHistory.TransferData[target].Event.Lottery.TicketPrice) * glrHistory.TransferData[target].Event.Lottery.TicketsSold + tonumber(glrHistory.TransferData[target].Event.Lottery.StartingGold) )
							local p = GLR_U:GetMoneyValue(g, "Lottery", true, "NA", target, false, false)
							local j = l - p
							LotteryEvent[10] = GLR_U:GetMoneyValue(j, "Lottery", false, "NA", target, true, true)
							if glrHistory.TransferData[target].Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
								local s = ( tonumber(glrHistory.TransferData[target].Event.Lottery.SecondPlace) / 100 ) * ( tonumber(glrHistory.TransferData[target].Event.Lottery.TicketPrice) * glrHistory.TransferData[target].Event.Lottery.TicketsSold + tonumber(glrHistory.TransferData[target].Event.Lottery.StartingGold) )
								LotteryEvent[11] = GLR_U:GetMoneyValue(s, "Lottery", true, "NA", target, true, true)
							else
								LotteryEvent[11] = L["Winner Guaranteed"]
							end
						end
					end
					if glrHistory.TransferAvailable.Raffle[target] ~= nil then
						if glrHistory.TransferAvailable.Raffle[target] then
							RaffleEvent[1] = true
							RaffleEvent[2] = glrHistory.TransferData[target].Event.Raffle.EventName
							RaffleEvent[3] = glrHistory.TransferData[target].Event.Raffle.Date
							RaffleEvent[4] = CommaValue(glrHistory.TransferData[target].Event.Raffle.TicketsSold)
							RaffleEvent[5] = CommaValue(glrHistory.TransferData[target].Event.Raffle.GiveAwayTickets)
							RaffleEvent[6] = GLR_U:GetMoneyValue(tonumber(glrHistory.TransferData[target].Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, true)
							RaffleEvent[7] = CommaValue(glrHistory.TransferData[target].Event.Raffle.MaxTickets)
							RaffleEvent[8] = tostring(#glrHistory.TransferData[target].Raffle.Entries.Names) --In the unlikely event it returns NIL
							RaffleEvent[9] = GLR_U:GetMoneyValue(glrHistory.TransferData[target].Event.Raffle.TicketsSold * tonumber(glrHistory.TransferData[target].Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, true)
						end
					end
					
					local class = GetClassColor(target)
					
					if LotteryEvent[1] then
						chat:AddMessage("Lottery Event Data from: |cff" .. class .. " " .. target .. "|r")
						chat:AddMessage("Event Name:|cfff7ff4d " .. LotteryEvent[2] .. "|r - Event Date:|cfff7ff4d " .. LotteryEvent[3] .. "|r")
						chat:AddMessage("Tickets Sold:|cfff7ff4d " .. LotteryEvent[4] .. "|r - Tickets Given:|cfff7ff4d " .. LotteryEvent[5] .. "|r")
						chat:AddMessage("Ticket Price: " .. LotteryEvent[6] .. " - Maximum Tickets Per Player:|cfff7ff4d " .. LotteryEvent[7] .. "|r")
						chat:AddMessage("Entered Players:|cfff7ff4d " .. LotteryEvent[8] .. "|r - Event Win Chance:|cfff7ff4d " .. LotteryEvent[9] .. "|r")
						chat:AddMessage("Jackpot (After Guild Cut): " .. LotteryEvent[10])
						chat:AddMessage("Second Place (No One Won The Jackpot): " .. LotteryEvent[11])
					end
					if LotteryEvent[1] and RaffleEvent[1] then
						chat:AddMessage(" ")
					end
					if RaffleEvent[1] then
						chat:AddMessage("Raffle Event Data from: |cff" .. class .. " " .. target .. "|r")
						chat:AddMessage("Event Name:|cfff7ff4d " .. RaffleEvent[2] .. "|r - Event Date:|cfff7ff4d " .. RaffleEvent[3] .. "|r")
						chat:AddMessage("Tickets Sold:|cfff7ff4d " .. RaffleEvent[4] .. "|r - Tickets Given:|cfff7ff4d " .. RaffleEvent[5] .. "|r")
						chat:AddMessage("Ticket Price: " .. RaffleEvent[6] .. " - Maximum Tickets Per Player:|cfff7ff4d " .. RaffleEvent[7] .. "|r")
						chat:AddMessage("Entered Players:|cfff7ff4d " .. RaffleEvent[8] .. "|r")
						chat:AddMessage("Value of Purchased Tickets: " .. RaffleEvent[9])
					end
					
					if not LotteryEvent[1] and not RaffleEvent[1] then -- In the unlikely event it's unable to grab event data for a Character with active events, need to let the player know.
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - Unable to grab Event Data. Target: [" .. target .. "]" )
						chat:AddMessage("Unable to grab Event Data. Please notify AddOn Author.")
					end
					
				end
				
			end
			
			if target == "" or not continue then
				if glrHistory.Names ~= nil then
					if #NameList >= 1 then
						chat:AddMessage("Detected the following names with Active Events")
						if #LotteryList >= 1 then
							local LotteryNames = "Lottery Events: "
							for i = 1, #LotteryList do
								local printed = false
								local length = string.len(LotteryNames)
								local compare = 12 + string.len(LotteryList[i])
								local total = length + compare
								local class = GetClassColor(LotteryList[i])
								if total <= 255 then
									if i == 1 then
										LotteryNames = LotteryNames .. "|cff" .. class .. " " .. LotteryList[i] .. "|r"
									else
										LotteryNames = LotteryNames .. ", |cff" .. class .. " " .. LotteryList[i] .. "|r"
									end
								else
									chat:AddMessage(LotteryNames)
									LotteryNames = "|cff" .. class .. " " .. LotteryList[i] .. "|r"
									printed = true
								end
								if not printed and LotteryList[i+1] == nil then
									chat:AddMessage(LotteryNames)
								end
							end
						end
						if #RaffleList >= 1 then
							if #RaffleList >= 1 and #LotteryList >= 1 then
								chat:AddMessage("------------------------------")
							end
							local RaffleNames = "Raffle Events: "
							for i = 1, #RaffleList do
								local printed = false
								local length = string.len(RaffleNames)
								local compare = 12 + string.len(RaffleList[i])
								local total = length + compare
								local class = GetClassColor(RaffleList[i])
								if total <= 255 then
									if i == 1 then
										RaffleNames = RaffleNames .. "|cff" .. class .. " " .. RaffleList[i] .. "|r"
									else
										RaffleNames = RaffleNames .. ", |cff" .. class .. " " .. RaffleList[i] .. "|r"
									end
								else
									chat:AddMessage(RaffleNames)
									RaffleNames = "|cff" .. class .. " " .. RaffleList[i] .. "|r"
									printed = true
								end
								if not printed and RaffleList[i+1] == nil then
									chat:AddMessage(RaffleNames)
								end
							end
						end
					else
						table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - No Valid Names Detected. Table was EMPTY." )
						chat:AddMessage("No Valid Names Detected.")
					end
				else
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SlashCommands() - No Active Events Detected. Table was NIL." )
					chat:AddMessage("No Active Events Detected.")
				end
			end
			
			chat:AddMessage(" ")
			
		end
		
		if command == "command" or command == "commands" or invalid then
			chat:AddMessage("")
			if invalid then
				chat:AddMessage("Invalid Command Detected")
			end
			chat:AddMessage("List of Available Commands:")
			chat:AddMessage("")
			chat:AddMessage("[|cfff7ff4d /glr |r] or [|cfff7ff4d /glr show |r] or [|cfff7ff4d /glr open |r] - Toggles the visibility of the User Interface")
			chat:AddMessage("[|cfff7ff4d /glr config |r] or [|cfff7ff4d /glr options |r] - Opens the Interface Panel to the Options tab")
			chat:AddMessage("[|cfff7ff4d /glr events |r] or [|cfff7ff4d /glr event |r] - Opens the Interface Panel to the Events tab")
			chat:AddMessage("[|cfff7ff4d /glr profiles |r] or [|cfff7ff4d /glr profile |r] - Opens the Interface Panel to the Profiles tab")
			chat:AddMessage("[|cfff7ff4d /glr messages |r] or [|cfff7ff4d /glr message |r] - Opens the Interface Panel to the Messages tab")
			chat:AddMessage("[|cfff7ff4d /glr giveaway |r] or [|cfff7ff4d /glr give |r] - Opens the Interface Panel to the Giveaway tab")
			chat:AddMessage("[|cfff7ff4d /glr alert |r] or [|cfff7ff4d /glr guildalert |r] - Alerts your Guild to any active Event(s)")
			chat:AddMessage("[|cfff7ff4d /glr export <type> |r] - Creates a string based on the information saved from your previously completed Event. Type can be:|cfff7ff4d " .. string.lower(L["Lottery"]) .. "|r or|cfff7ff4d " .. string.lower(L["Raffle"]) .. "|r" )
			chat:AddMessage("[|cfff7ff4d /glr minimap " .. string.lower(L["Toggle"]) .. " |r] - Toggles the visibility of the Minimap Icon.")
			chat:AddMessage("[|cfff7ff4d /glr minimap (X,Y) |r] - Sets the position of the Minimap Icon.")
			chat:AddMessage(" - X and Y can be any numeric entry, Icon position is anchored off the center of the Minimap.")
			chat:AddMessage(" - Both|cfff7ff4d ( ) |rParentheses are required.")
			chat:AddMessage("[|cfff7ff4d /glr check |r] or [|cfff7ff4d /glr checkinvalid |r] - Checks for any Invalid Entries in your Event(s) and removes them.")
			chat:AddMessage("[|cfff7ff4d /glr status <name> |r] - Displays basic information about any Active Event(s) on the specified Character.")
		end
		
	end
	
end

local AddDebug = true
function GLR:MinimapIconFunction(button)
	
	local CTRL = IsControlKeyDown()
	
	local timestamp = GetTimeStamp()
	
	if button == "LeftButton" then
		if not CTRL then
			GLR:ShowGLRFrame()
			if AddDebug then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MinimapIconFunction() - Toggle of Main UI")
				AddDebug = false
				C_Timer.After(1, function(self) AddDebug = true end)
			end
		elseif CTRL then
			if AddDebug then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MinimapIconFunction() - Sending Guild Alert")
				AddDebug = false
				C_Timer.After(1, function(self) AddDebug = true end)
			end
			GLR:AlertGuild()
		end
	end
	
	if button == "RightButton" then
		if not CTRL then
			if AddDebug then
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - MinimapIconFunction() - Opening Interface Panel")
				AddDebug = false
				C_Timer.After(1, function(self) AddDebug = true end)
			end
			local CheckGuild = GLR_U:CheckGuildName()
			if CheckGuild and not Variables[2] then
				GLR_U:UpdateInfo(false)
			end
			if GLR_UI.GLR_MainFrame:IsVisible() then
				GLR_UI.GLR_MainFrame:Hide()
			end
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
		end
	end
	
end

---------------------------------------------
----------------- ON ENABLE -----------------
---------------------------------------------
----- THE MOD NEEDS TO DO CERTAIN THINGS ----
---------- WHEN IT BECOMES ENABLED ----------
---------------------------------------------

function GLR:OnEnable()
	
	--self:RegisterEvent("CHAT_MSG_WHISPER")
	--self:RegisterEvent("CHAT_MSG_GUILD")
	--self:RegisterEvent("PLAYER_LOGOUT")
	--self:RegisterEvent("PLAYER_LOGIN")
	
end

function GLR:OnInitialize()
	
	local timestamp = GetTimeStamp()
	if glrHistory.Debug == nil then
		glrHistory.Debug = {}
	end
	if glrHistory.Debug[FullPlayerName] == nil then
		glrHistory.Debug[FullPlayerName] = {}
	end
	
	table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - -------------------------------------------------------------------------------------") --Makes it easy to parse the Debug messages, telling between each session.
	
	if not GLR_ReleaseState then
		table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - OnInitialize() - Beginning Initialization of Version: " .. GLR_VersionCheck .. "-" .. GLR_ReleaseType .. "." .. GLR_ReleaseNumber)
	else
		table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - OnInitialize() - Beginning Initialization of Version: " .. GLR_VersionCheck)
	end
	
	
	-- initialize configuration options
	self.options = GLR_O:OptionsTable()
	configUI:RegisterOptionsTable("GuildLotteryRaffle", self.options)
	self.optionsFrame = dialog:AddToBlizOptions("GuildLotteryRaffle", "Guild Lottery & Raffles", nil, "glrInfo")
	self.optionsFrame.general = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Options Tab"], "Guild Lottery & Raffles", "generalOptions")
	self.optionsFrame.events = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Events Tab"], "Guild Lottery & Raffles", "eventSettings")
	self.optionsFrame.profiles = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Profiles Tab"], "Guild Lottery & Raffles", "profileOptions")
	self.optionsFrame.messages = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Message Tab"], "Guild Lottery & Raffles", "messageOptions")
	self.optionsFrame.whispers = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Whispers Tab"], "Guild Lottery & Raffles", "whisperOptions")
	self.optionsFrame.giveaway = dialog:AddToBlizOptions("GuildLotteryRaffle", L["Configuration Panel Giveaway Tab"], "Guild Lottery & Raffles", "giveawayOptions")
	
	-- registers custom slash commands (see function for details)
	GLR:RegisterChatCommand('glr', 'SlashCommands')
	
end

local InitalizationDebug = 1
local CL = false
--Due to the way certain information is available when first logging in, the Initialize function had to be broken in two.
--This function will check every second upon logging in until GetGuildInfo returns true.
--If however the player is not in a Guild then it will stop checking one minute after logging in.
local function Initialization()
	
	if InitalizationDebug == 1 then
		InitalizationDebug = 2
		if not GLR_ReleaseState then
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Preforming Initialization Function")
		end
	end
	
	if Variables[2] then
		GLR:Print(L["GLR - Core - Critical Update Detected"])
		if not GLR_ReleaseState then
			InitalizationDebug = 4
		end
	elseif not Variables[2] then
		
		local CheckGuild = GLR_U:CheckGuildName()
		
		if Variables[7] <= 70 and not Variables[6] then
			Variables[7] = Variables[7] + 1
			C_Timer.After(1, function(self) Initialization() end)
		end
		
		--Not all information that this AddOn uses is completely available once CheckGuild returns true
		--This is why at least 3 seconds must pass before the Initialization can be completed.
		
		if glrHistory.ClubInfo ~= nil then
			glrHistory.ClubInfo = nil
		end
		
		-- if CheckGuild and Variables[7] >= 20 and Variables[7] <= 63 and not Variables[5] then
			-- local guildName, _, _, _ = GetGuildInfo("PLAYER")
			-- if guildName ~= nil then
				-- if guildName ~= "" then
					-- local faction, _ = UnitFactionGroup("PLAYER")
					
					--C_Club.GetMemberInfo(C_Club.GetGuildClubId(), 1)
					
					-- if glrHistory.ClubInfo[faction][guildName] == nil then
						-- glrHistory.ClubInfo[faction][guildName] = {}
					-- end
					
					-- glrHistory.ClubInfo[faction][guildName].MemberData = {}
					
					-- for i = 1, #C_Club.GetClubMembers(C_Club.GetGuildClubId()) do
						-- local t = C_Club.GetMemberInfo(C_Club.GetGuildClubId(), C_Club.GetClubMembers(C_Club.GetGuildClubId())[i])
						-- if t.name ~= nil then
							-- local p = { ["guid"] = t.guid, ["presence"] = t.presence, ["name"] = t.name, ["memberNote"] = t.memberNote, ["guildRank"] = t.guildRank }
							-- glrHistory.ClubInfo[faction][guildName].MemberData[t.name] = p
						-- end
					-- end
					
					-- Variables[5] = true
				-- end
			-- end
		-- end
		
		if Variables[4] and Variables[5] then Variables[6] = true end
		
		if CheckGuild and Variables[7] >= 10 and Variables[7] <= 70 and not Variables[4] then
			Variables[4] = true
			local guildName, _, _, _ = GetGuildInfo("PLAYER")
			local faction, _ = UnitFactionGroup("PLAYER")
			local canEdit = false
			local LoginMessages = true
			local gName = guildName
			
			--if gName == nil or gName == "" then gName = false end
			
			if glrHistory.DrawState[faction][FullPlayerName] == nil then
				glrHistory.DrawState[faction][FullPlayerName] = glrCharacter.Data.Settings.General.AdvancedTicketDraw
			elseif glrHistory.DrawState[faction][FullPlayerName] ~= glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				glrHistory.DrawState[faction][FullPlayerName] = glrCharacter.Data.Settings.General.AdvancedTicketDraw
			end
			
			if glrCharacter.Data.Settings.General.DisableLoginMessages ~= nil then
				if glrCharacter.Data.Settings.General.DisableLoginMessages then
					LoginMessages = false
				end
			end
			
			local v, b, d, t = GetBuildInfo()
			
			if tonumber(t) >= 80200 then
				canEdit = CanEditGuildEvent()
			end
			
			if not canEdit then --Prevents user from manually changing from false to true when they can't make Guild Events in the first place.
				glrCharacter.Data.Settings.General.CreateCalendarEvents = false
			end
			
			if guildName ~= nil then
				if guildName ~= "" and guildName ~= false then
					
					if glrHistory.GuildRanks[faction][guildName] == nil then
						glrHistory.GuildRanks[faction][guildName] = {}
					end
					
					local numTotalMembers, _, _ = GetNumGuildMembers()
					if glrHistory.GuildRanks[faction][guildName] ~= nil then
						local t = {}
						for i = 1 , GuildControlGetNumRanks() do
							t[i] = GuildControlGetRankName(i)
						end
						glrHistory.GuildRanks[faction][guildName] = t
					end
					
					if glrCharacter.Data.Settings.General.GuildName == nil then
						glrCharacter.Data.Settings.General.GuildName = guildName
					elseif glrCharacter.Data.Settings.General.GuildName ~= guildName then
						glrCharacter.Data.Settings.General.GuildName = guildName
					end
					
					if glrHistory.CharacterGuilds[FullPlayerName] == nil then
						glrHistory.CharacterGuilds[FullPlayerName] = {}
						glrHistory.CharacterGuilds[FullPlayerName] = gName
					else
						local tName = glrHistory.CharacterGuilds[FullPlayerName]
						if tName ~= gName then
							glrHistory.CharacterGuilds[FullPlayerName] = gName
						end
					end
					
					if glrHistory.GuildFaction[faction][FullPlayerName] == nil then
						glrHistory.GuildFaction[faction][FullPlayerName] = guildName
					elseif glrHistory.GuildFaction[faction][FullPlayerName] ~= guildName then
						glrHistory.GuildFaction[faction][FullPlayerName] = guildName
					end
					
					if glrHistory.GuildStatus[faction][guildName] == nil then
						local status = glrCharacter.Data.Settings.General.MultiGuild
						glrHistory.GuildStatus[faction][guildName] = {}
						glrHistory.GuildStatus[faction][guildName] = status
					else
						local status = glrCharacter.Data.Settings.General.MultiGuild
						local current = glrHistory.GuildStatus[faction][guildName]
						if status and not current then
							glrHistory.GuildStatus[faction][guildName] = status
						end
					end
					
					for t, v in pairs(glrHistory.GuildFaction) do
						if t ~= "Alliance" and t ~= "Horde" then
							local slot = glrHistory.GuildFaction[t]
							local name = ""
							for k, v in pairs(glrHistory.CharacterGuilds) do
								if glrHistory.CharacterGuilds[k] == t then
									name = k
									break
								end
							end
							glrHistory.GuildFaction[slot][name] = t
							glrHistory.GuildFaction[t] = nil
						end
					end
					
					for t, v in pairs(glrHistory.GuildStatus) do
						if t ~= "Alliance" and t ~= "Horde" then
							local status = glrHistory.GuildStatus[t]
							local GuildsFaction = ""
							local doBreak = false
							for k, v in pairs(glrHistory.GuildFaction) do
								for key, val in pairs(glrHistory.GuildFaction[k]) do
									if glrHistory.GuildFaction[k][key] == t then
										GuildsFaction = k
										doBreak = true
										break
									end
								end
								if doBreak then
									break
								end
							end
							glrHistory.GuildStatus[GuildsFaction][t] = status
							glrHistory.GuildStatus[t] = nil
						end
					end
					
					for t, v in pairs(glrHistory.GuildRoster) do
						if t ~= "Alliance" and t ~= "Horde" then
							local GuildsFaction = ""
							local continue = false
							for k, v in pairs(glrHistory.GuildFaction) do
								for key, val in pairs(glrHistory.GuildFaction[k]) do
									for i = 1, #glrHistory.GuildRoster[t] do
										local search = string.sub(glrHistory.GuildRoster[t][i], 1, string.find(glrHistory.GuildRoster[t][i], '%[') - 1)
										if search == key and glrHistory.GuildFaction[k][key] == t then
											continue = true
											GuildsFaction = k
											break
										end
									end
									if continue then
										break
									end
								end
								if continue then
									break
								end
							end
							if continue then
								glrHistory.GuildRoster[GuildsFaction][t] = glrHistory.GuildRoster[t]
								glrHistory.GuildRoster[t] = nil
							end
						end
					end
					
					--Checks if new table for storing guild data has been built and transfers existing data to it, otherwise it updates existing data.
					--Feature not implemented
					-- local DataTransfer = false
					-- if not guildData.Initialized then
						-- if glrHistory.GuildRoster ~= nil then
							-- if glrHistory.GuildRoster.Alliance ~= nil then
								-- DataTransfer = true
							-- end
							-- if glrHistory.GuildRoster.Horde ~= nil then
								-- DataTransfer = true
							-- end
						-- end
						-- if DataTransfer then
							-- for f, v in pairs(glrHistory.GuildRoster) do
								-- if f == "Alliance" or f == "Horde" then
									-- for g, e in pairs(glrHistory.GuildRoster[f]) do
										-- if guildData[f][g] == nil then
											-- guildData[f][g] = {}
											-- for i = 1, #glrHistory.GuildRoster[f][g] do
												-- local name = string.sub(glrHistory.GuildRoster[f][g][i], 1, string.find(glrHistory.GuildRoster[f][g][i], "%[") - 1)
												-- local class = string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%[") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%]") - 1)
												-- local level = tonumber(string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%(") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%)") - 1))
												-- local rankID = tonumber(string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%{") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%|") - 1))
												-- local rankName = string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%|") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%}") - 1)
												-- local online = string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%@") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%$") - 1)
												-- local onlineLast = string.sub(glrHistory.GuildRoster[f][g][i], string.find(glrHistory.GuildRoster[f][g][i], "%$") + 1, string.find(glrHistory.GuildRoster[f][g][i], "%!") - 1)
												-- if online == "true" then online = true elseif online == "false" then online = false end
												-- guildData[f][g][name] = { [1] = class, [2] = level, [3] = rankID, [4] = rankName, [5] = online, [6] = onlineLast }
											-- end
										-- end
									-- end
								-- end
							-- end
						-- end
						-- guildData.Initialized = true
					-- end
					
				end
			end
			
			local status = glrCharacter.Data.Settings.General.MultiGuild
			local numTotalMembers, _, _ = GetNumGuildMembers()
			
			if LoginMessages then --Due to Blizzard blocking the /who function without player involvement, automatic Login messages will only be sent to players of the same guild.
				
				if glrCharacter.Lottery.Entries.Names ~= nil then
					
					local state = "Lottery"
					
					for t, v in pairs(glrCharacter.Lottery.Entries.Names) do
						
						if glrCharacter.Lottery.MessageStatus[v] == nil then
							glrCharacter.Lottery.MessageStatus[v] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
						end
						
						if not glrCharacter.Lottery.MessageStatus[v].sentMessage then
							
							local targetRealm
							local bypass = false
							local continue = false
							local vN = v
							
							if string.find(string.lower(v), "-") ~= nil then
								targetRealm = string.sub(v, string.find(v, "-") + 1)
							else
								bypass = true
							end
							
							if PlayerRealmName == targetRealm and not bypass then
								vN = string.sub(v, 1, string.find(v, "-") - 1)
							end
							
							for i = 1, numTotalMembers do
								local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
								if v == name then
									if isOnline then
										continue = true
									end
									break
								end
							end
							if continue then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Sending Automatic Login Message To: [" .. v .. "] - Event: [" .. string.upper(state) .. "]")
								GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
							else
								if glrCharacter.Data.Settings.General.ToggleChatInfo then
									GLR:Print("|cfff7ff4d" .. v .. " " .. L["Send Info Player Not Online"] .. "|r")
								end
							end
							
							-- if not status then --If the current Lottery/Raffle isn't a Multi-Guild event it doesn't need to do a /who to see if the Player's online.
								-- for i = 1, numTotalMembers do
									-- local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
									-- if v == name then
										-- if isOnline then
											-- continue = true
										-- end
										-- break
									-- end
								-- end
								-- if continue then
									-- GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
								-- else
									-- if glrCharacter.Data.Settings.General.ToggleChatInfo then
										-- GLR:Print("|cfff7ff4d" .. v .. " " .. L["Send Info Player Not Online"] .. "|r")
									-- end
								-- end
							-- else
								
								--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
								
								--local pf = glrHistory.PlayerFaction[FullPlayerName]
								--local pg = glrHistory.GuildFaction[pf][FullPlayerName]
								
								--[[
								/script local nt, _, _ = GetNumGuildMembers() local n = math.random(1,nt) local p = select(1, GetGuildRosterInfo(n)) print("Name: '"..n"'")
								]]
								
								-- for i = 1, numTotalMembers do
									-- local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
									-- if v == name then
										-- if isOnline then
											-- continue = true
										-- end
										-- break
									-- end
								-- end
								
								-- if continue then
									-- GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
								-- end
								
								-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
									-- for i = 1, #glrHistory.GuildRoster[faction][key] do
										-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
										-- if CompareText == v then
											-- continue = true
											-- break
										-- end
									-- end
									-- if continue then
										-- break
									-- end
								-- end
								--if continue then
									
									-- if not glrCharacter.Lottery.MessageStatus[v]["sentMessage"] then
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
								--end
								
							--end
							
						end
						
					end
					
				end
				
				if glrCharacter.Raffle.Entries.Names ~= nil then
					
					local state = "Raffle"
					
					for t, v in pairs(glrCharacter.Raffle.Entries.Names) do
						
						if glrCharacter.Raffle.MessageStatus[v] == nil then
							glrCharacter.Raffle.MessageStatus[v] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
						end
						
						if not glrCharacter.Raffle.MessageStatus[v].sentMessage then
							
							local targetRealm
							local bypass = false
							local continue = false
							local vN = v
							
							if string.find(string.lower(v), "-") ~= nil then
								targetRealm = string.sub(v, string.find(v, "-") + 1)
							else
								bypass = true
							end
							
							if PlayerRealmName == targetRealm and not bypass then
								vN = string.sub(v, 1, string.find(v, "-") - 1)
							end
							
							for i = 1, numTotalMembers do
								local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
								if v == name then
									if isOnline then
										continue = true
									end
									break
								end
							end
							if continue then
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Sending Automatic Login Message To: [" .. v .. "] - Event: [" .. string.upper(state) .. "]")
								GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
							else
								if glrCharacter.Data.Settings.General.ToggleChatInfo then
									GLR:Print("|cfff7ff4d" .. v .. " " .. L["Send Info Player Not Online"] .. "|r")
								end
							end
							
							-- if not status then --If the current Lottery/Raffle isn't a Multi-Guild event it doesn't need to do a /who to see if the Player's online.
								-- for i = 1, numTotalMembers do
									-- local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
									-- if v == name then
										-- if isOnline then
											-- continue = true
										-- end
										-- break
									-- end
								-- end
								-- if continue then
									-- if not glrCharacter.Raffle.MessageStatus[v]["sentMessage"] then
										-- GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
									-- end
								-- elseif not glrCharacter.Raffle.MessageStatus[v]["sentMessage"] and not continue then
									-- if glrCharacter.Data.Settings.General.ToggleChatInfo then
										-- GLR:Print("|cfff7ff4d" .. v .. " " .. L["Send Info Player Not Online"] .. "|r")
									-- end
								-- end
							-- else
								
								--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
								-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
									-- for i = 1, #glrHistory.GuildRoster[faction][key] do
										-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
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
									-- if not glrCharacter.Raffle.MessageStatus[v]["sentMessage"] then
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
								
							-- end
							
						end
						
					end
					
				end
				
			end
			
			--Due to Blizzard blocking the /who function without player involvement, automatic Login messages will only be sent to players of the same guild.
			if glrCharacter.Data.OtherStatus ~= nil then
				for t, v in pairs(glrCharacter.Data.OtherStatus) do
					for key, val in pairs(glrCharacter.Data.OtherStatus[t]) do
						if not glrCharacter.Data.OtherStatus[t][key].sentMessage then
							local names = glrCharacter.Data.OtherStatus[t][key].Requesters
							local continue = false
							local check = false
							local TargetsRealm
							local TargetName = tostring(key)
							if string.find(string.lower(key), "-") ~= nil then
								TargetsRealm = string.sub(key, string.find(key, "-") + 1)
							end
							if PlayerRealmName == TargetsRealm then
								TargetName = string.sub(key, 1, string.find(key, "-") - 1)
							end
							
							for i = 1, numTotalMembers do
								local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
								if key == name then
									if isOnline then
										continue = true
									end
									break
								end
							end
							if continue then
								SendTicketHolderNotification(key, names, t, TargetName)
							end
							
							-- if not status then
								-- for i = 1, numTotalMembers do
									-- local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
									-- if key == name then
										-- if isOnline then
											-- continue = true
										-- end
										-- break
									-- end
								-- end
							-- else
								-- for keys, vals in pairs(glrHistory.GuildRoster[faction]) do
									-- for i = 1, #glrHistory.GuildRoster[faction][keys] do
										-- local CompareText = string.sub(glrHistory.GuildRoster[faction][keys][i], 1, string.find(glrHistory.GuildRoster[faction][keys][i], '%[') - 1)
										-- if CompareText == key then
											-- check = true
											-- break
										-- end
									-- end
									-- if check then
										-- break
									-- end
								-- end
								-- if check then
									-- local TargetName = GLR_Libs.WhoLib:UserInfo(target, 
										-- {
											-- timeout = 1,
											-- Online,
											-- callback = function(TargetName)
												-- SendTicketHolderNotification(key, names, t, TargetName)
											-- end
										-- }
									-- )
								-- end
							-- end
							-- if continue then
								-- SendTicketHolderNotification(key, names, t, _)
							-- end
							
						end
					end
				end
			end
			
			local gName = glrCharacter.Data.Settings.General.GuildName
			
			if gName ~= nil and gName ~= "GLR - No Guild" and gName ~= "" then
				
				if glrHistory.CharacterGuilds[FullPlayerName] == nil then
					glrHistory.CharacterGuilds[FullPlayerName] = {}
					glrHistory.CharacterGuilds[FullPlayerName] = gName
				else
					local tName = glrHistory.CharacterGuilds[FullPlayerName]
					
					if tName ~= gName then
						glrHistory.CharacterGuilds[FullPlayerName] = gName
					end
					
				end
				
				if glrHistory.GuildStatus[faction][gName] == nil then
					local status = glrCharacter.Data.Settings.General.MultiGuild
					glrHistory.GuildStatus[faction][gName] = {}
					glrHistory.GuildStatus[faction][gName] = status
				else
					local status = glrCharacter.Data.Settings.General.MultiGuild
					if status then
						glrHistory.GuildStatus[faction][gName] = status
					end
				end
				
				if glrHistory.ActiveEvents[FullPlayerName] then --Only want to do this if the player is currently hosting
					for f, tf in pairs(glrHistory.GuildStatus) do
						for g, tg in pairs(glrHistory.GuildStatus[f]) do
							for t, v in pairs(glrHistory.MultiGuildStatus) do
								if glrHistory.CharacterGuilds[t] == false then
									glrHistory.GuildStatus[f][g] = false
									glrHistory.MultiGuildStatus[t] = false
								end
							end
							if not glrHistory.GuildStatus[f][g] then
								for t, v in pairs(glrHistory.MultiGuildStatus) do
									if glrHistory.CharacterGuilds[t] ~= false then
										if glrHistory.MultiGuildStatus[t] and glrHistory.CharacterGuilds[t] == g then
											glrHistory.GuildStatus[f][g] = true
											break
										end
									end
								end
							end
						end
					end
				end
				
			end
			
			CheckForGivenOrSold()
			GLR_U:UpdateInfo(false)
			
		end
		
		if Variables[6] and not GLR_Global_Variables[1] then
			
			GLR_Global_Variables[1] = true
			GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton:Enable()
			GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton:Enable()
			if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
				GLR_UI.GLR_ScanMailButton:Enable()
				if glrCharacter.Data.Settings.CurrentlyActiveLottery then
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_DonationButton:Enable()
				end
				if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
					GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButton:Enable()
					GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButton:Enable()
					if not glrCharacter.Event.Raffle.SecondPlace or not glrCharacter.Event.Raffle.ThirdPlace then
						GLR_GoToAddRafflePrizes:Enable()
					end
				end
			end
			
			if glrCharacter.Data.Settings.General.ToggleChatInfo then
				GLR:Print(L["GLR - Core - Initialization Complete"])
			end
			
			local timestamp = GetTimeStamp()
			
			if InitalizationDebug == 2 then
				InitalizationDebug = 3
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Initialization Function Complete. Time To Completion: " .. Variables[7] .. " Seconds.")
			end
			
			if glrCharacter.Data.Settings.General.AnnounceAutoAbort ~= nil then
				if glrCharacter.Data.Settings.General.AnnounceAutoAbort then
					SendChatMessage("GLR: Draw Process Automatically Aborted. Client Restart Detected.", "GUILD")
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Announced Auto-Abort of Event Draw.")
					glrCharacter.Data.Settings.General.AnnounceAutoAbort = false
				end
			end
			
		end
		
	end
	
	if InitalizationDebug == 4 then
		InitalizationDebug = 5
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialization() - Initialization Function Failed or No Guild Detected")
	end
	
end

local function Initialize()
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialize() - Preforming Initialize Function")
	
	local numberOfMonth = {
		[1] = L["January Short"],
		[2] = L["February Short"],
		[3] = L["March Short"],
		[4] = L["April Short"],
		[5] = L["May Short"],
		[6] = L["June Short"],
		[7] = L["July Short"],
		[8] = L["August Short"],
		[9] = L["September Short"],
		[10] = L["October Short"],
		[11] = L["November Short"],
		[12] = L["December Short"]
	}
	local numberOfDay = {
		[1] = "st",
		[2] = "nd",
		[3] = "rd",
		[4] = "th",
		[5] = "th",
		[6] = "th",
		[7] = "th",
		[8] = "th",
		[9] = "th",
		[10] = "th",
		[11] = "th",
		[12] = "th",
		[13] = "th",
		[14] = "th",
		[15] = "th",
		[16] = "th",
		[17] = "th",
		[18] = "th",
		[19] = "th",
		[20] = "th",
		[21] = "st",
		[22] = "nd",
		[23] = "rd",
		[24] = "th",
		[25] = "th",
		[26] = "th",
		[27] = "th",
		[28] = "th",
		[29] = "th",
		[30] = "th",
		[31] = "st"
	}
	
	local faction, _ = UnitFactionGroup("PLAYER")
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local dateTime = time()
	local EventStatus = false
	local CheckVersion, _ = string.gsub(GLR_Version, "%.", "")
	local _, englishClass, _ = UnitClass("PLAYER")
	--[[
	/script local t = date() print(t)
	]]
	if guildName == nil or guildName == "" then guildName = false end
	
	local VersionCheckTable = {
		[1] = { [1] = 3103, [2] = 301004 },
		[2] = { [1] = 3107, [2] = 301008 }
	}
	
	if tonumber(CheckVersion) == nil then
		while true do
			local length = string.len(CheckVersion)
			CheckVersion = string.sub(CheckVersion, 1, length - 1)
			if tonumber(CheckVersion) ~= nil then break end
		end
	end
	
	for i = 1, #VersionCheckTable do
		if tonumber(CheckVersion) <= VersionCheckTable[i][1] and tonumber(GLR_VersionString) >= VersionCheckTable[i][2] then
			Variables[1] = true
			break
		end
	end
	
	if Variables[1] then
		if GLR_Version ~= GLR_VersionCheck then
			Variables[2] = true
		end
	end
	
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		EventStatus = true
	elseif glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		EventStatus = true
	end
	
	if glrHistory == nil then
		glrHistory = {}
	end
	
	-- if guildData == nil then
		-- guildData = {}
	-- end
	
	guildData = {}
	
	if glrHistory.PlayerClass[faction][FullPlayerName] == nil then
		glrHistory.PlayerClass[faction][FullPlayerName] = englishClass
	end
	
	if glrHistory.Whispers[FullPlayerName] == nil then
		glrHistory.Whispers[FullPlayerName] = { [1] = false, [2] = false, [3] = { [1] = L["GLR - Core - Whisper Default"], [2] = L["GLR - Core - Whisper Default"], }, } -- 1 = Lottery, 2 = Raffle. [3] = Messages (1-Lottery, 2-Raffle).
	end
	
	-- if guildData.Alliance == nil then
		-- guildData.Alliance = {}
	-- end
	-- if guildData.Horde == nil then
		-- guildData.Horde = {}
	-- end
	-- if guildData.Initialized == nil then
		-- if guildData.Initalized ~= nil then
			-- guildData.Initialized = guildData.Initalized
		-- else
			-- guildData.Initialized = false
		-- end
	-- end
	
	-- if guildData.Initalized ~= nil then --Removes old data entry
		-- guildData.Initalized = nil
	-- end
	
	-- if glrHistory.ClubInfo == nil then
		-- glrHistory.ClubInfo = { ["Alliance"] = {}, ["Horde"] = {} }
	-- end
	
	if glrHistory.lang == nil then
		if GetLocale() ~= nil then
			glrHistory.lang = GetLocale()
		end
	end
	
	if glrHistory.CharacterGuilds == nil then
		glrHistory.CharacterGuilds = {}
	end
	
	if glrHistory.MultiGuildStatus == nil then
		glrHistory.MultiGuildStatus = {}
	end
	
	if glrHistory.GuildStatus == nil then
		glrHistory.GuildStatus = {}
	end
	
	if glrHistory.GuildStatus.Alliance == nil then
		glrHistory.GuildStatus.Alliance = {}
	end
	
	if glrHistory.GuildStatus.Horde == nil then
		glrHistory.GuildStatus.Horde = {}
	end
	
	if glrHistory.GuildRoster == nil then
		glrHistory.GuildRoster = {}
	end
	
	if glrHistory.GuildRoster.Alliance == nil then
		glrHistory.GuildRoster.Alliance = {}
	end
	
	if glrHistory.GuildRoster.Horde == nil then
		glrHistory.GuildRoster.Horde = {}
	end
	
	if glrHistory.LastUpdated.Alliance == nil then
		glrHistory.LastUpdated.Alliance = {}
	end
	
	if glrHistory.LastUpdated.Horde == nil then
		glrHistory.LastUpdated.Horde = {}
	end
	
	if glrHistory.GuildRanks == nil then
		glrHistory.GuildRanks = {}
	end
	
	if glrHistory.GuildRanks.Alliance == nil then
		glrHistory.GuildRanks.Alliance = {}
	end
	
	if glrHistory.GuildRanks.Horde == nil then
		glrHistory.GuildRanks.Horde = {}
	end
	
	if glrHistory.CrossFaction == nil then
		glrHistory.CrossFaction = {}
	end
	
	if glrHistory.ActiveEvents == nil then
		glrHistory.ActiveEvents = {}
	end
	
	if glrHistory.DrawState == nil then
		glrHistory.DrawState = { ["Alliance"] = {}, ["Horde"] = {} }
	end
	
	if glrHistory.ActiveEvents[FullPlayerName] == nil then
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	else
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	end
	
	if glrHistory.PlayerFaction == nil then
		glrHistory.PlayerFaction = {}
	end
	
	if glrHistory.PlayerFaction[FullPlayerName] == nil then
		glrHistory.PlayerFaction[FullPlayerName] = {}
		glrHistory.PlayerFaction[FullPlayerName] = faction
	else
		local CheckFaction = glrHistory.PlayerFaction[FullPlayerName]
		if CheckFaction ~= faction then
			glrHistory.PlayerFaction[FullPlayerName] = faction --Redoes it in case a player changes faction.
		end
	end
	
	if glrHistory.GuildFaction == nil then
		glrHistory.GuildFaction = {}
	end
	
	if glrHistory.GuildFaction.Alliance == nil then
		glrHistory.GuildFaction.Alliance = {}
	end
	
	if glrHistory.GuildFaction.Horde == nil then
		glrHistory.GuildFaction.Horde = {}
	end
	
	if glrHistory.Profile == nil then
		glrHistory.Profile = {}
	end
	
	if glrHistory.Profile.Lottery == nil then
		glrHistory.Profile.Lottery = {}
	end
	
	if glrHistory.Profile.Raffle == nil then
		glrHistory.Profile.Raffle = {}
	end
	
	if glrHistory.Profile.Lottery[FullPlayerName] == nil then
		glrHistory.Profile.Lottery[FullPlayerName] = { ["StartingGold"] = "0", ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["SecondPlace"] = "0", ["GuildCut"] = "0", ["Guaranteed"] = false }
	else
		local ProfileTable = glrCharacter.Data.Settings.Profile.Lottery
		glrHistory.Profile.Lottery[FullPlayerName] = ProfileTable
	end
	
	if glrHistory.Profile.Raffle[FullPlayerName] == nil then
		glrHistory.Profile.Raffle[FullPlayerName] = { ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["InvalidItems"] = false }
	else
		local ProfileTable = glrCharacter.Data.Settings.Profile.Raffle
		glrHistory.Profile.Raffle[FullPlayerName] = ProfileTable
	end
	
	if glrHistory.Profile.Messages == nil then
		glrHistory.Profile.Messages = {}
	end
	
	if glrHistory.Profile.Messages.Lottery == nil then
		glrHistory.Profile.Messages.Lottery = {}
	end
	
	if glrHistory.Profile.Messages.Raffle == nil then
		glrHistory.Profile.Messages.Raffle = {}
	end
	
	if glrHistory.Profile.Messages.Both == nil then
		glrHistory.Profile.Messages.Both = {}
	end
	
	if glrHistory.Profile.Messages.Lottery[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = {}
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild Lottery Scheduled"] .. ": %lottery_date", [3] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [6] = L["Alert Guild Tickets Bought"] .. ": %lottery_winamount", [7] = L["Alert Guild Whisper For Lottery Info"], [8] = false }
	else
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Lottery
	end
	
	if glrHistory.Profile.Messages.Raffle[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = {}
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild Raffle Scheduled"] .. ": %raffle_date", [3] = L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"]  .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [6] = "%raffle_total " .. L["Alert Guild Raffle Tickets Bought"], [7] = L["Alert Guild Whisper For Raffle Info"], [8] = false }
	else
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Raffle
	end
	
	if glrHistory.Profile.Messages.Both[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Both[FullPlayerName] = {}
		glrHistory.Profile.Messages.Both[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild LaR Scheduled"] .. ":", [3] = L["Lottery"] .. ": %lottery_date, " .. L["Raffle"] .. ": %raffle_date", [4] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name, " .. L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name.", [5] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [6] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [7] = L["Lottery"] .. ": " .. L["Alert Guild Tickets Bought"] .. " %lottery_winamount", [8] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [9] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [10] = L["Raffle"] .. ": %raffle_total " .. L["Alert Guild Raffle Tickets Bought"], [11] = L["Alert Guild Whisper For LaR Info"], [12] = false }
	else
		glrHistory.Profile.Messages.Both[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Both
	end
	
	if glrCharacter == nil then
		glrCharacter = {}
	end
	
	if glrCharacter.Data == nil then
		glrCharacter.Data = {}
	end
	
	if glrCharacter.Data.Defaults == nil then
		glrCharacter.Data.Defaults = {}
	end
	
	if glrCharacter.Data.Settings == nil then
		glrCharacter.Data.Settings = {}
	end
	
	if glrCharacter.Lottery == nil then
		glrCharacter.Lottery = {}
	end
	
	if glrCharacter.Lottery.Entries == nil then
		glrCharacter.Lottery.Entries = {}
	end
	
	if glrCharacter.Raffle == nil then
		glrCharacter.Raffle = {}
	end
	
	if glrCharacter.Raffle.Entries == nil then
		glrCharacter.Raffle.Entries = {}
	end
	
	if glrCharacter.Data.Defaults.LotteryDate == nil then --Placed here instead of inside the ADDON_LOADED function because date() returns "" there
		glrCharacter.Data.Defaults.LotteryDate = numberOfMonth[date("*t",  GetServerTime()).month] .. " " .. FormatNumber(date("*t",  GetServerTime()).day) .. numberOfDay[date("*t",  GetServerTime()).day] .. ", " .. date("*t",  GetServerTime()).year
		if glrCharacter.Data.Settings.General.DateFormatKey ~= nil then
			if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
				glrCharacter.Data.Defaults.LotteryDate = FormatNumber(date("*t",  GetServerTime()).day) .. numberOfDay[date("*t",  GetServerTime()).day] .. " of " .. numberOfMonth[date("*t",  GetServerTime()).month] .. ", " .. date("*t",  GetServerTime()).year
			end
		end
	else
		glrCharacter.Data.Defaults.LotteryDate = numberOfMonth[date("*t",  GetServerTime()).month] .. " " .. FormatNumber(date("*t",  GetServerTime()).day) .. numberOfDay[date("*t",  GetServerTime()).day] .. ", " .. date("*t",  GetServerTime()).year
		if glrCharacter.Data.Settings.General.DateFormatKey ~= nil then
			if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
				glrCharacter.Data.Defaults.LotteryDate = FormatNumber(date("*t",  GetServerTime()).day) .. numberOfDay[date("*t",  GetServerTime()).day] .. " of " .. numberOfMonth[date("*t",  GetServerTime()).month] .. ", " .. date("*t",  GetServerTime()).year
			end
		end
	end
	
	local GetMonth = GLR:GetCurrentMonth()
	local GetDay = GLR:GetCurrentDay()
	local GetYear = GLR:GetCurrentYear()
	local GetHour = GLR:GetCurrentHour()
	local GetMinute = GLR:GetCurrentMinute()
	
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
	
	if glrCharacter.Data.Settings.General.Status == "Lottery" then
		GLR_UI.GLR_MainFrame.GLR_RaffleFrame:Hide()
	elseif glrCharacter.Data.Settings.General.Status == "Raffle" then
		GLR_UI.GLR_MainFrame.GLR_LotteryFrame:Hide()
	end
	
	if glrHistory.Names == nil then
		glrHistory.Names = {}
		table.insert(glrHistory.Names, FullPlayerName)
	else
		local isFound = false
		for t, v in pairs(glrHistory.Names) do
			if v == FullPlayerName then
				isFound = true
			end
		end
		if not isFound then
			table.insert(glrHistory.Names, FullPlayerName)
		end
	end
	
	if not Variables[2] then
		GLR_U:UpdateRosterTable()
		GLR_U:UpdateInfo(false)
	end
	
	local CheckGuild = GLR_U:CheckGuildName()
	
	if CheckGuild then
		guildName, _, _, _ = GetGuildInfo("PLAYER")
	end
	
	if guildName ~= nil then
		
		if glrCharacter.Data.Settings.General.GuildName == nil then --Used to track whether or not to reply to message events, prevents spam to players not in the players guild.
			glrCharacter.Data.Settings.General.GuildName = guildName
		elseif glrCharacter.Data.Settings.General.GuildName ~= guildName then --Updates the players guild name if they switch.
			glrCharacter.Data.Settings.General.GuildName = guildName
		end
		
	end
	
	if glrHistory.MultiGuildStatus[FullPlayerName] == nil then
		local status = glrCharacter.Data.Settings.General.MultiGuild
		glrHistory.MultiGuildStatus[FullPlayerName] = {}
		glrHistory.MultiGuildStatus[FullPlayerName] = status
	else
		local status = glrCharacter.Data.Settings.General.MultiGuild
		local compare = glrHistory.MultiGuildStatus[FullPlayerName]
		
		if compare ~= status then
			glrCharacter.Data.Settings.General.MultiGuild = compare
		end
	end
	
	if glrHistory.CrossFaction[FullPlayerName] == nil then
		local FactionStatus = glrCharacter.Data.Settings.General.CrossFactionEvents
		glrHistory.CrossFaction[FullPlayerName] = {}
		glrHistory.CrossFaction[FullPlayerName] = FactionStatus
	else
		local FactionStatus = glrCharacter.Data.Settings.General.CrossFactionEvents
		local CurrentStatus = glrHistory.CrossFaction[FullPlayerName]
		if CurrentStatus ~= FactionStatus then
			glrHistory.CrossFaction[FullPlayerName] = FactionStatus
		end
	end
	
	-- Version 3.1.18 re-utilizes the "glrCharacter.Data.Settings.Raffle" structure, along with "Lottery" and "General"
	-- if glrCharacter.Data.Settings.Raffle ~= nil then --Fix for patch 3.0.64 where data being Transferred wasn't being placed in the correct spot. This clears up the un-used data.
		-- glrCharacter.Data.Settings.Raffle = nil
	-- end
	
	if not GLR_ReleaseState then
		if GLR_ReleaseType == "alpha" then
			GLR_CurrentVersionString = GLR_CurrentVersionString .. "-a"
		elseif GLR_ReleaseType == "beta" then
			GLR_CurrentVersionString = GLR_CurrentVersionString .. "-b"
		else
			GLR_CurrentVersionString = GLR_CurrentVersionString .. "-nr"
		end
	end
	
	if not GLR_ReleaseState then
		timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - Initialize() - Initialize Function Part [1] Complete")
	end
	
	GLR:ToggleLotteryRaffle("update")
	Initialization()
	
end

function GLR:PLAYER_LOGIN()
	
	if glrHistory.Debug == nil then
		glrHistory.Debug = {}
	end
	
	if glrHistory.BulkDebug == nil then
		glrHistory.BulkDebug = {}
	end
	
	if glrHistory.Debug[FullPlayerName] == nil then
		glrHistory.Debug[FullPlayerName] = {}
	end
	
	if glrHistory.BulkDebug[FullPlayerName] == nil then
		glrHistory.BulkDebug[FullPlayerName] = {}
	end
	
	local timestamp = GetTimeStamp()
	if not GLR_ReleaseState then
		table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - PLAYER_LOGIN() - Preforming Login Function")
	end
	
	for t, v in pairs(glrHistory.TransferAvailable) do
		for k, v in pairs(glrHistory.TransferAvailable[t]) do
			if glrHistory.TransferAvailable[t][k] then
				if glrHistory.TransferData[k].Data.Settings.DateFormatKey == nil then
					glrHistory.TransferData[k].Data.Settings.DateFormatKey = 1
				end
				if t == "Lottery" then
					if glrHistory.TransferData[k].Data.Settings.WinChanceKey == nil then
						glrHistory.TransferData[k].Data.Settings.WinChanceKey = 5
					end
					if glrHistory.TransferData[k].Data.Settings.NoGuildCut == nil then
						glrHistory.TransferData[k].Data.Settings.NoGuildCut = false
					end
					if glrHistory.TransferData[k].Data.Settings.RoundValue == nil then
						glrHistory.TransferData[k].Data.Settings.RoundValue = 1
					end
				end
			end
		end
	end
	
	if glrHistory.Profile ~= nil then
		if glrHistory.Profile.Messages.Raffle ~= nil then
			for t, v in pairs(glrHistory.Profile.Messages.Raffle) do
				local doBreak = false
				for i = 1, #glrHistory.Profile.Messages.Raffle[t] do
					if i == 8 and glrHistory.Profile.Messages.Raffle[t][i] == false then
						glrHistory.Profile.Messages.Raffle[t][7] = L["Raffle Draw Step 1"] .. ": %raffle_prizes"
						glrHistory.Profile.Messages.Raffle[t][8] = L["Alert Guild Whisper For Raffle Info"]
						glrHistory.Profile.Messages.Raffle[t][9] = false
					end
					doBreak = true
					break
				end
				if doBreak then break end
			end
		end
	end
	
	if glrHistory.TransferStatus ~= nil then
		if glrHistory.TransferStatus.Lottery[FullPlayerName] then
			glrCharacter.Data.Settings.CurrentlyActiveLottery = false
			glrCharacter.Data.OtherStatus.Lottery = {}
			glrCharacter.Event.Lottery = {}
			glrCharacter.Lottery = { ["MessageStatus"] = {}, ["TicketPool"] = {}, ["Entries"] = { ["TicketNumbers"] = {}, ["TicketRange"] = {}, ["Tickets"] = {}, ["Names"] = {}, } }
			glrHistory.TransferStatus.Lottery[FullPlayerName] = false
			glrHistory.TransferAvailable.Lottery[FullPlayerName] = false
		end
		if glrHistory.TransferStatus.Raffle[FullPlayerName] then
			glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
			glrCharacter.Data.OtherStatus.Raffle = {}
			glrCharacter.Data.Raffle = { ["FirstPrizeData"] = { ["ItemLink"] = {}, ["ItemName"] = {}, }, ["SecondPrizeData"] = { ["ItemLink"] = {}, ["ItemName"] = {}, }, ["ThirdPrizeData"] = { ["ItemLink"] = {}, ["ItemName"] = {}, }, }
			glrCharacter.Event.Raffle = {}
			glrCharacter.Raffle = { ["MessageStatus"] = {}, ["TicketPool"] = {}, ["Entries"] = { ["TicketNumbers"] = {}, ["TicketRange"] = {}, ["Tickets"] = {}, ["Names"] = {}, } }
			glrHistory.TransferStatus.Raffle[FullPlayerName] = false
			glrHistory.TransferAvailable.Raffle[FullPlayerName] = false
		end
	end
	
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		table.insert(GLR_AddOnMessageTable.ActiveEvents.Lottery, FullPlayerName)
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		table.insert(GLR_AddOnMessageTable.ActiveEvents.Raffle, FullPlayerName)
	end
	
	C_ChatInfo.SendAddonMessage("GLR_LOGIN", FullPlayerName, "GUILD")
	C_Timer.After(10, function(self)
		local lottery = tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)
		local raffle = tostring(glrCharacter.Data.Settings.CurrentlyActiveRaffle)
		C_ChatInfo.SendAddonMessage("GLR_HASMOD", GLR_VersionString .. "?" .. GLR_Version, "GUILD")
		C_ChatInfo.SendAddonMessage("GLR_CHECK", "%lottery_" .. lottery .. "!%raffle_" .. raffle, "GUILD")
	end)
	
	if glrCharacter == nil then
		glrCharacter = {}
	end
	if glrCharacter.Data == nil then
		glrCharacter.Data = {}
	end
	if glrCharacter.Data.Settings == nil then
		glrCharacter.Data.Settings = {}
	end
	if glrCharacter.Data.Settings.General.Status == nil then
		glrCharacter.Data.Settings.General.Status = "Lottery"
	end
	if glrCharacter.Data.Settings.General.Status == "Lottery" then
		GLR_UI.GLR_MainFrame.GLR_RaffleFrame:Hide()
	elseif glrCharacter.Data.Settings.General.Status == "Raffle" then
		GLR_UI.GLR_MainFrame.GLR_LotteryFrame:Hide()
	end
	
	if glrCharacter.Event.Lottery.EventName ~= nil then
		if glrCharacter.Event.Lottery.GiveAwayTickets == nil then
			glrCharacter.Event.Lottery.GiveAwayTickets = 0
		end
	end
	if glrCharacter.Event.Raffle.EventName ~= nil then
		if glrCharacter.Event.Raffle.GiveAwayTickets == nil then
			glrCharacter.Event.Raffle.GiveAwayTickets = 0
		end
	end
	
	timestamp = GetTimeStamp()
	table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - PLAYER_LOGIN() - Login Function Complete")
	
	Initialize()
	
end

function GLR:PLAYER_LOGOUT()
	
	if glrHistory.Debug == nil then
		glrHistory.Debug = {}
	end
	
	if glrHistory.Debug[FullPlayerName] == nil then
		glrHistory.Debug[FullPlayerName] = {}
	end
	
	if glrHistory.BulkDebug == nil then
		glrHistory.BulkDebug = {}
	end
	
	if glrHistory.BulkDebug[FullPlayerName] == nil then
		glrHistory.BulkDebug[FullPlayerName] = {}
	end
	
	if GLR_AddOnMessageTable_Debug.Messages[1] ~= nil then
		if glrHistory.Debug[FullPlayerName][1] == nil then
			if #GLR_AddOnMessageTable_Debug.Messages > 2000 then --Trims table to prevent more than 2000 Debug messages being saved.
				local diff = #GLR_AddOnMessageTable_Debug.Messages - 1998
				for i = 1, diff do
					table.remove(GLR_AddOnMessageTable_Debug.Messages, 1)
				end
			end
			glrHistory.Debug[FullPlayerName] = GLR_AddOnMessageTable_Debug.Messages
		else
			local a = #glrHistory.Debug[FullPlayerName]
			local b = #GLR_AddOnMessageTable_Debug.Messages
			local c = a + b
			if c > 2000 then --Prevents more than 2000 Debug messages being saved per character.
				local d = c - 1998 --Leaves room for the final two Debug messages to be saved, leaving the total messages at 2000.
				for i = 1, d do --Removes oldest Debug messages.
					if glrHistory.Debug[FullPlayerName][1] == nil then break end
					table.remove(glrHistory.Debug[FullPlayerName], 1)
				end
				for i = 1, b do
					table.insert(glrHistory.Debug[FullPlayerName], GLR_AddOnMessageTable_Debug.Messages[i])
				end
			else
				for i = 1, b do
					table.insert(glrHistory.Debug[FullPlayerName], GLR_AddOnMessageTable_Debug.Messages[i])
				end
			end
		end
		local timestamp = GetTimeStamp()
		table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - PLAYER_LOGOUT() - Preforming Logout Function")
	end
	
	C_ChatInfo.SendAddonMessage("GLR_LOGOUT", FullPlayerName, "GUILD")
	
	local CheckGuild = GLR_U:CheckGuildName()
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local EventStatus = false
	
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		EventStatus = true
	elseif glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		EventStatus = true
	end
	
	if guildName == nil and CheckGuild then
		guildName, _, _, _ = GetGuildInfo("PLAYER")
	end
	
	if glrHistory == nil then
		glrHistory = {}
	end
	
	if glrHistory.CharacterGuilds == nil then
		glrHistory.CharacterGuilds = {}
	end
	
	if guildName ~= nil then
		
		if glrCharacter.Data.Settings.General.GuildName == nil then
			glrCharacter.Data.Settings.General.GuildName = guildName
		elseif glrCharacter.Data.Settings.General.GuildName ~= guildName then
			glrCharacter.Data.Settings.General.GuildName = guildName
		end
		
	end
	
	if glrCharacter.Data.Settings.General.UserName == nil or glrCharacter.Data.Settings.General.UserName == "" or glrCharacter.Data.Settings.General.UserName ~= FullPlayerName then
		
		glrCharacter.Data.Settings.General.UserName = FullPlayerName
		
	end
	
	if glrHistory.Profile.Lottery[FullPlayerName] == nil then
		glrHistory.Profile.Lottery[FullPlayerName] = { ["StartingGold"] = "0", ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["SecondPlace"] = "0", ["GuildCut"] = "0", ["Guaranteed"] = false }
	else
		local ProfileTable = glrCharacter.Data.Settings.Profile.Lottery
		glrHistory.Profile.Lottery[FullPlayerName] = ProfileTable
	end
	
	--Error correction for bug introduced sometime on or before v3.1.03
	--Fixed players unable to set the Invalid Items Raffle Profile option from True to False, so now going through the main table to auto-correct the other tables.
	for t, v in pairs(glrHistory.Profile.Raffle) do
		if glrHistory.Profile.Raffle[t].InvalidItems ~= false and glrHistory.Profile.Raffle[t].InvalidItems ~= true then
			glrHistory.Profile.Raffle[t].InvalidItems = false
		end
	end
	
	if glrHistory.Profile.Raffle[FullPlayerName] == nil then
		glrHistory.Profile.Raffle[FullPlayerName] = { ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["InvalidItems"] = false }
	else
		local ProfileTable = glrCharacter.Data.Settings.Profile.Raffle
		if ProfileTable.InvalidItems ~= false and ProfileTable.InvalidItems ~= true then --Same as the error correction above, but for the Character Specific save data.
			glrCharacter.Data.Settings.Profile.Raffle.InvalidItems = false
			ProfileTable.InvalidItems = false
		end
		glrHistory.Profile.Raffle[FullPlayerName] = ProfileTable
	end
	
	if glrHistory.Profile.Messages.Lottery[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = {}
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild Lottery Scheduled"] .. ": %lottery_date", [3] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [6] = L["Alert Guild Tickets Bought"] .. ": %lottery_winamount", [7] = L["Alert Guild Whisper For Lottery Info"], [8] = false }
	else
		glrHistory.Profile.Messages.Lottery[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Lottery
	end
	
	if glrHistory.Profile.Messages.Raffle[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = {}
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild Raffle Scheduled"] .. ": %raffle_date", [3] = L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"]  .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [6] = "%raffle_total " .. L["Alert Guild Raffle Tickets Bought"], [7] = L["Alert Guild Whisper For Raffle Info"], [8] = false }
	else
		glrHistory.Profile.Messages.Raffle[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Raffle
	end
	
	if glrHistory.Profile.Messages.Both[FullPlayerName] == nil then
		glrHistory.Profile.Messages.Both[FullPlayerName] = {}
		glrHistory.Profile.Messages.Both[FullPlayerName] = { [1] = L["Alert Guild GLR Title"], [2] = L["Alert Guild LaR Scheduled"] .. ":", [3] = L["Lottery"] .. ": %lottery_date, " .. L["Raffle"] .. ": %raffle_date", [4] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name, " .. L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name.", [5] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [6] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [7] = L["Lottery"] .. ": " .. L["Alert Guild Tickets Bought"] .. " %lottery_winamount", [8] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [9] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [10] = L["Raffle"] .. ": %raffle_total " .. L["Alert Guild Raffle Tickets Bought"], [11] = L["Alert Guild Whisper For LaR Info"], [12] = false }
	else
		glrHistory.Profile.Messages.Both[FullPlayerName] = glrCharacter.Data.Messages.GuildAlerts.Both
	end
	
	if glrHistory.ActiveEvents[FullPlayerName] == nil then
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	else
		glrHistory.ActiveEvents[FullPlayerName] = EventStatus
	end
	
	if glrHistory.TransferData ~= nil then
		local t = {}
		local continue = false
		if glrCharacter.Data.Settings.CurrentlyActiveLottery or glrCharacter.Data.Settings.CurrentlyActiveRaffle then
			continue = true
		end
		glrHistory.TransferAvailable.Lottery[FullPlayerName] = glrCharacter.Data.Settings.CurrentlyActiveLottery
		glrHistory.TransferAvailable.Raffle[FullPlayerName] = glrCharacter.Data.Settings.CurrentlyActiveRaffle
		if continue then
			for key, val in pairs(glrCharacter) do
				if key == "Data" then
					if t[key] == nil then
						t[key] = {}
					end
					--glrCharacter.Data.Settings.Lottery.WinChanceKey
					for k, v in pairs(glrCharacter[key]) do
						if k == "Raffle" and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
							if t[key][k] == nil then
								t[key][k] = {}
							end
							t[key][k] = glrCharacter[key][k]
						elseif k == "Settings" then
							if t[key][k] == nil then
								t[key][k] = {}
							end
							if t[key][k]["DateFormatKey"] == nil then
								t[key][k]["DateFormatKey"] = glrCharacter[key][k].General.DateFormatKey
							end
							if glrCharacter.Data.Settings.CurrentlyActiveLottery then
								t[key][k]["TicketSeries"] = glrCharacter[key][k].General.TicketSeries
								t[key][k]["NoGuildCut"] = glrCharacter[key][k].Lottery.NoGuildCut
								t[key][k]["WinChanceKey"] = glrCharacter[key][k].Lottery.WinChanceKey
								t[key][k]["RoundValue"] = glrCharacter[key][k].Lottery.RoundValue
							end
							if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
								t[key][k]["RaffleSeries"] = glrCharacter[key][k].General.RaffleSeries
								t[key][k]["AllowMultipleRaffleWinners"] = glrCharacter[key][k].Raffle.AllowMultipleRaffleWinners
							end
							for n, u in pairs(glrCharacter[key][k]) do
								if n == "PreviousLottery" then
									if t[key][k][n] == nil then
										t[key][k][n] = {}
									end
									t[key][k][n] = glrCharacter[key][k][n]
								end
							end
						elseif k == "OtherStatus" then
							if t[key][k] == nil then
								t[key][k] = {}
							end
							t[key][k] = glrCharacter[key][k]
						end
					end
				elseif key == "Event" then
					if t[key] == nil then
						t[key] = {}
					end
					for k, v in pairs(glrCharacter[key]) do
						if k == "Lottery" and glrCharacter.Data.Settings.CurrentlyActiveLottery then
							if t[key][k] == nil then
								t[key][k] = {}
							end
							t[key][k] = glrCharacter[key][k]
						elseif k == "Raffle" and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
							if t[key][k] == nil then
								t[key][k] = {}
							end
							t[key][k] = glrCharacter[key][k]
						end
					end
				elseif key == "Lottery" and glrCharacter.Data.Settings.CurrentlyActiveLottery then
					if t[key] == nil then
						t[key] = {}
					end
					for k, v in pairs(glrCharacter[key]) do
						if t[key][k] == nil then
							t[key][k] = {}
						end
						t[key][k] = glrCharacter[key][k]
					end
				elseif key == "Raffle" and glrCharacter.Data.Settings.CurrentlyActiveRaffle then
					if t[key] == nil then
						t[key] = {}
					end
					for k, v in pairs(glrCharacter[key]) do
						if t[key][k] == nil then
							t[key][k] = {}
						end
						t[key][k] = glrCharacter[key][k]
					end
				end
			end
			glrHistory.TransferData[FullPlayerName] = t
		else
			glrHistory.TransferData[FullPlayerName] = nil
		end
	end
	
	local numTotalMembers, _, _ = GetNumGuildMembers()
	local faction, _ = UnitFactionGroup("PLAYER")
	if glrHistory.GuildRanks[faction][guildName] ~= nil then
		local t = {}
		for i = 1 , GuildControlGetNumRanks() do
			t[i] = GuildControlGetRankName(i)
		end
		glrHistory.GuildRanks[faction][guildName] = t
	end
	
	local timestamp = GetTimeStamp()
	
	glrHistory.Settings.LastDebugUpdate[FullPlayerName] = timestamp
	glrCharacter.Data.Settings.General.LastDebugUpdate = timestamp
	
	table.insert(glrHistory.Debug[FullPlayerName], timestamp .. " - " .. GLR_GameVersion .. " - PLAYER_LOGOUT() - Logout Function Complete")
	
end

--Purpose: To act as a buffer when checking Player Online status in a Multi-Guild event.
function GLR:CheckMultiGuildPlayerStatus(target, glrTemp, vN, state)
	local online = target.Online
	if online then
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. vN .. " - " .. L["Send Info Player Online"] .. "|r")
		end
	else
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. vN .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
	end
end

---------------------------------------------
------------ SHOW USER INTERFACE ------------
---------------------------------------------
-------- DISPLAYS THE UI, IF ENABLED --------
---------------------------------------------

function GLR:ShowGLRFrame()
	
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local continue = true
	
	if glrCharacter.Data.Settings.General.Status == "Lottery" then
		GLR_UI.GLR_MainFrame.GLR_RaffleFrame:Hide()
	elseif glrCharacter.Data.Settings.General.Status == "Raffle" then
		GLR_UI.GLR_MainFrame.GLR_LotteryFrame:Hide()
	end
	
	if Variables[1] then
		if GLR_Version ~= GLR_VersionCheck then
			continue = false
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ShowGLRFrame() - Critical Update Detected")
			GLR:Print(L["GLR - Core - Critical Update Detected"])
		end
	end
	
	if continue then
		
		Variables[10] = glrCharacter.Data.Settings.General.Status
		
		GLR_L:SetFontSizes()
		
		if guildName ~= nil then
			
			if glrCharacter.Data.Settings.General.enabled == true then
				
				if GLR_UI.GLR_MainFrame:IsVisible() then
					GLR_U:UpdateInfo(false)
					GLR_UI.GLR_MainFrame:Hide()
				else
					--Quick and dirty way to get font strings to show completely
					GLR_UI.GLR_MainFrame:Show()
					GLR_UI.GLR_MainFrame:Hide()
					GLR_UI.GLR_MainFrame:Show()
					GLR_U:UpdateInfo()
				end
				
			else
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ShowGLRFrame() - AddOn is disabled, please enable it to begin a Lottery/Raffle")
				chat:AddMessage("|cfff7ff4d" .. L["GLR - Core - Disabled Message"] .. "|r")
			end
			
			GLR_U:GetLinkedNames()
			GLR_U:GetLinkedGuilds()
			GLR_U:UpdateMultiGuildTable()
			
		else
			local timestamp = GetTimeStamp()
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ShowGLRFrame() - You must be in a Guild to use this Addon")
			chat:AddMessage("|cfff7ff4d" .. L["GLR - Core - Disabled No Guild Message"] .. "|r")
		end
		
	end
	
end

---------------------------------------------
----------- TOGGLE LOTTERY/RAFFLE -----------
---------------------------------------------
---------- SWITCHES BETWEEN LOTTERY ---------
----------------- AND RAFFLE ----------------
---------------------------------------------

function GLR:ToggleLotteryRaffle(arg)
	
	local LorR = glrCharacter.Data.Settings.General.Status
	local CheckGuild = GLR_U:CheckGuildName()
	
	if arg == "toggle" then
		
		if GLR_UI.GLR_MainFrame.GLR_RaffleFrame:IsVisible() then
			LorR = "Raffle"
		elseif GLR_UI.GLR_MainFrame.GLR_LotteryFrame:IsVisible() then
			LorR = "Lottery"
		end
		
		glrCharacter.Data.Settings.General.Status = LorR
		Variables[10] = LorR
		
		GLR:ToggleLotteryRaffle("update")
		
	end
	
	if arg == "update" then
		
		if LorR == "Lottery" then -- Displays Lottery data
			
			GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButton, "BOTTOM", 0, -5)
			GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetPoint("LEFT", GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButton, "RIGHT", 5, 0)
			
		elseif LorR == "Raffle" then -- Displays Raffle data
			
			GLR_UI.GLR_MainFrame.GLR_OpenInterfaceOptionsButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_BeginRaffleButton, "BOTTOM", 0, -5)
			GLR_UI.GLR_MainFrame.GLR_AlertGuildButton:SetPoint("LEFT", GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButton, "RIGHT", 5, 0)
			
		end
		
		if CheckGuild and not Variables[2] then
			GLR_U:UpdateInfo()
		end
		
	end
	
end

---------------------------------------------
------------ CONFIRM NEW LOTTERY ------------
---------------------------------------------
---------- CONFIRMS FINAL SETTINGS ----------
-------------- FOR NEW LOTTERY --------------
---------------------------------------------

local function ConfirmNewLotterySettings()
	
	Variables[13][1] = 0
	
	local monthValue = {
		[L["January"]] = L["01"],
		[L["February"]] = L["02"],
		[L["March"]] = L["03"],
		[L["April"]] = L["04"],
		[L["May"]] = L["05"],
		[L["June"]] = L["06"],
		[L["July"]] = L["07"],
		[L["August"]] = L["08"],
		[L["September"]] = L["09"],
		[L["October"]] = L["10"],
		[L["November"]] = L["11"],
		[L["December"]] = L["12"]
	}
	local yearValue = {}
	local n
	if GLR_GameVersion == "RETAIL" then
		n = C_DateAndTime.GetCurrentCalendarTime()
	else
		n = C_DateAndTime.GetTodaysDate()
	end
	for i = 1, 2 do --Dynamically builds the list of potential years for new events to occur on, only does the current year + one as Calendar events can only be made up to one year in advance.
		local s = string.sub(tostring(n.year), 3, 4)
		yearValue[L[tostring(n.year)]] = L[s]
		n.year = n.year + 1
	end
	local useMonth = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	local SelectedMonth = monthValue[useMonth]
	local SelectedDay = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText()
	local useYear = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:GetText()
	local SelectedYear = yearValue[useYear]
	local SelectedHour = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:GetText()
	local SelectedMinute = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:GetText()
	local SelectedDate = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear
	local DateString = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
	local NewLotteryName = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:GetText()
	local NewLotteryStartingGold = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText()
	local NewLotteryMaxTickets = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:GetText()
	local NewLotteryTicketPrice = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText()
	local NewLotterySecondPlace = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:GetText()
	local NewLotteryGuildCut = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:GetText()
	local GuaranteeWinnerStatus = GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetChecked()
	
	local currentMonth = tonumber(date("%m"))
	local currentDay = tonumber(date("%d"))
	local currentYear = tonumber(date("%y"))
	local currentHour = tonumber(date("%H"))
	local currentMinute = tonumber(date("%M"))
	
	local selectedMonthNumber = tonumber(SelectedMonth)
	local selectedDayNumber = tonumber(SelectedDay)
	local selectedYearNumber = tonumber(SelectedYear)
	local selectedHourNumber = tonumber(SelectedHour)
	local selectedMinuteNumber = tonumber(SelectedMinute)
	
	local GuildCutNumber = -1
	local SecondCutNumber = -1
	local TicketPriceNumber = -1
	local MaxTicketsNumber = -1
	local StartingGoldNumber = -1
	local TotalGuildSecondCut = 101
	local CurrencyError = 0
	local ErrorTable = {
		false,	--Gold
		false,	--Silver
		false	--Copper
	}
	
	if NewLotteryGuildCut ~= "" then
		GuildCutNumber = tonumber(NewLotteryGuildCut)
		if GuildCutNumber ~= nil then
			TotalGuildSecondCut = GuildCutNumber
		end
	end
	if NewLotterySecondPlace ~= "" then
		SecondCutNumber = tonumber(NewLotterySecondPlace)
		if SecondCutNumber ~= nil then
			TotalGuildSecondCut = TotalGuildSecondCut + SecondCutNumber
		end
	end
	
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[1] = true
	end
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[2] = true
	end
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[3] = true
	end
	
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[1] = true
	end
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[2] = true
	end
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText() == nil or GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[3] = true
	end
	
	--Checks if more than one of the same type of Currecy Field is left blank
	--If so, it will cause the program to show that specific error. IE: "Silver Value Must Be Zero or Higher"
	--Does not need to be added to the Raffle portion as the only Currecy Error check is for Ticket Price.
	if CurrencyError > 1 then
		for i = 1, #ErrorTable do
			if ErrorTable[i] then
				Variables[13][1] = Variables[13][1] + 1
			end
		end
		if Variables[13][1] == 1 then
			CurrencyError = 1
		end
	end
	
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() == "" then
		NewLotteryTicketPrice = "0." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText()
	elseif GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() ~= "" then
		NewLotteryTicketPrice = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText()
	end
	if NewLotteryTicketPrice ~= "" and GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() ~= "" then
		TicketPriceNumber = tonumber(NewLotteryTicketPrice)
	end
	if NewLotteryMaxTickets ~= "" then
		MaxTicketsNumber = tonumber(NewLotteryMaxTickets)
	end
	if GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() == "" then
		NewLotteryStartingGold = "0." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText()
	elseif GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() ~= "" then
		NewLotteryStartingGold = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText()
	end
	if NewLotteryStartingGold ~= "" and GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() ~= "" then
		StartingGoldNumber = tonumber(NewLotteryStartingGold)
	end
	
	local bypass = false
	
	if selectedDayNumber > currentDay or selectedMonthNumber > currentMonth then
		
		bypass = true
		
	end
	
	if not bypass and selectedDayNumber == currentDay and selectedHourNumber > currentHour then
		
		bypass = true
		
	end
	
	if Variables[13][1] == 0 then
		local ToTooltip =  glrCharacter.Data.Settings.PreviousLottery.Jackpot + tonumber( GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText() )
		Variables[11] = GLR_U:GetMoneyValue(ToTooltip, "Lottery", true, 1, "NA", true, true)
	end
	
	if GuildCutNumber ~= nil then
		if GuildCutNumber <= 100 and GuildCutNumber >= 0 then
			if SecondCutNumber ~= nil then
				if SecondCutNumber <= 100 and SecondCutNumber >= 0 or GuaranteeWinnerStatus then
					if TotalGuildSecondCut <= 100 and TotalGuildSecondCut >= 0 then
						if TicketPriceNumber ~= nil then
							if TicketPriceNumber >= 0 then
								if MaxTicketsNumber ~= nil then
									if MaxTicketsNumber >= 1 and MaxTicketsNumber <= 50000 then
										if StartingGoldNumber ~= nil then
											if StartingGoldNumber >= 0 then
												if NewLotteryName ~= "" or NewLotteryName ~= nil then
													
													if currentYear == selectedYearNumber then
														if selectedMonthNumber >= currentMonth then
															if selectedDayNumber >= currentDay or bypass then
																if selectedHourNumber >= currentHour or bypass then
																	if currentMinute < selectedMinuteNumber and currentHour == selectedHourNumber or bypass then
																		
																		GLR_ConfirmNewLotteryFrame:Show()
																		
																	elseif currentMinute >= selectedMinuteNumber and currentHour ~= selectedHourNumber then
																		
																		GLR_ConfirmNewLotteryFrame:Show()
																		
																	else
																		GLR_ConfirmNewLotteryFrame:Hide()
																		GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Date Error"])
																	end
																else
																	GLR_ConfirmNewLotteryFrame:Hide()
																	GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Hour Error"])
																end
															else
																GLR_ConfirmNewLotteryFrame:Hide()
																GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Day Error"])
															end
														else
															GLR_ConfirmNewLotteryFrame:Hide()
															GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Month Error"])
														end
													end
													
													if selectedYearNumber > currentYear then
														GLR_ConfirmNewLotteryFrame:Show()
													end
													
												else
													GLR_ConfirmNewLotteryFrame:Hide()
													GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Lottery Name Error"])
												end
											else
												GLR_ConfirmNewLotteryFrame:Hide()
												GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Starting Gold Error"])
											end
										else
											GLR_ConfirmNewLotteryFrame:Hide()
											GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Starting Gold Error"])
										end
									else
										GLR_ConfirmNewLotteryFrame:Hide()
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Max Ticket Error"])
									end
								else
									GLR_ConfirmNewLotteryFrame:Hide()
									GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Max Ticket Error"])
								end
							else
								if ErrorTable[3] == true then
									if CurrencyError > 1 then
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
									else
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Copper Entry"])
									end
								elseif ErrorTable[2] == true then
									if CurrencyError > 1 then
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
									else
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Silver Entry"])
									end
								elseif ErrorTable[1] == true then
									if CurrencyError > 1 then
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
									else
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Gold Entry"])
									end
								else
									if CurrencyError > 1 then
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
									else
										GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Must Have Higher Value"])
									end
								end
								GLR_ConfirmNewLotteryFrame:Hide()
							end
						else
							GLR_ConfirmNewLotteryFrame:Hide()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Invalid Ticket Error"])
						end
					else
						GLR_ConfirmNewLotteryFrame:Hide()
						GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Guild & Second Place Error"])
					end
				else
					GLR_ConfirmNewLotteryFrame:Hide()
					GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Second Place Error"])
				end
			else
				GLR_ConfirmNewLotteryFrame:Hide()
				GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Second Place Error"])
			end
		else
			GLR_ConfirmNewLotteryFrame:Hide()
			GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Guild Cut Error"])
		end
	else
		GLR_ConfirmNewLotteryFrame:Hide()
		GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText(L["Guild Cut Error"])
	end
	
end

local function ConfirmNewRaffleSettings()
	
	local monthValue = {
		[L["January"]] = L["01"],
		[L["February"]] = L["02"],
		[L["March"]] = L["03"],
		[L["April"]] = L["04"],
		[L["May"]] = L["05"],
		[L["June"]] = L["06"],
		[L["July"]] = L["07"],
		[L["August"]] = L["08"],
		[L["September"]] = L["09"],
		[L["October"]] = L["10"],
		[L["November"]] = L["11"],
		[L["December"]] = L["12"]
	}
	local yearValue = {}
	local n
	if GLR_GameVersion == "RETAIL" then
		n = C_DateAndTime.GetCurrentCalendarTime()
	else
		n = C_DateAndTime.GetTodaysDate()
	end
	for i = 1, 2 do --Dynamically builds the list of potential years for new events to occur on, only does the current year + one as Calendar events can only be made up to one year in advance.
		local s = string.sub(tostring(n.year), 3, 4)
		yearValue[L[tostring(n.year)]] = L[s]
		n.year = n.year + 1
	end
	local useMonth = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	local SelectedMonth = monthValue[useMonth]
	local SelectedDay = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText()
	local useYear = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:GetText()
	local SelectedYear = yearValue[useYear]
	local SelectedHour = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:GetText()
	local SelectedMinute = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:GetText()
	local SelectedDate = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear
	local DateString = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
	local NewRaffleName = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:GetText()
	local NewRaffleMaxTickets = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:GetText()
	local NewRaffleTicketPrice = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText()
	
	local currentMonth = tonumber(date("%m"))
	local currentDay = tonumber(date("%d"))
	local currentYear = tonumber(date("%y"))
	local currentHour = tonumber(date("%H"))
	local currentMinute = tonumber(date("%M"))
	
	local selectedMonthNumber = tonumber(SelectedMonth)
	local selectedDayNumber = tonumber(SelectedDay)
	local selectedYearNumber = tonumber(SelectedYear)
	local selectedHourNumber = tonumber(SelectedHour)
	local selectedMinuteNumber = tonumber(SelectedMinute)
	
	local t = {
		[1] = false,
		[2] = false,
		[3] = false,
	}
	
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() == "" then
		holdRaffleInfo.FirstPrize.ItemName = ""
		holdRaffleInfo.FirstPrize.ItemLink = ""
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() == "" then
		holdRaffleInfo.SecondPrize.ItemName = ""
		holdRaffleInfo.SecondPrize.ItemLink = ""
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() == "" then
		holdRaffleInfo.ThirdPrize.ItemName = ""
		holdRaffleInfo.ThirdPrize.ItemLink = ""
	end
	
	if holdRaffleInfo.FirstPrize.ItemLink ~= "" then
		Variables[14][1] = holdRaffleInfo.FirstPrize.ItemLink
		t[1] = true
	end
	if holdRaffleInfo.SecondPrize.ItemLink ~= "" then
		if not t[1] then
			Variables[14][1] = holdRaffleInfo.SecondPrize.ItemLink
			Variables[14][2] = false
			t[1] = true
		else
			Variables[14][2] = holdRaffleInfo.SecondPrize.ItemLink
			t[2] = true
		end
	end
	if holdRaffleInfo.ThirdPrize.ItemLink ~= "" then
		if not t[1] and not t[2] then
			Variables[14][1] = holdRaffleInfo.ThirdPrize.ItemLink
			Variables[14][2] = false
			Variables[14][3] = false
		elseif not t[2] then
			Variables[14][2] = holdRaffleInfo.ThirdPrize.ItemLink
			Variables[14][3] = false
			t[2] = true
		else
			Variables[14][3] = holdRaffleInfo.ThirdPrize.ItemLink
			t[3] = true
		end
	end
	
	local CurrencyError = 0
	local ErrorTable = {
		false,	--Gold
		false,	--Silver
		false	--Copper
	}
	local bypass = false
	
	if selectedDayNumber > currentDay or selectedMonthNumber > currentMonth then
		
		bypass = true
		
	end
	
	if not bypass and selectedDayNumber == currentDay and selectedHourNumber > currentHour then
		
		bypass = true
		
	end
	
	local TicketPriceNumber = -1
	local MaxTicketsNumber = -1
	local TotalRafflePrizes = 0
	
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() == nil or GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[1] = true
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText() == nil or GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[2] = true
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText() == nil or GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText() == "" then
		CurrencyError = CurrencyError + 1
		ErrorTable[3] = true
	end
	
	if NewRaffleMaxTickets ~= "" then
		MaxTicketsNumber = tonumber(NewRaffleMaxTickets)
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() == "" then
		NewRaffleTicketPrice = "0." .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText()
	elseif GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() ~= "" then
		NewRaffleTicketPrice = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() .. "." .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText()
	end
	if NewRaffleTicketPrice ~= "" then
		TicketPriceNumber = tonumber(NewRaffleTicketPrice)
	end
	
	if holdRaffleInfo.FirstPrize.ItemLink ~= "" then
		TotalRafflePrizes = TotalRafflePrizes + 1
	end
	if holdRaffleInfo.SecondPrize.ItemLink ~= "" then
		TotalRafflePrizes = TotalRafflePrizes + 1
	end
	if holdRaffleInfo.ThirdPrize.ItemLink ~= "" then
		TotalRafflePrizes = TotalRafflePrizes + 1
	end
	
	if TicketPriceNumber ~= nil then
		if TicketPriceNumber >= 0 then
			if MaxTicketsNumber ~= nil then
				if MaxTicketsNumber >= 1 and MaxTicketsNumber <= 50000 then
					if NewRaffleName ~= "" or NewRaffleName ~= nil then
						if TotalRafflePrizes >= 1 then
							
							if currentYear == selectedYearNumber then
								if selectedMonthNumber >= currentMonth then
									if selectedDayNumber >= currentDay or bypass then
										if selectedHourNumber >= currentHour or bypass then
											if currentMinute < selectedMinuteNumber and currentHour == selectedHourNumber or bypass then
												
												GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
												GLR_ConfirmNewRaffleFrame:Show()
												
											elseif currentMinute >= selectedMinuteNumber and currentHour ~= selectedHourNumber then
												
												GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
												GLR_ConfirmNewRaffleFrame:Show()
												
											else
												GLR_ConfirmNewRaffleFrame:Hide()
												GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Date Error"])
											end
										else
											GLR_ConfirmNewRaffleFrame:Hide()
											GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Hour Error"])
										end
									else
										GLR_ConfirmNewRaffleFrame:Hide()
										GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Day Error"])
									end
								else
									GLR_ConfirmNewRaffleFrame:Hide()
									GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Month Error"])
								end
							end
							
							if selectedYearNumber > currentYear then
								GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
								GLR_ConfirmNewRaffleFrame:Show()
							end
							
						else
							GLR_ConfirmNewRaffleFrame:Hide()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Prize Error"])
						end
					else
						GLR_ConfirmNewRaffleFrame:Hide()
						GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Lottery Name Error"])
					end
				else
					GLR_ConfirmNewRaffleFrame:Hide()
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Max Ticket Error"])
				end
			else
				GLR_ConfirmNewRaffleFrame:Hide()
				GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Max Ticket Error"])
			end
		else
			GLR_ConfirmNewRaffleFrame:Hide()
			if ErrorTable[3] == true then
				if CurrencyError > 1 then
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
				else
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Copper Entry"])
				end
			elseif ErrorTable[2] == true then
				if CurrencyError > 1 then
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
				else
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Silver Entry"])
				end
			elseif ErrorTable[1] == true then
				if CurrencyError > 1 then
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
				else
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Gold Entry"])
				end
			else
				if CurrencyError > 1 then
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Blank Entry"])
				else
					GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Must Have Higher Value"])
				end
			end
		end
	else
		GLR_ConfirmNewRaffleFrame:Hide()
		GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["Invalid Ticket Error"])
	end
	
end

---------------------------------------------
----------- SETS NEW EVENT SETTINGS ---------
---------------------------------------------
-------- BASED OFF OF ABOVE FUNCTION --------
---------------------------------------------

local function SetNewEventSettings(EventType)
	
	local CheckGuild = GLR_U:CheckGuildName()
	local monthValue = {
		[L["January"]] = L["01"],
		[L["February"]] = L["02"],
		[L["March"]] = L["03"],
		[L["April"]] = L["04"],
		[L["May"]] = L["05"],
		[L["June"]] = L["06"],
		[L["July"]] = L["07"],
		[L["August"]] = L["08"],
		[L["September"]] = L["09"],
		[L["October"]] = L["10"],
		[L["November"]] = L["11"],
		[L["December"]] = L["12"]
	}
	local yearValue = {}
	local n
	if GLR_GameVersion == "RETAIL" then
		n = C_DateAndTime.GetCurrentCalendarTime()
	else
		n = C_DateAndTime.GetTodaysDate()
	end
	for i = 1, 2 do --Dynamically builds the list of potential years for new events to occur on, only does the current year + one as Calendar events can only be made up to one year in advance.
		local s = string.sub(tostring(n.year), 3, 4)
		yearValue[L[tostring(n.year)]] = L[s]
		n.year = n.year + 1
	end
	local useMonth = ""
	local SelectedMonth = ""
	local SelectedDay = ""
	local useYear = ""
	local SelectedYear = ""
	local SelectedHour = ""
	local SelectedMinute = ""
	local SelectedDate = ""
	local DateString = ""
	local NewEventName = ""
	local NewStartingGold = ""
	local NewMaxTickets = ""
	local NewTicketPrice = ""
	local NewLotterySecondPlace = ""
	local NewLotteryGuildCut = ""
	local CheckMarkStatus = ""
	local previousJackpot = ""
	local NewRaffleFirstPlace
	local NewRaffleSecondPlace
	local NewRaffleThirdPlace
	local First = false
	local Second = false
	local TicketSeries = 0
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local state = EventType
	local CreateCalendarEvent = glrCharacter.Data.Settings.General.CreateCalendarEvents
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local timestamp = GetTimeStamp()
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	
	if state == "Lottery" then
		
		useMonth = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
		SelectedMonth = monthValue[useMonth]
		SelectedDay = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText()
		useYear = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:GetText()
		SelectedYear = yearValue[useYear]
		SelectedHour = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:GetText()
		SelectedMinute = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:GetText()
		
		SelectedDate = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear
		
		if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
			DateString = SelectedDay .. "/" .. SelectedMonth .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
		else
			DateString = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
		end
		
		NewEventName = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:GetText()
		NewStartingGold = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText()
		NewMaxTickets = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:GetText()
		NewTicketPrice = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:GetText()
		NewLotterySecondPlace = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:GetText()
		NewLotteryGuildCut = GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:GetText()
		CheckMarkStatus = GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetChecked()
		
		previousJackpot = glrCharacter.Data.Settings.PreviousLottery.Jackpot
		TicketSeries = glrCharacter.Data.Settings.General.TicketSeries
		
		if previousJackpot > 0 then
			NewStartingGold = tostring(tonumber(NewStartingGold) + previousJackpot)
		end
		
		if tonumber(NewLotteryGuildCut) == 0 then
			NewLotteryGuildCut = "0"
		end
		
		if CheckMarkStatus then
			NewLotterySecondPlace = L["Winner Guaranteed"]
		elseif not CheckMarkStatus and tonumber(NewLotterySecondPlace) == 0 then
			NewLotterySecondPlace = "0"
		end
		
		if TicketSeries >= 9000 then
			glrCharacter.Data.Settings.General.TicketSeries = 1000
		else
			if TicketSeries >= 8000 then
				glrCharacter.Data.Settings.General.TicketSeries = 9000
			elseif TicketSeries >= 7000 then
				glrCharacter.Data.Settings.General.TicketSeries = 8000
			elseif TicketSeries >= 6000 then
				glrCharacter.Data.Settings.General.TicketSeries = 7000
			elseif TicketSeries >= 5000 then
				glrCharacter.Data.Settings.General.TicketSeries = 6000
			elseif TicketSeries >= 4000 then
				glrCharacter.Data.Settings.General.TicketSeries = 5000
			elseif TicketSeries >= 3000 then
				glrCharacter.Data.Settings.General.TicketSeries = 4000
			elseif TicketSeries >= 2000 then
				glrCharacter.Data.Settings.General.TicketSeries = 3000
			elseif TicketSeries >= 1000 then
				glrCharacter.Data.Settings.General.TicketSeries = 2000
			end
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SetNewEventSettings() - Creating new LOTTERY Event. DateFormatKey: [" .. glrCharacter.Data.Settings.General.DateFormatKey .. "] - Date: [" .. DateString .. "] - Name: [" .. NewEventName .. "] - Series: [" .. TicketSeries .. "] - Maximum: [" .. NewMaxTickets .. "] - Price: [" .. NewTicketPrice .. "] - Starting Amount: [" .. NewStartingGold .. "] - Guaranteed: [" .. string.upper(tostring(CheckMarkStatus)) .. "]" )
		
	elseif state == "Raffle" then
		
		useMonth = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
		SelectedMonth = monthValue[useMonth]
		SelectedDay = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText()
		useYear = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:GetText()
		SelectedYear = yearValue[useYear]
		SelectedHour = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:GetText()
		SelectedMinute = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:GetText()
		
		SelectedDate = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear
		
		if glrCharacter.Data.Settings.General.DateFormatKey == 2 then
			DateString = SelectedDay .. "/" .. SelectedMonth .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
		else
			DateString = SelectedMonth .. "/" .. SelectedDay .. "/" .. SelectedYear .. " @ " .. SelectedHour .. ":" .. SelectedMinute
		end
		
		NewEventName = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:GetText()
		NewMaxTickets = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:GetText()
		NewTicketPrice = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:GetText() .. "." .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketSilverPriceEditBox:GetText() .. GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketCopperPriceEditBox:GetText()
		
		if holdRaffleInfo.FirstPrize.ItemLink ~= "" then
			NewRaffleFirstPlace = holdRaffleInfo.FirstPrize.ItemLink
			glrCharacter.Data.Raffle.FirstPrizeData.ItemLink = holdRaffleInfo.FirstPrize.ItemLink
			glrCharacter.Data.Raffle.FirstPrizeData.ItemName = holdRaffleInfo.FirstPrize.ItemName
			First = true
		else
			NewRaffleFirstPlace = false
		end
		if holdRaffleInfo.SecondPrize.ItemLink ~= "" then
			if not First then
				NewRaffleFirstPlace = holdRaffleInfo.SecondPrize.ItemLink
				glrCharacter.Data.Raffle.FirstPrizeData.ItemLink = holdRaffleInfo.SecondPrize.ItemLink
				glrCharacter.Data.Raffle.FirstPrizeData.ItemName = holdRaffleInfo.SecondPrize.ItemName
				NewRaffleSecondPlace = false
				First = true
			else
				NewRaffleSecondPlace = holdRaffleInfo.SecondPrize.ItemLink
				glrCharacter.Data.Raffle.SecondPrizeData.ItemLink = holdRaffleInfo.SecondPrize.ItemLink
				glrCharacter.Data.Raffle.SecondPrizeData.ItemName = holdRaffleInfo.SecondPrize.ItemName
				Second = true
			end
		else
			NewRaffleSecondPlace = false
		end
		if holdRaffleInfo.ThirdPrize.ItemLink ~= "" then
			if not First and not Second then
				NewRaffleFirstPlace = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.FirstPrizeData.ItemLink = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.FirstPrizeData.ItemName = holdRaffleInfo.ThirdPrize.ItemName
				NewRaffleThirdPlace = false
			elseif not Second then
				NewRaffleSecondPlace = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.SecondPrizeData.ItemLink = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.SecondPrizeData.ItemName = holdRaffleInfo.ThirdPrize.ItemName
				NewRaffleThirdPlace = false
			else
				NewRaffleThirdPlace = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.ThirdPrizeData.ItemLink = holdRaffleInfo.ThirdPrize.ItemLink
				glrCharacter.Data.Raffle.ThirdPrizeData.ItemName = holdRaffleInfo.ThirdPrize.ItemName
			end
		else
			NewRaffleThirdPlace = false
		end
		
		TicketSeries = glrCharacter.Data.Settings.General.RaffleSeries
		
		if TicketSeries >= 9000 then
			glrCharacter.Data.Settings.General.RaffleSeries = 1000
		else
			if TicketSeries >= 8000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 9000
			elseif TicketSeries >= 7000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 8000
			elseif TicketSeries >= 6000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 7000
			elseif TicketSeries >= 5000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 6000
			elseif TicketSeries >= 4000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 5000
			elseif TicketSeries >= 3000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 4000
			elseif TicketSeries >= 2000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 3000
			elseif TicketSeries >= 1000 then
				glrCharacter.Data.Settings.General.RaffleSeries = 2000
			end
		end
		
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - SetNewEventSettings() - Creating new RAFFLE Event. DateFormatKey: [" .. glrCharacter.Data.Settings.General.DateFormatKey .. "] - Date: [" .. DateString .. "] - Name: [" .. NewEventName .. "] - Series: [" .. TicketSeries .. "] - Maximum: [" .. NewMaxTickets .. "] - Price: [" .. NewTicketPrice .. "] - Prizes(1/2/3): [(" .. tostring(NewRaffleFirstPlace) .. ") / (" .. tostring(NewRaffleSecondPlace) .. ") / (" .. tostring(NewRaffleThirdPlace) .. ")]" )
		
	end
	
	if guildName == nil then
		guildName = "GLR - No Guild"
	end
	
	if glrCharacter.Data.Settings.General.GuildName == nil then
		glrCharacter.Data.Settings.General.GuildName = guildName
	end
	
	if glrCharacter.Event == nil then
		if state == "Lottery" then
			glrCharacter.Event[state] = { ["EventName"] = NewEventName, ["Date"] = DateString, ["StartingGold"] = NewStartingGold, ["MaxTickets"] = NewMaxTickets, ["TicketPrice"] = NewTicketPrice, ["SecondPlace"] = NewLotterySecondPlace, ["GuildCut"] = NewLotteryGuildCut, ["TicketsSold"] = 0, ["LastTicketBought"] = TicketSeries, ["FirstTicketNumber"] = TicketSeries, ["GiveAwayTickets"] = 0 }
			if glrCharacter.Data.Settings.CurrentlyActiveLottery == nil or not glrCharacter.Data.Settings.CurrentlyActiveLottery then
				glrCharacter.Data.Settings.CurrentlyActiveLottery = true
			end
		else
			glrCharacter.Event[state] = { ["EventName"] = NewEventName, ["Date"] = DateString, ["MaxTickets"] = NewMaxTickets, ["TicketPrice"] = NewTicketPrice, ["FirstPlace"] = NewRaffleFirstPlace, ["SecondPlace"] = NewRaffleSecondPlace, ["ThirdPlace"] = NewRaffleThirdPlace, ["TotalPrizes"] = TotalRafflePrizes, ["TicketsSold"] = 0, ["LastTicketBought"] = TicketSeries, ["FirstTicketNumber"] = TicketSeries, ["GiveAwayTickets"] = 0 }
			if glrCharacter.Data.Settings.CurrentlyActiveRaffle == nil or not glrCharacter.Data.Settings.CurrentlyActiveRaffle then
				glrCharacter.Data.Settings.CurrentlyActiveRaffle = true
			end
			if not glrCharacter.Event[state].SecondPlace or not glrCharacter.Event[state].ThirdPlace then
				GLR_GoToAddRafflePrizes:Enable()
			else
				GLR_GoToAddRafflePrizes:Disable()
			end
		end
	else
		if state == "Lottery" then
			glrCharacter.Event[state] = { ["EventName"] = NewEventName, ["Date"] = DateString, ["StartingGold"] = NewStartingGold, ["MaxTickets"] = NewMaxTickets, ["TicketPrice"] = NewTicketPrice, ["SecondPlace"] = NewLotterySecondPlace, ["GuildCut"] = NewLotteryGuildCut, ["TicketsSold"] = 0, ["LastTicketBought"] = TicketSeries, ["FirstTicketNumber"] = TicketSeries, ["GiveAwayTickets"] = 0 }
			if glrCharacter.Data.Settings.CurrentlyActiveLottery == nil or not glrCharacter.Data.Settings.CurrentlyActiveLottery then
				glrCharacter.Data.Settings.CurrentlyActiveLottery = true
			end
		else
			glrCharacter.Event[state] = { ["EventName"] = NewEventName, ["Date"] = DateString, ["MaxTickets"] = NewMaxTickets, ["TicketPrice"] = NewTicketPrice, ["FirstPlace"] = NewRaffleFirstPlace, ["SecondPlace"] = NewRaffleSecondPlace, ["ThirdPlace"] = NewRaffleThirdPlace, ["TotalPrizes"] = TotalRafflePrizes, ["TicketsSold"] = 0, ["LastTicketBought"] = TicketSeries, ["FirstTicketNumber"] = TicketSeries, ["GiveAwayTickets"] = 0 }
			if glrCharacter.Data.Settings.CurrentlyActiveRaffle == nil or not glrCharacter.Data.Settings.CurrentlyActiveRaffle then
				glrCharacter.Data.Settings.CurrentlyActiveRaffle = true
			end
			if not glrCharacter.Event[state].SecondPlace or not glrCharacter.Event[state].ThirdPlace then
				GLR_GoToAddRafflePrizes:Enable()
			else
				GLR_GoToAddRafflePrizes:Disable()
			end
		end
	end
	
	if glrCharacter[state] == nil then
		glrCharacter[state] = {}
	end
	
	if glrCharacter[state].Entries == nil then
		glrCharacter[state].Entries = {}
		glrCharacter[state].Entries.Names = {}
		glrCharacter[state].Entries.Tickets = {}
		glrCharacter[state].Entries.TicketNumbers = {}
		glrCharacter[state].Entries.TicketRange = {}
	else
		glrCharacter[state].Entries = {}
		glrCharacter[state].Entries.Names = {}
		glrCharacter[state].Entries.Tickets = {}
		glrCharacter[state].Entries.TicketNumbers = {}
		glrCharacter[state].Entries.TicketRange = {}
	end
	
	if state == "Lottery" then
		if glrCharacter.Data.Settings.Lottery.CarryOver and glrCharacter.Data.RollOver.Lottery.Names[1] ~= nil then
			for i = 1, #glrCharacter.Data.RollOver.Lottery.Names do
				glrCharacter[state].Entries.TicketNumbers[glrCharacter.Data.RollOver[state].Names[i]] = {}
				glrCharacter[state].Entries.TicketRange[glrCharacter.Data.RollOver[state].Names[i]] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0, }
				glrCharacter[state].Entries.Tickets[glrCharacter.Data.RollOver[state].Names[i]] = { ["Given"] = 0, ["Sold"] = 0, ["NumberOfTickets"] = 0, }
			end
			glrCharacter[state].Entries.Names = glrCharacter.Data.RollOver.Lottery.Names
		end
	end
	
	local FirstTicket = glrCharacter.Event[state].FirstTicketNumber
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderLow:SetText(FirstTicket)
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText("")
	
	if glrCharacter[state].TicketPool == nil then
		glrCharacter[state].TicketPool = {}
	else
		glrCharacter[state].TicketPool = {}
	end
	
	if glrCharacter[state].MessageStatus == nil then
		glrCharacter[state].MessageStatus = {}
	else
		glrCharacter[state].MessageStatus = {}
	end
	
	if glrTemp == nil then
		glrTemp = {}
	end
	if glrTemp[state] == nil then
		glrTemp[state] = {}
	else
		glrTemp[state] = {}
	end
	
	if glrTempStatus == nil then
		glrTempStatus = {}
	else
		glrTempStatus = {}
	end
	
	if glrHistory.ActiveEvents == nil then
		glrHistory.ActiveEvents = {}
	end
	
	if glrHistory.ActiveEvents[FullPlayerName] == nil then
		glrHistory.ActiveEvents[FullPlayerName] = true
	else
		glrHistory.ActiveEvents[FullPlayerName] = true
	end
	
	if state == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:SetChecked(false)
		if glrHistory.TransferData[FullPlayerName].Data ~= nil then
			glrHistory.TransferData[FullPlayerName].Data.Settings.PreviousLottery = nil
			glrHistory.TransferData[FullPlayerName].Data.Settings.TicketSeries = nil
		end
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetChecked(false)
		holdRaffleInfo = { ["FirstPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" }, ["SecondPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" }, ["ThirdPrize"] = { ["ItemName"] = "", ["ItemLink"] = "" } }
		if glrHistory.TransferData[FullPlayerName].Data ~= nil then
			glrHistory.TransferData[FullPlayerName].Data.Settings.AllowMultipleRaffleWinners = nil
			glrHistory.TransferData[FullPlayerName].Data.Settings.RaffleSeries = nil
		end
	end
	
	if CreateCalendarEvent then
		GLR_C:CreateAnnouncement(state)
	end
	
	if glrHistory.TransferData[FullPlayerName] ~= nil and glrHistory.TransferData[FullPlayerName].Event ~= nil and glrHistory.TransferData[FullPlayerName].Data ~= nil then
		glrHistory.TransferData[FullPlayerName][state] = nil
		glrHistory.TransferData[FullPlayerName].Event[state] = nil
		glrHistory.TransferData[FullPlayerName].Data.OtherStatus[state] = nil
	end
	
	glrHistory.TransferAvailable[state][FullPlayerName] = false
	
	local LotteryStatus = tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)
	local RaffleStatus = tostring(glrCharacter.Data.Settings.CurrentlyActiveRaffle)
	C_ChatInfo.SendAddonMessage("GLR_CHECK", "%lottery_" .. LotteryStatus .. "!%raffle_" .. RaffleStatus, "GUILD")
	
	GLR_U:UpdateInfo()
	
end

---------------------------------------------
---------------- ALERT GUILD ----------------
---------------------------------------------
--------- ALERTS THE PLAYER'S GUILD ---------
---------- ABOUT AN ACTIVE LOTTERY ----------
---------------------------------------------

local AlertCount = 1
local LotteryAlert = false
local RaffleAlert = false
local AlertGuildVariables = {
	[1] = "",		-- Lottery Name
	[2] = "",		-- Raffle Name
	[3] = "",		-- Lottery Date
	[4] = "",		-- Raffle Date
	[5] = 0,		-- Lottery Max Tickets
	[6] = 0,		-- Raffle Max Tickets
	[7] = 0,		-- Lottery Ticket Price
	[8] = 0,		-- Raffle Ticket Price
	[9] = 0,		-- Starting Gold
	[10] = 0,		-- Lottery Tickets
	[11] = 0,		-- Raffle Tickets
	[12] = 0,		-- Lottery Price
	[13] = 0,		-- Jackpot Gold
	[14] = 0,		-- Jackpot Left
	[15] = 0,		-- Guild Cut
	[16] = false,	-- Raffle First
	[17] = false,	-- Raffle Second
	[18] = false	-- Raffle Third
}

local function GetAlertMessage(number, state)
	local message = glrCharacter.Data.Messages.GuildAlerts[state][number]
	if string.find(message, "%%version") then
		message = string.gsub(message, "%%version", GLR_CurrentVersionString)
	end
	if string.find(message, "%%lottery_reply") then
		message = string.gsub(message, "%%lottery_reply", L["Detect Lottery"])
	end
	if string.find(message, "%%raffle_reply") then
		message = string.gsub(message, "%%raffle_reply", L["Detect Raffle"])
	end
	if state == "Lottery" or state == "Both" then
		local round = glrCharacter.Data.Settings.Lottery.RoundValue
		local PreviousWinner = ""
		local PreviousValue = ""
		if string.find(message, "%%lottery_winchance") then
			local WinChanceTable = { [1] = "90%", [2] = "80%", [3] = "70%", [4] = "60%", [5] = "50%", [6] = "40%", [7] = "30%", [8] = "20%", [9] = "10%", [10] = "100%" }
			if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
				message = string.gsub(message, "%%lottery_winchance", WinChanceTable[glrCharacter.Data.Settings.Lottery.WinChanceKey])
			else
				message = string.gsub(message, "%%lottery_winchance", WinChanceTable[10])
			end
		end
		if string.find(message, "%%previous_winner") or string.find(message, "%%previous_jackpot") then
			if glrCharacter.PreviousEvent.Lottery.Available then
				local doBreak = false
				local PreviousRound = glrCharacter.PreviousEvent.Lottery.Settings.RoundValue
				local WinStatus = glrCharacter.PreviousEvent.Lottery.Settings.WonType[1]
				local FinalStatus = glrCharacter.PreviousEvent.Lottery.Settings.WonType[2]
				if WinStatus == nil then WinStatus = true end
				if FinalStatus == nil then FinalStatus = false end
				local start = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.StartingGold)
				local price = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.TicketPrice)
				local sold = glrCharacter.PreviousEvent.Lottery.Settings.TicketsSold
				local cut = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.GuildCut)
				local PreviousJackpot = ( start + ( price * sold ) ) - ( ( start + ( price * sold ) ) * ( cut / 100 ) )
				if not WinStatus and FinalStatus then -- True : Someone won First Place. False : Someone either won Second Place or no one won.
					local second = tonumber(glrCharacter.PreviousEvent.Lottery.Settings.SecondPlace)
					PreviousJackpot = ( ( start + ( price * sold ) ) * ( second / 100 ) )
				end
				for i = 1, #glrCharacter.PreviousEvent.Lottery.Data.Entries.Names do
					name = glrCharacter.PreviousEvent.Lottery.Data.Entries.Names[i]
					for j = 1, #glrCharacter.PreviousEvent.Lottery.Data.Entries.TicketNumbers[name] do
						if glrCharacter.PreviousEvent.Lottery.Data.Entries.TicketNumbers[name][j] == glrCharacter.PreviousEvent.Lottery.Data.Winner then
							PreviousWinner = name
							doBreak = true
							break
						end
					end
					if doBreak then break end
				end
				if not doBreak then
					PreviousWinner = "No Winner!"
					PreviousJackpot = start + ( price * sold )
				end
				if WinStatus then
					PreviousValue = GLR_U:GetMoneyValue(PreviousJackpot, "Lottery", true, 1)
				else
					PreviousValue = GLR_U:GetMoneyValue(PreviousJackpot, "Lottery", true, PreviousRound)
				end
			else
				PreviousWinner = "No Winner!"
				PreviousValue = "0g"
			end
			if string.find(message, "%%previous_winner") then
				message = string.gsub(message, "%%previous_winner", PreviousWinner)
			end
			if string.find(message, "%%previous_jackpot") then
				message = string.gsub(message, "%%previous_jackpot", PreviousValue)
			end
		end
		if string.find(message, "%%lottery_price") then
			local price = tonumber(glrCharacter.Event.Lottery.TicketPrice)
			price = GLR_U:GetMoneyValue(price, "Lottery", false)
			message = string.gsub(message, "%%lottery_price", price)
		end
		if string.find(message, "%%lottery_max") then
			message = string.gsub(message, "%%lottery_max", glrCharacter.Event.Lottery.MaxTickets)
		end
		if string.find(message, "%%lottery_name") then
			message = string.gsub(message, "%%lottery_name", glrCharacter.Event.Lottery.EventName)
		end
		if string.find(message, "%%lottery_date") then
			local m = glrCharacter.Event.Lottery.Date
			if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
				local s = string.sub(m, 1, string.find(m, "%@") + 1)
				local t = GetTimeFormat(string.sub(m, string.find(m, "%:") - 2))
				m = s .. t
			end
			message = string.gsub(message, "%%lottery_date", m)
		end
		if string.find(message, "%%lottery_guild") then
			local gold = ( tonumber(glrCharacter.Event.Lottery.StartingGold) + tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) ) * ( tonumber(glrCharacter.Event.Lottery.GuildCut) / 100 )
			if gold ~= nil then
				gold = GLR_U:GetMoneyValue(gold, "Lottery", true, round)
				message = string.gsub(message, "%%lottery_guild", gold)
			end
		end
		if string.find(message, "%%lottery_winamount") then
			local gold = (tonumber(glrCharacter.Event.Lottery.StartingGold) + tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) ) - ( ( tonumber(glrCharacter.Event.Lottery.StartingGold) + tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) ) * ( tonumber(glrCharacter.Event.Lottery.GuildCut) / 100 ) )
			if gold ~= nil then
				gold = GLR_U:GetMoneyValue(gold, "Lottery", true, 1)
				message = string.gsub(message, "%%lottery_winamount", gold)
			end
		end
		if string.find(message, "%%lottery_total") then
			local gold = tonumber(glrCharacter.Event.Lottery.StartingGold) + ( tonumber(glrCharacter.Event.Lottery.TicketPrice) * tonumber(glrCharacter.Event.Lottery.TicketsSold) )
			if gold ~= nil then
				gold = GLR_U:GetMoneyValue(gold, "Lottery", false)
				message = string.gsub(message, "%%lottery_total", gold)
			end
		end
		if string.find(message, "%%lottery_tickets") then
			local tickets = tostring(glrCharacter.Event.Lottery.TicketsSold)
			if tickets ~= nil then
				if glrCharacter.Event.Lottery.GiveAwayTickets > 0 then
					tickets = tostring( glrCharacter.Event.Lottery.TicketsSold + glrCharacter.Event.Lottery.GiveAwayTickets )
				end
				message = string.gsub(message, "%%lottery_tickets", tickets)
			end
		end
	end
	if state == "Raffle" or state == "Both" then
		local prizes = glrCharacter.Event.Raffle.FirstPlace
		if tonumber(glrCharacter.Event.Raffle.FirstPlace) ~= nil then
			prizes = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.FirstPlace), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_total" then
			prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_half" then
			prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
		elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_quarter" then
			prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
		end
		if glrCharacter.Event.Raffle.SecondPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.SecondPlace) ~= nil then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.SecondPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_total" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_half" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_quarter" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				prizes = prizes .. ", " .. glrCharacter.Event.Raffle.SecondPlace
			end
		end
		if glrCharacter.Event.Raffle.ThirdPlace ~= false then
			if tonumber(glrCharacter.Event.Raffle.ThirdPlace) ~= nil then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.ThirdPlace), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_total" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_half" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_quarter" then
				prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			else
				prizes = prizes .. ", " .. glrCharacter.Event.Raffle.ThirdPlace
			end
		end
		if string.find(message, "%%raffle_prizes") then
			if string.len(string.gsub(message, "%%raffle_prizes", prizes)) <= 255 then
				message = string.gsub(message, "%%raffle_prizes", prizes)
			end
		end
		if string.find(message, "%%raffle_price") then
			local price = tonumber(glrCharacter.Event.Raffle.TicketPrice)
			price = GLR_U:GetMoneyValue(price, "Raffle", false)
			message = string.gsub(message, "%%raffle_price", price)
		end
		if string.find(message, "%%raffle_max") then
			message = string.gsub(message, "%%raffle_max", glrCharacter.Event.Raffle.MaxTickets)
		end
		if string.find(message, "%%raffle_name") then
			message = string.gsub(message, "%%raffle_name", glrCharacter.Event.Raffle.EventName)
		end
		if string.find(message, "%%raffle_date") then
			local m = glrCharacter.Event.Raffle.Date
			if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
				local s = string.sub(m, 1, string.find(m, "%@") + 1)
				local t = GetTimeFormat(string.sub(m, string.find(m, "%:") - 2))
				m = s .. t
			end
			message = string.gsub(message, "%%raffle_date", m)
		end
		if string.find(message, "%%raffle_total") then
			local gold = glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice)
			if gold ~= nil then
				gold = GLR_U:GetMoneyValue(gold, "Raffle", false)
				message = string.gsub(message, "%%raffle_total", gold)
			end
		end
		if string.find(message, "%%raffle_tickets") then
			local tickets = tostring(glrCharacter.Event.Raffle.TicketsSold)
			if tickets ~= nil then
				if glrCharacter.Event.Raffle.GiveAwayTickets > 0 then
					tickets = tostring( glrCharacter.Event.Raffle.TicketsSold + glrCharacter.Event.Raffle.GiveAwayTickets )
				end
				message = string.gsub(message, "%%raffle_tickets", tickets)
			end
		end
	end
	return message
end

local function SendAlertGuildMessages()
	local doBreak = false
	local round = false
	local GoldLeft = ""
	local LotteryTicketPrice = ""
	local RaffleTicketPrice = ""
	local title = L["Alert Guild GLR Title No Version"] .. GLR_CurrentVersionString
	local WinChanceKeyValue = 5
	local WinChanceTable = { [1] = "90%", [2] = "80%", [3] = "70%", [4] = "60%", [5] = "50%", [6] = "40%", [7] = "30%", [8] = "20%", [9] = "10%", [10] = "100%" }
	if glrCharacter.Data.Settings.CurrentlyActiveLottery then
		round = glrCharacter.Data.Settings.Lottery.RoundValue
		GoldLeft = AlertGuildVariables[14]
		LotteryTicketPrice = AlertGuildVariables[7]
		GoldLeft = GLR_U:GetMoneyValue(GoldLeft, "Lottery", true, 1)
		LotteryTicketPrice = GLR_U:GetMoneyValue(LotteryTicketPrice, "Lottery", false)
		if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] and glrCharacter.Data.Settings.General.AdvancedTicketDraw then
			WinChanceKeyValue = glrCharacter.Data.Settings.Lottery.WinChanceKey
		elseif glrCharacter.Event.Lottery.SecondPlace == L["Winner Guaranteed"] then
			WinChanceKeyValue = 10
		end
	end
	if glrCharacter.Data.Settings.CurrentlyActiveRaffle then
		RaffleTicketPrice = AlertGuildVariables[8]
		RaffleTicketPrice = GLR_U:GetMoneyValue(RaffleTicketPrice, "Raffle", false)
	end
	local LotteryMessages = {
		[1] = "--------------------------------------------------",
		[2] = title,
		[3] = L["Alert Guild Lottery Scheduled"] .. ": " .. AlertGuildVariables[3],
		[4] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": " .. AlertGuildVariables[1],
		[5] = L["Alert Guild Ticket Info Part 1"] .. " " .. LotteryTicketPrice .. " " .. L["Alert Guild Ticket Info Part 2"],
		[6] = L["Alert Guild Ticket Info Part 3"] .. " " .. AlertGuildVariables[5] .. " " .. L["Alert Guild Ticket Info Part 4"],
		[7] = L["Alert Guild Tickets Bought"] .. ": " .. GoldLeft .. " - " .. L["Alert Guild Win Chance"] .. ": " .. WinChanceTable[WinChanceKeyValue],
		[8] = L["Alert Guild Whisper For Lottery Info"],
		[9] = "--------------------------------------------------"
	}
	local RaffleMessages = {
		[1] = "--------------------------------------------------",
		[2] = title,
		[3] = L["Alert Guild Raffle Scheduled"] .. ": " .. AlertGuildVariables[4],
		[4] = L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": " .. AlertGuildVariables[2],
		[5] = L["Alert Guild Ticket Info Part 1"] .. " " .. RaffleTicketPrice .. " " .. L["Alert Guild Ticket Info Part 2"],
		[6] = L["Alert Guild Ticket Info Part 3"]  .. " " .. AlertGuildVariables[6] .. " " .. L["Alert Guild Ticket Info Part 4"],
		[7] = AlertGuildVariables[11] .. " " .. L["Alert Guild Raffle Tickets Bought"],
		[8] = L["Raffle Draw Step 1"] .. ": ",
		[9] = L["Alert Guild Whisper For Raffle Info"],
		[10] = "--------------------------------------------------"
	}
	local BothEventMessages = {
		[1] = "--------------------------------------------------",
		[2] = title,
		[3] = L["Alert Guild LaR Scheduled"] .. ":",
		[4] = L["Lottery"] .. ": " .. AlertGuildVariables[3] .. ". " .. L["Raffle"] .. ": " .. AlertGuildVariables[4],
		[5] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": " .. AlertGuildVariables[1] .. ", " .. L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": " .. AlertGuildVariables[2],
		[6] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " " .. LotteryTicketPrice .. " " .. L["Alert Guild Ticket Info Part 2"],
		[7] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " " .. AlertGuildVariables[5] .. " " .. L["Alert Guild Ticket Info Part 4"],
		[8] = L["Lottery"] .. ": " .. L["Alert Guild Tickets Bought"] .. " " .. GoldLeft .. " - " .. L["Lottery"] .. " " .. L["Alert Guild Win Chance"] .. ": " .. WinChanceTable[WinChanceKeyValue],
		[9] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " " .. RaffleTicketPrice .. " " .. L["Alert Guild Ticket Info Part 2"],
		[10] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " " .. AlertGuildVariables[6] .. " " .. L["Alert Guild Ticket Info Part 4"],
		[11] = L["Raffle"] .. ": " .. AlertGuildVariables[11] .. " " .. L["Alert Guild Raffle Tickets Bought"],
		[12] = L["Alert Guild Whisper For LaR Info"],
		[13] = "--------------------------------------------------"
	}
	if LotteryAlert and not RaffleAlert then
		if AlertCount <= 9 then
			if glrCharacter.Data.Messages.GuildAlerts.Lottery[8] and AlertCount >= 2 and AlertCount <= 8 then
				local number = AlertCount - 1
				local message = GetAlertMessage(number, "Lottery")
				if message ~= "" then
					SendChatMessage(message, "GUILD")
				end
			elseif glrCharacter.Data.Messages.GuildAlerts.Lottery[8] then
				if AlertCount == 1 or AlertCount == 9 then
					SendChatMessage(LotteryMessages[AlertCount], "GUILD")
				end
			elseif AlertCount <= 9 then
				SendChatMessage(LotteryMessages[AlertCount], "GUILD")
			end
		end
	elseif RaffleAlert and not LotteryAlert then
		if AlertCount <= 10 then
			if glrCharacter.Data.Messages.GuildAlerts.Raffle[9] and AlertCount >= 2 and AlertCount <= 9 then
				local number = AlertCount - 1
				local message = GetAlertMessage(number, "Raffle")
				if message ~= "" then
					SendChatMessage(message, "GUILD")
				end
			elseif glrCharacter.Data.Messages.GuildAlerts.Raffle[9] then
				if AlertCount == 1 or AlertCount == 10 then
					SendChatMessage(RaffleMessages[AlertCount], "GUILD")
				end
			elseif AlertCount <= 10 then
				if AlertCount == 8 then
					local prizes = glrCharacter.Event.Raffle.FirstPlace
					if tonumber(glrCharacter.Event.Raffle.FirstPlace) ~= nil then
						prizes = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.FirstPlace), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_total" then
						prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_half" then
						prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event.Raffle.FirstPlace == "%raffle_quarter" then
						prizes = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
					end
					if glrCharacter.Event.Raffle.SecondPlace ~= false then
						if tonumber(glrCharacter.Event.Raffle.SecondPlace) ~= nil then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.SecondPlace), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_total" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_half" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.SecondPlace == "%raffle_quarter" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						else
							prizes = prizes .. ", " .. glrCharacter.Event.Raffle.SecondPlace
						end
					end
					if glrCharacter.Event.Raffle.ThirdPlace ~= false then
						if tonumber(glrCharacter.Event.Raffle.ThirdPlace) ~= nil then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(tonumber(glrCharacter.Event.Raffle.ThirdPlace), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_total" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_half" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event.Raffle.ThirdPlace == "%raffle_quarter" then
							prizes = prizes .. ", " .. GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						else
							prizes = prizes .. ", " .. glrCharacter.Event.Raffle.ThirdPlace
						end
					end
					RaffleMessages[AlertCount] = RaffleMessages[AlertCount] .. prizes
					SendChatMessage(RaffleMessages[AlertCount], "GUILD")
				else
					SendChatMessage(RaffleMessages[AlertCount], "GUILD")
				end
			end
		end
	elseif LotteryAlert and RaffleAlert then
		if glrCharacter.Data.Messages.GuildAlerts.Both[12] and AlertCount >= 2 and AlertCount <= 12 then
			local number = AlertCount - 1
			local message = GetAlertMessage(number, "Both")
			if message ~= "" then
				SendChatMessage(message, "GUILD")
			end
		elseif glrCharacter.Data.Messages.GuildAlerts.Both[12] then
			if AlertCount == 1 or AlertCount == 13 then
				SendChatMessage(BothEventMessages[AlertCount], "GUILD")
			end
		elseif AlertCount <= 13 then
			SendChatMessage(BothEventMessages[AlertCount], "GUILD")
		end
	end
	AlertCount = AlertCount + 1
	if AlertCount == 17 then
		doBreak = true
	end
	if doBreak then
		Variables[8] = true
	end
	if AlertCount <= 16 and not doBreak then
		C_Timer.After(0.25, SendAlertGuildMessages)
	end
end

function GLR:AlertGuild()
	
	local lotteryStatus = glrCharacter.Data.Settings.CurrentlyActiveLottery
	local raffleStatus = glrCharacter.Data.Settings.CurrentlyActiveRaffle
	local canSpeakInGuildChat = C_GuildInfo.CanSpeakInGuildChat()
	
	if not canSpeakInGuildChat then
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AlertGuild() - Unable to Alert Guild about Events. Reason: [MUTED] - Lottery / Raffle State: [" .. string.upper(tostring(lotteryStatus)) .. " / " .. string.upper(tostring(raffleStatus)) .. "]")
		GLR:Print("You are currently unable to speak in Guild Chat, and therefore unable to send Guild Alerts. Please contact your Guild Master to fix this.")
		return
	end
	
	local dateTime = time()
	local lA = 0
	local tBA = glrCharacter.Data.Settings.General.TimeBetweenAlerts
	AlertCount = 1
	LotteryAlert = false
	RaffleAlert = false
	Variables[8] = false
	AlertGuildVariables = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0, [10] = 0, [11] = 0, [12] = 0, [13] = 0, [14] = 0, [15] = 0, [16] = false, [17] = false, [18] = false }
	
	if glrCharacter.Data.Settings.General.LastAlert == nil then
		glrCharacter.Data.Settings.General.LastAlert = dateTime
	end
	
	if glrCharacter.Data.Settings.General.LastAlert ~= nil then
		lA = glrCharacter.Data.Settings.General.LastAlert
	else
		lA = dateTime
	end
	
	local totalTime = lA + tBA
	local timestamp = GetTimeStamp()
	
	
	if lotteryStatus or raffleStatus then
		
		if totalTime < dateTime then
			
			if lotteryStatus then
				AlertGuildVariables[1] = glrCharacter.Event.Lottery.EventName
				if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
					AlertGuildVariables[3] = glrCharacter.Event.Lottery.Date
				else
					local s = string.sub(glrCharacter.Event.Lottery.Date, 1, string.find(glrCharacter.Event.Lottery.Date, "%@") + 1)
					--local h = tonumber(string.sub(glrCharacter.Event.Lottery.Date, string.find(glrCharacter.Event.Lottery.Date, "%:" - 2), string.find(t, "%:" - 1)))
					--local m = tonumber(string.sub(glrCharacter.Event.Lottery.Date, string.find(glrCharacter.Event.Lottery.Date, "%:" + 1)))
					local t = GetTimeFormat(string.sub(glrCharacter.Event.Lottery.Date, string.find(glrCharacter.Event.Lottery.Date, "%:") - 2))
					AlertGuildVariables[3] = s .. t
				end
				AlertGuildVariables[5] = glrCharacter.Event.Lottery.MaxTickets
				AlertGuildVariables[7] = tonumber(glrCharacter.Event.Lottery.TicketPrice)
				AlertGuildVariables[9] = tonumber(glrCharacter.Event.Lottery.StartingGold)
				AlertGuildVariables[10] = glrCharacter.Event.Lottery.TicketsSold
				AlertGuildVariables[12] = tonumber(glrCharacter.Event.Lottery.TicketPrice)
				AlertGuildVariables[13] = AlertGuildVariables[9] + ( AlertGuildVariables[10] * AlertGuildVariables[12] )
				local parse = tonumber(glrCharacter.Event.Lottery.GuildCut) / 100 * AlertGuildVariables[13]
				AlertGuildVariables[15] = GLR_U:GetMoneyValue(parse, "Lottery", true, glrCharacter.Data.Settings.Lottery.RoundValue, "NA", false, false)
				AlertGuildVariables[14] = AlertGuildVariables[13] - AlertGuildVariables[15]
				LotteryAlert = true
			end
			if raffleStatus then
				AlertGuildVariables[2] = glrCharacter.Event.Raffle.EventName
				if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
					AlertGuildVariables[4] = glrCharacter.Event.Raffle.Date
				else
					local s = string.sub(glrCharacter.Event.Raffle.Date, 1, string.find(glrCharacter.Event.Raffle.Date, "%@") + 1)
					--local h = tonumber(string.sub(glrCharacter.Event.Raffle.Date, string.find(glrCharacter.Event.Raffle.Date, "%:" - 2), string.find(t, "%:" - 1)))
					--local m = tonumber(string.sub(glrCharacter.Event.Raffle.Date, string.find(glrCharacter.Event.Raffle.Date, "%:" + 1)))
					local t = GetTimeFormat(string.sub(glrCharacter.Event.Raffle.Date, string.find(glrCharacter.Event.Raffle.Date, "%:") - 2))
					AlertGuildVariables[4] = s .. t
				end
				AlertGuildVariables[6] = glrCharacter.Event.Raffle.MaxTickets
				AlertGuildVariables[8] = tonumber(glrCharacter.Event.Raffle.TicketPrice)
				AlertGuildVariables[11] = glrCharacter.Event.Raffle.TicketsSold
				
				if tonumber(glrCharacter.Data.Raffle.FirstPrizeData.ItemName) ~= nil then
					AlertGuildVariables[16] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Data.Raffle.FirstPrizeData.ItemName), "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Data.Raffle.FirstPrizeData.ItemName == "%raffle_total" then
					AlertGuildVariables[16] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Data.Raffle.FirstPrizeData.ItemName == "%raffle_half" then
					AlertGuildVariables[16] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Data.Raffle.FirstPrizeData.ItemName == "%raffle_quarter" then
					AlertGuildVariables[16] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
				else
					AlertGuildVariables[16] = glrCharacter.Data.Raffle.FirstPrizeData.ItemName
				end
				
				if glrCharacter.Event.Raffle.SecondPlace ~= false then
					if tonumber(glrCharacter.Data.Raffle.SecondPrizeData.ItemName) ~= nil then
						AlertGuildVariables[17] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Data.Raffle.SecondPrizeData.ItemName), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.SecondPrizeData.ItemName == "%raffle_total" then
						AlertGuildVariables[17] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.SecondPrizeData.ItemName == "%raffle_half" then
						AlertGuildVariables[17] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.SecondPrizeData.ItemName == "%raffle_quarter" then
						AlertGuildVariables[17] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
					else
						AlertGuildVariables[17] = glrCharacter.Data.Raffle.SecondPrizeData.ItemName
					end
				end
				if glrCharacter.Event.Raffle.ThirdPlace ~= false then
					if tonumber(glrCharacter.Data.Raffle.ThirdPrizeData.ItemName) ~= nil then
						AlertGuildVariables[18] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Data.Raffle.ThirdPrizeData.ItemName), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.ThirdPrizeData.ItemName == "%raffle_total" then
						AlertGuildVariables[18] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.ThirdPrizeData.ItemName == "%raffle_half" then
						AlertGuildVariables[18] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Data.Raffle.ThirdPrizeData.ItemName == "%raffle_quarter" then
						AlertGuildVariables[18] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
					else
						AlertGuildVariables[18] = glrCharacter.Data.Raffle.ThirdPrizeData.ItemName
					end
				end
				RaffleAlert = true
			end
			
			glrCharacter.Data.Settings.General.LastAlert = dateTime
			
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AlertGuild() - Starting Guild Alert. Lottery / Raffle State: [" .. string.upper(tostring(lotteryStatus)) .. " / " .. string.upper(tostring(raffleStatus)) .. "]" )
			
			if lotteryStatus and not raffleStatus then
				
				C_Timer.After(0.25, SendAlertGuildMessages)
				
			elseif raffleStatus and not lotteryStatus then
				
				C_Timer.After(0.25, SendAlertGuildMessages)
				
			elseif lotteryStatus and raffleStatus then
				
				C_Timer.After(0.25, SendAlertGuildMessages)
				
			end
			
		else
			
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AlertGuild() - Unable to Start Guild Alert. Time Between Alerts Error." )
			GLR:Print("|cfff7ff4d" .. L["Alert Guild Time Between Alerts Part 1"] .. tBA .. L["Alert Guild Time Between Alerts Part 2"] .. "|r")
			
		end
		
	else
		
		if not lotteryStatus or not raffleStatus then
			
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AlertGuild() - Unable to Start Guild Alert. No Event Active." )
			
			if not lotteryStatus and raffleStatus then
				GLR:Print("|cfff7ff4d" .. L["Alert Guild No Lottery Active"] .. "|r")
			elseif not raffleStatus and lotteryStatus then
				GLR:Print("|cfff7ff4d" .. L["Alert Guild No Raffle Active"] .. "|r")
			elseif not lotteryStatus and not raffleStatus then
				GLR:Print("|cfff7ff4d" .. L["Alert Guild No LoR Active"] .. "|r")
			end
			
		end
		
	end
	
end

---------------------------------------------
------------ ADD PLAYER TO EVENT ------------
---------------------------------------------
--------- ADDS A PLAYER TO THE EVENT --------
---------------------------------------------

local function AddPlayerTickets(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
	
	local dateTime = time()
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	local FirstTicketNumberBought = true
	local LastTicketNumberBought = true
	
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
	
	GLR_U:UpdateInfo()
	
	if glrCharacter[state].MessageStatus == nil then
		glrCharacter[state].MessageStatus = {}
	end
	if glrCharacter[state].MessageStatus[PlayerName] == nil then
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
	
	if continue then
		
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AddPlayerTickets() - Sending Ticket Info Message To New Player: [" .. PlayerName .. "] - Event: [" .. string.upper(state) .. "]")
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		
	else
		--Due to Blizzard blocking the /who function without player involvement, messages will only be sent to players of the same guild.
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
		--[[
		local online = target.Online
		if online then
			GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
			if glrCharacter.Data.Settings.General.ToggleChatInfo then
				GLR:Print("|cfff7ff4d" .. vN .. " - " .. L["Send Info Player Online"] .. "|r")
			end
		else
			if glrCharacter.Data.Settings.General.ToggleChatInfo then
				GLR:Print("|cfff7ff4d" .. vN .. " " .. L["Send Info Player Not Online"] .. "|r")
			end
		end
		]]
		
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
				-- local timestamp = GetTimeStamp()
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AddPlayerTickets() - WhoLib Search Started For: [" .. PlayerName .. "]")
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
		
	end
	
end

local function AddPlayerTicketsAdvanced(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
	
	local dateTime = time()
	local TicketNumber = glrCharacter.Event[state].LastTicketBought
	
	glrCharacter[state].Entries.TicketNumbers[PlayerName] = {}
	
	for i = 1, PlayerTickets do
		
		if state == "Lottery" then
			if guaranteedWinner then
				TicketNumber = TicketNumber + 1
			else
				TicketNumber = TicketNumber + 2
			end
		else
			TicketNumber = TicketNumber + 1
		end
		
	end
	
	glrCharacter.Event[state].LastTicketBought = TicketNumber
	
	GLR_UI.GLR_MainFrame.GLR_TicketNumberRangeBorderHigh:SetText(TicketNumber)
	
	if state == "Lottery" then
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToLotteryFrame:Hide()
	else
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:SetChecked(false)
		GLR_UI.GLR_AddPlayerToRaffleFrame:Hide()
	end
	
	GLR_U:UpdateInfo()
	
	if glrCharacter[state].MessageStatus == nil then
		glrCharacter[state].MessageStatus = {}
	end
	
	if glrCharacter[state].MessageStatus[PlayerName] == nil then
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
	
	if continue then
		
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AddPlayerTicketsAdvanced() - Sending Ticket Info Message To New Player: [" .. PlayerName .. "] - Event: [" .. string.upper(state) .. "]")
		GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
		
	else
		
		if glrCharacter.Data.Settings.General.ToggleChatInfo then
			GLR:Print("|cfff7ff4d" .. PlayerName .. " " .. L["Send Info Player Not Online"] .. "|r")
		end
		
		-- local printed = false
		--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
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
				-- local timestamp = GetTimeStamp()
				-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AddPlayerTicketsAdvanced() - WhoLib Search Started For: [" .. PlayerName .. "]")
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
		
	end
	
end

local function AddPlayerToEvent(state, isFrame, n, t, f)
	
	if isFrame == nil then isFrame = true end
	
	local faction, _ = UnitFactionGroup("PLAYER")
	local PlayerNames = GenerateRosterNames()
	local PlayerName = ""
	local PlayerTickets = 0
	local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
	local guaranteedWinner = false
	local FreeTickets = false
	local continue = false
	local numTotalMembers, _, _ = GetNumGuildMembers()
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	
	if state == "Lottery" then
		if isFrame then
			PlayerName = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:GetText()
			PlayerTickets = tonumber(GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:GetText())
			FreeTickets = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddFreeLotteryTicketsCheckButton:GetChecked()
		end
		if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
			guaranteedWinner = true
		end
	else
		if isFrame then
			PlayerName = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:GetText()
			PlayerTickets = tonumber(GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:GetText())
			FreeTickets = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddFreeRaffleTicketsCheckButton:GetChecked()
		end
		guaranteedWinner = true
	end
	
	if not isFrame then
		PlayerName = n
		PlayerTickets = t
		FreeTickets = f
	end
	
	for i = 1, numTotalMembers do
		local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
		if PlayerName == name then
			if isOnline then
				continue = true
			end
			break
		end
	end
	
	if glrTemp == nil then
		glrTemp = {}
	end
	if glrTemp[state] == nil then
		glrTemp[state] = {}
	end
	if glrTemp[state][PlayerName] == nil then
		glrTemp[state][PlayerName] = {}
	end
	if glrTemp[state][PlayerName].TicketNumbers == nil then
		glrTemp[state][PlayerName].TicketNumbers = {}
	end
	if glrTemp[state][PlayerName]["NumberOfTickets"] == nil then
		glrTemp[state][PlayerName]["NumberOfTickets"] = {}
	end
	if glrCharacter[state] == nil then
		glrCharacter[state] = {}
	end
	if glrCharacter[state].Entries.TicketRange == nil then
		glrCharacter[state].Entries.TicketRange = {}
	end
	if glrCharacter[state].Entries.TicketRange[PlayerName] == nil then
		glrCharacter[state].Entries.TicketRange[PlayerName] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
	end
	if glrTemp[state][PlayerName].TicketRange == nil then
		glrTemp[state][PlayerName].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
	end
	
	if PlayerTickets == nil or PlayerName == "" then
		
		if state == "Lottery" then
			if PlayerTickets == nil then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["Add Player Must Have Tickets"])
			elseif PlayerName == "" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["Add Player No Name Given"])
			end
		else
			if PlayerTickets == nil then
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["Add Player Must Have Tickets"])
			elseif PlayerName == "" then
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["Add Player No Name Given"])
			end
		end
		
	elseif PlayerTickets <= MaxTicket and PlayerTickets > 0 then
		
		if glrCharacter[state].Entries.Tickets[PlayerName] == nil or not isFrame then
			
			glrCharacter[state].Entries.Tickets[PlayerName] = {}
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = 0
			glrCharacter[state].Entries.Tickets[PlayerName].NumberOfTickets = PlayerTickets
			
			if FreeTickets then
				glrCharacter[state].Entries.Tickets[PlayerName].Given = PlayerTickets
				glrCharacter[state].Entries.Tickets[PlayerName].Sold = 0
				glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + PlayerTickets
			else
				glrCharacter[state].Entries.Tickets[PlayerName].Given = 0
				glrCharacter[state].Entries.Tickets[PlayerName].Sold = PlayerTickets
				glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + PlayerTickets
			end
			
			glrTemp[state][PlayerName].NumberOfTickets = PlayerTickets
			
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText("")
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText("")
			end
			
			if isFrame then
				table.insert(glrCharacter[state].Entries.Names, PlayerName)
			end
			
			if glrCharacter[state].Entries.TicketNumbers[PlayerName] == nil or not isFrame then
				
				local timestamp = GetTimeStamp()
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - AddPlayerToEvent() - NEW Player Entry. Event: [" .. string.upper(state) .. "] - Advanced: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.AdvancedTicketDraw)) .. "] - Name: [" .. PlayerName .. "] - Tickets: [" .. PlayerTickets .. "] - Guaranteed: [" .. string.upper(tostring(guaranteedWinner)) .. "]" )
				
				if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
					AddPlayerTickets(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
				else
					AddPlayerTicketsAdvanced(PlayerName, PlayerTickets, FreeTickets, guaranteedWinner, state, continue)
				end
				
			end
			
		else
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["Add Player They Already Exist"])
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["Add Player They Already Exist"])
			end
		end
		
	else
		
		if PlayerTickets > MaxTicket then
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["Add Player Max Tickets Exceeded"])
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["Add Player Max Tickets Exceeded"])
			end
		else
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["Add Player Cant Have 0 Tickets"])
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["Add Player Cant Have 0 Tickets"])
			end
		end
		
	end
	
end

---------------------------------------------
-------- CHANGE EXISTING PLAYER INFO --------
---------------------------------------------
------------- IF PLAYER EXISTS --------------
------------ CHANGES THEIR INFO -------------
---------------------------------------------

local function ChangePlayerInEventInfo(state)
	
	local currentName
	local nameChange
	local ticketString
	local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
	local faction, _ = UnitFactionGroup("PLAYER")
	local PlayerNames = GenerateRosterNames()
	local oldTickets = glrCharacter[state].Entries.Tickets
	local oldTicketNumbers = glrCharacter[state].Entries.TicketNumbers
	local oldTicketRange = glrCharacter[state].Entries.TicketRange
	local glrTempStatus = glrCharacter[state].MessageStatus
	local guaranteedWinner = false
	local continue = false
	local FreeTickets = false
	local FirstTicketNumberBought = true
	local LastTicketNumberBought = true
	local bypassRemoveEntry = false
	local numTotalMembers, _, _ = GetNumGuildMembers()
	
	if not GLR_Global_Variables[2] then GLR_Global_Variables[2] = true end
	
	if state == "Lottery" then
		currentName = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText()
		nameChange = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
		ticketString = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:GetText()
		FreeTickets = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:GetChecked()
		if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
			guaranteedWinner = true
		end
	else
		currentName = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText()
		nameChange = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
		ticketString = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:GetText()
		FreeTickets = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:GetChecked()
		guaranteedWinner = true
	end
	
	if currentName == nil or currentName == "" or nameChange == nil or nameChange == "" then return end
	
	local currentTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets
	local currentSold = glrCharacter[state].Entries.Tickets[currentName].Sold
	local currentGiven = glrCharacter[state].Entries.Tickets[currentName].Given
	local ticketChange = tonumber(ticketString)
	
	if ticketChange == 0 and currentTickets == 0 and currentName == nameChange then
		bypassRemoveEntry = true
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ChangePlayerInEventInfo() - EDIT Player Entry. Event: [" .. string.upper(state) .. "] - Advanced: [" .. string.upper(tostring(glrCharacter.Data.Settings.General.AdvancedTicketDraw)) .. "] - Name: [" .. currentName .. " / " .. nameChange .. "] - Tickets: [" .. currentTickets .. " / " .. ticketChange .. "] - Guaranteed: [" .. string.upper(tostring(guaranteedWinner)) .. "]" )
	
	if currentGiven == nil then currentGiven = 0 end
	if currentSold == nil then currentSold = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets end
	
	if glrCharacter[state].Entries.Tickets[currentName].Given == nil then glrCharacter[state].Entries.Tickets[currentName].Given = 0 end
	if glrCharacter[state].Entries.Tickets[currentName].Sold == nil then glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets end
	
	for i = 1, numTotalMembers do
		local name, _, _, _, _, _, _, _, isOnline, _, _, _, _, _, _, _ = GetGuildRosterInfo(i)
		if currentName == nameChange and currentName == name then
			if isOnline then
				continue = true
			end
			break
		elseif currentName ~= nameChange and nameChange == name then
			if isOnline then
				continue = true
			end
			break
		end
	end
	
	if currentName ~= L["GLR - Error - No Entries Found"] then
		
		if ticketChange ~= nil then
			
			if glrCharacter[state].Entries.Tickets[nameChange] ~= nil and ticketChange > MaxTicket then
				
				if state == "Lottery" then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["Edit Player Name Exists & Max Tickets Exceeded"])
				else
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["Edit Player Name Exists & Max Tickets Exceeded"])
				end
				
			elseif ticketChange <= MaxTicket then
				
				if currentName ~= nameChange then
					
					if glrCharacter[state].Entries.Tickets[nameChange] ~= nil then
						
						if state == "Lottery" then
							GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["Edit Player Name Exists"])
						else
							GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["Edit Player Name Exists"])
						end
						
					else
						
						if ticketChange ~= currentTickets then
							
							if glrTemp == nil then
								glrTemp = {}
							end
							if glrTemp[state] == nil then
								glrTemp[state] = {}
							end
							if glrTemp[state][nameChange] == nil then
								glrTemp[state][nameChange] = {}
							end
							if glrTemp[state][nameChange].NumberOfTickets == nil then
								glrTemp[state][nameChange].NumberOfTickets = 0
							end
							if glrTemp[state][nameChange].TicketNumbers == nil then
								glrTemp[state][nameChange].TicketNumbers = {}
							end
							if glrTemp[state][nameChange].TicketRange == nil then
								glrTemp[state][nameChange].TicketRange = {}
								glrTemp[state][nameChange].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
							end
							if glrCharacter[state].Entries.TicketNumbers[nameChange] ~= nil then
								if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
									glrTemp[state][nameChange].NumberOfTickets = glrCharacter[state].Entries.Tickets[nameChange].NumberOfTickets
									glrTemp[state][nameChange].TicketNumbers = glrCharacter[state].Entries.TicketNumbers[nameChange]
								else
									glrTemp[state][nameChange].TicketNumbers = {}
								end
							elseif glrCharacter[state].Entries.TicketNumbers[currentName] ~= nil then
								if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
									glrTemp[state][nameChange].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets
									glrTemp[state][nameChange].TicketNumbers = glrCharacter[state].Entries.TicketNumbers[currentName]
								else
									glrTemp[state][nameChange].TicketNumbers = {}
								end
							end
							if glrCharacter[state].Entries.TicketRange[nameChange] ~= nil then
								glrTemp[state][nameChange].TicketRange.LowestTicketNumber = glrCharacter[state].Entries.TicketRange[nameChange].LowestTicketNumber
								glrTemp[state][nameChange].TicketRange.HighestTicketNumber = glrCharacter[state].Entries.TicketRange[nameChange].HighestTicketNumber
							end
							if glrCharacter[state].Entries.TicketRange[currentName] ~= nil then
								glrTemp[state][nameChange].TicketRange.LowestTicketNumber = glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber
								glrTemp[state][nameChange].TicketRange.HighestTicketNumber = glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber
							end
							
							if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
								
								if ticketChange < currentTickets then
									
									local ticketDifference = currentTickets - ticketChange
									local TicketNumber = glrCharacter.Event[state].LastTicketBought
									local holdTickets = {}
									
									for i = 1, #glrTemp[state][nameChange].TicketNumbers do
										local v = glrTemp[state][nameChange].TicketNumbers[i]
										table.insert(holdTickets, v)
									end
									
									for i = 1, ticketDifference do
										i = currentTickets
										TicketNumber = TicketNumber - 1
										local TicketString = tostring(TicketNumber)
										table.insert(glrCharacter[state].TicketPool, holdTickets[i])
										if ticketDifference == i and LastTicketNumberBought and ticketChange > 0 then
											glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = tonumber(holdTickets[i])
											glrTemp[state][nameChange].TicketRange.HighestTicketNumber = tonumber(holdTickets[i])
											LastTicketNumberBought = false
										end
										if ticketChange == 0 then
											glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber = 0
											glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = 0
											glrTemp[state][nameChange].TicketRange.LowestTicketNumber = 0
											glrTemp[state][nameChange].TicketRange.HighestTicketNumber = 0
											LastTicketNumberBought = false
											FirstTicketNumberBought = false
										end
										table.remove(glrCharacter[state].Entries.TicketNumbers[currentName], i)
										table.remove(glrTemp[state][nameChange], i)
										currentTickets = currentTickets - 1
									end
									
									holdTickets = nil
									
									sort(glrCharacter[state].TicketPool)
									sort(glrCharacter[state].Entries.TicketNumbers[currentName])
									
									local change = ticketDifference
									
									if currentGiven > 0 then
										for i = 1, ticketDifference do
											glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given - 1
											glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - 1
											change = change - 1
											if glrCharacter.Event[state].GiveAwayTickets == 0 then break end
											if glrCharacter[state].Entries.Tickets[currentName].Given == 0 then break end
										end
									end
									
									if currentSold > 0 then
										if change > 0 then
											for i = 1, change do
												glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold - 1
												glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
												if glrCharacter.Event[state].TicketsSold == 0 then break end
												if glrCharacter[state].Entries.Tickets[currentName].Sold == 0 then break end
											end
										end
									end
									
									glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = ticketChange
									glrTemp[state][nameChange].NumberOfTickets = ticketChange
									
								elseif ticketChange > currentTickets then
									
									local ticketIncrease = ticketChange - currentTickets
									local TicketNumber = glrCharacter.Event[state].LastTicketBought
									local holdTickets = {}
									
									for i = 1, #glrTemp[state][nameChange].TicketNumbers do
										
										local v = glrTemp[state][nameChange].TicketNumbers[i]
										table.insert(holdTickets, v)
										
									end
									
									glrCharacter[state].Entries.TicketNumbers[currentName] = nil
									glrCharacter[state].Entries.TicketNumbers[currentName] = {}
									
									for i = 1, ticketIncrease do
										
										if glrCharacter[state].TicketPool[1] ~= nil then
											
											table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], glrCharacter[state].TicketPool[1])
											table.insert(glrTemp[state][nameChange], glrCharacter[state].TicketPool[1])
											if ticketIncrease == i and LastTicketNumberBought then
												glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
												glrTemp[state][nameChange].TicketRange.HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
												LastTicketNumberBought = false
											end
											table.remove(glrCharacter[state].TicketPool, 1)
											
										else
											
											local ts = tostring(TicketNumber)
											table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], ts)
											table.insert(glrTemp[state][nameChange], ts)
											if ticketIncrease == i and LastTicketNumberBought then
												glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = TicketNumber
												glrTemp[state][nameChange].TicketRange.HighestTicketNumber = TicketNumber
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
									
									holdTickets = nil
									
									sort(glrCharacter[state].Entries.TicketNumbers[currentName])
									
									if FreeTickets then
										glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given + ticketIncrease
										glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
									else
										glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold + ticketIncrease
										glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
									end
									
									glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = ticketChange
									glrTemp[state][nameChange].NumberOfTickets = ticketChange
									
								end
								
							else
								
								if ticketChange < currentTickets then
									
									local ticketDifference = currentTickets - ticketChange
									glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ticketDifference
									
									local change = ticketDifference
									
									glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets - ticketDifference
									
									if currentGiven > 0 then
										for i = 1, ticketDifference do
											glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given - 1
											glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - 1
											change = change - 1
											if glrCharacter.Event[state].GiveAwayTickets == 0 then break end
											if glrCharacter[state].Entries.Tickets[currentName].Given == 0 then break end
										end
									end
									
									if currentSold > 0 then
										if change > 0 then
											for i = 1, change do
												glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold - 1
												glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
												if glrCharacter.Event[state].TicketsSold == 0 then break end
												if glrCharacter[state].Entries.Tickets[currentName].Sold == 0 then break end
											end
										end
									end
									
									if glrCharacter[state].MessageStatus[currentName] ~= nil then
										glrCharacter[state].MessageStatus[currentName].sentMessage = false
									else
										glrCharacter[state].MessageStatus[currentName] = { ["sentMessage"] = false, }
									end
									
								elseif ticketChange > currentTickets then
									
									local ticketIncrease = ticketChange - currentTickets
									glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ticketIncrease
									
									if not FreeTickets then
										glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
										glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold + ticketIncrease
									else
										glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
										glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given + ticketIncrease
									end
									
									glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets + ticketIncrease
									
									if ticketChange > 0 then
										if not FreeTickets then
											if glrCharacter[state].MessageStatus[currentName] ~= nil then
												glrCharacter[state].MessageStatus[currentName].sentMessage = false
											else
												glrCharacter[state].MessageStatus[currentName] = { ["sentMessage"] = false, }
											end
										end
									end
									
								end
								
							end
							
						end
						
						local replaceTickets = glrCharacter[state].Entries.Tickets[currentName]
						local replaceTicketNumbers = glrCharacter[state].Entries.TicketNumbers[currentName]
						local replaceTicketRange = glrCharacter[state].Entries.TicketRange[currentName]
						
						glrCharacter[state].Entries.Tickets[nameChange] = {}
						glrCharacter[state].Entries.Tickets[nameChange] = replaceTickets
						
						glrCharacter[state].Entries.TicketNumbers[nameChange] = {}
						glrCharacter[state].Entries.TicketNumbers[nameChange] = replaceTicketNumbers
						
						glrCharacter[state].Entries.TicketRange[nameChange] = {}
						glrCharacter[state].Entries.TicketRange[nameChange] = replaceTicketRange
						
						if ticketChange > 0 then
							if not FreeTickets then
								glrCharacter[state].MessageStatus[nameChange] = { ["sentMessage"] = false, ["lastAlert"] = glrCharacter[state].MessageStatus[currentName].lastAlert }
							else
								glrCharacter[state].MessageStatus[nameChange] = { ["sentMessage"] = glrCharacter[state].MessageStatus[currentName].sentMessage, ["lastAlert"] = glrCharacter[state].MessageStatus[currentName].lastAlert }
							end
						end
						
						for t, v in pairs(oldTicketRange) do
							if t ~= currentName and oldTickets[t].NumberOfTickets > 0 then
								glrCharacter[state].Entries.TicketRange[t] = {}
								glrCharacter[state].Entries.TicketRange[t] = v
							elseif t == currentName or oldTickets[t].NumberOfTickets == 0 then
								glrCharacter[state].Entries.TicketRange[t] = nil
							end
						end
						
						for t, v in pairs(oldTicketNumbers) do
							if t ~= currentName and oldTickets[t].NumberOfTickets > 0 then
								glrCharacter[state].Entries.TicketNumbers[t] = {}
								if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
									glrCharacter[state].Entries.TicketNumbers[t] = v
								end
							elseif t == currentName or oldTickets[t].NumberOfTickets == 0 then
								glrCharacter[state].Entries.TicketNumbers[t] = nil
							end
						end
						
						for t, v in pairs(oldTickets) do
							if t ~= currentName and oldTickets[t].NumberOfTickets > 0 then
								glrCharacter[state].Entries.Tickets[t] = {}
								glrCharacter[state].Entries.Tickets[t] = v
							elseif t == currentName or oldTickets[t].NumberOfTickets == 0 then
								oldTickets[t] = nil
							end
						end
						
						for i = 1, #glrCharacter[state].Entries.Names do
							local name = glrCharacter[state].Entries.Names[i]
							if name == currentName then
								table.remove(glrCharacter[state].Entries.Names, i)
								table.insert(glrCharacter[state].Entries.Names, nameChange)
							end
						end
						
						for t, v in pairs(glrTempStatus) do
							local value = glrTempStatus[t]["sentMessage"]
							local tValue = glrTempStatus[t]["lastAlert"]
							if t ~= currentName then
								glrCharacter[state].MessageStatus[t] = { ["sentMessage"] = value, ["lastAlert"] = tValue }
							elseif t == currentName then
								glrCharacter[state].MessageStatus[t] = nil
							end
						end
						
					end
					
					GLR_U:UpdateInfo()
					
					if state == "Lottery" then
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetChecked(false)
						GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
					else
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetChecked(false)
						GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
					end
					
					if glrCharacter[state].MessageStatus.nameChange ~= nil then
						
						local state = "Lottery"
						local targetRealm
						local bypass = false
						local vN = nameChange
						
						if string.find(string.lower(nameChange), "-") ~= nil then
							targetRealm = string.sub(nameChange, string.find(nameChange, "-") + 1)
						else
							bypass = true
						end
						
						if PlayerRealmName == targetRealm and not bypass then
							vN = string.sub(nameChange, 1, string.find(nameChange, "-") - 1)
						end
						
						if continue then
							
							local timestamp = GetTimeStamp()
							table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ChangePlayerInEventInfo() - Sending Updated Ticket Info Message To New Player: [" .. nameChange .. "] - Event: [" .. string.upper(state) .. "]")
							GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
							
						--elseif not continue and status then
							
							--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
							-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
								-- for i = 1, #glrHistory.GuildRoster[faction][key] do
									-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
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
								-- if not glrCharacter[state].MessageStatus[nameChange]["sentMessage"] then
									-- local timestamp = GetTimeStamp()
									-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ChangePlayerInEventInfo() - WhoLib Search Started For: [" .. nameChange .. "]")
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
								GLR:Print("|cfff7ff4d" .. nameChange .. " " .. L["Send Info Player Not Online"] .. "|r")
							end
							
						end
						
					end
					
				end
				
				if nameChange == currentName then
					
					if ticketChange ~= currentTickets or bypassRemoveEntry then
						
						if not bypassRemoveEntry then
							
							if glrTemp == nil then
								glrTemp = {}
							end
							if glrTemp[state] == nil then
								glrTemp[state] = {}
							end
							if glrTemp[state][currentName] == nil then
								glrTemp[state][currentName] = {}
							end
							if glrTemp[state][currentName].TicketNumbers == nil then
								glrTemp[state][currentName].TicketNumbers = {}
							end
							if glrTemp[state][currentName].NumberOfTickets == nil then
								glrTemp[state][currentName].NumberOfTickets = 0
							end
							if glrTemp[state][currentName]["TicketRange"] == nil then
								glrTemp[state][currentName]["TicketRange"] = {}
								glrTemp[state][currentName]["TicketRange"] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
							else
								glrTemp[state][currentName]["TicketRange"] = {}
								glrTemp[state][currentName]["TicketRange"] = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
							end
							if glrCharacter[state].Entries.TicketNumbers[currentName] ~= nil then
								glrTemp[state][currentName] = glrCharacter[state].Entries.TicketNumbers[currentName]
								if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
									glrTemp[state][currentName].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets
									glrTemp[state][currentName].TicketNumbers = glrCharacter[state].Entries.TicketNumbers[currentName]
								end
							end
							
						end
						
						if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
							
							if ticketChange < currentTickets or bypassRemoveEntry then
								
								local ticketDifference = currentTickets - ticketChange
								local holdTickets = {}
								
								if not bypassRemoveEntry then
									
									for i = 1, #glrTemp[state][currentName].TicketNumbers do
										local v = glrTemp[state][currentName].TicketNumbers[i]
										table.insert(holdTickets, v)
									end
									
								end
								
								if ticketChange == 0 then
									
									if glrCharacter.Data.RollOver.Lottery.Check ~= nil then
										if glrCharacter.Data.RollOver.Lottery.Check[currentName] ~= nil then
											glrCharacter.Data.RollOver.Lottery.Check[currentName] = nil
											for i = 1, #glrCharacter.Data.RollOver.Lottery.Names do
												if currentName == glrCharacter.Data.RollOver.Lottery.Names[i] then
													table.remove(glrCharacter.Data.RollOver.Lottery.Names, i)
													break
												end
											end
										end
									end
									
									if glrCharacter[state].Entries.Tickets[currentName].Given ~= nil then
										if glrCharacter[state].Entries.Tickets[currentName].Given > 0 then
											local RemoveAmount = glrCharacter[state].Entries.Tickets[currentName].Given
											glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - RemoveAmount
										end
									end
									if glrCharacter[state].Entries.Tickets[currentName].Sold ~= nil then
										if glrCharacter[state].Entries.Tickets[currentName].Sold > 0 then
											local RemoveAmount = glrCharacter[state].Entries.Tickets[currentName].Sold
											glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - RemoveAmount
										end
									end
									
									glrCharacter[state].Entries.TicketNumbers[currentName] = nil
									glrCharacter[state].Entries.Tickets[currentName] = nil
									glrCharacter[state].Entries.TicketRange[currentName] = nil
									
									for i = 1, #glrCharacter[state].Entries.Names do
										local name = glrCharacter[state].Entries.Names[i]
										if name == currentName then
											table.remove(glrCharacter[state].Entries.Names, i)
										end
									end
									
									for t, v in pairs(glrTempStatus) do
										if t == currentName then
											glrCharacter[state].MessageStatus[t] = nil
										end
									end
									
								else
									
									glrCharacter[state].Entries.TicketNumbers[currentName] = nil
									glrCharacter[state].Entries.TicketNumbers[currentName] = {}
									
									for i = 1, ticketChange do
										table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], holdTickets[1])
										if ticketChange == i and LastTicketNumberBought then
											glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = tonumber(holdTickets[1])
											LastTicketNumberBought = false
										end
										table.remove(holdTickets, 1)
									end
									
									local change = ticketDifference
									
									if currentGiven > 0 then
										for i = 1, ticketDifference do
											glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given - 1
											change = change - 1
											if glrCharacter[state].Entries.Tickets[currentName].Given == 0 then
												break
											end
										end
									end
									
									if currentSold > 0 then
										if change > 0 then
											for i = 1, change do
												glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold - 1
												glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
												if glrCharacter[state].Entries.Tickets[currentName].Sold == 0 then
													break
												end
											end
										end
									end
									
								end
								
								if not bypassRemoveEntry then
									
									for i = 1, ticketDifference do
										table.insert(glrCharacter[state].TicketPool, holdTickets[1])
										table.remove(holdTickets, 1)
									end
									
									holdTickets = nil
									
									sort(glrCharacter[state].TicketPool)
									if ticketChange > 0 then
										sort(glrCharacter[state].Entries.TicketNumbers[currentName])
									end
									
									if ticketChange > 0 then
										glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = ticketChange
									end
									
								end
								
								GLR_U:UpdateInfo()
								
								if state == "Lottery" then
									GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetChecked(false)
									GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
								else
									GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetChecked(false)
									GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
								end
								
							elseif ticketChange > currentTickets then
								
								local ticketIncrease = ticketChange - currentTickets
								local TicketNumber = glrCharacter.Event[state].LastTicketBought
								local holdTickets = {}
								
								for i = 1, #glrTemp[state][currentName].TicketNumbers do
									local v = glrTemp[state][currentName].TicketNumbers[i]
									table.insert(holdTickets, v)
								end
								
								glrCharacter[state].Entries.TicketNumbers[currentName] = nil
								glrCharacter[state].Entries.TicketNumbers[currentName] = {}
								
								for i = 1, currentTickets do
									table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], holdTickets[1])
									table.remove(holdTickets, 1)
								end
								
								sort(glrCharacter[state].Entries.TicketNumbers[currentName])
								
								for i = 1, ticketIncrease do
									if glrCharacter[state].TicketPool[1] ~= nil then
										table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], glrCharacter[state].TicketPool[1])
										table.insert(glrTemp[state][currentName], glrCharacter[state].TicketPool[1])
										if glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber == 0 then
											glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
										end
										if ticketIncrease == i and LastTicketNumberBought then
											glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
											LastTicketNumberBought = false
										end
										table.remove(glrCharacter[state].TicketPool, 1)
									else
										local ts = tostring(TicketNumber)
										table.insert(glrCharacter[state].Entries.TicketNumbers[currentName], ts)
										table.insert(glrTemp[state][currentName], ts)
										if glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber == 0 then
											glrCharacter[state].Entries.TicketRange[currentName].LowestTicketNumber = TicketNumber
										end
										if ticketIncrease == i and LastTicketNumberBought then
											glrCharacter[state].Entries.TicketRange[currentName].HighestTicketNumber = TicketNumber
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
								sort(glrCharacter[state].Entries.TicketNumbers[currentName])
								
								if FreeTickets then
									glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given + ticketIncrease
									glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
								else
									glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold + ticketIncrease
									glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
								end
								
								glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = ticketChange
								glrTemp[state][currentName].NumberOfTickets = ticketChange
								
							end
							
						else
							
							if ticketChange < currentTickets or bypassRemoveEntry then
								
								if not bypassRemoveEntry then
									
									local ticketDifference = currentTickets - ticketChange
									
									if state == "Lottery" then
										if guaranteedWinner then
											glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ticketDifference
										else
											glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ( ticketDifference * 2 )
										end
									else
										glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ticketDifference
									end
									
									local change = ticketDifference
									
									glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets - ticketDifference
									
									if currentGiven > 0 then
										for i = 1, ticketDifference do
											glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given - 1
											glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - 1
											change = change - 1
											if glrCharacter.Event[state].GiveAwayTickets == 0 then break end
											if glrCharacter[state].Entries.Tickets[currentName].Given == 0 then break end
										end
									end
									
									if currentSold > 0 then
										if change > 0 then
											for i = 1, change do
												glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold - 1
												glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
												if glrCharacter.Event[state].TicketsSold == 0 then break end
												if glrCharacter[state].Entries.Tickets[currentName].Sold == 0 then break end
											end
										end
									end
									
								end
								
								if ticketChange == 0 then
									if glrCharacter.Data.RollOver.Lottery.Check ~= nil then
										if glrCharacter.Data.RollOver.Lottery.Check[currentName] ~= nil then
											glrCharacter.Data.RollOver.Lottery.Check[currentName] = nil
											for i = 1, #glrCharacter.Data.RollOver.Lottery.Names do
												if currentName == glrCharacter.Data.RollOver.Lottery.Names[i] then
													table.remove(glrCharacter.Data.RollOver.Lottery.Names, i)
													break
												end
											end
										end
									end
									glrCharacter[state].MessageStatus[currentName] = nil
									glrCharacter[state].Entries.Tickets[currentName] = nil
									glrCharacter[state].Entries.TicketRange[currentName] = nil
									glrCharacter[state].Entries.TicketNumbers[currentName] = nil
									for i = 1, #glrCharacter[state].Entries.Names do
										if currentName == glrCharacter[state].Entries.Names[i] then
											table.remove(glrCharacter[state].Entries.Names, i)
											sort(glrCharacter[state].Entries.Names)
											break
										end
									end
								else
									if glrCharacter[state].MessageStatus[currentName] ~= nil then
										glrCharacter[state].MessageStatus[currentName].sentMessage = false
									else
										glrCharacter[state].MessageStatus[currentName] = { ["sentMessage"] = false, }
									end
								end
								
							elseif ticketChange > currentTickets then
								
								local ticketIncrease = ticketChange - currentTickets
								
								if state == "Lottery" then
									if guaranteedWinner then
										glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ticketIncrease
									else
										glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( ticketIncrease * 2 )
									end
								else
									glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ticketIncrease
								end
								
								if not FreeTickets then
									glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
									glrCharacter[state].Entries.Tickets[currentName].Sold = glrCharacter[state].Entries.Tickets[currentName].Sold + ticketIncrease
								else
									glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
									glrCharacter[state].Entries.Tickets[currentName].Given = glrCharacter[state].Entries.Tickets[currentName].Given + ticketIncrease
								end
								
								glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets = glrCharacter[state].Entries.Tickets[currentName].NumberOfTickets + ticketIncrease
								
								if ticketChange > 0 then
									if not FreeTickets then
										if glrCharacter[state].MessageStatus[currentName] ~= nil then
											glrCharacter[state].MessageStatus[currentName].sentMessage = false
										else
											glrCharacter[state].MessageStatus[currentName] = { ["sentMessage"] = false, }
										end
									end
								end
								
							end
							
						end
						
						GLR_U:UpdateInfo()
						
						if state == "Lottery" then
							GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_EditFreeLotteryTicketsCheckButton:SetChecked(false)
							GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
						else
							GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_EditFreeRaffleTicketsCheckButton:SetChecked(false)
							GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
						end
						
						if glrCharacter[state].MessageStatus[currentName] ~= nil then
							
							local targetRealm
							local bypass = false
							local vN = currentName
							
							if string.find(string.lower(currentName), "-") ~= nil then
								targetRealm = string.sub(currentName, string.find(currentName, "-") + 1)
							else
								bypass = true
							end
							
							if PlayerRealmName == targetRealm and not bypass then
								vN = string.sub(currentName, 1, string.find(currentName, "-") - 1)
							end
							
							if continue then
								
								local timestamp = GetTimeStamp()
								table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ChangePlayerInEventInfo() - Sending Updated Ticket Info Message To Current Player: [" .. currentName .. "] - Event: [" .. string.upper(state) .. "]")
								GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
								
							--elseif not continue and status then
								
								--With Multi-Guild Events enabled, the mod will only attempt to send a message to the target player if they're part of the same faction.
								-- for key, val in pairs(glrHistory.GuildRoster[faction]) do
									-- for i = 1, #glrHistory.GuildRoster[faction][key] do
										-- local CompareText = string.sub(glrHistory.GuildRoster[faction][key][i], 1, string.find(glrHistory.GuildRoster[faction][key][i], '%[') - 1)
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
									-- if not glrCharacter[state].MessageStatus[currentName].sentMessage then
										-- local timestamp = GetTimeStamp()
										-- table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - ChangePlayerInEventInfo() - WhoLib Search Started For: [" .. currentName .. "]")
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
									GLR:Print("|cfff7ff4d" .. currentName .. " " .. L["Send Info Player Not Online"] .. "|r")
								end
								
							end
							
						end
						
					end
					
				end
				
			else
				if state == "Lottery" then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["Edit Player Max Tickets Exceeded"])
				else
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["Edit Player Max Tickets Exceeded"])
				end
			end
			
		else
			if state == "Lottery" then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["Edit Player Ticket Not Numerical"])
			else
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["Edit Player Ticket Not Numerical"])
			end
		end
		
	end
	
end

local function EditPlayerTickets(name, state, amount, free)
	
	local MaxTicket = tonumber(glrCharacter.Event[state].MaxTickets)
	local faction, _ = UnitFactionGroup("PLAYER")
	local status = glrCharacter.Data.Settings.General.MultiGuild
	local PlayerNames = GenerateRosterNames()
	local oldTickets = glrCharacter[state].Entries.Tickets
	local oldTicketNumbers = glrCharacter[state].Entries.TicketNumbers
	local oldTicketRange = glrCharacter[state].Entries.TicketRange
	local glrTempStatus = glrCharacter[state].MessageStatus
	local guaranteedWinner = false
	local continue = false
	local FirstTicketNumberBought = true
	local LastTicketNumberBought = true
	local numTotalMembers, _, _ = GetNumGuildMembers()
	local Advanced = glrCharacter.Data.Settings.General.AdvancedTicketDraw
	
	if state == "Lottery" then
		if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
			guaranteedWinner = true
		end
	else
		guaranteedWinner = true
	end
	
	local currentTickets = glrCharacter[state].Entries.Tickets[name].NumberOfTickets
	local currentSold = glrCharacter[state].Entries.Tickets[name].Sold
	local currentGiven = glrCharacter[state].Entries.Tickets[name].Given
	local ticketChange = currentTickets + amount
	
	if ticketChange > MaxTicket then
		ticketChange = MaxTicket
	end
	
	if not Advanced then
		
		if glrTemp == nil then
			glrTemp = {}
		end
		if glrTemp[state] == nil then
			glrTemp[state] = {}
		end
		if glrTemp[state][name] == nil then
			glrTemp[state][name] = {}
		end
		if glrTemp[state][name].TicketNumbers == nil then
			glrTemp[state][name].TicketNumbers = {}
		end
		if glrTemp[state][name].NumberOfTickets == nil then
			glrTemp[state][name].NumberOfTickets = 0
		end
		if glrTemp[state][name].TicketRange == nil then
			glrTemp[state][name].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
		else
			glrTemp[state][name].TicketRange = { ["LowestTicketNumber"] = 0, ["HighestTicketNumber"] = 0 }
		end
		if glrCharacter[state].Entries.TicketNumbers[name] ~= nil then
			glrTemp[state][name] = glrCharacter[state].Entries.TicketNumbers[name]
			glrTemp[state][name].NumberOfTickets = glrCharacter[state].Entries.Tickets[name].NumberOfTickets
			glrTemp[state][name].TicketNumbers = glrCharacter[state].Entries.TicketNumbers[name]
		end
		
		if ticketChange < currentTickets then
			
			local ticketDifference = currentTickets - ticketChange
			local holdTickets = {}
			local update = false
			
			for i = 1, #glrTemp[state][name].TicketNumbers do
				local v = glrTemp[state][name].TicketNumbers[i]
				table.insert(holdTickets, v)
			end
			
			glrCharacter[state].Entries.TicketNumbers[name] = nil
			glrCharacter[state].Entries.TicketNumbers[name] = {}
			
			for i = 1, ticketChange do
				table.insert(glrCharacter[state].Entries.TicketNumbers[name], holdTickets[1])
				if ticketChange == i and LastTicketNumberBought then
					glrCharacter[state].Entries.TicketRange[name].HighestTicketNumber = tonumber(holdTickets[1])
					LastTicketNumberBought = false
				end
				table.remove(holdTickets, 1)
			end
			
			local change = ticketDifference
			
			if currentGiven > 0 then
				for i = 1, ticketDifference do
					glrCharacter[state].Entries.Tickets[name].Given = glrCharacter[state].Entries.Tickets[name].Given - 1
					change = change - 1
					if glrCharacter[state].Entries.Tickets[name].Given == 0 then
						break
					end
				end
			end
			
			if currentSold > 0 then
				if change > 0 then
					for i = 1, change do
						if not update then update = true end
						glrCharacter[state].Entries.Tickets[name].Sold = glrCharacter[state].Entries.Tickets[name].Sold - 1
						glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
						if glrCharacter[state].Entries.Tickets[name].Sold == 0 then
							break
						end
					end
				end
			end
			
			for i = 1, ticketDifference do
				table.insert(glrCharacter[state].TicketPool, holdTickets[1])
				table.remove(holdTickets, 1)
			end
			
			holdTickets = nil
			
			sort(glrCharacter[state].TicketPool)
			sort(glrCharacter[state].Entries.TicketNumbers[name])
			glrCharacter[state].Entries.Tickets[name].NumberOfTickets = ticketChange
			
			if update then
				if glrCharacter[state].MessageStatus[name] ~= nil then
					glrCharacter[state].MessageStatus[name].sentMessage = false
				else
					glrCharacter[state].MessageStatus[name] = { ["sentMessage"] = false, }
				end
			end
			
		elseif ticketChange > currentTickets and ticketChange <= MaxTicket then
			
			local ticketIncrease = ticketChange - currentTickets
			local TicketNumber = glrCharacter.Event[state].LastTicketBought
			local holdTickets = {}
			
			for i = 1, #glrTemp[state][name].TicketNumbers do
				local v = glrTemp[state][name].TicketNumbers[i]
				table.insert(holdTickets, v)
			end
			
			glrCharacter[state].Entries.TicketNumbers[name] = nil
			glrCharacter[state].Entries.TicketNumbers[name] = {}
			
			for i = 1, currentTickets do
				table.insert(glrCharacter[state].Entries.TicketNumbers[name], holdTickets[1])
				table.remove(holdTickets, 1)
			end
			
			sort(glrCharacter[state].Entries.TicketNumbers[name])
			
			for i = 1, ticketIncrease do
				if glrCharacter[state].TicketPool[1] ~= nil then
					table.insert(glrCharacter[state].Entries.TicketNumbers[name], glrCharacter[state].TicketPool[1])
					table.insert(glrTemp[state][name], glrCharacter[state].TicketPool[1])
					if ticketIncrease == i and LastTicketNumberBought then
						glrCharacter[state].Entries.TicketRange[name].HighestTicketNumber = tonumber(glrCharacter[state].TicketPool[1])
						LastTicketNumberBought = false
					end
					table.remove(glrCharacter[state].TicketPool, 1)
				else
					local ts = tostring(TicketNumber)
					table.insert(glrCharacter[state].Entries.TicketNumbers[name], ts)
					table.insert(glrTemp[state][name], ts)
					if ticketIncrease == i and LastTicketNumberBought then
						glrCharacter[state].Entries.TicketRange[name].HighestTicketNumber = TicketNumber
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
			sort(glrCharacter[state].Entries.TicketNumbers[name])
			
			if free then
				glrCharacter[state].Entries.Tickets[name].Given = glrCharacter[state].Entries.Tickets[name].Given + ticketIncrease
				glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
			else
				glrCharacter[state].Entries.Tickets[name].Sold = glrCharacter[state].Entries.Tickets[name].Sold + ticketIncrease
				glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
			end
			
			glrCharacter[state].Entries.Tickets[name].NumberOfTickets = ticketChange
			glrTemp[state][name].NumberOfTickets = ticketChange
			
		end
		
		GLR:UpdateNumberOfUnusedTickets()
		
	else
		
		if ticketChange < currentTickets then
			
			local ticketDifference = currentTickets - ticketChange
			local update = false
			
			if state == "Lottery" then
				if guaranteedWinner then
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ticketDifference
				else
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ( ticketDifference * 2 )
				end
			else
				glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought - ticketDifference
			end
			
			local change = ticketDifference
			
			glrCharacter[state].Entries.Tickets[name].NumberOfTickets = glrCharacter[state].Entries.Tickets[name].NumberOfTickets - ticketDifference
			
			if currentGiven > 0 then
				for i = 1, ticketDifference do
					glrCharacter[state].Entries.Tickets[name].Given = glrCharacter[state].Entries.Tickets[name].Given - 1
					glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets - 1
					change = change - 1
					if glrCharacter.Event[state].GiveAwayTickets == 0 then break end
					if glrCharacter[state].Entries.Tickets[name].Given == 0 then break end
				end
			end
			
			if currentSold > 0 then
				if change > 0 then
					for i = 1, change do
						if not update then update = true end
						glrCharacter[state].Entries.Tickets[name].Sold = glrCharacter[state].Entries.Tickets[name].Sold - 1
						glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold - 1
						if glrCharacter.Event[state].TicketsSold == 0 then break end
						if glrCharacter[state].Entries.Tickets[name].Sold == 0 then break end
					end
				end
			end
			
			if update then
				glrCharacter[state].MessageStatus[name].sentMessage = false
			end
			
		elseif ticketChange > currentTickets and ticketChange <= MaxTicket then
			
			local ticketIncrease = ticketChange - currentTickets
			
			if state == "Lottery" then
				if guaranteedWinner then
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ticketIncrease
				else
					glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ( ticketIncrease * 2 )
				end
			else
				glrCharacter.Event[state].LastTicketBought = glrCharacter.Event[state].LastTicketBought + ticketIncrease
			end
			
			if not free then
				glrCharacter.Event[state].TicketsSold = glrCharacter.Event[state].TicketsSold + ticketIncrease
				glrCharacter[state].Entries.Tickets[name].Sold = glrCharacter[state].Entries.Tickets[name].Sold + ticketIncrease
			else
				glrCharacter.Event[state].GiveAwayTickets = glrCharacter.Event[state].GiveAwayTickets + ticketIncrease
				glrCharacter[state].Entries.Tickets[name].Given = glrCharacter[state].Entries.Tickets[name].Given + ticketIncrease
			end
			
			glrCharacter[state].Entries.Tickets[name].NumberOfTickets = glrCharacter[state].Entries.Tickets[name].NumberOfTickets + ticketIncrease
			
			if not free then
				if glrCharacter[state].MessageStatus[name] ~= nil then
					glrCharacter[state].MessageStatus[name].sentMessage = false
				else
					glrCharacter[state].MessageStatus[name] = { ["sentMessage"] = false, }
				end
			end
			
		end
		
	end
	
	if state == "Lottery" then
		if GLR_UI.GLR_EditPlayerInLotteryFrame:IsVisible() then
			GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
		end
	else
		if GLR_UI.GLR_EditPlayerInRaffleFrame:IsVisible() then
			GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
		end
	end
	
	GLR_U:UpdateInfo(false)
	
end

---------------------------------------------
---------- SEND PLAYER TICKET INFO ----------
---------------------------------------------
--------- CHECKS IF PLAYER IS ONLINE --------
--------- AND IN SAME GUILD AS HOST ---------
---------------------------------------------

function GLR:SendPlayerTheirTicketInfo(glrTemp, vN, state)
	
	local EventDate
	local ticketPrice
	local jackpotGold = ""
	local playerGuild = glrCharacter.Data.Settings.General.GuildName
	local LargeData = glrCharacter.Data.Settings.General.SendLargeInfo
	local guildPercent
	local userName = vN
	local ticketsN = 0
	local ticketString
	local dateTime = time()
	local prizeOne = false
	local prizeTwo = false
	local prizeThree = false
	local round = false
	
	if not string.find(userName, "-") then
		userName = strjoin("-", userName, PlayerRealmName)
	end
	
	if state == "Lottery" then
		round = glrCharacter.Data.Settings.Lottery.RoundValue
		if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
			EventDate = glrCharacter.Event[state].Date
		else
			local s = string.sub(glrCharacter.Event[state].Date, 1, string.find(glrCharacter.Event[state].Date, "%@") + 1)
			local t = GetTimeFormat(string.sub(glrCharacter.Event[state].Date, string.find(glrCharacter.Event[state].Date, "%:") - 2))
			EventDate = s .. t
		end
		ticketPrice = tonumber(glrCharacter.Event[state].TicketPrice)
		local tempJackpotGold = tonumber(glrCharacter.Event[state].StartingGold) + ( glrCharacter.Event[state].TicketsSold * tonumber(glrCharacter.Event[state].TicketPrice) )
		guildPercent = glrCharacter.Event[state].GuildCut
		jackpotGold = tempJackpotGold - ( (tonumber(guildPercent) / 100) * tempJackpotGold )
		jackpotGold = GLR_U:GetMoneyValue(jackpotGold, "Lottery", true, 1)
	else
		if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
			EventDate = glrCharacter.Event[state].Date
		else
			local s = string.sub(glrCharacter.Event[state].Date, 1, string.find(glrCharacter.Event[state].Date, "%@") + 1)
			local t = GetTimeFormat(string.sub(glrCharacter.Event[state].Date, string.find(glrCharacter.Event[state].Date, "%:") - 2))
			EventDate = s .. t
		end
		ticketPrice = tonumber(glrCharacter.Event[state].TicketPrice)
		if glrCharacter.Event[state].FirstPlace then
			if glrCharacter.Event[state].FirstPlace == "%raffle_total" then
				prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].FirstPlace == "%raffle_half" then
				prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].FirstPlace == "%raffle_quarter" then
				prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			elseif tonumber(glrCharacter.Event[state].FirstPlace) ~= nil then
				prizeOne = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].FirstPlace), "Raffle", false, 1, "NA", true, false)
			else
				prizeOne = glrCharacter.Event[state].FirstPlace
			end
		end
		if glrCharacter.Event[state].SecondPlace then
			if glrCharacter.Event[state].SecondPlace == "%raffle_total" then
				prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].SecondPlace == "%raffle_half" then
				prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].SecondPlace == "%raffle_quarter" then
				prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			elseif tonumber(glrCharacter.Event[state].SecondPlace) ~= nil then
				prizeTwo = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].SecondPlace), "Raffle", false, 1, "NA", true, false)
			else
				prizeTwo = glrCharacter.Event[state].SecondPlace
			end
		end
		if glrCharacter.Event[state].ThirdPlace then
			if glrCharacter.Event[state].ThirdPlace == "%raffle_total" then
				prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].ThirdPlace == "%raffle_half" then
				prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
			elseif glrCharacter.Event[state].ThirdPlace == "%raffle_quarter" then
				prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
			elseif tonumber(glrCharacter.Event[state].ThirdPlace) ~= nil then
				prizeThree = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].ThirdPlace), "Raffle", false, 1, "NA", true, false)
			else
				prizeThree = glrCharacter.Event[state].ThirdPlace
			end
		end
	end
	
	ticketPrice = GLR_U:GetMoneyValue(ticketPrice, "Lottery", false, 1, "NA", true, false)
	
	if playerGuild ~= nil then
		
		local maxTickets = 0
		local ticketDiff = 0
		local title = L["Send Info Title"] .. GLR_CurrentVersionString
		
		if glrCharacter[state].Entries.Tickets[userName] ~= nil then
			ticketsN = glrCharacter[state].Entries.Tickets[userName].NumberOfTickets
		else
			ticketsN = glrTemp[state][userName].NumberOfTickets
		end
		
		if glrCharacter[state].Entries.TicketNumbers[userName] ~= nil then
			ticketString = glrCharacter[state].Entries.TicketNumbers[userName]
		else
			ticketString = glrTemp[state][userName].TicketNumbers
		end
		
		if glrCharacter[state].MessageStatus[userName] == nil then
			glrCharacter[state].MessageStatus[userName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
		else
			glrCharacter[state].MessageStatus[userName] = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
		end
		
		maxTickets = tonumber(glrCharacter.Event[state].MaxTickets)
		ticketDiff = maxTickets - ticketsN
		
		SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
		SendChatMessage(title, "WHISPER", nil, userName)
		
		if state == "Lottery" then
			SendChatMessage(L["Send Info Player Lottery Entered"] .. ": " .. EventDate, "WHISPER", nil, userName)
		else
			SendChatMessage(L["Send Info Player Raffle Entered"] .. ": " .. EventDate, "WHISPER", nil, userName)
		end
		
		if ticketsN < maxTickets then
			if ticketDiff == 1 then
				SendChatMessage(L["Send Info Tickets Purchased Part 1"] .. " " .. ticketsN .. " " .. L["Send Info Tickets Purchased Part 2"] .. " " .. ticketDiff .. " " .. L["Send Info Tickets Purchased Part 3.1"] .. " " .. ticketPrice .. " " .. L["Send Info Tickets Purchased Part 4"], "WHISPER", nil, userName)
			else
				SendChatMessage(L["Send Info Tickets Purchased Part 1"] .. " " .. ticketsN .. " " .. L["Send Info Tickets Purchased Part 2"] .. " " .. ticketDiff .. " " .. L["Send Info Tickets Purchased Part 3"] .. " " .. ticketPrice .. " " .. L["Send Info Tickets Purchased Part 4"], "WHISPER", nil, userName)
			end
		else
			SendChatMessage(L["Send Info Max Tickets Part 1"] .. " " .. ticketsN .. " " .. L["Send Info Max Tickets Part 2"], "WHISPER", nil, userName)
		end
		
		if LargeData and not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
			
			local purchasedTickets
			local ticketNumbers = ""
			
			purchasedTickets = tostring(glrCharacter[state].Entries.Tickets[userName].NumberOfTickets)
			
			if glrCharacter[state].Entries.TicketNumbers[userName] ~= nil then
				ticketString = glrCharacter[state].Entries.TicketNumbers[userName]
			end
			
			for i = 1, #ticketString do
				ticketNumbers = strjoin(" ", ticketNumbers, ticketString[i])
			end
			
			local length = strlen(ticketNumbers)
			
			if length > 220 then
				
				local currentTime = time()
				local longMsg = true
				local bypass = true
				local endMsg = true
				local done = false
				local ta = {}
				local lt = {}
				local ts = ""
				local nt = 0
				local mnt = 0
				local nm = 0
				local steps = 35
				
				if longMsg then
					SendChatMessage(L["Send Info Long Ticket Message"], "WHISPER", nil, userName)
					longMsg = false
				end
				
				for v in string.gmatch(ticketNumbers, "[^ ]+") do
					table.insert(ta, v)
					nt = nt + 1
					mnt = mnt + 1
				end
				
				if mnt >= 500 then
					bypass = false
				end
				
				for i = 1, #ta do
					
					for j = 1, steps do
						if length > 0 or not done then
							if  nt > 0 then
								ts = strjoin(" ", ts, ta[1])
								table.remove(ta, 1)
								nt = nt - 1
							end
						end
					end
					
					if not done then
						nm = nm + 1
						if not bypass then
							table.insert(lt, ts)
						end
						length = length - strlen(ts)
						steps = length / 5
						if steps > 35 then
							steps = 35
						end
						if nt == 0 then
							done = true
						end
					end
					
					if bypass then
						SendChatMessage(L["Send Info GLR"] .. ":" .. ts, "WHISPER", nil, userName)
					end
					
					--Resets the Ticket Number string so it's not a ever growing string until it breaks the character limit
					ts = ""
					
					if done then
						break
					end
					
				end
				
				if not bypass then
					local ms = 0.2
					nm = nm + 1
					sort(lt)
					for i = 1, nm do
						C_Timer.After(ms, function()
							GLR:SendLargeTicketInfo(lt, userName, nm, state)
						end)
						ms = ms + 0.2
					end
				end
				
				if endMsg and bypass and state == "Lottery" then
					SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					endMsg = false
				elseif endMsg and bypass and state == "Raffle" then
					SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
					if prizeOne then
						prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
						SendChatMessage(prizeOne, "WHISPER", nil, userName)
					end
					if prizeTwo then
						prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
						SendChatMessage(prizeTwo, "WHISPER", nil, userName)
					end
					if prizeThree then
						prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
						SendChatMessage(prizeThree, "WHISPER", nil, userName)
					end
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					endMsg = false
				end
				
			else
				if tonumber(purchasedTickets) > 0 then
					SendChatMessage(L["Send Info Short Ticket Message"] .. ":" .. ticketNumbers, "WHISPER", nil, userName)
					if state == "Lottery" then
						SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
					else
						SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
						if prizeOne then
							prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
							SendChatMessage(prizeOne, "WHISPER", nil, userName)
						end
						if prizeTwo then
							prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
							SendChatMessage(prizeTwo, "WHISPER", nil, userName)
						end
						if prizeThree then
							prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
							SendChatMessage(prizeThree, "WHISPER", nil, userName)
						end
					end
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
				end
			end
			
		else
			local fT
			local lT
			if state == "Lottery" then
				if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
					fT = glrCharacter[state].Entries.TicketRange[userName].LowestTicketNumber
					lT = glrCharacter[state].Entries.TicketRange[userName].HighestTicketNumber
					local message_1 = string.gsub(string.gsub(L["Send Info Ticket Number Range"], "%%first", fT), "%%last", lT)
					SendChatMessage(message_1, "WHISPER", nil, userName)
				end
				local WinChanceTable = { [1] = "90", [2] = "80", [3] = "70", [4] = "60", [5] = "50", [6] = "40", [7] = "30", [8] = "20", [9] = "10", [10] = "100" }
				local WinChanceKeyValue = 5
				if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
					WinChanceKeyValue = glrCharacter.Data.Settings.Lottery.WinChanceKey
				else
					WinChanceKeyValue = 10
				end
				local WinChanceMessage, _ = string.gsub(L["Send Info Current Win Chance"], "%%c", WinChanceTable[WinChanceKeyValue])
				SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
				SendChatMessage(WinChanceMessage, "WHISPER", nil, userName)
			else
				if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
					fT = glrCharacter[state].Entries.TicketRange[userName].LowestTicketNumber
					lT = glrCharacter[state].Entries.TicketRange[userName].HighestTicketNumber
					local message_1 = string.gsub(string.gsub(L["Send Info Ticket Number Range"], "%%first", fT), "%%last", lT)
					SendChatMessage(message_1, "WHISPER", nil, userName)
				end
				SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
				if prizeOne then
					prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
					SendChatMessage(prizeOne, "WHISPER", nil, userName)
				end
				if prizeTwo then
					prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
					SendChatMessage(prizeTwo, "WHISPER", nil, userName)
				end
				if prizeThree then
					prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
					SendChatMessage(prizeThree, "WHISPER", nil, userName)
				end
			end
			SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
		end
	end
	
end

function GLR:SendLargeTicketInfo(lt, userName, nm, state)
	local jackpotGold
	local guildPercent
	if state == "Lottery" then
		local round = glrCharacter.Data.Settings.Lottery.RoundValue
		local tempJackpotGold = tonumber(glrCharacter.Event[state].StartingGold) + ( glrCharacter.Event[state].TicketsSold * tonumber(glrCharacter.Event[state].TicketPrice) )
		guildPercent = glrCharacter.Event[state].GuildCut
		jackpotGold = tempJackpotGold - ( (tonumber(guildPercent) / 100) * tempJackpotGold )
		jackpotGold = GLR_U:GetMoneyValue(jackpotGold, "Lottery", true, 1)
	end
	local msg = lt[1]
	if msg ~= nil then
		SendChatMessage(L["Send Info GLR"] .. ":" .. msg, "WHISPER", nil, userName)
		table.remove(lt, 1)
	end
	if msg == nil then
		if state == "Lottery" then
			SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
		else
			SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
			if glrCharacter.Event[state].FirstPlace ~= nil then
				SendChatMessage(L["Send Info GLR"] .. ": " .. glrCharacter.Event[state].FirstPlace, "WHISPER", nil, userName)
			end
			if glrCharacter.Event[state].SecondPlace ~= nil then
				SendChatMessage(L["Send Info GLR"] .. ": " .. glrCharacter.Event[state].SecondPlace, "WHISPER", nil, userName)
			end
			if glrCharacter.Event[state].ThirdPlace ~= nil then
				SendChatMessage(L["Send Info GLR"] .. ": " .. glrCharacter.Event[state].ThirdPlace, "WHISPER", nil, userName)
			end
		end
		SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
	end
end

---------------------------------------------
------- UPDATE PLAYER & TOTAL TICKETS -------
---------------------------------------------
--------- UPDATES DISPLAYED PLAYERS ---------
---------- AND THEIR TOTAL TICKETS ----------
---------------------------------------------

local PlusUpdate = true
local MinusUpdate = true
local PlusState = true
local PlusTimer = false
local MinusState = true
local MinusTimer = false
function GLR:UpdatePlayersAndTotalTickets(scroll)
	
	if scroll == nil then scroll = true end
	local classTable = {}
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if not status then
		classTable = glrRoster
	else
		classTable = glrMultiGuildRoster
	end
	local playerNamesAndTickets = GLR:GeneratePlayersAndTicketTotalsTable()
	local s = Variables[10]
	local buffer = 3
	local count = 1
	local count2 = 1
	local scrollHeight = 0
	local Max
	local doBypass = true
	local check = false
	local advance = glrCharacter.Data.Settings.General.AdvancedTicketDraw
	
	local function SendDataForEntry(advanced, name, state, amount, free)
		local new = false
		local guaranteedWinner = false
		if glrCharacter[state].Entries.Tickets[name].NumberOfTickets == 0 then new = true end
		if state == "Lottery" then
			if glrCharacter.Event[state].SecondPlace == L["Winner Guaranteed"] then
				guaranteedWinner = true
			end
		else
			guaranteedWinner = true
		end
		if new then
			AddPlayerToEvent(state, false, name, amount, free)
		else
			EditPlayerTickets(name, state, amount, free)
		end
	end
	
	if s ~= nil then
		if glrCharacter.Event[s].MaxTickets ~= nil then
			Max = tonumber(glrCharacter.Event[s].MaxTickets)
		end
		if s == "Lottery" then
			check = true
		end
	end
	
	if GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings == nil then
		
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings or {}
		
	elseif GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings ~= nil then
		
		for i = 1, #GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings do
			
			local ClearPlayersText = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[count2][1]
			local ClearTicketsText = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[count2][2]
			ClearPlayersText:SetText()
			ClearTicketsText:SetText()
			count2 = count2 + 1
			
		end
		
	end
	
	if GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons == nil then
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons or {}
	elseif GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons ~= nil then
		for i = 1, #GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons do
			local UpButton = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[i][1]
			local DownButton = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[i][2]
			DownButton:Hide()
			DownButton:UnregisterAllEvents()
			DownButton:SetID(0)
			DownButton:ClearAllPoints()
			UpButton:Hide()
			UpButton:UnregisterAllEvents()
			UpButton:SetID(0)
			UpButton:ClearAllPoints()
			for script, _ in pairs(profile.frames.scripts) do
				UpButton:SetScript(script, nil)
				DownButton:SetScript(script, nil)
			end
		end
	end
	
	if #playerNamesAndTickets > 0 then
		
		for t, v in pairs(playerNamesAndTickets) do
			
			if not GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[t] then
				GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[t] = { GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild:CreateFontString("GLR_PlayerNamesText" .. count, "OVERLAY", "GameFontWhiteTiny"), GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild:CreateFontString("GLR_PlayerTicketsText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
			
			if not GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[t] then
				GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[t] = { CreateFrame("Button", "UpButton" .. count, GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild, "UIPanelButtonTemplate"), CreateFrame("Button", "DownButton" .. count, GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild, "UIPanelButtonTemplate") }
			end
			
			local UpButton = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[count][1]
			local DownButton = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[count][2]
			local PlayerNamesText = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[count][1]
			local PlayerTicketsText = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.PlayersAndTicketsTextFontstrings[count][2]
			local targetName = v
			local bypass = false
			local playerRealm
			if string.find(string.lower(v), "-") ~= nil then
				playerRealm = string.sub(v, string.find(v, "-") + 1)
			else
				bypass = true
			end
			
			if not bypass then
				targetName = string.sub(v, 1, string.find(v, "-") - 1)
			end
			
			UpButton:SetSize(16,16)
			UpButton:SetNormalTexture("Interface\\BUTTONS\\UI-PlusButton-Up")
			UpButton:SetPushedTexture("Interface\\BUTTONS\\UI-PlusButton-Down")
			UpButton:SetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Hilight")
			
			DownButton:SetSize(16,16)
			DownButton:SetNormalTexture("Interface\\BUTTONS\\UI-MinusButton-Up")
			DownButton:SetPushedTexture("Interface\\BUTTONS\\UI-MinusButton-Down")
			DownButton:SetHighlightTexture("Interface\\BUTTONS\\UI-PlusButton-Hilight")
			
			if check then
				if glrCharacter[s].Entries.Tickets[v] == nil then
					doBypass = false
				end
			end
			
			UpButton:SetScript("OnClick", function(self, button, down)
				if doBypass then
					if down == nil then down = false end
					if GLR_Global_Variables[1] then
						local continue = true
						if s == "Lottery" and GLR_Global_Variables[6][1] then continue = false end
						if s == "Raffle" and GLR_Global_Variables[6][2] then continue = false end
						if continue then
							local Max = tonumber(glrCharacter.Event[s].MaxTickets)
							if not down then
								local timestamp = GetTimeStamp()
								local SHFT = IsShiftKeyDown()
								local CTRL = IsControlKeyDown()
								if SHFT and CTRL then
									--Increase by 5 tickets.
									--Tickets are Free.
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - INCREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [5] - Free: [TRUE]")
									SendDataForEntry(advance, v, s, 5, true)
								elseif SHFT then
									--Just increase by 5 Tickets (bought).
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - INCREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [5] - Free: [FALSE]")
									SendDataForEntry(advance, v, s, 5, false)
								elseif CTRL then
									--Just give one Free Ticket.
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - INCREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [1] - Free: [TRUE]")
									SendDataForEntry(advance, v, s, 1, true)
								else
									--Just increase by 1 Ticket (bought).
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - INCREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [1] - Free: [FALSE]")
									SendDataForEntry(advance, v, s, 1, false)
								end
							end
							PlayerTicketsText:SetText(CommaValue(glrCharacter[s].Entries.Tickets[v].NumberOfTickets))
							if glrCharacter[s].Entries.Tickets[v].NumberOfTickets == Max then
								UpButton:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled")
								UpButton:Disable()
							else UpButton:Enable() end
							if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 1 then
								DownButton:Enable()
							end
						end
					end
				else
					UpButton:Disable()
					DownButton:Disable()
				end
			end)
			DownButton:SetScript("OnClick", function(self, button, down)
				if doBypass then
					if down == nil then down = false end
					if GLR_Global_Variables[1] then
						local continue = true
						if s == "Lottery" and GLR_Global_Variables[6][1] then continue = false end
						if s == "Raffle" and GLR_Global_Variables[6][2] then continue = false end
						if continue then
							local Max = tonumber(glrCharacter.Event[s].MaxTickets)
							if not down then
								local timestamp = GetTimeStamp()
								local SHFT = IsShiftKeyDown()
								local CTRL = IsControlKeyDown()
								if SHFT and CTRL then
									--Decrease all the way to 1 Ticket left.
									local a = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
									table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - DECREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [" .. amount .. "]")
									SendDataForEntry(advance, v, s, -a, false)
								elseif SHFT then
									--Just decrease by 5.
									if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 5 then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - DECREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [5]")
										SendDataForEntry(advance, v, s, -5, false)
									else
										local a = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - DECREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [" .. amount .. "]")
										SendDataForEntry(advance, v, s, -a, false)
									end
								elseif not SHFT then
									--Decrease by 1 Ticket
									if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 1 then
										table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdatePlayersAndTotalTickets() - DECREASING Player Tickets. Event: [" .. string.upper(s) .. "] - SHFT / CTRL State: [" .. string.upper(tostring(SHFT)) .. " / " .. string.upper(tostring(CTRL)) .. "] - Name: [" .. v .. "] - Amount: [1]")
										SendDataForEntry(advance, v, s, -1, false)
									end
								end
							end
							PlayerTicketsText:SetText(CommaValue(glrCharacter[s].Entries.Tickets[v].NumberOfTickets))
							if glrCharacter[s].Entries.Tickets[v].NumberOfTickets <= 1 then
								DownButton:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")
								DownButton:Disable()
							else DownButton:Enable() end
							if glrCharacter[s].Entries.Tickets[v].NumberOfTickets ~= Max then
								UpButton:Enable()
							end
						end
					end
				else
					UpButton:Disable()
					DownButton:Disable()
				end
			end)
			
			UpButton:SetScript("OnEnter", function(self)
				if doBypass then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					if IsShiftKeyDown() then
						if IsControlKeyDown() then --Tooltip for adding five Free Tickets.
							GameTooltip:SetText("Increase Amount by:")
							GameTooltip:AddLine("Five Free Tickets")
						else -- Tooltip for adding five Tickets.
							GameTooltip:SetText("Increase Amount by:")
							GameTooltip:AddLine("Five Tickets")
						end
					else
						if IsControlKeyDown() then --Tooltip for adding one Free Ticket.
							GameTooltip:SetText("Increase Amount by:")
							GameTooltip:AddLine("One Free Ticket")
						else --Tooltip for adding one Ticket.
							GameTooltip:SetText("Increase Amount by:")
							GameTooltip:AddLine("One Ticket")
						end
					end
					GameTooltip:Show()
				end
			end)
			UpButton:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			UpButton:SetScript("OnShow", function(self)
				self.time = 1
			end)
			UpButton:SetScript("OnUpdate", function(self, elapsed)
				if doBypass then
					if self.time == nil then self.time = 1 end
					self.time = self.time - elapsed
					if self.time <= 0 then
						if PlusUpdate and (MouseIsOver(self)) then
							PlusUpdate = false
							self.time = 1
							if IsShiftKeyDown() then
								if IsControlKeyDown() then --Tooltip for adding five Free Tickets.
									GameTooltip:SetText("Increase Amount by:")
									GameTooltip:AddLine("Five Free Tickets")
								else -- Tooltip for adding five Tickets.
									GameTooltip:SetText("Increase Amount by:")
									GameTooltip:AddLine("Five Tickets")
								end
							else
								if IsControlKeyDown() then --Tooltip for adding one Free Ticket.
									GameTooltip:SetText("Increase Amount by:")
									GameTooltip:AddLine("One Free Ticket")
								else --Tooltip for adding one Ticket.
									GameTooltip:SetText("Increase Amount by:")
									GameTooltip:AddLine("One Ticket")
								end
							end
							GameTooltip:Show()
							C_Timer.After(1, function(self) PlusUpdate = true end)
						end
					end
				end
			end)
			
			DownButton:SetScript("OnEnter", function(self)
				if doBypass then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					if IsShiftKeyDown() then
						if IsControlKeyDown() then --Tooltip for removing all but one Ticket.
							local amount = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
							GameTooltip:SetText("Decrease Amount by:")
							GameTooltip:AddLine(amount .. " Ticket(s)")
						else -- Tooltip for removing at most Five Tickets.
							if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 5 then
								GameTooltip:SetText("Decrease Amount by:")
								GameTooltip:AddLine("Five Tickets")
							else -- Tooltip for removing less than 5 (but no more than the users last) Ticket(s).
								local amount = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
								GameTooltip:SetText("Decrease Amount by:")
								GameTooltip:AddLine(amount .. " Ticket(s)")
							end
						end
					else
						GameTooltip:SetText("Decrease Amount by:")
						GameTooltip:AddLine("One Ticket")
					end
					GameTooltip:Show()
				end
			end)
			DownButton:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			DownButton:SetScript("OnShow", function(self)
				self.time = 1
			end)
			DownButton:SetScript("OnUpdate", function(self, elapsed)
				if doBypass then
					if self.time == nil then self.time = 1 end
					self.time = self.time - elapsed
					if self.time <= 0 then
						if MinusUpdate and (MouseIsOver(self)) then
							MinusUpdate = false
							self.time = 1
							if IsShiftKeyDown() then
								if IsControlKeyDown() then --Tooltip for removing all but one Ticket.
									local amount = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
									GameTooltip:SetText("Decrease Amount by:")
									GameTooltip:AddLine(amount .. " Ticket(s)")
								else -- Tooltip for removing at most Five Tickets.
									if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 5 then
										GameTooltip:SetText("Decrease Amount by:")
										GameTooltip:AddLine("Five Tickets")
									else -- Tooltip for removing less than 5 (but no more than the users last) Ticket(s).
										local amount = glrCharacter[s].Entries.Tickets[v].NumberOfTickets - 1
										GameTooltip:SetText("Decrease Amount by:")
										GameTooltip:AddLine(amount .. " Ticket(s)")
									end
								end
							else
								if glrCharacter[s].Entries.Tickets[v].NumberOfTickets > 1 then
									GameTooltip:SetText("Decrease Amount by:")
									GameTooltip:AddLine("One Ticket")
								end
							end
							GameTooltip:Show()
							C_Timer.After(1, function(self) MinusUpdate = true end)
						end
					end
				end
			end)
			
			PlayerNamesText:SetText(targetName)
			PlayerNamesText:SetFont(GLR_Core.Font, 12)
			PlayerNamesText:SetWordWrap(false)
			
			for i = 1, #classTable do
				local text = classTable[i]
				local subText = string.sub(text, 1, string.find(text, '%[') - 1)
				local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
				if subText == v then
					if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
						CN = "NA"
					end
					PlayerNamesText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
					break
				end
			end
			
			if doBypass then
				PlayerTicketsText:SetText(CommaValue(glrCharacter[s].Entries.Tickets[v].NumberOfTickets))
			else
				PlayerTicketsText:SetText("0")
			end
			PlayerTicketsText:SetFont(GLR_Core.Font, 12)
			PlayerTicketsText:SetWordWrap(false)
			
			local height = UpButton:GetHeight()
			
			if count == 1 then
				UpButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild, "TOPRIGHT", -25, 0)
				scrollHeight = scrollHeight + height
			else
				UpButton:SetPoint("TOP", GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild.Buttons[count - 1][1], "BOTTOM", 0, -3)
				scrollHeight = scrollHeight + height + 3
			end
			
			PlayerNamesText:SetPoint("CENTER", UpButton, "LEFT", -130, 0)
			PlayerTicketsText:SetPoint("RIGHT", UpButton, "LEFT", -35, 0)
			DownButton:SetPoint("RIGHT", UpButton, "LEFT", -5, 0)
			
			if doBypass then
				if glrCharacter[s].Entries.Tickets[v].NumberOfTickets == Max then
					UpButton:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled")
					UpButton:Disable()
				else UpButton:Enable() end
				if glrCharacter[s].Entries.Tickets[v].NumberOfTickets <= 1 then
					DownButton:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")
					DownButton:Disable()
				else DownButton:Enable() end
			else
				UpButton:SetDisabledTexture("Interface\\BUTTONS\\UI-PlusButton-Disabled")
				DownButton:SetDisabledTexture("Interface\\BUTTONS\\UI-MinusButton-Disabled")
				UpButton:Disable()
				DownButton:Disable()
			end
			
			PlayerNamesText:Show()
			PlayerTicketsText:Show()
			UpButton:Show()
			DownButton:Show()
			
			count = count + 1
			
		end
		
	end
	
	local scrollMax = ( scrollHeight - 160 )
	
	if scrollMax < 0 then
		
		scrollMax = 0
		
		if GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:IsVisible() == true then
			GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:Hide()
		end
		
	elseif GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:IsVisible() == false then
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:Show()
	end
	
	GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameChild:SetSize(225, scrollHeight)
	
	if scroll then
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(0)
	end
	
	if scrollMax > 0 then
		
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValueStep(1)
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetObeyStepOnDrag(true)
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetMinMaxValues(0, scrollMax)
		
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetScript("OnValueChanged", function(self)
			GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:SetVerticalScroll(self:GetValue())
		end)
		
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:EnableMouseWheel(true)
		GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrame:SetScript("OnMouseWheel", function(_, delta)
			
			local current = GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:GetValue()
			
			if IsShiftKeyDown() and delta > 0 then
				GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(0)
			elseif IsShiftKeyDown() and delta < 0 then
				GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(scrollMax)
			elseif delta < 0 and current < scrollMax then
				if IsControlKeyDown() then
					GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(current + 60)
				else
					GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(current + 20)
				end
			elseif delta > 0 and current > 1 then
				if IsControlKeyDown() then
					GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(current - 60)
				else
					GLR_UI.GLR_MainFrame.GLR_PlayerNamesScrollFrameSlider:SetValue(current - 20)
				end
			end
			
		end)
		
	end
	
end

---------------------------------------------
----------- UPDATE UNUSED TICKETS -----------
---------------------------------------------
-------- UPDATES UNUSED TICKETS FRAME -------
---------------------------------------------

function GLR:UpdateNumberOfUnusedTickets()
	
	local s = glrCharacter.Data.Settings.General.Status
	local ut = 0
	
	if glrCharacter[s].TicketPool ~= nil then
		ut = #glrCharacter[s].TicketPool
	end
	if ut == 0 then
		GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:Hide()
	else
		local timestamp = GetTimeStamp()
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - UpdateNumberOfUnusedTickets() - " .. s .. " Event Has Unused Tickets: [" .. ut .. "]")
		GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorder:Show()
		GLR_UI.GLR_MainFrame.GLR_NumberOfUnusedTicketsRangeBorderAmount:SetText(ut)
	end
	
end

---------------------------------------------
---------------- GET MONTHS -----------------
---------------------------------------------
------------ RETURNS VALID MONTHS -----------
------------- FOR A NEW EVENTS --------------
---------------------------------------------

function GLR:GetListOfMonths(arg)
	
	local monthList = {
		L["January"],
		L["February"],
		L["March"],
		L["April"],
		L["May"],
		L["June"],
		L["July"],
		L["August"],
		L["September"],
		L["October"],
		L["November"],
		L["December"]
	}
	local monthValue = {
		[L["January"]] = 1,
		[L["February"]] = 2,
		[L["March"]] = 3,
		[L["April"]] = 4,
		[L["May"]] = 5,
		[L["June"]] = 6,
		[L["July"]] = 7,
		[L["August"]] = 8,
		[L["September"]] = 9,
		[L["October"]] = 10,
		[L["November"]] = 11,
		[L["December"]] = 12
	}
	local currentMonth = tonumber(date("%m"))
	local buffer = 3
	local sbuffer = 3.2
	local nameHeight = 0
	local count = 1
	local currentYear = L["20"] .. date("%y")
	local selectedYear
	
	if arg == "Lottery" then
		selectedYear = GLR_Lottery_ListOfYearsSelectionText:GetText()
	else
		selectedYear = GLR_Raffle_ListOfYearsSelectionText:GetText()
	end
	
	if currentYear ~= selectedYear then
		
		currentMonth = 1
		
	end
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons or {}
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons or {}
	
	if arg == "Lottery" then
		for i = 1, #GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons do
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons do
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[i][1]:Hide()
		end
	end
	
	for t, v in pairs(monthList) do
		
		if arg == "Lottery" then
			if not GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "month" .. count, GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("monthText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "month" .. count, GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("monthText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local MonthButtons
		local MonthButtonsText
		
		if arg == "Lottery" then
			MonthButtons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count][1]
			MonthButtonsText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count][2]
		else
			MonthButtons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count][1]
			MonthButtonsText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count][2]
		end
		
		for x, y in pairs(monthValue) do
			
			if v == x and y >= currentMonth then
				
				MonthButtons:SetWidth(120)
				MonthButtons:SetHeight(11)
				MonthButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
				MonthButtonsText:SetText(v)
				MonthButtonsText:SetWidth(120)
				MonthButtonsText:SetWordWrap(false)
				MonthButtonsText:SetPoint("CENTER", MonthButtons)
				MonthButtonsText:SetFont(GLR_Core.ButtonFont, 12)
				
				local sHeight = ( MonthButtons:GetHeight() * 1.1 ) + 2.2
				
				if count == 1 then
					
					if arg == "Lottery" then
						MonthButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu, 0, -4)
					else
						MonthButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu, 0, -4)
					end
					
					nameHeight = nameHeight + sHeight + 3
					
				else
					
					if arg == "Lottery" then
						MonthButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					else
						MonthButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					end
					
					nameHeight = nameHeight + sHeight
					
				end
				
				MonthButtons:SetScript("OnClick", function(self, button)
					
					if button == "LeftButton" then
						
						local formerText
						
						if arg == "Lottery" then
							formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetText(MonthButtonsText:GetText())
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelection:Show()
						else
							formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetText(MonthButtonsText:GetText())
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:Hide()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelection:Show()
						end
						
					end
					
				end)
				
				MonthButtons:Show()
				
				count = count + 1
				
			end
			
		end
		
	end
	
	if arg == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionMenu:SetSize(120, nameHeight)
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:SetSize(120, nameHeight)
	end
	
end

---------------------------------------------
----------------- GET DAYS ------------------
---------------------------------------------
------------- RETURNS VALID DAYS ------------
------------- FOR A NEW EVENTS --------------
---------------------------------------------

function GLR:GetListOfDays(arg)
	
	local dayList = {
		[L["January"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["February"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
		},
		[L["March"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["April"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
		},
		[L["May"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["June"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
		},
		[L["July"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["August"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["September"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
		},
		[L["October"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
		[L["November"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
		},
		[L["December"]] = {
			L["01"], -- [1]
			L["02"], -- [2]
			L["03"], -- [3]
			L["04"], -- [4]
			L["05"], -- [5]
			L["06"], -- [6]
			L["07"], -- [7]
			L["08"], -- [8]
			L["09"], -- [9]
			L["10"], -- [10]
			L["11"], -- [11]
			L["12"], -- [12]
			L["13"], -- [13]
			L["14"], -- [14]
			L["15"], -- [15]
			L["16"], -- [16]
			L["17"], -- [17]
			L["18"], -- [18]
			L["19"], -- [19]
			L["20"], -- [20]
			L["21"], -- [21]
			L["22"], -- [22]
			L["23"], -- [23]
			L["24"], -- [24]
			L["25"], -- [25]
			L["26"], -- [26]
			L["27"], -- [27]
			L["28"], -- [28]
			L["29"], -- [29]
			L["30"], -- [30]
			L["31"], -- [31]
		},
	}
	local numberOfMonth = {
		[1] = L["January"],
		[2] = L["February"],
		[3] = L["March"],
		[4] = L["April"],
		[5] = L["May"],
		[6] = L["June"],
		[7] = L["July"],
		[8] = L["August"],
		[9] = L["September"],
		[10] = L["October"],
		[11] = L["November"],
		[12] = L["December"]
	}
	local buffer = 3
	local sbuffer = 3.2
	local nameHeight = 0
	local currentMonth = tonumber(date("%m"))
	local currentDay = tonumber(date("%d"))
	local currentYear = L["20"] .. date("%y")
	local count = 1
	local useMonth = numberOfMonth[currentMonth]
	local ShowAllDays = false
	local currentSelectedDay
	local selectedMonth
	local selectedYear
	local t = date("*t", GetServerTime())
	local cTime = tonumber(t.hour .. t.min)
	
	if arg == "Lottery" then
		currentSelectedDay = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText())
		selectedMonth = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
		selectedYear = GLR_Lottery_ListOfYearsSelectionText:GetText()
	else
		currentSelectedDay = tonumber(GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText())
		selectedMonth = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
		selectedYear = GLR_Raffle_ListOfYearsSelectionText:GetText()
	end
	
	if (((tonumber(selectedYear) % 4 == 0) and (tonumber(selectedYear) % 100 ~= 0)) or (tonumber(selectedYear) % 400 == 0)) then
		table.insert(dayList[L["February"]], L["29"])
	end
	
	if selectedMonth ~= useMonth or selectedYear ~= currentYear then
		
		useMonth = selectedMonth
		ShowAllDays = true
		
	end
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons or {}
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons or {}
	
	if arg == "Lottery" then
		for i = 1, #GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons do
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons do
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[i][1]:Hide()
		end
	end
	
	if cTime >= 2345 and selectedMonth == useMonth and selectedYear == currentYear and currentSelectedDay == currentDay then
		currentDay = currentDay + 1
		if #dayList[useMonth] < currentDay then
			if currentMonth == 12 then
				currentMonth = 1
				t.year = L[tostring(tonumber(t.year) + 1)]
			else
				currentMonth = currentMonth + 1
			end
			useMonth = numberOfMonth[currentMonth]
			currentDay = 1
		end
		local dayText = currentDay
		if dayText < 10 then
			dayText = L["0" .. tostring(dayText)]
		else dayText = L[tostring(dayText)] end
		if arg == "Lottery" then
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetText(dayText)
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:SetText(numberOfMonth[currentMonth])
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetText(t.year)
		else
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetText(dayText)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:SetText(numberOfMonth[currentMonth])
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetText(t.year)
		end
	end
	
	for t, v in pairs(dayList[useMonth]) do
		
		if arg == "Lottery" then
			if not GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "day" .. count, GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("dayText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "day" .. count, GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("dayText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local n = tonumber(v)		
		local DayButtons
		local DayButtonsText
		
		if arg == "Lottery" then
			DayButtons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count][1]
			DayButtonsText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count][2]
		else
			DayButtons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count][1]
			DayButtonsText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count][2]
		end
		
		if n >= currentDay or ShowAllDays then
			
			DayButtons:SetWidth(70)
			DayButtons:SetHeight(11)
			DayButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
			DayButtonsText:SetText(v)
			DayButtonsText:SetWidth(70)
			DayButtonsText:SetWordWrap(false)
			DayButtonsText:SetPoint("CENTER", DayButtons)
			DayButtonsText:SetFont(GLR_Core.ButtonFont, 12)
			
			local sHeight = ( DayButtons:GetHeight() * 1.1 ) + 2.2
			
			if count == 1 then
				
				if arg == "Lottery" then
					DayButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu, 0, -4)
				else
					DayButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu, 0, -4)
				end
				
				nameHeight = nameHeight + sHeight + 3
				
			else
				
				if arg == "Lottery" then
					DayButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				else
					DayButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				end
				
				nameHeight = nameHeight + sHeight
				
			end
			
			DayButtons:SetScript("OnClick", function(self, button)
				
				if button == "LeftButton" then
					
					local formerText
					if arg == "Lottery" then
						formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText()
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetText(DayButtonsText:GetText())
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:SetFont(GLR_Core.ButtonFont, 12)
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelection:Show()
					else
						formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText()
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetText(DayButtonsText:GetText())
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:SetFont(GLR_Core.ButtonFont, 12)
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:Hide()
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelection:Show()
					end
					
				end
				
			end)
			
			DayButtons:Show()
			
			count = count + 1
			
		end
		
	end
	
	if arg == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionMenu:SetSize(70, nameHeight)
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:SetSize(70, nameHeight)
	end
	
end

---------------------------------------------
----------------- GET YEARS -----------------
---------------------------------------------
------------ RETURNS VALID YEARS ------------
------------- FOR A NEW EVENTS --------------
---------------------------------------------

function GLR:GetListOfYears(arg)
	
	local yearList = {}
	local buffer = 3
	local sbuffer = 3.2
	local nameHeight = 0
	local count = 1
	local n
	if GLR_GameVersion == "RETAIL" then
		n = C_DateAndTime.GetCurrentCalendarTime()
	else
		n = C_DateAndTime.GetTodaysDate()
	end
	
	for i = 1, 2 do --Dynamically builds the list of potential years for new events to occur on, only does the current year + one as Calendar events can only be made up to one year in advance.
		table.insert(yearList, L[tostring(n.year)])
		n.year = n.year + 1
	end
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons or {}
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons or {}
	
	if arg == "Lottery" then
		for i = 1, #GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons do
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons do
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[i][1]:Hide()
		end
	end
	
	for t, v in pairs(yearList) do
		
		if arg == "Lottery" then
			if not GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "year" .. count, GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("yearText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "year" .. count, GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("yearText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local YearButtons
		local YearButtonsText
		
		if arg == "Lottery" then
			YearButtons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count][1]
			YearButtonsText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count][2]
		else
			YearButtons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count][1]
			YearButtonsText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count][2]
		end
		
		YearButtons:SetWidth(100)
		YearButtons:SetHeight(11)
		YearButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
		YearButtonsText:SetText(v)
		YearButtonsText:SetWidth(100)
		YearButtonsText:SetWordWrap(false)
		YearButtonsText:SetPoint("CENTER", YearButtons)
		YearButtonsText:SetFont(GLR_Core.ButtonFont, 12)
		
		local sHeight = ( YearButtons:GetHeight() * 1.1 ) + 2.2
		
		if count == 1 then
			
			if arg == "Lottery" then
				YearButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu, 0, -4)
			else
				YearButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu, 0, -4)
			end
			
			nameHeight = nameHeight + sHeight + 3
			
		else
			
			if arg == "Lottery" then
				YearButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
			else
				YearButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
			end
			
			nameHeight = nameHeight + sHeight
			
		end
		
		YearButtons:SetScript("OnClick", function(self, button)
			
			if button == "LeftButton" then
				
				local formerText
				if arg == "Lottery" then
					formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:GetText()
					GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetText(YearButtonsText:GetText())
					GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:SetFont(GLR_Core.ButtonFont, 12)
					GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
					GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelection:Show()
				else
					formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:GetText()
					GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetText(YearButtonsText:GetText())
					GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:SetFont(GLR_Core.ButtonFont, 12)
					GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:Hide()
					GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelection:Show()
				end
				
			end
			
		end)
		
		YearButtons:Show()
		
		count = count + 1
		
	end
	
	if arg == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionMenu:SetSize(100, nameHeight)
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:SetSize(100, nameHeight)
	end
	
end

---------------------------------------------
---------------- GET HOURS -----------------
---------------------------------------------
------------ RETURNS VALID HOURS ------------
------------- FOR A NEW EVENTS --------------
---------------------------------------------

function GLR:GetListOfHours(arg)
	
	local hourList = {
		L["00"], -- [1]
		L["01"], -- [2]
		L["02"], -- [3]
		L["04"], -- [4]
		L["05"], -- [5]
		L["06"], -- [6]
		L["07"], -- [7]
		L["08"], -- [8]
		L["09"], -- [9]
		L["10"], -- [10]
		L["11"], -- [11]
		L["12"], -- [12]
		L["13"], -- [13]
		L["14"], -- [14]
		L["15"], -- [15]
		L["16"], -- [16]
		L["17"], -- [17]
		L["18"], -- [18]
		L["19"], -- [19]
		L["20"], -- [20]
		L["21"], -- [21]
		L["22"], -- [22]
		L["23"], -- [23]
	}
	local currentHour = tonumber(date("%H"))
	local currentMinute = tonumber(date("%M"))
	local currentDate = date("%m/%d/%y")
	local selectedMonth = GLR:MonthToString(arg)
	local selectedDay
	local selectedYear = GLR:YearToString(arg)
	local useCurrentHour = true
	local buffer = 3
	local sbuffer = 3.2
	local nameHeight = 0
	local count = 1
	
	if arg == "Lottery" then
		selectedDay = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText()
	else
		selectedDay = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText()
	end
	
	local selectedDate = selectedMonth .. "/" .. selectedDay .. "/" .. selectedYear
	
	if currentDate ~= selectedDate then
		
		useCurrentHour = false
		
	end
	
	if currentMinute >= 45 then
		
		currentHour = currentHour + 1
		
	end
	
	local timestamp = GetTimeStamp()
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetListOfHours() - Getting List of Hours: [" .. string.upper(arg) .. "] - Current Date: [" .. currentDate .."] - Selected Date: [" .. selectedDate .. "]")
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons or {}
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons or {}
	
	if arg == "Lottery" then
		for i = 1, #GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons do
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons do
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[i][1]:Hide()
		end
	end
	
	for t, v in pairs(hourList) do
		
		if arg == "Lottery" then
			if not GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "hour" .. count, GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("hourText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "hour" .. count, GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("hourText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local hour = tonumber(v)
		local HourButtons
		local HourButtonsText
		
		if arg == "Lottery" then
			HourButtons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count][1]
			HourButtonsText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count][2]
		else
			HourButtons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count][1]
			HourButtonsText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count][2]
		end
		
		if hour >= currentHour or not useCurrentHour then
			
			HourButtons:SetWidth(70)
			HourButtons:SetHeight(11)
			HourButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
			HourButtonsText:SetText(v)
			HourButtonsText:SetWidth(70)
			HourButtonsText:SetWordWrap(false)
			HourButtonsText:SetPoint("CENTER", HourButtons)
			HourButtonsText:SetFont(GLR_Core.ButtonFont, 12)
			
			local sHeight = ( HourButtons:GetHeight() * 1.1 ) + 2.2
			
			if count == 1 then
				
				if arg == "Lottery" then
					HourButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu, 0, -4)
				else
					HourButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu, 0, -4)
				end
				
				nameHeight = nameHeight + sHeight + 3
				
			else
				
				if arg == "Lottery" then
					HourButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				else
					HourButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				end
				
				nameHeight = nameHeight + sHeight
				
			end
			
			HourButtons:SetScript("OnClick", function(self, button)
				
				if button == "LeftButton" then
					
					local formerText
					if arg == "Lottery" then
						formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:GetText()
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:SetText(HourButtonsText:GetText())
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:SetFont(GLR_Core.ButtonFont, 12)
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
						GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelection:Show()
					else
						formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:GetText()
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:SetText(HourButtonsText:GetText())
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:SetFont(GLR_Core.ButtonFont, 12)
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:Hide()
						GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelection:Show()
					end
					
				end
				
			end)
			
			HourButtons:Show()
			
			count = count + 1
			
		end
		
	end
	
	if arg == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionMenu:SetSize(75, nameHeight)
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionMenu:SetSize(75, nameHeight)
	end
	
	table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - GetListOfHours() - Retrieved List of Hours")
	
end

---------------------------------------------
---------------- GET MINUTES ----------------
---------------------------------------------
----------- RETURNS VALID MINUTES -----------
------------- FOR A NEW EVENTS --------------
---------------------------------------------

function GLR:DebugMenu(state)
	
	if state == nil then state = 1 end
	
	if state == 1 then
		
		if GLR_UI.GLR_NewLotteryEventFrame:IsVisible() then
			GLR_UI.GLR_NewLotteryEventFrame:Hide()
		end
		
		GLR_UI.GLR_NewLotteryEventFrame:Show()
		GLR_UI.GLR_NewLotteryEventFrame:Hide()
		GLR_UI.GLR_NewLotteryEventFrame:Show()
		
	elseif state == 2 then
		
		if GLR_UI.GLR_NewRaffleEventFrame:IsVisible() then
			GLR_UI.GLR_NewRaffleEventFrame:Hide()
		end
		
		GLR_UI.GLR_NewRaffleEventFrame:Show()
		GLR_UI.GLR_NewRaffleEventFrame:Hide()
		GLR_UI.GLR_NewRaffleEventFrame:Show()
		
	end
	
end

function GLR:GetListOfMinutes(arg)
	
	local minuteList = {
		L["00"], -- [1]
		L["15"], -- [2]
		L["30"], -- [3]
		L["45"], -- [4]
	}
	local currentMinute = tonumber(date("%M"))
	local currentHour = date("%H")
	local currentDate = date("%m/%d/%y")
	local selectedMonth = GLR:MonthToString(arg)
	local selectedYear = GLR:YearToString(arg)
	local selectedDay
	local selectedHour
	local useCurrentMinute = true
	local buffer = 3
	local nameHeight = 0
	local count = 1
	
	if arg == "Lottery" then
		selectedDay = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfDaysSelectionText:GetText()
		selectedHour = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfHoursSelectionText:GetText()
	else
		selectedDay = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionText:GetText()
		selectedHour = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfHoursSelectionText:GetText()
	end
	
	local selectedDate = selectedMonth .. "/" .. selectedDay .. "/" .. selectedYear
	
	if selectedDate ~= currentDate or selectedHour ~= currentHour then
		
		useCurrentMinute = false
		
	end
	
	GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons or {}
	GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons or {}
	
	if arg == "Lottery" then
		for i = 1, #GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons do
			GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons do
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[i][1]:Hide()
		end
	end
	
	for t, v in pairs(minuteList) do
		
		if arg == "Lottery" then
			if not GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "minute" .. count, GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu)
				GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("minuteText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[t] then
				local tempButton = CreateFrame("Button", "minute" .. count, GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu)
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("minuteText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local MinuteButtons
		local MinuteButtonsText
		local minute = tonumber(v)
		
		if arg == "Lottery" then
			MinuteButtons = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count][1]
			MinuteButtonsText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count][2]
		else
			MinuteButtons = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count][1]
			MinuteButtonsText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count][2]
		end
		
		if minute < 15 then
			minute = 0
		end
		
		if minute >= currentMinute or not useCurrentMinute then
			
			if currentMinute >= 45 or not useCurrentMinute then
				
				if minute == 0 then
					v = L["00"]
				end
				
				MinuteButtons:SetWidth(70)
				MinuteButtons:SetHeight(11)
				MinuteButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
				MinuteButtonsText:SetText(v)
				MinuteButtonsText:SetWidth(70)
				MinuteButtonsText:SetWordWrap(false)
				MinuteButtonsText:SetPoint("CENTER", MinuteButtons)
				MinuteButtonsText:SetFont(GLR_Core.ButtonFont, 12)
				
				local sHeight = ( MinuteButtons:GetHeight() * 1.1 ) + 2.2
				
				if count == 1 then
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					end
					
					nameHeight = nameHeight + sHeight + 3
					
				else
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					end
					
					nameHeight = nameHeight + sHeight
					
				end
				
				MinuteButtons:SetScript("OnClick", function(self, button)
					
					if button == "LeftButton" then
						
						local formerText
						if arg == "Lottery" then
							formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:Show()
						else
							formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:Show()
						end
						
					end
					
				end)
				
				MinuteButtons:Show()
				
				count = count + 1
				
			elseif minute >= currentMinute and useCurrentMinute then
				
				MinuteButtons:SetWidth(70)
				MinuteButtons:SetHeight(11)
				MinuteButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
				MinuteButtonsText:SetText(v)
				MinuteButtonsText:SetWidth(70)
				MinuteButtonsText:SetWordWrap(false)
				MinuteButtonsText:SetPoint("CENTER", MinuteButtons)
				MinuteButtonsText:SetFont(GLR_Core.ButtonFont, 12)
				
				local sHeight = ( MinuteButtons:GetHeight() * 1.1 ) + 2.2
				
				if count == 1 then
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					end
					
					nameHeight = nameHeight + sHeight + 3
					
				else
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					end
					
					nameHeight = nameHeight + sHeight
					
				end
				
				MinuteButtons:SetScript("OnClick", function(self, button)
					
					if button == "LeftButton" then
						
						local formerText
						if arg == "Lottery" then
							formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:Show()
						else
							formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:Show()
						end
						
					end
					
				end)
				
				MinuteButtons:Show()
				
				count = count + 1
				
			elseif currentMinute >= 45 and useCurrentMinute then
				
				if selectedHour == currentHour then
					break
				end
				
				MinuteButtons:SetWidth(70)
				MinuteButtons:SetHeight(11)
				MinuteButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
				MinuteButtonsText:SetText("45")
				MinuteButtonsText:SetWidth(70)
				MinuteButtonsText:SetWordWrap(false)
				MinuteButtonsText:SetPoint("CENTER", MinuteButtons)
				MinuteButtonsText:SetFont(GLR_Core.ButtonFont, 12)
				
				local sHeight = ( MinuteButtons:GetHeight() * 1.1 ) + 2.2
				
				if count == 1 then
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu, 0, -4)
					end
					
					nameHeight = nameHeight + sHeight + 3
					
				else
					
					if arg == "Lottery" then
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					else
						MinuteButtons:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
					end
					
					nameHeight = nameHeight + sHeight
					
				end
				
				MinuteButtons:SetScript("OnClick", function(self, button)
					
					if button == "LeftButton" then
						
						local formerText
						if arg == "Lottery" then
							formerText = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelection:Show()
						else
							formerText = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:GetText()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetText(MinuteButtonsText:GetText())
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionText:SetFont(GLR_Core.ButtonFont, 12)
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:Hide()
							GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelection:Show()
						end
						
					end
					
				end)
				
				MinuteButtons:Show()
				
				count = count + 1
				
			end
			
		end
		
	end
	
	if arg == "Lottery" then
		GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMinutesSelectionMenu:SetSize(75, nameHeight)
	else
		GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:SetSize(75, nameHeight)
	end
	
end

function GLR:GetListOfPlayersToEdit(EventType)
	
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if glrRosterTotal == 0 and guildName ~= nil then
		if not status then --Determines whether to search just your guild (if not a Multi-Guild Event) for player names to Edit, or the Multi-Guild Roster (if Multi-Guild Event).
			GLR_U:UpdateRosterTable()
		else
			GLR_U:PopulateMultiGuildTable()
		end
	end
	local nameList = GLR:GetListOfEntries()
	local state = EventType
	local buffer = 3
	local sbuffer = 3.2
	local nameHeight = 0
	local count = 1
	local width = 240
	local height = 160
	local scrollHeight = 0
	local classTable = {}
	local classCheck = false
	
	if not status then
		classTable = glrRoster
	else
		classTable = glrMultiGuildRoster
	end
	
	if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons == nil then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons or {}
	end
	if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons == nil then
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons or {}
	end
	
	if state == "Lottery" then
		for i = 1, #GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons do
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[i][1]:Hide()
		end
	else
		for i = 1, #GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons do
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[i][1]:Hide()
		end
	end
	
	if GetLocale() == "frFR" then classCheck = true end
	
	for t, v in pairs(nameList) do
		
		if state == "Lottery" then
			if not GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[t] then
				local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild)
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		else
			if not GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[t] then
				local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild)
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
			end
		end
		
		local NameButtons
		local NameButtonsText
		
		if state == "Lottery" then
			NameButtons = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[count][1]
			NameButtonsText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[count][2]
		else
			NameButtons = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[count][1]
			NameButtonsText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[count][2]
		end
		
		NameButtons:SetHeight(11)
		NameButtons:SetWidth(125)
		NameButtons:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
		NameButtonsText:SetText(v)
		NameButtonsText:SetWordWrap(false)
		NameButtonsText:SetPoint("CENTER", NameButtons)
		NameButtonsText:SetFont(GLR_Core.ButtonFont, 12)
		
		local sWidth = NameButtonsText:GetWidth()
		local sHeight = ( NameButtons:GetHeight() * 1.1 ) + 1.9
		
		NameButtonsText:SetWidth(sWidth)
		NameButtons:SetWidth(sWidth)
		
		for i = 1, #classTable do
			
			local text = classTable[i]
			local subText = string.sub(text, 1, string.find(text, '%[') - 1)
			local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
			
			if v == L["GLR - Error - No Entries Found"] then
				NameButtonsText:SetTextColor(1, 1, 1, 1)
				break
			end
			
			if subText == v then
				if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
					CN = "NA"
				end
				NameButtonsText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
				break
			end
			
		end
		
		if count == 1 then
			
			if state == "Lottery" then
				NameButtons:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild, "TOP", 0, -2)
			else
				NameButtons:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild, "TOP", 0, -2)
			end
			
			nameHeight = nameHeight + sHeight + 2
			
		else
			
			if state == "Lottery" then
				NameButtons:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
			else
				NameButtons:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
			end
			
			nameHeight = nameHeight + sHeight
			
		end
		
		NameButtons:SetScript("OnClick", function(self, button)
			
			if button == "LeftButton" then
				
				local formerText
				if state == "Lottery" then
					formerText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText()
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetText(NameButtonsText:GetText())
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetWidth(115)
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetWordWrap(false)
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetFont(GLR_Core.ButtonFont, 12)
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:Hide()
					for i = 1, #classTable do
						
						local isClassFound = false
						local text = classTable[i]
						local subText = string.sub(text, 1, string.find(text, '%[') - 1)
						local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
						if subText == GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText() then
							if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
								CN = "NA"
							end
							GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
							GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
							isClassFound = true
						end
						
						if isClassFound then
							break
						end
					end
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelection:Show()
				else
					formerText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText()
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetText(NameButtonsText:GetText())
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetWidth(115)
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetWordWrap(false)
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetFont(GLR_Core.ButtonFont, 12)
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:Hide()
					for i = 1, #classTable do
						
						local isClassFound = false
						local text = classTable[i]
						local subText = string.sub(text, 1, string.find(text, '%[') - 1)
						local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
						if subText == GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText() then
							if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
								CN = "NA"
							end
							GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
							GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
							isClassFound = true
						end
						
						if isClassFound then
							break
						end
					end
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelection:Show()
				end
				
			end
			
		end)
		
		if nameHeight <= 150 and scrollHeight <= 149 then
			scrollHeight = 150
		elseif nameHeight > 150 then
			scrollHeight = nameHeight
		end
		
		if (sWidth + 40) >= width and (sWidth + 40) >= 240 then
			width = sWidth + 100
		end
		
		NameButtons:Show()
		NameButtons:Hide()
		NameButtons:Show()
		
		count = count + 1
		
	end
	
	local scrollMax = ( scrollHeight - 150 )
	
	if scrollMax <= 0 then
		
		scrollMax = 0
		
		if state == "Lottery" then
			if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:IsVisible() == true then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Hide()
			end
		else
			if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:IsVisible() == true then
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Hide()
			end
		end
		
	elseif state == "Lottery" then
		if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:IsVisible() == false then
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:Show()
		end
	elseif state == "Raffle" then
		if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:IsVisible() == false then
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:Show()
		end
	end
	
	if state == "Lottery" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu:SetSize(width, 160)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameChild:SetSize(width, 160)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetSize(width, 150)
		
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(0)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetMinMaxValues(0, scrollMax)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetScript("OnValueChanged", function(self)
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetVerticalScroll(self:GetValue())
		end)
		
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:EnableMouseWheel(true)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameScrollFrame:SetScript("OnMouseWheel", function(_, delta)
			
			local current = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:GetValue()
			
			if IsShiftKeyDown() and delta > 0 then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(0)
			elseif IsShiftKeyDown() and delta < 0 then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(scrollMax)
			elseif delta < 0 and current < scrollMax then
				if IsControlKeyDown() then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(current + 60)
				else
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(current + 20)
				end
			elseif delta > 0 and current > 1 then
				if IsControlKeyDown() then
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(current - 60)
				else
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionMenu.GLR_EditLotteryNameFrameSlider:SetValue(current - 20)
				end
			end
			
		end)
		
	else
		
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu:SetSize(width, 160)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameChild:SetSize(width, 160)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetSize(width, 150)
		
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(0)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetMinMaxValues(0, scrollMax)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetScript("OnValueChanged", function(self)
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetVerticalScroll(self:GetValue())
		end)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:EnableMouseWheel(true)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameScrollFrame:SetScript("OnMouseWheel", function(_, delta)
			
			local current = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:GetValue()
			
			if IsShiftKeyDown() and delta > 0 then
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(0)
			elseif IsShiftKeyDown() and delta < 0 then
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(scrollMax)
			elseif delta < 0 and current < scrollMax then
				if IsControlKeyDown() then
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(current + 60)
				else
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(current + 20)
				end
			elseif delta > 0 and current > 1 then
				if IsControlKeyDown() then
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(current - 60)
				else
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionMenu.GLR_EditRaffleNameFrameSlider:SetValue(current - 20)
				end
			end
			
		end)
		
	end
	
end

function GLR:SetPlayerToEditInEvent(EventType)
	
	local state = EventType
	local ticket = 0
	local name
	
	if state == "Lottery" then
		name = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectPlayerSelectionText:GetText()
	else
		name = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectPlayerSelectionText:GetText()
	end
	
	if name ~= L["GLR - Error - No Entries Found"] then
		ticket = glrCharacter[state].Entries.Tickets[name]["NumberOfTickets"]
	end
	
	local tickets = tostring(ticket)
	
	if state == "Lottery" then
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetText(name)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetCursorPosition(0)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetText(tickets)
		GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerTicketsEditBox:SetCursorPosition(0)
	else
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetText(name)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetCursorPosition(0)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetText(tickets)
		GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTicketsEditBox:SetCursorPosition(0)
	end
	
end

function GLR:GetListOfEntries()
	
	local ListOfEntries = {}
	local s = Variables[10]
	local count = 0
	
	if glrCharacter ~= nil then
		if glrCharacter[s] ~= nil then
			if glrCharacter[s].Entries ~= nil then
				for i = 1, #glrCharacter[s].Entries.Names do
					table.insert(ListOfEntries, glrCharacter[s].Entries.Names[i])
					count = count + 1
				end
			end
		end
	end
	
	if count == 0 then
		table.insert(ListOfEntries, L["GLR - Error - No Entries Found"])
	end
	
	sort(ListOfEntries)
	return ListOfEntries
	
end

function GLR:MonthToString(arg)
	
	local selectedMonth
	if arg == "Lottery" then
		selectedMonth = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	else
		selectedMonth = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	end
	local monthValue = {
		["January"] = "01",
		["February"] = "02",
		["March"] = "03",
		["April"] = "04",
		["May"] = "05",
		["June"] = "06",
		["July"] = "07",
		["August"] = "08",
		["September"] = "09",
		["October"] = "10",
		["November"] = "11",
		["December"] = "12"
	}
	
	return monthValue[selectedMonth]
	
end

function GLR:YearToString(arg)
	
	local selectedYear
	if arg == "Lottery" then
		selectedYear = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfYearsSelectionText:GetText()
	else
		selectedYear = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionText:GetText()
	end
	local yearValue = {}
	local n
	if GLR_GameVersion == "RETAIL" then
		n = C_DateAndTime.GetCurrentCalendarTime()
	else
		n = C_DateAndTime.GetTodaysDate()
	end
	for i = 1, 2 do --Dynamically builds the list of potential years for new events to occur on, only does the current year + one as Calendar events can only be made up to one year in advance.
		local s = string.sub(tostring(n.year), 3, 4)
		yearValue[L[tostring(n.year)]] = L[s]
		n.year = n.year + 1
	end
	
	return yearValue[selectedYear]
	
end

function GLR:GetCurrentMonth()
	
	local monthList = {
		L["January"],
		L["February"],
		L["March"],
		L["April"],
		L["May"],
		L["June"],
		L["July"],
		L["August"],
		L["September"],
		L["October"],
		L["November"],
		L["December"]
	}
	local monthValue = {
		[L["January"]] = 1,
		[L["February"]] = 2,
		[L["March"]] = 3,
		[L["April"]] = 4,
		[L["May"]] = 5,
		[L["June"]] = 6,
		[L["July"]] = 7,
		[L["August"]] = 8,
		[L["September"]] = 9,
		[L["October"]] = 10,
		[L["November"]] = 11,
		[L["December"]] = 12
	}
	local month = "Month"
	local currentMonth = tonumber(date("%m"))
	
	for t, v in pairs(monthList) do
		for x, y in pairs(monthValue) do
			if v == x and y == currentMonth then
				month = v
				return month
			end
		end
	end
	
end

function GLR:GetCurrentDay()
	
	local Day = date("%d")
	local monthDays = {
		[L["January"]] = 31,
		[L["February"]] = 28,
		[L["March"]] = 31,
		[L["April"]] = 30,
		[L["May"]] = 31,
		[L["June"]] = 30,
		[L["July"]] = 31,
		[L["August"]] = 31,
		[L["September"]] = 30,
		[L["October"]] = 31,
		[L["November"]] = 30,
		[L["December"]] = 31
	}
	--[[
	local currentHour = tonumber(date("%H"))
	local currentMinute = tonumber(date("%M"))
	local state = ""
	local SelectedMonth = ""
	local Lottery = GLR_UI.GLR_NewLotteryEventFrame:IsVisible()
	local Raffle = GLR_UI.GLR_NewRaffleEventFrame:IsVisible()
	local Month = GLR:GetCurrentMonth()
	
	
	if Lottery then
		state = "Lottery"
		SelectedMonth = GLR_UI.GLR_NewLotteryEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	elseif Raffle then
		state = "Raffle"
		SelectedMonth = GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionText:GetText()
	else
		state = "None"
		SelectedMonth = GLR:GetCurrentMonth()
	end
	
	
	
	Will have to spend some time working on this logic as it will also require checking current month for valid number of days
	if currentHour > 23 then
		if currentMinute >= 45 then
			
		else
			return currentDay
		end
	else
		return currentDay
	end
	--]]
	
	return Day
	
end

function GLR:GetCurrentYear()
	
	local currentYear = L["20"] .. date("%y")
	return currentYear
	
end

function GLR:GetCurrentHour()
	
	local currentHour = tonumber(date("%H"))
	local currentMinute = tonumber(date("%M"))
	
	if currentMinute < 45 then
		if currentHour < 10 then
			currentHour = L["0"] .. L[tostring(currentHour)]
			return L[currentHour]
		else
			return L[tostring(currentHour)]
		end
	else
		if currentHour < 10 then
			currentHour = currentHour + 1
			if currentHour < 10 then
				currentHour = L["0"] .. L[tostring(currentHour)]
				return L[currentHour]
			else
				currentHour = L[tostring(currentHour)]
				return L[currentHour]
			end
		else
			if currentHour == 23 then
				return L["00"]
			else
				currentHour = currentHour + 1
				return L[tostring(currentHour)]
			end
		end
	end
	
end

function GLR:GetCurrentMinute()
	
	local currentMinute = tonumber(date("%M"))
	local minuteList = {
		15, -- [1]
		30, -- [2]
		45, -- [3]
	}
	
	for i = 1, #minuteList do
		if currentMinute <= minuteList[i] then
			return L[tostring(minuteList[i])]
		elseif currentMinute >= 45 then
			return L["00"]
		end
	end
	
end

function GLR:GeneratePlayersAndTicketTotalsTable()
	
	local playerNameTable = {}
	local s = Variables[10]
	
	if s == "Lottery" then
		if glrCharacter ~= nil then
			if glrCharacter[s] ~= nil then
				if glrCharacter[s].Entries ~= nil then
					if glrCharacter[s].Entries.Names ~= nil then
						local c = 0
						for i = 1, #glrCharacter[s].Entries.Names do
							table.insert(playerNameTable, glrCharacter[s].Entries.Names[i])
							c = c + 1
						end
						if c == 0 then
							if glrCharacter.Data.Settings.Lottery.CarryOver then
								if glrCharacter.Data.RollOver.Lottery.Names ~= nil then
									for i = 1, #glrCharacter.Data.RollOver.Lottery.Names do
										table.insert(playerNameTable, glrCharacter.Data.RollOver.Lottery.Names[i])
									end
								end
							end
						end
						sort(playerNameTable)
						return playerNameTable
					else
						return playerNameTable
					end
				else
					return playerNameTable
				end
			else
				return playerNameTable
			end
		else
			return playerNameTable
		end
	else
		if glrCharacter ~= nil then
			if glrCharacter[s] ~= nil then
				if glrCharacter[s].Entries ~= nil then
					if glrCharacter[s].Entries.Names ~= nil then
						for i = 1, #glrCharacter[s].Entries.Names do
							table.insert(playerNameTable, glrCharacter[s].Entries.Names[i])
						end
						sort(playerNameTable)
						return playerNameTable
					else
						return playerNameTable
					end
				else
					return playerNameTable
				end
			else
				return playerNameTable
			end
		else
			return playerNameTable
		end
	end
	
end

function GLR:CHAT_MSG_GUILD(event, msg, sender)
	
	if not glrCharacter.Data.Settings.General.enabled or not Variables[9] or not Variables[8] or event ~= "CHAT_MSG_GUILD" then return end
	
	local doCheck = false
	local text = ""
	local test = ""
	local CommandDetected = false
	local DoCommand = ""
	local Command = ""
	local SubText = ""
	local timestamp = GetTimeStamp()
	
	if msg ~= nil and sender ~= nil then
		text = string.lower(msg)
		SubText = text
		if string.find(text, " ") then
			text = string.sub(text, 1, string.find(text, " ") - 1)
		end
	else
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_GUILD() - Detected NIL Value. Sender: [" .. tostring(sender) .. "] - Message: [" .. tostring(msg) .. "]" )
		GLR:Print("Sender or Message was nil, please report this to the AddOn Author")
		return
	end
	
	if text ~= nil then
		
		local DoContinue = true
		
		if string.find(text, "%!") then
			CommandDetected = true
			DoCommand = "!"
		elseif string.find(text, "%?") then
			CommandDetected = true
			DoCommand = "?"
		end
		
		if CommandDetected then
			text = string.sub(text, 2)
		end
		
		for i = 1, #glrHistory.Settings.Lottery.Commands do
			if text == glrHistory.Settings.Lottery.Commands[i] or text == "lottery" then
				DoContinue = false
				Command = "Lottery"
				break
			end
		end
		if DoContinue then
			for i = 1, #glrHistory.Settings.Raffle.Commands do
				if text == glrHistory.Settings.Raffle.Commands[i] or text == "raffle" then
					DoContinue = false
					Command = "Raffle"
					break
				end
			end
		end
	elseif text == nil then return end
	
	if text ~= nil then
		if DoCommand == "!" and Command == "Lottery" then
			text = L["Detect Lottery"]
		elseif DoCommand == "!" and Command == "Raffle" then
			text = L["Detect Raffle"]
		elseif DoCommand == "?" and Command == "Lottery" then
			text = L["Detect Other Lottery"]
		elseif DoCommand == "?" and Command == "Raffle" then
			text = L["Detect Other Raffle"]
		end
	elseif text == nil then return end
	
	
	if event == "CHAT_MSG_GUILD" then
		if sender == nil then
			GLR:Print("Sender was nil, please report this to the AddOn Author")
			return
		elseif msg == nil then
			return
		else
			--text = string.lower(msg)
			if text ~= nil then
				if text == L["Detect Other Lottery"] or text == L["Detect Other Raffle"] then
					doCheck = true
					if text == L["Detect Other Lottery"] then
						test = "Lottery"
					else
						test = "Raffle"
					end
				elseif text == L["Detect Lottery"] then
					doCheck = true
					text = L["Detect Lottery"]
					test = "Lottery"
				elseif text == L["Detect Raffle"] then
					doCheck = true
					text = L["Detect Raffle"]
					test = "Raffle"
				end
			else return end
		end
	end
	
	if doCheck then
		
		local continue = false
		local check = false
		
		--Multiple people (including the user) have this AddOn installed so we need to check if they have an Active Event.
		--Can't do a simple boolean check of the glrCharacter.Data.Settings.CurrentlyActiveLottery/Raffle because if multiple
		--People have the AddOn but no one has an event active we still need to send the message telling the player such.
		if GLR_AddOnMessageTable.HasMod[2] ~= nil then
			check = true
		else continue = true end
		
		if check then
			local count = #GLR_AddOnMessageTable.ActiveEvents[test]
			for i = 1, #GLR_AddOnMessageTable.ActiveEvents[test] do
				if GLR_AddOnMessageTable.ActiveEvents[test][i] == FullPlayerName then
					continue = true
					break
				end
			end
			if count == nil then continue = true elseif count == 0 then continue = true end
		end
		
		if continue then
			
			if text == L["Detect Other Lottery"] or text == L["Detect Other Raffle"] then
				local target
				local state
				if text == L["Detect Other Lottery"] then
					if string.find(SubText, " ") then	
						target = string.sub(msg, string.find(msg, " ") + 1)
					elseif SubText == L["Detect Other Lottery"] then
						target = ""
					end
					state = "Lottery"
				elseif text == L["Detect Other Raffle"] then
					if string.find(SubText, " ") then	
						target = string.sub(msg, string.find(msg, " ") + 1)
					elseif SubText == L["Detect Other Raffle"] then
						target = ""
					end
					state = "Raffle"
				end
				if target ~= nil then
					Variables[9] = false
					table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_GUILD() - Detected ? Command. Sending REQUESTED Info to: SENDER: [" .. sender .. "] - TARGET: [" .. target .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
					SendRequestedInfo(sender, target, state)
				end
			end
			
			if event == "CHAT_MSG_GUILD" and text == L["Detect Lottery"] then
				
				local user = sender
				local targetRealm
				local bypass = false
				local state = "Lottery"
				
				if string.find(string.lower(sender), "-") ~= nil then
					targetRealm = string.sub(sender, string.find(sender, "-") + 1)
				else
					bypass = true
				end
				
				if PlayerRealmName == targetRealm and not bypass then
					user = string.sub(sender, 1, string.find(sender, "-") - 1)
				end
				
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_GUILD() - Detected ! Command. Sending TICKET Info - SENDER: [" .. user .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
				GLR:SendPlayerTicketInfo(state, user)
				
			end
			
			if event == "CHAT_MSG_GUILD" and text == L["Detect Raffle"] then
				
				local user = sender
				local targetRealm
				local bypass = false
				local state = "Raffle"
				
				if string.find(string.lower(sender), "-") ~= nil then
					targetRealm = string.sub(sender, string.find(sender, "-") + 1)
				else
					bypass = true
				end
				
				if PlayerRealmName == targetRealm and not bypass then
					user = string.sub(sender, 1, string.find(sender, "-") - 1)
				end
				
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_GUILD() - Detected ! Command. Sending TICKET Info to: SENDER: [" .. user .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
				GLR:SendPlayerTicketInfo(state, user)
				
			end
			
		end
		
	end
	
end

function GLR:CHAT_MSG_WHISPER(event, msg, sender)
	
	if not glrCharacter.Data.Settings.General.enabled or not Variables[9] or not Variables[8] then return end
	
	local guildName, _, _, _ = GetGuildInfo("PLAYER")
	
	if guildName == nil then return end
	
	local text = ""
	local CommandDetected = false
	local DoCommand = ""
	local Command = ""
	local SubText = ""
	local timestamp = GetTimeStamp()
	
	if msg ~= nil and sender ~= nil then
		text = string.lower(msg)
		SubText = text
		if string.find(text, " ") then
			text = string.sub(text, 1, string.find(text, " ") - 1)
		end
	else
		table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_WHISPER() - Detected NIL Value. Sender: [" .. tostring(sender) .. "] - Message: [" .. tostring(msg) .. "]" )
		GLR:Print("Sender or Message was nil, please report this to the AddOn Author")
		return
	end
	
	if text ~= nil then
		
		local DoContinue = true
		
		if string.find(text, "%!") then
			CommandDetected = true
			DoCommand = "!"
		elseif string.find(text, "%?") then
			CommandDetected = true
			DoCommand = "?"
		end
		
		if CommandDetected then
			text = string.sub(text, 2)
		end
		
		for i = 1, #glrHistory.Settings.Lottery.Commands do
			if text == glrHistory.Settings.Lottery.Commands[i] or string.lower(text) == "lottery" then
				DoContinue = false
				Command = "Lottery"
				break
			end
		end
		if DoContinue then
			for i = 1, #glrHistory.Settings.Raffle.Commands do
				if text == glrHistory.Settings.Raffle.Commands[i] or string.lower(text) == "raffle" then
					DoContinue = false
					Command = "Raffle"
					break
				end
			end
		end
	elseif text == nil then return end
	
	if text ~= nil then
		if DoCommand == "!" and Command == "Lottery" then
			text = L["Detect Lottery"]
		elseif DoCommand == "!" and Command == "Raffle" then
			text = L["Detect Raffle"]
		elseif DoCommand == "?" and Command == "Lottery" then
			text = L["Detect Other Lottery"]
		elseif DoCommand == "?" and Command == "Raffle" then
			text = L["Detect Other Raffle"]
		end
	elseif text == nil then return end
	
	-- if text ~= nil then
		-- if string.find(text, L["Detect Lottery"]) or text == string.lower(L["Lottery"]) then
			-- text = L["Detect Lottery"]
		-- elseif string.find(text, L["Detect Raffle"]) or text == string.lower(L["Raffle"]) then
			-- text = L["Detect Raffle"]
		-- end
	-- elseif text == nil then return end
	
	local status = glrCharacter.Data.Settings.General.MultiGuild
	
	if glrRosterTotal == 0 and guildName ~= nil then
		if not status then
			GLR_U:UpdateRosterTable()
		else
			GLR_U:PopulateMultiGuildTable()
		end
	end
	
	if event == "CHAT_MSG_WHISPER" and Variables[9] then
		if DoCommand == "?" then
			local target
			local state
			if text == L["Detect Other Lottery"] then
				if string.find(SubText, " ") then
					target = string.sub(msg, string.find(msg, " ") + 1)
				else
					target = ""
				end
				state = "Lottery"
			elseif text == L["Detect Other Raffle"] then
				if string.find(SubText, " ") then
					target = string.sub(msg, string.find(msg, " ") + 1)
				else
					target = ""
				end
				state = "Raffle"
			end
			if target ~= nil then
				Variables[9] = false
				table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_WHISPER() - Detected ? Command. Sending REQUESTED Info to: SENDER: [" .. sender .. "] - TARGET: [" .. target .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
				SendRequestedInfo(sender, target, state)
			end
		end
	end
	
	-- if event == "CHAT_MSG_WHISPER" and Variables[9] then
		-- if sender == nil then
			-- GLR:Print("Sender was nil, please report this to the AddOn Author")
			-- return
		-- end
		-- if string.find(text, L["Detect Other Lottery"]) or string.find(text, L["Detect Other Raffle"]) then
			-- local target
			-- local state
			-- if string.find(text, L["Detect Other Lottery"]) then
				-- if string.find(text, " ") then	
					-- target = string.sub(msg, string.find(msg, " ") + 1)
				-- elseif text == L["Detect Other Lottery"] then
					-- target = ""
				-- end
				-- state = "Lottery"
			-- elseif string.find(text, L["Detect Other Raffle"]) then
				-- if string.find(text, " ") then	
					-- target = string.sub(msg, string.find(msg, " ") + 1)
				-- elseif text == L["Detect Other Raffle"] then
					-- target = ""
				-- end
				-- state = "Raffle"
			-- end
			-- if target ~= nil then
				-- Variables[9] = false
				-- SendRequestedInfo(sender, target, state)
			-- end
		-- end
	-- end
	
	local continue = false
	
	if event == "CHAT_MSG_WHISPER" and text == L["Detect Lottery"] and guildName ~= nil and Variables[8] then
		
		local user = sender
		local targetRealm
		local bypass = false
		local state = "Lottery"
		local TestTargetName = ""
		if not string.find(user, "-") then
			TestTargetName = strjoin("-", user, PlayerRealmName)
		end
		
		if not status then
			for i = 1, #glrRoster do
				local TestTarget = string.sub(glrRoster[i], 1, string.find(glrRoster[i], '%[') - 1)
				if TestTargetName ~= "" then
					if TestTargetName == TestTarget then
						continue = true
						break
					end
				else
					if user == TestTarget then
						continue = true
						break
					end
				end
			end
		else
			for i = 1, #glrMultiGuildRoster do
				local TestTarget = string.sub(glrMultiGuildRoster[i], 1, string.find(glrMultiGuildRoster[i], '%[') - 1)
				if TestTargetName ~= "" then
					if TestTargetName == TestTarget then
						continue = true
						break
					end
				else
					if user == TestTarget then
						continue = true
						break
					end
				end
			end
		end
		
		if string.find(string.lower(sender), "-") ~= nil then
			targetRealm = string.sub(sender, string.find(sender, "-") + 1)
		else
			bypass = true
		end
		
		if PlayerRealmName == targetRealm and not bypass then
			user = string.sub(sender, 1, string.find(sender, "-") - 1)
		end
		
		if continue then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_WHISPER() - Detected ! Command. Sending TICKET Info to: SENDER: [" .. user .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
			GLR:SendPlayerTicketInfo(state, user)
		end
		
	end
	
	if event == "CHAT_MSG_WHISPER" and text == L["Detect Raffle"] and guildName ~= nil and Variables[8] then
		
		local user = sender
		local targetRealm
		local bypass = false
		local state = "Raffle"
		
		if not status then
			for i = 1, #glrRoster do
				local TestTargetName = ""
				local TestTarget = string.sub(glrRoster[i], 1, string.find(glrRoster[i], '%[') - 1)
				if not string.find(user, "-") then
					TestTargetName = strjoin("-", user, PlayerRealmName)
				end
				if TestTargetName ~= "" then
					if TestTargetName == TestTarget then
						continue = true
						break
					end
				else
					if user == TestTarget then
						continue = true
						break
					end
				end
			end
		else
			for i = 1, #glrMultiGuildRoster do
				local TestTargetName = ""
				local TestTarget = string.sub(glrMultiGuildRoster[i], 1, string.find(glrMultiGuildRoster[i], '%[') - 1)
				if not string.find(user, "-") then
					TestTargetName = strjoin("-", user, PlayerRealmName)
				end
				if TestTargetName ~= "" then
					if TestTargetName == TestTarget then
						continue = true
						break
					end
				else
					if user == TestTarget then
						continue = true
						break
					end
				end
			end
		end
		
		if string.find(string.lower(sender), "-") ~= nil then
			targetRealm = string.sub(sender, string.find(sender, "-") + 1)
		else
			bypass = true
		end
		
		if PlayerRealmName == targetRealm and not bypass then
			user = string.sub(sender, 1, string.find(sender, "-") - 1)
		end
		
		if continue then
			table.insert(GLR_AddOnMessageTable_Debug.Messages, timestamp .. " - " .. GLR_GameVersion .. " - CHAT_MSG_WHISPER() - Detected ! Command. Sending TICKET Info to: SENDER: [" .. user .. "] - STATE: [" .. state .. "] - COMMAND: [" .. msg .. "]" )
			GLR:SendPlayerTicketInfo(state, user)
		end
		
	end
	
end

local function UpdateWhisperVariables(state)
	
	Variables[17][2]["%%version"] = GLR_CurrentVersionString
	Variables[17][2]["%%reply_default"] = L["Detect " .. state]
	Variables[17][2]["%%mail_default"] = string.lower(L[state])
	
	local function PharseVariable(var)
		if glrCharacter.Event[state] ~= nil then
			if state == "Lottery" then
				if var == "%%jackpot_total" then
					Variables[17][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_guild" then
					Variables[17][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].GuildCut)/100), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_first" then
					Variables[17][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) - (tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].GuildCut)/100), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%jackpot_second" then
					if glrCharacter.Event[state].SecondPlace ~= L["Winner Guaranteed"] then
						Variables[17][2][var] = GLR_U:GetMoneyValue((tonumber(glrCharacter.Event[state].TicketPrice) * glrCharacter.Event[state].TicketsSold + tonumber(glrCharacter.Event[state].StartingGold)) * (tonumber(glrCharacter.Event[state].SecondPlace)/100), state, true, 1, "NA", true, false, false)
					else
						Variables[17][2][var] = L["Winner Guaranteed"]
					end
					return
				elseif var == "%%jackpot_start" then
					Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event[state].StartingGold, state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%percent_guild" then
					Variables[17][2][var] = glrCharacter.Event[state].GuildCut
					return
				elseif var == "%%percent_second" then
					Variables[17][2][var] = glrCharacter.Event[state].SecondPlace
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
					Variables[17][2]["%%raffle_prizes"] = var
					return
				elseif var == "%%raffle_first" then
					if glrCharacter.Event[state].FirstPlace == "%raffle_total" then
						Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event[state].FirstPlace == "%raffle_half" then
						Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
					elseif glrCharacter.Event[state].FirstPlace == "%raffle_quarter" then
						Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
					elseif tonumber(glrCharacter.Event[state].FirstPlace) ~= nil then
						Variables[17][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].FirstPlace), "Raffle", false, 1, "NA", true, false)
					else
						Variables[17][2][var] = glrCharacter.Event[state].FirstPlace
					end
					return
				elseif var == "%%raffle_second" then
					if glrCharacter.Event[state].SecondPlace ~= false then
						if glrCharacter.Event[state].SecondPlace == "%raffle_total" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].SecondPlace == "%raffle_half" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].SecondPlace == "%raffle_quarter" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						elseif tonumber(glrCharacter.Event[state].SecondPlace) ~= nil then
							Variables[17][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].SecondPlace), "Raffle", false, 1, "NA", true, false)
						else
							Variables[17][2][var] = glrCharacter.Event[state].SecondPlace
						end
					end
					return
				elseif var == "%%raffle_third" then
					if glrCharacter.Event[state].ThirdPlace ~= false then
						if glrCharacter.Event[state].ThirdPlace == "%raffle_total" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].ThirdPlace == "%raffle_half" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
						elseif glrCharacter.Event[state].ThirdPlace == "%raffle_quarter" then
							Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
						elseif tonumber(glrCharacter.Event[state].ThirdPlace) ~= nil then
							Variables[17][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].ThirdPlace), "Raffle", false, 1, "NA", true, false)
						else
							Variables[17][2][var] = glrCharacter.Event[state].ThirdPlace
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
					Variables[17][2][var] = s
					return
				elseif var == "%%tickets_max" then
					Variables[17][2][var] = glrCharacter.Event[state].MaxTickets
					return
				elseif var == "%%tickets_price" then
					Variables[17][2][var] = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].TicketPrice), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%tickets_sold" then
					Variables[17][2][var] = glrCharacter.Event[state].TicketsSold
					return
				elseif var == "%%tickets_given" then
					Variables[17][2][var] = glrCharacter.Event[state].GiveAwayTickets
					return
				elseif var == "%%tickets_total" then
					Variables[17][2][var] = CommaValue(glrCharacter.Event[state].TicketsSold + glrCharacter.Event[state].GiveAwayTickets)
					return
				elseif var == "%%tickets_value" then
					Variables[17][2][var] = GLR_U:GetMoneyValue(glrCharacter.Event[state].TicketsSold * tonumber(glrCharacter.Event[state].TicketPrice), state, true, 1, "NA", true, false, false)
					return
				elseif var == "%%event_name" then
					Variables[17][2][var] = glrCharacter.Event[state].EventName
					return
				elseif var == "%%event_date" then
					Variables[17][2][var] = glrCharacter.Event[state].Date
					return
				else
					if glrCharacter[state].Entries.Tickets[FullPlayerName] ~= nil then
						if var == "%%tickets_current" then
							Variables[17][2][var] = glrCharacter[state].Entries.Tickets[FullPlayerName].NumberOfTickets
							return
						elseif var == "%%tickets_difference" then
							Variables[17][2][var] = tonumber(glrCharacter.Event[state].MaxTickets) - glrCharacter[state].Entries.Tickets[FullPlayerName].NumberOfTickets
							return
						end
					else
						if var == "%%tickets_current" then
							Variables[17][2][var] = "0"
							return
						elseif var == "%%tickets_difference" then
							Variables[17][2][var] = glrCharacter.Event[state].MaxTickets
							return
						end
					end
				end
			end
		end
	end
	
	for t, v in pairs(Variables[17][3]) do
		if t == "General" then
			for k, e in pairs(Variables[17][3][t]) do
				if Variables[17][3][t][k] then
					PharseVariable(tostring(k))
					Variables[17][3][t][k] = false
				end
			end
		end
		if t == state then
			if glrCharacter.Data.Settings["CurrentlyActive" .. state] then
				for k, e in pairs(Variables[17][3][t]) do
					if Variables[17][3][t][k] then
						PharseVariable(tostring(k))
						Variables[17][3][t][k] = false
					end
				end
			else
				for k, e in pairs(Variables[17][3][t]) do
					Variables[17][2][k] = tostring(k)
					Variables[17][3][t][k] = true
				end
			end
		end
	end
	
end

local function ResetWhisperVariables(state)
	for t, v in pairs(Variables[17][3]) do
		if t == "General" or t == state then
			for k, e in pairs(Variables[17][3][t]) do
				Variables[17][3][t][k] = true
			end
		end
	end
end

local function SendAdditionalMessages(message, state, target)
	
	UpdateWhisperVariables(state)
	
	local t = {}
	
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
		for j = 1, #Variables[17][1] do
			m = string.gsub(m, Variables[17][1][j], Variables[17][2][Variables[17][1][j]])
		end
		t[i] = m
	end
	
	for i = 1, #t do
		SendChatMessage(t[i], "WHISPER", nil, target)
	end
	
	ResetWhisperVariables(state)
	
end

function GLR:SendPlayerTicketInfo(state, user)
	
	local userName = user
	local targetedName = user
	local playerGuild = glrCharacter.Data.Settings.General.GuildName
	local addonEnabled = false
	local timeBetweenAlerts = glrCharacter.Data.Settings.General.TimeBetweenAlerts
	local lotteryStatus = glrCharacter.Data.Settings["CurrentlyActiveLottery"]
	local raffleStatus = glrCharacter.Data.Settings["CurrentlyActiveRaffle"]
	local LargeData = glrCharacter.Data.Settings.General.SendLargeInfo
	local dateTime = time()
	local lastAlert = 0
	local totalTime = 0
	local status = false
	local prizeOne = false
	local prizeTwo = false
	local prizeThree = false
	
	if glrCharacter.Data.Settings ~= nil then
		if glrCharacter.Data.Settings.General.enabled ~= nil then
			addonEnabled = glrCharacter.Data.Settings.General.enabled
		end
	end
	
	if not string.find(targetedName, "-") then
		userName = strjoin("-", userName, PlayerRealmName)
	end
	
	if glrCharacter[state] ~= nil then
		if glrCharacter[state].MessageStatus ~= nil then
			if glrCharacter[state].MessageStatus[userName] ~= nil then
				if glrCharacter[state].MessageStatus[userName].lastAlert == nil then
					glrCharacter[state].MessageStatus[userName].lastAlert = dateTime - timeBetweenAlerts - 1
				end
				lastAlert = glrCharacter[state].MessageStatus[userName].lastAlert + timeBetweenAlerts
				totalTime = dateTime + timeBetweenAlerts
			else
				glrCharacter[state].MessageStatus[userName] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
			end
		else
			glrCharacter[state].MessageStatus = {}
			glrCharacter[state].MessageStatus[userName] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
		end
	end
	
	if state == "Lottery" then
		if glrCharacter.Event[state] ~= nil then
			status = lotteryStatus
		end
	else
		if glrCharacter.Event[state] ~= nil then
			if glrCharacter.Event[state].FirstPlace then
				if glrCharacter.Event[state].FirstPlace == "%raffle_total" then
					prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].FirstPlace == "%raffle_half" then
					prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].FirstPlace == "%raffle_quarter" then
					prizeOne = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
				elseif tonumber(glrCharacter.Event[state].FirstPlace) ~= nil then
					prizeOne = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].FirstPlace), "Raffle", false, 1, "NA", true, false)
				else
					prizeOne = glrCharacter.Event[state].FirstPlace
				end
			end
			if glrCharacter.Event[state].SecondPlace then
				if glrCharacter.Event[state].SecondPlace == "%raffle_total" then
					prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].SecondPlace == "%raffle_half" then
					prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].SecondPlace == "%raffle_quarter" then
					prizeTwo = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
				elseif tonumber(glrCharacter.Event[state].SecondPlace) ~= nil then
					prizeTwo = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].SecondPlace), "Raffle", false, 1, "NA", true, false)
				else
					prizeTwo = glrCharacter.Event[state].SecondPlace
				end
			end
			if glrCharacter.Event[state].ThirdPlace then
				if glrCharacter.Event[state].ThirdPlace == "%raffle_total" then
					prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice), "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].ThirdPlace == "%raffle_half" then
					prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.5, "Raffle", false, 1, "NA", true, false)
				elseif glrCharacter.Event[state].ThirdPlace == "%raffle_quarter" then
					prizeThree = GLR_U:GetMoneyValue(glrCharacter.Event.Raffle.TicketsSold * tonumber(glrCharacter.Event.Raffle.TicketPrice) * 0.25, "Raffle", false, 1, "NA", true, false)
				elseif tonumber(glrCharacter.Event[state].ThirdPlace) ~= nil then
					prizeThree = GLR_U:GetMoneyValue(tonumber(glrCharacter.Event[state].ThirdPlace), "Raffle", false, 1, "NA", true, false)
				else
					prizeThree = glrCharacter.Event[state].ThirdPlace
				end
			end
			status = raffleStatus
		end
	end
	
	if addonEnabled then
		
		if dateTime > lastAlert then
			
			if status then
				
				local startingGold
				local ticketSold
				local price
				local jackpotGold
				local guildPercent
				local continue = false
				
				if state == "Lottery" then
					startingGold = tonumber(glrCharacter.Event[state].StartingGold)
					ticketSold = glrCharacter.Event[state].TicketsSold
					price = tonumber(glrCharacter.Event[state].TicketPrice)
					local tempJackpotGold = startingGold + ( ticketSold * price )
					local round = glrCharacter.Data.Settings.Lottery.RoundValue
					guildPercent = glrCharacter.Event[state].GuildCut
					jackpotGold = tostring(tempJackpotGold - ( (tonumber(guildPercent) / 100) * tempJackpotGold ))
					jackpotGold = GLR_U:GetMoneyValue(jackpotGold, "Lottery", true, 1)
					if glrCharacter[state].Entries.Tickets[userName] ~= nil then
						continue = true
					end
				else
					ticketSold = glrCharacter.Event[state].TicketsSold
					price = tonumber(glrCharacter.Event[state].TicketPrice)
					if glrCharacter[state].Entries.Tickets[userName] ~= nil then
						continue = true
					end
				end
				
				if continue then
					
					local eventName
					local eventDate
					local purchasedTickets
					local maxTickets
					local tickets = 1
					local ticketNumbers = ""
					local title = L["Send Info Title"] .. GLR_CurrentVersionString
					
					if glrCharacter[state].MessageStatus.userName ~= nil then
						glrCharacter[state].MessageStatus.userName = { ["sentMessage"] = true, ["lastAlert"] = dateTime }
					end
					
					eventName = glrCharacter.Event[state].EventName
					if glrCharacter.Data.Settings.General.TimeFormatKey == 1 then
						eventDate = glrCharacter.Event[state].Date
					else
						local s = string.sub(glrCharacter.Event[state].Date, 1, string.find(glrCharacter.Event[state].Date, "%@") + 1)
						local t = GetTimeFormat(string.sub(glrCharacter.Event[state].Date, string.find(glrCharacter.Event[state].Date, "%:") - 2))
						eventDate = s .. t
					end
					purchasedTickets = tostring(glrCharacter[state].Entries.Tickets[userName].NumberOfTickets)
					maxTickets = glrCharacter.Event[state].MaxTickets
					if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
						tickets = glrCharacter[state].Entries.TicketNumbers[userName]
					end
					
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					SendChatMessage(title, "WHISPER", nil, userName)
					SendChatMessage(L["Send Info Event Info 1"] .. ": " .. eventName .. " " .. L["Send Info Event Info 2"] .. " " .. eventDate, "WHISPER", nil, userName)
					
					if tonumber(purchasedTickets) > 0 then
						
						SendChatMessage(L["Send Info Tickets Purchased First Msg 1"] .. " " .. purchasedTickets .. " " .. L["Send Info Tickets Purchased First Msg 2"] .. " " .. maxTickets .. " " .. L["Send Info Tickets Purchased First Msg 3"], "WHISPER", nil, userName)
						
					end
					
					if LargeData then
						
						for i = 1, #tickets do
							
							if glrCharacter.Data.Settings.General.AdvancedTicketDraw then break end
							ticketNumbers = strjoin(" ", ticketNumbers, tickets[i])
							
						end
						
						local length = strlen(ticketNumbers)
						
						if length > 220 then
							
							local currentTime = time()
							local longMsg = true
							local bypass = true
							local endMsg = true
							local done = false
							local ta = {}
							local lt = {}
							local ts = ""
							local nt = 0
							local mnt = 0
							local nm = 0
							local steps = 35
							
							if longMsg then
								
								SendChatMessage(L["Send Info Long Ticket Message"], "WHISPER", nil, userName)
								longMsg = false
								
							end
							
							for v in string.gmatch(ticketNumbers, "[^ ]+") do
								table.insert(ta, v)
								nt = nt + 1
								mnt = mnt + 1
							end
							
							if mnt >= 500 then
								bypass = false
							end
							
							for i = 1, #ta do
								
								for j = 1, steps do
									if length > 0 or not done then
										if  nt > 0 then
											ts = strjoin(" ", ts, ta[1])
											table.remove(ta, 1)
											nt = nt - 1
										end
									end
								end
								
								if not done then
									nm = nm + 1
									table.insert(lt, ts)
									length = length - strlen(ts)
									steps = length / 5
									if steps > 35 then
										steps = 35
									end
									if nt == 0 then
										done = true
									end
								end
								
								if bypass then
									SendChatMessage(ts, "WHISPER", nil, userName)
								end
								
								--Resets the Ticket Number string so it's not a ever growing string until it breaks the character limit
								ts = ""
								
								if done then
									break
								end
								
							end
							
							if not bypass then
								
								local ms = 0.2
								nm = nm + 1
								sort(lt)
								
								for i = 1, nm do
									C_Timer.After(ms, function()
										GLR:SendLargeTicketInfo(lt, userName, nm, state)
									end)
									ms = ms + 0.2
								end
								
							end
							
							if endMsg and bypass and state == "Lottery" then
								
								SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
								SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
								endMsg = false
								
							elseif endMsg and bypass and state == "Raffle" then
								
								SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
								
								if prizeOne then
									prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
									SendChatMessage(prizeOne, "WHISPER", nil, userName)
								end
								if prizeTwo then
									prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
									SendChatMessage(prizeTwo, "WHISPER", nil, userName)
								end
								if prizeThree then
									prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
									SendChatMessage(prizeThree, "WHISPER", nil, userName)
								end
								
								SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
								endMsg = false
								
							end
							
						else
							
							if tonumber(purchasedTickets) > 0 then
								
								if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
									SendChatMessage(L["Send Info Short Ticket Message"] .. ":" .. ticketNumbers, "WHISPER", nil, userName)
								end
								if state == "Lottery" then
									SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
								end
								
							end
							
						end
						
					else
						
						if not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
							local fT = glrCharacter[state].Entries.TicketRange[userName].LowestTicketNumber
							local lT = glrCharacter[state].Entries.TicketRange[userName].HighestTicketNumber
							local message_1 = string.gsub(string.gsub(L["Send Info Ticket Number Range"], "%%first", fT), "%%last", lT)
							SendChatMessage(message_1, "WHISPER", nil, userName)
						end
						
					end
					
					if glrCharacter[state].Entries.Tickets[userName].NumberOfTickets < tonumber(maxTickets) then
						
						local ticketDifference = tonumber(maxTickets) - glrCharacter[state].Entries.Tickets[userName].NumberOfTickets
						local ticketPrice = tonumber(glrCharacter.Event[state].TicketPrice)
						ticketPrice = GLR_U:GetMoneyValue(ticketPrice, "Lottery", false)
						
						SendChatMessage(L["Send Info Can Purchase Tickets Part 1"] .. " " .. ticketDifference .. " " .. L["Send Info Can Purchase Tickets Part 2"] .. " " .. ticketPrice .. " " .. L["Send Info Can Purchase Tickets Part 3"], "WHISPER", nil, userName)
						
					end
					
					if state == "Lottery" then
						
						SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
						
						if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
							local WinChanceTable = { [1] = "90", [2] = "80", [3] = "70", [4] = "60", [5] = "50", [6] = "40", [7] = "30", [8] = "20", [9] = "10", [10] = "100" }
							local WinChanceKeyValue = 5
							if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
								WinChanceKeyValue = glrCharacter.Data.Settings.Lottery.WinChanceKey
							else
								WinChanceKeyValue = 10
							end
							local WinChanceMessage, _ = string.gsub(L["Send Info Current Win Chance"], "%%c", WinChanceTable[WinChanceKeyValue])
							SendChatMessage(WinChanceMessage, "WHISPER", nil, userName)
						end
						
						if glrHistory.Whispers[FullPlayerName][1] then
							SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][1], state, userName)
						end
						
					else
						
						SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
						if prizeOne then
							prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
							SendChatMessage(prizeOne, "WHISPER", nil, userName)
						end
						if prizeTwo then
							prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
							SendChatMessage(prizeTwo, "WHISPER", nil, userName)
						end
						if prizeThree then
							prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
							SendChatMessage(prizeThree, "WHISPER", nil, userName)
						end
						
						if glrHistory.Whispers[FullPlayerName][2] then
							SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][2], state, userName)
						end
						
					end
					
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					
				elseif not continue then
					
					local eventName = glrCharacter.Event[state].EventName
					local eventDate = glrCharacter.Event[state].Date
					if glrCharacter.Data.Settings.General.TimeFormatKey ~= 1 then
						local s = string.sub(glrCharacter.Event[state].Date, 1, string.find(glrCharacter.Event[state].Date, "%@") + 1)
						local t = GetTimeFormat(string.sub(glrCharacter.Event[state].Date, string.find(glrCharacter.Event[state].Date, "%:") - 2))
						eventDate = s .. t
					end
					local maxTickets = glrCharacter.Event[state].MaxTickets
					local ticketPrice = tonumber(glrCharacter.Event[state].TicketPrice)
					local title = L["Send Info Title"] .. GLR_CurrentVersionString
					ticketPrice = GLR_U:GetMoneyValue(ticketPrice, "Lottery", false)
					
					if glrCharacter[state].Entries.Tickets[userName] == nil then
						SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
						SendChatMessage(title, "WHISPER", nil, userName)
						SendChatMessage(L["Send Info Event Info 1"] .. ": " .. eventName .. " " .. L["Send Info Event Info 2"] .. " " .. eventDate, "WHISPER", nil, userName)
						SendChatMessage(L["Send Info No Tickets Purchased Part 1"] .. " " .. userName .. ". " .. L["Send Info No Tickets Purchased Part 2"], "WHISPER", nil, userName)
						SendChatMessage(L["Send Info Can Purchase Tickets Part 1"] .. " " .. maxTickets .. " " .. L["Send Info Can Purchase Tickets Part 2"] .. " " .. ticketPrice .. " " .. L["Send Info Can Purchase Tickets Part 3"], "WHISPER", nil, userName)
					end
					
					if state == "Lottery" then
						
						if glrCharacter[state].Entries.Tickets[userName] == nil then
							
							SendChatMessage(L["Send Info Reply Lottery"], "WHISPER", nil, userName)
							SendChatMessage(L["Send Info Current Jackpot Part 1"] .. " " .. guildPercent .. "%. " .. L["Send Info Current Jackpot Part 2"] .. " " .. jackpotGold, "WHISPER", nil, userName)
							
							if glrCharacter.Data.Settings.General.AdvancedTicketDraw then
								local WinChanceTable = { [1] = "90", [2] = "80", [3] = "70", [4] = "60", [5] = "50", [6] = "40", [7] = "30", [8] = "20", [9] = "10", [10] = "100" }
								local WinChanceKeyValue = 5
								if glrCharacter.Event.Lottery.SecondPlace ~= L["Winner Guaranteed"] then
									WinChanceKeyValue = glrCharacter.Data.Settings.Lottery.WinChanceKey
								else
									WinChanceKeyValue = 10
								end
								local WinChanceMessage, _ = string.gsub(L["Send Info Current Win Chance"], "%%c", WinChanceTable[WinChanceKeyValue])
								SendChatMessage(WinChanceMessage, "WHISPER", nil, userName)
							end
							
							if glrHistory.Whispers[FullPlayerName][1] then
								SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][1], state, userName)
							end
							
							SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
							
						end
						
					else
						
						if glrCharacter[state].Entries.Tickets[userName] == nil then
							
							SendChatMessage(L["Send Info Reply Raffle"], "WHISPER", nil, userName)
							SendChatMessage(L["Send Info Current Prizes"] .. ":", "WHISPER", nil, userName)
							if prizeOne then
								prizeOne = string.gsub(L["Raffle Draw Step 1 Prize 1"], "%%p1", prizeOne)
								SendChatMessage(prizeOne, "WHISPER", nil, userName)
							end
							if prizeTwo then
								prizeTwo = string.gsub(L["Raffle Draw Step 1 Prize 2"], "%%p2", prizeTwo)
								SendChatMessage(prizeTwo, "WHISPER", nil, userName)
							end
							if prizeThree then
								prizeThree = string.gsub(L["Raffle Draw Step 1 Prize 3"], "%%p3", prizeThree)
								SendChatMessage(prizeThree, "WHISPER", nil, userName)
							end
							
							if glrHistory.Whispers[FullPlayerName][2] then
								SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][2], state, userName)
							end
							
							SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
							
						end
						
					end
					
				end
				
			else
				if state == "Lottery" then
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					SendChatMessage(L["Send Info No Active Lottery"], "WHISPER", nil, userName)
					
					if glrHistory.Whispers[FullPlayerName][1] then
						SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][1], state, userName)
					end
					
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
				else
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
					SendChatMessage(L["Send Info No Active Raffle"], "WHISPER", nil, userName)
					
					if glrHistory.Whispers[FullPlayerName][2] then
						SendAdditionalMessages(glrHistory.Whispers[FullPlayerName][3][2], state, userName)
					end
					
					SendChatMessage("--------------------------------------------------", "WHISPER", nil, userName)
				end
			end
			
			if glrCharacter[state].MessageStatus == nil then
				glrCharacter[state].MessageStatus = {}
				glrCharacter[state].MessageStatus[userName] = { ["sentMessage"] = false, ["lastAlert"] = dateTime }
			end
			
		else
			SendChatMessage(L["Send Info Must Wait 1"] .. " " .. timeBetweenAlerts .. " " .. L["Send Info Must Wait 2"], "WHISPER", nil, userName)
		end
		
	elseif not addonEnabled then
		SendChatMessage(L["Send Info GLR Disabled"], "WHISPER", nil, userName)
	end
	
end

local function GLR_ChatEdit_InsertLink(text)
	
	if text and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:HasFocus() then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText(text)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetCursorPosition(0)
		return true
	end
	
	if text and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:HasFocus() then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText(text)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetCursorPosition(0)
		return true
	end
	
	if text and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:HasFocus() then
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText(text)
		GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetCursorPosition(0)
		return true
	end
	
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
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:HasFocus() then
		ItemText = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText()
		use = 1
	elseif GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:HasFocus() then
		ItemText = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText()
		use = 2
	elseif GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:HasFocus() then
		ItemText = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText()
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
					if use == 1 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText("")
					elseif use == 2 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText("")
					elseif use == 3 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText("")
					end
					C_Timer.After(1, function(self) TooltipCheck = false end)
					return
				elseif ItemOkay and ItemText ~= "" then
					if use == 1 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:ClearFocus()
					elseif use == 2 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:ClearFocus()
					elseif use == 3 then
						GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:ClearFocus()
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

function GLR:RaffleEditBoxTextChanged(checkBox)
	
	if IsShiftKeyDown() then
		CheckItemTooltip()
	end
	
	if checkBox == "First" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() ~= "" then
			if not Variables[15] then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Show()
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Hide()
			end
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() == "" then
			Variables[16][1][1] = false
			Variables[16][2][1] = 0
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Hide()
		end
	end
	
	if checkBox == "Second" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() ~= "" then
			if not Variables[15] then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Show()
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Hide()
			end
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() == "" then
			Variables[16][1][2] = false
			Variables[16][2][2] = 0
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Hide()
		end
	end
	
	if checkBox == "Third" then
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() ~= nil and GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() ~= "" then
			if not Variables[15] then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Show()
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Hide()
			end
		end
		if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() == "" then
			Variables[16][1][3] = false
			Variables[16][2][3] = 0
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Hide()
		end
	end
end

local function IsItemLinkCagedPet(text)
	local result = false
	if string.find(text, "battlepet:") ~= nil then
		result = true
	end
	return result
end

local function GetPetSpeciesIDFromLink(text)
	text = string.sub(text, select(2, string.find(text, "battlepet:")) + 1)	-- Parse out the first text up to colon + 1
	text = string.sub(text, 1, string.find(text, ":") - 1)					-- The end of the ID will be a colon
	return tonumber(text)
end

local function IsPetTradeable(speciesID)
    local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
    local isTradeable = select(9, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
    return isTradeable, name
end

function GLR:ConfirmValidItem(state, check)
	
	if check == nil then check = false end
	
	local text
	local use = 0
	local allowInvalid = GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:GetChecked()
	local bypass = false
	
	Variables[15] = true
	
	if state == "First" then
		use = 1
		text = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText()
		local compare, _ = string.gsub(string.gsub(text, "%.", ""), "%,", "")
		if check and Variables[16][1][1] then
			text = Variables[16][2][1]
		end
		if string.find(text, "%,") and tonumber(compare) ~= nil then
			text, _ = string.gsub(text, "%,", "")
		end
		if string.find(text, "%.") and tonumber(compare) ~= nil then
			local t = {}
			local p = ""
			for v in string.gmatch(text, "[^.]+") do
				if v ~= nil then
					table.insert(t, v)
				end
			end
			for i = 1, #t do
				p = p .. t[i]
				if t[i+1] == nil then
					text = tostring(tonumber(p) / 10000)
				end
			end
		end
		if tonumber(text) ~= nil then
			bypass = true
			Variables[16][1][1] = true
			Variables[16][2][1] = text
			if tonumber(text) > 9999999.9999 then
				text = 9999999.9999
			end
		else
			Variables[16][1][1] = false
			Variables[16][2][1] = 0
		end
	elseif state == "Second" then
		use = 2
		text = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText()
		local compare, _ = string.gsub(string.gsub(text, "%.", ""), "%,", "")
		if check and Variables[16][1][2] then
			text = Variables[16][2][2]
		end
		if string.find(text, "%,") and tonumber(compare) ~= nil then
			text, _ = string.gsub(text, "%,", "")
		end
		if string.find(text, "%.") and tonumber(compare) ~= nil then
			local t = {}
			local p = ""
			for v in string.gmatch(text, "[^.]+") do
				if v ~= nil then
					table.insert(t, v)
				end
			end
			for i = 1, #t do
				p = p .. t[i]
				if t[i+1] == nil then
					text = tostring(tonumber(p) / 10000)
				end
			end
		end
		if tonumber(text) ~= nil then
			bypass = true
			Variables[16][1][2] = true
			Variables[16][2][2] = text
			if tonumber(text) > 9999999.9999 then
				text = 9999999.9999
			end
		else
			Variables[16][1][2] = false
			Variables[16][2][2] = 0
		end
	elseif state == "Third" then
		use = 3
		text = GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText()
		local compare, _ = string.gsub(string.gsub(text, "%.", ""), "%,", "")
		if check and Variables[16][1][3] then
			text = Variables[16][2][3]
		end
		if string.find(text, "%,") and tonumber(compare) ~= nil then
			text, _ = string.gsub(text, "%,", "")
		end
		if string.find(text, "%.") and tonumber(compare) ~= nil then
			local t = {}
			local p = ""
			for v in string.gmatch(text, "[^.]+") do
				if v ~= nil then
					table.insert(t, v)
				end
			end
			for i = 1, #t do
				p = p .. t[i]
				if t[i+1] == nil then
					text = tostring(tonumber(p) / 10000)
				end
			end
		end
		if tonumber(text) ~= nil then
			bypass = true
			Variables[16][1][3] = true
			Variables[16][2][3] = text
			if tonumber(text) > 9999999.9999 then
				text = 9999999.9999
			end
		else
			Variables[16][1][3] = false
			Variables[16][2][3] = 0
		end
	end
	
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:GetText() == "" then
		holdRaffleInfo.FirstPrize.ItemName = ""
		holdRaffleInfo.FirstPrize.ItemLink = ""
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:GetText() == "" then
		holdRaffleInfo.SecondPrize.ItemName = ""
		holdRaffleInfo.SecondPrize.ItemLink = ""
	end
	if GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:GetText() == "" then
		holdRaffleInfo.ThirdPrize.ItemName = ""
		holdRaffleInfo.ThirdPrize.ItemLink = ""
	end
	
	local itemName, itemLink
	
	if tonumber(text) == nil then
		itemName, itemLink = GetItemInfo(text)
	end
	
	-- In case of caged pet, let's do an extra check, but only need to do this check if initially nil
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
		else
			text = GLR_U:GetMoneyValue(tonumber(text), "Raffle", false, 1, "NA", true, true)
		end
		allowInvalid = true
	end
	
	if itemLink == nil and allowInvalid then
		if bypass then
			itemLink = Variables[16][2][use]
		else
			itemLink = text
		end
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
			if bypass then
				nameText = Variables[16][2][use]
			else
				nameText = itemText
			end
		end
		itemName = nameText
	end
	
	if itemName then
		if use == 1 then
			holdRaffleInfo.FirstPrize.ItemName = itemName
		elseif use == 2 then
			holdRaffleInfo.SecondPrize.ItemName = itemName
		elseif use == 3 then
			holdRaffleInfo.ThirdPrize.ItemName = itemName
		end
	end
	
	if itemLink then
		if use == 1 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Hide()
			if bypass then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText(text)
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText(itemLink)
			end
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetCursorPosition(0)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:ClearFocus()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnEnter", function(self)
				if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
				else
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(L["Set Raffle Prize"])
					GameTooltip:AddLine(L["Set Raffle First Place Prize"])
					if Variables[16][1][1] and bypass then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("First Place Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(tonumber(Variables[16][2][1]), "Raffle", false, 1, "NA", true, true, true))
					end
					GameTooltip:Show()
				end
			end)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			holdRaffleInfo.FirstPrize.ItemLink = itemLink
		elseif use == 2 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Hide()
			if bypass then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText(text)
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText(itemLink)
			end
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetCursorPosition(0)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:ClearFocus()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnEnter", function(self)
				if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
				else
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(L["Set Raffle Prize"])
					GameTooltip:AddLine(L["Set Raffle Second Place Prize P1"])
					if Variables[16][1][2] and bypass then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Second Place Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(tonumber(Variables[16][2][2]), "Raffle", false, 1, "NA", true, true, true))
					end
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(L["Set Raffle Second Place Prize P2"], 1, 0, 0, 1)
					GameTooltip:Show()
				end
			end)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			holdRaffleInfo.SecondPrize.ItemLink = itemLink
		elseif use == 3 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Hide()
			if bypass then
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText(text)
			else
				GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText(itemLink)
			end
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetCursorPosition(0)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:ClearFocus()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnEnter", function(self)
				if GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMinutesSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfMonthsSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfDaysSelectionMenu:IsVisible() or GLR_UI.GLR_NewRaffleEventFrame.GLR_ListOfYearsSelectionMenu:IsVisible() then
				else
					GameTooltip:SetOwner(self, "ANCHOR_LEFT")
					GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
					GameTooltip:AddLine(L["Set Raffle Prize"])
					GameTooltip:AddLine(L["Set Raffle Third Place Prize P1"])
					if Variables[16][1][3] and bypass then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine("Third Place Prize Value is greater than the Player Gold Cap.")
						GameTooltip:AddLine("Current Prize Value: " .. GLR_U:GetMoneyValue(tonumber(Variables[16][2][3]), "Raffle", false, 1, "NA", true, true, true))
					end
					GameTooltip:AddLine(" ")
					GameTooltip:AddLine(L["Set Raffle Third Place Prize P2"], 1, 0, 0, 1)
					GameTooltip:Show()
				end
			end)
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			holdRaffleInfo.ThirdPrize.ItemLink = itemLink
		end
		GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
	else
		if use == 1 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemOneButton:Hide()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText("")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:ClearFocus()
		elseif use == 2 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemTwoButton:Hide()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText("")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:ClearFocus()
		elseif use == 3 then
			GLR_UI.GLR_NewRaffleEventFrame.GLR_ConfirmRaffleItemThreeButton:Hide()
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText("")
			GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:ClearFocus()
		end
		GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText(L["GLR - Core - Invalid Raffle Item"])
	end
	
	C_Timer.After(1, function(self) Variables[15] = false end)
	
end

function GLR:SelectPlayerNameForEntry(state)
	
	local playerNames = GenerateRosterNames()
	local enteredText
	local enteredTable = {}
	local classTable = {}
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if not status then
		classTable = glrRoster
	else
		classTable = glrMultiGuildRoster
	end
	local buffer = 3
	local count = 1
	local count2 = 1
	local n = 0
	local scrollHeight = 4
	local pHeight = 4
	local scrollWidth = 115
	local enteredOnce = false
	
	if state == "Lottery" then
		if GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons == nil then
			GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons or {}
		elseif GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons ~= nil then
			for i = 1, #GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons do
				local ClearText = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[count2][1]
				ClearText:SetText()
				count2 = count2 + 1
			end
		end
		enteredText = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:GetText()
	else
		if GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons == nil then
			GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons or {}
		elseif GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons ~= nil then
			for i = 1, #GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons do
				local ClearText = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[count2][1]
				ClearText:SetText()
				count2 = count2 + 1
			end
		end
		enteredText = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:GetText()
	end
	
	if enteredText ~= "" then
		
		local classCheck = false
		
		if GetLocale() == "frFR" then classCheck = true end
		
		for i = 1, #playerNames do
			
			local text = string.sub(playerNames[i], 1, string.find(playerNames[i], '%.') - 1)
			
			if string.lower(enteredText) == string.lower(string.sub(text, 1, #enteredText)) then
				table.insert(enteredTable, text)
			end
		end
		
		if #enteredTable == 0 then
			for i = 1, #playerNames do
				
				local text = string.sub(playerNames[i], 1, string.find(playerNames[i], '%.') - 1)
				
				if string.find(string.lower(text), string.lower(enteredText)) ~= nil then
					table.insert(enteredTable, text)
				end
			end
		end
		
		if state == "Lottery" then
			for i = 1, #GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons do
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[i][1]:Hide()
			end
		else
			for i = 1, #GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons do
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[i][1]:Hide()
			end
		end
		
		for t, v in pairs(enteredTable) do
			
			local isClassFound = false
			local PlayerNamesButton
			local PlayerNamesText
			
			if state == "Lottery" then
				if not GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[t] then
					local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu)
					GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
				end
				PlayerNamesButton = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[count][1]
				PlayerNamesText = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[count][2]
			else
				if not GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[t] then
					local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu)
					GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
				end
				PlayerNamesButton = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[count][1]
				PlayerNamesText = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[count][2]
			end
			
			PlayerNamesText:SetText(v)
			PlayerNamesText:SetPoint("CENTER", PlayerNamesButton)
			PlayerNamesText:SetFont(GLR_Core.ButtonFont, 12)
			PlayerNamesText:SetWordWrap(false)
			
			local sWidth = PlayerNamesText:GetWidth()
			
			PlayerNamesButton:SetWidth(sWidth)
			PlayerNamesButton:SetHeight(11)
			PlayerNamesButton:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
			
			for i = 1, #classTable do
				local text = classTable[i]
				local subText = string.sub(text, 1, string.find(text, '%[') - 1)
				local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
				if subText == v then
					if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
						CN = "NA"
					end
					PlayerNamesText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
					isClassFound = true
				end
				if isClassFound then
					break
				end
			end
			
			local sHeight = floor(PlayerNamesText:GetStringHeight()) + 1
			pHeight = sHeight + floor(PlayerNamesText:GetStringHeight()) + 1
			
			if count == 1 then
				if state == "Lottery" then
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu, "TOP", 0, -5)
				else
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu, "TOP", 0, -5)
				end
				scrollHeight = scrollHeight + sHeight
			else
				if state == "Lottery" then
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				else
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				end
				scrollHeight = scrollHeight + sHeight
			end
			
			if (sWidth + 20) > scrollWidth and (sWidth + 20) >= 115 then
				scrollWidth = sWidth + 30
			end
			
			if state == "Lottery" then
				PlayerNamesButton:SetScript("OnClick", function(self, button)
					if button == "LeftButton" then
						GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()
						GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetText(PlayerNamesText:GetText())
						GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetCursorPosition(0)
						GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:ClearFocus()
						for i = 1, #classTable do
							
							local isClassFound = false
							local text = classTable[i]
							local subText = string.sub(text, 1, string.find(text, '%[') - 1)
							local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
							if subText == GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:GetText() then
								if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
									CN = "NA"
								end
								GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
								isClassFound = true
							end
							
							if isClassFound then
								break
							end
						end
						GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerTicketsToLotteryEditBox:SetFocus()
					end
				end)
			else
				PlayerNamesButton:SetScript("OnClick", function(self, button)
					if button == "LeftButton" then
						GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()
						GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetText(PlayerNamesText:GetText())
						GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetCursorPosition(0)
						GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:ClearFocus()
						for i = 1, #classTable do
							
							local isClassFound = false
							local text = classTable[i]
							local subText = string.sub(text, 1, string.find(text, '%[') - 1)
							local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
							if subText == GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:GetText() then
								if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
									CN = "NA"
								end
								GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
								isClassFound = true
							end
							
							if isClassFound then
								break
							end
						end
						GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerTicketsToRaffleEditBox:SetFocus()
					end
				end)
			end
			
			PlayerNamesButton:Show()
			
			count = count + 1
			n = n + 1
			
		end
		
		scrollHeight = scrollHeight * 1.1
		
		if n > 0 then
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:SetSize(scrollWidth, scrollHeight)
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Show()
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText("")
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:SetSize(scrollWidth, scrollHeight)
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Show()
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText("")
			end
		elseif n == 0 then
			if state == "Lottery" then
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["No Player Found"])
				GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox.GLR_AddPlayerNameToLotterySelectionMenu:Hide()
			else
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["No Player Found"])
				GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox.GLR_AddPlayerNameToRaffleSelectionMenu:Hide()
			end
		end
	end
end

function GLR:SelectPlayerNameToEdit(state)
	
	local playerNames = GenerateRosterNames()
	local enteredText
	local enteredTable = {}
	local classTable = {}
	local status = glrCharacter.Data.Settings.General.MultiGuild
	if not status then
		classTable = glrRoster
	else
		classTable = glrMultiGuildRoster
	end
	local buffer = 3
	local count = 1
	local count2 = 1
	local n = 0
	local scrollHeight = 0
	local scrollWidth = 125
	local enteredOnce = false
	
	if state == "Lottery" then
		if GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons == nil then
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons or {}
		elseif GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons ~= nil then
			for i = 1, #GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons do
				local ClearText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[count2][1]
				ClearText:SetText()
				count2 = count2 + 1
			end
		end
		enteredText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
	else
		if GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons == nil then
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons or {}
		elseif GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons ~= nil then
			for i = 1, #GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons do
				local ClearText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[count2][1]
				ClearText:SetText()
				count2 = count2 + 1
			end
		end
		enteredText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
	end
	
	if enteredText ~= "" then
		
		local classCheck = false
		
		if GetLocale() == "frFR" then classCheck = true end
		
		for i = 1, #playerNames do
			
			local text = string.sub(playerNames[i], 1, string.find(playerNames[i], '%.') - 1)
			
			if string.lower(enteredText) == string.lower(string.sub(playerNames[i], 1, #enteredText)) then
				table.insert(enteredTable, text)
			end
		end
		
		if #enteredTable == 0 then
			for i = 1, #playerNames do
				
				local text = string.sub(playerNames[i], 1, string.find(playerNames[i], '%.') - 1)
				
				if string.find(string.lower(playerNames[i]), string.lower(enteredText)) ~= nil then
					table.insert(enteredTable, text)
				end
			end
		end
		
		if state == "Lottery" then
			for i = 1, #GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons do
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[i][1]:Hide()
			end
		else
			for i = 1, #GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons do
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[i][1]:Hide()
			end
		end
		
		for t, v in pairs(enteredTable) do
			
			local isClassFound = false
			local PlayerNamesButton
			local PlayerNamesText
			
			if state == "Lottery" then
				if not GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[t] then
					local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu)
					GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
				end
				PlayerNamesButton = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[count][1]
				PlayerNamesText = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[count][2]
			else
				if not GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[t] then
					local tempButton = CreateFrame("Button", "name" .. count, GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu)
					GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[t] = { tempButton, tempButton:CreateFontString("nameText" .. count, "OVERLAY", "GameFontWhiteTiny") }
				end
				PlayerNamesButton = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[count][1]
				PlayerNamesText = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[count][2]
			end
			
			PlayerNamesText:SetText(v)
			PlayerNamesText:SetPoint("CENTER", PlayerNamesButton)
			PlayerNamesText:SetFont(GLR_Core.ButtonFont, 12)
			PlayerNamesText:SetWordWrap(false)
			
			local sWidth = PlayerNamesText:GetWidth()
			
			PlayerNamesButton:SetWidth(sWidth)
			PlayerNamesButton:SetHeight(11)
			PlayerNamesButton:SetHighlightTexture("Interface\\Buttons\\UI-Silver-Button-Select")
			
			for i = 1, #classTable do
				
				local text = classTable[i]
				local subText = string.sub(text, 1, string.find(text, '%[') - 1)
				local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
				if subText == v then
					if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
						CN = "NA"
					end
					PlayerNamesText:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
					isClassFound = true
				end
				
				if isClassFound then
					break
				end
			end
			
			local sHeight = ( PlayerNamesText:GetStringHeight() * 1.1 ) + 1.8
			
			if count == 1 then
				if state == "Lottery" then
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu, "TOP", 0, -4)
				else
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu, "TOP", 0, -4)
				end
				scrollHeight = scrollHeight + sHeight + 2
			else
				if state == "Lottery" then
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				else
					PlayerNamesButton:SetPoint("TOP", GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu.Buttons[count - 1][1], "BOTTOM", 0, -buffer)
				end
				scrollHeight = scrollHeight + sHeight
			end
			
			if sWidth > scrollWidth and sWidth >= 125 then
				scrollWidth = sWidth + 20
			end
			
			if state == "Lottery" then
				PlayerNamesButton:SetScript("OnClick", function(self, button)
					if button == "LeftButton" then
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetText(PlayerNamesText:GetText())
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetCursorPosition(0)
						for i = 1, #classTable do
							
							local isClassFound = false
							local text = classTable[i]
							local subText = string.sub(text, 1, string.find(text, '%[') - 1)
							local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
							if subText == GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText() then
								if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
									CN = "NA"
								end
								GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
								isClassFound = true
							end
							
							if isClassFound then
								break
							end
						end
						GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:ClearFocus()
					end
				end)
			else
				PlayerNamesButton:SetScript("OnClick", function(self, button)
					if button == "LeftButton" then
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetText(PlayerNamesText:GetText())
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetCursorPosition(0)
						for i = 1, #classTable do
							
							local isClassFound = false
							local text = classTable[i]
							local subText = string.sub(text, 1, string.find(text, '%[') - 1)
							local CN = string.sub(text, string.find(text, '%[') + 1, string.find(text, '%]') - 1)
							if subText == GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText() then
								if ClassColor[CN] == nil then --Changes color to Red in event that it errors out.
									CN = "NA"
								end
								GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:SetTextColor(ClassColor[CN][1], ClassColor[CN][2], ClassColor[CN][3], 1)
								isClassFound = true
							end
							
							if isClassFound then
								break
							end
						end
						GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:ClearFocus()
					end
				end)
			end
			
			PlayerNamesButton:Show()
			
			count = count + 1
			n = n + 1
			
		end
		
		if n > 0 then
			if state == "Lottery" then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:SetSize(scrollWidth, scrollHeight)
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Show()
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText("")
			else
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:SetSize(scrollWidth, scrollHeight)
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Show()
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText("")
			end
		elseif n == 0 then
			if state == "Lottery" then
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["No Player Found"])
				GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
			else
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["No Player Found"])
				GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
			end
		end
	end
	
end

---------------------------------------------
------------- ADDON ACTIVATION --------------
---------------------------------------------
----- RUNS WHEN THE MOD IS FULLY LOADED -----
---------------------------------------------

GLR.Activation = function(_, event, addon)
	
	if event == "ADDON_LOADED" and addon == "GuildLotteryRaffle" and not Variables[3] then
		
		GLR:RegisterEvent("CHAT_MSG_WHISPER")
		GLR:RegisterEvent("CHAT_MSG_GUILD")
		GLR:RegisterEvent("PLAYER_LOGOUT")
		GLR:RegisterEvent("PLAYER_LOGIN")
		C_ChatInfo.RegisterAddonMessagePrefix("GLR_LOGIN")
		C_ChatInfo.RegisterAddonMessagePrefix("GLR_CHECK")
		C_ChatInfo.RegisterAddonMessagePrefix("GLR_HASMOD")
		C_ChatInfo.RegisterAddonMessagePrefix("GLR_LOGOUT")
		C_ChatInfo.RegisterAddonMessagePrefix("GLR_DEBUG")
		hooksecurefunc("ChatEdit_InsertLink", GLR_ChatEdit_InsertLink)
		
		if glrHistory == nil then
			glrHistory = {}
		end
		if glrHistory.Whispers == nil then
			glrHistory.Whispers = {}
		end
		if glrHistory.PlayerClass == nil then
			glrHistory.PlayerClass = { ["Alliance"] = {}, ["Horde"] = {}, }
		end
		if glrHistory.TransferData == nil then
			glrHistory.TransferData = {}
		end
		if glrHistory.TransferData[FullPlayerName] == nil then
			glrHistory.TransferData[FullPlayerName] = {}
		else
			local continue = true
			for t, v in pairs(glrHistory.TransferData) do
				if t == FullPlayerName then
					continue = false
					break
				end
			end
			if continue then
				glrHistory.TransferData[FullPlayerName] = {}
			end
		end
		if glrHistory.TransferStatus == nil then
			glrHistory.TransferStatus = {}
			glrHistory.TransferStatus.Lottery = {}
			glrHistory.TransferStatus.Raffle = {}
		end
		if glrHistory.TransferStatus.Lottery[FullPlayerName] == nil then
			glrHistory.TransferStatus.Lottery[FullPlayerName] = false
		elseif glrHistory.TransferStatus.Lottery[FullPlayerName] then
			
		end
		if glrHistory.TransferStatus.Raffle[FullPlayerName] == nil then
			glrHistory.TransferStatus.Raffle[FullPlayerName] = false
		elseif glrHistory.TransferStatus.Raffle[FullPlayerName] then
			
		end
		if glrHistory.TransferAvailable == nil then
			glrHistory.TransferAvailable = {}
			glrHistory.TransferAvailable.Lottery = {}
			glrHistory.TransferAvailable.Raffle = {}
		end
		if glrHistory.TransferAvailable.Lottery[FullPlayerName] == nil then
			glrHistory.TransferAvailable.Lottery[FullPlayerName] = false
		end
		if glrHistory.TransferAvailable.Raffle[FullPlayerName] == nil then
			glrHistory.TransferAvailable.Raffle[FullPlayerName] = false
		end
		if glrCharacter == nil then
			glrCharacter = {}
		end
		if glrCharacter.Data == nil then
			glrCharacter.Data = {}
		end
		if glrHistory.Version == nil then
			glrHistory.Version = GLR_Version
		elseif glrHistory.Version ~= nil and GLR_Version ~= nil then
			if glrHistory.Version ~= GLR_Version then
				glrHistory.Version = GLR_Version
				NewUpdate()
			end
		end
		if glrHistory.Updated == nil then
			glrHistory.Updated = time()
		else
			glrHistory.Updated = time()
		end
		if glrHistory.Settings == nil then
			glrHistory.Settings = {}
		end
		if glrHistory.Settings.Lottery == nil then
			glrHistory.Settings.Lottery = {}
		end
		if glrHistory.Settings.Raffle == nil then
			glrHistory.Settings.Raffle = {}
		end
		if glrHistory.Settings.LastDebugUpdate == nil then
			glrHistory.Settings.LastDebugUpdate = {}
		end
		if glrHistory.Settings.LastDebugUpdate[FullPlayerName] == nil then
			glrHistory.Settings.LastDebugUpdate[FullPlayerName] = ""
		end
		if glrHistory.Settings.Lottery.Mail == nil then
			glrHistory.Settings.Lottery.Mail = { [1] = L["Lottery"], [2] = L["Guild Lottery"], }
		end
		if glrHistory.Settings.Raffle.Mail == nil then
			glrHistory.Settings.Raffle.Mail = { [1] = L["Raffle"], [2] = L["Guild Raffle"], }
		end
		if glrHistory.Settings.Lottery.Commands == nil then
			if GetLocale() == "enUS" then
				glrHistory.Settings.Lottery.Commands = { [1] = string.lower(L["Lottery"]), }
			else
				glrHistory.Settings.Lottery.Commands = { [1] = "lottery", [2] = string.lower(L["Lottery"]), }
			end
		end
		if glrHistory.Settings.Raffle.Commands == nil then
			if GetLocale() == "enUS" then
				glrHistory.Settings.Raffle.Commands = { [1] = string.lower(L["Raffle"]), }
			else
				glrHistory.Settings.Raffle.Commands = { [1] = "raffle", [2] = string.lower(L["Raffle"]), }
			end
		end
		if glrHistory.LastUpdated == nil then
			glrHistory.LastUpdated = { ["Alliance"] = {}, ["Horde"] = {}, }
		end
		if glrCharacter.Updated == nil then
			glrCharacter.Updated = time()
		else
			glrCharacter.Updated = time()
		end
		if glrCharacter.Data.Version == nil and GLR_Version ~= nil then
			glrCharacter.Data.Version = GLR_Version
		elseif glrCharacter.Data.Version ~= nil and GLR_Version ~= nil then
			if glrCharacter.Data.Version ~= GLR_Version then
				glrCharacter.Data.Version = GLR_Version
			end
		end
		if glrCharacter.Data.Raffle == nil then
			glrCharacter.Data.Raffle = {}
		end
		if glrCharacter.Data.Raffle.FirstPrizeData == nil then
			glrCharacter.Data.Raffle.FirstPrizeData = {}
		end
		if glrCharacter.Data.Raffle.SecondPrizeData == nil then
			glrCharacter.Data.Raffle.SecondPrizeData = {}
		end
		if glrCharacter.Data.Raffle.ThirdPrizeData == nil then
			glrCharacter.Data.Raffle.ThirdPrizeData = {}
		end
		if glrCharacter.Data.Raffle.FirstPrizeData.ItemName == nil then
			glrCharacter.Data.Raffle.FirstPrizeData.ItemName = {}
		end
		if glrCharacter.Data.Raffle.SecondPrizeData.ItemName == nil then
			glrCharacter.Data.Raffle.SecondPrizeData.ItemName = {}
		end
		if glrCharacter.Data.Raffle.ThirdPrizeData.ItemName == nil then
			glrCharacter.Data.Raffle.ThirdPrizeData.ItemName = {}
		end
		if glrCharacter.Data.Raffle.FirstPrizeData.ItemLink == nil then
			glrCharacter.Data.Raffle.FirstPrizeData.ItemLink = {}
		end
		if glrCharacter.Data.Raffle.SecondPrizeData.ItemLink == nil then
			glrCharacter.Data.Raffle.SecondPrizeData.ItemLink = {}
		end
		if glrCharacter.Data.Raffle.ThirdPrizeData.ItemLink == nil then
			glrCharacter.Data.Raffle.ThirdPrizeData.ItemLink = {}
		end
		if glrCharacter.Data.Defaults == nil then
			glrCharacter.Data.Defaults = {}
		end
		if glrCharacter.Data.Defaults.GuildCut == nil then
			glrCharacter.Data.Defaults.GuildCut = "0"
		end
		if glrCharacter.Data.Defaults.SecondCut == nil then
			glrCharacter.Data.Defaults.SecondCut = "0"
		end
		if glrCharacter.Data.Defaults.LotteryMaxTickets == nil then
			glrCharacter.Data.Defaults.LotteryMaxTickets = "0"
		end
		if glrCharacter.Data.Defaults.LotteryMaxTickets == nil then
			glrCharacter.Data.Defaults.LotteryMaxTickets = "0"
		end
		if glrCharacter.Data.Defaults.RaffleMaxTickets == nil then
			glrCharacter.Data.Defaults.RaffleMaxTickets = "0"
		end
		if glrCharacter.Data.Defaults.StartingGold == nil then
			glrCharacter.Data.Defaults.StartingGold = "0"
		end
		if glrCharacter.Data.Defaults.LotteryDate == nil then
			glrCharacter.Data.Defaults.LotteryDate = ""
		end
		if glrCharacter.Data.Defaults.TicketPrice == nil then
			glrCharacter.Data.Defaults.TicketPrice = "0"
		end
		if glrCharacter.Data.Defaults.LotteryJackpot == nil then
			glrCharacter.Data.Defaults.LotteryJackpot = "0"
		end
		if glrCharacter.Data.Defaults.LotteryName == nil then
			glrCharacter.Data.Defaults.LotteryName = "No Lottery Active"
		end
		if glrCharacter.Data.Defaults.RaffleName == nil then
			glrCharacter.Data.Defaults.RaffleName = "No Raffle Active"
		end
		if glrCharacter.Data.Settings == nil then
			glrCharacter.Data.Settings = {}
		end
		if glrCharacter.Data.Settings.General == nil then
			glrCharacter.Data.Settings.General = {}
		end
		if glrCharacter.Data.Settings.Lottery == nil then
			glrCharacter.Data.Settings.Lottery = {}
		end
		if glrCharacter.Data.Settings.Raffle == nil then
			glrCharacter.Data.Settings.Raffle = {}
		end
		if glrCharacter.Data.Settings.CurrentlyActiveLottery == nil then
			glrCharacter.Data.Settings.CurrentlyActiveLottery = false
		end
		if glrCharacter.Data.Settings.CurrentlyActiveRaffle == nil then
			glrCharacter.Data.Settings.CurrentlyActiveRaffle = false
		end
		if glrCharacter.Data.Settings.PreviousLottery == nil then
			glrCharacter.Data.Settings.PreviousLottery = {}
		end
		if glrCharacter.Data.Settings.PreviousLottery.Jackpot == nil then
			glrCharacter.Data.Settings.PreviousLottery.Jackpot = 0
		end
		if glrCharacter.Data.Settings.PreviousLottery.TicketsSold == nil then
			glrCharacter.Data.Settings.PreviousLottery.TicketsSold = 0
		end
		if glrCharacter.Data.Settings.PreviousLottery.TicketsSold == nil then
			glrCharacter.Data.Settings.PreviousLottery.TicketsSold = 0
		end
		if glrCharacter.Data.Settings.PreviousLottery.TicketPrice == nil then
			glrCharacter.Data.Settings.PreviousLottery.TicketPrice = 0
		end
		if glrCharacter.Data.Settings.Profile == nil then
			glrCharacter.Data.Settings.Profile = {}
		end
		--
		--	BEGIN GENERAL SETTINGS VARIABLES
		--
		if glrCharacter.Data.Settings.General.DateFormatKey == nil then
			glrCharacter.Data.Settings.General.DateFormatKey = 1
		end
		if glrCharacter.Data.Settings.General.AnnounceAutoAbort == nil then
			glrCharacter.Data.Settings.General.AnnounceAutoAbort = false
		end
		if glrCharacter.Data.Settings.General.TimeFormatKey == nil then
			glrCharacter.Data.Settings.General.TimeFormatKey = 1
		end
		if glrCharacter.Data.Settings.General.LastDebugUpdate == nil then
			glrCharacter.Data.Settings.General.LastDebugUpdate = ""
		end
		if glrCharacter.Data.Settings.General.UserName == nil then
			if glrCharacter.Data.Settings.UserName ~= nil then
				glrCharacter.Data.Settings.General.UserName = glrCharacter.Data.Settings.UserName
				glrCharacter.Data.Settings.UserName = nil
			else
				glrCharacter.Data.Settings.General.UserName = ""
			end
		end
		if glrCharacter.Data.Settings.General.GuildName == nil then
			if glrCharacter.Data.Settings.GuildName ~= nil then
				glrCharacter.Data.Settings.General.GuildName = glrCharacter.Data.Settings.GuildName
				glrCharacter.Data.Settings.GuildName = nil
			else
				glrCharacter.Data.Settings.General.GuildName = ""
			end
		end
		if glrCharacter.Data.Settings.General.enabled == nil then
			if glrCharacter.Data.Settings.enabled ~= nil then
				glrCharacter.Data.Settings.General.enabled = glrCharacter.Data.Settings.enabled
				glrCharacter.Data.Settings.enabled = nil
			else
				glrCharacter.Data.Settings.General.enabled = true
			end
		end
		if glrCharacter.Data.Settings.General.mini_map == nil then
			if glrCharacter.Data.Settings.mini_map ~= nil then
				glrCharacter.Data.Settings.General.mini_map = glrCharacter.Data.Settings.mini_map
				glrCharacter.Data.Settings.mini_map = nil
			else
				glrCharacter.Data.Settings.General.mini_map = true
			end
		end
		if glrCharacter.Data.Settings.General.MinimapXOffset == nil then
			if glrCharacter.Data.Settings.MinimapXOffset ~= nil then
				glrCharacter.Data.Settings.General.MinimapXOffset = glrCharacter.Data.Settings.MinimapXOffset
				glrCharacter.Data.Settings.MinimapXOffset = nil
			else
				glrCharacter.Data.Settings.General.MinimapXOffset = -75
			end
		end
		if glrCharacter.Data.Settings.General.MinimapYOffset == nil then
			if glrCharacter.Data.Settings.MinimapYOffset ~= nil then
				glrCharacter.Data.Settings.General.MinimapYOffset = glrCharacter.Data.Settings.MinimapYOffset
				glrCharacter.Data.Settings.MinimapYOffset = nil
			else
				glrCharacter.Data.Settings.General.MinimapYOffset = -50
			end
		end
		if glrCharacter.Data.Settings.General.MinimapEdge == nil then
			if glrCharacter.Data.Settings.MinimapEdge ~= nil then
				glrCharacter.Data.Settings.General.MinimapEdge = glrCharacter.Data.Settings.MinimapEdge
				glrCharacter.Data.Settings.MinimapEdge = nil
			else
				glrCharacter.Data.Settings.General.MinimapEdge = true
			end
		end
		if glrCharacter.Data.Settings.General.TimeBetweenAlerts == nil then
			if glrCharacter.Data.Settings.TimeBetweenAlerts ~= nil then
				glrCharacter.Data.Settings.General.TimeBetweenAlerts = glrCharacter.Data.Settings.TimeBetweenAlerts
				glrCharacter.Data.Settings.TimeBetweenAlerts = nil
			else
				glrCharacter.Data.Settings.General.TimeBetweenAlerts = 60
			end
		end
		if glrCharacter.Data.Settings.General.TicketSeries == nil then
			if glrCharacter.Data.Settings.TicketSeries ~= nil then
				glrCharacter.Data.Settings.General.TicketSeries = glrCharacter.Data.Settings.TicketSeries
				glrCharacter.Data.Settings.TicketSeries = nil
			else
				glrCharacter.Data.Settings.General.TicketSeries = 1000
			end
		end
		if glrCharacter.Data.Settings.General.RaffleSeries == nil then
			if glrCharacter.Data.Settings.RaffleSeries ~= nil then
				glrCharacter.Data.Settings.General.RaffleSeries = glrCharacter.Data.Settings.RaffleSeries
				glrCharacter.Data.Settings.RaffleSeries = nil
			else
				glrCharacter.Data.Settings.General.RaffleSeries = 1000
			end
		end
		if glrCharacter.Data.Settings.General.ToggleEscape == nil then
			if glrCharacter.Data.Settings.ToggleEscape ~= nil then
				glrCharacter.Data.Settings.General.ToggleEscape = glrCharacter.Data.Settings.ToggleEscape
				glrCharacter.Data.Settings.ToggleEscape = nil
			else
				glrCharacter.Data.Settings.General.ToggleEscape = true
			end
		end
		if glrCharacter.Data.Settings.General.ToggleChatInfo == nil then
			if glrCharacter.Data.Settings.ToggleChatInfo ~= nil then
				glrCharacter.Data.Settings.General.ToggleChatInfo = glrCharacter.Data.Settings.ToggleChatInfo
				glrCharacter.Data.Settings.ToggleChatInfo = nil
			else
				glrCharacter.Data.Settings.General.ToggleChatInfo = false
			end
		end
		if glrCharacter.Data.Settings.General.SendLargeInfo == nil then
			if glrCharacter.Data.Settings.SendLargeInfo ~= nil then
				glrCharacter.Data.Settings.General.SendLargeInfo = glrCharacter.Data.Settings.SendLargeInfo
				glrCharacter.Data.Settings.SendLargeInfo = nil
			else
				glrCharacter.Data.Settings.General.SendLargeInfo = false
			end
		end
		if glrCharacter.Data.Settings.General.Status == nil then
			if glrCharacter.Data.Settings.Status ~= nil then
				glrCharacter.Data.Settings.General.Status = glrCharacter.Data.Settings.Status
				glrCharacter.Data.Settings.Status = nil
			else
				glrCharacter.Data.Settings.General.Status = "Lottery"
			end
		end
		if glrCharacter.Data.Settings.General.LastAlert == nil then
			if glrCharacter.Data.Settings.LastAlert ~= nil then
				glrCharacter.Data.Settings.General.LastAlert = glrCharacter.Data.Settings.LastAlert
				glrCharacter.Data.Settings.LastAlert = nil
			else
				glrCharacter.Data.Settings.General.LastAlert = 0
			end
		end
		if glrCharacter.Data.Settings.General.MultiGuild == nil then
			if glrCharacter.Data.Settings.MultiGuild ~= nil then
				glrCharacter.Data.Settings.General.MultiGuild = glrCharacter.Data.Settings.MultiGuild
				glrCharacter.Data.Settings.MultiGuild = nil
			else
				glrCharacter.Data.Settings.General.MultiGuild = false
			end
		end
		if glrCharacter.Data.Settings.General.CrossFactionEvents == nil then
			if glrCharacter.Data.Settings.CrossFactionEvents ~= nil then
				glrCharacter.Data.Settings.General.CrossFactionEvents = glrCharacter.Data.Settings.CrossFactionEvents
				glrCharacter.Data.Settings.CrossFactionEvents = nil
			else
				glrCharacter.Data.Settings.General.CrossFactionEvents = false
			end
		end
		if glrCharacter.Data.Settings.General.AdvancedTicketDraw == nil then
			if glrCharacter.Data.Settings.AdvancedTicketDraw ~= nil then
				glrCharacter.Data.Settings.General.AdvancedTicketDraw = glrCharacter.Data.Settings.AdvancedTicketDraw
				glrCharacter.Data.Settings.AdvancedTicketDraw = nil
			else
				glrCharacter.Data.Settings.General.AdvancedTicketDraw = false
			end
		end
		if glrCharacter.Data.Settings.General.CreateCalendarEvents == nil then
			if glrCharacter.Data.Settings.CreateCalendarEvents ~= nil then
				glrCharacter.Data.Settings.General.CreateCalendarEvents = glrCharacter.Data.Settings.CreateCalendarEvents
				glrCharacter.Data.Settings.CreateCalendarEvents = nil
			else
				glrCharacter.Data.Settings.General.CreateCalendarEvents = false
			end
		end
		if glrCharacter.Data.Settings.General.DisableLoginMessages == nil then
			if glrCharacter.Data.Settings.DisableLoginMessages ~= nil then
				glrCharacter.Data.Settings.General.DisableLoginMessages = glrCharacter.Data.Settings.DisableLoginMessages
				glrCharacter.Data.Settings.DisableLoginMessages = nil
			else
				glrCharacter.Data.Settings.General.DisableLoginMessages = false
			end
		end
		if glrCharacter.Data.Settings.General.ExportFormatKey == nil then
			if glrCharacter.Data.Settings.ExportFormatKey ~= nil then
				glrCharacter.Data.Settings.General.ExportFormatKey = glrCharacter.Data.Settings.ExportFormatKey
				glrCharacter.Data.Settings.ExportFormatKey = nil
			else
				glrCharacter.Data.Settings.General.ExportFormatKey = 1
			end
		end
		if glrCharacter.Data.Settings.General.ExportTypeKey == nil then
			if glrCharacter.Data.Settings.ExportTypeKey ~= nil then
				glrCharacter.Data.Settings.General.ExportTypeKey = glrCharacter.Data.Settings.ExportTypeKey
				glrCharacter.Data.Settings.ExportTypeKey = nil
			else
				glrCharacter.Data.Settings.General.ExportTypeKey = 1
			end
		end
		if glrCharacter.Data.Settings.General.ExportHeader == nil then
			if glrCharacter.Data.Settings.ExportHeader ~= nil then
				glrCharacter.Data.Settings.General.ExportHeader = glrCharacter.Data.Settings.ExportHeader
				glrCharacter.Data.Settings.ExportHeader = nil
			else
				glrCharacter.Data.Settings.General.ExportHeader = true
			end
		end
		if glrCharacter.Data.Settings.General.ReplyToSender == nil then
			if glrCharacter.Data.Settings.ReplyToSender ~= nil then
				glrCharacter.Data.Settings.General.ReplyToSender = glrCharacter.Data.Settings.ReplyToSender
				glrCharacter.Data.Settings.ReplyToSender = nil
			else
				glrCharacter.Data.Settings.General.ReplyToSender = false
			end
		end
		--
		--	BEGIN LOTTERY SETTINGS VARIABLES
		--
		if glrCharacter.Data.Settings.Lottery.CarryOver == nil then
			glrCharacter.Data.Settings.Lottery.CarryOver = false
		end
		if glrCharacter.Data.RollOver == nil then
			glrCharacter.Data.RollOver = { ["Lottery"] = { ["Check"] = {}, ["Names"] = {}, }, ["Raffle"] = {}, }
		end
		if glrCharacter.Data.Settings.Lottery.RollOverCheck == nil then
			glrCharacter.Data.Settings.Lottery.RollOverCheck = false
		end
		if glrCharacter.Data.Settings.Lottery.WinChanceKey == nil then
			glrCharacter.Data.Settings.Lottery.WinChanceKey = 5
		else
			--Need to make sure the value isn't changed manually
			if glrCharacter.Data.Settings.CurrentlyActiveLottery and not glrCharacter.Data.Settings.General.AdvancedTicketDraw then
				glrCharacter.Data.Settings.Lottery.WinChanceKey = 5
			end
		end
		if glrCharacter.Data.Settings.Lottery.NoGuildCut == nil then
			if glrCharacter.Data.Settings.NoGuildCut ~= nil then
				glrCharacter.Data.Settings.Lottery.NoGuildCut = glrCharacter.Data.Settings.NoGuildCut
				glrCharacter.Data.Settings.NoGuildCut = nil
			else
				glrCharacter.Data.Settings.Lottery.NoGuildCut = false
			end
		end
		if glrCharacter.Data.Settings.Lottery.RoundValue == nil then
			if glrCharacter.Data.Settings.RoundJackpot ~= nil then
				if glrCharacter.Data.Settings.RoundJackpot then
					glrCharacter.Data.Settings.Lottery.RoundValue = 2
				else
					glrCharacter.Data.Settings.Lottery.RoundValue = 1
				end
				glrCharacter.Data.Settings.RoundJackpot = nil
			else
				if glrCharacter.Data.Settings.Lottery.RoundJackpot ~= nil then
					if glrCharacter.Data.Settings.Lottery.RoundJackpot then
						glrCharacter.Data.Settings.Lottery.RoundValue = 2
					else
						glrCharacter.Data.Settings.Lottery.RoundValue = 1
					end
					glrCharacter.Data.Settings.Lottery.RoundJackpot = nil
				else
					glrCharacter.Data.Settings.Lottery.RoundValue = 1
				end
			end
		end
		--
		--	BEGIN RAFFLE SETTINGS VARIABLES
		--
		if glrCharacter.Data.Settings.Raffle.InverseAnnounce == nil then
			if glrCharacter.Data.Settings.InverseAnnounce ~= nil then
				glrCharacter.Data.Settings.Raffle.InverseAnnounce = glrCharacter.Data.Settings.InverseAnnounce
				glrCharacter.Data.Settings.InverseAnnounce = nil
			else
				glrCharacter.Data.Settings.Raffle.InverseAnnounce = false
			end
		end
		if glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners == nil then
			if glrCharacter.Data.Settings.AllowMultipleRaffleWinners ~= nil then
				glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners = glrCharacter.Data.Settings.AllowMultipleRaffleWinners
				glrCharacter.Data.Settings.AllowMultipleRaffleWinners = nil
			else
				glrCharacter.Data.Settings.Raffle.AllowMultipleRaffleWinners = false
			end
		end
		--
		--	END GENERAL / LOTTERY / RAFFLE SETTINGS VARIABLES
		--
		if glrCharacter.Data.Settings.Profile.Lottery == nil then
			glrCharacter.Data.Settings.Profile.Lottery = { ["StartingGold"] = "0", ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["SecondPlace"] = "0", ["GuildCut"] = "0", ["Guaranteed"] = false }
		end
		if glrCharacter.Data.Settings.Profile.Raffle == nil then
			glrCharacter.Data.Settings.Profile.Raffle = { ["MaxTickets"] = "0", ["TicketPrice"] = "0", ["InvalidItems"] = false }
		end
		if glrCharacter.Data.Messages == nil then
			glrCharacter.Data.Messages = {}
		end
		if glrCharacter.Data.Messages.GuildAlerts == nil then
			glrCharacter.Data.Messages.GuildAlerts = {}
		end
		if glrCharacter.Data.Messages.GuildAlerts.Lottery == nil then
			glrCharacter.Data.Messages.GuildAlerts.Lottery = {}
			glrCharacter.Data.Messages.GuildAlerts.Lottery = { [1] = L["GLR Title with Version"] .. "%version", [2] = L["Alert Guild Lottery Scheduled"] .. ": %lottery_date", [3] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [6] = L["Alert Guild Tickets Bought"] .. ": %lottery_winamount", [7] = L["Alert Guild Whisper For Lottery Info"], [8] = false }
		else
			if string.find(glrCharacter.Data.Messages.GuildAlerts.Lottery[1], L["GLR Title with Version"]) then
				local text = string.sub(glrCharacter.Data.Messages.GuildAlerts.Lottery[1], string.find(glrCharacter.Data.Messages.GuildAlerts.Lottery[1], 'v') + 1)
				if string.find(text, "3.0.6") then
					glrCharacter.Data.Messages.GuildAlerts.Lottery[1] = L["GLR Title with Version"] .. "%version"
				end
				if string.find(text, "3.0.61") then
					glrCharacter.Data.Messages.GuildAlerts.Lottery[1] = L["GLR Title with Version"] .. "%version"
				end
			end
		end
		if glrCharacter.Data.Messages.GuildAlerts.Raffle == nil then
			glrCharacter.Data.Messages.GuildAlerts.Raffle = {}
			glrCharacter.Data.Messages.GuildAlerts.Raffle = { [1] = L["GLR Title with Version"] .. "%version", [2] = L["Alert Guild Raffle Scheduled"] .. ": %raffle_date", [3] = L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name", [4] = L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [5] = L["Alert Guild Ticket Info Part 3"]  .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [6] = "%raffle_tickets " .. L["Alert Guild Raffle Tickets Bought"], [7] = L["Raffle Draw Step 1"] .. ": %raffle_prizes", [8] = L["Alert Guild Whisper For Raffle Info"], [9] = false }
		else
			if string.find(glrCharacter.Data.Messages.GuildAlerts.Raffle[1], L["GLR Title with Version"]) then
				local text = string.sub(glrCharacter.Data.Messages.GuildAlerts.Raffle[1], string.find(glrCharacter.Data.Messages.GuildAlerts.Raffle[1], 'v') + 1)
				if string.find(text, "3.0.6") then
					glrCharacter.Data.Messages.GuildAlerts.Raffle[1] = L["GLR Title with Version"] .. "%version"
				end
				if string.find(text, "3.0.61") then
					glrCharacter.Data.Messages.GuildAlerts.Raffle[1] = L["GLR Title with Version"] .. "%version"
				end
			end
			if glrCharacter.Data.Messages.GuildAlerts.Raffle[8] == false then
				glrCharacter.Data.Messages.GuildAlerts.Raffle[7] = L["Raffle Draw Step 1"] .. ": %raffle_prizes"
				glrCharacter.Data.Messages.GuildAlerts.Raffle[8] = L["Alert Guild Whisper For Raffle Info"]
				glrCharacter.Data.Messages.GuildAlerts.Raffle[9] = false
			end
		end
		if glrCharacter.Data.Messages.GuildAlerts.Both == nil then
			glrCharacter.Data.Messages.GuildAlerts.Both = {}
			glrCharacter.Data.Messages.GuildAlerts.Both = { [1] = L["GLR Title with Version"] .. "%version", [2] = L["Alert Guild LaR Scheduled"] .. ":", [3] = L["Lottery"] .. ": %lottery_date, " .. L["Raffle"] .. ": %raffle_date", [4] = L["Lottery"] .. " " .. L["Alert Guild Event Name"] .. ": %lottery_name, " .. L["Raffle"] .. " " .. L["Alert Guild Event Name"] .. ": %raffle_name.", [5] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %lottery_price " .. L["Alert Guild Ticket Info Part 2"], [6] = L["Lottery"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %lottery_max " .. L["Alert Guild Ticket Info Part 4"], [7] = L["Lottery"] .. ": " .. L["Alert Guild Tickets Bought"] .. " %lottery_winamount", [8] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 1"] .. " %raffle_price " .. L["Alert Guild Ticket Info Part 2"], [9] = L["Raffle"] .. ": " .. L["Alert Guild Ticket Info Part 3"] .. " %raffle_max " .. L["Alert Guild Ticket Info Part 4"], [10] = L["Raffle"] .. ": %raffle_tickets " .. L["Alert Guild Raffle Tickets Bought"], [11] = L["Alert Guild Whisper For LaR Info"], [12] = false }
		else
			if string.find(glrCharacter.Data.Messages.GuildAlerts.Both[1], L["GLR Title with Version"]) then
				local text = string.sub(glrCharacter.Data.Messages.GuildAlerts.Both[1], string.find(glrCharacter.Data.Messages.GuildAlerts.Both[1], 'v') + 1)
				if string.find(text, "3.0.6") then
					glrCharacter.Data.Messages.GuildAlerts.Both[1] = L["GLR Title with Version"] .. "%version"
				end
				if string.find(text, "3.0.61") then
					glrCharacter.Data.Messages.GuildAlerts.Both[1] = L["GLR Title with Version"] .. "%version"
				end
			end
		end
		if glrCharacter.Data.OtherStatus == nil then
			glrCharacter.Data.OtherStatus = {}
		end
		if glrCharacter.Data.OtherStatus.Lottery == nil then
			glrCharacter.Data.OtherStatus.Lottery = {}
		end
		if glrCharacter.Data.OtherStatus.Raffle == nil then
			glrCharacter.Data.OtherStatus.Raffle = {}
		end
		if glrCharacter.Lottery == nil then
			glrCharacter.Lottery = {}
		end
		if glrCharacter.Raffle == nil then
			glrCharacter.Raffle = {}
		end
		if glrCharacter.Event == nil then
			glrCharacter.Event = {}
		end
		if glrCharacter.Event.Lottery == nil then
			glrCharacter.Event.Lottery = {}
		end
		if glrCharacter.Event.Raffle == nil then
			glrCharacter.Event.Raffle = {}
		end
		if glrCharacter.Lottery.TicketPool == nil then
			glrCharacter.Lottery.TicketPool = {}
		end
		if glrCharacter.Raffle.TicketPool == nil then
			glrCharacter.Raffle.TicketPool = {}
		end
		if glrCharacter.Lottery.MessageStatus == nil then
			glrCharacter.Lottery.MessageStatus = {}
		end
		if glrCharacter.Raffle.MessageStatus == nil then
			glrCharacter.Raffle.MessageStatus = {}
		end
		if glrCharacter.Lottery.Entries == nil then
			glrCharacter.Lottery.Entries = {}
		end
		if glrCharacter.Lottery.Entries.TicketNumbers == nil then
			glrCharacter.Lottery.Entries.TicketNumbers = {}
		end
		if glrCharacter.Lottery.Entries.TicketRange == nil then
			glrCharacter.Lottery.Entries.TicketRange = {}
		end
		if glrCharacter.Lottery.Entries.Tickets == nil then
			glrCharacter.Lottery.Entries.Tickets = {}
		end
		if glrCharacter.Lottery.Entries.Names == nil then
			glrCharacter.Lottery.Entries.Names = {}
		end
		if glrCharacter.Raffle.Entries == nil then
			glrCharacter.Raffle.Entries = {}
		end
		if glrCharacter.Raffle.Entries.TicketNumbers == nil then
			glrCharacter.Raffle.Entries.TicketNumbers = {}
		end
		if glrCharacter.Raffle.Entries.TicketRange == nil then
			glrCharacter.Raffle.Entries.TicketRange = {}
		end
		if glrCharacter.Raffle.Entries.Tickets == nil then
			glrCharacter.Raffle.Entries.Tickets = {}
		end
		if glrCharacter.Raffle.Entries.Names == nil then
			glrCharacter.Raffle.Entries.Names = {}
		end
		if glrCharacter.PreviousEvent == nil then
			glrCharacter.PreviousEvent = {}
		end
		if glrCharacter.PreviousEvent.Lottery == nil then
			glrCharacter.PreviousEvent.Lottery = {}
		end
		if glrCharacter.PreviousEvent.Lottery.Available == nil then
			glrCharacter.PreviousEvent.Lottery.Available = false
		end
		if glrCharacter.PreviousEvent.Lottery.Data == nil then
			glrCharacter.PreviousEvent.Lottery.Data = {}
		end
		if glrCharacter.PreviousEvent.Lottery.Settings == nil then
			glrCharacter.PreviousEvent.Lottery.Settings = {}
		end
		if glrCharacter.PreviousEvent.Raffle == nil then
			glrCharacter.PreviousEvent.Raffle = {}
		end
		if glrCharacter.PreviousEvent.Raffle.Available == nil then
			glrCharacter.PreviousEvent.Raffle.Available = false
		end
		if glrCharacter.PreviousEvent.Raffle.Data == nil then
			glrCharacter.PreviousEvent.Raffle.Data = {}
		end
		if glrCharacter.PreviousEvent.Raffle.Settings == nil then
			glrCharacter.PreviousEvent.Raffle.Settings = {}
		end
		if glrCharacter.PreviousEvent.Lottery.Settings.WonType == nil then
			glrCharacter.PreviousEvent.Lottery.Settings.WonType = { [1] = true, [2] = false, }
		end
		if glrCharacter.PreviousEvent.Lottery.Settings.RoundValue == nil then
			if glrCharacter.PreviousEvent.Lottery.Settings.RoundJackpot ~= nil then
				if glrCharacter.PreviousEvent.Lottery.Settings.RoundJackpot then
					glrCharacter.PreviousEvent.Lottery.Settings.RoundValue = 2
				else
					glrCharacter.PreviousEvent.Lottery.Settings.RoundValue = 1
				end
				glrCharacter.PreviousEvent.Lottery.Settings.RoundJackpot = nil
			else
				glrCharacter.PreviousEvent.Lottery.Settings.RoundValue = 1
			end
		end
		if glrCharacter.PreviousEvent.Lottery.Settings.NoGuildCut == nil then
			glrCharacter.PreviousEvent.Lottery.Settings.NoGuildCut = false
		end
		if glrEvents ~= nil or glrRaffleData ~= nil or glrProfile ~= nil or glrLotteryEntries ~= nil or glrRaffleEntries ~= nil or glrTicketPool ~= nil or glrMessageStatus ~= nil then
			GLR_TransferTables()
		end
		
		GLR_U:UpdateMinimapIcon()
		GLR_U:ToggleEscapeKey()
		
		local message = ""
		if GLR_ReleaseState then
			message = string.gsub(L["GLR - Core - AddOn Loaded Message"], "%%version", GLR_Version)
		else
			if GLR_ReleaseType == "alpha" then
				message = string.gsub(L["GLR - Core - AddOn Loaded Message"], "%%version", GLR_Version .. "-a")
			elseif GLR_ReleaseType == "beta" then
				message = string.gsub(L["GLR - Core - AddOn Loaded Message"], "%%version", GLR_Version .. "-b")
			else
				message = string.gsub(L["GLR - Core - AddOn Loaded Message"], "%%version", GLR_Version .. "-nr")
			end
		end
		
		chat:AddMessage("|cfff7ff4d" .. message .. ".|r")
		
		Variables[3] = true
		
	end
	
end

Initalizeation:RegisterEvent("ADDON_LOADED")
Initalizeation:SetScript("OnEvent", GLR.Activation)

function GLR:SendDebug()
	local status = tostring(glrCharacter.Data.Settings.General.enabled)
	local lotterystate = tostring(glrCharacter.Data.Settings.CurrentlyActiveLottery)
	local rafflestate = tostring(glrCharacter.Data.Settings.CurrentlyActiveRaffle)
	C_ChatInfo.SendAddonMessage("GLR_DEBUG", FullPlayerName .. "!" .. GLR_VersionString .. "?" .. status .. "[" .. lotterystate .. "]" .. rafflestate .. "{", "GUILD")
end
function GLR:RunDebug()
	local count = 0
	local multi = glrCharacter.Data.Settings.General.MultiGuild
	local numTotalMembers, _, _ = GetNumGuildMembers()
	local status = glrCharacter.Data.Settings.General.enabled
	if status == nil then
		print("|cffffdf00Begin Guild Lottery & Raffle Debug Information...|r")
		print("AddOn Status nil")
		print("|cffffdf00...End Debug Information|r")
		return
	end
	if multi == nil then
		print("|cffffdf00Begin Guild Lottery & Raffle Debug Information...|r")
		print("Multi Status nil")
		print("|cffffdf00...End Debug Information|r")
		return
	end
	if multi then
		count = #glrMultiGuildRoster
	else
		count = #glrRoster
	end
	print("|cffffdf00Begin Guild Lottery & Raffles Debug Information...|r")
	print("AddOn State: |cffffdf00" .. tostring(status) .. "|r")
	print("Player: |cffffdf00" .. PlayerName .. "|r Realm Name: |cffffdf00" .. PlayerRealmName .. "|r Full Name: |cffffdf00" .. FullPlayerName .. "|r")
	print("Potential Entries: (|cffffdf00" .. count .. "|r) Guild Total: (|cffffdf00" .. numTotalMembers .. "|r) MultiGuild Status: |cffffdf00" .. tostring(multi) .. "|r")
	print("Locale: (|cffffdf00" .. GetLocale() .. "|r) Lottery Phrase: |cffffdf00" .. L["Detect Lottery"] .. "|r Raffle Phrase: |cffffdf00" .. L["Detect Raffle"] .. "|r")
	print("AddOn Version: |cffff0000" .. GLR_CurrentVersionString .. "|r Version String: |cffff0000" .. GLR_VersionString .. "|r")
	print("Critical Update State: |cffffdf00" .. tostring(Variables[1]) .. "|r")
	print("|cffffdf00...End Debug Information|r")
end

function GLR:CommandDebug()
	if GLR_Debug_Give then
		GLR_Debug_Give = false
	else
		GLR_Debug_Give = true
	end
end

function GLR:Success()
	GLR:Print("Success")
end

local function GLR_Round(num, Decimals)
	local mod = 10 ^ (Decimals or 0)
	return math.floor(num * mod + 0.5) / mod
end

---------------------------------------------
------------ SECURE UI ELEMENTS -------------
---------------------------------------------

local Frames = {}
local BackdropFrames = {}

-- Lottery UI Elements
-- Add Player
local ConfirmAddPlayerToLotteryButton = CreateFrame("Button", "ConfirmAddPlayerToLotteryButton", GLR_UI.GLR_AddPlayerToLotteryFrame, "GameMenuButtonTemplate")
ConfirmAddPlayerToLotteryButton:SetPoint("BOTTOM", GLR_UI.GLR_AddPlayerToLotteryFrame, "BOTTOM", 0, 10)
ConfirmAddPlayerToLotteryButton:SetSize(100, 26)
ConfirmAddPlayerToLotteryButton:SetScript("OnClick", function(self)
	local targets = GenerateRosterNames()
	local continue = false
	local text = GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_AddPlayerNameToLotteryEditBox:GetText()
	for i = 1, #targets do
		local target = string.sub(targets[i], 1, string.find(targets[i], '%.') - 1)
		if text == target then
			continue = true
			break
		end
	end
	if continue then
		AddPlayerToEvent("Lottery")
	else
		GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ExceededParameters:SetText(L["No Player Found"])
	end
end)
ConfirmAddPlayerToLotteryButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm Add Player to Lottery Button Tooltip"])
	GameTooltip:Show()
end)
ConfirmAddPlayerToLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.ConfirmAddPlayerToLotteryButton = CreateFrame("Frame", "BackdropFramesGLR_ConfirmNewRaffleButton", ConfirmAddPlayerToLotteryButton, "BackdropTemplate")
	BackdropFrames.ConfirmAddPlayerToLotteryButton:SetAllPoints()
	BackdropFrames.ConfirmAddPlayerToLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.ConfirmAddPlayerToLotteryButton:ApplyBackdrop()
	BackdropFrames.ConfirmAddPlayerToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	ConfirmAddPlayerToLotteryButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	ConfirmAddPlayerToLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

local ConfirmAddPlayerToLotteryButtonText = ConfirmAddPlayerToLotteryButton:CreateFontString("ConfirmAddPlayerToLotteryButtonText", "OVERLAY", "GameFontWhiteTiny")
ConfirmAddPlayerToLotteryButtonText:SetPoint("CENTER", ConfirmAddPlayerToLotteryButton)
ConfirmAddPlayerToLotteryButtonText:SetText(L["Confirm Add Player Button"])
ConfirmAddPlayerToLotteryButtonText:SetFont(GLR_UI.ButtonFont, 11)

-- Edit Player
local ConfirmEditLotteryPlayerButton = CreateFrame("Button", "ConfirmEditLotteryPlayerButton", GLR_UI.GLR_EditPlayerInLotteryFrame, "GameMenuButtonTemplate")
ConfirmEditLotteryPlayerButton:SetPoint("BOTTOM", GLR_UI.GLR_EditPlayerInLotteryFrame, "BOTTOM", 0, 10)
ConfirmEditLotteryPlayerButton:SetSize(100, 26)
ConfirmEditLotteryPlayerButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox.GLR_EditPlayerNameInLotterySelectionMenu:Hide()
	local name = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
	if name == "" or name == "No Entries Found" then
		GLR_UI.GLR_EditPlayerInLotteryFrame:Hide()
	else
		local targets = GenerateRosterNames()
		local continue = false
		local text = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
		for i = 1, #targets do
			local target = string.sub(targets[i], 1, string.find(targets[i], '%.') - 1)
			if text == target then
				continue = true
				break
			end
		end
		if continue then
			ChangePlayerInEventInfo("Lottery")
		else
			GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ExceededLotteryTickets:SetText(L["No Player Found"])
		end
	end
end)
ConfirmEditLotteryPlayerButton:SetScript("OnEnter", function(self)
	local name = GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedPlayerEditBox:GetText()
	if name == "" or name == L["GLR - Error - No Entries Found"] then
		name = "Player"
	end
	local text = string.gsub(L["Confirm Edit Player Button Tooltip"], "%%name", name)
	text = string.gsub(text, "%%event", L["Lottery"])
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(text)
	GameTooltip:Show()
end)
ConfirmEditLotteryPlayerButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.ConfirmEditLotteryPlayerButton = CreateFrame("Frame", "BackdropFramesGLR_ConfirmNewRaffleButton", ConfirmEditLotteryPlayerButton, "BackdropTemplate")
	BackdropFrames.ConfirmEditLotteryPlayerButton:SetAllPoints()
	BackdropFrames.ConfirmEditLotteryPlayerButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.ConfirmEditLotteryPlayerButton:ApplyBackdrop()
	BackdropFrames.ConfirmEditLotteryPlayerButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	ConfirmEditLotteryPlayerButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	ConfirmEditLotteryPlayerButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

local ConfirmEditLotteryPlayerButtonText = ConfirmEditLotteryPlayerButton:CreateFontString("ConfirmEditLotteryPlayerButtonText", "OVERLAY", "GameFontWhiteTiny")
ConfirmEditLotteryPlayerButtonText:SetPoint("CENTER", ConfirmEditLotteryPlayerButton)
ConfirmEditLotteryPlayerButtonText:SetText(L["Confirm Edit Player Button"])
ConfirmEditLotteryPlayerButtonText:SetFont(GLR_UI.ButtonFont, 11)

-- Raffle UI Elements
-- Add Player
local ConfirmAddPlayerToRaffleButton = CreateFrame("Button", "ConfirmAddPlayerToRaffleButton", GLR_UI.GLR_AddPlayerToRaffleFrame, "GameMenuButtonTemplate")
ConfirmAddPlayerToRaffleButton:SetPoint("BOTTOM", GLR_UI.GLR_AddPlayerToRaffleFrame, "BOTTOM", 0, 10)
ConfirmAddPlayerToRaffleButton:SetSize(100, 26)
ConfirmAddPlayerToRaffleButton:SetScript("OnClick", function(self)
	local targets = GenerateRosterNames()
	local continue = false
	local text = GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_AddPlayerNameToRaffleEditBox:GetText()
	for i = 1, #targets do
		local target = string.sub(targets[i], 1, string.find(targets[i], '%.') - 1)
		if text == target then
			continue = true
			break
		end
	end
	if continue then
		AddPlayerToEvent("Raffle")
	else
		GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ExceededParameters:SetText(L["No Player Found"])
	end
end)
ConfirmAddPlayerToRaffleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm Add Player to Raffle Button Tooltip"])
	GameTooltip:Show()
end)
ConfirmAddPlayerToRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.ConfirmAddPlayerToRaffleButton = CreateFrame("Frame", "BackdropFramesGLR_ConfirmNewRaffleButton", ConfirmAddPlayerToRaffleButton, "BackdropTemplate")
	BackdropFrames.ConfirmAddPlayerToRaffleButton:SetAllPoints()
	BackdropFrames.ConfirmAddPlayerToRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.ConfirmAddPlayerToRaffleButton:ApplyBackdrop()
	BackdropFrames.ConfirmAddPlayerToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	ConfirmAddPlayerToRaffleButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	ConfirmAddPlayerToRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

local ConfirmAddPlayerToRaffleButtonText = ConfirmAddPlayerToRaffleButton:CreateFontString("ConfirmAddPlayerToRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
ConfirmAddPlayerToRaffleButtonText:SetPoint("CENTER", ConfirmAddPlayerToRaffleButton)
ConfirmAddPlayerToRaffleButtonText:SetText(L["Confirm Add Player Button"])
ConfirmAddPlayerToRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

-- Edit Player
local ConfirmEditRafflePlayerButton = CreateFrame("Button", "ConfirmEditRafflePlayerButton", GLR_UI.GLR_EditPlayerInRaffleFrame, "GameMenuButtonTemplate")
ConfirmEditRafflePlayerButton:SetPoint("BOTTOM", GLR_UI.GLR_EditPlayerInRaffleFrame, "BOTTOM", 0, 10)
ConfirmEditRafflePlayerButton:SetSize(100, 26)
ConfirmEditRafflePlayerButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox.GLR_EditPlayerNameInRaffleSelectionMenu:Hide()
	local name = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
	if name == "" or name == L["GLR - Error - No Entries Found"] then
		GLR_UI.GLR_EditPlayerInRaffleFrame:Hide()
	else
		local targets = GenerateRosterNames()
		local continue = false
		local text = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
		for i = 1, #targets do
			local target = string.sub(targets[i], 1, string.find(targets[i], '%.') - 1)
			if text == target then
				continue = true
				break
			end
		end
		if continue then
			ChangePlayerInEventInfo("Raffle")
		else
			GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ExceededRaffleTickets:SetText(L["No Player Found"])
		end
	end
end)
ConfirmEditRafflePlayerButton:SetScript("OnEnter", function(self)
	local name = GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerEditBox:GetText()
	if name == "" or name == "No Entries Found" then
		name = "Player"
	end
	local text = string.gsub(L["Confirm Edit Player Button Tooltip"], "%%name", name)
	text = string.gsub(text, "%%event", L["Raffle"])
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(text)
	GameTooltip:Show()
end)
ConfirmEditRafflePlayerButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.ConfirmEditRafflePlayerButton = CreateFrame("Frame", "BackdropFramesGLR_ConfirmNewRaffleButton", ConfirmEditRafflePlayerButton, "BackdropTemplate")
	BackdropFrames.ConfirmEditRafflePlayerButton:SetAllPoints()
	BackdropFrames.ConfirmEditRafflePlayerButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.ConfirmEditRafflePlayerButton:ApplyBackdrop()
	BackdropFrames.ConfirmEditRafflePlayerButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	ConfirmEditRafflePlayerButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	ConfirmEditRafflePlayerButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

local ConfirmEditRafflePlayerButtonText = ConfirmEditRafflePlayerButton:CreateFontString("ConfirmEditRafflePlayerButtonText", "OVERLAY", "GameFontWhiteTiny")
ConfirmEditRafflePlayerButtonText:SetPoint("CENTER", ConfirmEditRafflePlayerButton)
ConfirmEditRafflePlayerButtonText:SetText(L["Confirm Edit Player Button"])
ConfirmEditRafflePlayerButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm Event UI Elements
--Confirm Lottery Frame
local GLR_ConfirmNewLotteryFrame
if GLR_GameVersion == "RETAIL" then
	GLR_ConfirmNewLotteryFrame = CreateFrame("Frame", "GLR_ConfirmNewLotteryFrame", GLR_UI.GLR_NewLotteryEventFrame, "BackdropTemplate")
else
	GLR_ConfirmNewLotteryFrame = CreateFrame("Frame", "GLR_ConfirmNewLotteryFrame", GLR_UI.GLR_NewLotteryEventFrame)
end
GLR_ConfirmNewLotteryFrame:SetPoint("TOP", GLR_UI.GLR_NewLotteryEventFrame, "BOTTOM", 0, -5)
GLR_ConfirmNewLotteryFrame:SetSize(140, 50)
GLR_ConfirmNewLotteryFrame:EnableMouse(true)
GLR_ConfirmNewLotteryFrame:SetMovable(false)
GLR_ConfirmNewLotteryFrame:SetResizable(false)
GLR_ConfirmNewLotteryFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_ConfirmNewLotteryFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_ConfirmNewLotteryFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_ConfirmNewLotteryFrame:Hide()

--Confirm Lottery Button
local GLR_ConfirmNewLotteryButton = CreateFrame("Button", "GLR_ConfirmNewLotteryButton", GLR_ConfirmNewLotteryFrame, "GameMenuButtonTemplate")
GLR_ConfirmNewLotteryButton:SetPoint("CENTER", GLR_ConfirmNewLotteryFrame, "CENTER")
GLR_ConfirmNewLotteryButton:SetSize(100, 26)
GLR_ConfirmNewLotteryButton:SetScript("OnClick", function(self)
	GLR_ConfirmNewLotteryFrame:Hide()
	GLR_UI.GLR_NewLotteryEventFrame:Hide()
	SetNewEventSettings("Lottery")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryNameEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:SetText("00")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:SetText("00")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketGoldPriceEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketSilverPriceEditBox:SetText("00")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryTicketCopperPriceEditBox:SetText("00")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetText("")
	GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText("")
end)
GLR_ConfirmNewLotteryButton:SetScript("OnEnter", function(self)
	ConfirmNewLotterySettings()
	local GuildPercent = 0
	local SecondPercent = 0
	local GuildCut = "0" .. string.lower(L["Value_Gold_Short_Colored"]) .. " 00" .. string.lower(L["Value_Silver_Short_Colored"]) .. " 00" .. string.lower(L["Value_Copper_Short_Colored"])
	local SecondCut = "0" .. string.lower(L["Value_Gold_Short_Colored"]) .. " 00" .. string.lower(L["Value_Silver_Short_Colored"]) .. " 00" .. string.lower(L["Value_Copper_Short_Colored"])
	local parse = 0
	if Variables[13][1] == 0 then
		local round = glrCharacter.Data.Settings.Lottery.RoundValue
		local StartingAmount =  glrCharacter.Data.Settings.PreviousLottery.Jackpot + tonumber( GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingGoldEditBox:GetText() .. "." .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingSilverEditBox:GetText() .. GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryStartingCopperEditBox:GetText() )
		Variables[11] = GLR_U:GetMoneyValue(StartingAmount, "Lottery", true, 1, "NA", true, true, true)
		if tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:GetText()) ~= nil then
			GuildPercent = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:GetText())
			parse = StartingAmount * (GuildPercent / 100)
			GuildCut = GLR_U:GetMoneyValue(parse, "Lottery", true, round, "NA", true, true, true)
		end
		if not GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetChecked() then
			if tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:GetText()) ~= nil then
				SecondPercent = tonumber(GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:GetText())
				parse = StartingAmount * (SecondPercent / 100)
				SecondCut = GLR_U:GetMoneyValue(parse, "Lottery", true, round, "NA", true, true, true)
			end
		end
	end
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm New Lottery Button Tooltip"])
	GameTooltip:AddLine("")
	GameTooltip:AddLine("|cffffffffThis Events Jackpot Starts At:|r " .. Variables[11])
	GameTooltip:AddLine("|cffffffffThe Guilds Take: " .. GuildPercent .. "% -|r " .. GuildCut)
	if not GLR_UI.GLR_NewLotteryEventFrame.GLR_GuaranteeWinnerCheckButton:GetChecked() then
		GameTooltip:AddLine("|cffffffffSecond Place: " .. SecondPercent .. "% -|r " .. SecondCut)
	else
		GameTooltip:AddLine("|cffffffffSecond Place: " .. L["Winner Guaranteed"])
	end
	GameTooltip:AddLine("")
	GameTooltip:AddLine(L["Confirm New Lottery Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
GLR_ConfirmNewLotteryButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.GLR_ConfirmNewLotteryButton = CreateFrame("Frame", "BackdropFrames.GLR_ConfirmNewLotteryButton", GLR_ConfirmNewLotteryButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmNewLotteryButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmNewLotteryButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmNewLotteryButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmNewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	GLR_ConfirmNewLotteryButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	GLR_ConfirmNewLotteryButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

local GLR_ConfirmActionButtonText = GLR_ConfirmNewLotteryButton:CreateFontString("GLR_ConfirmActionButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_ConfirmActionButtonText:SetPoint("CENTER", GLR_ConfirmNewLotteryButton)
GLR_ConfirmActionButtonText:SetText(L["Confirm Action Button"])
GLR_ConfirmActionButtonText:SetFont(GLR_UI.ButtonFont, 11)

--Confirm New Raffle Frame & Settings
local GLR_ConfirmNewRaffleFrame
if GLR_GameVersion == "RETAIL" then
	GLR_ConfirmNewRaffleFrame = CreateFrame("Frame", "GLR_ConfirmNewRaffleFrame", GLR_UI.GLR_NewRaffleEventFrame, "BackdropTemplate")
else
	GLR_ConfirmNewRaffleFrame = CreateFrame("Frame", "GLR_ConfirmNewRaffleFrame", GLR_UI.GLR_NewRaffleEventFrame)
end
GLR_ConfirmNewRaffleFrame:SetPoint("TOP", GLR_UI.GLR_NewRaffleEventFrame, "BOTTOM", 0, -5)
GLR_ConfirmNewRaffleFrame:SetSize(140, 50)
GLR_ConfirmNewRaffleFrame:EnableMouse(true)
GLR_ConfirmNewRaffleFrame:SetMovable(false)
GLR_ConfirmNewRaffleFrame:SetResizable(false)
GLR_ConfirmNewRaffleFrame:SetBackdrop({
	bgFile = profile.frames.outside.bgFile,
	edgeFile = profile.frames.outside.edgeFile,
	edgeSize = profile.frames.outside.edgeSize,
	insets = profile.frames.outside.insets
})
GLR_ConfirmNewRaffleFrame:SetBackdropColor(unpack(profile.colors.frames.outside.bgcolor))
GLR_ConfirmNewRaffleFrame:SetBackdropBorderColor(unpack(profile.colors.frames.outside.bordercolor))
GLR_ConfirmNewRaffleFrame:Hide()

--Confirm New Raffle Button
local GLR_ConfirmNewRaffleButton = CreateFrame("Button", "GLR_ConfirmNewRaffleButton", GLR_ConfirmNewRaffleFrame, "GameMenuButtonTemplate")
GLR_ConfirmNewRaffleButton:SetPoint("CENTER", GLR_ConfirmNewRaffleFrame, "CENTER")
GLR_ConfirmNewRaffleButton:SetSize(100, 26)
GLR_ConfirmNewRaffleButton:SetScript("OnClick", function(self)
	GLR_ConfirmNewRaffleFrame:Hide()
	GLR_UI.GLR_NewRaffleEventFrame:Hide()
	SetNewEventSettings("Raffle")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleNameEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleTicketGoldPriceEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleFirstPlaceEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleSecondPlaceEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleThirdPlaceEditBox:SetText("")
	GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
end)
GLR_ConfirmNewRaffleButton:SetScript("OnEnter", function(self)
	ConfirmNewRaffleSettings()
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText(L["GLR Tooltip Title"], 0.97, 1, 0.30)
	GameTooltip:AddLine(L["Confirm New Raffle Button Tooltip"])
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Raffle Prizes:")
	if Variables[14][1] ~= false then
		local first = Variables[14][1]
		if Variables[14][1] == "%raffle_total" then
			first = "Total Ticket Sales Value"
		elseif Variables[14][1] == "%raffle_half" then
			first = "Half of Ticket Sales Value"
		elseif Variables[14][1] == "%raffle_quarter" then
			first = "Quarter of Ticket Sales Value"
		elseif tonumber(Variables[14][1]) ~= nil then
			first = GLR_U:GetMoneyValue(tonumber(Variables[14][1]), "Raffle", false, 1, "NA", true, true, true)
		end
		GameTooltip:AddLine("1st Place: " .. first)
	end
	if Variables[14][2] ~= false then
		local second = Variables[14][2]
		if Variables[14][2] == "%raffle_total" then
			second = "Total Ticket Sales Value"
		elseif Variables[14][2] == "%raffle_half" then
			second = "Half of Ticket Sales Value"
		elseif Variables[14][2] == "%raffle_quarter" then
			second = "Quarter of Ticket Sales Value"
		elseif tonumber(Variables[14][2]) ~= nil then
			second = GLR_U:GetMoneyValue(tonumber(Variables[14][2]), "Raffle", false, 1, "NA", true, true, true)
		end
		GameTooltip:AddLine("2nd Place: " .. second)
	end
	if Variables[14][3] ~= false then
		local third = Variables[14][3]
		if Variables[14][3] == "%raffle_total" then
			third = "Total Ticket Sales Value"
		elseif Variables[14][3] == "%raffle_half" then
			third = "Half of Ticket Sales Value"
		elseif Variables[14][3] == "%raffle_quarter" then
			third = "Quarter of Ticket Sales Value"
		elseif tonumber(Variables[14][3]) ~= nil then
			third = GLR_U:GetMoneyValue(tonumber(Variables[14][3]), "Raffle", false, 1, "NA", true, true, true)
		end
		GameTooltip:AddLine("3rd Place: " .. third)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["Confirm New Raffle Button Tooltip Warning"], 1, 0, 0)
	GameTooltip:Show()
end)
GLR_ConfirmNewRaffleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

if GLR_GameVersion == "RETAIL" then
	BackdropFrames.GLR_ConfirmNewRaffleButton = CreateFrame("Frame", "BackdropFramesGLR_ConfirmNewRaffleButton", GLR_ConfirmNewRaffleButton, "BackdropTemplate")
	BackdropFrames.GLR_ConfirmNewRaffleButton:SetAllPoints()
	BackdropFrames.GLR_ConfirmNewRaffleButton.backdropInfo = BackdropProfile.Buttons
	BackdropFrames.GLR_ConfirmNewRaffleButton:ApplyBackdrop()
	BackdropFrames.GLR_ConfirmNewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
else
	GLR_ConfirmNewRaffleButton:SetBackdrop({
		edgeFile = profile.buttons.edgeFile,
		edgeSize = profile.buttons.edgeSize,
	})
	GLR_ConfirmNewRaffleButton:SetBackdropBorderColor(unpack(profile.colors.buttons.bordercolor))
end

--Confirm New Raffle Button String & Settings
GLR_ConfirmNewRaffleButtonText = GLR_ConfirmNewRaffleButton:CreateFontString("GLR_ConfirmNewRaffleButtonText", "OVERLAY", "GameFontWhiteTiny")
GLR_ConfirmNewRaffleButtonText:SetPoint("CENTER", GLR_ConfirmNewRaffleButton)
GLR_ConfirmNewRaffleButtonText:SetText(L["Confirm Action Button"])
GLR_ConfirmNewRaffleButtonText:SetFont(GLR_UI.ButtonFont, 11)

---------------------------------------------
------------ SECURE UI ELEMENTS -------------
----------------- SCRIPTS -------------------
---------------------------------------------

--Start New Lottery Button Script
GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetScript("OnClick", function(self)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText("")
	GLR_ConfirmNewLotteryFrame:Hide()
	ConfirmNewLotterySettings()
end)

--Start New Raffle Button Script
GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetScript("OnClick", function(self)
	ConfirmNewRaffleSettings()
end)

--Confirm New Lottery Border Frame Script
GLR_ConfirmNewLotteryFrame:SetScript("OnKeyDown", function(_, key)
	GLR_ConfirmNewLotteryFrame:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_ConfirmNewLotteryFrame:SetPropagateKeyboardInput(false)
		GLR_ConfirmNewLotteryFrame:Hide()
	end
end)

--Confirm New Raffle Border Frame Script
GLR_ConfirmNewRaffleFrame:SetScript("OnKeyDown", function(_, key)
	GLR_ConfirmNewRaffleFrame:SetPropagateKeyboardInput(true)
	if key == "ESCAPE" then
		GLR_ConfirmNewRaffleFrame:SetPropagateKeyboardInput(false)
		GLR_ConfirmNewRaffleFrame:Hide()
	end
end)

--New Lottery Frame Script
GLR_UI.GLR_NewLotteryEventFrame:SetScript("OnHide", function(self)
	GLR_ConfirmNewLotteryFrame:Hide()
	GLR_UI.GLR_NewLotteryEventFrame.GLR_InvalidOption:SetText("")
end)

--New Lottery Max Tickets Edit Box Script
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryMaxTicketsEditBox:SetScript("OnTextChanged", function(self)
	if GLR_ConfirmNewLotteryFrame:IsVisible() then
		GLR_ConfirmNewLotteryFrame:Hide()
	end
end)
--New Lottery Second Place Edit Box Script
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotterySecondPlaceEditBox:SetScript("OnTextChanged", function(self)
	if GLR_ConfirmNewLotteryFrame:IsVisible() then
		GLR_ConfirmNewLotteryFrame:Hide()
	end
end)
--New Lottery Guild Cut Edit Box Script
GLR_UI.GLR_NewLotteryEventFrame.GLR_NewLotteryGuildCutEditBox:SetScript("OnTextChanged", function(self)
	if GLR_ConfirmNewLotteryFrame:IsVisible() then
		GLR_ConfirmNewLotteryFrame:Hide()
	end
end)

--New Raffle Frame Script
GLR_UI.GLR_NewRaffleEventFrame:SetScript("OnHide", function(self)
	GLR_ConfirmNewRaffleFrame:Hide()
	GLR_UI.GLR_NewRaffleEventFrame.GLR_InvalidOption:SetText("")
end)

--New Raffle Max Tickets Edit Box Script
GLR_UI.GLR_NewRaffleEventFrame.GLR_NewRaffleMaxTicketsEditBox:SetScript("OnTextChanged", function(self)
	if GLR_ConfirmNewRaffleFrame:IsVisible() then
		GLR_ConfirmNewRaffleFrame:Hide()
	end
end)

-- Debugging
function GLR:DoDebug()
	local count = 0
	for t, v in pairs(glrHistory.GuildRoster) do
		local c = 0
		for k, e in pairs(glrHistory.GuildRoster[t]) do
			count = count + #glrHistory.GuildRoster[t][k]
			c = c + 1
			GLR:Print("Entered " .. tostring(k) .. " with: " .. #glrHistory.GuildRoster[t][k] .. " Entries")
		end
		GLR:Print("Total " .. tostring(t) .. ": " .. c)
	end
	GLR:Print(count)
end

--[[

]]
