local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GuildLotteryRaffle", "frFR")
if not L then return end

local GLR_VersionText = GetAddOnMetadata("GuildLotteryRaffle", "Version")

--To search for new things that need translating, click CTRL + F
--Then Copy: NEEDS TRANSLATING

-- Addon DEFAULT_CHAT_FRAME Translations
L["GLR - Core - Disabled Message"] = "Le mod est désactiver, veuillez activé le pour commencer une Loterie/tirage"
L["GLR - Core - Disabled No Guild Message"] = "Tu a besoin d'être dans une guilde pour l'utilisé."
L["GLR - Core - Invalid Raffle Item"] = "Invalide tirage objet detectée"

-- Addon Error/Completion Message Translations
L["GLR - Error - Zero Entries"] = "Impossible de commencée l'évenement avec aucune inscription"
L["GLR - Error - No Entries Found"] = "Aucune inscription trouvée"
L["GLR - UI > Config > Events - Confirm Cancel"] = "Confirme Annulé"
--NEEDS TRANSLATING
L["GLR - UI > Config - Confirm Action"] = "Confirm Action"
L["GLR - UI > Config > Events - Confirm Cancel Desc"] = "Doit être cochée pour annulée l'évenement actuel"
L["GLR - Core - Confirm Cancel False"] = "La case doit être cochée, confirmant que vous souhaité annulée l'évenement."
L["GLR - Core - Lottery Canceled Message"] = "L'évenement de Loterie actuel a été annulé"
L["GLR - Core - Raffle Canceled Message"] = "La tirage actuel a été annulé"
L["GLR AddOn Loaded Msg 1"] = "Loterie de Guilde & tirage AddOn Version"
L["GLR AddOn Loaded Msg 2"] = "Chargé avec succès"
L["GLR - Error - Cant Create Calendar Events"] = "Vous n'êtes pas autorisé a créer d'évenement de guilde. Veuillez, contacter le maitre de guilde pour faire la correction."
L["GLR - Error - Calendar Events Disabled"] = "La creation des événements du calendrier est désactiver. Veuillez activé le (Activer / Désactiver les événements du calendrier) pour créer un évenement de guilde dans le calendrier."
--NEEDS TRANSLATING
L["GLR - Core - Initialization Complete"] = "Initialization Complete! Multi-Guild Roster Updated."
L["GLR - Core - Ticket Giveaway"] = "Everyone has received up to %PlayerTickets %word for the current %name event."

-- Frame Title Font String Translations
L["Guild Lottery & Raffles"] = true -- Title of the mod. Set to true as it won't be translated.
L["GLR - UI > Main - Lottery & Raffle Info"] = "Loterie & tirage Info" -- Lottery Info Frame Title
L["GLR - UI > Main - Player Ticket Information"] = "Joueurs & et leurs billets total" -- Lottery Player Name Frame Title
--L["GLR - UI > Main - Ticket Pool"] = "Ticket Pool" -- Unused Ticket Frame Title
L["GLR - UI > Main - Ticket Number Range"] = "Portée du nombre de billets" -- Ticket Number Range Frame Title
L["GLR - UI > Config > Options > Tickets - View Ticket Info Title"] = "Voir les billets du joueur"
--NEEDS TRANSLATING
L["GLR - UI > UpdateFrame - New Update"] = "AddOn Updated"

-- Lottery & Raffle Translation
L["Lottery"] = "Loterie"
L["Raffle"] = "Tirage"
--NEEDS TRANSLATING
L["Both"] = "Both"

-- Detect Lottery/Raffle Msg Translation (must all be lower case characters, and have a ! before the text)
L["Detect Lottery"] = "!loterie"
L["Detect Raffle"] = "!tirage"

-- Class Name Translations
L["Death Knight"] = "Chevalier de la mort"
L["Demon Hunter"] = "Chasseur de démons"
L["Druid"] = "Druide"
L["Hunter"] = "Chasseur"
L["Mage"] = "Mage"
L["Monk"] = "Moine"
L["Paladin"] = "Paladin"
L["Priest"] = "Prêtre"
L["Rogue"] = "Voleur"
L["Shaman"] = "Chaman"
L["Warlock"] = "Démoniste"
L["Warrior"] = "Guerrier"

-- Month Name Translations
L["January"] = "Janvier"
L["February"] = "Février"
L["March"] = "Mars"
L["April"] = "Avril"
L["May"] = "Mai"
L["June"] = "Juin"
L["July"] = "Juillet"
L["August"] = "Aôut"
L["September"] = "Septembre"
L["October"] = "Octobre"
L["November"] = "Novembre"
L["December"] = "Decembre"

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
L["2018"] = "2018" --Current Year + One More year (can create calendar events up to one year ahead)
L["2019"] = "2019"

-- Calendar Guild Announcement Text Translations
L["GLR - Core - Calendar Lottery Title"] = "Loterie de Guilde"
L["GLR - Core - Calendar Raffle Title"] = "tirage de Guilde"
L["Calendar Guild Announcement Part 1"] = "Les billets son"
L["Calendar Guild Announcement Part 2"] = "Or chaque"
L["Calendar Guild Announcement Part 3"] = "Billets peuvent être achetée par personne"
L["Calendar Guild Announcement Part 4"] = "Contact"
L["Calendar Guild Announcement Part 5"] = "Pour plus de détails"

-- Button Font String Translations
L["New Lottery Button"] = "Nouvelle Loterie"
L["New Raffle Button"] = "Nouvelle Tirage"
L["Begin Lottery Button"] = "Début Loterie"
L["Begin Raffle Button"] = "Début Tirage"
L["Alert Guild Button"] = "Alerte de Guilde"
L["New Player Button"] = "Nouveau joueur"
L["Edit Players Button"] = "Modifier" --les joueurs
L["Configure Button"] = "Configurer"
L["Go To Raffle Button"] = "Aller à la tirage"
L["Go To Lottery Button"] = "Aller à la loterie"
L["Confirm Start Button"] = "Confirmer le début"
L["Start New Lottery Button"] = "Commencer la loterie"
L["Start New Raffle Button"] = "Commencer la tirage"
L["Confirm Add Player Button"] = "Ajoutez un joueur"
L["Confirm Edit Player Button"] = "Modifier un joueur"
L["Confirm Action Button"] = "Confirmer"
L["Confirm Add Raffle Item"] = "Okay"
L["Abort Roll"] = "Avorter"
L["Confirm Abort Roll"] = "Confirmer l'abandon"
L["Scan Mail Button"] = "Scanner le Courrier"

