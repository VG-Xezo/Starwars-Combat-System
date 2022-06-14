local Players = game:GetService("Players")
local HealRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("HealPlayer")
local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local healVfx = game:GetService("ServerStorage").VFX:WaitForChild("Force Heal 2")
local MoveCost = game:GetService("ReplicatedStorage").ConfigureHere.HealMove.MoveCost
local HealAmount = game:GetService("ReplicatedStorage").ConfigureHere.HealMove.HealAmount

function handleHeal(playerFired, characterToHeal)
	local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
	if playerStamina.Value >= MoveCost.Value then
		
		local characterHumanoid = characterToHeal:FindFirstChild("Humanoid")
		if characterHumanoid then
			if characterHumanoid.MaxHealth > characterHumanoid.Health then
				playerStamina.Value = playerStamina.Value - MoveCost.Value
				characterHumanoid.Health += HealAmount.Value
			end
		end
	end
end

function addHealVfx(player)
	local clonesThings = healVfx.Torso
	local Character = player.Character or player.CharacterAdded:Wait()
	
	for _, vfxPart in pairs(clonesThings:GetChildren()) do
		local newVfxPart = vfxPart:Clone()
		newVfxPart.Name = "HealingAttachment"
		local UpperTorso = Character:FindFirstChild("UpperTorso")
		local Torso = Character:FindFirstChild("Torso")

		if UpperTorso then
			newVfxPart.Parent = UpperTorso
		elseif Torso then
			newVfxPart.Parent = Torso
		end
	end
end

Players.PlayerAdded:Connect(addHealVfx)
HealRemote.OnServerEvent:Connect(handleHeal)
