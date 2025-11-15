--[[
	VIPAccessManager.lua
	Server-side VIP access control system
	
	Features:
	- Gamepass ownership verification
	- VIP room entry control
	- Purchase prompts
	- Teleportation to VIP room
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for configuration
local GamepassConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GamepassConfig"))

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local checkVIPAccessEvent = remoteEventsFolder:WaitForChild("CheckVIPAccess")
local requestVIPEntryEvent = remoteEventsFolder:WaitForChild("RequestVIPEntry")

-- VIP access cache (refreshed periodically)
local vipCache = {}

-- Functions
local function checkPlayerHasGamepass(player, gamepassId)
	-- Check cache first (with timestamp)
	if vipCache[player.UserId] then
		local cacheData = vipCache[player.UserId]
		-- Cache valid for 60 seconds
		if os.time() - cacheData.timestamp < 60 then
			return cacheData.hasGamepass
		end
	end
	
	-- Verify gamepass ownership
	local success, hasGamepass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
	end)
	
	if not success then
		warn("Failed to check gamepass ownership for", player.Name, ":", hasGamepass)
		return false
	end
	
	-- Update cache
	vipCache[player.UserId] = {
		hasGamepass = hasGamepass,
		timestamp = os.time()
	}
	
	return hasGamepass
end

local function grantVIPAccess(player)
	-- Find VIP room entrance
	local vipRoom = workspace:FindFirstChild("VIPRoom")
	if not vipRoom then
		warn("VIPRoom not found in workspace!")
		return false
	end
	
	local entryPoint = vipRoom:FindFirstChild("EntryPoint")
	local entryPosition = GamepassConfig.VIP_ROOM_ENTRY_POSITION
	
	if entryPoint then
		entryPosition = entryPoint.Position
	elseif vipRoom:IsA("Model") and vipRoom.PrimaryPart then
		entryPosition = vipRoom.PrimaryPart.Position
	elseif vipRoom:IsA("BasePart") then
		entryPosition = vipRoom.Position
	end
	
	-- Teleport player
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(entryPosition + Vector3.new(0, 5, 0))
		
		-- Optional: Welcome message
		player:SetAttribute("IsVIP", true)
		
		return true
	end
	
	return false
end

local function promptVIPPurchase(player)
	-- Open purchase prompt on client
	local success, error = pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, GamepassConfig.VIP_GAMEPASS_ID)
	end)
	
	if not success then
		warn("Failed to prompt gamepass purchase for", player.Name, ":", error)
	end
end

-- Handle VIP access check
checkVIPAccessEvent.OnServerEvent:Connect(function(player)
	local hasAccess = checkPlayerHasGamepass(player, GamepassConfig.VIP_GAMEPASS_ID)
	checkVIPAccessEvent:FireClient(player, hasAccess)
end)

-- Handle VIP entry request
requestVIPEntryEvent.OnServerEvent:Connect(function(player)
	-- Always verify server-side (security)
	local hasAccess = checkPlayerHasGamepass(player, GamepassConfig.VIP_GAMEPASS_ID)
	
	if hasAccess then
		-- Grant access and teleport
		local success = grantVIPAccess(player)
		if success then
			requestVIPEntryEvent:FireClient(player, true, "Welcome to the VIP Room!")
		else
			requestVIPEntryEvent:FireClient(player, false, "Failed to access VIP room. Please try again.")
		end
	else
		-- Prompt purchase
		promptVIPPurchase(player)
		requestVIPEntryEvent:FireClient(player, false, "VIP Gamepass required for access!")
	end
end)

-- Handle gamepass purchase
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, wasPurchased)
	if gamepassId == GamepassConfig.VIP_GAMEPASS_ID and wasPurchased then
		-- Clear cache
		vipCache[player.UserId] = nil
		
		-- Verify purchase
		local hasAccess = checkPlayerHasGamepass(player, gamepassId)
		
		if hasAccess then
			-- Auto-grant access after purchase
			grantVIPAccess(player)
			-- Notify player
			local gui = Instance.new("ScreenGui")
			gui.Name = "VIPWelcomeGui"
			gui.ResetOnSpawn = false
			gui.Parent = player:WaitForChild("PlayerGui")
			
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 300, 0, 100)
			frame.Position = UDim2.new(0.5, -150, 0.2, 0)
			frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
			frame.BorderSizePixel = 0
			frame.Parent = gui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame
			
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = "Welcome VIP! You can now access the VIP Room!"
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextSize = 18
			label.Font = Enum.Font.GothamBold
			label.TextWrapped = true
			label.Parent = frame
			
			wait(5)
			gui:Destroy()
		end
	end
end)

-- Clear cache when player leaves
Players.PlayerRemoving:Connect(function(player)
	vipCache[player.UserId] = nil
end)

-- Periodic cache refresh for active players (every 5 minutes)
spawn(function()
	while true do
		wait(300) -- 5 minutes
		
		for _, player in ipairs(Players:GetPlayers()) do
			-- Refresh cache
			checkPlayerHasGamepass(player, GamepassConfig.VIP_GAMEPASS_ID)
		end
	end
end)

print("VIPAccessManager loaded successfully!")

