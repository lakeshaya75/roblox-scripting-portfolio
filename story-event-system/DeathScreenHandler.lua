local deathScreenGui = script.Parent

local background = deathScreenGui.Background
local continueButton = background.ContinueButton
local restartButton = background.RestartButton
local status = background.Status

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

local lobbyId = 2569453732
local productId = 21175902

humanoid.Died:Connect(function()
	
	background:TweenPosition(UDim2.new(0.5, 0, 0.5, 0))
	
	for i = 15, 0, -1 do
		
		status.Text = "Choose one. (" .. i .. ")"
		
		wait(1)
		
	end
	
	game:GetService("TeleportService"):Teleport(lobbyId)
	
end)

restartButton.MouseButton1Click:Connect(function()
	
	wait(1)
	
	game:GetService("TeleportService"):Teleport(lobbyId)
	
end)

continueButton.MouseButton1Click:Connect(function()
	
	game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, productId)
	
end)
