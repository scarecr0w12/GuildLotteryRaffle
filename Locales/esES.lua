local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GuildLotteryRaffle", "esES")
if not L then return end

local GLR_VersionText = GetAddOnMetadata("GuildLotteryRaffle", "Version")

--To search for new things that need translating, click CTRL + F
--Then Copy: NEEDS TRANSLATING

-- Addon DEFAULT_CHAT_FRAME Translations
L["GLR - Core - Disabled Message"] = "La extension esta deshabilitada, por favor activela para hacer una Loteria/Rifa"
L["GLR - Core - Disabled No Guild Message"] = "Tienes que permanecer en una hermandad para usar esta extension"
L["GLR - Core - Invalid Raffle Item"] = "Objeto invalido detectado en la Rifa"

-- Addon Error/Completion Message Translations
L["GLR - Error - Zero Entries"] = "No se puede empezar el evento con entradas nulas"
L["GLR - Error - No Entries Found"] = "No se ha encontrado ninguna entrada"
L["GLR - UI > Config > Events - Confirm Cancel"] = "Confirmar cancelacion"
--NEEDS TRANSLATING
L["GLR - UI > Config - Confirm Action"] = "Confirm Action"

L["GLR - UI > Config > Events - Confirm Cancel Desc"] = "Tiene que ser comprobado para cancelar el evento actual"
L["GLR - Core - Confirm Cancel False"] = "La casilla de confirmacion tiene que estar cliqueada, para confirmar que quieres cancelar el evento."
L["GLR - Core - Lottery Canceled Message"] = "Evento de Loteria actual cancelada"
L["GLR - Core - Raffle Canceled Message"] = "Evento de Rifa actual cancelada"
L["GLR AddOn Loaded Msg 1"] = "Version de la extension de, Guild Lottery & Raffle"
L["GLR AddOn Loaded Msg 2"] = "Carga completa"
L["GLR - Error - Cant Create Calendar Events"] = "No tienes permitido crear eventos de hermandad. Contacta con el maestro de hermandad para solucionarlo."
L["GLR - Error - Calendar Events Disabled"] = "La creacion de eventos en el calendario esta deshabilitada. Activala (Crear evento en el calendario) para crear un evento de hermandad en el calendario."
--NEEDS TRANSLATING
L["GLR - Core - Initialization Complete"] = "Initialization Complete! Multi-Guild Roster Updated."
L["GLR - Core - Ticket Giveaway"] = "Everyone has received up to %PlayerTickets %word for the current %name event."

-- Frame Title Font String Translations
L["Guild Lottery & Raffles"] = true -- Titulo de la extension. activando el modo true, no se traducira.
L["GLR - UI > Main - Lottery & Raffle Info"] = "Informacion de Guild Lottery & Raffle" -- Titulo del marco de informacion de loteria
L["GLR - UI > Main - Player Ticket Information"] = "Jugadores y sus boletos totales" -- Titulo del marco de nombre de jugador
--L["GLR - UI > Main - Ticket Pool"] = "Ticket Pool" -- Titulo del marco de boletos nulos
L["GLR - UI > Main - Ticket Number Range"] = "Rango de numero de boletos" -- Ticket Number Range Frame Title
L["GLR - UI > Config > Options > Tickets - View Ticket Info Title"] = "Ver boletos vendidos"
--NEEDS TRANSLATING
L["GLR - UI > UpdateFrame - New Update"] = "AddOn Updated"

-- Lottery & Raffle Translation
L["Lottery"] = "Loteria"
L["Raffle"] = "Rifa"
--NEEDS TRANSLATING
L["Both"] = "Both"

-- Detect Lottery/Raffle Msg Translation (must all be lower case characters, and have a ! before the text)
L["Detect Lottery"] = "!loteria"
L["Detect Raffle"] = "!rifa"

-- Class Name Translations
L["Death Knight"] = "Caballero de la Muerte"
L["Demon Hunter"] = "Cazador de demonios"
L["Druid"] = "Druida"
L["Hunter"] = "Cazador"
L["Mage"] = "Mago"
L["Monk"] = "Monje"
L["Paladin"] = "Paladín"
L["Priest"] = "Sacerdote"
L["Rogue"] = "Pícaro"
L["Shaman"] = "Chamán"
L["Warlock"] = "Brujo"
L["Warrior"] = "Guerrero"

-- Month Name Translations
L["January"] = "Enero"
L["February"] = "Febrero"
L["March"] = "Marzo"
L["April"] = "Abril"
L["May"] = "Mayo"
L["June"] = "Junio"
L["July"] = "Juio"
L["August"] = "Agosto"
L["September"] = "Septiembre"
L["October"] = "Octubre"
L["November"] = "Noviembre"
L["December"] = "Diciembre"

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
L["45"] = "45" -- 45 minutos de 60 (60 = 00)
L["2018"] = "2018" --Año actual + Un año mas (Se pueden crear eventos hasta el año que viene)
L["2019"] = "2019"

-- Calendar Guild Announcement Text Translations
L["GLR - Core - Calendar Lottery Title"] = "Loteria de hermandad"
L["GLR - Core - Calendar Raffle Title"] = "Rifa de hermandad"
L["Calendar Guild Announcement Part 1"] = "Los boletos vendidos son"
L["Calendar Guild Announcement Part 2"] = "Precio del boleto"
L["Calendar Guild Announcement Part 3"] = "Maximos boletos por persona"
L["Calendar Guild Announcement Part 4"] = "Contacto con el Guild Master"
L["Calendar Guild Announcement Part 5"] = "Para mas informacion"

