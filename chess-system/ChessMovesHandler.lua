local pieceInteractionRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PieceInteraction")
local squaresRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Squares")

pieceInteractionRE.OnClientEvent:Connect(function(board, color, piece, file, rank, click)
	if click == "clicked" then
		pieceInteractionRE:FireServer(true, piece)
		local selectionBox = Instance.new("SelectionBox")
		selectionBox.Parent = workspace:FindFirstChild(board):FindFirstChild(color):FindFirstChild(piece)
		selectionBox.Adornee = workspace:FindFirstChild(board):FindFirstChild(color):FindFirstChild(piece)
		selectionBox.Transparency = 0.5
		selectionBox.LineThickness = 0.1
		selectionBox.Color3 = Color3.fromRGB(170, 170, 255)
	elseif click == "unclicked" then
		pieceInteractionRE:FireServer(false, "")
			
		workspace:FindFirstChild(board):FindFirstChild(color):FindFirstChild(piece).SelectionBox:Destroy()
	elseif click == "moved" then
		workspace:FindFirstChild(board):FindFirstChild(color):FindFirstChild(piece).SelectionBox:Destroy()
		for i, v in pairs(workspace:FindFirstChild(board).Chessboard:GetChildren()) do
			if v:FindFirstChild("SelectionBox") then
				v.SelectionBox:Destroy()
				v.ClickDetector.MaxActivationDistance = 0
			end
		end
	end
end)

squaresRE.OnClientEvent:Connect(function(board, square, takes)
	if (workspace:FindFirstChild(board).Chessboard:FindFirstChild(square):FindFirstChild("SelectionBox")) then
		workspace:FindFirstChild(board).Chessboard:FindFirstChild(square).SelectionBox:Destroy()
	else
		local selectionBox = Instance.new("SelectionBox")
		selectionBox.Parent = workspace:FindFirstChild(board).Chessboard:FindFirstChild(square)
		selectionBox.Adornee = workspace:FindFirstChild(board).Chessboard:FindFirstChild(square)
		selectionBox.Transparency = 0.5
		selectionBox.LineThickness = 0.1
		selectionBox.Color3 = Color3.fromRGB(170, 170, 255)
		selectionBox.SurfaceTransparency = 0.4
		
		workspace:FindFirstChild(board).Chessboard:FindFirstChild(square).ClickDetector.MaxActivationDistance = 2000
		if takes == "capture" then
			squaresRE:FireServer(true, square)
		elseif takes == "castles" then
			squaresRE:FireServer("castle", square)
		else
			squaresRE:FireServer(false, square)
		end
	end
end)
