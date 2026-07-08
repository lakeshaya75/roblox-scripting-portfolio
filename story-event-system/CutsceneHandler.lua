
-- Variables --

local TweenService = game:GetService("TweenService")
local camera = game.Workspace.CurrentCamera

local PlayCutsceneEvent = game.ReplicatedStorage.RemoteEvents.PlayCutsceneEvent

-- Functions --

local TweenService = game:GetService("TweenService")

local camera = game.Workspace.CurrentCamera

PlayCutsceneEvent.OnClientEvent:Connect(function(endCamera, duration, waitTime)
	
	if script.Disabled == false then
	
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = game.Workspace.CurrentCamera.CFrame
		
		local TweenInformation = TweenInfo.new(
			duration,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out,
			0,
			false,
			0
		)
		
		local tween = TweenService:Create(camera, TweenInformation, {CFrame = endCamera.CFrame})	
		tween:Play()
		
		wait(waitTime)
		
		camera.CameraType = Enum.CameraType.Custom
		
	end
	
end)




