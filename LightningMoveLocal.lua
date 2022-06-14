local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local LightningRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("LightningPlayer")

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local LightningAnimation = Instance.new("Animation")
LightningAnimation.Name = "LightningAnimation"
LightningAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script.Lightning)

-- Load Animation

local lightningAnimationTrack = Animator:LoadAnimation(LightningAnimation)
lightningAnimationTrack.Priority = Enum.AnimationPriority.Action

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.L and not gameProcessed then
			lightningAnimationTrack:Play()
			LightningRemote:FireServer()
			humanoid.WalkSpeed = 0
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.L and not gameProcessed then
			humanoid.WalkSpeed = 16
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
