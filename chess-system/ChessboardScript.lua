local chessEquip = script.Parent

local blackPieces = chessEquip.BlackPieces
local whitePieces = chessEquip.WhitePieces
local blackTP = chessEquip.BlackTakenPieces
local whiteTP = chessEquip.WhiteTakenPieces

local chessboard = chessEquip.Chessboard

for i, v in pairs(chessboard:GetChildren()) do
	if (v.Name[2] == "1" or v.Name[2] == "2") then
		v:FindFirstChild("Occupied").Value = "White"
	elseif (v.Name[2] == "7" or v.Name[2] == "8") then
		v:FindFirstChild("Occupied").Value = "Black"	
	end
end

chessEquip.MoveTurn.Value = 0

chessEquip.MoveTurn.Changed:Connect(function(value)
	for i, v in pairs (chessEquip:GetChildren()) do
		if v.Name == "AvailableSquare" then
			v:Destroy()
		end
	end
	chessEquip.PieceSelected.Value = false
	if value == 0 then
		for i, v in pairs(chessEquip.BlackPieces:GetChildren()) do
			if v:FindFirstChild("ClickDetector") then
				v.ClickDetector.MaxActivationDistance = 0
			end
		end
		for i, v in pairs(chessEquip.WhitePieces:GetChildren()) do
			if v:FindFirstChild("ClickDetector") then
				v.ClickDetector.MaxActivationDistance = 2000
			end
		end
	else
		for i, v in pairs(chessEquip.WhitePieces:GetChildren()) do
			if v:FindFirstChild("ClickDetector") then
				v.ClickDetector.MaxActivationDistance = 0
			end
		end
		for i, v in pairs(chessEquip.BlackPieces:GetChildren()) do
			if v:FindFirstChild("ClickDetector") then
				v.ClickDetector.MaxActivationDistance = 2000
			end
		end
	end
	
	for i, v in pairs(chessboard:GetChildren()) do
		if (v:FindFirstChild("ClickDetector")) then
			v.ClickDetector.MaxActivationDistance = 0
		end
	end
end)


