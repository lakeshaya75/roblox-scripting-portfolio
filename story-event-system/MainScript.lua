-- never finished the challenges since the story game trend died out

-- Variables --

local RemotesFolder = game.ReplicatedStorage.RemoteEvents

local DialogueEvent = RemotesFolder.DialogueEvent
local VisibleEvent = RemotesFolder.VisibleEvent
local PlayCutsceneEvent = RemotesFolder.PlayCutsceneEvent
local TransitionEvent = RemotesFolder.TransitionEvent
local TimerEvent = RemotesFolder.TimerEvent
local MathProblemEvent = RemotesFolder.MathProblemEvent
local StatusEvent = RemotesFolder.StatusEvent
local CameraShakeEvent = RemotesFolder.CameraShakeEvent
local DisableScriptEvent = RemotesFolder.DisableScriptEvent

local thumbnailType = Enum.ThumbnailType.HeadShot
local thumbnailSize = Enum.ThumbnailSize.Size420x420

-- Challenge Variables --

-- Functions --

function ChooseRandomPlayer()
	return game.Players:GetChildren()[math.random(1, #game.Players:GetChildren())]
end

function getPlayerId()
	local player = ChooseRandomPlayer()
	return game.Players:GetUserThumbnailAsync(player.UserId, thumbnailType, thumbnailSize) -- returns all the information for the dialogue
end

function teleportPlayers(teleportPart)
	local players = game.Players:GetPlayers()
	
	for i, player in pairs(players) do
		if player.Character then
			if player.Character.HumanoidRootPart.Anchored == false then
				player.Character.Humanoid.Jump = true -- if the humanoid root part is unanchored then the player will jump
			end
		end
	end
	
	wait(0.5)
	for v, player in pairs(players) do
		if player.Character then
			if player.Character.HumanoidRootPart.Anchored == false then
				player.Character:SetPrimaryPartCFrame(teleportPart) -- once the player jump we set the player to a different position
			end
		end
	end
	
	game.ReplicatedStorage.SpawnLocation.Position = teleportPart.Position
	
end

function moveCharacter(character, endpoint)
	character.Humanoid:MoveTo(endpoint.Position)
	
	character.Humanoid.MoveToFinished:Wait()
end

function changeDoorStatus(door, status)
	for i, v in pairs(door:GetChildren()) do
		
		v.CanCollide = status
		
	end
end

function playSound(soundId, volume, looped)
	
	local newSound = Instance.new("Sound", game.ReplicatedStorage)
	
	newSound.SoundId = soundId
	
	newSound.Volume = volume
	
	newSound:Play()
	
	newSound.Looped = looped
	
end

-- Create Functions --

function CreateDialogue(player, text, id, backgroundColor, borderColor)
	DialogueEvent:FireAllClients(player, text, id, backgroundColor, borderColor)
end

function CreateTransition()
	TransitionEvent:FireAllClients()	
end

function CreateCutscene(endCamera, duration, waitTime)
	PlayCutsceneEvent:FireAllClients(endCamera, duration, waitTime)
end

function CreateTimer(timer)
	TimerEvent:FireAllClients(timer)
end

function CreateStatusNotification(title, objective, length)
	StatusEvent:FireAllClients(title, objective, length)
end

function CreatePlayerItem(item)
	for i, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			local newItem = item:Clone()
			
			newItem.Parent = player.Backpack
		end
	end
end

function CreateCameraShake()
	CameraShakeEvent:FireAllClients()	
end

-- Challenge Functions --

function GiveMathProblem()
	MathProblemEvent:FireAllClients()
end

function changeLights(color, partColor, brightness)
	
	for i, light in pairs (game.Workspace.Setting.Main.Preschool.Lights:GetChildren()) do
		if light.LightPart:FindFirstChild("PointLight") then
			
			local pointLight = light.LightPart.PointLight
			
			light.LightPart.BrickColor = partColor
			
			pointLight.Brightness = brightness
			
			pointLight.Color = color
			
		end
	end
	
end



-- Storyline --

function challengeIntro()
	
	-- Background Colors --

	local sophiaMainColor = Color3.fromRGB(0, 230, 100)
	local sophiaBorderColor = Color3.fromRGB(20, 250, 120)

	local playerMainColor = Color3.fromRGB(40, 150, 200)
	local playerBorderColor = Color3.fromRGB(60, 170, 220)
	
	-- Other Variables --
	
	local CutscenesFolder = game.Workspace.Cutscenes
	local SettingFolder = game.Workspace.Setting
	local TeleportsFolder = game.Workspace.Teleports
	local CharactersFolder = game.Workspace.Characters
	local CharacterPointsFolder = game.Workspace.CharacterPoints
	
	local player = ChooseRandomPlayer()
	local playerId = getPlayerId()
	
	local sophiaImage = "rbxassetid://8624445637"
	local sikoImage = "rbxassetid://7261922746"
	
	wait(1)
	
	game.Lighting.FogEnd = 100
	
	wait(5)
	
	CreateCutscene(CutscenesFolder.IntroCutscene.IntroCutscenePartA, 5, 20)
	
	VisibleEvent:FireAllClients(true)

	CreateDialogue("Sophia", "Hello, and welcome to the preschool!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Come on, let's go inside! It's chilly out here!", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	VisibleEvent:FireAllClients(false)
	
	wait(8)
	
	CreateTransition()
	
	wait(2)
	
	teleportPlayers(TeleportsFolder.EntranceTeleport.CFrame)
	
	CharactersFolder.Sophia:SetPrimaryPartCFrame(CharacterPointsFolder.SophiaStartingPoint.CFrame)
	
	game.Workspace.SpawnLocation:Destroy()
	
	wait(3)
	
	game.Workspace.Setting.Main.Preschool.Basement.Available.Value = true
	
	VisibleEvent:FireAllClients(true)
	
	CreateDialogue("Sophia", "Welcome to the preschool! Go ahead and explore!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(10)
	
	VisibleEvent:FireAllClients(false)
	
	CreateStatusNotification("Objective", "Explore the preschool with your friends!", 40)
	
	wait(40)
	
	game.Workspace.Setting.Main.Preschool.Basement.Available.Value = false
	
	CreateTransition()
	
	
end

function challenge1()
	
	-- Background Colors --

	local sophiaMainColor = Color3.fromRGB(0, 230, 100)
	local sophiaBorderColor = Color3.fromRGB(20, 250, 120)

	local playerMainColor = Color3.fromRGB(40, 150, 200)
	local playerBorderColor = Color3.fromRGB(60, 170, 220)

	-- Other Variables --

	local CutscenesFolder = game.Workspace.Cutscenes
	local SettingFolder = game.Workspace.Setting
	local TeleportsFolder = game.Workspace.Teleports
	local CharactersFolder = game.Workspace.Characters
	local CharacterPointsFolder = game.Workspace.CharacterPoints

	local player = ChooseRandomPlayer()
	local playerId = getPlayerId()
	
	local sophiaImage = "rbxassetid://8624445637"
	local sikoImage = "rbxassetid://7261922746"
	
	wait(5)

	VisibleEvent:FireAllClients(true)

	CreateDialogue("Sophia", "Okay, everyone! Come inside the classroom! Let's learn some math!", sophiaImage, sophiaMainColor, sophiaBorderColor)

	wait(2)

	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaClassroomPoint1)

	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaClassroomPoint2)

	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaClassroomPoint3)
	
	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaClassroomPoint4)

	wait(8)

	CreateDialogue("Sophia", "Please take a seat everyone!", sophiaImage, sophiaMainColor, sophiaBorderColor)

	wait(3)
	
	CreateStatusNotification("Objective", "Take a seat in the classroom!", 15)

	CreateTimer(15)
	
	wait(20)
		
	CreateDialogue(player, "What are we learning today? Are we gonna do something fun?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Yes, today I will be teaching you some math! That's fun, right?", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Uhhhh .. sure, that's fun, I guess.", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Great, today, we're gonna be doing some multiplication!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "I'll ask a math question. Whoever gets that question right will get a treat!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Are you ready? Begin!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(5)
	
	CreateTimer(15)
	
	GiveMathProblem()
	
	wait(15)
	
	CreateDialogue("Sophia", "Time's up!! If you got it right, you earned yourself a cookie!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Now, on with the lesson ...", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(5)
	
	VisibleEvent:FireAllClients(false)
	
	wait(5)
	
	CreateTransition()
	
	wait(5)
	
	VisibleEvent:FireAllClients(true)
	
	CreateDialogue(player, "Math is so boring ... can we go and play?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Hey, wait! You're forgetting something!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "What?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)

	CreateDialogue("Sophia", "Lunch!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(3)
	
	CreateTransition()
	
	wait(3)
	
	CharactersFolder.Sophia:SetPrimaryPartCFrame(CharacterPointsFolder.SophiaLunchroomPoint.CFrame)
	
	wait(2)
	
	CreateDialogue("Sophia", "Come to the cafeteria, children! Take a seat!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(10)
	
	CreateDialogue(player, "What's for lunch?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Today, we are having .. pizza!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Woohoo! I love pizza! :D", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	VisibleEvent:FireAllClients(false)
	
	CreatePlayerItem(game.ReplicatedStorage.Pizza)
	
	wait(3)
	
	CreateTimer(10)
	
	CreateStatusNotification("Objective", "Finish your pizza!", 10)
	
	wait(10)
	
	CreateTransition()
	
	wait(5)
	
	VisibleEvent:FireAllClients(true)
	
	CreateDialogue(player, "I have finished eating my pizza!", playerId, playerMainColor, playerBorderColor)
	
	wait(5)
	
	CreateDialogue(player, "Me too! Now can we go and play?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)

	CreateDialogue("Sophia", "Okay, go ahead! Feel free to go outside and play!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(5)
	
	VisibleEvent:FireAllClients(false)
	
	changeDoorStatus(game.Workspace.Setting.Main.Preschool.FirstFloor.Backyard.BackyardDoor, false)	
	
	CreateStatusNotification("Have fun!", "Go outside and play with your friends!", 30)
	
	wait(30)
	
	CreateTransition()
	
	wait(3)
	
	CharactersFolder.Sophia:SetPrimaryPartCFrame(CharacterPointsFolder.SophiaStartingPoint.CFrame)
	
	teleportPlayers(TeleportsFolder.AfterPlayTeleport.CFrame)
	
	game.Lighting.ClockTime = 18
	
	changeDoorStatus(game.Workspace.Setting.Main.Preschool.FirstFloor.Backyard.BackyardDoor, false)	
	
	wait(5)
	
	VisibleEvent:FireAllClients(true)
	
	CreateDialogue("Sophia", "Okay kids, playtime is over! It's time to go to bed!", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "NO!! We wanna stay up and play!", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "I can't let you guys stay out alone!", sophiaImage, sophiaMainColor, sophiaBorderColor)

	wait(8)
	
	CreateDialogue(player, "What do you mean alone? Aren't you gonna stay here?", playerId, playerMainColor, playerBorderColor)

	wait(8)
	
	CreateDialogue("Sophia", "Oh .. about that, well uh- I have to run some errands...", sophiaImage, sophiaMainColor, sophiaBorderColor)

	wait(8)
	
	CreateDialogue(player, "Oh, okay... where will you be?", playerId, playerMainColor, playerBorderColor)

	wait(8)
	
	CreateDialogue("Sophia", "That's not important! Anyways, it's time to get to bed for a nap!", sophiaImage, sophiaMainColor, sophiaBorderColor)

	wait(8)
	
	CreateTimer(20)
	
	CreateStatusNotification("Objective", "Get into bed to go to sleep.", 20)
	
	VisibleEvent:FireAllClients(false)
	
	wait(20)
	
	CreateTransition()	
	
end

function challenge2()
	
	-- Background Colors --

	local sophiaMainColor = Color3.fromRGB(0, 230, 100)
	local sophiaBorderColor = Color3.fromRGB(20, 250, 120)

	local playerMainColor = Color3.fromRGB(40, 150, 200)
	local playerBorderColor = Color3.fromRGB(60, 170, 220)
	
	local sikoMainColor = Color3.fromRGB(0, 0, 0)
	local sikoBorderColor = Color3.fromRGB(255, 0, 0)

	-- Other Variables --

	local CutscenesFolder = game.Workspace.Cutscenes
	local SettingFolder = game.Workspace.Setting
	local TeleportsFolder = game.Workspace.Teleports
	local CharactersFolder = game.Workspace.Characters
	local CharacterPointsFolder = game.Workspace.CharacterPoints

	local player = ChooseRandomPlayer()
	local playerId = getPlayerId()
	
	local sophiaImage = "rbxassetid://8624445637"
	local sikoImage = "rbxassetid://7261922746"
	
	
	wait(3)

	game.Lighting.ClockTime = 1

	teleportPlayers(TeleportsFolder.MidnightSleepTeleport.CFrame)
	
	changeDoorStatus(game.Workspace.Setting.Main.Preschool.SecondFloor.Bedroom.BlueRoom.BlueRoomDoor, true)
	
	changeDoorStatus(game.Workspace.Setting.Main.Preschool.SecondFloor.Bedroom.PinkRoom.PinkRoomDoor, true)
	
	CharactersFolder.Sophia:SetPrimaryPartCFrame(game.Workspace.CharacterPoints.InvisiblePoint)
	
	game.Workspace.Setting.Main.Preschool.SecondFloor.PlayArea.IndoorWindow.Barrier.CanCollide = true

	wait(5)

	VisibleEvent:FireAllClients(true)

	CreateDialogue(player, "Hey, you guys still awake?", playerId, playerMainColor, playerBorderColor)
	
	wait(5)
	
	CreateDialogue(player, "Yeah, I can't sleep! Something feels off about this place...", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	VisibleEvent:FireAllClients(false)
	
	wait(5)
	
	playSound("rbxassetid://3774598649", 10, false)
	
	wait(8)
	
	VisibleEvent:FireAllClients(true)

	CreateDialogue(player, "Wh- what was th- that?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Be quiet noob, it's probably Sophia.", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Don't call me a noob!", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "Okay, guys, let's go downstairs and check it out...", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	VisibleEvent:FireAllClients(false)
	
	changeDoorStatus(game.Workspace.Setting.Main.Preschool.SecondFloor.Bedroom.BlueRoom.BlueRoomDoor, false)

	changeDoorStatus(game.Workspace.Setting.Main.Preschool.SecondFloor.Bedroom.PinkRoom.PinkRoomDoor, false)
	
	CreateStatusNotification("Objective", "Go downstairs and see who it is at the door!", 15)
	
	game.Workspace.Setting.Main.Preschool.SecondFloor.PlayArea.IndoorWindow.Barrier:Destroy()
	
	wait(15)
	
	CreateCutscene(CutscenesFolder.DoorEntranceCutscene.DoorEntranceCutscenePartA, 3, 15)
	
	wait(5)
	
	game.ReplicatedStorage.Sophia.Parent = CharactersFolder
	
	CharactersFolder.Sophia:SetPrimaryPartCFrame(CharacterPointsFolder.SophiaEntrancePoint.CFrame)
	
	wait(8)
	
	VisibleEvent:FireAllClients(true)
	
	CreateDialogue("Sophia", "Children, what is this? Why are you all not sleeping?", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateDialogue(player, "We couldn't sleep, and you rang the doorbell so we came-", playerId, playerMainColor, playerBorderColor)
	
	wait(3)
	
	game.Lighting.Ambient = Color3.new(0, 0, 0)
	
	changeLights(Color3.new(0.105882, 0.164706, 0.207843), BrickColor.new("Black"), .5)	

	CreateCameraShake()
	
	wait(5)
	
	CreateDialogue("Sophia", "What is this? ... it seems the power went off.", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)

	CreateDialogue(player, "This is uh ... this isn't very good.", playerId, playerMainColor, playerBorderColor)
	
	wait(8)

	CreateDialogue("Sophia", "Okay, children no need to fear. I will go -", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(3)
	
	changeLights(Color3.new(255, 0, 0), BrickColor.new("Really red"), 1)
	
	wait(5)
	
	game.Workspace.Characters.Siko:SetPrimaryPartCFrame(game.Workspace.CharacterPoints.SikoAppearPoint1)
	
	wait(3)
	
	CreateCutscene(CutscenesFolder.SikoIntroCutscene.SikoIntroCutscenePartA, 5, 30)
	
	CreateDialogue(player, "Uhhhhhh ... Sophia, who is that outside the cafeteria window?", playerId, playerMainColor, playerBorderColor)
	
	wait(8)
	
	CreateDialogue("Sophia", "Who is it?", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaInvestigationPoint1)
	
	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaInvestigationPoint2)
	
	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaInvestigationPoint3)
	
	moveCharacter(CharactersFolder.Sophia, CharacterPointsFolder.SophiaInvestigationPoint4)
	
	wait(8)
	
	CreateDialogue("Sophia", "Is this some sort of joke, children?", sophiaImage, sophiaMainColor, sophiaBorderColor)
	
	wait(8)
	
	CreateCameraShake()
	
	CreateDialogue("???", "THIS IS NO JOKE. YOU WILL ALL DIE.", sikoImage, sikoMainColor, sikoBorderColor)
	
	wait(5)
	
	moveCharacter(CharactersFolder.Siko, CharacterPointsFolder.SikoDisappearPoint1)
	
	
	
	
	
	
	
	
	
	
	
end

function challenge3()

end

function challenge4()

end

function challenge5()

end

function challengeEnd()

end

function runGame()
	challengeIntro()
	challenge1()
	challenge2()
	challenge3()
	challenge4()
	challenge5()
	challengeEnd()
end

wait(5)

runGame()
