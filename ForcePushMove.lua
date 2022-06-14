local ForcePushRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("LaunchPlayer")
local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local Players = game:GetService("Players")

local MoveCost = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ForcePushMove.MoveCost
local ForceDamage = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ForcePushMove.MoveDamage

function handleLaunch(playerFired, characterToLaunch)
	if characterToLaunch then
		local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
		if playerStamina.Value >= MoveCost.Value then
			local Humanoid = characterToLaunch:FindFirstChild("Humanoid")
			if Humanoid then
				local RootPart = characterToLaunch:FindFirstChild("HumanoidRootPart")
				local humanoidLookVector = playerFired.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector
				local magnitude = 50
				local fling = (humanoidLookVector + Vector3.new(0,2,0) ) * magnitude
				characterToLaunch:FindFirstChild("Humanoid").Sit = true
				Humanoid:ChangeState(1)
				playerStamina.Value = playerStamina.Value - MoveCost.Value
				Humanoid.Health = Humanoid.Health - ForceDamage.Value
				RootPart.Velocity = fling
			end
		end
	end
end

ForcePushRemote.OnServerEvent:Connect(handleLaunch)
