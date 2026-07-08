local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local harvestables = Workspace:WaitForChild("Harvestables")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local toolEvent = remotes:WaitForChild("Tool")
local harvestEvent = remotes:WaitForChild("Harvest")

local cooldowns = {}
local cooldownTime = 1

local shakingTrees = {}

local function playHitSound(harvestable)
	local sound = harvestable:FindFirstChild("Sound", true)
	if sound and sound:IsA("Sound") then
		sound:Play()
	end
end

local function shakeTree(harvestable)
	if shakingTrees[harvestable] then return end
	shakingTrees[harvestable] = true

	local originalPivot = harvestable:GetPivot()
	local cf, size = harvestable:GetBoundingBox()
	local basePosition = cf.Position - Vector3.new(0, size.Y / 2, 0)

	local angle = math.rad(1)

	local function pivotAroundBase(rotation)
		local toPivot = originalPivot.Position - basePosition
		local rotatedOffset = rotation:VectorToWorldSpace(toPivot)
		local newPosition = basePosition + rotatedOffset

		local originalRotationOnly = originalPivot - originalPivot.Position
		local newPivot = CFrame.new(newPosition) * rotation * originalRotationOnly

		harvestable:PivotTo(newPivot)
	end

	task.spawn(function()
		local steps = {
			CFrame.Angles(0, 0, angle),
			CFrame.Angles(0, 0, -angle),
			CFrame.Angles(0, 0, angle * 0.5),
			CFrame.Angles(0, 0, -angle * 0.5),
			CFrame.new()
		}

		for _, rotation in ipairs(steps) do
			if not harvestable or not harvestable.Parent then break end
			pivotAroundBase(rotation)
			task.wait(0.06)
		end

		if harvestable and harvestable.Parent then
			harvestable:PivotTo(originalPivot)
		end

		shakingTrees[harvestable] = nil
	end)
end

toolEvent.OnServerEvent:Connect(function(player, harvestable, tool, soundDelay)
	local now = tick()

	if cooldowns[player] and now - cooldowns[player] < cooldownTime then
		return
	end

	local character = player.Character
	if not character then return end

	if not tool then return end

	if not harvestable then return end
	if not harvestable:IsDescendantOf(harvestables) then return end

	local damage = tool:GetAttribute("Damage")
	local health = harvestable:GetAttribute("Health")

	if typeof(damage) ~= "number" or typeof(health) ~= "number" then
		return
	end

	cooldowns[player] = now

	playHitSound(harvestable)
	task.delay(soundDelay, function()
		shakeTree(harvestable)
	end)

	local newHealth = health - damage
	harvestable:SetAttribute("Health", newHealth)

	print(harvestable.Name)
	print(tool.Name)
	print(newHealth)

	if newHealth <= 0 then
		task.delay(0.18, function()
			if harvestable and harvestable.Parent then
				harvestEvent:FireClient(player, harvestable.Name, harvestable.Harvest.Value)
				if _G.HarvestResource then 
					_G.HarvestResource(harvestable)
				else
					warn("HarvestResource not found")
				end
			end
		end)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	cooldowns[player] = nil
end)