-- Lottery Info Frame Font String Translations
L["Lottery Date"] = "Date de Loterie"
L["Raffle Date"] = "Date de tirage"
L["Lottery Name"] = "Nom de la Loterie"
L["Raffle Name"] = "Nom de la tirage"
L["Starting Gold"] = "Montant de départ"
L["Raffle First Place"] = "Prix de la première place"
L["Raffle Second Place"] = "Prix de la Deuxième place"
L["Raffle Third Place"] = "Prix de la Troisième place"
--TRANSLATION NEEDED
L["Raffle Sales"] = "Ticket Sales"
L["Jackpot"] = "Gros Lot"
L["Raffle Second Place"] = "Prix de la Deuxième place"
L["Max Tickets"] = "Max Billets"
L["Ticket Price"] = "Prix du billet"
L["Winner Guaranteed"] = "Gagnant garantie"

-- New Lottery Frame Font String Translations
L["New Lottery Settings"] = "Paramètres de Nouvelle Loterie"
L["Select Valid Lottery Date"] = "Selectionne une date valide pour la nouvelle Loterie"
L["Hour"] = "Heure:"
L["Minute"] = "Minute:"
L["Set Lottery Name"] = "Nom de la loterie" --"Définir le nom de la loterie"
L["Set Starting Gold"] = "Définir Montant initial"
L["Set Maximum Tickets"] = "Maximum billets"
L["Set Ticket Price"] = "Prix du billet"
L["Set Second Place Prize"] = "Deuxième place"
L["Set Guild Cut"] = "Pourcentage de guilde"

-- New Raffle Frame Font String Translations
L["New Raffle Settings"] = "Paramètres de la nouvelle tirage"
L["Select Valid Raffle Date"] = "Selectionne une date valide pour la nouvelle tirage"
L["Set Raffle Name"] = "Nom de la tirage"
L["Set First Place"] = "Première place"
L["Set Second Place"] = "Deuxième place"
L["Set Third Place"] = "Troisième place"

-- Add Player Frame Font String Translations (general)
L["Type Player Name"] = "Nom du joueur:"
L["Add Player Tickets"] = "Ajouter des billets:"
L["Add Player Must Have Tickets"] = "Le joueur doit avoir au moins 1 billet"
L["Add Player No Name Given"] = "Veuillez entrer un nom de joueur"
L["Add Player They Already Exist"] = "Le joueur existe déjà"
L["Add Player Max Tickets Exceeded"] = "Les billets dépassent la limite maximale"
L["Add Player Cant Have 0 Tickets"] = "Le joueur ne peut pas avoir 0 billets"
L["No Player Found"] = "Aucun joueur trouvé"

-- Add Player to Lottery Frame Font String Translations
L["Add Player to Lottery"] = "Ajouter un joueur à la Loterie"

-- Add Player to Raffle Frame Font String Translations
L["Add Player to Raffle"] = "Ajouter un joueur à la tirage"

-- Edit Player Frame Font String Translations
L["Edit Players in Lottery"] = "Modifier les joueurs dans la Loterie"
L["Edit Players in Raffle"] = "Modifier les joueurs dans la tirage"
L["Select Player to Edit"] = "Sélectionner un joueur:"
L["Edit Player Name Below"] = "Modifier le nom"
L["Edit Player Tickets Below"] = "Modifier les billets"
L["Edit Player Name Exists & Max Tickets Exceeded"] = "Nom déjà existant, nombre maximum de billet dépassé"
L["Edit Player Name Exists"] = "Nom déjà existant"
L["Edit Player Max Tickets Exceeded"] = "Les billets dépassent la limite maximale"
L["Edit Player Ticket Not Numerical"] = "Le changement de billet doit être numérique"

-- New Lottery/Raffle Frame Error Message Translations
L["Guild Cut Error"] = "Le pourcentage de guilde doit être comprise entre 0 et 100"
L["Second Place Error"] = "La deuxième place doit être comprise entre 0 et 100"
L["Guild & Second Place Error"] = "Le total de la deuxième place & du pourcentage de guilde ne peut pas dépasser 100"
L["Invalid Ticket Error"] = "Prix du billet invalide"
L["Max Ticket Error"] = "Max billet doit être compris entre 1 et 50000"
L["Starting Gold Error"] = "Or de départ invalide"
L["Lottery Name Error"] = "Veuillez entrer un nom pour votre loterie"
L["Month Error"] = "Veuillez sélectionner un mois valide"
L["Day Error"] = "Veuillez sélectionner un jour valide"
L["Hour Error"] = "Veuillez sélectionner une heure valide"
L["Date Error"] = "Veuillez sélectionner une date valide"
L["Prize Error"] = "Veuillez entrer au moins un prix"

-- Mail Scanning Error/Completion Message Translations
L["Mail Scan Start"] = "Démarrage du processus d'analyse du courrier"
L["Mail Scan Refreshing Mailbox"] = "Rafraichir le courrier"
L["Mail Scan Processing"] = "En traitement"
L["Mail Scan Complete"] = "Processus d'analyse du courrier terminé"
L["Mail Scan Interrupted"] = "Processus d'analyse du courrier interrompu, cadre de la boîte de réception fermé."
L["Mail Scan Format String 1"] = "pour"
L["Mail Scan Format String 2"] = "Or reçu"
L["Mail Scan Extra Ticket String 1"] = "envoyé"
L["Mail Scan Extra Ticket String 2"] = "Or supplémentaire"
L["Mail Scan Extra Ticket String 3"] = "Ce montant peut leurs être renvoyé ou aller à la banque de guilde"

-- View Player Ticket Info Frame Font String Translations
L["Ticket Info Player Name"] = "Nom du Joueur"
L["Ticket Info Player Tickets P1"] = "Acheté"
L["Ticket Info Player Tickets P2"] = "Billets"
L["Ticket Info Gold Value P1"] = "Valeur"
L["Ticket Info Gold Value P2"] = "Or"

