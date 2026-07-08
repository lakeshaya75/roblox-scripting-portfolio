local serverStorage = game:GetService("ServerStorage")
local players = game:GetService("Players")

local harvestables = serverStorage:WaitForChild("Harvestables")
local regionParts = workspace:WaitForChild("Regions")

local spawnedHarvestables = workspace:WaitForChild("Harvestables")

local rng = Random.new()

local SPAWN_HEIGHT = 400
local GLOBAL_MIN_SPACING = 10
local PLAYER_CLEAR_RADIUS = 120
local RESPAWN_CHECK_INTERVAL = 5
local MAX_SLOT_ATTEMPTS = 5000


local resourceRules = {
	OakTree = {
		minSameTypeSpacing = 30,
		groundOffset = 11,
	},

	BirchTree = {
		minSameTypeSpacing = 30,
		groundOffset = 11,
	},

	PineTree = {
		minSameTypeSpacing = 25,
		groundOffset = 11,
	},

	AcaciaTree = {
		minSameTypeSpacing = 45,
		groundOffset = 8,
	},

	MangroveTree = {
		minSameTypeSpacing = 25,
		groundOffset = 14,
	},

	PalmTree = {
		minSameTypeSpacing = 40,
		groundOffset = 8,
	},

	StrawberryBush = {
		minSameTypeSpacing = 20,
		groundOffset = 3,
	},

	BlueberryBush = {
		minSameTypeSpacing = 20,
		groundOffset = 3,
	},

	GooseberryBush = {
		minSameTypeSpacing = 20,
		groundOffset = 3,
	},

	Fern = {
		minSameTypeSpacing = 15,
		groundOffset = 1,
	},

	Aloe = {
		minSameTypeSpacing = 20,
		groundOffset = 1,
	},

	Stone = {
		minSameTypeSpacing = 20,
		groundOffset = 2,
	},
	
	Flint = {
		minSameTypeSpacing = 30,
		groundOffset = 2,
	},

	Coal = {
		minSameTypeSpacing = 45,
		groundOffset = 3,
	},

	Iron = {
		minSameTypeSpacing = 60,
		groundOffset = 3,
	},
}

local regionConfigs = {
	Forest = {
		slotSpacing = 20,
		
		allowedMaterials = {
			[Enum.Material.Grass] = true,
		},
		
		resources = {
			OakTree = 0.25,
			BirchTree = 0.10,
			StrawberryBush = 0.05,
			BlueberryBush = 0.05,
			GooseberryBush = 0.05,
			Fern = 0.15,
			Stone = 0.25,
			Flint = 0.10
		},
	},
	
	Beach = {
		slotSpacing = 30,
		
		allowedMaterials = {
			[Enum.Material.Sand] = true,
		},

		resources = {
			PalmTree = 0.25,
			Iron = 0.05,
			Fern = 0.15,
			Stone = 0.25,
			Flint = 0.30
		},
	},
	
	Beach2 = {
		slotSpacing = 50,

		allowedMaterials = {
			[Enum.Material.Sand] = true,
		},

		resources = {
			PalmTree = 0.25,
			Iron = 0.05,
			Fern = 0.15,
			Stone = 0.25,
			Flint = 0.30
		},
	},
	
	Mountains = {
		slotSpacing = 15,
		
		allowedMaterials = {
			[Enum.Material.Grass] = true,
		},

		resources = {
			PineTree = 0.35,
			Stone = 0.15,
			Coal = 0.10,
			Iron = 0.05,
			Flint = 0.05,
			StrawberryBush = 0.10,
			GooseberryBush = 0.10,
			BlueberryBush = 0.10
		},
	},
	
	Meadow = {
		slotSpacing = 35,
		
		allowedMaterials = {
			[Enum.Material.Grass] = true,
		},

		resources = {
			OakTree = 0.05,
			PineTree = 0.05,
			Stone = 0.20,
			Iron = 0.10,
			StrawberryBush = 0.20,
			GooseberryBush = 0.20,
			BlueberryBush = 0.20
		},
	},
	
	Savannah = {
		slotSpacing = 25,
		
		allowedMaterials = {
			[Enum.Material.Grass] = true,
		},

		resources = {
			AcaciaTree = 0.30,
			Flint = 0.20,
			Iron = 0.10,
			StrawberryBush = 0.10,
			GooseberryBush = 0.10,
			BlueberryBush = 0.20
		},
	},
	
	Swamp = {
		slotSpacing = 15,
		
		allowedMaterials = {
			[Enum.Material.Grass] = true,
		},

		resources = {
			MangroveTree = 0.40,
			Fern = 0.20,
			Aloe = 0.30,
			GooseberryBush = 0.10,
		},
	},
}

