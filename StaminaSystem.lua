local Players = game:GetService("Players")
local StaminaFolder = game:GetService("ReplicatedStorage").Staminas
local maxStamina = game:GetService("ReplicatedStorage").ConfigureHere.StaminaSystem.MaxStamina
local regenAmount = game:GetService("ReplicatedStorage").ConfigureHere.StaminaSystem.RegenAmount
local regenTime = game:GetService("ReplicatedStorage").ConfigureHere.StaminaSystem.RegenTime

local regenStaminaFunc = function()
	while true do
		for _, stamina in pairs(StaminaFolder:GetChildren()) do
			if stamina.Value < maxStamina.Value then
				local newAmount = stamina.Value + regenAmount.Value
				if newAmount >= maxStamina.Value then
					stamina.Value = maxStamina.Value
				else
					stamina.Value += regenAmount.Value
				end
			end
			wait()
		end
		wait(regenTime.Value)
	end
end

local Thread = coroutine.wrap(regenStaminaFunc);
Thread()

function playerAdded(player)
	local newStaminaValue = Instance.new("IntValue")
	newStaminaValue.Value = maxStamina.Value
	newStaminaValue.Name = player.UserId
	newStaminaValue.Parent = StaminaFolder
end

function playerLeave(player)
	StaminaFolder:FindFirstChild(player.UserId):Destroy()
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerLeave)