-- Lottery/Raffle Roll Guild Text Translations
-- Initiate Lottery / Raffle Roll
L["GLR Title with Version"] = "Guild Lottery & Raffles v" -- The 'v' at the end denotes the Version of the mod
L["Begin Lottery Draw"] = "La Loterie commencera sous peu"
L["Begin Raffle Draw"] = "Le tirage au sort de tirage commencera sous peu"
L["No Lottery Active"] = "Aucune loterie active"
L["No Raffle Active"] = "Aucune tirage active"
L["Draw In Progress"] = "Le tirage est en cours, veuillez attendre qu'il se termine."
-- Step 1
L["Lottery Draw Step 1 Part 1"] = "GLR: Un total de"
L["Lottery Draw Step 1 Part 2"] = "Les billets ont été vendus, pour un total de"
L["Lottery Draw Step 1 Part 3"] = "Or."
L["Raffle Draw Step 1"] = "Prix de tirage"
L["Raffle Draw Step 1 Prize 1"] = "Prix de la première place"
L["Raffle Draw Step 1 Prize 2"] = "Prix de la deuxième place"
L["Raffle Draw Step 1 Prize 3"] = "Prix de la troisième place"
-- Step 2
L["Lottery Draw Step 2 Invalid Tickets Part 1"] = "GLR: Il y a: "
L["Lottery Draw Step 2 Invalid Tickets Part 2"] = " Billets non utilisés. Si le numéro gagnant est l'un d'entre eux, le ticket gagnant sera re-tiré. Ce processus peut prendre du temps."
L["Lottery Draw Step 2 Part 1"] = "GLR: Les numéros de billets vont de"
L["Lottery Draw Step 2 Part 2"] = "à"
-- Step 3
L["Lottery Draw Step 3 Fixed Variable 1"] = "% du gros lot."
L["Lottery Draw Step 3 Fixed Variable 2"] = "GLR: Personne n'est assuré de gagner le gros lot, cependant personne n'a de chance de gagner le deuxième prix."
L["Lottery Draw Step 3 Fixed Variable 3"] = "GLR: La guilde a décidé de ne pas prendre un pourcentage du jackpot."
L["Lottery Draw Step 3 Condition 1"] = "GLR: Il n'y a pas de deuxième place tant qu'un gagnant est garanti! Cependant, la guilde prend "
L["Lottery Draw Step 3 Condition 2"] = "GLR: Il n'y a pas de deuxième place tant qu'un gagnant est garanti! La guilde a également décidé de ne pas prendre un pourcentage du gros lot!"
L["Lottery Draw Step 3 Condition 3 Guild Part"] = "GLR: La prise de guilde est "
L["Lottery Draw Step 3 Condition 3"] = "GLR: Si personne ne gagne le gros lot, quelqu'un a une chance de gagner la deuxième place pour "
-- Step 4
L["Lottery Draw Step 4 Fixed Variable 1"] = "Or."
L["Lottery Draw Step 4 Fixed Variable 2"] = "GLR: Comme aucun gagnant n'est garanti, si personne ne remporte le jackpot de"
L["Lottery Draw Step 4 Fixed Variable 3"] = "Or. Il y a une chance pour quelqu'un de gagner"
L["Lottery Draw Step 4 Condition 1 Part 1"] = "GLR: Après la prise de guilde de"
L["Lottery Draw Step 4 Condition 1 Part 2"] = "Or, le total restant du gros lot est de"
L["Lottery Draw Step 4 Announce Roll"] = "GLR: Le roulement commencera dans 10 secondes."
-- Step 5
L["Lottery Draw Step 5 Announce Winning Ticket"] = "GLR: Le numéro du ticket gagnant est: "
L["Raffle Draw Step 5 Announce First Ticket"] = "GLR: Le premier numéro de ticket gagnant est: "
L["Raffle Draw Step 5 Announce Second Ticket"] = "GLR: Le deuxième numéro de ticket gagnant est: "
L["Raffle Draw Step 5 Announce Third Ticket"] = "GLR: Le troisième numéro de ticket gagnant est: "
L["Lottery Draw Step 5 Winner Found Part 1"] = "GLR: Un gagnant a été trouvé! "
L["Lottery Draw Step 5 Winner Found Part 2"] = " est le gagnant, recevant "
L["Lottery Draw Step 5 Winner Found Part 3"] = " Or."
L["Raffle Draw Step 5 Winner Found Fixed Variable"] = " est le gagnant, recevant "
L["Raffle Draw Step 5 First Winner Found"] = "GLR: Un gagnant a été trouvé pour la première place! "
L["Raffle Draw Step 5 Second Winner Found"] = "GLR: Un gagnant a été trouvé pour la deuxième place! "
L["Raffle Draw Step 5 Third Winner Found"] = "GLR: Un gagnant a été trouvé pour la troisième place! "
L["Lottery Draw Step 5 Guilds Take Part 1"] = "GLR: La guilde recevra: "
L["Lottery Draw Step 5 Guilds Take Part 2"] = " Or."
L["Lottery Draw Step 5 Unused Ticket Found Part 1"] = "GLR: Le numéro de ticket gagnant était "
L["Lottery Draw Step 5 Unused Ticket Found Part 2"] = " et apparié un numéro de ticket non utilisé, re-tirant un nouveau numéro de ticket gagnant."
L["Lottery Draw Step 5 Unused Ticket Redraw"] = "GLR: Le re-tirage va commencer dans 10 secondes."
L["Lottery Draw Step 5 No Winner Found"] = "GLR: Aucun gagnant n'a pu être trouvé pour: "
L["Lottery Draw Step 5 Draw Second Place"] = "GLR: Le tirage pour la deuxième place commencera dans 10 secondes."
-- Step 6
L["Lottery Draw Step 6 Announce Second Place Winning Ticket"] = "GLR: Le numéro de ticket gagnant pour la deuxième place est: "
L["Lottery Draw Step 6 Winner Found Part 1"] = "GLR: Un gagnant de la deuxième place a été trouvé! "
L["Lottery Draw Step 6 Winner Found Part 2"] = " recevra "
L["Lottery Draw Step 6 Winner Found Part 3"] = " Or."
L["Lottery Draw Step 6 Guilds Take Part 1"] = "GLR: La guilde recevra: "
L["Lottery Draw Step 6 Guilds Take Part 2"] = " Or."
L["Lottery Draw Step 6 Next Lottery Starts Part 1"] = "GLR: La prochaine loterie commencera avec au moins "
L["Lottery Draw Step 6 Next Lottery Starts Part 2"] = " Or."
L["Lottery Draw Step 6 Unused Ticket Found Part 1"] = "GLR: Le numéro de billet gagnant était "
L["Lottery Draw Step 6 Unused Ticket Found Part 2"] = " et apparié un numéro de ticket non utilisé, redessinant un nouveau numéro de ticket gagnant."
L["Lottery Draw Step 6 Unused Ticket Redraw"] = "GLR: Le re-tirage va commencer dans 10 secondes."
L["Lottery Draw Step 6 No Winner Found"] = "GLR: Le numéro de billet gagnant de la deuxième place était: "
L["Lottery Draw Step 6 No Second Place Part 1"] = "GLR: Aucun gagnant n'a été trouvé pour la deuxième place. La prochaine loterie commencera avec au moins "
L["Lottery Draw Step 6 No Second Place Part 2"] = " Or."
-- Lottery/Raffle Completed Message
L["Lottery Draw Complete"] = "GLR: Tirage de loterie terminé."
L["Raffle Draw Complete"] = "GLR: Tirage de tirage terminé."

