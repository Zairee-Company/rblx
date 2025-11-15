--[[
	GamepassConfig.lua
	Configuration module for VIP Gamepass system
	
	INSTRUCTIONS:
	1. Create a gamepass in Roblox Creator Dashboard
	2. Copy the gamepass ID
	3. Replace VIP_GAMEPASS_ID below with your actual gamepass ID
	4. Update PRICE_ROBUX if needed (informational only)
]]

return {
	VIP_GAMEPASS_ID = 0, -- REPLACE WITH YOUR GAMEPASS ID from Creator Dashboard
	VIP_ROOM_BENEFITS = {
		"Exclusive lounge area",
		"Special avatar items",
		"Priority server access",
		"Unique badge"
	},
	PRICE_ROBUX = 100, -- Informational only, actual price set in dashboard
	VIP_ROOM_ENTRY_POSITION = Vector3.new(0, 50, 0), -- Default position, update in workspace
}

