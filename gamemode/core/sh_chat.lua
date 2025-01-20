impulse.chatCommands = impulse.chatCommands or {}
impulse.chatClasses = impulse.chatClasses or {}

function impulse.RegisterChatCommand(name, cmdData)
	if not cmdData.adminOnly then cmdData.adminOnly = false end
	if not cmdData.leadAdminOnly then cmdData.leadAdminOnly = false end
	if not cmdData.cMOnly then cmdData.cMOnly = false end
	if not cmdData.superAdminOnly then cmdData.superAdminOnly = false end
	if not cmdData.description then cmdData.description = "" end
	if not cmdData.requiresArg then cmdData.requiresArg = false end
	if not cmdData.requiresAlive then cmdData.requiresAlive = false end

    impulse.chatCommands[name] = cmdData
end

if SERVER then
	util.AddNetworkString("impulseChatNetMessage")
	function meta:SendChatClassMessage(id, message, target)
		net.Start("impulseChatNetMessage")
		net.WriteUInt(id, 8)
		net.WriteString(message)
		if target then
			net.WriteUInt(target:EntIndex(), 8)
		end
		net.Send(self)
	end
else
	function impulse.RegisterChatClass(id, onReceive)
		impulse.chatClasses[id] = onReceive
	end
end

local oocCol = color_white
local oocTagCol = Color(200, 0, 0)
local yellCol = Color(255, 140, 0)
local whisperCol = Color(65, 105, 225)
local infoCol = Color(135, 206, 250)
local talkCol = Color(255, 255, 100)
local radioCol = Color(55, 146, 21)
local pmCol = Color(45, 154, 6)

--[[
local oocCommand = {
	description = "Talk out of character globally.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if impulse.OOCClosed then
			return ply:Notify("OOC chat has been suspsended and will return shortly.")	
		end

		local timeout = impulse.OOCTimeouts[ply:SteamID()]
		if timeout then
			return ply:Notify("You have an active OOC timeout that will remain for "..string.NiceTime(timeout - CurTime())..".")
		end

		ply.OOCLimit = ply.OOCLimit or ((ply:IsDonator() and impulse.Config.OOCLimitVIP) or impulse.Config.OOCLimit)
		local timeLeft = timer.TimeLeft(ply:UserID().."impulseOOCLimit")

		if ply.OOCLimit < 1 and not ply:IsAdmin() then
			return ply:Notify("You have ran out of OOC messages. Wait "..string.NiceTime(timeLeft).." for more.")
		end

		for v,k in pairs(player.GetAll()) do
			k:SendChatClassMessage(2, rawText, ply)
		end

		ply.OOCLimit = ply.OOCLimit - 1

		net.Start("impulseUpdateOOCLimit")
		net.WriteUInt(timeLeft, 16)
		net.WriteBool(false)
		net.Send(ply)

		hook.Run("ProcessOOCMessage", rawText)
	end
}
impulse.RegisterChatCommand("/ooc", oocCommand)
impulse.RegisterChatCommand("//", oocCommand)
--]]

local announceCommand = {
	description = "Talk out of character globally.",
	requiresArg = true,
    adminOnly = true,
	onRun = function(ply, arg, rawText)
        for v,k in pairs(player.GetAll()) do
			k:SendChatClassMessage(18, rawText, ply)
		end
    end
}

impulse.RegisterChatCommand("/announce", announceCommand)


local loocCommand = {
	description = "Talk out of character locally.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if ply.hasOOCTimeout then
			return ply:Notify("You have an active OOC timeout that will remain for "..string.NiceTime(ply.hasOOCTimeout - CurTime())..".")
		end

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				if impulse.OwOify or false then
					rawText = OwOifyText(rawText,true,true)
				end
                k:SendChatClassMessage(3, rawText, ply)
			end
		end

		hook.Run("ProcessOOCMessage", rawText)
	end
}

impulse.RegisterChatCommand("/looc", loocCommand)
impulse.RegisterChatCommand("//.", loocCommand)