-- Button Font String Translations
L["New Lottery Button"] = "Loteria Nueva"
L["New Raffle Button"] = "Rifa Nueva"
L["Begin Lottery Button"] = "Inicio de Loteria"
L["Begin Raffle Button"] = "Inicio de Rifa"
L["Alert Guild Button"] = "Alerta"
L["New Player Button"] = "Añadir Jugador"
L["Edit Players Button"] = "Editar Jugadores"
L["Configure Button"] = "Configuracion"
L["Go To Raffle Button"] = "GIr a la Rifa"
L["Go To Lottery Button"] = "Ir a la Lotería"
L["Confirm Start Button"] = "Iniciar"
L["Start New Lottery Button"] = "Nueva Lotería"
L["Start New Raffle Button"] = "Nueva Rifa"
L["Confirm Add Player Button"] = "Confirmar Jugador"
L["Confirm Edit Player Button"] = "Confirmar edicion de Personaje"
L["Confirm Action Button"] = "Confirmar"
L["Confirm Add Raffle Item"] = "Okay"
L["Abort Roll"] = "Abortar Sorteo"
L["Confirm Abort Roll"] = "Confirmar Abortar Sorteo"
L["Scan Mail Button"] = "Escanear Correo"

-- Lottery Info Frame Font String Translations
L["Lottery Date"] = "Fecha de Loteria"
L["Raffle Date"] = "Fecha de Rifa"
L["Lottery Name"] = "Nombre de Loteria"
L["Raffle Name"] = "Nombre de Rifa"
L["Starting Gold"] = "Cantidad inicial"
L["Raffle First Place"] = "Primer Premio"
L["Raffle Second Place"] = "Segundo Premio"
L["Raffle Third Place"] = "Tercer Premio"
L["Raffle Sales"] = "Ticket Sales"
L["Jackpot"] = "Bote"
L["Raffle Second Place"] = "Segundo Premio"
L["Max Tickets"] = "Boletos Maximos"
L["Ticket Price"] = "Precio del Boleto"
L["Winner Guaranteed"] = "Ganador Garantizado"

-- New Lottery Frame Font String Translations
L["New Lottery Settings"] = "Opciones de Nueva Loteria"
L["Select Valid Lottery Date"] = "Seleccione una fecha válida para la nueva Loteria"
L["Hour"] = "Hora:"
L["Minute"] = "Minutos:"
L["Set Lottery Name"] = "Nombre de Loteria"
L["Set Starting Gold"] = "Oros de Inicio"
L["Set Maximum Tickets"] = "Maximo de Boletos"
L["Set Ticket Price"] = "Precio del Boleto"
L["Set Second Place Prize"] = "Segundo Premio"
L["Set Guild Cut"] = "Parte de Hermandad"

-- New Raffle Frame Font String Translations
L["New Raffle Settings"] = "Opciones de Nueva Rifa"
L["Select Valid Raffle Date"] = "Seleccione una fecha válida para la nueva Rifa"
L["Set Raffle Name"] = "Nombre de Rifa"
L["Set First Place"] = "Primer Premio"
L["Set Second Place"] = "Segundo Premio"
L["Set Third Place"] = "Tercer Premio"

-- Add Player Frame Font String Translations (general)
L["Type Player Name"] = "Nombre de Jugador:"
L["Add Player Tickets"] = "Boletos:"
L["Add Player Must Have Tickets"] = "El Jugador requiere 1 boleto minimo"
L["Add Player No Name Given"] = "Por favor pon el nombre del Jugador"
L["Add Player They Already Exist"] = "Jugador ya Apuntado"
L["Add Player Max Tickets Exceeded"] = "Excedido el maximo de Boletos por Jugador"
L["Add Player Cant Have 0 Tickets"] = "Un Jugador no puede tener 0 Boletos"
L["No Player Found"] = "Jugador no encontrado"

-- Add Player to Lottery Frame Font String Translations
L["Add Player to Lottery"] = "Añadir Jugador a la Loteria"

-- Add Player to Raffle Frame Font String Translations
L["Add Player to Raffle"] = "Añadir jugador a la Rifa"

-- Edit Player Frame Font String Translations
L["Edit Players in Lottery"] = "Editar Jugadores en Loteria"
L["Edit Players in Raffle"] = "Editar Jugadores en Rifa"
L["Select Player to Edit"] = "Selecciona Jugador:"
L["Edit Player Name Below"] = "Editar Nombre de Jugador"
L["Edit Player Tickets Below"] = "Editar Boletos del Jugador"
L["Edit Player Name Exists & Max Tickets Exceeded"] = "Ese Nombre ya existe, Maximo de Boletos excedido"
L["Edit Player Name Exists"] = "Ese Nombre ya existe"
L["Edit Player Max Tickets Exceeded"] = "Los boletos exceden el Maximo"
L["Edit Player Ticket Not Numerical"] = "El cambio debe ser numerico"

-- New Lottery/Raffle Frame Error Message Translations
L["Guild Cut Error"] = "El porcentaje de Hermandad debe ser entre 0 y 100"
L["Second Place Error"] = "El segundo Premio debe ser entre 0 y 100"
L["Guild & Second Place Error"] = "El total del segundo Premio y el Porcentaje de Hermandad no puede superar el 100"
L["Invalid Ticket Error"] = "Precio de Boleto invalido"
L["Max Ticket Error"] = "El maximo de Boletos debe ser entre 0 y 50000"
L["Starting Gold Error"] = "Oros de Inicio invalido"
L["Lottery Name Error"] = "Selecciona un nombre de Loteria"
L["Month Error"] = "Selecciona un Mes valido"
L["Day Error"] = "Selecciona un Dia valido"
L["Hour Error"] = "Selecciona una Hora valida"
L["Date Error"] = "Selecciona una Fecha valida"
L["Prize Error"] = "Selecciona al menos 1 Premio"

