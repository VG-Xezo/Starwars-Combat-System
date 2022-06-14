local LightningRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("LightningPlayer")
local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local Players = game:GetService("Players")

local MoveCost = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").LightningMove.MoveCost
local ForceDamage = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").LightningMove.MoveDamage
local MoveRange = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").LightningMove.MoveRange

local lightningVfx = game:GetService("ServerStorage").VFX:WaitForChild("LightningVFX")

local playersDamaging = {}

local gradualDamage = function()
	while true do
		if #playersDamaging > 0 then
			for i, playerToDamage in pairs(playersDamaging) do

				local playerName = playerToDamage[1]
				local player = game.Workspace:FindFirstChild(playerName)

				local Humanoid = player:FindFirstChild("Humanoid")
				local PlayerTorso = player:FindFirstChild("UpperTorso")
				
				playerToDamage[2] = playerToDamage[2] + 1
				Humanoid.Health = Humanoid.Health - ForceDamage.Value
				PlayerTorso:FindFirstChild("LightningVFX").Enabled = true
				if playerToDamage[2] >= 5 then
					table.remove(playersDamaging, i)
					PlayerTorso:FindFirstChild("LightningVFX").Enabled = false
				end

				wait()
			end
		end
		wait(2)
	end
end

local Thread = coroutine.wrap(gradualDamage)
Thread()

function lightningMove(playerFired)
	local Character = playerFired.Character
	local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
	wait(.25)
	for _, player in pairs(game.Workspace:GetChildren()) do
		local Humanoid = player:FindFirstChild("Humanoid")		
		if player.Name ~= playerFired.Name then
			if Humanoid then
				local CharacterTorso = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso")
				local PlayerTorso = player:FindFirstChild("UpperTorso") or player:FindFirstChild("Torso")
				local CharacterHand = Character:FindFirstChild("LeftHand") or Character:FindFirstChild("Left Arm")
				if CharacterTorso and PlayerTorso then
					if (CharacterTorso.Position - PlayerTorso.Position).magnitude < MoveRange.Value then
						local startPosition = CharacterHand.Position
						local endPosition = PlayerTorso.Position
						
						local SHOT_DURATION = 0.25

						local laserDistance = (startPosition - endPosition).Magnitude
						local laserCFrame = CFrame.lookAt(startPosition, endPosition) * CFrame.new(0, 0, -laserDistance / 2)

						local laserPart = Instance.new("Part")
						laserPart.Size = Vector3.new(0.2, 0.2, laserDistance)
						laserPart.CFrame  = laserCFrame
						laserPart.Anchored = true
						laserPart.CanCollide = false
						laserPart.Color = Color3.fromRGB(0, 255, 255)
						laserPart.Material = Enum.Material.Neon
						laserPart.Parent = workspace

						-- Add laser beam to the Debris service to be removed & cleaned up
						game.Debris:AddItem(laserPart, SHOT_DURATION)
						
						Humanoid:ChangeState(1)
						local foundPlayer = false
						for i, v in pairs(playersDamaging) do
							if table.find(v, player.Name) then
								foundPlayer = true
							end
						end
						
						if foundPlayer then
							Humanoid.Health = Humanoid.Health - ForceDamage.Value
						else
							local newPlayerTable = {}
							table.insert(newPlayerTable, player.Name)
							table.insert(newPlayerTable, 0)
							table.insert(playersDamaging, newPlayerTable)
						end
						
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
			playerStamina.Value = playerStamina.Value - MoveCost.Value
			lightningMove(playerFired)
		end
	end
end

function addLightningVfx(player)
	local clonedLightningVFX = lightningVfx:Clone()
	local Character = player.Character or player.CharacterAdded:Wait()
	
	local UpperTorso = Character:FindFirstChild("UpperTorso")
	local Torso = Character:FindFirstChild("Torso")
	
	if UpperTorso then
		clonedLightningVFX.Parent = UpperTorso
	end
	if Torso then
		clonedLightningVFX.Parent = Torso
	end
end

Players.PlayerAdded:Connect(addLightningVfx)
LightningRemote.OnServerEvent:Connect(handleLaunch)
