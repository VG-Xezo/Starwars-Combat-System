local ShockwaveRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("ShockwavePlayer")
local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local Players = game:GetService("Players")

local MoveCost = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ShockwaveMove.MoveCost
local ForceDamage = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ShockwaveMove.MoveDamage
local MoveRange = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").ShockwaveMove.MoveRange

function shockwaveMove(playerFired)
	local Character = playerFired.Character
	local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
	for _, player in pairs(game.Workspace:GetChildren()) do
		local Humanoid = player:FindFirstChild("Humanoid")		
		if player.Name ~= playerFired.Name then
			if Humanoid then
				local CharacterTorso = Character:FindFirstChild("UpperTorso")
				local PlayerTorso = player:FindFirstChild("UpperTorso")
				if CharacterTorso and PlayerTorso then
					if (CharacterTorso.Position - PlayerTorso.Position).magnitude < MoveRange.Value then
						local humanoidLookVector = playerFired.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector
						local PlayerRootPart = player:FindFirstChild("HumanoidRootPart")
						local magnitude = 4
						local fling = (PlayerTorso.Position - CharacterTorso.Position) * magnitude
						player:FindFirstChild("Humanoid").Sit = true
						Humanoid:ChangeState(1)
						Humanoid.Health = Humanoid.Health - ForceDamage.Value
						PlayerRootPart.Velocity = fling
					end	
				end
			end
		end
	end
end

function handleLaunch(playerFired)
	if playerFired then
		local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
		if playerStamina.Value >= MoveCost.Value then
			shockwaveMove(playerFired)
			playerStamina.Value = playerStamina.Value - MoveCost.Value
		end
	end
end

ShockwaveRemote.OnServerEvent:Connect(handleLaunch)
