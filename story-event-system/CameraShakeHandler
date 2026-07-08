local CameraShakeEvent = game.ReplicatedStorage.RemoteEvents.CameraShakeEvent

local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local debounce = false

CameraShakeEvent.OnClientEvent:Connect(function()
	
	if script.Disabled == false then
	
		if not debounce then
			
			debounce = true
			
			for i = 1, 20 do
				
				local a = math.random(-20, 20)/100
				local b = math.random(-20, 20)/100
				local c = math.random(-20, 20)/100
				
				humanoid.CameraOffset = Vector3.new(a, b, c)
				wait()
				
			end
			
			wait(4)
			debounce = false
			
		end
		
	end
	
end)