local regions = {}
local allOccupiedSlots = {}


local function getRandomPointInRegion(regionPart)
	local size = regionPart.Size
	local cf = regionPart.CFrame
	
	local x = rng:NextNumber(-size.X / 2, size.X / 2)
	local z = rng:NextNumber(-size.Z / 2, size.Z / 2)

	return (cf * CFrame.new(x, 0, z)).Position
end

local function raycastToGround(position)
	local origin = position + Vector3.new(0, SPAWN_HEIGHT, 0)
	local direction = Vector3.new(0, -SPAWN_HEIGHT * 2, 0)
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		spawnedHarvestables,
		regionParts
	}
	
	return workspace:Raycast(origin, direction, params)
end

local function isSlotFarEnough(regionData, position)
	for _, slot in ipairs(regionData.slots) do
		if (slot.position - position).Magnitude < regionData.config.slotSpacing then
			return false
		end
	end

	return true
end

local function isPlayerNear(position, radius)
	for _, player in ipairs(players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if root then
			local distance = (root.Position - position).Magnitude

			if distance <= radius then
				return true
			end
		end
	end

	return false
end

local function getAllAliveSlots(regionData)
	local aliveSlots = {}

	for _, slot in ipairs(regionData.slots) do
		if slot.occupied and slot.resource then
			table.insert(aliveSlots, slot)
		end
	end

	return aliveSlots
end

local function canPlaceResourceAtSlot(regionData, slot, resourceName)
	local rules = resourceRules[resourceName]
	local sameTypeSpacing = rules and rules.minSameTypeSpacing or 20

	for _, otherSlot in ipairs(allOccupiedSlots) do
		if otherSlot ~= slot then
			local distance = (otherSlot.position - slot.position).Magnitude

			if distance < GLOBAL_MIN_SPACING then
				return false
			end

			if otherSlot.resourceName == resourceName and distance < sameTypeSpacing then
				return false
			end
		end
	end

	return true
end

local function countAliveResources(regionData)
	local counts = {}
	local totalAlive = 0

	for resourceName in pairs(regionData.config.resources) do
		counts[resourceName] = 0
	end

	for _, slot in ipairs(regionData.slots) do
		if slot.occupied and slot.resourceName then
			counts[slot.resourceName] = (counts[slot.resourceName] or 0) + 1
			totalAlive += 1
		end
	end

	return counts, totalAlive
end

local function chooseMostUnderTarget(regionData, slot)
	local counts, totalAlive = countAliveResources(regionData)

	local bestResource = nil
	local biggestDeficit = -math.huge

	for resourceName, targetPercent in pairs(regionData.config.resources) do
		if canPlaceResourceAtSlot(regionData, slot, resourceName) then
			local currentPercent = 0

			if totalAlive > 0 then
				currentPercent = (counts[resourceName] or 0) / totalAlive
			end

			local deficit = targetPercent - currentPercent

			if deficit > biggestDeficit then
				biggestDeficit = deficit
				bestResource = resourceName
			end
		end
	end

	return bestResource
end

local function spawnResourceAtSlot(regionData, slot, resourceName)
	local template = harvestables:FindFirstChild(resourceName)

	if not template then
		warn("Missing resource model:", resourceName)
		return nil
	end

	local resource = template:Clone()
	resource.Parent = spawnedHarvestables
	
	for _, descendant in ipairs(resource:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
		end
	end
	
	local randomRotation = CFrame.Angles(0, math.rad(rng:NextInteger(0, 360)), 0)

	local _, size = resource:GetBoundingBox()

	local groundOffset = 0
	if resourceRules[resourceName] then
		groundOffset = resourceRules[resourceName].groundOffset or 0
	end

	local spawnPosition =
		slot.position +
		Vector3.new(0, size.Y / 2 - groundOffset, 0)

	resource:PivotTo(CFrame.new(spawnPosition) * randomRotation)

	resource:SetAttribute("ResourceName", resourceName)
	resource:SetAttribute("RegionName", regionData.name)
	resource:SetAttribute("SlotId", slot.id)

	slot.occupied = true
	slot.resource = resource
	slot.resourceName = resourceName
	slot.waitingToRespawn = false
	table.insert(allOccupiedSlots, slot)
	
	print(
		("[ResourceSpawner] Respawned %s in %s at (%.1f, %.1f, %.1f)")
			:format(
				resourceName,
				regionData.name,
				slot.position.X,
				slot.position.Y,
				slot.position.Z
			)
	)
	

	return resource
end

local function fillSlot(regionData, slot)
	if slot.occupied then
		return
	end

	local resourceName = chooseMostUnderTarget(regionData, slot)

	if not resourceName then
		warn("No valid resource found for slot in", regionData.name)
		return
	end

	spawnResourceAtSlot(regionData, slot, resourceName)
end

local function isValidSpawnSurface(regionData, result)
	if not result then
		return false
	end

	if result.Material == Enum.Material.Water then
		return false
	end

	if result.Normal.Y < 0.80 then
		return false
	end

	if result.Position.Y < 3 then
		return false
	end

	local allowedMaterials = regionData.config.allowedMaterials
	if allowedMaterials and not allowedMaterials[result.Material] then
		return false
	end

	return true
end

local function generateSlots(regionName, regionPart, config)
	local regionData = {
		name = regionName,
		part = regionPart,
		config = config,
		slots = {},
	}

	regions[regionName] = regionData

	local regionArea = regionPart.Size.X * regionPart.Size.Z
	local estimatedSlots = math.floor(regionArea / (config.slotSpacing * config.slotSpacing))

	local attempts = 0

	while #regionData.slots < estimatedSlots and attempts < MAX_SLOT_ATTEMPTS do
		attempts += 1

		local randomPoint = getRandomPointInRegion(regionPart)
		local result = raycastToGround(randomPoint)

		if result then
			local normal = result.Normal
			local position = result.Position

			if isValidSpawnSurface(regionData, result) and isSlotFarEnough(regionData, position) then
				local slot = {
					id = #regionData.slots + 1,
					position = position,
					occupied = false,
					resource = nil,
					resourceName = nil,
					waitingToRespawn = false,
				}

				table.insert(regionData.slots, slot)
			end
		end
	end

	print("Generated", #regionData.slots, "slots for", regionName)

	return regionData
end

local function fillAllSlots(regionData)
	for _, slot in ipairs(regionData.slots) do
		fillSlot(regionData, slot)
	end
end

local function waitUntilClearThenRespawn(regionData, slot)
	print("Waiting for respawn:", slot.id)
	if slot.waitingToRespawn then
		return
	end

	slot.waitingToRespawn = true

	task.spawn(function()
		while not slot.occupied do
			if not isPlayerNear(slot.position, PLAYER_CLEAR_RADIUS) then
				print("No player nearby, respawning!")
				fillSlot(regionData, slot)
				return
			end
			
			print("Player still nearby")

			task.wait(RESPAWN_CHECK_INTERVAL)
		end

		slot.waitingToRespawn = false
	end)
end

_G.HarvestResource = function(resource)
	
	print("Harvested:", resource.Name)
	
	if not resource or not resource.Parent then
		return
	end

	local regionName = resource:GetAttribute("RegionName")
	local slotId = resource:GetAttribute("SlotId")

	local regionData = regions[regionName]

	if not regionData then
		resource:Destroy()
		return
	end

	local slot = regionData.slots[slotId]
	
	for i, occupiedSlot in ipairs(allOccupiedSlots) do
		if occupiedSlot == slot then
			table.remove(allOccupiedSlots, i)
			break
		end
	end

	if not slot then
		resource:Destroy()
		return
	end

	slot.occupied = false
	slot.resource = nil
	slot.resourceName = nil

	resource:Destroy()

	waitUntilClearThenRespawn(regionData, slot)
end

for regionName, config in pairs(regionConfigs) do
	local regionPart = regionParts:FindFirstChild(regionName)

	if regionPart then
		local regionData = generateSlots(regionName, regionPart, config)
		fillAllSlots(regionData)
	else
		warn("Missing region part:", regionName)
	end
end

