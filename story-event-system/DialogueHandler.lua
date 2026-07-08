-- Variables --

local DialogueEvent = game.ReplicatedStorage.RemoteEvents.DialogueEvent -- defines RemoteEvent in ReplicatedStorage
local VisibleEvent = game.ReplicatedStorage.RemoteEvents.VisibleEvent

local backgroundFrame = script.Parent.Background
local borderFrame = script.Parent.Borders
local characterImage = backgroundFrame.CharacterImage
local dialogueText = backgroundFrame.DialogueText
local characterName = backgroundFrame.CharacterName
local typingSound = backgroundFrame.TypeSound

local messageWaitSigns = {".", "!", ",", "?", "-"}

-- Functions --


function animateText(dialogue) 
	for i = 1, #dialogue do -- Finds number of characters
		dialogueText.Text = string.sub(dialogue, 1, i) -- Manipulates characters to animate
		for index, value in pairs(messageWaitSigns) do
			if string.sub(dialogue, i, i) == value then
				wait(.425)			
			end
		end	
		wait(.075)
		typingSound:Play()
	end
end


DialogueEvent.OnClientEvent:Connect(function(player, text, id, backgroundColor, borderColor) -- Runs function OnClientEvent for DialogueEvent
	backgroundFrame.BackgroundColor3 = backgroundColor
	borderFrame.BackgroundColor3 = borderColor
	
	characterName.Text	= player.Name or player
	characterImage.Image = id
	animateText(text)
end)

VisibleEvent.OnClientEvent:Connect(function(visibility)
	backgroundFrame.Visible = visibility
	borderFrame.Visible = visibility
end)
