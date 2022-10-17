local L = LibStub("AceLocale-3.0"):NewLocale("GuildLotteryRaffle", "enUS", true)

local GLR_VersionText = GetAddOnMetadata("GuildLotteryRaffle", "Version")

--[[
Locale labels have changed to more accurately reflect where they appear in game.
For example: L["GLR - Core - Disabled Message"]
GLR will always appear at the beginning
Core - The text is used outside the custom UI for GLR, such as the user's chat frame.
	Reply - The text is used when sending messages to players, through either a reply or starting a conversation.
	Chat - The text is used when sending messages to Guild chat.
Error - The text is found either in the user's chat frame or as a string shown in the custom UI to denote something as wrong.
Comms - The text is used in cross character communication between players of the AddOn (silent comms).
UI - Text will be displayed somewhere on the custom UI, this will always be followed with a '>' to denote where specifically. For example: L["Guild Lottery & Raffles"] is shown on the "Main" UI.

Exceptions are made for certain entries to allow for ease of coding, such as L["Lottery"] or L["Detect Lottery"] etc.
]]

-- Addon DEFAULT_CHAT_FRAME Translations
L["GLR - Core - Disabled Message"] = "AddOn is disabled, please enable it to begin a Lottery/Raffle"
L["GLR - Core - Disabled No Guild Message"] = "You must be in a Guild to use this Addon."
L["GLR - Core - Invalid Raffle Item"] = "Invalid Raffle Item Detected"
L["GLR - Core - Critical Update Detected"] = "Please restart WoW for critical AddOn updates to take affect."

-- Addon Error/Completion Message Translations
L["GLR - Error - Zero Entries"] = "Can't start event with zero entries"
L["GLR - Error - No Jackpot"] = "Can't start event with no prize to give!"
L["GLR - Error - No Entries Found"] = "No Entries Found"
L["GLR - UI > Config > Events - Confirm Cancel"] = "Confirm Cancel"
L["GLR - UI > Config - Confirm Action"] = "Confirm Action"
L["GLR - UI > Config > Events - Confirm Cancel Desc"] = "Must be checked to cancel current event"
L["GLR - Core - Confirm Cancel False"] = "Checkbox must be ticked, confirming you wish to cancel the event."
L["GLR - Core - Lottery Canceled Message"] = "Current Lottery Event Canceled"
L["GLR - Core - Raffle Canceled Message"] = "Current Raffle Event Canceled"
L["GLR - Core - AddOn Loaded Message"] = "Guild Lottery & Raffle AddOn Version %version Loaded Successfully"
L["GLR - Error - Cant Create Calendar Events"] = "You are unable to create Guild Events. Please contact your Guild Master to correct this."
L["GLR - Error - Calendar Events Disabled"] = "Creation of Calendar Events is disabled. Please enable it (Toggle Calendar Events) to create a Guild Calendar Event."
L["GLR - Core - Initialization Complete"] = "Initialization Complete! Roster Data Updated."
L["GLR - Core - Invalid Player Entry Detected"] = "%n - Did not detect this player as a valid entry; they were removed from your current %e Event."

-- Addon Slash Command Detection
L["Toggle"] = "Toggle"

-- Addon Communication Message Translations
L["GLR - Comms - Your Version Outdated"] = "Your Version %version_current is outdated. %version_new is available for download."
L["GLR - Comms - Others Version Outdated"] = "%name has an outdated version. Tell them to update!"

-- Custom Whisper Message Default
L["GLR - Core - Whisper Default"] = "Default messages via Whisper are always sent. Any message typed here is sent after.\n\nSimply press ENTER to perform a line break, starting a new message. Multiple line breaks will not result in blank messages."
L["GLR - Core - Whisper Description"] = '|cFF87CEFAExample:|r\nSend %tickets_price via mail with the subject as "%mail_default" to receive 1 Ticket in the %e Event.\n\n|cFF87CEFABecomes:|r\nSend %tp via mail with the subject as "%md" to receive 1 Ticket in the %e Event.'
L["Configuration Panel Whispers Tab Formats Lottery"] = "Available Formats:\n|cFF87CEFA  %version |r-> Becomes: %vs\n|cFF87CEFA  %event_name |r-> Becomes the Name of your Event.\n|cFF87CEFA  %event_date |r-> Becomes the Date for your Event.\n|cFF87CEFA  %reply_default |r-> The default reply phrase.\n|cFF87CEFA  %mail_default |r-> The default subject phrase for Mails.\n|cFF87CEFA  %reply_phrases |r-> A comma separated string of your reply phrases (includes default).\n|cFF87CEFA  %mail_phrases |r-> A comma separated string of applicable subject phrases for Mails (one phrase per Mail Subject).\n|cFF87CEFA  %tickets_price |r-> Becomes the Ticket Cost for your Event.\n|cFF87CEFA  %tickets_max |r-> Becomes the Maximum Tickets a Player can have.\n|cFF87CEFA  %tickets_sold |r-> The number of Tickets Sold.\n|cFF87CEFA  %tickets_given |r-> The number of Tickets Given away.\n|cFF87CEFA  %tickets_total |r-> Number of Tickets Sold & Given away.\n|cFF87CEFA  %tickets_value |r-> Total value of Tickets Sold.\n|cFF87CEFA  %tickets_current |r-> Current number of Tickets the Player has.\n|cFF87CEFA  %tickets_difference |r-> Number of Tickets a Player can receive before reaching the Maximum.\n|cFF87CEFA  %jackpot_start |r-> The starting value of your Lottery Event.\n|cFF87CEFA  %jackpot_total |r-> The total Jackpot value.\n|cFF87CEFA  %jackpot_guild |r-> Value of the Jackpot your Guild receives.\n|cFF87CEFA  %jackpot_first |r-> Value of the Jackpot should someone win.\n|cFF87CEFA  %jackpot_second |r-> Value of the Jackpot should a Second Place be drawn (if no one was drawn for First Place).\n|cFF87CEFA  %percent_guild |r-> The Guild Cut value entered when creating a New Event.\n|cFF87CEFA  %percent_second |r-> The Second Place Prize value entered when creating a New Event.\n"
L["Configuration Panel Whispers Tab Formats Raffle"] = "Available Formats:\n|cFF87CEFA  %version |r-> Becomes: %vs\n|cFF87CEFA  %event_name |r-> Becomes the Name of your Event.\n|cFF87CEFA  %event_date |r-> Becomes the Date for your Event.\n|cFF87CEFA  %reply_default |r-> The default reply phrase.\n|cFF87CEFA  %mail_default |r-> The default subject phrase for Mails.\n|cFF87CEFA  %reply_phrases |r-> A comma separated string of your reply phrases (includes default).\n|cFF87CEFA  %mail_phrases |r-> A comma separated string of applicable subject phrases for Mails (one phrase per Mail Subject).\n|cFF87CEFA  %tickets_price |r-> Becomes the Ticket Cost for your Event.\n|cFF87CEFA  %tickets_max |r-> Becomes the Maximum Tickets a Player can have.\n|cFF87CEFA  %tickets_sold |r-> The number of Tickets Sold.\n|cFF87CEFA  %tickets_given |r-> The number of Tickets Given away.\n|cFF87CEFA  %tickets_total |r-> Number of Tickets Sold & Given away.\n|cFF87CEFA  %tickets_value |r-> Total value of Tickets Sold.\n|cFF87CEFA  %tickets_current |r-> Current number of Tickets the Player has.\n|cFF87CEFA  %tickets_difference |r-> Number of Tickets a Player can receive before reaching the Maximum.\n|cFF87CEFA  %raffle_prizes |r-> A comma separated string of current Raffle Prizes.\n|cFF87CEFA  %raffle_first |r-> The First Place Prize.\n|cFF87CEFA  %raffle_second |r-> The Second Place Prize, if available.\n|cFF87CEFA  %raffle_third |r-> The Third Place Prize, if available."
L["Configuration Panel Whispers Profile Copy Lottery Desc"] = "Copy a existing Lottery Whispers Profile"
L["Configuration Panel Whispers Profile Copy Raffle Desc"] = "Copy a existing Raffle Whispers Profile"

