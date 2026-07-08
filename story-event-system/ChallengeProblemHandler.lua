local MathProblemEvent = game.ReplicatedStorage.RemoteEvents.MathProblemEvent

local MathProblemsGui = script.Parent
local background = MathProblemsGui.Background
local borders = MathProblemsGui.Borders
local question = background.Question
local questionAnswer = background.Answer
local confirmButton = background.Confirm
local result = background.Result


MathProblemEvent.OnClientEvent:Connect(function()
	
	background:TweenPosition(UDim2.new(0.5, 0, 0.5, 0))

	borders:TweenPosition(UDim2.new(0.5, 0, 0.5, 0))
	
	question.Text = "What is 11 x 10?"
	
	confirmButton.MouseButton1Click:Connect(function()	
		
		result.Visible = true
		questionAnswer.Visible = false
		confirmButton.Visible = false
		
		if questionAnswer.Text == "110" then
			
			result.Text = "CORRECT!"
							
		else
				
			result.Text = "INCORRECT!"				
			
		end
		
		wait(2)
		
		background:TweenPosition(UDim2.new(0.5, 0, -0.5, 0))

		borders:TweenPosition(UDim2.new(0.5, 0, -0.5, 0))
	end)
	
	wait(15)
	
	background:TweenPosition(UDim2.new(0.5, 0, -0.5, 0))

	borders:TweenPosition(UDim2.new(0.5, 0, -0.5, 0))
	
	if result.Text == "CORRECT!" then
	
		local cookieTool = game.ReplicatedStorage.Cookie:Clone()
		cookieTool.Parent = game:GetService("Players").LocalPlayer.Backpack
		
	end
	
	
end)