-- Mail Scanning Error/Completion Message Translations
L["Mail Scan Start"] = "Escaneando"
L["Mail Scan Refreshing Mailbox"] = "Refrescando Buzon"
L["Mail Scan Processing"] = "Procesando"
L["Mail Scan Complete"] = "Escaneo de Buzon completo"
L["Mail Scan Interrupted"] = "Escaneo de buzon interrumpido, Ventana de Correo cerrada."
L["Mail Scan Format String 1"] = "Para"
L["Mail Scan Format String 2"] = "Oros recibido"
L["Mail Scan Extra Ticket String 1"] = "Enviado"
L["Mail Scan Extra Ticket String 2"] = "Oros Extra"
L["Mail Scan Extra Ticket String 3"] = "La cantidad puede ser devuelta, o donada a la Hermandad"

-- View Player Ticket Info Frame Font String Translations
L["Ticket Info Player Name"] = "Nombre de Jugador"
L["Ticket Info Player Tickets P1"] = "Comprado"
L["Ticket Info Player Tickets P2"] = "Boletos"
L["Ticket Info Gold Value P1"] = "Valor"
L["Ticket Info Gold Value P2"] = "Oros"

-- Lottery/Raffle Roll Guild Text Translations
-- Initiate Lottery / Raffle Roll
L["GLR Title with Version"] = "Guild Lottery & Raffles v" -- The 'v' at the end denotes the Version of the mod
L["Begin Lottery Draw"] = "La Loteria comenzara en Breve"
L["Begin Raffle Draw"] = "La Rifa comenzara en breve"
L["No Lottery Active"] = "Ninguna Loteria Activa"
L["No Raffle Active"] = "Ninguna Rifa activa"
L["Draw In Progress"] = "Evento en progreso, Espera a que se complete."
-- Step 1
L["Lottery Draw Step 1 Part 1"] = "GLR: Si nadie gana el Bote, Alguien puede ganar el 2do Premio: Un total de"
L["Lottery Draw Step 1 Part 2"] = "Boletos vendidos para un Total de"
L["Lottery Draw Step 1 Part 3"] = "Oros."
L["Raffle Draw Step 1"] = "Premios de la Rifa"
L["Raffle Draw Step 1 Prize 1"] = "1er Premio"
L["Raffle Draw Step 1 Prize 2"] = "2do Premio"
L["Raffle Draw Step 1 Prize 3"] = "3er Premio"
-- Step 2
L["Lottery Draw Step 2 Invalid Tickets Part 1"] = "GLR: Si nadie gana el Bote, Alguien puede ganar el 2do Premio: hay un total de: "
L["Lottery Draw Step 2 Invalid Tickets Part 2"] = " Boletos no vendidos. Si el numero ganador es uno de ellos, El jugador con ese numero recibira los oros pagado. Este proceso puede llevar un rato."
L["Lottery Draw Step 2 Part 1"] = "GLR: Los boletos van del rango de"
L["Lottery Draw Step 2 Part 2"] = "A"
-- Step 3
L["Lottery Draw Step 3 Fixed Variable 1"] = "% Del Bote."
L["Lottery Draw Step 3 Fixed Variable 2"] = "GLR: No esta asegurado un ganador para el Bote,Por lo tanto no esta asegurado un ganador de 2do Premio."
L["Lottery Draw Step 3 Fixed Variable 3"] = "GLR: La Hermandad ha decidido no cobrar Porcentaje."
L["Lottery Draw Step 3 Condition 1"] = "GLR: No se garantiza Ganador de 2do Premio! Por lo tanto el porcentaje de Hermandad es"
L["Lottery Draw Step 3 Condition 2"] = "GLR: No se garantiza Ganador de 2do Premio! La Hermandad ha decidido no cobrar Porcentaje!"
L["Lottery Draw Step 3 Condition 3 Guild Part"] = "GLR: El porcentaje de Hermandad es "
L["Lottery Draw Step 3 Condition 3"] = "GLR: Si nadie gana el Bote, Alguien puede ganar el 2do Premio "
-- Step 4
L["Lottery Draw Step 4 Fixed Variable 1"] = "Oros."
L["Lottery Draw Step 4 Fixed Variable 2"] = "GLR: Como ningún ganador está garantizado, si nadie gana el Jackpot de"
L["Lottery Draw Step 4 Fixed Variable 3"] = "Oros. Hay una oportunidad de Ganador"
L["Lottery Draw Step 4 Condition 1 Part 1"] = "GLR: Despues de que la Hermandad reciba De"
L["Lottery Draw Step 4 Condition 1 Part 2"] = "Oros, El Bote actual total es"
L["Lottery Draw Step 4 Announce Roll"] = "GLR: El sorteo empezara en 10 Segundos."
-- Step 5
L["Lottery Draw Step 5 Announce Winning Ticket"] = "GLR: Los numeros Ganadores son: "
L["Raffle Draw Step 5 Announce First Ticket"] = "GLR: El numero ganador del 1er Premio es el: "
L["Raffle Draw Step 5 Announce Second Ticket"] = "GLR: El numero Ganador del 2do Premio es el: "
L["Raffle Draw Step 5 Announce Third Ticket"] = "GLR: El numero Ganador del 3er Premio es el: "
L["Lottery Draw Step 5 Winner Found Part 1"] = "GLR: Tenemos un Ganador! "
L["Lottery Draw Step 5 Winner Found Part 2"] = " Es el Ganador, Recibiendo "
L["Lottery Draw Step 5 Winner Found Part 3"] = " Oros."
L["Raffle Draw Step 5 Winner Found Fixed Variable"] = " Es el Ganador, Recibiendo "
L["Raffle Draw Step 5 First Winner Found"] = "GLR: Tenemos Ganador del 1er Premio! "
L["Raffle Draw Step 5 Second Winner Found"] = "GLR: Tenemos Ganador del 2do Premio! "
L["Raffle Draw Step 5 Third Winner Found"] = "GLR: Tenemos Ganador del 3er Premio! "
L["Lottery Draw Step 5 Guilds Take Part 1"] = "GLR: El porcentaje de Hermandad es de: "
L["Lottery Draw Step 5 Guilds Take Part 2"] = " Oros."
L["Lottery Draw Step 5 Unused Ticket Found Part 1"] = "GLR: El numero ganador es el "
L["Lottery Draw Step 5 Unused Ticket Found Part 2"] = " Se ha encontrado un Boleto Nulo, Buscando a un nuevo numero Ganador."
L["Lottery Draw Step 5 Unused Ticket Redraw"] = "GLR: El reintento comenzara en 10 Segundos."
L["Lottery Draw Step 5 No Winner Found"] = "GLR: No se ha encontrado Ganador para: "
L["Lottery Draw Step 5 Draw Second Place"] = "GLR: El reintento para el 2do premio, comenzara en 10 segundos."
-- Step 6
L["Lottery Draw Step 6 Announce Second Place Winning Ticket"] = "GLR: El numero Ganador para el 2do Premio es el: "
L["Lottery Draw Step 6 Winner Found Part 1"] = "GLR: Se ha encontrado un Ganador para el 2do Premio! "
L["Lottery Draw Step 6 Winner Found Part 2"] = " Recibira "
L["Lottery Draw Step 6 Winner Found Part 3"] = " Oros."
L["Lottery Draw Step 6 Guilds Take Part 1"] = "GLR: La Hermandad recibira: "
L["Lottery Draw Step 6 Guilds Take Part 2"] = " Oros."
L["Lottery Draw Step 6 Next Lottery Starts Part 1"] = "GLR: La próxima lotería comenzará con al menos "
L["Lottery Draw Step 6 Next Lottery Starts Part 2"] = " Oros."
L["Lottery Draw Step 6 Unused Ticket Found Part 1"] = "GLR: El número de boleto Ganador es el "
L["Lottery Draw Step 6 Unused Ticket Found Part 2"] = " Se ha encontrado un Boleto Nulo, Reintentando para un Nuevo Boleto Ganador."
L["Lottery Draw Step 6 Unused Ticket Redraw"] = "GLR: El reintento comenzara en 10 Segundos."
L["Lottery Draw Step 6 No Winner Found"] = "GLR: El numero Ganador para el 2do Premio es el: "
L["Lottery Draw Step 6 No Second Place Part 1"] = "GLR: No se encontro Ganador para el 2do Premio. La próxima lotería comenzará con al menos "
L["Lottery Draw Step 6 No Second Place Part 2"] = " Oros."
-- Lottery/Raffle Completed Message
L["Lottery Draw Complete"] = "GLR: Loteria Finalizada."
L["Raffle Draw Complete"] = "GLR: Rifa Finalizada."

