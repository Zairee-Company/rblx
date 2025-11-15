--[[
	VIPPurchaseGui.lua
	LocalScript that handles VIP purchase GUI
	
	This creates the GUI elements programmatically
	Alternatively, you can create this GUI in Roblox Studio
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for configuration
local GamepassConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GamepassConfig"))

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local requestVIPEntryEvent = remoteEventsFolder:WaitForChild("RequestVIPEntry")
local checkVIPAccessEvent = remoteEventsFolder:WaitForChild("CheckVIPAccess")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VIPPurchaseGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 100)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "⭐ VIP ACCESS REQUIRED ⭐"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextWrapped = true
title.Parent = mainFrame

-- Benefits list
local benefitsLabel = Instance.new("TextLabel")
benefitsLabel.Name = "BenefitsLabel"
benefitsLabel.Size = UDim2.new(1, -40, 0, 150)
benefitsLabel.Position = UDim2.new(0, 20, 0, 70)
benefitsLabel.BackgroundTransparency = 1
benefitsLabel.Text = "VIP Benefits:\n"
benefitsLabel.TextColor3 = Color3.new(1, 1, 1)
benefitsLabel.TextSize = 16
benefitsLabel.Font = Enum.Font.Gotham
benefitsLabel.TextXAlignment = Enum.TextXAlignment.Left
benefitsLabel.TextYAlignment = Enum.TextYAlignment.Top
benefitsLabel.TextWrapped = true
benefitsLabel.Parent = mainFrame

-- Build benefits text
local benefitsText = "VIP Benefits:\n"
for i, benefit in ipairs(GamepassConfig.VIP_ROOM_BENEFITS) do
	benefitsText = benefitsText .. "✓ " .. benefit .. "\n"
end
benefitsLabel.Text = benefitsText

-- Price label
local priceLabel = Instance.new("TextLabel")
priceLabel.Name = "PriceLabel"
priceLabel.Size = UDim2.new(1, -40, 0, 40)
priceLabel.Position = UDim2.new(0, 20, 0, 230)
priceLabel.BackgroundTransparency = 1
priceLabel.Text = "Price: " .. tostring(GamepassConfig.PRICE_ROBUX) .. " Robux"
priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
priceLabel.TextSize = 24
priceLabel.Font = Enum.Font.GothamBold
priceLabel.Parent = mainFrame

-- Buttons
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -40, 0, 50)
buttonsFrame.Position = UDim2.new(0, 20, 1, -70)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local buttonsLayout = Instance.new("UIListLayout")
buttonsLayout.FillDirection = Enum.FillDirection.Horizontal
buttonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonsLayout.Padding = UDim.new(0, 10)
buttonsLayout.Parent = buttonsFrame

-- Purchase button
local purchaseButton = Instance.new("TextButton")
purchaseButton.Name = "PurchaseButton"
purchaseButton.Size = UDim2.new(0, 180, 1, 0)
purchaseButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
purchaseButton.Text = "Purchase Gamepass"
purchaseButton.TextColor3 = Color3.new(1, 1, 1)
purchaseButton.TextSize = 18
purchaseButton.Font = Enum.Font.GothamBold
purchaseButton.BorderSizePixel = 0
purchaseButton.Parent = buttonsFrame

local purchaseCorner = Instance.new("UICorner")
purchaseCorner.CornerRadius = UDim.new(0, 8)
purchaseCorner.Parent = purchaseButton

-- Cancel button
local cancelButton = Instance.new("TextButton")
cancelButton.Name = "CancelButton"
cancelButton.Size = UDim2.new(0, 180, 1, 0)
cancelButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
cancelButton.Text = "Cancel"
cancelButton.TextColor3 = Color3.new(1, 1, 1)
cancelButton.TextSize = 18
cancelButton.Font = Enum.Font.GothamBold
cancelButton.BorderSizePixel = 0
cancelButton.Parent = buttonsFrame

local cancelCorner = Instance.new("UICorner")
cancelCorner.CornerRadius = UDim.new(0, 8)
cancelCorner.Parent = cancelButton

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.new(0, 1, 0)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Visible = false
statusLabel.Parent = mainFrame

-- Functions
local function showGUI()
	screenGui.Parent = playerGui
	mainFrame.Visible = true
	
	-- Animate in
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 450, 0, 400)}
	)
	tween:Play()
end

local function hideGUI()
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.new(0, 0, 0, 0)}
	)
	tween:Play()
	tween.Completed:Wait()
	mainFrame.Visible = false
end

local function showStatus(message, color)
	color = color or Color3.new(0, 1, 0)
	statusLabel.Text = message
	statusLabel.TextColor3 = color
	statusLabel.Visible = true
end

-- Purchase handler
purchaseButton.MouseButton1Click:Connect(function()
	showStatus("Opening purchase prompt...", Color3.fromRGB(255, 193, 7))
	
	local success, error = pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, GamepassConfig.VIP_GAMEPASS_ID)
	end)
	
	if not success then
		showStatus("Failed to open purchase prompt: " .. tostring(error), Color3.new(1, 0, 0))
	end
end)

-- Cancel handler
cancelButton.MouseButton1Click:Connect(hideGUI)

-- Listen for VIP entry requests from server
requestVIPEntryEvent.OnClientEvent:Connect(function(success, message)
	if success then
		hideGUI()
		showStatus(message or "Access granted!", Color3.new(0, 1, 0))
	else
		-- Show purchase GUI if access denied
		if message and message:find("required") then
			showGUI()
			showStatus(message, Color3.new(1, 0.5, 0))
		else
			showStatus(message or "Access denied", Color3.new(1, 0, 0))
		end
	end
end)

-- Handle purchase completion
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(purchasedGamepassId, wasPurchased)
	if purchasedGamepassId == GamepassConfig.VIP_GAMEPASS_ID and wasPurchased then
		hideGUI()
		showStatus("Purchase successful! Granting access...", Color3.new(0, 1, 0))
		
		-- Request entry again after purchase
		wait(1)
		requestVIPEntryEvent:FireServer()
	end
end)

-- Export show function
_G.ShowVIPPurchaseGUI = showGUI

-- Parent to StarterGui
screenGui.Parent = game:GetService("StarterGui")

print("VIPPurchaseGui loaded successfully!")