-- Ticket Giveaway Message Translations
L["GLR - Core - Ticket Giveaway"] = "Ticket Giveaway! Players will receive up to %PlayerTickets %word for the current %name event."
L["GLR - Core - Random Ticket Giveaway"] = "Ticket Giveaway! %PlayerTickets %word will be randomly given for the current %name event."
L["GLR - Core - Ticket Giveaway Rank Based"] = "Those with the following ranks will receive free tickets!"
L["GLR - Core - Random Ticket Giveaway Rank Based"] = "Those with the following ranks have a chance to receive free tickets!"
L["GLR - Core - Ticket Giveaway Singular"] = "ticket"
L["GLR - Core - Ticket Giveaway Plural"] = "tickets"
L["GLR - UI > Config > Giveaway - Select Event"] = "Select Event"
L["GLR - UI > Config > Giveaway - Type"] = "Select Giveaway Type"
L["GLR - UI > Config > Giveaway - Type Desc"] = "Options are:\n- Everyone\n- By Rank\n\nIf doing By Rank, you will need to select below which ranks are valid for receiving the free Tickets."
L["GLR - UI > Config > Giveaway - Online"] = "Online Status"
L["GLR - UI > Config > Giveaway - Online Desc"] = "If set to Currently Online, this will only give Tickets to Players in your Guild that're Online.\n\nIf you're hosting Multi-Guild Events and set this to any 'Last X Days', accuracy cannot be guaranteed as Last Online data is saved when your Character was online in the Linked Guild.\n\n'Currently Online' is not available for Multi-Guild Events."
L["GLR - UI > Config > Giveaway - Start"] = "Start Giveaway"
L["GLR - UI > Config > Giveaway - Start Desc"] = "This process may take some time"
L["GLR - UI > Config > Giveaway - Tickets"] = "Give Away Tickets"
L["GLR - UI > Config > Giveaway - Tickets Desc"] = "Entered amount will give all valid Entries at most %t Ticket(s)"
L["GLR - UI > Config > Giveaway - No Event Active"] = "No Event Active"
L["GLR - UI > Config > Giveaway - Everyone"] = "Everyone"
L["GLR - UI > Config > Giveaway - By Rank"] = "By Rank"
L["GLR - UI > Config > Giveaway - Currently Online"] = "Currently Online"
L["GLR - UI > Config > Giveaway - 7 Days"] = "Last 7 Days"
L["GLR - UI > Config > Giveaway - 14 Days"] = "Last 14 Days"
L["GLR - UI > Config > Giveaway - 21 Days"] = "Last 21 Days"
L["GLR - UI > Config > Giveaway - 28 Days"] = "Last 28 Days"
L["GLR - UI > Config > Giveaway - Names Available"] = "Names Available for Entry"
L["GLR - UI > Config > Giveaway - Total Tickets To Give"] = "Total Tickets to Giveaway"
L["GLR - UI > Config > Giveaway - Select Rank"] = "Select Rank(s)"
L["GLR - UI > Config > Giveaway - Select Guild"] = "Select Guild For Ranks"
L["GLR - UI > Config > Giveaway - Select Ranks Desc"] = "Select which Rank(s) should be eligible for Ticket(s)."
L["GLR - UI > Config > Giveaway - Select Guild Desc"] = "Select which Guild, then which Rank(s) should be eligible for Ticket(s).\n\nMultiple Guilds can be done at the same time."

-- Data Export Translations
L["GLR - UI > StaticPopupDialog - Copy Text"] = "Copy the following to your Clipboard (CTRL+C):"
L["GLR - UI > Config > Events > Data Export - Button"] = "Export Data"
L["GLR - UI > Config > Events > Data Export - Button Tooltip"] = "Export Previous %e Event Data"

-- Event Settings Translations
L["GLR - UI > Config > Events > Raffle - Inverse Announce Order"] = "Inverse Announce Order"
L["GLR - UI > Config > Events > Raffle - Inverse Announce Order Tooltip"] = "By default, when announcing Raffle winners, the AddOn first reports:\n   1st -> 2nd -> 3rd\nBy checking this box, the AddOn will announce:\n   3rd -> 2nd -> 1st"

-- Frame Title Font String Translations
L["Guild Lottery & Raffles"] = true -- Title of the mod. Set to true as it won't be translated.
L["GLR - UI > Main - Lottery & Raffle Info"] = "Lottery & Raffle Info" -- Lottery Info Frame Title
L["GLR - UI > Main - Player Ticket Information"] = "Player Ticket Information" -- Lottery Player Name Frame Title
L["GLR - UI > Main - Ticket Pool"] = "Ticket Pool" -- Unused Ticket Frame Title
L["GLR - UI > Main - Ticket Number Range"] = "Ticket Number Range" -- Ticket Number Range Frame Title
L["GLR - UI > Config > Options > Tickets - View Ticket Info Title"] = "View Player Tickets"
L["GLR - UI > UpdateFrame - New Update"] = "AddOn Updated"

-- Lottery & Raffle Translation
L["Lottery"] = "Lottery"
L["Raffle"] = "Raffle"
L["Guild Lottery"] = "Guild Lottery" -- Currently used for Mail Subject text detection
L["Guild Raffle"] = "Guild Raffle" -- Currently used for Mail Subject text detection
L["Both"] = "Both"
L["Value_Gold"] = "Gold"
L["Value_Silver"] = "Silver"
L["Value_Copper"] = "Copper"
L["Value_Gold_Short"] = "g"
L["Value_Silver_Short"] = "s"
L["Value_Copper_Short"] = "c"
L["Value_Gold_Short_Colored"] = "|cffffdf00G|r"
L["Value_Silver_Short_Colored"] = "|cffc0c0c0S|r"
L["Value_Copper_Short_Colored"] = "|cffb87333C|r"

-- Detect Lottery/Raffle Msg Translation (Must all be lower case characters, and have a ! or ? before the text. ! for event information. ? for requesting other player ticket information.)
L["Detect Lottery"] = "!lottery"
L["Detect Raffle"] = "!raffle"
L["Detect Other Lottery"] = "?lottery"
L["Detect Other Raffle"] = "?raffle"

L["GLR - Core - Reply - Detect Other Event: Notify Player (long msg)"] = "GLR: The following have requested information about your Tickets for the current %e event:"
L["GLR - Core - Reply - Detect Other Event: Notify Player (short msg)"] = "GLR: %users requested information about your Tickets for the current %e event."
L["GLR - Core - Reply - Detect Other Event: Target Found"] = "GLR: '%target' has bought %num Tickets in the current %e event. Their Tickets range from %low to %high."
L["GLR - Core - Reply - Detect Other Event: No One Found"] = "GLR: '%target' has not entered into the event or could not be found. If the name you're searching for has entered into the event, please spell their name correctly."
L["GLR - Core - Reply - Detect Other Event: No Valid Text"] = "GLR: Please enter a name to receive information about their purchased tickets. Example: ?%event %host"
L["GLR - Core - Reply - Detect Other Event: Multiple Found"] = "GLR: Detected multiple possible names from your search parameter of '%target' please specify by adding the appropriate Realm Name. Example: ?%event %host"

-- Class Name Translations
L["Death Knight"] = "Death Knight"
L["Demon Hunter"] = "Demon Hunter"
L["Druid"] = "Druid"
L["Hunter"] = "Hunter"
L["Mage"] = "Mage"
L["Monk"] = "Monk"
L["Paladin"] = "Paladin"
L["Priest"] = "Priest"
L["Rogue"] = "Rogue"
L["Shaman"] = "Shaman"
L["Warlock"] = "Warlock"
L["Warrior"] = "Warrior"

-- Month Name Translations
L["January"] = "January"
L["January Short"] = "Jan"
L["February"] = "February"
L["February Short"] = "Feb"
L["March"] = "March"
L["March Short"] = "Mar"
L["April"] = "April"
L["April Short"] = "Apr"
L["May"] = "May"
L["May Short"] = "May"
L["June"] = "June"
L["June Short"] = "Jun"
L["July"] = "July"
L["July Short"] = "Jul"
L["August"] = "August"
L["August Short"] = "Aug"
L["September"] = "September"
L["September Short"] = "Sep"
L["October"] = "October"
L["October Short"] = "Oct"
L["November"] = "November"
L["November Short"] = "Nov"
L["December"] = "December"
L["December Short"] = "Dec"

