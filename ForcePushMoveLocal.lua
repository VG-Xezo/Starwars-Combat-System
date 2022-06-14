local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local LaunchRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("LaunchPlayer")

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local PushAnimation = Instance.new("Animation")
PushAnimation.Name = "PushAnimation"
PushAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script.ForcePush)

-- Load Animation

local pushAnimationTrack = Animator:LoadAnimation(PushAnimation)
pushAnimationTrack.Priority = Enum.AnimationPriority.Action

local function pushMove()
	print(mouse.Target:GetFullName())
	if mouse.Target then
		local Character = mouse.Target.Parent
		if Character:FindFirstChild("Humanoid") then
			LaunchRemote:FireServer(Character)
		end
	end
end

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
			pushAnimationTrack:Play()
			pushMove()
			humanoid.WalkSpeed = 0
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
			humanoid.WalkSpeed = 16
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
