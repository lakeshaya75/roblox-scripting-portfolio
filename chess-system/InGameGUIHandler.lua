local inGameGui = script.Parent

local transitionFrame = inGameGui.TransitionFrame
local gameInfoFrame = inGameGui.InGameFrame.GameInfo
local notationBoardFrame = inGameGui.InGameFrame.NotationBoard

local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")

local beginGameEvent = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BeginGame")
local pieceMovedEvent = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PieceMove")

local currCam = workspace.CurrentCamera
local setup

local controls = require(players.LocalPlayer.PlayerScripts.PlayerModule):GetControls()
beginGameEvent.OnClientEvent:Connect(function(player1Name, player2Name, timeControl)
	
	local player1 = game.Players:FindFirstChild(player1Name)
	transitionFrame.WhitePlayer.Main.WPlayerName.Text = player1Name
	transitionFrame.WhitePlayer.Main.WPlayerRating.Text= 1000
	transitionFrame.WhitePlayer.Main.WPlayerImage.Image = (players:GetUserThumbnailAsync(player1.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420))
	
	local player2 = game.Players:FindFirstChild(player2Name)
	transitionFrame.BlackPlayer.Main.BPlayerName.Text = player2Name
	transitionFrame.BlackPlayer.Main.BPlayerRating.Text= 1000
	transitionFrame.BlackPlayer.Main.BPlayerImage.Image = (players:GetUserThumbnailAsync(player2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420))
	
	script.Parent.Enabled = true
	transitionFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad)
	wait(2)
	setup = workspace:FindFirstChild(player1Name .. " vs Richard") -- change to player 2 name
	
	transitionFrame.WhitePlayer:TweenPosition(UDim2.new(0.4, 0, 0.3, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine)
	transitionFrame.BlackPlayer:TweenPosition(UDim2.new(0.6, 0, 0.7, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine)
	
	
	wait(5)
	transitionFrame.WhitePlayer:TweenPosition(UDim2.new(1.4, 0, 0.3, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine)
	transitionFrame.BlackPlayer:TweenPosition(UDim2.new(-0.4, 0, 0.7, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine)
	game:GetService("Players").LocalPlayer.CameraMinZoomDistance = 20                          
	game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 1000
	currCam.CameraSubject = setup:FindFirstChild("CenterCameraFocus")
	controls:Disable()

	wait(2)
	transitionFrame:TweenPosition(UDim2.new(0.5, 0, 2, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad)
	
	wait(2)
	gameInfoFrame:TweenPosition(UDim2.new(0.5, 0, 0.1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back)
	
	gameInfoFrame.Mainframe.Player1Image.Image = (players:GetUserThumbnailAsync(player1.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420))
	gameInfoFrame.Mainframe.Player1Label.Text = player1Name
	gameInfoFrame.Mainframe.Player2Image.Image = (players:GetUserThumbnailAsync(player2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420))
	gameInfoFrame.Mainframe.Player2Label.Text = player2Name
	
	
	notationBoardFrame:TweenPosition(UDim2.new(0.85, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back)
	
end)


-- end of matchmaking stuff

local newMove

pieceMovedEvent.OnClientEvent:Connect(function(piece, square, color, capture, originalSquare)
	if color == "White" then
		newMove = notationBoardFrame.Mainframe.MoveTemplate:Clone()
		newMove.Name = tostring(#notationBoardFrame.Mainframe.MoveList:GetChildren() - 1)
		newMove.Parent = notationBoardFrame.Mainframe.MoveList
		newMove.Visible = true
		newMove.Number.Text = tostring(#notationBoardFrame.Mainframe.MoveList:GetChildren() - 1)		
		
		if string.sub(piece, 6, 9) == "Pawn" then
			if capture == true then
				newMove.WhiteMove.Text = string.sub(originalSquare, 1, 1) .. "x" .. square
			else
				newMove.WhiteMove.Text = square
			end
		elseif string.sub(piece, 6, 11) == "Bishop" then
			if capture == true then
				newMove.WhiteMove.Text = "Bx" .. square
			else
				newMove.WhiteMove.Text = "B" .. square
			end
		elseif string.sub(piece, 6, 9) == "Rook" then
			if capture == true then
				newMove.WhiteMove.Text = "Rx" .. square
			else
				newMove.WhiteMove.Text = "R" .. square
			end
		elseif string.sub(piece, 6, 9) == "King" then
			if capture == true then
				newMove.WhiteMove.Text = "Kx" .. square
			else
				newMove.WhiteMove.Text = "K" .. square
			end
		elseif string.sub(piece, 6, 11) == "Knight" then
			if capture == true then
				newMove.WhiteMove.Text = "Nx" .. square
			else
				newMove.WhiteMove.Text = "N" .. square
			end
		elseif string.sub(piece, 6, 10) == "Queen" then
			if capture == true then
				newMove.WhiteMove.Text = "Qx" .. square
			else
				newMove.WhiteMove.Text = "Q" .. square
			end
		end
	else
		if string.sub(piece, 6, 9) == "Pawn" then
			if capture == true then
				newMove.BlackMove.Text = string.sub(originalSquare, 1, 1) .. "x" .. square
			else
				newMove.BlackMove.Text = square
			end
		elseif string.sub(piece, 6, 11) == "Bishop" then
			if capture == true then
				newMove.BlackMove.Text = "Bx" .. square
			else
				newMove.BlackMove.Text = "B" .. square
			end
		elseif string.sub(piece, 6, 9) == "Rook" then
			if capture == true then
				newMove.BlackMove.Text = "Rx" .. square
			else
				newMove.BlackMove.Text = "R" .. square
			end
		elseif string.sub(piece, 6, 9) == "King" then
			if capture == true then
				newMove.BlackMove.Text = "Kx" .. square
			else
				newMove.BlackMove.Text = "K" .. square
			end
		elseif string.sub(piece, 6, 11) == "Knight" then
			if capture == true then
				newMove.BlackMove.Text = "Nx" .. square
			else
				newMove.BlackMove.Text = "N" .. square
			end
		elseif string.sub(piece, 6, 10) == "Queen" then
			if capture == true then
				newMove.BlackMove.Text = "Qx" .. square
			else
				newMove.BlackMove.Text = "Q" .. square
			end
		end
	end
end)
