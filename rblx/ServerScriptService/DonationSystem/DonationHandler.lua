--[[
	DonationHandler.lua
	Server-side donation system handler
	
	Features:
	- ProcessReceipt handler for all donation products
	- Triggers fireworks displays
	- Broadcasts donor names
	- Anti-spam protection
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Wait for modules
local DonationConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DonationConfig"))
local FireworksEngine = require(script.Parent:WaitForChild("FireworksEngine"))
local NameDisplayer = require(script.Parent:WaitForChild("NameDisplayer"))

-- Anti-spam tracking
local donationCooldowns = {}
local activeShows = 0

-- Get product config by ID
local function getProductConfig(productId)
	for donationType, config in pairs(DonationConfig.PRODUCTS) do
		if config.ID == productId then
			return donationType, config
		end
	end
	return nil, nil
end

-- Process receipt handler
MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		-- Player left before receipt processed
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	local productId = receiptInfo.ProductId
	local donationType, config = getProductConfig(productId)
	
	if not donationType or not config then
		warn("Unknown product ID:", productId)
		-- Still grant purchase to avoid issues
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
	
	-- Anti-spam check
	local lastDonationTime = donationCooldowns[player.UserId]
	if lastDonationTime and (tick() - lastDonationTime) < DonationConfig.COOLDOWN then
		warn("Donation spam detected for", player.Name)
		return Enum.ProductPurchaseDecision.PurchaseGranted -- Still grant, but don't process
	end
	
	-- Update cooldown
	donationCooldowns[player.UserId] = tick()
	
	-- Find spawn position (center of map or configured location)
	local spawnPosition = Workspace:FindFirstChild("FireworksSpawnZone")
	if spawnPosition and spawnPosition:IsA("BasePart") then
		spawnPosition = spawnPosition.Position + Vector3.new(0, DonationConfig.DISPLAY_HEIGHT, 0)
	else
		-- Default to center of workspace
		spawnPosition = Vector3.new(0, DonationConfig.DISPLAY_HEIGHT, 0)
	end
	
	-- Trigger fireworks show
	spawn(function()
		activeShows = activeShows + 1
		
		-- Display donor name
		NameDisplayer.ShowDonorName(player.DisplayName or player.Name, donationType)
		
		-- Start fireworks
		FireworksEngine.Show(
			config.DURATION,
			config.FIREWORKS_COUNT,
			config.COLORS,
			spawnPosition,
			config.SPECIAL_EFFECTS
		)
		
		-- Wait for show to complete
		wait(config.DURATION)
		activeShows = activeShows - 1
	end)
	
	-- Broadcast to clients (optional, for additional effects)
	local remoteEvent = ReplicatedStorage:FindFirstChild("RemoteEvents"):FindFirstChild("DonationTriggered")
	if remoteEvent then
		remoteEvent:FireAllClients(player.Name, donationType)
	end
	
	print(player.Name, "donated:", config.NAME, "(" .. donationType .. ")")
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

-- Clean up cooldowns when player leaves
Players.PlayerRemoving:Connect(function(player)
	donationCooldowns[player.UserId] = nil
end)

print("DonationHandler loaded successfully!")

