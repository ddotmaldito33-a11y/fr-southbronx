-- Character Controller Module
-- Handles player movement, animations, and character interactions

local CharacterController = {}
CharacterController.__index = CharacterController

function CharacterController.new(character)
	local self = setmetatable({}, CharacterController)
	
	self.character = character
	self.humanoid = character:WaitForChild("Humanoid")
	self.rootPart = character:WaitForChild("HumanoidRootPart")
	self.isMoving = false
	self.currentAnimation = nil
	
	return self
end

function CharacterController:playAnimation(animationId, speed)
	speed = speed or 1
	
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId
	
	local animator = self.humanoid:FindFirstChild("Animator") or Instance.new("Animator", self.humanoid)
	self.currentAnimation = animator:LoadAnimation(animation)
	self.currentAnimation:Play()
	self.currentAnimation:AdjustSpeed(speed)
	
	return self.currentAnimation
end

function CharacterController:stopAnimation()
	if self.currentAnimation then
		self.currentAnimation:Stop()
		self.currentAnimation = nil
	end
end

function CharacterController:setMovementSpeed(speed)
	self.humanoid.WalkSpeed = speed
end

function CharacterController:knockBack(direction, force)
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Velocity = direction * force
	bodyVelocity.Parent = self.rootPart
	
	game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
end

return CharacterController