-- Abort Roll Message
L["Abort Roll Message"] = "GLR: Sorteo Abortado."

-- Alert Guild Translations
L["Alert Guild GLR Title No Version"] = "Guild Lottery & Raffle v"
L["Alert Guild GLR Title"] = "Guild Lottery & Raffles v" .. GLR_VersionText -- The 'v' is to denote the version of the mod
L["Alert Guild Lottery Scheduled"] = "Hay una Loteria para"
L["Alert Guild Raffle Scheduled"] = "Hay una Rifa para"
L["Alert Guild LaR Scheduled"] = "Hay una Loteria y una Rifa para"
L["Alert Guild Event Name"] = "Nombre de Evento"
L["Alert Guild Ticket Info Part 1"] = "Los Boletos son"
L["Alert Guild Ticket Info Part 2"] = "Oros cada uno."
L["Alert Guild Ticket Info Part 3"] = "Un maximo de"
L["Alert Guild Ticket Info Part 4"] = "Boletos pueden ser Comprados por Persona."
L["Alert Guild Tickets Bought Part 1"] = "El Bote es Ahora"
L["Alert Guild Tickets Bought Part 2"] = "Oros."
L["Alert Guild Raffle Tickets Bought"] = "Todos los boletos de Rifa han sido vendidos."
L["Alert Guild Whisper For Lottery Info"] = "Whispea '!lottery' Para mas detalles."
L["Alert Guild Whisper For Raffle Info"] = "Whispea '!raffle' Para mas detalles."
L["Alert Guild Whisper For LaR Info"] = "Whispea '!lottery' Para mas detalles. Whispea '!raffle' Para mas detalles."
L["Alert Guild Time Between Alerts Part 1"] = "Espera al menos "
L["Alert Guild Time Between Alerts Part 2"] = " Segundos, antes de enviar otra Alerta."
L["Alert Guild No Lottery Active"] = "No hay una Loteria Activa."
L["Alert Guild No Raffle Active"] = "No hay una Rifa activa."
L["Alert Guild No LoR Active"] = "No hay ninguna Loteria o Rifa activa."