-- Numerical Translations (for some languages, up to 31)
L["0"] = "0"
L["00"] = "00"
L["1"] = "1"
L["01"] = "01"
L["2"] = "2"
L["02"] = "02"
L["3"] = "3"
L["03"] = "03"
L["4"] = "4"
L["04"] = "04"
L["5"] = "5"
L["05"] = "05"
L["6"] = "6"
L["06"] = "06"
L["7"] = "7"
L["07"] = "07"
L["8"] = "8"
L["08"] = "08"
L["9"] = "9"
L["09"] = "09"
L["10"] = "10"
L["11"] = "11"
L["12"] = "12"
L["13"] = "13"
L["14"] = "14"
L["15"] = "15"
L["16"] = "16"
L["17"] = "17"
L["18"] = "18"
L["19"] = "19"
L["20"] = "20"
L["21"] = "21"
L["22"] = "22"
L["23"] = "23"
L["24"] = "24"
L["25"] = "25"
L["26"] = "26"
L["27"] = "27"
L["28"] = "28"
L["29"] = "29"
L["30"] = "30"
L["31"] = "31"
L["45"] = "45" -- 45th minute out of 60 (60 = 00)
L["2020"] = "2020" --Current Year + One More year (can create calendar events up to one year ahead)
L["2021"] = "2021" --Future proofing up to 10 years for the AddOn to dynamically build the list of available years in which to create events.
L["2022"] = "2022"
L["2023"] = "2023"
L["2024"] = "2024"
L["2025"] = "2025"
L["2026"] = "2026"
L["2027"] = "2027"
L["2028"] = "2028"
L["2029"] = "2029"
L["2030"] = "2030"

-- Calendar Guild Announcement Text Translations
L["GLR - Core - Calendar Lottery Title"] = "Guild Lottery"
L["GLR - Core - Calendar Raffle Title"] = "Guild Raffle"
-- Large space required as a simple /n doesn't create a new line for text in Calendar Events.
L["GLR - Core - Calendar Guild Announcement"] = "Tickets are: %TicketPrice Each.                                   %MaxTickets Tickets can be bought per person.           Contact: %Player For further details."

-- Button Font String Translations
L["New Lottery Button"] = "New Lottery"
L["New Raffle Button"] = "New Raffle"
L["Begin Lottery Button"] = "Begin Lottery"
L["Begin Raffle Button"] = "Begin Raffle"
L["Alert Guild Button"] = "Alert Guild"
L["New Player Button"] = "New Player"
L["Edit Players Button"] = "Edit Players"
L["Configure Button"] = "Configure"
L["Go To Raffle Button"] = "Go To Raffle"
L["Go To Lottery Button"] = "Go To Lottery"
L["Confirm Start Button"] = "Confirm Start"
L["Start New Lottery Button"] = "Start Lottery"
L["Start New Raffle Button"] = "Start Raffle"
L["Confirm Add Player Button"] = "Add Player"
L["Confirm Edit Player Button"] = "Edit Player"
L["Confirm Action Button"] = "Confirm"
L["Confirm Add Raffle Item"] = "Okay"
L["Abort Roll"] = "Abort Roll"
L["Confirm Abort Roll"] = "Confirm Abort"
L["Scan Mail Button"] = "Scan Mail"
L["Reply Mail Button"] = "Reply"

-- Lottery Info Frame Font String Translations
L["Lottery Date"] = "Lottery Date"
L["Raffle Date"] = "Raffle Date"
L["Lottery Name"] = "Lottery Name"
L["Raffle Name"] = "Raffle Name"
L["Starting Gold"] = "Starting Amount"
L["Raffle First Place"] = "First Place Prize"
L["Raffle Second Place"] = "Second Place Prize"
L["Raffle Third Place"] = "Third Place Prize"
L["Raffle Sales"] = "Ticket Sales"
L["Jackpot"] = "Jackpot"
L["Raffle Second Place"] = "Second Place Prize"
L["Max Tickets"] = "Max Tickets"
L["Ticket Price"] = "Ticket Price"
L["Second Place Text"] = "Second Place"
L["Guild Amount Text"] = "Guilds Amount"
L["Winner Guaranteed"] = "Winner Guaranteed"

-- New Lottery Frame Font String Translations
L["New Lottery Settings"] = "New Lottery Settings"
L["Select Valid Lottery Date"] = "Select a Valid Date for the new Lottery"
L["Hour"] = "Hour:"
L["Minute"] = "Minute:"
L["Set Lottery Name"] = "Set Lottery Name"
L["Set Starting Gold"] = "Set Starting Amount"
L["Set Maximum Tickets"] = "Set Maximum Tickets"
L["Set Ticket Price"] = "Set Ticket Price"
L["Set Second Place Prize"] = "Set Second Place Prize"
L["Set Guild Cut"] = "Set Guild Cut"

-- New Raffle Frame Font String Translations
L["New Raffle Settings"] = "New Raffle Settings"
L["Select Valid Raffle Date"] = "Select a Valid Date for the new Raffle"
L["Set Raffle Name"] = "Set Raffle Name"
L["Set First Place"] = "First Place Prize"
L["Set Second Place"] = "Second Place Prize"
L["Set Third Place"] = "Third Place Prize"

-- Add Player Frame Font String Translations (general)
L["Type Player Name"] = "Type Player Name:"
L["Add Player Tickets"] = "Add Player Tickets:"
L["Add Player Must Have Tickets"] = "Player Must Have Atleast 1 Ticket"
L["Add Player No Name Given"] = "Please Enter a Player Name"
L["Add Player They Already Exist"] = "Player Already Exists"
L["Add Player Max Tickets Exceeded"] = "Tickets Exceed Max Limit"
L["Add Player Cant Have 0 Tickets"] = "Player Can't have 0 Tickets"
L["No Player Found"] = "No Player Found"

-- Add Player to Lottery Frame Font String Translations
L["Add Player to Lottery"] = "Add Player to Lottery"

-- Add Player to Raffle Frame Font String Translations
L["Add Player to Raffle"] = "Add Player to Raffle"

-- Edit Player Frame Font String Translations
L["Edit Players in Lottery"] = "Edit Players in Lottery"
L["Edit Players in Raffle"] = "Edit Players in Raffle"
L["Select Player to Edit"] = "Select Player to Edit:"
L["Edit Player Name Below"] = "Edit Player Name Below"
L["Edit Player Tickets Below"] = "Edit Player Tickets Below"
L["Edit Player Name Exists & Max Tickets Exceeded"] = "Name Already Exists, Max Tickets Exceeded"
L["Edit Player Name Exists"] = "Name Already Exists"
L["Edit Player Max Tickets Exceeded"] = "Tickets Exceed Max Limit"
L["Edit Player Ticket Not Numerical"] = "Ticket Change Must Be Numerical"

-- New Lottery/Raffle Frame Error Message Translations
L["Guild Cut Error"] = "Guild Cut must be between 0 and 100"
L["Second Place Error"] = "Second Place must be between 0 and 100"
L["Guild & Second Place Error"] = "Total of Second Place & Guild Cut can't be higher than 100"
L["Invalid Ticket Error"] = "Invalid Ticket Price"
L["Blank Entry"] = "All Currency Fields Must Be Zero or Higher"
L["Blank Gold Entry"] = "Gold Value Must Be Zero or Higher"
L["Blank Silver Entry"] = "Silver Value Must Be Zero or Higher"
L["Blank Copper Entry"] = "Copper Value Must Be Zero or Higher"
L["Max Ticket Error"] = "Max Tickets must be between 1 and 50000"
L["Starting Gold Error"] = "Invalid Starting Gold"
L["Lottery Name Error"] = "Please enter a name for your Lottery"
L["Month Error"] = "Please select a valid Month"
L["Day Error"] = "Please select a valid Day"
L["Hour Error"] = "Please select a valid Hour"
L["Date Error"] = "Please select a valid Date"
L["Prize Error"] = "Please enter at least one Prize"

