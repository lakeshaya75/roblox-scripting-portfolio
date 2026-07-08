local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local tool = script.Parent
local toolEvent = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Tool")
local animation = tool:WaitForChild("Animation")
local sound = tool:WaitForChild("Sound")

local animTrack
local animPlaying = false
local soundDelay = 0.4

local isHolding = false
local holdDB = false
local holdDelay = 1

local hitboxSize = Vector3.new(5, 5, 5)

tool.Equipped:Connect(function()
	-- load everything if you equip the tool
	local character = tool.Parent
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	if not animTrack then
		animTrack = animator:LoadAnimation(animation)
		animTrack.Priority = Enum.AnimationPriority.Action
	end
end)

tool.Unequipped:Connect(function()
	animPlaying = false
	isHolding = false
	holdDB = false
end)

tool.Activated:Connect(function()
	if isHolding then return end
	isHolding = true
	
	while isHolding do
		if not holdDB then
			holdDB = true

			local character = tool.Parent
			if not character then return end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local root = character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end

			if not animTrack then
				local animator = humanoid:FindFirstChildOfClass("Animator")
				if not animator then
					animator = Instance.new("Animator")
					animator.Parent = humanoid
				end

				animTrack = animator:LoadAnimation(animation)
				animTrack.Priority = Enum.AnimationPriority.Action
			end

			animPlaying = true
			animTrack:Play()

			if sound then
				task.delay(soundDelay, function()
					sound:Play()
				end)
			end

			task.delay(0.2, function()
				if not tool.Parent or tool.Parent ~= character then return end

				local parts = Workspace:GetPartBoundsInBox(root.CFrame, hitboxSize) -- see if anything is nearby the player
				local harvestableFound = nil

				for _, part in ipairs(parts) do
					if part.Name == "Hitbox" then
						local model = part:FindFirstAncestorOfClass("Model")
						if model and model.Parent == Workspace:FindFirstChild("Harvestables") then -- if theres a harvestable in the vicinity
							harvestableFound = model
							break
						end
					end
				end

				if harvestableFound then
					toolEvent:FireServer(harvestableFound, tool, soundDelay)
				end
				
			end)

			task.delay(animTrack.Length, function()
				animPlaying = false
			end)
			

			task.delay(holdDelay, function()
				holdDB = false
			end)
		end
		task.wait() -- prevents freezing
	end
	
end)

tool.Deactivated:Connect(function()
	isHolding = false
end)