--local pmCommand = {
--	description = "Directly messages the player specified.",
--	requiresArg = true,
--	onRun = function(ply, arg, rawText)
--		local name = arg[1]
--		local message = string.sub(rawText, (string.len(name) + 2))
--		message = string.Trim(message)
--
--		if not message or message == "" then
--			return ply:Notify("Invalid argument.")
--		end
--
--		local plyTarget = impulse.FindPlayer(name)
--
--		if plyTarget and ply != plyTarget then
--			plyTarget:SendChatClassMessage(4, message, ply)
--			plyTarget.PMReply = ply
--
--			ply:SendChatClassMessage(5, message, ply)
--		else
--			return ply:Notify("Could not find player: "..tostring(name))
--		end
--	end
--}
--
--impulse.RegisterChatCommand("/pm", pmCommand)

--local replyCommand = {
--	description = "Replies to the last player who directly messaged you.",
--	requiresArg = true,
--	onRun = function(ply, arg, rawText)
--		local message = rawText
--
--		if not message or message == "" then
--			return ply:Notify("Invalid argument.")
--		end
--
--		if not ply.PMReply or not IsValid(ply.PMReply) then
--			return ply:Notify("Target not found.")
--		end
--
--		local plyTarget = ply.PMReply
--
--		if plyTarget and ply != plyTarget then
--			plyTarget:SendChatClassMessage(4, message, ply)
--			plyTarget.PMReply = ply
--
--			ply:SendChatClassMessage(5, message, ply)
--		end
--	end
--}
--
--impulse.RegisterChatCommand("/reply", replyCommand)