-- Send Player Ticket Info Translations
L["Send Info Title"] = "Guild Lottery & Raffle v"
L["Send Info Event Info 1"] = "Informacion de Evento para"
L["Send Info Event Info 2"] = "en"
L["Send Info Player Lottery Entered"] = "Has entrado en la loteria para"
L["Send Info Player Raffle Entered"] = "Has entrado en la Rifa para"
L["Send Info No Tickets Purchased Part 1"] = "No has comprado Boletos"
L["Send Info No Tickets Purchased Part 2"] = "Si es un error, susurra al Guild Master."
L["Send Info Can Purchase Tickets Part 1"] = "Puedes comprar"
L["Send Info Can Purchase Tickets Part 2"] = "Boletos por"
L["Send Info Can Purchase Tickets Part 3"] = "Oros por Boleto."
L["Send Info Reply Lottery"] = "Para ver los Boletos que has comprado, mandame un mensaje con '!lottery' Despues de este mensaje."
L["Send Info Reply Raffle"] = "Para ver los Boletos que has comprado, mandame un mensaje con '!raffle' Despues de este mensaje."
L["Send Info Tickets Purchased Part 1"] = "Has Comprado"
L["Send Info Tickets Purchased Part 2"] = "Boletos, y puedes comprar"
L["Send Info Tickets Purchased Part 3"] = "Mas boletos por"
L["Send Info Tickets Purchased Part 3.1"] = "Otro Boleto por"
L["Send Info Tickets Purchased Part 4"] = "por Boleto."
L["Send Info Max Tickets Part 1"] = "Has comprado el maximo de"
L["Send Info Max Tickets Part 2"] = "Boletos."
L["Send Info Long Ticket Message"] = "Tus Numeros de Boletos son (Mensaje Largo):"
L["Send Info GLR"] = "Guild Lottery & Raffle"
L["Send Info Current Jackpot Part 1"] = "Despues la Hermandad recibe"
L["Send Info Current Jackpot Part 2"] = "El bote actual es de"
L["Send Info Current Jackpot Part 3"] = "Oros."
L["Send Info Current Prizes"] = "Los Premios de Rifa son"
L["Send Info Short Ticket Message"] = "Tus Numeros de Boletos Son"
L["Send Info Ticket Number Range Part 1"] = "El rango de tus Boletos son de"
L["Send Info Ticket Number Range Part 2"] = "a"
L["Send Info Player Online"] = "Mensaje de informacion recibido"
L["Send Info Player Not Online"] = "No esta Conectado. Recibira un aviso, la proxima vez que conecte."
L["Send Info No Active Lottery"] = "No hay una Loteria activa."
L["Send Info No Active Raffle"] = "No hay una Rifa activa."
L["Send Info Must Wait 1"] = "Tienes que esperar al menos"
L["Send Info Must Wait 2"] = "Segundos para recibir otro mensaje de Guild Lottery & Raffle."
L["Send Info GLR Disabled"] = "Guild Lottery & Raffle, esta desactivado ahora mismo."

-- Tooltip Translation
L["GLR Tooltip Title"] = "Rifas y Loterias" -- Title used in all tooltips

-- New Lottery Button Tooltip Translations
L["Start New Lottery Button Tooltip"] = "Empieza una nueva Loteria"
L["Start New Lottery Button Tooltip Warning"] = "CUIDADO: Esta accion cancelara la Loteria activa"

-- Begin Lottery Button Tooltip Translation
L["Begin Lottery Button Tooltip"] = "Quieres iniciar la Loteria?"

-- Alert Guild Button Tooltip Translation
L["Alert Guild Button Tooltip"] = "Avisar a la Hermandad de la Loteria Activa"

-- Add Player Button Tooltip Translation
L["Add Player Button Tooltip"] = "Añadir un Nuevo Nombre a la "

-- Edit Player Button Tooltip Translation
L["Edit Player Button Tooltip"] = "Editar los jugadores en la "

-- New Raffle Button Tooltip Translations
L["Start New Raffle Button Tooltip"] = "Nueva Loteria"
L["Start New Raffle Button Tooltip Warning"] = "CUIDADO: Esta accion cancelara la Rifa activa"

-- Begin Raffle Button Tooltip Translation
L["Begin Raffle Button Tooltip"] = "Quieres Iniciar la Rifa?"

-- Open Interface Options Button Tooltip Translation
L["Configure Button Tooltip"] = "Configura las opciones de la Rifa o Loteria"

-- Confirm Start Lottery Button Tooltip Translations
L["Confirm Start Lottery Button Tooltip"] = "Quieres Iniciar esta Loteria?"
L["Confirm Start Lottery Button Tooltip Warning"] = "CUIDADO: No se puede detener el Proceso."

-- Confirm Start Raffle Button Tooltip Translations
L["Confirm Start Raffle Button Tooltip"] = "Quieres Iniciar esta Rifa?"
L["Confirm Start Raffle Button Tooltip Warning"] = "CUIDADO: No se puede detener el Proceso."

-- Start New Lottery Button Tooltip Translation
L["Start Lottery Button Tooltip"] = "Confirmar los cambios de Loteria"

-- Start New Raffle Button Tooltip Translation
L["Start Raffle Button Tooltip"] = "Confirmar los cambios de Rifa"

-- Confirm Add Player Button Tooltip Translation
L["Confirm Add Player to Lottery Button Tooltip"] = "Confirmar añadir un Nuevo Jugador a la Loteria"
L["Confirm Add Player to Raffle Button Tooltip"] = "Confirmar añadir un Nuevo Jugador a la Rifa"

-- Confirm Edit Player Button Tooltip Translations
L["Confirm Edit Player Button Tooltip Part 1"] = "Confirmar la Edicion de "
L["Confirm Edit Player Button Tooltip Part 2"] = " En Loteria"
L["Confirm Edit Player Button Tooltip Part 3"] = " En Rifa"

-- Confirm New Lottery Button Tooltip Translations
L["Confirm New Lottery Button Tooltip"] = "Confirmar Nueva Loteria?"
L["Confirm New Lottery Button Tooltip Warning"] = "WARNING: This action will cancel any current Lottery"

-- Confirm New Raffle Button Tooltip Translations
L["Confirm New Raffle Button Tooltip"] = "Confirmar Nueva Rifa"
L["Confirm New Raffle Button Tooltip Warning"] = "CUIDADO: Esto cancelara la Rifa activa"