-- Abort Roll Message
L["Abort Roll Message"] = "GLR: Processus de tirage interrompu."

-- Alert Guild Translations
L["Alert Guild GLR Title No Version"] = "Guild Lottery & Raffle v"
L["Alert Guild GLR Title"] = "Guild Lottery & Raffles v" .. GLR_VersionText -- The 'v' is to denote the version of the mod
L["Alert Guild Lottery Scheduled"] = "Une loterie prévue pour"
L["Alert Guild Raffle Scheduled"] = "Une tirage est prévu pour"
L["Alert Guild LaR Scheduled"] = "Une loterie et tirage est prévu pour"
L["Alert Guild Event Name"] = "Nom de l'évenement"
L["Alert Guild Ticket Info Part 1"] = "Les billets son"
L["Alert Guild Ticket Info Part 2"] = "Or chaque."
L["Alert Guild Ticket Info Part 3"] = "Un maximum de"
L["Alert Guild Ticket Info Part 4"] = "billets peuvent être acheter par personne."
L["Alert Guild Tickets Bought Part 1"] = "Le gros lot est de"
L["Alert Guild Tickets Bought Part 2"] = "Or."
L["Alert Guild Raffle Tickets Bought"] = "Les billets de tirage ont été acheter."
L["Alert Guild Whisper For Lottery Info"] = "Envoyer le message 'loterie' en chat de guilde pour plus de détails."
L["Alert Guild Whisper For Raffle Info"] = "Envoyer le message 'tirage' en chat de guilde pour plus de détails."
L["Alert Guild Whisper For LaR Info"] = "M'envoyer un message privée pour plus de détails."
L["Alert Guild Time Between Alerts Part 1"] = "Veuillez, attend au moin "
L["Alert Guild Time Between Alerts Part 2"] = " secondes avant d'envoyer une autre alerte."
L["Alert Guild No Lottery Active"] = "Aucune loterie n'est créer."
L["Alert Guild No Raffle Active"] = "Aucune tirage n'est créer."
L["Alert Guild No LoR Active"] = "Aucune loterie ou tirage n'est créer."

-- Send Player Ticket Info Translations
L["Send Info Title"] = "Guild Lottery & Raffle v"
L["Send Info Event Info 1"] = "Informations sur l'événement"
L["Send Info Event Info 2"] = "sur"
L["Send Info Player Lottery Entered"] = "Vous êtes entré dans une loterie prévue pour"
L["Send Info Player Raffle Entered"] = "Vous avez participé à une tirage prévu pour"
L["Send Info No Tickets Purchased Part 1"] = "Vous n'avez pas acheté de billets pour"
L["Send Info No Tickets Purchased Part 2"] = "Si c'est une erreur s'il vous plaît faites le moi savoir."
L["Send Info Can Purchase Tickets Part 1"] = "Vous êtes en mesure d'acheter"
L["Send Info Can Purchase Tickets Part 2"] = "Billets a"
L["Send Info Can Purchase Tickets Part 3"] = "or par billet."
L["Send Info Reply Lottery"] = "Pour voir les informations sur vos billets achetés, envoyez-moi un message avec «!loterie» après votre inscription.."
L["Send Info Reply Raffle"] = "Pour voir les informations sur les billets que vous avez achetés, envoyez-moi un message avec «!tirage» après votre inscription.."
L["Send Info Tickets Purchased Part 1"] = "Vous avez acheté"
L["Send Info Tickets Purchased Part 2"] = "Billets, et peuvent acheter"
L["Send Info Tickets Purchased Part 3"] = "Billets supplémentaires à"
L["Send Info Tickets Purchased Part 3.1"] = "Billets supplémentaires à"
L["Send Info Tickets Purchased Part 4"] = "par Billets."
L["Send Info Max Tickets Part 1"] = "Vous avez acheté le maximum de"
L["Send Info Max Tickets Part 2"] = "Billets."
L["Send Info Long Ticket Message"] = "Vos numéros de billets sont (message long):"
L["Send Info GLR"] = "GLR"
L["Send Info Current Jackpot Part 1"] = "Après le pourcentage de guilde"
L["Send Info Current Jackpot Part 2"] = "Le gros lot actuel est de"
L["Send Info Current Jackpot Part 3"] = "Or."
L["Send Info Current Prizes"] = "Le prix de tirage actuel est"
L["Send Info Short Ticket Message"] = "Vos numéros de billets sont"
L["Send Info Ticket Number Range Part 1"] = "Vos billets vont de"
L["Send Info Ticket Number Range Part 2"] = "à"
L["Send Info Player Online"] = "Informations sur le ticket reçu"
L["Send Info Player Not Online"] = "n'est pas en ligne. Ils seront envoyés la prochaine fois que vous serez en ligne."
L["Send Info No Active Lottery"] = "Aucune loterie n'est actuellement active."
L["Send Info No Active Raffle"] = "Aucun tirage n'est actuellement actif."
L["Send Info Must Wait 1"] = "Vous devez attendre au moins"
L["Send Info Must Wait 2"] = "secondes entre la réception des messages de loterie de la guilde et le tirage au sort."
L["Send Info GLR Disabled"] = "La Loterie de Guilde et le tirage au sort est actuellement désactivé."

-- Tooltip Translation
L["GLR Tooltip Title"] = "Loterie de Guilde & Tirage" -- Title used in all tooltips

