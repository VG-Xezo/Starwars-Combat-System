local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local HealRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("HealPlayer")
local healing = false

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local HealingAnimation = Instance.new("Animation")
HealingAnimation.Name = "HealingAnimation"
HealingAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script.Healing)

-- Load Animation

local healingAnimationTrack = Animator:LoadAnimation(HealingAnimation)
healingAnimationTrack.Priority = Enum.AnimationPriority.Action
healingAnimationTrack.Looped = true

-- Get Vfx

local healVfxEmitter = character.UpperTorso:WaitForChild("HealingAttachment").ParticleEmitter

-- Healing Script

local function healPlayer()
	if mouse.Target then
		-- Validate Player
		if mouse.Target.Parent:FindFirstChild("Humanoid") then
			local characterToHeal = mouse.Target.Parent
			print(characterToHeal:GetFullName())
			HealRemote:FireServer(characterToHeal)
			print("FIRED REMOTE")
		else
			local characterToHeal = Players.LocalPlayer.Character
			HealRemote:FireServer(characterToHeal)
		end
	else
		local characterToHeal = Players.LocalPlayer.Character
		HealRemote:FireServer(characterToHeal)
		print("NO HUMANOID HEAL SELF")
	end
end

local regenFunc = function()
	while true do
		if healing then
			healPlayer()
		end
		wait(1)
	end
end

local Thread = coroutine.wrap(regenFunc);
Thread()

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
			healingAnimationTrack:Play()
			humanoid.WalkSpeed = 0
			healing = true
			healVfxEmitter.Enabled = true
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
			healingAnimationTrack:Stop()
			humanoid.WalkSpeed = 16
			healing = false
			healVfxEmitter.Enabled = false
		end
	end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
