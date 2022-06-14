local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local mouse = Players.LocalPlayer:GetMouse()
local MindtrickRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("MindtrickPlayer")
local ControlRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("ControlPlayer")
local DisableControlsRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("DisableControls")

-- Get Animation Values

local player = Players.LocalPlayer
local character = player.Character
if not character or not character.Parent then
	character = player.CharacterAdded:Wait()
end

local humanoid = character:WaitForChild("Humanoid")
local Animator = humanoid:WaitForChild("Animator")

-- Setting up Animation

local MindtrickAnimation = Instance.new("Animation")
MindtrickAnimation.Name = "MindtrickAnimation"
MindtrickAnimation.AnimationId = game:GetService("KeyframeSequenceProvider"):RegisterKeyframeSequence(script["Mind Control"])

-- Load Animation

local mindtrickAnimationTrack = Animator:LoadAnimation(MindtrickAnimation)
mindtrickAnimationTrack.Priority = Enum.AnimationPriority.Action
mindtrickAnimationTrack.Looped = true


-- Healing Script

local function mindtrickPlayer()
	if mouse.Target then
		-- Validate Player
		if mouse.Target.Parent:FindFirstChild("Humanoid") then
			local characterToMindtrick = mouse.Target.Parent
			print(characterToMindtrick:GetFullName() .. " MINDTRICK")
			MindtrickRemote:FireServer(characterToMindtrick)
			print("FIRED MINDTRICK REMOTE")
		end
	end
end

local function onInputBegan(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.M and not gameProcessed then
			mindtrickAnimationTrack:Play()
			mindtrickPlayer()
			humanoid.WalkSpeed = 0
		end
		if input.KeyCode == Enum.KeyCode.H and not gameProcessed then
			while UserInputService:IsKeyDown(Enum.KeyCode.H) do
				ControlRemote:FireServer("Right")
				wait(.1)
			end
		end
		if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
			while UserInputService:IsKeyDown(Enum.KeyCode.G) do
				ControlRemote:FireServer("Left")
				wait(.1)
			end
		end
		if input.KeyCode == Enum.KeyCode.Y and not gameProcessed then
			while UserInputService:IsKeyDown(Enum.KeyCode.Y) do
				ControlRemote:FireServer("Forward")
				wait(.1)
			end
		end
		if input.KeyCode == Enum.KeyCode.B and not gameProcessed then
			while UserInputService:IsKeyDown(Enum.KeyCode.B) do
				ControlRemote:FireServer("Backward")
				wait(.1)
			end
		end
	end
end

local function onInputEnded(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.M and not gameProcessed then
			mindtrickAnimationTrack:Stop()
			humanoid.WalkSpeed = 16
		end
	end
end

local function disableControls(changeType)
	local playerScripts = player:WaitForChild("PlayerScripts")
	local playerModule = require(playerScripts:WaitForChild("PlayerModule"))
	
	local Controls = playerModule:GetControls()
	
	if changeType == "Disable" then
		Controls:Disable()
	end
	if changeType == "Enable" then
		Controls:Enable()
	end
end

DisableControlsRemote.OnClientEvent:Connect(disableControls)
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)