-- New Lottery Button Tooltip Translations
L["Start New Lottery Button Tooltip"] = "Commencer une nouvelle loterie"
L["Start New Lottery Button Tooltip Warning"] = "ATTENTION: Cette action annulera toute loterie en cours"

-- Begin Lottery Button Tooltip Translation
L["Begin Lottery Button Tooltip"] = "Voulez-vous commencer le tirage au sort de la loterie?"

-- Alert Guild Button Tooltip Translation
L["Alert Guild Button Tooltip"] = "Alertez votre guilde à propos de la loterie actuelle"

-- Add Player Button Tooltip Translation
L["Add Player Button Tooltip"] = "Ajouter un nom au "

-- Edit Player Button Tooltip Translation
L["Edit Player Button Tooltip"] = "Modifier la liste actuelle des joueurs dans le "

-- New Raffle Button Tooltip Translations
L["Start New Raffle Button Tooltip"] = "Lancer un nouveau tirage"
L["Start New Raffle Button Tooltip Warning"] = "ATTENTION: Cette action annulera tout tirage en cours"

-- Begin Raffle Button Tooltip Translation
L["Begin Raffle Button Tooltip"] = "Voulez-vous commencer le tirage au sort?"

-- Open Interface Options Button Tooltip Translation
L["Configure Button Tooltip"] = "Configurer les paramètres de Guild Lottery & Raffles"

-- Confirm Start Lottery Button Tooltip Translations
L["Confirm Start Lottery Button Tooltip"] = "Es-tu sûr de vouloir commencer cette loterie?"
L["Confirm Start Lottery Button Tooltip Warning"] = "AVERTISSEMENT: Le retour ne sera pas possible."

-- Confirm Start Raffle Button Tooltip Translations
L["Confirm Start Raffle Button Tooltip"] = "Es-tu sûr de vouloir commencer ce tirage?"
L["Confirm Start Raffle Button Tooltip Warning"] = "AVERTISSEMENT: Le retour ne sera pas possible."

-- Start New Lottery Button Tooltip Translation
L["Start Lottery Button Tooltip"] = "Confirmer les nouveaux paramètres de loterie"

-- Start New Raffle Button Tooltip Translation
L["Start Raffle Button Tooltip"] = "Confirmer les nouveaux paramètres de tirage"

-- Confirm Add Player Button Tooltip Translation
L["Confirm Add Player to Lottery Button Tooltip"] = "Confirmer ajouter un nouveau joueur à la loterie"
L["Confirm Add Player to Raffle Button Tooltip"] = "Confirmer ajouter un nouveau joueur au tirage"

-- Confirm Edit Player Button Tooltip Translations
L["Confirm Edit Player Button Tooltip Part 1"] = "Confirmer la modification de "
L["Confirm Edit Player Button Tooltip Part 2"] = " à la loterie"
L["Confirm Edit Player Button Tooltip Part 3"] = " au tirage"

-- Confirm New Lottery Button Tooltip Translations
L["Confirm New Lottery Button Tooltip"] = "Confirmer le début de la nouvelle loterie?"
L["Confirm New Lottery Button Tooltip Warning"] = "ATTENTION: Cette action annulera toute loterie en cours"

-- Confirm New Raffle Button Tooltip Translations
L["Confirm New Raffle Button Tooltip"] = "Confirmer le début d'un nouveau tirage"
L["Confirm New Raffle Button Tooltip Warning"] = "ATTENTION: Cette action annulera tout tirage en cours"

-- Abort Roll Process Button Tooltip Translation
L["Abort Roll Process Button Tooltip"] = "Abandonner le tirage au sort actuel"
L["Abort Roll Process Button Tooltip Warning"] = "Confirmation requise"

-- Confirm Abort Roll Process Button Tooltip Translation
L["Confirm Abort Roll Process Button Tooltip"] = "Confirmez que vous souhaitez arrêter le tirage au sort actuel de loterie / tirage"

-- Scan Mail Button Tooltip Translations
L["Mail Scan - Button Tooltip Line 1"] = "Scanne votre courrier à la recherche d'éventuelles entrées de loterie ou de tirage. Cliquez pour démarrer ce processus."
--NEEDS TRANSLATION
--L["Scan Mail Button Tooltip Subject Line"] = "Subject lines must be" .. ' "Lottery" ' .. "or" .. ' "Raffle" ' .. "for their respective Events."
L["Mail Scan - Button Tooltip Line 3"] = "AVERTISSEMENT: pour que cela fonctionne correctement, vous devez garder la boîte aux lettres ouverte jusqu'à ce qu'elle soit complète."

-- Lottery Donation Translations
L["Donation Button"] = "Donation"
L["Donation Description Text"] = "Augmenter le montant du jackpot" --"Entrez le montant pour augmenter le gros lot"
L["Lottery Donation Tooltip"] = "Augmenter la taille du gros lot actuel"
L["Lottery Donation Confirmation Button Tooltip 1"] = "Augmenter le gros lot de loterie actuel par"
L["Lottery Donation Confirmation Button Tooltip 2"] = "Or."
L["Lottery Donation Confirmation Button Tooltip Warning"] = "ATTENTION: Cette action ne peut pas être annulée, le Jackpot ne peut pas être diminué en utilisant ceci."
--NEEDS TRANSLATION
L["Send Donation Info To Guild"] = "The Lottery Jackpot has been increased by: %Amountg %Silvers %Copperc Gold. The Jackpot is now: %new Gold."

-- Check Button Translations
L["Guarantee Winner Check Button"] = "Garantir un gagnant"
L["Allow Invalid Item Check Button"] = "Autoriser les articles non valides"

-- Check Button Tooltip Translations
L["Guarantee Winner Check Button Tooltip"] = "Garantir un gagnant pour cet événement de loterie"
L["Allow Invalid Item Check Button Tooltip"] = "Permet d'introduire des éléments que le mod détecte comme non valides"

-- Main Frame Edit Box Tooltip Translations
L["Starting Gold Edit Box Tooltip"] = "La valeur est en or et non en argent ou en cuivre"
L["Max Tickets Edit Box Tooltip"] = "Nombre maximum de tickets qu'un joueur peut obtenir"
L["Gold Value Edit Box Tooltip"] = "La valeur est en or et non en argent ou en cuivre"
--NEEDS TRANSLATING
L["Ticket Sales Edit Box Tooltip"] = "Displays the amount of Gold earned through ticket sales"

