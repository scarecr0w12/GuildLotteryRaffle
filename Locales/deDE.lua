local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GuildLotteryRaffle", "deDE")
if not L then return end

-- Class Name Translations
L["Death Knight"] = "Todesritter"
L["Demon Hunter"] = "Dämonenjäger"
L["Druid"] = "Druide"
L["Hunter"] = "Jäger"
L["Mage"] = "Magier"
L["Monk"] = "Mönch"
L["Paladin"] = "Paladin"
L["Priest"] = "Priester"
L["Rogue"] = "Schurke"
L["Shaman"] = "Schamane"
L["Warlock"] = "Hexenmeister"
L["Warrior"] = "Krieger"

-- Lottery & Raffle Translation
L["Lottery"] = "Lotterie"
L["Raffle"] = "Verlosen"
L["Guild Lottery"] = "Gildenlotterie" -- Currently used for Mail Subject text detection
L["Guild Raffle"] = "Gildenverlosung" -- Currently used for Mail Subject text detection