local yellCommand = {
	description = "Yell in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 6, rawText, ply) or rawText

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.YellDistance ^ 2) then 
				k:SendChatClassMessage(6, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/y", yellCommand)

local whisperCommand = {
	description = "Whisper in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 7, rawText, ply) or rawText

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.WhisperDistance ^ 2) then 
				k:SendChatClassMessage(7, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/w", whisperCommand)

local radioCommand = {
	description = "Send a radio message to all units.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 8, rawText, ply) or rawText

		if ply:IsCP() then
			for v,k in pairs(player.GetAll()) do
				if (k:IsCP() or k:IsAdmin()) then 
					k:SendChatClassMessage(8, rawText, ply)
				end
			end
		else
			hook.Run("RadioMessageFallback", ply, rawText)
		end
	end
}

impulse.RegisterChatCommand("/radio", radioCommand)
impulse.RegisterChatCommand("/r", radioCommand)

local meCommand = {
	description = "Preform an action in character.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		rawText = hook.Run("ChatClassMessageSend", 9, rawText, ply) or rawText
		
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(9, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/me", meCommand)

local itCommand = {
	description = "Perform an action from a third party.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(10, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/it", itCommand)

--local advertCommand = {
--	description = "Broadcasts the advert provided.",
--	requiresArg = true,
--	requiresAlive = true,
--	onRun = function(ply, arg, rawText)
--		if not impulse.Teams.Data[ply:Team()].canAdvert or impulse.Teams.Data[ply:Team()].canAdvert == false then 
--			return ply:Notify("Your team cannot make an advert.") 
--		end
--
--		if ply:GetSyncVar(SYNC_ARRESTED, false) then
--			return ply:Notify("You cannot make an advert while arrested.")
--		end
--
--
--		timer.Simple(15, function()
--			if IsValid(ply) and ply:IsPlayer() then
--				for v,k in pairs(player.GetAll()) do
--					k:SendChatClassMessage(12, rawText, ply)
--				end
--			end
--		end)
--
--		ply:Notify("Your advert has been sent and will be broadcast shortly.")
--	end
--}
--
--impulse.RegisterChatCommand("/advert", advertCommand)

local rollCommand = {
	description = "Generate a random number between 0 and 100.",
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		local rollResult = (tostring(math.random(1,100)))

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then 
				k:SendChatClassMessage(11, rollResult, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/roll", rollCommand)

local dropMoneyCommand = {
	description = "Drops the specified amount of money on the floor.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, arg, rawText)
		if arg[1] and tonumber(arg[1]) then
			local value = math.floor(tonumber(arg[1]))
			if ply:CanAfford(value) and value > 0 then
				ply:TakeMoney(value)

				local trace = {}
				trace.start = ply:EyePos()
				trace.endpos = trace.start + ply:GetAimVector() * 85
				trace.filter = ply

				local tr = util.TraceLine(trace)
				local note = impulse.SpawnMoney(tr.HitPos, value, ply)

				ply.DroppedMoneyC = math.Clamp((ply.DroppedMoneyC and ply.DroppedMoneyC + 1) or 1, 0, impulse.Config.DroppedMoneyLimit)
				ply.DroppedMoney = ply.DroppedMoney or {}
				ply.DroppedMoneyCA = (ply.DroppedMoneyCA and ply.DroppedMoneyCA + 1) or 1

				ply.DroppedMoney[ply.DroppedMoneyCA] = note
				note.DropKey = ply.DroppedMoneyCA

				if ply.DroppedMoneyC == impulse.Config.DroppedMoneyLimit then
					for v,k in pairs(ply.DroppedMoney) do
						if k and IsValid(k) then
							k:Remove()
							break
						end
					end
				end

				hook.Run("PlayerDropMoney", ply, note)
				ply:Notify("You have dropped "..impulse.Config.CurrencyPrefix..value..".")
			else
				return ply:Notify("You cannot afford to drop that amount of money.")
			end
		else
			return ply:Notify("Invalid argument.")
		end
	end
}

impulse.RegisterChatCommand("/dropmoney", dropMoneyCommand)

local eventCommand = {
	description = "Sends a global chat message to all players. Only for use in events.",
	leadAdminOnly = true,
	requiresArg = true,
	descriptors = {
		{
			descriptor = DESCRIPTOR_STRING,
			description = "Message"
		}
	},
	onRun = function(ply, arg, rawText)
		if ply:GetUserGroup() == "leadadmin" then
			return
		end
		
		for v,k in pairs(player.GetAll()) do
			k:SendChatClassMessage(14, rawText, ply)
		end
	end
}

impulse.RegisterChatCommand("/event", eventCommand)

local writeCommand = {
	description = "Writes a letter with the text specified.",
	requiresArg = true,
	requiresAlive = true,
	onRun = function(ply, args, text)
		if ply.letterCount and ply.letterCount > impulse.Config.MaxLetters then
			ply:Notify("You have reached the max amount of letters.")
			return
		end

		if string.len(text) > 900 then
			ply:Notify("Letter max character limit reached. (900)")
			return
		end

		text = impulse.SafeString(text)

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)

		local letter = ents.Create("impulse_letter")
		letter:SetPos(tr.HitPos)
		letter:SetText(text)
		letter:SetPlayerOwner(ply)
		letter:Spawn()

		undo.Create("letter")
		undo.AddEntity(letter)
		undo.SetPlayer(ply)
		undo.Finish()
	end
}

impulse.RegisterChatCommand("/write", writeCommand)

local searchCommand = {
	description = "Searches a players inventory.",
	requiresArg = false,
	requiresAlive = true,
	onRun = function(ply, args, text)
		if not ply:IsCP() then return end
		if ply.InvSearching and IsValid(ply.InvSearching) then return end

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 50
		trace.filter = ply

		local tr = util.TraceLine(trace)
		local targ = tr.Entity

		if targ and IsValid(targ) and targ:IsPlayer() and targ:OnGround() then
			if not targ.beenInvSetup then return end

			if not ply:CanArrest(targ) then
				return ply:Notify("You cannot search this player.")
			end

			if not targ:GetSyncVar(SYNC_ARRESTED, false) then
				return ply:Notify("You must detain a player before searching them.")
			end

			targ:Freeze(true)
			targ:Notify("You are currently being searched.")
			ply:Notify("You have started searching "..targ:Nick()..".")
			ply.InvSearching = targ
			hook.Run("DoInventorySearch", ply, targ)

			local inv = targ:GetInventory(1)
			net.Start("impulseInvDoSearch")
			net.WriteUInt(targ:EntIndex(), 8)
			net.WriteUInt(table.Count(inv), 16)
			for v,k in pairs(inv) do
				local netid = impulse.Inventory.ClassToNetID(k.class)
				net.WriteUInt(netid, 10)
			end
			net.Send(ply)
		else
			ply:Notify("No player in search range.")
		end
	end
}

impulse.RegisterChatCommand("/invsearch", searchCommand)

local eventCommand = {
	description = "Sends a global chat message to all players. Only for use in events.",
	leadAdminOnly = true,
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if ply:GetUserGroup() == "leadadmin" then
			return
		end
		
		for v,k in pairs(player.GetAll()) do
			k:SendChatClassMessage(14, rawText, ply)
		end
	end
}

--[[
local dispCommand = {
	description = "Send a dispatch announcement.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ( ply:IsAdmin() or ply:IsUUHigherRank() ) then
			return
		end
		
		for k, v in pairs(player.GetAll()) do
			v:SendChatClassMessage(16, rawText, ply)
		end
	end
}

impulse.RegisterChatCommand("/dispatchannounce", dispCommand)
--]]

local dispcommCommand = {
	description = "Send a dispatch radio to the UU.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		if not ( ply:IsAdmin() or ply:IsUUHigherRank() ) then
			return
		end
		
		for k, v in pairs(player.GetAll()) do
			if ( v:IsCP() or v:IsAdmin() ) then
				v:SendChatClassMessage(17, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/dispatch", dispcommCommand)

local groupChatCommand = {
	description = "Sends a message to members of your group.",
	requiresArg = true,
	onRun = function(ply, arg, rawText)
		local group = ply:GetSyncVar(SYNC_GROUP_NAME, nil)

		if not group then
			return ply:Notify("You must be in a group to use this command.")
		end

		if ply:IsCP() then
			return ply:Notify("You can not use this command as this team.")
		end

		if not ply:GroupHasPermission(2) then
			return ply:Notify("Your group rank does not have permission to do this.")
		end

		for v,k in pairs(player.GetAll()) do
			if k:GetSyncVar(SYNC_GROUP_NAME, "") == group and not k:IsCP() then
				k:SendChatClassMessage(15, rawText, ply)
			end
		end
	end
}

impulse.RegisterChatCommand("/group", groupChatCommand)
impulse.RegisterChatCommand("/g", groupChatCommand)

local function GrammarCheck(text)
	text = string.Trim(text)
	local last = text:sub(-1)

	if (last != "." and last != "?" and last != "!" and last != "-" and last != "\"") then
		text = text .. "."
	end

	return text:sub(1, 1):upper() .. text:sub(2)
end

if CLIENT then
	local talkCol = Color(255, 255, 100)
	local infoCol = Color(135, 206, 250)
	local oocCol = color_white
	local oocTagCol = Color(200, 0, 0)
	local yellCol = Color(255, 140, 0)
	local whisperCol = Color(65, 105, 225)
	local infoCol = Color(135, 206, 250)
	local talkCol = Color(255, 255, 100)
	local radioCol = Color(65, 120, 200)
	local pmCol = Color(45, 154, 6)
	local advertCol = Color(255, 174, 66)
	local acCol = Color(0, 235, 0, 255)
	local eventCol = Color(255, 69, 0)
	local fallbackRankCol = Color(211, 211, 211)
	local groupCol = Color(148, 0, 211)
	local dispatchCol = Color(127, 255, 212)
	local rankCols = impulse.Config.RankColours
	local hiddenCol = Color(140, 160, 200)

	impulse.RegisterChatClass(1, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message

		if(LocalPlayer():Team() == TEAM_CITIZEN) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, talkCol, ": ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_REBEL then
				local replaceCol = ColorAlpha(team.GetColor(LocalPlayer():Team()), alpha)
				chat.AddText(replaceCol, speaker:GetName(), talkCol, ": ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", talkCol, ": ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_CP) then
			if speaker:Team() == TEAM_CP then
				chat.AddText(speaker, talkCol, ": ", message)
			elseif GetApply(speaker) then -- applied player table
				if speaker:Team() == TEAM_CITIZEN then
					chat.AddText(speaker, talkCol, ": ", message)
				elseif speaker:Team() == TEAM_VORT then
					chat.AddText(speaker, talkCol, ": ", message)
				end
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", talkCol, ": ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_OTA) then
			if speaker:Team() == TEAM_CP or speaker:Team() == TEAM_OTA then
				chat.AddText(speaker, talkCol, ": ", message)
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", talkCol, ": ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_REBEL or LocalPlayer():Team() == TEAM_VORT) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, talkCol, ": ", message)
			elseif speaker:Team() == TEAM_REBEL then
				chat.AddText(speaker, talkCol, ": ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", talkCol, ": ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", talkCol, ": ", message)
			end
		else
			local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
			chat.AddText(someoneCol, "Someone", talkCol, ": ", message)
		end
	end)

	local strFind = string.find
	impulse.RegisterChatClass(2, function(message, speaker)
		if not impulse.GetSetting("chat_oocenabled", true) then
			return print("(OOC DISABLED) [OOC] "..speaker:SteamName()..": "..message)
		end

		impulse.customChatPlayer = speaker

		if LocalPlayer and IsValid(LocalPlayer()) then
			local tag = "@"..LocalPlayer():SteamName()
			local findStart, findEnd = strFind(string.lower(message), string.lower(tag), 1, true)

			if findStart then
				local pre = string.sub(message, 1, findStart - 1)
				local post = string.sub(message, findEnd + 1)

				if impulse.GetSetting("chat_pmpings") then
					surface.PlaySound("buttons/blip1.wav")
				end

				chat.AddText(oocTagCol, "[OOC] ", (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol), speaker:SteamName(), oocCol, ": ", pre, infoCol, tag, oocCol, post)
				return
			end
		end
		
		local col = (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol)
		
		if ( speaker:SteamID() == "STEAM_0:1:34022464" ) then
			col = Color(255,140,0)
		elseif ( speaker:SteamID() == "STEAM_0:0:526890129" ) then
			col = Color(0, 155, 0)
		end

		chat.AddText(oocTagCol, "[OOC] ", col, speaker:SteamName(), oocCol, ": ", message)
	end)
	
	impulse.RegisterChatClass(3, function(message, speaker)
		impulse.customChatPlayer = speaker
		
		local col = (rankCols[speaker:IsIncognito() and "user" or speaker:GetUserGroup()] or fallbackRankCol)
		
		if ( speaker:SteamID() == "STEAM_0:1:34022464" ) then
			col = Color(255,140,0)
		elseif ( speaker:SteamID() == "STEAM_0:0:526890129" ) then
			col = Color(0, 155, 0)
		end
		
		chat.AddText(oocTagCol, "[LOOC] ", col, speaker:SteamName(), (team.GetColor(speaker:Team())), " (", speaker:Name(), ")", oocCol, ": ",  message)
	end)

	impulse.RegisterChatClass(4, function(message, speaker)
		if impulse.GetSetting("chat_pmpings") then
			surface.PlaySound("buttons/blip1.wav")
		end
		
		chat.AddText(pmCol, "[PM] ", speaker:SteamName(), (team.GetColor(speaker:Team())), " (", speaker:Name(), ")", pmCol, ": ", message)
	end)

	impulse.RegisterChatClass(5, function(message, speaker)
		surface.PlaySound("buttons/blip1.wav")
		chat.AddText(pmCol, "[PM SENT] ", speaker:SteamName(), (team.GetColor(speaker:Team())), " (", speaker:Name(), ")", pmCol, ": ", message)
	end)

	impulse.RegisterChatClass(6, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message

		impulse.customChatFont = "Impulse-ChatLarge"
		
		if(LocalPlayer():Team() == TEAM_CITIZEN) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_REBEL then
				local replaceCol = ColorAlpha(team.GetColor(LocalPlayer():Team()), alpha)
				chat.AddText(replaceCol, speaker:GetName(), yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", yellCol, " yells: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_CP) then
			if speaker:Team() == TEAM_CP then
				chat.AddText(speaker, yellCol, " yells: ", message)
			elseif GetApply(speaker) then -- applied player table
				if speaker:Team() == TEAM_CITIZEN then
					chat.AddText(speaker, yellCol, " yells: ", message)
				elseif speaker:Team() == TEAM_VORT then
					chat.AddText(speaker, yellCol, " yells: ", message)
				end
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", yellCol, " yells: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_OTA) then
			if speaker:Team() == TEAM_CP or speaker:Team() == TEAM_OTA then
				chat.AddText(speaker, yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", yellCol, " yells: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_REBEL or LocalPlayer():Team() == TEAM_VORT) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_REBEL then
				chat.AddText(speaker, yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", yellCol, " yells: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", yellCol, " yells: ", message)
			end
		else
			local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
			chat.AddText(someoneCol, "Someone", yellCol, " yells: ", message)
		end
	end)

	impulse.RegisterChatClass(7, function(message, speaker)
		message = hook.Run("ProcessICChatMessage", speaker, message) or message
		
		impulse.customChatFont = "Impulse-ChatSmall"
		
		if(LocalPlayer():Team() == TEAM_CITIZEN) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_REBEL then
				local replaceCol = ColorAlpha(team.GetColor(LocalPlayer():Team()), alpha)
				chat.AddText(replaceCol, speaker:GetName(), whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", whisperCol, " whispers: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_CP) then
			if speaker:Team() == TEAM_CP then
				chat.AddText(speaker, whisperCol, " whispers: ", message)
			elseif GetApply(speaker) then -- applied player table
				if speaker:Team() == TEAM_CITIZEN then
					chat.AddText(speaker, whisperCol, " whispers: ", message)
				elseif speaker:Team() == TEAM_VORT then
					chat.AddText(speaker, whisperCol, " whispers: ", message)
				end
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", whisperCol, " whispers: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_OTA) then
			if speaker:Team() == TEAM_CP or speaker:Team() == TEAM_OTA then
				chat.AddText(speaker, whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_CITIZEN or speaker:Team() == TEAM_REBEL then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
				chat.AddText(someoneCol, "Someone", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", whisperCol, " whispers: ", message)
			end
		elseif(LocalPlayer():Team() == TEAM_REBEL or LocalPlayer():Team() == TEAM_VORT) then
			if speaker:Team() == TEAM_CITIZEN then
				chat.AddText(speaker, whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_REBEL then
				chat.AddText(speaker, whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_VORT then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_VORT), alpha)
				chat.AddText(someoneCol, "Vortigaunt", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_CP then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_CP), alpha)
				chat.AddText(someoneCol, "Civil Protection", whisperCol, " whispers: ", message)
			elseif speaker:Team() == TEAM_OTA then
				local someoneCol = ColorAlpha(team.GetColor(TEAM_OTA), alpha)
				chat.AddText(someoneCol, "Combine Soldier", whisperCol, " whispers: ", message)
			end
		else
			local someoneCol = ColorAlpha(team.GetColor(TEAM_CITIZEN), alpha)
			chat.AddText(someoneCol, "Someone", whisperCol, " whispers: ", message)
		end
	end)

	impulse.RegisterChatClass(8, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		chat.AddText(radioCol, "[RADIO] ", speaker:Name(), ": ", "<:: "..message.." ::>")
	end)

	impulse.RegisterChatClass(9, function(message, speaker)
		chat.AddText(talkCol, speaker:KnownName(), " ", message)
	end)

	impulse.RegisterChatClass(10, function(message, speaker)
		chat.AddText(infoCol, "** ", message)
	end)

	impulse.RegisterChatClass(11, function(message, speaker)
		chat.AddText(speaker, yellCol, " rolled ", message)
	end)

	impulse.RegisterChatClass(12, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		chat.AddText(advertCol, "[ADVERT] ", speaker:Name(), ": ", message)
	end)

	impulse.RegisterChatClass(13, function(message, speaker)
		chat.AddText(acCol, "[Admin Chat] ", speaker:SteamName(), ": ", acCol, message)
	end)

	impulse.RegisterChatClass(14, function(message, speaker)
		chat.AddText(eventCol, "[EVENT] ", message)
	end)

	impulse.RegisterChatClass(15, function(message, speaker)
		local groupName = LocalPlayer():GetSyncVar(SYNC_GROUP_NAME, nil)
		local groupRank = speaker:GetSyncVar(SYNC_GROUP_RANK, nil)

		if not groupName or not groupRank then
			return
		end

		local myGroup = impulse.Group.Groups[1]

		if not myGroup then
			return
		end
		
		if myGroup.Color then
			chat.AddText(myGroup.Color, "["..groupName.."] ("..groupRank..") ", speaker:Nick(), ": ", message)
		else
			chat.AddText(groupCol, "["..groupName.."] ("..groupRank..") ", speaker:Nick(), ": ", message)
		end
	end)
	
	impulse.RegisterChatClass(16, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		
		chat.AddText(dispatchCol, "[DISPATCH ANNOUNCEMENT]: ", "<:: "..message.." ::>")
	end)
	
	impulse.RegisterChatClass(17, function(message, speaker)
		impulse.customChatFont = "Impulse-ChatRadio" 
		
		chat.AddText(dispatchCol, "[DISPATCH]: ", "<:: "..message.." ::>")
		if (speaker:Team() == TEAM_CP or speaker:Team() == TEAM_OTA) then
        	surface.PlaySound("npc/overwatch/radiovoice/on3.wav")
        end
	end)
	
	impulse.RegisterChatClass(18, function(message, speaker)
		chat.AddText(eventCol, "( SERVER ) ", message)
	end)
end