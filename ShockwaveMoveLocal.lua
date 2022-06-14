local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local ShockwaveRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("ShockwavePlayer")

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local ShockwaveAnimation = Instance.new("Animation")
ShockwaveAnimation.Name = "ShockwaveAnimation"
ShockwaveAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script.Meditation)

-- Load Animation

local shockwaveAnimationTrack = Animator:LoadAnimation(ShockwaveAnimation)
shockwaveAnimationTrack.Priority = Enum.AnimationPriority.Action

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
			shockwaveAnimationTrack:Play()
			ShockwaveRemote:FireServer()
			humanoid.WalkSpeed = 0
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Z and not gameProcessed then
			shockwaveAnimationTrack:Stop()
			humanoid.WalkSpeed = 16
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
