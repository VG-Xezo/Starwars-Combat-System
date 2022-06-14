local ForcePullRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("PullPlayer")
local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local Players = game:GetService("Players")

local MoveCost = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ForcePullMove.MoveCost
local ForceDamage = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ForcePullMove.MoveDamage

function handleLaunch(playerFired, characterToLaunch)
	if characterToLaunch then
		local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
		if playerStamina.Value >= MoveCost.Value then
			local Humanoid = characterToLaunch:FindFirstChild("Humanoid")
			if Humanoid then
				local RootPart = characterToLaunch:FindFirstChild("HumanoidRootPart")
				local humanoidLookVector = playerFired.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector
				local magnitude = 50
				local fling = ((humanoidLookVector * -1) + Vector3.new(0,2,0) ) * magnitude
				characterToLaunch:FindFirstChild("Humanoid").Sit = true
				playerStamina.Value = playerStamina.Value - MoveCost.Value
				Humanoid.Health = Humanoid.Health - ForceDamage.Value
				RootPart.Velocity = fling
			end
		end
	end
end

ForcePullRemote.OnServerEvent:Connect(handleLaunch)