-- New Lottery Frame Edit Box Tooltip Translations
L["Set Lottery Name"] = "Définir le nom de la nouvelle loterie"
--These 3 need new translations (it's no longer just Gold)
--L["Set Starting Gold Part 1"] = "Définir l'or de départ pour la nouvelle loterie"
--L["Set Starting Gold Part 2"] = "Cet or vient de vous ou de votre guilde"
--L["Set Starting Gold Part 3"] = "Previous Lottery Gold is factored after the fact!"
L["Set Maximum Lottery Tickets"] = "Définir les billets maximum pour la nouvelle loterie"
L["Set Lottery Ticket Price"] = "Définissez le prix du billet pour la nouvelle loterie"
L["Set Second Place Percent"] = "Définissez le prix Second Place pour la nouvelle loterie"
L["Set Guild Cut Percent"] = "Définir le pourcentage de guilde pour la nouvelle loterie"
L["Set Lottery Percent Value"] = "La valeur est un pourcentage du gros lot, donc 100 seront égaux 100%"

-- New Raffle Frame Edit Box Tooltip Translations
L["Set Raffle Name"] = "Définir le nom du nouveau tirage"
L["Set Maximum Raffle Tickets"] = "Définissez le nombre maximum de billets pour le nouveau tirage"
L["Set Raffle Ticket Price"] = "Définir le prix du billet pour le nouveau tirage"
L["Set Raffle Prize"] = "Maj + Clic gauche sur l'article pour l'entrer dans le tirage au sort."
L["Set Raffle First Place Prize"] = "Cela deviendra l'objet pour le gagnant de la première place."
L["Set Raffle Second Place Prize P1"] = "Cela deviendra l'article pour le gagnant de la deuxième place."
L["Set Raffle Second Place Prize P2"] = "Laisser en blanc pour ne pas avoir une deuxième place."
L["Set Raffle Third Place Prize P1"] = "Cela deviendra l'objet pour le gagnant de la troisième place."
L["Set Raffle Third Place Prize P2"] = "Laisser en blanc pour ne pas avoir de troisième place."

-- Add Player to Lottery Frame Edit Box Tooltip Translations
L["Add Lottery Player Name Part 1"] = "Définir le nom du joueur à ajouter à la nouvelle loterie"
L["Add Lottery Player Name Part 2"] = "Les noms sont sensibles à la case, car le mod envoie un message"
L["Add Lottery Player Name Part 3"] = "au joueur à propos de son billet"
L["Add Lottery Player Tickets"] = "Définir le nombre de billets achetés pour la nouvelle loterie"

-- Edit Player in Lottery/Raffle Frame Edit Box Tooltip Translations
L["Edit Lottery Selected Player"] = "Modifier le nom des joueurs sélectionnés"
L["Edit Lottery Selected Player Tickets"] = "Modifier les tickets des joueurs sélectionnés, ne peut pas être supérieur à Max Billets"

-- Add Player to Raffle Frame Edit Box Tooltip Translations
L["Add Raffle Player Name Part 1"] = "Définir le nom du joueur à ajouter au nouveau tirage"
L["Add Raffle Player Name Part 2"] = "Les noms sont sensibles à la case, car le mod envoie un message"
L["Add Raffle Player Name Part 3"] = "au joueur à propos de son billet"
L["Add Raffle Player Tickets"] = "Définir le nombre de billets achetés pour le nouveau tirage"

--Donation Frame Edit Box Tooltip Translations
L["Donation Edit Box Tooltip"] = "Entrez un montant pour augmenter le gros lot de loterie actuel"

-- Minimap Button Tooltip Translations
L["Minimap Button Left Click"] = "Click gauche"
L["Minimap Button Left Click Info"] = "Ouvre Guild Lottery & Raffles"
L["Minimap Button Right Click"] = "Click droit"
L["Minimap Button Right Click Info"] = "Ouvre le panneau de configuration"
L["Minimap Button Hold Left"] = "Tenez le clic gauche"
L["Minimap Button Hold Left Info"] = "Fait glisser l'icône Minimap"

-- Configuration Panel Translations
--NEEDS TRANSLATING
L["Configuration Panel Information Tab"] = "Information"
L["Configuration Panel Options Tab"] = "Options"
L["Configuration Panel Options Tab Config"] = "Config"
L["Configuration Panel Options Tab General"] = "General"
L["Configuration Panel Options Tab Minimap"] = "Minimap"
L["Configuration Panel Options Tab Multi-Guild"] = "Multi-Guild"
L["Configuration Panel Events Tab"] = "Events"
L["Configuration Panel Profiles Tab"] = "Profiles"
L["Configuration Panel Preview"] = "Preview"
L["Configuration Panel Message Tab"] = "Messages"
L["Configuration Panel Message Preview"] = "Message Preview"
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
L["Configuration Panel Message Tab Formats Lottery"] = "Available Formats:\n  %lottery_price -> Becomes the Ticket Cost for your Event.\n  %lottery_max -> Becomes the Maximum Tickets for your Event.\n  %lottery_name -> Becomes the Name of your Event.\n  %lottery_date -> Becomes the Date for your Event.\n  %lottery_guild -> Becomes the Jackpot value your Guild receives.\n  %lottery_winamount -> Becomes the Jackpot value the winner will receive.\n  %lottery_total -> Becomes the total Jackpot value.\n  %lottery_tickets -> Becomes the number of Tickets Sold.\n  %lottery_reply -> Becomes the detection phrase.\n  %previous_winner -> Becomes the Winners Name of your Previous Event.\n  %previous_jackpot -> Becomes the amount the Previous Winner won."
L["Configuration Panel Message Tab Formats Raffle"] = "Available Formats:\n  %raffle_price -> Becomes the Ticket Cost for your Event.\n  %raffle_max -> Becomes the Maximum Tickets for your Event.\n  %raffle_name -> Becomes the Name of your Event.\n  %raffle_date -> Becomes the Date for your Event.\n  %raffle_total -> Becomes the Tickets Sold for your Event.\n  %raffle_reply -> Becomes the detection phrase."
L["Configuration Panel Message Too Long"] = "Warning - Custom Message can't be more than 255 characters!"
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

L["Configuration Panel Options Tab Ticket Info"] = "Billets"
L["Configuration Panel Options Tab Changelog"] = "Changelog"
L["Configuration Panel Mod Author"] = "Auteur du Mod:"
L["Configuration Panel Previous Authors"] = "Auteurs du Mod précédent:"
L["Configuration Panel Translators"] = "Traducteurs:"
L["Configuration Panel Toggle GLR"] = "Activer / désactiver ce mod"
L["Configuration Panel Toggle GLR Description"] = "Active ou désactive le mod Guild Lottery & Raffles."
L["Configuration Panel Slash Command List"] = "Liste des commandes Slash"
L["Configuration Panel How To Header"] = "Guide d'instruction"
L["Configuration Panel How To Step 1 P1"] = "Étape 1"
L["Configuration Panel How To Step 1 P2"] = "Pour lancer une loterie ou un tirage, ouvrez d'abord l'interface utilisateur de loterie et de tirages de guilde. (voir au dessus)"
L["Configuration Panel How To Step 2 P1"] = "Étape 2"
L["Configuration Panel How To Step 2 P2"] = "Si vous souhaitez lancer une loterie, cliquez sur le bouton Nouvelle loterie et entrez dans les paramètres de loterie. Pour lancer un tirage, cliquez sur le bouton 'Aller au tirage' et cliquez sur le bouton Nouveau tirage pour faire la même chose.."
L["Configuration Panel How To Step 3 P1"] = "Étape 3"
L["Configuration Panel How To Step 3 P2"] = "Pour ajouter des joueurs à la loterie active, cliquez sur le bouton Nouveau joueur pour modifier les joueurs de la loterie en cliquant sur le bouton Modifier les joueurs. Pour ajouter ou modifier des joueurs dans un tirage au sort, vous devez d'abord cliquer sur le bouton «Aller au tirage».."
L["Configuration Panel How To Step 4 P1"] = "Étape 4"
L["Configuration Panel How To Step 4 P2"] = "Pour lancer la procédure de loterie, cliquez sur le bouton Commencer la loterie, cela vous demandera de confirmer que vous souhaitez lancer la loterie. Cela empêchera d'ajouter ou de modifier des joueurs à la loterie jusqu'à ce que le tirage soit terminé. Pour lancer le même processus pour un tirage au sort, cliquez sur le bouton «Aller au tirage» et cliquez sur le bouton Commencer le tirage au sort.."
L["Configuration Panel Open GLR Command"] = "Ouvre l'interface utilisateur de Guild Lottery & Raffles."
L["Configuration Panel Help Command"] = "Vous amène à cette interface."
L["Configuration Panel Config Command"] = "Vous amène au panneau Options pour Guild Lottery & Raffles."
L["Configuration Panel Options Header"] = "Options pour Guild Lottery & Raffles"
L["Configuration Panel General Options Header"] = "réglages généraux"
L["Configuration Panel Options Minimap Header"] = "Minimap réglages"
L["Configuration Panel Options Lottery Header"] = "Loterie réglages"
L["Configuration Panel Options Guild Header"] = "Multi-Guild réglages"
L["Configuration Panel Options Raffle Header"] = "Tirage réglages"
L["Configuration Panel Options Open GLR Button"] = "Ouvre Guild Lottery & Raffles"
L["Configuration Panel Options Open GLR Button Desc"] = "Ouvre l'interface utilisateur de Guild Lottery & Raffles"
L["Configuration Panel Options Toggle Escape Key"] = "Active / Désactive touche d'échappement"
L["Configuration Panel Options Toggle Escape Key Desc"] = "Permet à la touche d'échappement de fermer l'interface utilisateur. Par défaut à On"
L["Configuration Panel Options Toggle Chat Info"] = "Activer / Désactiver les infos de discussion"
L["Configuration Panel Options Toggle Chat Info Desc"] = "Active / désactive les informations supplémentaires envoyées à votre cadre de discussion. Tels que le processus de numérisation de courrier détaillé."
L["Configuration Panel Options Toggle Full Ticket Info"] = "Activer / Désactiver les informations de ticket complètes"
L["Configuration Panel Options Toggle Full Ticket Info Desc"] = "Si activé, le mod enverra aux joueurs leurs informations de ticket sur plusieurs messages. Si cette option est désactivée, le mod indiquera simplement aux joueurs leur plage de numéros de ticket. La valeur par défaut est désactivée, car les loteries avec un Max Ticket massif peuvent recevoir du spam.."
L["Configuration Panel Options Time Between Alerts"] = "Définir l'heure (en secondes) à laquelle le mod vous permettra d'envoyer des alertes à votre guilde"
L["Configuration Panel Options Time Between Alerts Desc"] = "Utilisé pour empêcher une mauvaise utilisation des alertes envoyées par le mod, il varie de 30 secondes à 10 minutes (le temps est en secondes). La valeur par défaut est 60 secondes. Cela affecte également le temps que les joueurs peuvent recevoir des informations sur la loterie en vous chuchotant ou en tapant «loterie» dans le chat de guilde.."
L["Configuration Panel Options Toggle Multi Guild"] = "Multi-Guild évenement"
L["Configuration Panel Options Toggle Multi Guild Desc"] = "Si activé sur deux ou plusieurs de vos personnages, le mod traitera ces guildes comme une grande super-guilde. Vous permettant d'ajouter des joueurs de différentes guildes. Utile pour les guildes supportant plus de 1K membres. Nécessite un rechargement pour que les paramètres prennent effet."
L["Configuration Panel Options Toggle Multi Guild Failed"] = "Le statut Multi-Guild ne peut pas être modifié pendant qu'une loterie ou un tirage au sort est actuellement actif. Veuillez compléter ou annuler ces événements pour / link."
L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"] = "a un événement actif."
L["Configuration Panel Options Toggle Cross Faction"] = "Événements de faction croisée"
L["Configuration Panel Options Toggle Cross Faction Desc"] = "Avec les événements multi-guild activés, cette option vous permet de lier vos événements entre les deux factions. Il suffit de définir le personnage qui héberge."
L["Configuration Panel Options Toggle Cross Faction Failed"] = "Le statut Cross-Faction ne peut pas être modifié pendant qu'une loterie ou un tirage au sort est actuellement actif. Veuillez compléter ou annuler ces événements avant de changer cela."
L["Configuration Panel Options Toggle Calendar Events"] = "Créer des événements de calendrier"
L["Configuration Panel Options Toggle Calendar Events Desc"] = "Si cette option est activée, le mod créera des annonces de guilde pour vos événements de loterie ou de tirage. Requiert la permission de la guilde: 'est officier'"
L["Configuration Panel Options Minimap Toggle"] = "Bascule l'affichage de l'icône Minimap."
L["Configuration Panel Options Minimap Toggle Desc"] = "Lorsque cette option est activée, vous pouvez accéder rapidement à la loterie et aux tirages de guilde."
L["Configuration Panel Options Minimap X Range"] = "Définissez manuellement la valeur de l'axe X pour l'icône Minimap"
L["Configuration Panel Options Minimap X Range Desc"] = "Vous permet d'affiner le placement de l'icône Minimap"
L["Configuration Panel Options Minimap Y Range"] = "Définissez manuellement la valeur de l'axe Y pour l'icône Minimap"
L["Configuration Panel Options Minimap Y Range Desc"] = "Vous permet d'affiner le placement de l'icône Minimap"
L["Configuration Panel Options Cancel Lottery"] = "Annuler la loterie"
L["Configuration Panel Options Cancel Lottery Desc"] = "Annule la loterie en cours et efface toutes les données de loterie enregistrées. confirmation requise."
--NEEDS TRANSLATING
L["Configuration Panel Options Profile Header"] = "Profile Settings"
L["Configuration Panel Options Profile Desc"] = "Here you can set values for the AddOn to remember when making new events in the future. You can change these settings whenever you like."
L["Configuration Panel Options Profile Copy"] = "Copy Profile"
L["Configuration Panel Options Profile Copy Lottery Desc"] = "Copy a existing Lottery Profile"
L["Configuration Panel Options Profile Copy Raffle Desc"] = "Copy a existing Raffle Profile"
L["Configuration Panel Options Profile Max Tickets"] = "Max Tickets"
L["Configuration Panel Options Profile Enter Amount Desc"] = "Enter a amount for the AddOn to remember to start all future Events with."
L["Configuration Panel Options Profile Ticket Price"] = "Ticket Price"
L["Configuration Panel Options Lottery Profile Starting Gold"] = "Starting Gold"
L["Configuration Panel Options Lottery Profile Second Place"] = "Second Place"
L["Configuration Panel Options Lottery Profile Guild Cut"] = "Guild Cut"
L["Configuration Panel Options Lottery Profile Guarantee Winner"] = "Guarantee Winner"
L["Configuration Panel Options Lottery Profile Toggle Desc"] = "Set if the AddOn should remember to Guarantee a Winner for future Lotteries."
L["Configuration Panel Options Cancel Raffle"] = "Cancel Raffle"
L["Configuration Panel Options Cancel Raffle Desc"] = "Cancels the current Raffle, and wipes any saved Raffle data. Confirmation Required."
L["Configuration Panel Options Raffle Profile Invalid Items"] = "Invalid Items"
L["Configuration Panel Options Raffle Profile Toggle Desc"] = "Set if the AddOn should remember to allow Invalid Items to be entered when creating future Raffles."

L["Configuration Panel Options Profile Enter Amount Desc"] = "Enter a amount for the AddOn to remember to start all future Events with."
L["Configuration Panel Options Profile Ticket Price"] = "Ticket Price"
L["Configuration Panel Options Cancel Raffle"] = "Annuler le tirage"
L["Configuration Panel Options Cancel Raffle Desc"] = "Annule le tirage en cours et efface toutes les données de tirage enregistrées. confirmation requise."
L["Configuration Panel Options Allow Multiple Raffle Winners"] = "Autoriser les gagnants de plusieurs tirages"
L["Configuration Panel Options Allow Multiple Raffle Winners Desc"] = "Modifie la manière dont le tirage au sort sélectionne les gagnants. Si activé, le mod sélectionnera un gagnant différent pour chaque prix. Si désactivé, une personne peut gagner tous les prix."
L["Configuration Panel Options Multi-Guild Description"] = "Pour commencer le processus de liaison entre plusieurs guildes, vous devez activer l'option «Multi-Guild Events» dans les paramètres généraux. Cela doit être fait sur au moins deux personnages de différentes guildes pour définir leur statut en tant que lié. Pour organiser une loterie ou un tirage au sort pour les guildes liées, vous devez l’accueillir sur un personnage que vous avez lié.."
L["Configuration Panel Options Multi-Guild Tooltip"] = "Nécessite un rechargement pour confirmer le changement de statut. Ne peut pas être changé pendant qu'un loterie ou un tirage au sort est actif."
L["Configuration Panel Options Multi-Guild Linked Guilds"] = "Guildes actuellement liées"
L["Configuration Panel Options Multi-Guild Linked Characters"] = "Personnages actuellement liés"
L["Configuration Panel Ticket Info Header"] = "Information billet pour Guild Lottery & Raffles"
L["Configuration Panel Ticket Info Select Lottery Player"] = "Sélectionnez le joueur de loterie"
L["Configuration Panel Ticket Info Select Lottery Player Desc"] = "Sélectionnez un joueur dans la loterie actuelle pour voir ses informations de ticket"
L["Configuration Panel Ticket Info Select Raffle Player"] = "Sélectionnez un joueur de tirage au sort"
L["Configuration Panel Ticket Info Select Raffle Player Desc"] = "Sélectionnez un joueur dans le tirage en cours pour afficher ses informations de ticket"
L["Configuration Panel Ticket Info Lottery Button"] = "Voir le joueur de loterie"
L["Configuration Panel Ticket Info Lottery Button Desc"] = "Affichage d'informations sur l'entrée de loterie sélectionnée"
L["Configuration Panel Ticket Info Raffle Button"] = "Voir le joueur de tirage"
L["Configuration Panel Ticket Info Raffle Button Desc"] = "Affichage des informations sur l'entrée de tirage sélectionnée"
L["Configuration Panel Changelog Header"] = "Changelog pour Guild Lottery & Raffles" -- Full changelog won't be translated into other languages as that'd take too much time, so just giving the option to translate the header.

-- Anything new to translate will be at the bottom of the file.
L["Send Info Tickets Purchased First Msg 1"] = "Vous avez acheté"
L["Send Info Tickets Purchased First Msg 2"] = "hors de"
L["Send Info Tickets Purchased First Msg 3"] = "Limite de billet"