local staminaFolder = game:GetService("ReplicatedStorage").Staminas
local Players = game:GetService("Players")

local MindTrickRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("MindtrickPlayer")
local ControlPlayerRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("ControlPlayer")
local DisableControlsRemote = game:GetService("ReplicatedStorage").RemoteEvents:WaitForChild("DisableControls")

local MoveCost = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").MindtrickMove.MoveCost
local MoveLength = game:GetService("ReplicatedStorage"):WaitForChild("ConfigureHere").MindtrickMove.MoveLength

-- {player.Name, character, interger}
-- {"CONTROLLER", "CONTROLLED", "TIME CONTROLLED"}

local playersControlled = {}

local gradualDamage = function()
	while true do
		if #playersControlled > 0 then
			for i, playerToUpdate in pairs(playersControlled) do
				local Humanoid = playerToUpdate[2]:FindFirstChild("Humanoid")
				playerToUpdate[3] = playerToUpdate[3] + 1
				
				local playerControlled = game:GetService("Players"):GetPlayerFromCharacter(playerToUpdate[2])
				
				if playerControlled ~= nil then
					DisableControlsRemote:FireClient(playerControlled, "Disable")
				end
				
				if playerToUpdate[3] >= MoveLength.Value then
					table.remove(playersControlled, i)
					if playerControlled ~= nil then
						DisableControlsRemote:FireClient(playerControlled, "Enable")
					end
				end

				wait()
			end
		end
		wait(1)
	end
end

local Thread = coroutine.wrap(gradualDamage)
Thread()

function newControlledPlayer(playerFired, controlledPlayer)
	local isPlayerControlling = false
	for i, v in pairs(playersControlled) do
		if table.find(v, playerFired.Name) then
			isPlayerControlling = true
		end
	end
	
	if isPlayerControlling then
		return
	end
	local newControlledTable = {}
	table.insert(newControlledTable, playerFired.Name)
	table.insert(newControlledTable, controlledPlayer)
	table.insert(newControlledTable, 0)
	table.insert(playersControlled, newControlledTable)
end

function controlPlayer(playerFired, controlledCharacter, inputType)
	local Humanoid = controlledCharacter:FindFirstChild("Humanoid")
	local RootPart = controlledCharacter:FindFirstChild("HumanoidRootPart")
	if Humanoid then
		if inputType == "Right" then
			local newPosition = RootPart.Position + Vector3.new(4,0,0)
			Humanoid:MoveTo(newPosition)
		end
		if inputType == "Left" then
			local newPosition = RootPart.Position + Vector3.new(-4,0,0)
			Humanoid:MoveTo(newPosition)
		end
		if inputType == "Forward" then
			local newPosition = RootPart.Position + Vector3.new(0,0,4)
			Humanoid:MoveTo(newPosition)
		end
		if inputType == "Backward" then
			local newPosition = RootPart.Position + Vector3.new(0,0,-4)
			Humanoid:MoveTo(newPosition)
		end
	end
end

function handleMindTrick(playerFired, controlledPlayer)
	if playerFired then
		local playerStamina = staminaFolder:FindFirstChild(playerFired.UserId)
		if playerStamina.Value >= MoveCost.Value then
			playerStamina.Value = playerStamina.Value - MoveCost.Value
			newControlledPlayer(playerFired, controlledPlayer)
		end
	end
end

function handleControlPlayer(playerFired, inputType)
	local isPlayerControlling = false
	local controlledCharacter
	for i, v in pairs(playersControlled) do
		if table.find(v, playerFired.Name) then
			isPlayerControlling = true
			controlledCharacter = v[2]
		end
	end

	if isPlayerControlling then
		controlPlayer(playerFired, controlledCharacter, inputType)
	end

end

MindTrickRemote.OnServerEvent:Connect(handleMindTrick)
ControlPlayerRemote.OnServerEvent:Connect(handleControlPlayer)

