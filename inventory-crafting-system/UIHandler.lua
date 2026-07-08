local replStorage = game:GetService("ReplicatedStorage")
local remotes = replStorage:WaitForChild("Remotes")
local harvestEvent = remotes:WaitForChild("Harvest")

local UI = script.Parent

-- inventory stuff

local inventoryItem = script:WaitForChild("InventoryItem")

local inventoryButton = UI:WaitForChild("InventoryButton")
local inventoryBtnX = inventoryButton.Size.X.Scale
local inventoryBtnY = inventoryButton.Size.Y.Scale

local inventoryFrame = UI:WaitForChild("InventoryFrame")
local inventoryBg = inventoryFrame.Background
local inventoryCloseBtn = inventoryBg.Close

-- crafting stuff

local craftingButton = UI:WaitForChild("CraftingButton")
local craftingBtnX = craftingButton.Size.X.Scale
local craftingBtnY = craftingButton.Size.Y.Scale

local craftingFrame = UI:WaitForChild("CraftingFrame")
local craftingBg = craftingFrame.Background
local craftingCloseBtn = craftingBg.Close

local debounce = false

inventoryButton.MouseEnter:Connect(function()
	inventoryButton:TweenSize(UDim2.new(inventoryBtnX * 1.1, 0, inventoryBtnY * 1.1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
end)

inventoryButton.MouseLeave:Connect(function()
	inventoryButton:TweenSize(UDim2.new(inventoryBtnX, 0, inventoryBtnY, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)

inventoryButton.MouseButton1Click:Connect(function()
	if debounce == false then
		debounce = true
		if inventoryFrame.Position.X.Scale == 1.5 then
			inventoryButton.Visible = false
			craftingButton.Visible = false
			inventoryButton.Sound:Play()
			inventoryFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 1, true)
		end
		wait(1)
		debounce = false
	end
end)

inventoryCloseBtn.MouseButton1Click:Connect(function()
	if debounce == false then
		debounce = true
		if inventoryFrame.Position.X.Scale == 0.5 then
			inventoryCloseBtn.Sound:Play()
			inventoryFrame:TweenPosition(UDim2.new(1.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
		end
		wait(1)
		debounce = false
		inventoryBg.Description.Visible = false
		inventoryButton.Visible = true
		craftingButton.Visible = true
	end
end)

craftingButton.MouseEnter:Connect(function()
	craftingButton:TweenSize(UDim2.new(craftingBtnX * 1.1, 0, craftingBtnY * 1.1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
end)

craftingButton.MouseLeave:Connect(function()
	craftingButton:TweenSize(UDim2.new(craftingBtnX, 0, craftingBtnY, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)


craftingButton.MouseButton1Click:Connect(function()
	if debounce == false then
		debounce = true
		if craftingFrame.Position.X.Scale == 1.5 then
			inventoryButton.Visible = false
			craftingButton.Visible = false
			craftingButton.Sound:Play()
			craftingFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 1, true)
		end
		wait(1)
		debounce = false
	end
end)

craftingCloseBtn.MouseButton1Click:Connect(function()
	if debounce == false then
		debounce = true
		if craftingFrame.Position.X.Scale == 0.5 then
			craftingCloseBtn.Sound:Play()
			craftingFrame:TweenPosition(UDim2.new(1.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
		end
		wait(1)
		debounce = false
		inventoryButton.Visible = true
		craftingButton.Visible = true
	end
end)

harvestEvent.OnClientEvent:Connect(function(harvestable, harvest)
	if inventoryBg.Scroll:FindFirstChild(harvestable) then
		inventoryBg.Scroll:FindFirstChild(harvestable):WaitForChild("Count").Visible = true
		inventoryBg.Scroll:FindFirstChild(harvestable):WaitForChild("Count").Text = tonumber(inventoryBg.Scroll:FindFirstChild(harvestable):WaitForChild("Count").Text) + harvest
		return
	end
	
	local clonedItem = inventoryItem:Clone()
	clonedItem.Parent = inventoryBg.Scroll
	clonedItem.Active = true
	clonedItem.Name = harvestable
	clonedItem.ItemHandler.Enabled = true
	if harvest > 1 then
		clonedItem:FindFirstChild("Count").Visible = true
		clonedItem:FindFirstChild("Count").Text = harvest
	end
	
	if harvestable == "AcaciaTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://130144933713914"
		clonedItem.Description.Value = "Acacia trees are known for their wide canopies and tough wood, helping them survive harsh dry climates."
	elseif harvestable == "BirchTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://73492707765863"
		clonedItem.Description.Value = "Birch trees are famous for their pale peeling bark, which was once used as paper and canoe material."
	elseif harvestable == "PineTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://104546207693284"
		clonedItem.Description.Value = "Pine trees stay green year-round and produce cones filled with seeds instead of flowers."
	elseif harvestable == "OakTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://102288134941733"
		clonedItem.Description.Value = "Oak trees can live for hundreds of years and produce acorns that feed many forest animals."
	elseif harvestable == "PalmTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://140432549621617"
		clonedItem.Description.Value = "Palm trees are built to handle strong coastal winds with their flexible trunks and leaves."
	elseif harvestable == "MangroveTree" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://81886490381036"
		clonedItem.Description.Value = "Mangrove trees can grow in salty ocean water thanks to their special filtering root systems."
	elseif harvestable == "Stone" then
		clonedItem:FindFirstChild("Icon").Image = "rbxassetid://111395957678150"
		clonedItem.Description.Value = "Stones are the basis of all buildings in modern society due to their relative abundance."
	end
end)