-- Mail Scanning Error/Completion Message Translations
L["Mail Scan - Start"] = "Starting Mail Scan Process"
L["Mail Scan - Refreshing"] = "Refreshing Mailbox"
L["Mail Scan - Processing"] = "Processing"
L["Mail Scan - Processing Format"] = "Processing %sender for: %subject. Money Received: %money"
L["Mail Scan - Complete"] = "Mail Scanning Process Complete"
L["Mail Scan - Interrupted"] = "Mail Scanning Process Interrupted, Inbox Frame Closed."
L["Mail Scan - Extra Tickets"] = "%sender sent %money Extra. This amount can be sent back to them or to the Guild Bank."
L["Mail Scan - Button Tooltip Line 1"] = "Scans your mail for potential Lottery or Raffle entries. Click to start this process."
L["Mail Scan - Button Tooltip Line 2"] = "Subject lines must be" .. ' "Lottery" ' .. "or" .. ' "Raffle" ' .. "for their respective Events."
L["Mail Scan - Button Tooltip Line 3"] = "WARNING: For this to work properly, you must keep the mailbox open until it's complete."
L["GLR - Mail Scan - Mail Subject"] = "GLR: %e Confirmation"
L["GLR - Mail Scan - Mail Body"] = "This mail is to inform you that your character, %s, has been entered into the current %e Event for %t Ticket(s).\n\nMoney Received: %m\nTickets Bought: %t\nYour Total Tickets: %f\nYou can purchase %x more Tickets.[\nTotal value of Ticket Sales]{\nTotal Jackpot before Guild Cut}: %j\n\n-- Guild Lottery & Raffles --"
L["GLR - Mail Scan - Confirmation Chat Message"] = "Sending %e Confirmation Mail to: %r"
L["GLR - Config - Events - Mail Header"] = "Mail Scan Settings"
L["GLR - Config - Events - Command Header"] = "Command Detection Settings"


-- View Player Ticket Info Frame Font String Translations
L["Ticket Info Player Name"] = "Name: %User"
L["Ticket Info Player Name Default"] = "Name:"
L["Ticket Info Player Tickets"] = "Tickets: %amount"
L["Ticket Info Player Tickets Default"] = "Tickets: 0"
L["Ticket Info Gold Value"] = "Value: %money"
L["Ticket Info Gold Value Default"] = "Value: 0"

-- Lottery/Raffle Roll Guild Text Translations
-- Initiate Lottery / Raffle Roll
L["GLR Title with Version"] = "Guild Lottery & Raffles v" -- The 'v' at the end denotes the Version of the mod
L["Begin Lottery Draw"] = "Lottery Draw will commence shortly"
L["Begin Raffle Draw"] = "Raffle Draw will commence shortly"
L["Begin Advanced Lottery Draw"] = "Advanced Lottery Draw will commence shortly"
L["Begin Advanced Raffle Draw"] = "Advanced Raffle Draw will commence shortly"
L["No Lottery Active"] = "No Lottery Active"
L["No Raffle Active"] = "No Raffle Active"
L["Draw In Progress"] = "Draw is in progress, please wait for it to complete."
L["Lottery Draw Guilds Take"] = "GLR: The Guild will receive: %g."
L["Lottery Draw Unused Ticket Found"] = "GLR: The winning ticket number was %t and matched a Unused Ticket Number, redrawing a new winning ticket number."
L["Lottery Draw Unused Ticket Redraw"] = "GLR: Redraw will start in 10 seconds."
-- Step 1
L["Advanced Draw Step 1"] = "GLR: Ticket Numbers ranged from: %f - %l"
L["Advanced Draw Step 1 Totals"] = "GLR: %t Ticket Numbers were generated. %c were assigned randomly to all entered Players."
L["Advanced Draw Step 1 Win Chance"] = "GLR: This event has a %c% chance to draw a Winner."
L["Draw Step 1"] = "GLR: A total of %TicketsSold Tickets were sold, for a total of %money."
L["Draw Given Tickets"] = "%t Free Tickets were given away."
L["Raffle Draw Step 1"] = "GLR: Raffle Prize(s)"
L["Raffle Draw Step 1 Prize 1"] = "GLR: First Place Prize: %p1"
L["Raffle Draw Step 1 Prize 2"] = "GLR: Second Place Prize: %p2"
L["Raffle Draw Step 1 Prize 3"] = "GLR: Third Place Prize: %p3"
-- Step 2
L["Draw Step 2"] = "GLR: Ticket Numbers ranged from %low to %high."
L["Draw Step 2 Invalid Tickets"] = "GLR: There are: %unsold Unused Tickets. If the winning number is one of them, the Winning Ticket will be redrawn. This process may take some time."
-- Step 3
L["Lottery Draw Step 3 Fixed Variable 1"] = "% of the Jackpot."
L["Lottery Draw Step 3 Fixed Variable 2"] = "GLR: No one is guaranteed to win the Jackpot, however no one has a chance to win a Second Place prize either."
L["Lottery Draw Step 3 Fixed Variable 3"] = "GLR: The Guild has decided not to take a percentage of the Jackpot."
L["Lottery Draw Step 3 Condition 1"] = "GLR: There's no Second Place as a winner is guaranteed! However the Guilds take is "
L["Lottery Draw Step 3 Condition 2"] = "GLR: There's no Second Place as a winner is guaranteed! The Guild has also decided not to take a percentage of the Jackpot!"
L["Lottery Draw Step 3 Condition 3 Guild Part"] = "GLR: The Guilds take is "
L["Lottery Draw Step 3 Condition 3"] = "GLR: If no one wins the Jackpot, someone has a chance to win Second Place for "
-- Step 4
L["Lottery Draw Step 4 Fixed Variable 1"] = "Gold."
L["Lottery Draw Step 4 Fixed Variable 2"] = "GLR: Since no winner is guaranteed, if no one wins the Jackpot of"
L["Lottery Draw Step 4 Fixed Variable 3"] = "Their's a chance for someone to win"
L["Lottery Draw Step 4 Condition 1 Part 1"] = "GLR: After the Guilds take of"
L["Lottery Draw Step 4 Condition 1 Part 2"] = ", the remaining Jackpot total is"
L["Lottery Draw Step 4 No Guild Cut 1"] = "GLR: However! If no one wins either the Jackpot or Second Place the Guild will not take a cut."
L["Lottery Draw Step 4 No Guild Cut 2"] = "GLR: However! If no one wins the Jackpot, the Guild will not take a cut."
L["Lottery Draw Step 4 Announce Roll"] = "GLR: The roll will begin in 10 seconds."
-- Step 5
L["Lottery Draw Step 5 Announce Winning Ticket"] = "GLR: The Winning Ticket number is: %t"
L["Raffle Draw Step 5 Announce First Ticket"] = "GLR: The First Place Winning Ticket number is: "
L["Raffle Draw Step 5 Announce Second Ticket"] = "GLR: The Second Place Winning Ticket number is: "
L["Raffle Draw Step 5 Announce Third Ticket"] = "GLR: The Third Place Winning Ticket number is: "
L["Lottery Draw Step 5 Winner Found"] = "GLR: A winner has been found! %v is the winner, receiving: %g."
L["Raffle Draw Step 5 Winner Found Fixed Variable"] = " is the winner, receiving: "
L["Raffle Draw Step 5 First Winner Found"] = "GLR: A winner has been found for First Place! "
L["Raffle Draw Step 5 Second Winner Found"] = "GLR: A winner has been found for Second Place! "
L["Raffle Draw Step 5 Third Winner Found"] = "GLR: A winner has been found for Third Place! "
L["Lottery Draw Step 5 No Winner Found"] = "GLR: No winner could be found for: %t"
L["Lottery Draw Step 5 Draw Second Place"] = "GLR: Draw for Second Place will start in 10 seconds."
-- Step 6
L["Lottery Draw Step 6 Announce Second Place Winning Ticket"] = "GLR: The winning ticket number for Second Place is: %t"
L["Lottery Draw Step 6 Winner Found"] = "GLR: A Second Place Winner has been found! %v will receive %g."
L["Lottery Draw Step 6 Next Lottery Starts"] = "GLR: The next lottery will start with at least %g."
L["Lottery Draw Step 6 No Winner Found"] = "GLR: The Second Place winning ticket number was: %t"
L["Lottery Draw Step 6 No Second Place"] = "GLR: No winner was found for Second Place. The next lottery will start with at least %g."
-- Lottery/Raffle Completed Message
L["Lottery Draw Complete"] = "GLR: Lottery Draw Completed."
L["Advanced Lottery Draw Complete"] = "GLR: Advanced Lottery Draw Completed."
L["Raffle Draw Complete"] = "GLR: Raffle Draw Completed."
L["Advanced Raffle Draw Complete"] = "GLR: Advanced Raffle Draw Completed."

