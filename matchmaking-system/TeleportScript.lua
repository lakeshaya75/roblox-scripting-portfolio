-- incoming teleport script in the other place (there are two places both with essentially the same scripts, one for PVP and the other for PVB)

-- ServerScriptService / MatchServer_Bot.server.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local matchEvent   = Remotes:WaitForChild("Match")
local clientReady  = Remotes:WaitForChild("ClientReady")
local playerInfo   = Remotes:WaitForChild("PlayerInfo")
local scoreUpd     = Remotes:WaitForChild("ScoreUpd")
local tp           = Remotes:WaitForChild("TP")

-- Defaults for bot matches
local DEFAULTS = {
	mode   = "Classic",
	banner = "Basic",
	avatar = "Default",
	emotes = {1, 5, 6},
}

-- State (keyed by userId)
local pendingData     = {}   -- [uid] = sanitized payload for that player
local clientIsReady   = {}   -- [uid] = true after "ui_visible"
local matchStartedFor = {}   -- [uid] = true once Match fired
local playersByUserId = {}   -- [uid] = Player

-- ---------- utils ----------

local function prettyPrint(prefix, tbl)
	local ok, encoded = pcall(function() return HttpService:JSONEncode(tbl) end)
	print(prefix, ok and encoded or "[unprintable table]")
end

local function sanitize(d)
	return {
		mode   = (d and d.mode)   or DEFAULTS.mode,
		banner = (d and d.banner) or DEFAULTS.banner,
		avatar = (d and d.avatar) or DEFAULTS.avatar,
		emotes = (d and d.emotes) or DEFAULTS.emotes,
	}
end

-- Accepts either shared map (tDataAll) or legacy single-table payload
local function extractMyData(userId, td)
	if typeof(td) ~= "table" then return nil end
	if td.dataByUserId and typeof(td.dataByUserId) == "table" then
		return td.dataByUserId[userId]
	end
	return td
end

-- Fire Match once this player is fully ready
local function tryStart(uid)
	if matchStartedFor[uid] then return end
	if not clientIsReady[uid] then return end
	if not pendingData[uid] then return end

	local plr = playersByUserId[uid]
	if not plr then return end

	matchStartedFor[uid] = true
	matchEvent:FireClient(plr, pendingData[uid])
	pendingData[uid] = nil
	print("[BOT MATCH] Started for", plr.Name)
end

-- ---------- lifecycle ----------

Players.PlayerAdded:Connect(function(player)
	local uid = player.UserId
	playersByUserId[uid] = player

	local ok, joinData = pcall(function() return player:GetJoinData() end)
	local td = ok and joinData and joinData.TeleportData or nil
	local mine = extractMyData(uid, td)

	if mine then
		pendingData[uid] = sanitize(mine)
		prettyPrint(("[TeleportData] %s"):format(player.Name), mine)
	else
		pendingData[uid] = sanitize(nil)
		warn("[TeleportData] Missing for", player.Name, "→ using defaults")
	end

	tryStart(uid)
end)

clientReady.OnServerEvent:Connect(function(player, payload)
	if typeof(payload) == "table" and payload.phase == "ui_visible" then
		local uid = player.UserId
		clientIsReady[uid] = true
		print(("[READY] %s UI visible"):format(player.Name))
		tryStart(uid)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local uid = player.UserId
	pendingData[uid]     = nil
	clientIsReady[uid]   = nil
	matchStartedFor[uid] = nil
	playersByUserId[uid] = nil
end)

-- ---------- passthrough events (still useful if you show bot info/score) ----------

playerInfo.OnServerEvent:Connect(function(player, data)
	playerInfo:FireAllClients(player, data)
end)

scoreUpd.OnServerEvent:Connect(function(player, score)
	scoreUpd:FireAllClients(player, score)
end)

-- ---------- teleport back to lobby after match (per-player) ----------

tp.OnServerEvent:Connect(function(plr, payload)
	payload = typeof(payload) == "table" and payload or {}
	local tpData = {
		result  = typeof(payload.result) == "string" and payload.result or "ok",
		credits = payload.credits,
		xp      = payload.xp,
	}

	local LOBBY_PLACE_ID = 79348082970925 -- update this to your lobby place id
	local options = Instance.new("TeleportOptions")
	options:SetTeleportData(tpData)

	print(("[BOT MATCH] Teleporting %s → %d with %s")
		:format(plr.Name, LOBBY_PLACE_ID, HttpService:JSONEncode(tpData)))

	local ok, err = pcall(function()
		TeleportService:TeleportAsync(LOBBY_PLACE_ID, { plr }, options)
	end)
	print("[BOT MATCH] TeleportAsync ok=", ok, "err=", err)
end)
