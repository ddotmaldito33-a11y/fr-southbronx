-- South Bronx: The Trenches - Roblox Game Script
-- This script provides core functionality for a street-themed Roblox game

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- =====================
-- CONFIGURATION
-- =====================
local CONFIG = {
	WALK_SPEED = 16,
	SPRINT_SPEED = 25,
	STAMINA_MAX = 100,
	STAMINA_DRAIN_RATE = 15,
	STAMINA_REGEN_RATE = 10,
	MELEE_DAMAGE = 25,
	MELEE_RANGE = 5,
	MELEE_COOLDOWN = 0.5,
}

-- =====================
-- PLAYER INITIALIZATION
-- =====================
local function initializePlayer(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	-- Create player data
	local playerData = {
		stamina = CONFIG.STAMINA_MAX,
		isSprinting = false,
		lastMeleeTime = 0,
		health = humanoid.Health,
	}
	
	-- Store player data
	local folder = Instance.new("Folder")
	folder.Name = "PlayerData"
	folder.Parent = character
	
	local staminaValue = Instance.new("NumberValue")
	staminaValue.Name = "Stamina"
	staminaValue.Value = CONFIG.STAMINA_MAX
	staminaValue.Parent = folder
	
	-- Setup humanoid
	humanoid.MaxHealth = 100
	humanoid.Health = 100
	
	return character, humanoid, rootPart, playerData, staminaValue
end

-- =====================
-- SPRINT SYSTEM
-- =====================
local function setupSprintSystem(character, humanoid, playerData, staminaValue)
	local isSprinting = false
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.LeftShift then
			isSprinting = true
			playerData.isSprinting = true
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			isSprinting = false
			playerData.isSprinting = false
		end
	end)
	
	-- Sprint loop
	local sprintConnection
	sprintConnection = RunService.Heartbeat:Connect(function(deltaTime)
		if not character.Parent then
			sprintConnection:Disconnect()
			return
		end
		
		if isSprinting and staminaValue.Value > 0 then
			humanoid.WalkSpeed = CONFIG.SPRINT_SPEED
			staminaValue.Value = math.max(0, staminaValue.Value - CONFIG.STAMINA_DRAIN_RATE * deltaTime)
		else
			humanoid.WalkSpeed = CONFIG.WALK_SPEED
			if staminaValue.Value < CONFIG.STAMINA_MAX then
				staminaValue.Value = math.min(CONFIG.STAMINA_MAX, staminaValue.Value + CONFIG.STAMINA_REGEN_RATE * deltaTime)
			end
		end
	end)
end

-- =====================
-- MELEE COMBAT SYSTEM
-- =====================
local function setupMeleeSystem(character, humanoid, playerData)
	local lastMeleeTime = 0
	
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		
		if input.KeyCode == Enum.KeyCode.E then
			local currentTime = tick()
			if currentTime - lastMeleeTime >= CONFIG.MELEE_COOLDOWN then
				performMelee(character)
				lastMeleeTime = currentTime
			end
		end
	end)
end

function performMelee(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	
	-- Create hit region
	local region = Region3.new(rootPart.Position - Vector3.new(CONFIG.MELEE_RANGE, CONFIG.MELEE_RANGE, CONFIG.MELEE_RANGE), 
		rootPart.Position + Vector3.new(CONFIG.MELEE_RANGE, CONFIG.MELEE_RANGE, CONFIG.MELEE_RANGE))
	region = region:ExpandToGrid(4)
	
	-- Find targets in range
	for _, part in pairs(workspace:FindPartBoundsInRadius(rootPart.Position, CONFIG.MELEE_RANGE)) do
		if part.Parent:FindFirstChild("Humanoid") and part.Parent ~= character then
			local targetHumanoid = part.Parent:FindFirstChild("Humanoid")
			if targetHumanoid then
				targetHumanoid:TakeDamage(CONFIG.MELEE_DAMAGE)
				print("Hit: " .. part.Parent.Name .. " for " .. CONFIG.MELEE_DAMAGE .. " damage")
			end
		end
	end
	
	-- Play animation or effect here
	playMeleeEffect(character)
end

function playMeleeEffect(character)
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	-- Create a visual effect
	local effect = Instance.new("Part")
	effect.Shape = Enum.PartType.Ball
	effect.Size = Vector3.new(1, 1, 1)
	effect.Color = Color3.fromRGB(255, 50, 50)
	effect.Material = Enum.Material.Neon
	effect.CanCollide = false
	effect.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 5
	effect.Parent = workspace
	
	game:GetService("Debris"):AddItem(effect, 0.2)
end

-- =====================
-- DAMAGE SYSTEM
-- =====================
local function setupDamageSystem(character, humanoid)
	local lastDamageTime = 0
	local damageDebounce = 0.5
	
	humanoid.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= character then
			local currentTime = tick()
			if currentTime - lastDamageTime >= damageDebounce then
				humanoid:TakeDamage(10)
				lastDamageTime = currentTime
			end
		end
	end)
end

-- =====================
-- MAIN PLAYER SETUP
-- =====================
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local character, humanoid, rootPart, playerData, staminaValue = initializePlayer(player)
		setupSprintSystem(character, humanoid, playerData, staminaValue)
		setupMeleeSystem(character, playerData)
		setupDamageSystem(character, humanoid)
		
		print(player.Name .. " has spawned in South Bronx: The Trenches")
	end)
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
	if player.Character then
		local character, humanoid, rootPart, playerData, staminaValue = initializePlayer(player)
		setupSprintSystem(player.Character, humanoid, playerData, staminaValue)
		setupMeleeSystem(player.Character, playerData)
		setupDamageSystem(player.Character, humanoid)
	end
end

-- =====================
-- RESPAWN SYSTEM
-- =====================
Players.PlayerRemoving:Connect(function(player)
	print(player.Name .. " has left South Bronx: The Trenches")
end)

print("South Bronx: The Trenches - Game Script Loaded!")
