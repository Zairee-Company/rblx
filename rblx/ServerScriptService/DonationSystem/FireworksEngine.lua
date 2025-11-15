--[[
	FireworksEngine.lua
	ModuleScript for creating and managing firework displays
	
	Features:
	- Rocket fireworks
	- Burst explosions
	- Particle effects
	- Special shapes (hearts, stars, spirals)
]]

local FireworksEngine = {}

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Helper function to create particles
local function createParticleEmitter(part, color)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
	emitter.Lifetime = NumberRange.new(2, 4)
	emitter.Rate = 100
	emitter.Speed = NumberRange.new(20, 50)
	emitter.SpreadAngle = Vector2.new(45, 45)
	emitter.Color = ColorSequence.new(color)
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 2),
		NumberSequenceKeypoint.new(1, 0)
	})
	emitter.Acceleration = Vector3.new(0, -20, 0) -- Gravity
	emitter.Parent = part
	return emitter
end

-- Create a single rocket firework
function FireworksEngine.LaunchFirework(startPosition, targetHeight, color, delay)
	delay = delay or 0
	
	wait(delay)
	
	-- Create rocket
	local rocket = Instance.new("Part")
	rocket.Name = "FireworkRocket"
	rocket.Size = Vector3.new(0.2, 0.2, 1)
	rocket.Material = Enum.Material.Neon
	rocket.Color = color
	rocket.Anchored = true
	rocket.CanCollide = false
	rocket.Transparency = 0.5
	rocket.Position = startPosition
	rocket.Parent = workspace
	
	-- Trail effect
	local attachment = Instance.new("Attachment")
	attachment.Parent = rocket
	
	local trailParticles = Instance.new("ParticleEmitter")
	trailParticles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	trailParticles.Lifetime = NumberRange.new(0.5, 1)
	trailParticles.Rate = 50
	trailParticles.Speed = NumberRange.new(5, 10)
	trailParticles.Color = ColorSequence.new(color)
	trailParticles.Size = NumberSequence.new(0.5)
	trailParticles.Parent = attachment
	
	-- Launch animation
	local targetPosition = startPosition + Vector3.new(0, targetHeight, 0)
	local launchTime = targetHeight / 100 -- Approximate time based on height
	
	local tween = TweenService:Create(
		rocket,
		TweenInfo.new(launchTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Position = targetPosition}
	)
	
	tween:Play()
	
	-- Explode at peak
	tween.Completed:Wait()
	FireworksEngine.CreateExplosion(targetPosition, {color}, math.random(3, 5))
	rocket:Destroy()
end