-- Abort Roll Process Button Tooltip Translation
L["Abort Roll Process Button Tooltip"] = "Anulando la Loteria/Rifa activa"
L["Abort Roll Process Button Tooltip Warning"] = "Necesaria Confirmacion"

-- Confirm Abort Roll Process Button Tooltip Translation
L["Confirm Abort Roll Process Button Tooltip"] = "Confirmar que quieres detener la Loteria/Rifa activa"

-- Scan Mail Button Tooltip Translations
L["Mail Scan - Button Tooltip Line 1"] = "Escanea el Correo para buscar entradas potenciales de Loterias o Rifas. Cliquea para empezar el Proceso."
--NEEDS Translation
--L["Scan Mail Button Tooltip Subject Line"] = "Subject lines must be" .. ' "Lottery" ' .. "or" .. ' "Raffle" ' .. "for their respective Events."
L["Mail Scan - Button Tooltip Line 3"] = "CUIDADO: Para que funcione todo bien, Debes mantener el buzon abierto hasta que se complete."

-- Lottery Donation Translations
L["Donation Button"] = "Donacion"
L["Donation Description Text"] = "Introducir cantidad para aumentar el Bote"
L["Lottery Donation Tooltip"] = "Aumenta el valor del Bote activo"
L["Lottery Donation Confirmation Button Tooltip 1"] = "Aumentar el tamaño del bote de loteria hasta"
L["Lottery Donation Confirmation Button Tooltip 2"] = "Oros."
L["Lottery Donation Confirmation Button Tooltip Warning"] = "AVISO: Esta accion no se puede deshacer, El bote no puede reducirse de esta manera."
--NEEDS TRANSLATION
L["Send Donation Info To Guild"] = "The Lottery Jackpot has been increased by: %Amountg %Silvers %Copperc Gold. The Jackpot is now: %new Gold."

-- Check Button Translations
L["Guarantee Winner Check Button"] = "Garantizar Ganador"
L["Allow Invalid Item Check Button"] = "Permitir Objetos Nulos"

-- Check Button Tooltip Translations
L["Guarantee Winner Check Button Tooltip"] = "Garantizar un Ganador para esta Loteria"
L["Allow Invalid Item Check Button Tooltip"] = "Detecta si la extension permite Objetos Nulos"

-- Main Frame Edit Box Tooltip Translations
L["Starting Gold Edit Box Tooltip"] = "El valor es en Oros, no en Platas, ni Cobres "
L["Max Tickets Edit Box Tooltip"] = "El numero maximo de Boletos por Jugador"
L["Gold Value Edit Box Tooltip"] = "El valor es en Oros, no en Platas, ni Cobres"

-- New Lottery Frame Edit Box Tooltip Translations
L["Set Lottery Name"] = "Pon un Nombre para la Nueva Loteria"
--L["Set Starting Gold Part 1"] = "Pon un Inicio de Oros para la nueva Loteria"
--L["Set Starting Gold Part 2"] = "Estos oros lo pone la Hermandad"
--L["Set Starting Gold Part 3"] = "Los oros de lotería anterior se tiene en cuenta después del hecho!"
L["Set Maximum Lottery Tickets"] = "Maximo de Boletos a Vender"
L["Set Lottery Ticket Price"] = "Precio de Loteria"
L["Set Second Place Percent"] = "Marca el porcentaje del 2do Premio"
L["Set Guild Cut Percent"] = "Marca el porcentaje de Hermandad"
L["Set Lottery Percent Value"] = "El valor es un Porcentaje del Bote, asi que 100 equivale al 100%"

-- New Raffle Frame Edit Box Tooltip Translations
L["Set Raffle Name"] = "Pon un nombre a la Rifa"
L["Set Maximum Raffle Tickets"] = "Selecciona el maximo de boletos para la Rifa"
L["Set Raffle Ticket Price"] = "Selecciona el precio para los Boletos para la Rifa"
L["Set Raffle Prize"] = "Shift + Click-Izquierdo en el Objeto para añadirlo a la Rifa."
L["Set Raffle First Place Prize"] = "Este sera el Objeto para el Ganador del 1er Premio."
L["Set Raffle Second Place Prize P1"] = "Este sera el Objeto para el Ganador del 2do Premio."
L["Set Raffle Second Place Prize P2"] = "Dejar en Blanco para no sortear 2do Premio."
L["Set Raffle Third Place Prize P1"] = "Este sera el Objeto para el Ganador del 3er Premio."
L["Set Raffle Third Place Prize P2"] = "Dejar en Blanco para no sortear 3er Premio."

-- Add Player to Lottery Frame Edit Box Tooltip Translations
L["Add Lottery Player Name Part 1"] = "Jugador a Añadir"
L["Add Lottery Player Name Part 2"] = "La extension detecta Mayusculas y Minusculas, como en los mensajes"
L["Add Lottery Player Name Part 3"] = "Para el jugador, sobre su informacion de Boletos"
L["Add Lottery Player Tickets"] = "Seleccion la cantidad de Boletos"

-- Edit Player in Lottery/Raffle Frame Edit Box Tooltip Translations
L["Edit Lottery Selected Player"] = "Editar el Nombre de Jugador"
L["Edit Lottery Selected Player Tickets"] = "Editar los Boletos del jugador seleccionado, No puede superar el maximo de tickets"

-- Add Player to Raffle Frame Edit Box Tooltip Translations
L["Add Raffle Player Name Part 1"] = "Selecciona el nombre de Jugador, para añadir a la Rifa"
L["Add Raffle Player Name Part 2"] = "La extension detecta Mayusculas y Minusculas, como en los mensajes"
L["Add Raffle Player Name Part 3"] = "Para el jugador, sobre su informacion de Boletos"
L["Add Raffle Player Tickets"] = "Seleccion la cantidad de Boletos"

