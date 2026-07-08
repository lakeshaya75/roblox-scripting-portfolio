-- STONE PICKAXE --
-- REQUIREMENTS: 15 OAK, 6 STONE

local replStorage = game:GetService("ReplicatedStorage")

local item = script.Parent
local btn = item.CraftButton

local bg = item.Parent.Parent

local ui = script.Parent.Parent.Parent.Parent.Parent
local invFrame = ui.InventoryFrame

btn.MouseEnter:Connect(function()
	btn.ImageTransparency = 0.5
end)

btn.MouseLeave:Connect(function()
	btn.ImageTransparency = 0
end)

btn.MouseButton1Click:Connect(function()
	if invFrame.Background.Scroll:FindFirstChild("OakTree") and invFrame.Background.Scroll:FindFirstChild("Stone") then
		local oakCount = tonumber(invFrame.Background.Scroll.OakTree.Count.Text)
		local stoneCount = tonumber(invFrame.Background.Scroll.Stone.Count.Text)
		
		if oakCount >= 15 and stoneCount >= 6 then
			oakCount -= 15
			stoneCount -= 6

			invFrame.Background.Scroll.OakTree.Count.Text = tostring(oakCount)
			invFrame.Background.Scroll.Stone.Count.Text = tostring(stoneCount)
			
			if oakCount == 1 then
				invFrame.Background.Scroll.OakTree.Count.Visible = false
			end
			if stoneCount == 1 then
				invFrame.Background.Scroll.Stone.Count.Visible = false
			end
			
			if oakCount == 0 then
				invFrame.Background.Scroll.OakTree:Destroy()
			end
			if stoneCount == 0 then
				invFrame.Background.Scroll.Stone:Destroy()
			end
			
			replStorage:WaitForChild("Remotes"):WaitForChild("Craft"):FireServer("StonePickaxe")
			item:Destroy()
			return
		end
	end
	
	btn.Interactable = false
	
	if ui.MessageBoard.Position.Y.Scale == 1.5 then
		ui.MessageBoard.Message.Text = "Not enough required materials!"
		ui.MessageBoard:TweenPosition(UDim2.new(0.5, 0, 0.8, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 2)
		wait(4)
		ui.MessageBoard:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 2)
	end
	
	btn.Interactable = true

end)