-- Abort Roll Message
L["Abort Roll Message"] = "GLR: Draw Process Aborted."
L["Automatic Abort Roll Message"] = "GLR: Draw Process Automatically Aborted. You were prevented from sending messages to Guild Chat. Contact your Guild Master to fix this."

-- Alert Guild Translations
L["Alert Guild GLR Title No Version"] = "Guild Lottery & Raffle v"
L["Alert Guild GLR Title"] = "Guild Lottery & Raffle v" .. GLR_VersionText -- The 'v' is to denote the version of the mod
L["Alert Guild Lottery Scheduled"] = "A Lottery is scheduled for"
L["Alert Guild Raffle Scheduled"] = "A Raffle is scheduled for"
L["Alert Guild LaR Scheduled"] = "A Lottery and Raffle are scheduled for"
L["Alert Guild Event Name"] = "Event Name"
L["Alert Guild Win Chance"] = "Chance to draw a Winner"
L["Alert Guild Ticket Info Part 1"] = "Tickets are"
L["Alert Guild Ticket Info Part 2"] = "each."
L["Alert Guild Ticket Info Part 3"] = "A maximum of"
L["Alert Guild Ticket Info Part 4"] = "tickets can be bought per person."
L["Alert Guild Tickets Bought"] = "The Jackpot is currently"
L["Alert Guild Raffle Tickets Bought"] = "Raffle Tickets have been bought."
L["Alert Guild Whisper For Lottery Info"] = "Whisper '!lottery' for more details."
L["Alert Guild Whisper For Raffle Info"] = "Whisper '!raffle' for more details."
L["Alert Guild Whisper For LaR Info"] = "Whisper '!lottery' for more Lottery details. Whisper '!raffle' for more Raffle details."
L["Alert Guild Time Between Alerts Part 1"] = "Please wait at least "
L["Alert Guild Time Between Alerts Part 2"] = " seconds before sending another alert."
L["Alert Guild No Event Active"] = "No %event is currently set."
L["Alert Guild No Lottery Active"] = "No Lottery is currently set."
L["Alert Guild No Raffle Active"] = "No Raffle is currently set."
L["Alert Guild No LoR Active"] = "No Lottery or Raffle is currently set."

-- Send Player Ticket Info Translations
L["Send Info Title"] = "Guild Lottery & Raffle v"
L["Send Info Event Info 1"] = "GLR: Event Info For"
L["Send Info Event Info 2"] = "on"
L["Send Info Player Lottery Entered"] = "GLR: You've entered into a Lottery scheduled for"
L["Send Info Player Raffle Entered"] = "GLR: You've entered into a Raffle scheduled for"
L["Send Info No Tickets Purchased Part 1"] = "GLR: You've not purchased any Tickets for"
L["Send Info No Tickets Purchased Part 2"] = "If this is a mistake please let me know."
L["Send Info Can Purchase Tickets Part 1"] = "GLR: You are able to purchase"
L["Send Info Can Purchase Tickets Part 2"] = "Tickets at"
L["Send Info Can Purchase Tickets Part 3"] = "per Ticket."
L["Send Info Reply Lottery"] = "GLR: To see info about your purchased tickets please message me with '!lottery' after you've been entered."
L["Send Info Reply Raffle"] = "GLR: To see info about your purchased tickets please message me with '!raffle' after you've been entered."
L["Send Info Tickets Purchased First Msg 1"] = "GLR: You've purchased"
L["Send Info Tickets Purchased First Msg 2"] = "out of the"
L["Send Info Tickets Purchased First Msg 3"] = "Ticket Limit"
L["Send Info Tickets Purchased Part 1"] = "GLR: You've purchased"
L["Send Info Tickets Purchased Part 2"] = "Tickets, and can purchase"
L["Send Info Tickets Purchased Part 3"] = "additional Tickets at"
L["Send Info Tickets Purchased Part 3.1"] = "additional Ticket at"
L["Send Info Tickets Purchased Part 4"] = "per Ticket."
L["Send Info Max Tickets Part 1"] = "GLR: You've purchased the maximum of"
L["Send Info Max Tickets Part 2"] = "Tickets."
L["Send Info Long Ticket Message"] = "GLR: Your Ticket numbers are (long message):"
L["Send Info GLR"] = "GLR"
L["Send Info Current Jackpot Part 1"] = "GLR: After the Guilds cut of"
L["Send Info Current Jackpot Part 2"] = "The current Jackpot is"
L["Send Info Current Win Chance"] = "GLR: This Lottery Event has a %c% chance of drawing a winner."
L["Send Info Current Prizes"] = "GLR: The Current Raffle Prize(s) are"
L["Send Info Short Ticket Message"] = "GLR: Your Ticket Numbers are"
L["Send Info Ticket Number Range"] = "GLR: Your tickets range from: %first to %last"
L["Send Info Player Online"] = "Received Ticket Information"
L["Send Info Player Not Online"] = "is not online. They will be messaged the next time you're both online."
L["Send Info No Active Event"] = "GLR: No %event is currently active."
L["Send Info No Active Lottery"] = "GLR: No Lottery is currently active."
L["Send Info No Active Raffle"] = "GLR: No Raffle is currently active."
L["Send Info Must Wait 1"] = "You must wait at least"
L["Send Info Must Wait 2"] = "seconds between receiving Guild Lottery & Raffle Info messages."
L["Send Info GLR Disabled"] = "Guild Lottery and Raffles is currently disabled."

-- Tooltip Translation
L["GLR Tooltip Title"] = "Guild Lottery & Raffle" -- Title used in all tooltips

-- New Lottery Button Tooltip Translations
L["Start New Lottery Button Tooltip"] = "Start a new Lottery"
L["Start New Lottery Button Tooltip Warning"] = "WARNING: This action will cancel any current Lottery"

-- Begin Lottery Button Tooltip Translation
L["Begin Lottery Button Tooltip"] = "Do you want to start the Lottery Draw?"

-- Alert Guild Button Tooltip Translation
L["Alert Guild Button Tooltip"] = "Alert your Guild about current Lottery/Raffle Events"

-- Add Player Button Tooltip Translation
L["Add Player Button Tooltip"] = "Add a name to the "

-- Edit Player Button Tooltip Translation
L["Edit Player Button Tooltip"] = "Edit current list of Players in the "

-- New Raffle Button Tooltip Translations
L["Start New Raffle Button Tooltip"] = "Start a new Raffle"
L["Start New Raffle Button Tooltip Warning"] = "WARNING: This action will cancel any current Raffle"

-- Begin Raffle Button Tooltip Translation
L["Begin Raffle Button Tooltip"] = "Do you want to start the Raffle Draw?"

-- Open Interface Options Button Tooltip Translation
L["Configure Button Tooltip"] = "Configure settings for Guild Lottery & Raffles AddOn"

-- Confirm Start Lottery Button Tooltip Translations
L["Confirm Start Lottery Button Tooltip"] = "Sure you want to start this Lottery?"
L["Confirm Start Lottery Button Tooltip Warning"] = "WARNING: Their's no turning back after this."

-- Confirm Start Raffle Button Tooltip Translations
L["Confirm Start Raffle Button Tooltip"] = "Sure you want to start this Raffle?"
L["Confirm Start Raffle Button Tooltip Warning"] = "WARNING: Their's no turning back after this."

-- Start New Lottery Button Tooltip Translation
L["Start Lottery Button Tooltip"] = "Confirm new Lottery Settings"

-- Start New Raffle Button Tooltip Translation
L["Start Raffle Button Tooltip"] = "Confirm new Raffle Settings"

-- Confirm Add Player Button Tooltip Translation
L["Confirm Add Player to Lottery Button Tooltip"] = "Confirm add new Player to Lottery"
L["Confirm Add Player to Raffle Button Tooltip"] = "Confirm add new Player to Raffle"

-- Confirm Edit Player Button Tooltip Translations
L["Confirm Edit Player Button Tooltip"] = "Confirm edit of %name in %event"

