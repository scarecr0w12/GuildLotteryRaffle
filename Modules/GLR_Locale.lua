GLR_L = {}

local isDone = false

GLR_L.TextModifer = 1
GLR_L.ButtonModifer = 1

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

local function ChangeToFrenchSettings()
	
	--Main Frame (Lottery)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_GoToRaffleButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11 + 1)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_AddPlayerToLotteryButtonText:SetFont(GLR_UI.ButtonFont, 10)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_NewLotteryButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	--GLR_UI.GLR_MainFrame.GLR_ConfirmStartLotteryBorder:SetSize(185, 75)
	
	--Main Frame (Raffle)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_GoToLotteryButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11 + 1)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_AddPlayerToRaffleButtonText:SetFont(GLR_UI.ButtonFont, 10)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_NewRaffleButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	--GLR_UI.GLR_MainFrame.GLR_ConfirmStartRaffleBorder:SetSize(185, 75)
	
	--Main Frame (General)
	GLR_UI.GLR_MainFrame.GLR_AlertGuildButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessButton:SetSize(135, 26)
	GLR_UI.GLR_MainFrame.GLR_ConfirmAbortRollProcessBorder:SetSize(185, 75)
	
	--New Lottery Frame
	GLR_UI.GLR_NewLotteryEventFrame.GLR_StartNewLotteryButton:SetSize(140, 26)
	GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle:SetFont(GLR_UI.ButtonFont, GLR_L.TextModifer * 13)
	
	--New Raffle Frame
	GLR_UI.GLR_NewRaffleEventFrame.GLR_StartNewRaffleButton:SetSize(140, 26)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_SelectDateTitle:SetFont(GLR_UI.ButtonFont, GLR_L.TextModifer * 13)
	GLR_UI.GLR_NewRaffleEventFrame.GLR_AllowInvalidItemCheckButton:SetPoint("BOTTOMLEFT", GLR_UI.GLR_NewRaffleEventFrame, "BOTTOMLEFT", 15, 45)
	
	--Add Player to Lottery Frame
	--GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ConfirmAddPlayerToLotteryButton:SetSize(140, 26)
	
	--Add Player to Raffle Frame
	--GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ConfirmAddPlayerToRaffleButton:SetSize(140, 26)
	
	--Edit Player in Lottery Frame
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectLotteryPlayer:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "TOPLEFT", 35, -35)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayer:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInLotteryFrame, "LEFT", 45, 0)
	GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_SelectedLotteryPlayerTickets:SetPoint("RIGHT", GLR_UI.GLR_EditPlayerInLotteryFrame, "RIGHT", -45, 0)
	--GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ConfirmEditLotteryPlayerButton:SetSize(140, 26)
	
	--Edit Player in Raffle Frame
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectRafflePlayer:SetPoint("TOPLEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "TOPLEFT", 35, -35)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayer:SetPoint("LEFT", GLR_UI.GLR_EditPlayerInRaffleFrame, "LEFT", 45, 0)
	GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_SelectedRafflePlayerTickets:SetPoint("RIGHT", GLR_UI.GLR_EditPlayerInRaffleFrame, "RIGHT", -45, 0)
	--GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ConfirmEditRafflePlayerButton:SetSize(140, 26)
	
	--Mail Scan Button
	GLR_UI.GLR_ScanMailButton:SetSize(140, 26)
	
	isDone = true
	
end

local function ChangeToSpanishSettings()
	
	--Main Frame (Lottery)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_BeginLotteryButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	GLR_UI.GLR_MainFrame.GLR_LotteryFrame.GLR_EditPlayerInLotteryButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	
	--Main Frame (Raffle)
	GLR_UI.GLR_MainFrame.GLR_RaffleFrame.GLR_EditPlayerInRaffleButtonText:SetFont(GLR_UI.ButtonFont, GLR_L.ButtonModifer * 11)
	
	--New Lottery Frame
	GLR_UI.GLR_NewLotteryEventFrame.GLR_SelectDateTitle:SetFont(GLR_UI.ButtonFont, GLR_L.TextModifer * 13)
	
	--Add Player to Lottery Frame
	--GLR_UI.GLR_AddPlayerToLotteryFrame.GLR_ConfirmAddPlayerToLotteryButton:SetSize(140, 26)
	
	--Add Player to Raffle Frame
	--GLR_UI.GLR_AddPlayerToRaffleFrame.GLR_ConfirmAddPlayerToRaffleButton:SetSize(140, 26)
	
	--Edit Player in Lottery Frame
	--GLR_UI.GLR_EditPlayerInLotteryFrame.GLR_ConfirmEditLotteryPlayerButton:SetSize(220, 26)
	
	--Edit Player in Raffle Frame
	--GLR_UI.GLR_EditPlayerInRaffleFrame.GLR_ConfirmEditRafflePlayerButton:SetSize(220, 26)
	
	isDone = true
	
end

local changed = false
local int = false

function GLR_L:SetFontSizes()
	
	local locale = GetLocale()
	
	if locale == nil then return end
	if locale == "enUS" and not isDone then
		isDone = true
	elseif locale == "esES" and not isDone then
		GLR_L.TextModifer = 0.9
		GLR_L.ButtonModifer = 0.8
		ChangeToSpanishSettings()
	elseif locale == "frFR" and not isDone then
		GLR_L.TextModifer = 0.85
		GLR_L.ButtonModifer = 0.8
		ChangeToFrenchSettings()
	end
	
end