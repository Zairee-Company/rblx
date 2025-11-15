--[[
	DonationController.lua
	LocalScript that controls the Donation GUI
	
	This creates the GUI elements programmatically
	Alternatively, you can create this GUI in Roblox Studio
]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for configuration
local DonationConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DonationConfig"))

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DonationGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Toggle button (always visible)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "DonateToggleButton"
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(1, -160, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
toggleButton.Text = "💰 Donate"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleButton

-- Main donation frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "DonationFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(100, 100, 100)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "💰 Support the Game!"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 28
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 45, 0, 45)
closeButton.Position = UDim2.new(1, -50, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Preview text
local previewLabel = Instance.new("TextLabel")
previewLabel.Name = "PreviewLabel"
previewLabel.Size = UDim2.new(1, -30, 0, 50)
previewLabel.Position = UDim2.new(0, 15, 0, 70)
previewLabel.BackgroundTransparency = 1
previewLabel.Text = "Your name will appear on screen for all players!"
previewLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
previewLabel.TextSize = 16
previewLabel.Font = Enum.Font.Gotham
previewLabel.TextWrapped = true
previewLabel.Parent = mainFrame

-- Scrolling frame for donation options
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "DonationOptions"
scrollFrame.Size = UDim2.new(1, -30, 0, 430)
scrollFrame.Position = UDim2.new(0, 15, 0, 130)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 15)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

-- Create donation buttons
local function createDonationButton(donationType, config, layoutOrder)
	local button = Instance.new("TextButton")
	button.Name = donationType .. "Donation"
	button.Size = UDim2.new(1, -20, 0, 120)
	button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	button.Text = ""
	button.BorderSizePixel = 0
	button.LayoutOrder = layoutOrder
	button.Parent = scrollFrame
	
	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button
	
	local buttonStroke = Instance.new("UIStroke")
	buttonStroke.Color = config.COLORS[1] or Color3.fromRGB(255, 215, 0)
	buttonStroke.Thickness = 2
	buttonStroke.Parent = button
	
	-- Hover effect
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
	end)
	
	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -20, 0, 35)
	titleLabel.Position = UDim2.new(0, 10, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = config.NAME or donationType .. " Donation"
	titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	titleLabel.TextSize = 22
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = button
	
	-- Price (use PRICE field if available, otherwise try to extract from name)
	local priceText = "N/A"
	if config.PRICE then
		priceText = config.PRICE .. " Robux"
	elseif config.NAME then
		-- Fallback: try to extract price from name if it contains numbers
		local priceNum = tonumber(config.NAME:match("%d+"))
		if priceNum then
			priceText = priceNum .. " Robux"
		end
	end
	
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Name = "Price"
	priceLabel.Size = UDim2.new(0, 150, 0, 30)
	priceLabel.Position = UDim2.new(1, -160, 0, 5)
	priceLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
	priceLabel.Text = priceText
	priceLabel.TextColor3 = Color3.new(1, 1, 1)
	priceLabel.TextSize = 18
	priceLabel.Font = Enum.Font.GothamBold
	priceLabel.BorderSizePixel = 0
	priceLabel.Parent = button
	
	local priceCorner = Instance.new("UICorner")
	priceCorner.CornerRadius = UDim.new(0, 6)
	priceCorner.Parent = priceLabel
	
	-- Duration
	local durationLabel = Instance.new("TextLabel")
	durationLabel.Name = "Duration"
	durationLabel.Size = UDim2.new(1, -20, 0, 25)
	durationLabel.Position = UDim2.new(0, 10, 0, 45)
	durationLabel.BackgroundTransparency = 1
	durationLabel.Text = "Duration: " .. config.DURATION .. " seconds"
	durationLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	durationLabel.TextSize = 14
	durationLabel.Font = Enum.Font.Gotham
	durationLabel.TextXAlignment = Enum.TextXAlignment.Left
	durationLabel.Parent = button
	
	-- Fireworks count
	local fireworksLabel = Instance.new("TextLabel")
	fireworksLabel.Name = "FireworksCount"
	fireworksLabel.Size = UDim2.new(1, -20, 0, 25)
	fireworksLabel.Position = UDim2.new(0, 10, 0, 70)
	fireworksLabel.BackgroundTransparency = 1
	fireworksLabel.Text = "Fireworks: " .. config.FIREWORKS_COUNT
	fireworksLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	fireworksLabel.TextSize = 14
	fireworksLabel.Font = Enum.Font.Gotham
	fireworksLabel.TextXAlignment = Enum.TextXAlignment.Left
	fireworksLabel.Parent = button
	
	-- Special effects indicator
	if config.SPECIAL_EFFECTS then
		local specialLabel = Instance.new("TextLabel")
		specialLabel.Name = "Special"
		specialLabel.Size = UDim2.new(1, -20, 0, 25)
		specialLabel.Position = UDim2.new(0, 10, 0, 95)
		specialLabel.BackgroundTransparency = 1
		specialLabel.Text = "⭐ Special Effects Included!"
		specialLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		specialLabel.TextSize = 14
		specialLabel.Font = Enum.Font.GothamBold
		specialLabel.TextXAlignment = Enum.TextXAlignment.Left
		specialLabel.Parent = button
	end
	
	-- Purchase handler
	button.MouseButton1Click:Connect(function()
		-- Prompt purchase
		local success, error = pcall(function()
			MarketplaceService:PromptProductPurchase(player, config.ID)
		end)
		
		if not success then
			warn("Failed to prompt product purchase:", error)
		end
	end)
	
	return button
end

-- Create buttons for each donation tier
local order = 1
for donationType, config in pairs(DonationConfig.PRODUCTS) do
	if config.ID and config.ID > 0 then
		createDonationButton(donationType, config, order)
		order = order + 1
	end
end

-- Update canvas size
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

-- Functions
local function showGUI()
	mainFrame.Visible = true
	screenGui.Parent = playerGui
	
	-- Animate in
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 500, 0, 600)}
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

-- Event connections
toggleButton.MouseButton1Click:Connect(function()
	if mainFrame.Visible then
		hideGUI()
	else
		showGUI()
	end
end)

closeButton.MouseButton1Click:Connect(hideGUI)

-- Handle purchase completion
MarketplaceService.PromptProductPurchaseFinished:Connect(function(purchasedProductId, wasPurchased)
	if wasPurchased then
		hideGUI()
		
		-- Show confirmation (optional)
		local confirmation = Instance.new("ScreenGui")
		confirmation.Name = "DonationConfirmation"
		confirmation.ResetOnSpawn = false
		confirmation.Parent = playerGui
		
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 300, 0, 100)
		frame.Position = UDim2.new(0.5, -150, 0.2, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		frame.BorderSizePixel = 0
		frame.Parent = confirmation
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = frame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "Thank you for your donation! 🎆"
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextSize = 18
		label.Font = Enum.Font.GothamBold
		label.TextWrapped = true
		label.Parent = frame
		
		wait(3)
		confirmation:Destroy()
	end
end)

-- Export show function
_G.ShowDonationGUI = showGUI

-- Parent to StarterGui
screenGui.Parent = game:GetService("StarterGui")

print("DonationController loaded successfully!")