-- Confirm New Lottery Button Tooltip Translations
L["Confirm New Lottery Button Tooltip"] = "Confirm start of New Lottery?"
L["Confirm New Lottery Button Tooltip Warning"] = "WARNING: This action will cancel any current Lottery"

-- Confirm New Raffle Button Tooltip Translations
L["Confirm New Raffle Button Tooltip"] = "Confirm Start of New Raffle"
L["Confirm New Raffle Button Tooltip Warning"] = "WARNING: This action will cancel anny current Raffle"

-- Abort Roll Process Button Tooltip Translation
L["Abort Roll Process Button Tooltip"] = "Abort the current Lottery/Raffle Draw"
L["Abort Roll Process Button Tooltip Warning"] = "Confirmation Required"

-- Confirm Abort Roll Process Button Tooltip Translation
L["Confirm Abort Roll Process Button Tooltip"] = "Confirm you want to stop the current Lottery/Raffle Draw"

-- Lottery Donation Translations
L["Donation Button"] = "Donation"
L["Donation Description Text"] = "Enter Amount To Increase Jackpot"
L["Lottery Donation Tooltip"] = "Increase the size of the current Jackpot"
L["Lottery Donation Confirmation Button Tooltip"] = "Increase the current Lottery Jackpot by %amount"
L["Lottery Donation Confirmation Button Tooltip Warning"] = "WARNING: This action can't be undone, the Jackpot can't be decreased using this."
L["Send Donation Info To Guild"] = "The Lottery Jackpot has been increased by: %Amountg %Silvers %Copperc. The Jackpot Total is now: %new. After the Guilds Cut the takeaway is now: %q"

-- Check Button Translations
L["Add Free Tickets"] = "Free"
L["Edit Free Tickets"] = "Set as Free"
L["Add Free Tickets Tooltip"] = "If checked, the tickets for the entered player will be marked as Free."
L["Edit Free Tickets Tooltip"] = "If checked, any amount greater than the currently entered tickets will be marked as Free."
L["Guarantee Winner Check Button"] = "Guarantee a Winner"
L["Allow Invalid Item Check Button"] = "Allow Invalid Items"

-- Check Button Tooltip Translations
L["Guarantee Winner Check Button Tooltip"] = "Guarantee a Winner for this Lottery event"
L["Allow Invalid Item Check Button Tooltip"] = "Allows items the mod detects as invalid to be entered"

-- Main Frame Edit Box Tooltip Translations
L["Starting Gold Edit Box Tooltip"] = "Value is in Gold, not Silver or Copper"
L["Max Tickets Edit Box Tooltip"] = "Maximum tickets a player can get"
L["Gold Value Edit Box Tooltip"] = "Value is in Gold, not Silver or Copper"
L["Jackpot Place Edit Box Tooltip"] = "Value of the Jackpot for %v Place"
L["Jackpot Guild Place Edit Box Tooltip"] = "Value of the Jackpot for the Guild"
L["Percentage of Jackpot Tooltip"] = "Percentage of Jackpot: %v%"
L["Ticket Sales Edit Box Tooltip"] = "Displays the amount of Gold earned through ticket sales"
L["First"] = "First"
L["Second"] = "Second"
L["Guild"] = "Guild"

-- New Lottery Frame Edit Box Tooltip Translations
L["Set Lottery Name"] = "Set the Name of the new Lottery"
L["Set Starting Gold Part 1"] = "Set the Starting Value for the new Lottery"
L["Set Starting Gold Part 2"] = "This amount comes from you or your Guild"
L["Set Starting Gold Part 3"] = "Previous Lottery amount is factored after the fact!"
L["Set Maximum Lottery Tickets"] = "Set the Maximum Tickets for the new Lottery"
L["Set Lottery Ticket Price"] = "Set the Ticket Price for the new Lottery"
L["Set Second Place Percent"] = "Set the Second Place prize for the new Lottery"
L["Set Guild Cut Percent"] = "Set the Guild Cut for the new Lottery"
L["Set Lottery Percent Value"] = "Value is a percentage of the Jackpot, so 100 will equal 100%"
L["No Guild Cut Enabled"] = "No Guild Cut on No Winner is Enabled"

-- New Raffle Frame Edit Box Tooltip Translations
L["Set Raffle Name"] = "Set the Name of the new Raffle"
L["Set Maximum Raffle Tickets"] = "Set the Maximum Tickets for the new Raffle"
L["Set Raffle Ticket Price"] = "Set the Ticket Price for the new Raffle"
L["Set Raffle Prize"] = "Shift + Left-Click on the item to enter it into the Raffle."
L["Set Raffle First Place Prize"] = "This will become the item for the first place winner."
L["Set Raffle Second Place Prize P1"] = "This will become the item for the second place winner."
L["Set Raffle Second Place Prize P2"] = "Leave blank to not have a second place."
L["Set Raffle Third Place Prize P1"] = "This will become the item for the third place winner."
L["Set Raffle Third Place Prize P2"] = "Leave blank to not have a third place."

-- Add Player to Lottery Frame Edit Box Tooltip Translations
L["Add Lottery Player Name Part 1"] = "Set the Name of Player to add to the new Lottery"
L["Add Lottery Player Name Part 2"] = "Names are case sensitive, as the mod sends a message"
L["Add Lottery Player Name Part 3"] = "to the player about their Ticket Info"
L["Add Lottery Player Tickets"] = "Set the Number of Tickets Purchased for the new Lottery"

-- Edit Player in Lottery/Raffle Frame Edit Box Tooltip Translations
L["Edit Lottery Selected Player"] = "Edit the Selected Players Name"
L["Edit Lottery Selected Player Tickets"] = "Edit the Selected Players Tickets, can't be above Max Tickets"

-- Add Player to Raffle Frame Edit Box Tooltip Translations
L["Add Raffle Player Name Part 1"] = "Set the Name of Player to add to the new Raffle"
L["Add Raffle Player Name Part 2"] = "Names are case sensitive, as the mod sends a message"
L["Add Raffle Player Name Part 3"] = "to the player about their Ticket Info"
L["Add Raffle Player Tickets"] = "Set the Number of Tickets Purchased for the new Raffle"

--Donation Frame Edit Box Tooltip Translations
L["Donation Edit Box Tooltip"] = "Enter an amount to increase the current Lottery Jackpot"

-- Minimap Button Tooltip Translations
L["Minimap Button Left Click"] = "Left Click"
L["Minimap Button Shft Hold Left Click"] = "Shift + Hold Left Click"
L["Minimap Button Ctrl Left Click"] = "Ctrl + Left Click"
L["Minimap Button Left Click Info"] = "Opens Guild Lottery & Raffles"
L["Minimap Button Shft Hold Left Click Info"] = "Drags the Minimap Icon (free mode)"
L["Minimap Button Ctrl Left Click Info"] = "Alerts Guild about active Events"
L["Minimap Button Right Click"] = "Right Click"
L["Minimap Button Right Click Info"] = "Opens to Configuration Panel"
L["Minimap Button Hold Left"] = "Hold Left Click"
L["Minimap Button Hold Left Info"] = "Drags the Minimap Icon"
L["Minimap Button Lottery Info"] = "Lottery Info"
L["Minimap Button Raffle Info"] = "Raffle Info"
L["Minimap Button Event Info"] = "%cDate:%r %event\n%cTickets Sold:%r %amount\n%cTickets Given:%r %free"