-- Donation Frame Edit Box Tooltip Translations
L["Donation Edit Box Tooltip"] = "Introduce la cantidad para incrementar el bote actual de Loteria"

-- Minimap Button Tooltip Translations
L["Minimap Button Left Click"] = "Boton Izquierdo"
L["Minimap Button Left Click Info"] = "Abre la Extension"
L["Minimap Button Right Click"] = "Boton Derecho"
L["Minimap Button Right Click Info"] = "Abre el panel de Configuracion"
L["Minimap Button Hold Left"] = "Mantener Click Izquierdo"
L["Minimap Button Hold Left Info"] = "Mueve el Icono del Minimapa"

-- Configuration Panel Translations
L["Configuration Panel Information Tab"] = "Informacion"
L["Configuration Panel Options Tab"] = "Opciones"
L["Configuration Panel Options Tab Config"] = "Configuracion"
L["Configuration Panel Options Tab General"] = "General"
L["Configuration Panel Options Tab Minimap"] = "Minimapa"
--NEEDS TRANSLATING
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

L["Configuration Panel Options Tab Ticket Info"] = "Boletos"
L["Configuration Panel Options Tab Changelog"] = "Cambios en la version"
L["Configuration Panel Mod Author"] = "Creador:"
L["Configuration Panel Previous Authors"] = "Anterior Creadors:"
L["Configuration Panel Translators"] = "Traductores:"
L["Configuration Panel Toggle GLR"] = "Activa/Desactiva esta Extension"
L["Configuration Panel Toggle GLR Description"] = "Alterna entre activar/desactivar esta Extension."
L["Configuration Panel Slash Command List"] = "Lista de Comandos"
L["Configuration Panel How To Header"] = "Guia Basica"
L["Configuration Panel How To Step 1 P1"] = "Paso 1"
L["Configuration Panel How To Step 1 P2"] = "Para comenzar una Lotería o una rifa, primero abra la Interfaz de Usuario de Lotería y Rifas de Hermandad. (véase más arriba)"
L["Configuration Panel How To Step 2 P1"] = "Paso 2"
L["Configuration Panel How To Step 2 P2"] = "Si desea comenzar una Lotería, haga clic en el botón Nueva Lotería e ingrese en la Configuración de Lotería. Para comenzar una rifa, haga clic en el botón 'Ir a la rifa' y haga clic en el botón Nueva rifa allí y haga lo mismo"
L["Configuration Panel How To Step 3 P1"] = "Paso 3"
L["Configuration Panel How To Step 3 P2"] = "Para agregar jugadores a la Lotería activa, haga clic en el botón Nuevo jugador, para editar Jugadores en la lotería, haga clic en el botón Editar jugadores. Para agregar o editar jugadores en una rifa, primero debe hacer clic en el botón 'Ir a la rifa'."
L["Configuration Panel How To Step 4 P1"] = "Step 4"
L["Configuration Panel How To Step 4 P2"] = "Para comenzar el proceso de lanzamiento para una Lotería, haga clic en el botón Comenzar Lotería, esto le pedirá que confirme que desea comenzar la Lotería. Al hacerlo, evitará agregar o editar jugadores en la lotería hasta que se complete el sorteo. Para comenzar el mismo proceso para una rifa, haga clic en el botón 'Ir a rifa' y haga clic en el botón Comenzar rifa."
L["Configuration Panel Open GLR Command"] = "Abre el Interfaz de la Extension."
L["Configuration Panel Help Command"] = "Te lleva a la Inmterfaz."
L["Configuration Panel Config Command"] = "Te lleva al Panel de Opciones."
L["Configuration Panel Options Header"] = "Opciones de la Extension"
L["Configuration Panel General Options Header"] = "Opciones Generales"
L["Configuration Panel Options Minimap Header"] = "Opciones del Minimapa"
L["Configuration Panel Options Lottery Header"] = "Opciones de Loteria"
--NEEDS TRANSLATING
L["Configuration Panel Options Guild Header"] = "Multi-Guild Settings"

