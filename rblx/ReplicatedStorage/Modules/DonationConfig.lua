--[[
	DonationConfig.lua
	Configuration module for Donation System with Fireworks
	
	INSTRUCTIONS:
	1. Create Developer Products in Roblox Creator Dashboard
	2. Create 4 products: Small, Medium, Large, Epic
	3. Copy each product ID
	4. Replace the ID values below with your actual product IDs
]]

return {
	PRODUCTS = {
		SMALL = {
			ID = 0, -- REPLACE WITH YOUR PRODUCT ID
			NAME = "Small Donation",
			PRICE = 25, -- Robux amount (informational, actual price set in dashboard)
			DURATION = 10,
			FIREWORKS_COUNT = 15,
			COLORS = {Color3.fromRGB(255, 100, 100), Color3.fromRGB(100, 100, 255)},
			SOUND_ID = "rbxassetid://9125644075" -- Celebration sound
		},
		MEDIUM = {
			ID = 0, -- REPLACE WITH YOUR PRODUCT ID
			NAME = "Medium Donation",
			PRICE = 50, -- Robux amount (informational, actual price set in dashboard)
			DURATION = 20,
			FIREWORKS_COUNT = 30,
			COLORS = {Color3.fromRGB(255, 200, 0), Color3.fromRGB(0, 255, 150)},
			SOUND_ID = "rbxassetid://9125644075"
		},
		LARGE = {
			ID = 0, -- REPLACE WITH YOUR PRODUCT ID
			NAME = "Large Donation",
			PRICE = 100, -- Robux amount (informational, actual price set in dashboard)
			DURATION = 30,
			FIREWORKS_COUNT = 50,
			COLORS = {Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255)},
			SOUND_ID = "rbxassetid://9125644075"
		},
		EPIC = {
			ID = 0, -- REPLACE WITH YOUR PRODUCT ID
			NAME = "Epic Donation",
			PRICE = 250, -- Robux amount (informational, actual price set in dashboard)
			DURATION = 60,
			FIREWORKS_COUNT = 100,
			COLORS = {
				Color3.fromRGB(255, 0, 0),
				Color3.fromRGB(0, 255, 0),
				Color3.fromRGB(0, 0, 255),
				Color3.fromRGB(255, 255, 0)
			},
			SOUND_ID = "rbxassetid://9125644075",
			SPECIAL_EFFECTS = true -- Hearts, stars, spiral patterns
		}
	},
	DISPLAY_HEIGHT = 200, -- Height above ground for fireworks
	NAME_DISPLAY_DURATION = 5, -- How long donor name stays on screen
	COOLDOWN = 2, -- Seconds between donations (prevents spam)
	FIREWORKS_SPAWN_RADIUS = 50, -- Radius around spawn point for firework positions
}

