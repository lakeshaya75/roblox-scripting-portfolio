-- was used for every square in the chessboard (64)

local square = script.Parent

local clickDetect = square.ClickDetector
local occupied = square.Occupied

local equipment = script.Parent.Parent.Parent

local tweenService = game:GetService("TweenService")

local capturing

local tweenInfo = TweenInfo.new(
	1.5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.In,
	0,
	false,
	0.5
)

local pieceSelected

local pieceInteractionRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PieceInteraction")
local pieceMovedRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PieceMove")
local squaresRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Squares")

pieceInteractionRE.OnServerEvent:Connect(function(player, bool, piece)
	pieceSelected = piece
end)

squaresRE.OnServerEvent:Connect(function(player, takes, square)
	if (square == script.Parent.Name) then
		capturing = takes
	end
end)

clickDetect.MouseClick:Connect(function(player)
	if (equipment.MoveTurn.Value == 0) then
		if (player.Name == equipment.White.Value) then
			for i, v in pairs(equipment.WhitePieces:GetChildren()) do
				if v.Name == pieceSelected then
					if capturing == true then
						for i, v in pairs(equipment.BlackPieces:GetChildren()) do
							if v:FindFirstChild("CurrentSquare") then
								if v.CurrentSquare.Value == square.Name then
									local removePieceGoal = {
										Position = equipment.BlackTakenPieces:FindFirstChild(v.Name).Position
									}
									local removePieceTween = tweenService:Create(v, tweenInfo, removePieceGoal)
									removePieceTween:Play()
									v.Parent = equipment.BlackTakenPieces
								end
							end
						end
					end
					
					local goal = {
						Position = Vector3.new(square.Position.X, v.Position.Y, square.Position.Z)
					}
					local tween = tweenService:Create(v, tweenInfo, goal)
					tween:Play()
					equipment.MoveTurn.Value = 1
					
					pieceMovedRE:FireClient(game.Players:FindFirstChild(equipment.White.Value), v.Name, square.Name, "White", capturing, v.CurrentSquare.Value)
					pieceMovedRE:FireClient(game.Players:FindFirstChild(equipment.Black.Value), v.Name, square.Name, "White", capturing, v.CurrentSquare.Value)
					square.Occupied.Value = "White"
					equipment.Chessboard:FindFirstChild(v.CurrentSquare.Value).Occupied.Value = ""
					v.CurrentSquare.Value = square.Name
					pieceInteractionRE:FireClient(player, equipment.Name, "WhitePieces", v.Name, square.Name[1], square.Name[2], "moved")
					
				end
			end
		end
	else
		if player.Name == equipment.Black.Value then
			for i, v in pairs(equipment.BlackPieces:GetChildren()) do
				if v.Name == pieceSelected then
					
					if capturing == true then
						for i, v in pairs(equipment.WhitePieces:GetChildren()) do
							if v:FindFirstChild("CurrentSquare") then
								if v.CurrentSquare.Value == square.Name then
									local removePieceGoal = {
										Position = equipment.WhiteTakenPieces:FindFirstChild(v.Name).Position
									}
									local removePieceTween = tweenService:Create(v, tweenInfo, removePieceGoal)
									removePieceTween:Play()
									v.Parent = equipment.WhiteTakenPieces
								end
							end
						end
					end
					
					local goal = {
						Position = Vector3.new(square.Position.X, v.Position.Y, square.Position.Z)
					}
					local tween = tweenService:Create(v, tweenInfo, goal)
					tween:Play()
					equipment.MoveTurn.Value = 0
					
					pieceMovedRE:FireClient(game.Players:FindFirstChild(equipment.White.Value), v.Name, square.Name, "Black", capturing, v.CurrentSquare.Value)
					pieceMovedRE:FireClient(game.Players:FindFirstChild(equipment.Black.Value), v.Name, square.Name, "Black", capturing, v.CurrentSquare.Value)
						
					square.Occupied.Value = "Black"
					equipment.Chessboard:FindFirstChild(v.CurrentSquare.Value).Occupied.Value = ""
					v.CurrentSquare.Value = square.Name
					pieceInteractionRE:FireClient(player, equipment.Name, "BlackPieces", v.Name, square.Name[1], square.Name[2], "moved")
				end
			end
		end
	end
end)
