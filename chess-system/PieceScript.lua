-- was used for all black and white (32) pieces

local piece = script.Parent

local clickDetect = piece.ClickDetector

local files = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}

local pieceRank = string.sub(piece.CurrentSquare.Value, 2, 2)
local pieceFile = table.find(files, string.sub(piece.CurrentSquare.Value, 1, 1))

local equipment = script.Parent.Parent.Parent

local chessboard = script.Parent.Parent.Parent.Chessboard

local pieceInteractionRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("PieceInteraction")
local squaresRE = game.ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Squares")

local pieceSelected

pieceInteractionRE.OnServerEvent:Connect(function(player, bool, piece1)
	equipment.PieceSelected.Value = bool
	pieceSelected = piece1
end)

piece.CurrentSquare.Changed:Connect(function()
	if pieceFile ~= 1 then
		chessboard:FindFirstChild(tostring(files[pieceFile - 1] .. pieceRank - 1)).BAttacked.Value = false
	end
	if pieceFile ~= 8 then 
		chessboard:FindFirstChild(tostring(files[pieceFile + 1] .. pieceRank - 1)).BAttacked.Value = false
	end
	pieceRank = string.sub(piece.CurrentSquare.Value, 2, 2)
	pieceFile = table.find(files, string.sub(piece.CurrentSquare.Value, 1, 1))
	if pieceFile ~= 1 then
		if equipment.WhitePieces.WhiteKing.CurrentSquare.Value == tostring(files[pieceFile - 1] .. pieceRank - 1) then
			local newAS = Instance.new("StringValue")
			newAS.Parent = equipment
			newAS.Name = "AvailableSquare"
			newAS.Value = tostring(files[pieceFile] .. pieceRank)
		end
		chessboard:FindFirstChild(tostring(files[pieceFile - 1] .. pieceRank - 1)).BAttacked.Value = true
	end
	if pieceFile ~= 8 then 
		if equipment.WhitePieces.WhiteKing.CurrentSquare.Value == tostring(files[pieceFile + 1] .. pieceRank - 1) then
			local newAS = Instance.new("StringValue")
			newAS.Parent = equipment
			newAS.Name = "AvailableSquare"
			newAS.Value = tostring(files[pieceFile] .. pieceRank)
		end
		chessboard:FindFirstChild(tostring(files[pieceFile + 1] .. pieceRank - 1)).BAttacked.Value = true
	end
end)

clickDetect.MouseClick:Connect(function(player)
	pieceRank = string.sub(piece.CurrentSquare.Value, 2, 2)
	pieceFile = table.find(files, string.sub(piece.CurrentSquare.Value, 1, 1))
	if equipment:FindFirstChild("Black") then
		if equipment.Black.Value == player.Name then 
			if equipment.PieceSelected.Value == false then
				pieceInteractionRE:FireClient(player, equipment.Name, "BlackPieces", piece.Name, files[pieceFile], pieceRank, "clicked")

				if (chessboard:FindFirstChild(tostring(files[pieceFile] .. pieceRank - 1)).Occupied.Value == "") then 
					squaresRE:FireClient(player, equipment.Name, (files[pieceFile] .. pieceRank - 1), "free")
					if (chessboard:FindFirstChild(tostring(files[pieceFile] .. pieceRank - 2)).Occupied.Value == "" and pieceRank == "7") then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile] .. pieceRank - 2), "free")
					end
				end
				if pieceFile ~= 1 then
					if (chessboard:FindFirstChild(tostring(files[pieceFile - 1] .. pieceRank - 1)).Occupied.Value == "White") then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile - 1] .. pieceRank - 1), "capture")
					end
				end
				if pieceFile ~= 8 then
					if (chessboard:FindFirstChild(tostring(files[pieceFile + 1] .. pieceRank - 1)).Occupied.Value == "White") then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile + 1] .. pieceRank - 1), "capture")
					end
				end
			elseif equipment.PieceSelected.Value == true and pieceSelected == piece.Name then
				pieceInteractionRE:FireClient(player, equipment.Name, "BlackPieces", piece.Name, files[pieceFile], pieceRank, "unclicked")

				if (chessboard:FindFirstChild(tostring(files[pieceFile] .. pieceRank - 1)).Occupied.Value == "") then 
					squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile] .. pieceRank - 1), "free")
					if (chessboard:FindFirstChild(tostring(files[pieceFile] .. pieceRank - 2)).Occupied.Value == "") then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile] .. pieceRank - 2), "free")
					end
				end
				if pieceFile ~= 1 then
					if chessboard:FindFirstChild(tostring(files[pieceFile - 1]  .. pieceRank - 1)).Occupied.Value == "White" then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile - 1] .. pieceRank - 1), "capture")
					end
				end
				if pieceFile ~= 8 then
					if chessboard:FindFirstChild(tostring(files[pieceFile + 1]  .. pieceRank - 1)).Occupied.Value == "White" then 
						squaresRE:FireClient(player, equipment.Name, tostring(files[pieceFile + 1] .. pieceRank - 1), "capture")
					end
				end
			end
		end
	end
end)