L["Configuration Panel Options Raffle Header"] = "Opciones de Rifa"
L["Configuration Panel Options Open GLR Button"] = "Abre la Extension"
L["Configuration Panel Options Open GLR Button Desc"] = "Abre el panel de Interfaz"
L["Configuration Panel Options Toggle Escape Key"] = "Activa ESC"
L["Configuration Panel Options Toggle Escape Key Desc"] = "Permite cerrar la extension con ESC (Por defecto, Activa)"
L["Configuration Panel Options Toggle Chat Info"] = "Activa la informacion en el Chat"
L["Configuration Panel Options Toggle Chat Info Desc"] = "Alterna con Activo/Inactivo la informacion Extra que se envia al Chat. Como el proceso de informacion avanzado de escaneo del correo."
L["Configuration Panel Options Toggle Full Ticket Info"] = "Alterna la informacion Total de los Boletos"
L["Configuration Panel Options Toggle Full Ticket Info Desc"] = "Si está habilitado, la extension enviará a los jugadores su información de Boletos a través de múltiples mensajes. Si está desactivado, la extension simplemente les dirá a los jugadores su rango de números de Boletos. Los valores predeterminados para deshabilitados como loterías con Maximo de Boletos masivos pueden recibir spam."
L["Configuration Panel Options Time Between Alerts"] = "Establezca el tiempo (en segundos) que la extension le permitirá enviar alertas a su Hermandad"
L["Configuration Panel Options Time Between Alerts Desc"] = "Se usa para evitar el mal uso de las Alertas enviadas por la extension, oscila entre 30 segundos y 10 minutos (el tiempo está en segundos). El valor predeterminado es 60 segundos. Esto también afecta el tiempo que los jugadores pueden recibir la información de la Lotería, ya sea susurrándolo o escribiendo 'lotería' en el chat de Hermandad."
L["Configuration Panel Options Toggle Multi Guild"] = "Eventos para multiples Hermandades"
L["Configuration Panel Options Toggle Multi Guild Desc"] = "Si está habilitado en dos o más de tus Personajes, la extension tratará a esas Hermandades como una gran Súper Hermandad. Permitiéndole agregar jugadores de diferentes Hermandades. Útil para Hermandades que apoyan a más de 1000 miembros. Requiere una recarga para que la configuración surta efecto."
L["Configuration Panel Options Toggle Multi Guild Failed"] = "El estado de Multiples Hermandades no se puede cambiar mientras una lotería o rifa esté actualmente activa. Complete o cancele esos eventos para Desenlazar."
L["Configuration Panel Options Toggle Multi Guild Failed Other Toon"] = "Hay un evento activo."
L["Configuration Panel Options Toggle Cross Faction"] = "Eventos para ambas Facciones"
L["Configuration Panel Options Toggle Cross Faction Desc"] = "Con los eventos de múltiples Hermandades habilitados, esta opción te permite vincular tus eventos en ambas facciones. Solo debe establecerse en el personaje que aloja."
L["Configuration Panel Options Toggle Cross Faction Failed"] = "El estado de ambas facciónes no se puede cambiar mientras una lotería o rifa esté actualmente activa. Complete o cancele esos eventos antes de cambiar esto."
L["Configuration Panel Options Toggle Calendar Events"] = "Crear eventos en el Calendario"
L["Configuration Panel Options Toggle Calendar Events Desc"] = "Si está habilitado, la extension creará Anuncios de Hermandad para su Lotería o Eventos de la rifa. Requiere permiso de Administrador"
L["Configuration Panel Options Minimap Toggle"] = "Activa o desactiva el Icono del minimapa."
L["Configuration Panel Options Minimap Toggle Desc"] = "Cuando esta activado permite el acceso rapido a Guild Lottery & Raffle"
L["Configuration Panel Options Minimap X Range"] = "Eje X del icono en el Minimapa"
L["Configuration Panel Options Minimap X Range Desc"] = "Permite ajustar el lugar del icono en el minimapa"
L["Configuration Panel Options Minimap Y Range"] = "Eje Y del icono en el Minimapa"
L["Configuration Panel Options Minimap Y Range Desc"] = "Permite ajustar el lugar del icono en el minimapa"
L["Configuration Panel Options Cancel Lottery"] = "Cancelar Loteria"
L["Configuration Panel Options Cancel Lottery Desc"] = "Cancela la Loteria activa, y Limpia los datos guardados, Confirmacion requerida."
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

L["Configuration Panel Options Cancel Raffle"] = "Cancelar Rifa"
L["Configuration Panel Options Cancel Raffle Desc"] = "Cancela la Rifa activa, y Limpia los datos guardados, Confirmacion requerida."
--NEEDS TRANSLATING
L["Configuration Panel Options Raffle Profile Invalid Items"] = "Invalid Items"
L["Configuration Panel Options Raffle Profile Toggle Desc"] = "Set if the AddOn should remember to allow Invalid Items to be entered when creating future Raffles."

L["Configuration Panel Options Allow Multiple Raffle Winners"] = "Permite Multiples Ganadores"
L["Configuration Panel Options Allow Multiple Raffle Winners Desc"] = "Cambia cómo la rifa selecciona a los ganadores. Si está habilitado, la extension seleccionará un ganador diferente para cada premio. Si está desactivado, una persona puede terminar ganando todos los premios."
L["Configuration Panel Options Multi-Guild Description"] = "Para comenzar el proceso de vincular múltiples Hermandades, debe habilitar la opción 'Eventos de múltiples Hermandades' en Configuración general. Esto se debe hacer en al menos dos caracteres en diferentes Hermandades para establecer su estado como Linkeado. Para organizar una Lotería o una Rifa para las Hermandades Vinculadas, debes alojarla en un personaje que hayas vinculado."
L["Configuration Panel Options Multi-Guild Tooltip"] = "Requiere una recarga para confirmar el cambio de estado. No se puede cambiar mientras haya un evento de lotería o rifa activo."
L["Configuration Panel Options Multi-Guild Linked Guilds"] = "Hermandades vinculadas actualmente"
L["Configuration Panel Options Multi-Guild Linked Characters"] = "Personajes vinculados actualmente"
L["Configuration Panel Ticket Info Header"] = "Informacion de Boletos para Guild Lottery & Raffle"
L["Configuration Panel Ticket Info Select Lottery Player"] = "Seleccionar Jugador de Loteria"
L["Configuration Panel Ticket Info Select Lottery Player Desc"] = "Seleccione un jugador en la lotería actual para ver su información de entradas"
L["Configuration Panel Ticket Info Select Raffle Player"] = "Seleccionar Jugador de Rifa"
L["Configuration Panel Ticket Info Select Raffle Player Desc"] = "Seleccione un jugador en la Rifa actual para ver su información de entradas"
L["Configuration Panel Ticket Info Lottery Button"] = "Ver Jugador de Loteria"
L["Configuration Panel Ticket Info Lottery Button Desc"] = "Información de vistas sobre la entrada de lotería seleccionada"
L["Configuration Panel Ticket Info Raffle Button"] = "Ver Jugador de Rifa"
L["Configuration Panel Ticket Info Raffle Button Desc"] = "Ver Información sobre la entrada de la rifa seleccionada"
L["Configuration Panel Changelog Header"] = "Cambios para Lotería y Rifa de la Hermandad" -- El registro de cambios completo no se traducirá a otros idiomas, ya que eso llevaría demasiado tiempo, por lo que le da la opción de traducir el encabezado.