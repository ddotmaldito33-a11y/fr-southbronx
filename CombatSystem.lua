-- Combat System Module
-- Handles all combat mechanics including melee, blocking, and special moves

local CombatSystem = {}
CombatSystem.__index = CombatSystem

local CONFIG = {
	PUNCH_DAMAGE = 25,
	KICK_DAMAGE = 35,
	COMBO_WINDOW = 0.8,
	BLOCK_COOLDOWN = 0.3,
	SPECIAL_COOLDOWN = 5,
}

function CombatSystem.new(character, humanoid)
	local self = setmetatable({}, CombatSystem)
	
	self.character = character
	self.humanoid = humanoid
	self.rootPart = character:WaitForChild("HumanoidRootPart")
	self.lastAttackTime = 0
	self.comboCount = 0
	self.isBlocking = false
	self.lastSpecialTime = 0
	
	return self
end

function CombatSystem:punch(targetHumanoid)
	local currentTime = tick()
	
	if currentTime - self.lastAttackTime < 0.5 then
		return false
	end
	
	self.lastAttackTime = currentTime
	self.comboCount = self.comboCount + 1
	
	local damage = CONFIG.PUNCH_DAMAGE + (self.comboCount * 5)
	targetHumanoid:TakeDamage(damage)
	
	print("Punch! Combo: " .. self.comboCount .. " - Damage: " .. damage)
	
	-- Reset combo after window
	task.wait(CONFIG.COMBO_WINDOW)
	if tick() - currentTime > CONFIG.COMBO_WINDOW then
		self.comboCount = 0
	end
	
	return true
end

function CombatSystem:kick(targetHumanoid, targetRootPart)
	local currentTime = tick()
	
	if currentTime - self.lastAttackTime < 0.5 then
		return false
	end
	
	self.lastAttackTime = currentTime
	targetHumanoid:TakeDamage(CONFIG.KICK_DAMAGE)
	
	-- Knockback effect
	local direction = (targetRootPart.Position - self.rootPart.Position).Unit
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * 50
	bodyVelocity.Parent = targetRootPart
	
	game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
	
	print("Kick! Damage: " .. CONFIG.KICK_DAMAGE)
	return true
end

function CombatSystem:block()
	if self.isBlocking then return false end
	
	self.isBlocking = true
	self.humanoid.WalkSpeed = 8
	
	task.wait(CONFIG.BLOCK_COOLDOWN)
	self.isBlocking = false
	self.humanoid.WalkSpeed = 16
	
	return true
end

function CombatSystem:specialMove(targetHumanoid, targetRootPart)
	local currentTime = tick()
	
	if currentTime - self.lastSpecialTime < CONFIG.SPECIAL_COOLDOWN then
		return false
	end
	
	self.lastSpecialTime = currentTime
	targetHumanoid:TakeDamage(50)
	
	-- Stun effect
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = targetRootPart
	
	game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
	
	print("Special Move! Heavy Damage: 50")
	return true
end

function CombatSystem:resetCombo()
	self.comboCount = 0
end

return CombatSystem