-- Configuration Panel Translations
L["Configuration Panel Information Tab"] = "Information"
L["Configuration Panel Options Tab"] = "Options"
L["Configuration Panel Options Tab Config"] = "Config"
L["Configuration Panel Options Tab General"] = "General"
L["Configuration Panel Options Tab Minimap"] = "Minimap"
L["Configuration Panel Options Tab Multi-Guild"] = "Multi-Guild"
L["Configuration Panel Options Tab Transfer"] = "Transfer"
L["Configuration Panel Events Tab"] = "Events"
L["Configuration Panel Profiles Tab"] = "Profiles"
L["Configuration Panel Preview"] = "Preview"
L["Configuration Panel Message Tab"] = "Messages"
L["Configuration Panel Whispers Tab"] = "Whispers"
L["Configuration Panel Giveaway Tab"] = "Giveaway"
L["Configuration Panel Message Preview"] = "Message Preview"
L["Configuration Panel Message Settings"] = "Settings"
L["Configuration Panel Message Settings Desc"] = "Configure the messages sent"
L["Configuration Panel Message Tab Guild Alert (L) Config"] = "Guild Alerts - Lottery"
L["Configuration Panel Message Tab Guild Alert (R) Config"] = "Guild Alerts - Raffle"
L["Configuration Panel Message Tab Guild Alert (B) Config"] = "Guild Alerts - Both"
L["Configuration Panel Message Tab Guild Alert (L) Name"] = "Guild Alert Messages - Lottery"
L["Configuration Panel Message Tab Guild Alert (R) Name"] = "Guild Alert Messages - Raffle"
L["Configuration Panel Message Tab Guild Alert (B) Name"] = "Guild Alert Messages - Both Events Active"
L["Configuration Panel Message Enable Lottery"] = "Enable Custom Guild Alerts for Lottery Events"
L["Configuration Panel Message Enable Raffle"] = "Enable Custom Guild Alerts for Raffle Events"
L["Configuration Panel Message Enable Both"] = "Enable Custom Guild Alerts while Both Event types are Active"
L["Configuration Panel Message Enable Both Desc"] = "Both Custom Guild Alerts for Lottery and Raffle must be Enabled for this to Enable"
L["Configuration Panel Message Tab Formats Lottery"] = "Available Formats:\n|cFF87CEFA  %version |r-> Becomes: %vs\n|cFF87CEFA  %lottery_price |r-> Becomes the Ticket Cost for your Event.\n|cFF87CEFA  %lottery_max |r-> Becomes the Maximum Tickets for your Event.\n|cFF87CEFA  %lottery_name |r-> Becomes the Name of your Event.\n|cFF87CEFA  %lottery_date |r-> Becomes the Date for your Event.\n|cFF87CEFA  %lottery_guild |r-> Becomes the Jackpot value your Guild receives.\n|cFF87CEFA  %lottery_winamount |r-> Becomes the Jackpot value the winner will receive.\n|cFF87CEFA  %lottery_winchance |r-> Becomes the percentage chance that someone will win.\n|cFF87CEFA  %lottery_total |r-> Becomes the total Jackpot value.\n|cFF87CEFA  %lottery_tickets |r-> Becomes the number of Tickets Sold.\n|cFF87CEFA  %lottery_reply |r-> Becomes the detection phrase.\n|cFF87CEFA  %previous_winner |r-> Becomes the Winners Name of your Previous Event.\n|cFF87CEFA  %previous_jackpot |r-> Becomes the amount the Previous Winner won."
L["Configuration Panel Message Tab Formats Raffle"] = "Available Formats:\n|cFF87CEFA  %version |r-> Becomes: %vs\n|cFF87CEFA  %raffle_price |r-> Becomes the Ticket Cost for your Event.\n|cFF87CEFA  %raffle_max |r-> Becomes the Maximum Tickets for your Event.\n|cFF87CEFA  %raffle_name |r-> Becomes the Name of your Event.\n|cFF87CEFA  %raffle_date |r-> Becomes the Date for your Event.\n|cFF87CEFA  %raffle_tickets |r-> Becomes the Tickets Sold for your Event.\n|cFF87CEFA  %raffle_total |r-> Becomes the value of Tickets Sold for your Event.\n|cFF87CEFA  %raffle_prizes |r-> Prints out your Event Prizes in order of: 1st, 2nd, 3rd\n|cFF87CEFA  %raffle_reply |r-> Becomes the detection phrase."
L["Configuration Panel Message Too Long"] = "Warning - Custom Message can't be more than 255 characters!"
L["Configuration Panel Whisper Message Too Long"] = "Warning - Custom Whisper Message is greater than 255 characters!"
L["Configuration Panel Message One"] = "First Message"
L["Configuration Panel Message Two"] = "Second Message"
L["Configuration Panel Message Three"] = "Third Message"
L["Configuration Panel Message Four"] = "Fourth Message"
L["Configuration Panel Message Five"] = "Fifth Message"
L["Configuration Panel Message Six"] = "Sixth Message"
L["Configuration Panel Message Seven"] = "Seventh Message"
L["Configuration Panel Message Eight"] = "Eighth Message"
L["Configuration Panel Message Nine"] = "Ninth Message"
L["Configuration Panel Message Ten"] = "Tenth Message"
L["Configuration Panel Message Eleven"] = "Eleventh Message"
L["Configuration Panel Message Profile Copy Lottery Desc"] = "Copy a existing Lottery Message Profile"
L["Configuration Panel Message Profile Copy Raffle Desc"] = "Copy a existing Raffle Message Profile"
L["Configuration Panel Message Profile Copy Both Desc"] = "Copy a existing Lottery & Raffle Message Profile"
L["Configuration Panel Options Tab Ticket Info"] = "Tickets"
L["Configuration Panel Options Tab Changelog"] = "Changelog"
L["Configuration Panel Mod Author"] = "Mod Author:"
L["Configuration Panel Previous Authors"] = "Previous Mod Authors:"
L["Configuration Panel Translators"] = "Translators:"
L["Configuration Panel Toggle GLR"] = "Enable/Disable this AddOn"
L["Configuration Panel Toggle GLR Description"] = "Toggles either On/Off the Guild Lottery & Raffles AddOn."
L["Configuration Panel Slash Command List"] = "List of Slash Commands"
L["Configuration Panel How To Header"] = "How To Guide"
L["Configuration Panel How To Step 1 P1"] = "Step 1"
L["Configuration Panel How To Step 1 P2"] = "To start a Lottery or Raffle, first open the Guild Lottery & Raffles User Interface. (see above)"
L["Configuration Panel How To Step 2 P1"] = "Step 2"
L["Configuration Panel How To Step 2 P2"] = "If you want to start a Lottery click the New Lottery button and enter in the Lottery Settings. To start a Raffle click the 'Go To Raffle' button and click the New Raffle Button there and do the same."
L["Configuration Panel How To Step 3 P1"] = "Step 3"
L["Configuration Panel How To Step 3 P2"] = "To Add Players to the active Lottery click the New Player button, to edit Players in the Lottery click the Edit Players button. To Add or Edit Players in a Raffle, you must first click the 'Go To Raffle' button."
L["Configuration Panel How To Step 4 P1"] = "Step 4"
L["Configuration Panel How To Step 4 P2"] = "To start the roll process for a Lottery click the Begin Lottery button, this will ask to confirm that you wish to start the Lottery. Doing so will prevent Adding or Editing Players to the Lottery until the draw is complete. To start the same process for a Raffle, click the 'Go To Raffle' button and click the Begin Raffle button."
L["Configuration Panel Open GLR Command"] = "Opens the Guild Lottery & Raffles User Interface."
L["Configuration Panel Help Command"] = "Brings you to this interface."
L["Configuration Panel Config Command"] = "Brings you to the Options panel for Guild Lottery & Raffles."
L["Configuration Panel Options Header"] = "Options for Guild Lottery & Raffles"
L["Configuration Panel General Options Header"] = "General Settings"
L["Configuration Panel Options Minimap Header"] = "Minimap Settings"
L["Configuration Panel Options Lottery Header"] = "Lottery Settings"
L["Configuration Panel Options Guild Header"] = "Multi-Guild Settings"
L["Configuration Panel Options Transfer Header"] = "Transfer Data Settings"
L["Configuration Panel Options Raffle Header"] = "Raffle Settings"
L["Configuration Panel Options Open GLR Button"] = "Open Guild Lottery & Raffles"
L["Configuration Panel Options Open GLR Button Desc"] = "Opens the Guild Lottery & Raffles User Interface"
L["Configuration Panel Options Toggle Escape Key"] = "Toggle Escape Key"
L["Configuration Panel Options Toggle Escape Key Desc"] = "Allows the Escape Key to close the User Interface. Defaults to On"
L["Configuration Panel Options Toggle Chat Info"] = "Additional Info"
L["Configuration Panel Options Toggle Chat Info Desc"] = "Show extra information that's sent to your chat frame. Such as detailed Mail Scanning process."
L["Configuration Panel Options Toggle Full Ticket Info"] = "Full Ticket Info"
L["Configuration Panel Options Toggle Full Ticket Info Desc"] = "If enabled, the AddOn will send players their ticket info over multiple messages. If disabled the AddOn will just tell players their ticket number range. Defaults to disabled as Events with massive Maximum Tickets can get spammy."
L["Configuration Panel Options Toggle Full Ticket Info Failed"] = "Full Ticket Information is not available with Advanced Ticket Draw enabled."
L["Configuration Panel Options Time Between Alerts"] = "Set the time (in seconds) the mod will let you send alerts to your guild"
L["Configuration Panel Options Time Between Alerts Desc"] = "Used to prevent misuse of Alerts sent by the mod, ranges from 30 seconds to 10 minutes (time is in seconds). Defaults to 60 seconds. This also affects the time that players can receive Lottery info either by whispering you or typing 'lottery' in guild chat."
L["Configuration Panel Options Toggle Multi Guild"] = "Multi-Guild Events"
L["Configuration Panel Options Toggle Multi Guild Desc"] = "If enabled on two or more of your Characters, the mod will treat those Guilds as one large Super-Guild. Allowing you to add players from different Guilds. Useful for Guilds supporting more than 1K Members. Requires a Reload for settings to take affect."
L["Configuration Panel Options Toggle Multi Guild Failed"] = "Multi-Guild status can't be changed while a Lottery or Raffle is currently active. Please Complete or Cancel those events to un/link."
L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"] = "%name has a active event. Multi-Guild status can't be changed while a Lottery or Raffle is currently active. Please Complete or Cancel those events to un/link."
L["Configuration Panel Options Transfer Data"] = "Begin Transfer"
L["Configuration Panel Options Transfer Data Desc"] = "Transfers available %event Data from selected player.\nRequires the Confirmation checkbox to proceed.\n|cffff0000WARNING|r: This will cancel any active %event for this character."
L["Configuration Panel Options Transfer Select Name"] = "Transfer %event Data From:"
L["Configuration Panel Options Transfer Select Name Desc"] = "Select a valid character to transfer %event Data from.\n\nBoth the selected player and you must be in the same Guild to appear as valid options (exceptions are made for Multi-Guild Events).\n\nMulti-Guild Events can only be transferred to characters that have Multi-Guild enabled."
L["Configuration Panel Options Transfer Completed"] = "Data Transfer From %name Complete"
L["Configuration Panel Options Toggle Cross Faction"] = "Cross-Faction Events"
L["Configuration Panel Options Toggle Cross Faction Desc"] = "With Multi-Guild Events enabled, this option allows you to link your Events across both Factions. Only needs to be set on the character that's hosting."
L["Configuration Panel Options Toggle Cross Faction Failed"] = "Cross-Faction status can't be changed while a Lottery or Raffle is currently active. Please Complete or Cancel those events before changing this."
L["Configuration Panel Options Toggle Randomize Tickets Failed"] = "Advanced Ticket Draw can't be changed while a Lottery or Raffle is currently active. Please Complete or Cancel those events before changing this."
L["Configuration Panel Options Toggle Calendar Events"] = "Calendar Events"
L["Configuration Panel Options Toggle Calendar Events Desc"] = "If enabled, the mod will create Guild Announcements for your Lottery or Raffle Events.\nRequires the Guild permission:\n'Is Officer'"
L["Configuration Panel Options Minimap Toggle"] = "Toggles display of Minimap Icon."
L["Configuration Panel Options Minimap Toggle Desc"] = "When enabled, allows you to quickly access Guild Lottery & Raffles"
L["Configuration Panel Options Minimap X Range"] = "Manually set the X axis value for the Minimap Icon"
L["Configuration Panel Options Minimap X Range Desc"] = "Allows you to fine tune the placement of the Minimap Icon"
L["Configuration Panel Options Minimap Y Range"] = "Manually set the Y axis value for the Minimap Icon"
L["Configuration Panel Options Minimap Y Range Desc"] = "Allows you to fine tune the placement of the Minimap Icon"
L["Configuration Panel Options Cancel Lottery"] = "Cancel Lottery"
L["Configuration Panel Options Cancel Lottery Desc"] = "Cancels the current Lottery, and wipes any saved Lottery data. Confirmation Required."
L["Configuration Panel Options Profile Header"] = "Profile Settings"
L["Configuration Panel Options Profile Desc"] = "Here you can set values for the AddOn to remember when making new events in the future. You can change these settings whenever you like."
L["Configuration Panel Options Profile Copy"] = "Copy Profile"
L["Configuration Panel Options Profile Copy Lottery Desc"] = "Copy a existing Lottery Profile"
L["Configuration Panel Options Profile Copy Raffle Desc"] = "Copy a existing Raffle Profile"
L["Configuration Panel Options Profile Max Tickets"] = "Max Tickets"
L["Configuration Panel Options Profile Enter Amount Desc"] = "Enter a amount for the AddOn to remember to start all future Events with."
L["Configuration Panel Options Profile Value Continued"] = "Values less than one gold are read as: 0.0575 - This becomes 5 Silver and 75 Copper"
L["Configuration Panel Options Profile Ticket Price"] = "Ticket Price"
L["Configuration Panel Options Lottery Profile Starting Gold"] = "Starting Amount"
L["Configuration Panel Options Lottery Profile Second Place"] = "Second Place"
L["Configuration Panel Options Lottery Profile Guild Cut"] = "Guild Cut"
L["Configuration Panel Options Lottery Profile Guarantee Winner"] = "Guarantee Winner"
L["Configuration Panel Options Lottery Profile Toggle Desc"] = "Set if the AddOn should remember to Guarantee a Winner for future Lotteries."
L["Configuration Panel Options Cancel Raffle"] = "Cancel Raffle"
L["Configuration Panel Options Cancel Raffle Desc"] = "Cancels the current Raffle, and wipes any saved Raffle data. Confirmation Required."
L["Configuration Panel Options Raffle Profile Invalid Items"] = "Invalid Items"
L["Configuration Panel Options Raffle Profile Toggle Desc"] = "Set if the AddOn should remember to allow Invalid Items to be entered when creating future Raffles."
L["Configuration Panel Options Allow Multiple Raffle Winners"] = "Force Multiple Raffle Winners"
L["Configuration Panel Options Allow Multiple Raffle Winners Desc"] = "Changes how the Raffle selects winners. If enabled then the mod will select a different winner for each prize. If disabled then one person can end up winning all prizes."
L["Configuration Panel Options Multi-Guild Description"] = "To begin the process of linking Multiple Guilds together you must enable the '|cFF87CEFAMulti-Guild Events|r' option in General Settings. This must be done on at least two characters in different Guilds to set their status as Linked. To host a Lottery or Raffle for the Linked Guilds, you must host it on a character you've Linked."
L["Configuration Panel Options Multi-Guild Tooltip"] = "Requires a reload to confirm status change. Can't be changed while a Lottery or Raffle event is active."
L["Configuration Panel Options Multi-Guild Linked Guilds"] = "Currently Linked Guilds"
L["Configuration Panel Options Multi-Guild Linked Characters"] = "Currently Linked Characters"
L["Configuration Panel Ticket Info Header"] = "Ticket Info for Guild Lottery & Raffles"
L["Configuration Panel Ticket Info Select Lottery Player"] = "Select Lottery Player"
L["Configuration Panel Ticket Info Select Lottery Player Desc"] = "Select a player in the current Lottery to view their Ticket Info"
L["Configuration Panel Ticket Info Select Raffle Player"] = "Select Raffle Player"
L["Configuration Panel Ticket Info Select Raffle Player Desc"] = "Select a player in the current Raffle to view their Ticket Info"
L["Configuration Panel Ticket Info Lottery Button"] = "View Lottery Player"
L["Configuration Panel Ticket Info Lottery Button Desc"] = "Views Info about the selected Lottery Entry"
L["Configuration Panel Ticket Info Raffle Button"] = "View Raffle Player"
L["Configuration Panel Ticket Info Raffle Button Desc"] = "Views Info about the selected Raffle Entry"

L["Configuration Panel No Guild Cut on No Winner"] = "No Winner, No Cut"
L["Configuration Panel No Guild Cut on No Winner Desc"] = "When enabled, if no one wins the Jackpot and no one wins Second Place the Guild will not receive a cut of the Jackpot.\n|cffff0000This option can only be changed while no Lottery Event is active.|r"