-- Create explosion effect
function FireworksEngine.CreateExplosion(position, colors, intensity)
	intensity = intensity or 3
	
	-- Multiple burst particles
	for i = 1, intensity * 5 do
		local particle = Instance.new("Part")
		particle.Name = "FireworkBurst"
		particle.Size = Vector3.new(0.5, 0.5, 0.5)
		particle.Material = Enum.Material.Neon
		particle.Color = colors[math.random(1, #colors)]
		particle.Anchored = false
		particle.CanCollide = false
		particle.Position = position
		particle.Shape = Enum.PartType.Ball
		particle.Parent = workspace
		
		-- Random direction
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
		bodyVelocity.Velocity = Vector3.new(
			math.random(-50, 50),
			math.random(-50, 50),
			math.random(-50, 50)
		)
		bodyVelocity.Parent = particle
		
		-- Light effect
		local pointLight = Instance.new("PointLight")
		pointLight.Color = particle.Color
		pointLight.Brightness = 5
		pointLight.Range = 20
		pointLight.Parent = particle
		
		-- Particles
		local attachment = Instance.new("Attachment")
		attachment.Parent = particle
		createParticleEmitter(particle, particle.Color)
		
		-- Cleanup
		Debris:AddItem(particle, 3)
	end
	
	-- Sound effect
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9125644075" -- Celebration sound
	sound.Volume = 0.5
	sound.Parent = workspace
	sound:Play()
	Debris:AddItem(sound, 5)
	
	-- Large flash
	local flash = Instance.new("Part")
	flash.Name = "FireworkFlash"
	flash.Size = Vector3.new(10, 10, 10)
	flash.Material = Enum.Material.Neon
	flash.Color = Color3.new(1, 1, 1)
	flash.Anchored = true
	flash.CanCollide = false
	flash.Position = position
	flash.Shape = Enum.PartType.Ball
	flash.Transparency = 0.5
	flash.Parent = workspace
	
	local flashTween = TweenService:Create(
		flash,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{Size = Vector3.new(30, 30, 30), Transparency = 1}
	)
	flashTween:Play()
	flashTween.Completed:Connect(function()
		flash:Destroy()
	end)
end

-- Create fountain firework
function FireworksEngine.CreateFountain(position, colors, duration)
	duration = duration or 5
	
	local fountain = Instance.new("Part")
	fountain.Name = "FireworkFountain"
	fountain.Size = Vector3.new(2, 0.2, 2)
	fountain.Material = Enum.Material.Neon
	fountain.Color = colors[1]
	fountain.Anchored = true
	fountain.CanCollide = false
	fountain.Position = position
	fountain.Parent = workspace
	
	local attachment = Instance.new("Attachment")
	attachment.Position = Vector3.new(0, 0.1, 0)
	attachment.Parent = fountain
	
	local emitter = Instance.new("ParticleEmitter")
	emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Lifetime = NumberRange.new(1, 2)
	emitter.Rate = 200
	emitter.Speed = NumberRange.new(30, 60)
	emitter.SpreadAngle = Vector2.new(30, 30)
	emitter.Color = ColorSequence.new(colors)
	emitter.Acceleration = Vector3.new(0, -30, 0)
	emitter.EmissionDirection = Enum.NormalId.Top
	emitter.Parent = attachment
	
	Debris:AddItem(fountain, duration)
end

-- Create heart shape (for Epic donations)
function FireworksEngine.CreateHeartShape(center, color)
	local heartParts = {}
	
	-- Simple heart pattern using parts
	for i = 1, 20 do
		local angle = (i / 20) * math.pi * 2
		local x = math.cos(angle) * 5
		local y = math.sin(angle) * 5
		
		-- Heart equation approximation
		local heartX = x * math.sqrt(math.abs(x)) / math.sqrt(math.abs(x) + 1)
		local heartY = y * math.sqrt(math.abs(y)) / math.sqrt(math.abs(y) + 1)
		
		local part = Instance.new("Part")
		part.Size = Vector3.new(1, 1, 1)
		part.Material = Enum.Material.Neon
		part.Color = color
		part.Anchored = true
		part.CanCollide = false
		part.Position = center + Vector3.new(heartX * 2, heartY * 2, 0)
		part.Shape = Enum.PartType.Ball
		part.Parent = workspace
		
		table.insert(heartParts, part)
		
		Debris:AddItem(part, 3)
	end
	
	wait(1)
	FireworksEngine.CreateExplosion(center, {color}, 5)
end

-- Main fireworks show
function FireworksEngine.Show(duration, fireworkCount, colors, spawnPosition, specialEffects)
	duration = duration or 10
	fireworkCount = fireworkCount or 20
	colors = colors or {Color3.fromRGB(255, 100, 100)}
	specialEffects = specialEffects or false
	
	local endTime = tick() + duration
	local fireworkInterval = duration / fireworkCount
	
	spawn(function()
		while tick() < endTime do
			-- Random position around spawn
			local offset = Vector3.new(
				math.random(-30, 30),
				0,
				math.random(-30, 30)
			)
			local fireworkPosition = spawnPosition + offset
			local height = math.random(50, 100)
			local color = colors[math.random(1, #colors)]
			
			FireworksEngine.LaunchFirework(fireworkPosition, height, color, 0)
			
			-- Special effects for Epic donations
			if specialEffects and math.random() < 0.3 then
				wait(0.5)
				FireworksEngine.CreateFountain(fireworkPosition, colors, 2)
				
				if math.random() < 0.1 then
					FireworksEngine.CreateHeartShape(fireworkPosition + Vector3.new(0, height, 0), color)
				end
			end
			
			wait(fireworkInterval)
		end
	end)
end

return FireworksEngine

