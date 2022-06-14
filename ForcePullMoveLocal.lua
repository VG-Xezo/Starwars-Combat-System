local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local PullRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("PullPlayer")

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local PullAnimation = Instance.new("Animation")
PullAnimation.Name = "PullAnimation"
PullAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script.ForcePush)

-- Load Animation

local pullAnimationTrack = Animator:LoadAnimation(PullAnimation)
pullAnimationTrack.Priority = Enum.AnimationPriority.Action

local function pullMove()
	print(mouse.Target:GetFullName())
	if mouse.Target then
		local Character = mouse.Target.Parent
		if Character:FindFirstChild("Humanoid") then
			PullRemote:FireServer(Character)
		end
	end
end

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.P and not gameProcessed then
			pullAnimationTrack:Play()
			pullMove()
			humanoid.WalkSpeed = 0
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.P and not gameProcessed then
			humanoid.WalkSpeed = 16
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
