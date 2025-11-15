--[[
	AvatarProfileAllInOne.lua
	Complete avatar profile system with friend request functionality
	
	Features:
	- View player avatar and info
	- Send friend/connection requests
	- Open donation GUI
	- Profile management
]]

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local friendRequestEvent = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("FriendRequest")

-- Wait for Donation GUI (if exists)
local donationGui = StarterGui:FindFirstChild("DonationGui")

-- Create Profile GUI
local profileGui = Instance.new("ScreenGui")
profileGui.Name = "AvatarProfileGui"
profileGui.ResetOnSpawn = false
profileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = profileGui

-- Corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 100, 100)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Player Profile"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Avatar display area
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(1, -30, 0, 150)
avatarFrame.Position = UDim2.new(0, 15, 0, 60)
avatarFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = mainFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(0, 8)
avatarCorner.Parent = avatarFrame

local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.Size = UDim2.new(1, -20, 0, 30)
playerName.Position = UDim2.new(0, 10, 0, 10)
playerName.BackgroundTransparency = 1
playerName.Text = "Loading..."
playerName.TextColor3 = Color3.new(1, 1, 1)
playerName.TextSize = 24
playerName.Font = Enum.Font.GothamBold
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = avatarFrame

local playerDisplayName = Instance.new("TextLabel")
playerDisplayName.Name = "PlayerDisplayName"
playerDisplayName.Size = UDim2.new(1, -20, 0, 25)
playerDisplayName.Position = UDim2.new(0, 10, 0, 40)
playerDisplayName.BackgroundTransparency = 1
playerDisplayName.Text = "@username"
playerDisplayName.TextColor3 = Color3.fromRGB(200, 200, 200)
playerDisplayName.TextSize = 18
playerDisplayName.Font = Enum.Font.Gotham
playerDisplayName.TextXAlignment = Enum.TextXAlignment.Left
playerDisplayName.Parent = avatarFrame

local userIdLabel = Instance.new("TextLabel")
userIdLabel.Name = "UserIdLabel"
userIdLabel.Size = UDim2.new(1, -20, 0, 20)
userIdLabel.Position = UDim2.new(0, 10, 0, 70)
userIdLabel.BackgroundTransparency = 1
userIdLabel.Text = "User ID: 0"
userIdLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
userIdLabel.TextSize = 14
userIdLabel.Font = Enum.Font.Gotham
userIdLabel.TextXAlignment = Enum.TextXAlignment.Left
userIdLabel.Parent = avatarFrame

-- Buttons container
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -30, 0, 280)
buttonsFrame.Position = UDim2.new(0, 15, 0, 220)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local buttonsLayout = Instance.new("UIListLayout")
buttonsLayout.Padding = UDim.new(0, 10)
buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonsLayout.Parent = buttonsFrame

-- Add Friend Button
local addFriendButton = Instance.new("TextButton")
addFriendButton.Name = "AddFriendButton"
addFriendButton.Size = UDim2.new(1, 0, 0, 50)
addFriendButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
addFriendButton.Text = "Add Friend"
addFriendButton.TextColor3 = Color3.new(1, 1, 1)
addFriendButton.TextSize = 18
addFriendButton.Font = Enum.Font.GothamBold
addFriendButton.BorderSizePixel = 0
addFriendButton.LayoutOrder = 1
addFriendButton.Parent = buttonsFrame

local friendCorner = Instance.new("UICorner")
friendCorner.CornerRadius = UDim.new(0, 8)
friendCorner.Parent = addFriendButton

-- Donate Button
local donateButton = Instance.new("TextButton")
donateButton.Name = "DonateButton"
donateButton.Size = UDim2.new(1, 0, 0, 50)
donateButton.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
donateButton.Text = "💰 Donate"
donateButton.TextColor3 = Color3.new(0, 0, 0)
donateButton.TextSize = 18
donateButton.Font = Enum.Font.GothamBold
donateButton.BorderSizePixel = 0
donateButton.LayoutOrder = 2
donateButton.Parent = buttonsFrame

local donateCorner = Instance.new("UICorner")
donateCorner.CornerRadius = UDim.new(0, 8)
donateCorner.Parent = donateButton

-- Status message
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 1, -40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.new(0, 1, 0)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Visible = false
statusLabel.Parent = mainFrame

-- Variables
local targetPlayer = nil
local targetUserId = nil

-- Functions
local function showStatus(message, color)
	color = color or Color3.new(0, 1, 0)
	statusLabel.Text = message
	statusLabel.TextColor3 = color
	statusLabel.Visible = true
	
	wait(3)
	
	local fadeOut = TweenService:Create(
		statusLabel,
		TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{TextTransparency = 1}
	)
	
	fadeOut:Play()
	fadeOut.Completed:Wait()
	statusLabel.Visible = false
	statusLabel.TextTransparency = 0
end

local function updateProfile(playerToShow)
	if not playerToShow then return end
	
	targetPlayer = playerToShow
	targetUserId = playerToShow.UserId
	
	playerName.Text = playerToShow.DisplayName
	playerDisplayName.Text = "@" .. playerToShow.Name
	userIdLabel.Text = "User ID: " .. tostring(playerToShow.UserId)
	
	-- Check if already friends
	if playerToShow.UserId == player.UserId then
		addFriendButton.Text = "That's You!"
		addFriendButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		addFriendButton.Active = false
	else
		addFriendButton.Text = "Add Friend"
		addFriendButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
		addFriendButton.Active = true
	end
end

local function openProfile(playerToShow)
	if not playerToShow then return end
	
	updateProfile(playerToShow)
	
	profileGui.Parent = playerGui
	mainFrame.Visible = true
	
	-- Animate in
	mainFrame.Size = UDim2.new(0, 0, 0, 0)
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Size = UDim2.new(0, 400, 0, 500)}
	)
	tween:Play()
end

local function closeProfile()
	local tween = TweenService:Create(
		mainFrame,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Size = UDim2.new(0, 0, 0, 0)}
	)
	tween:Play()
	tween.Completed:Wait()
	mainFrame.Visible = false
end

local function sendFriendRequest()
	if not targetUserId or targetUserId == player.UserId then
		showStatus("Cannot send friend request to yourself!", Color3.new(1, 0, 0))
		return
	end
	
	-- Close profile immediately
	closeProfile()
	
	-- Attempt to use native friend request prompt
	local success, error = pcall(function()
		StarterGui:SetCore("PromptSendFriendRequest", targetUserId)
	end)
	
	if success then
		showStatus("Friend request sent!", Color3.new(0, 1, 0))
	else
		-- Fallback to server-side handling
		warn("SetCore failed, using server fallback:", error)
		friendRequestEvent:FireServer(targetUserId)
		showStatus("Friend request processing...", Color3.fromRGB(255, 193, 7))
	end
end

local function openDonationGui()
	if not targetUserId then return end
	
	closeProfile()
	
	-- Try to open donation GUI
	if donationGui then
		local donationController = donationGui:FindFirstChild("DonationController")
		if donationController then
			-- Store target user ID for shoutout
			donationGui:SetAttribute("TargetUserId", targetUserId)
			-- Trigger open
			local remote = ReplicatedStorage:FindFirstChild("RemoteEvents"):FindFirstChild("OpenDonationGui")
			if remote then
				remote:FireServer()
			end
		end
	end
end

-- Event connections
closeButton.MouseButton1Click:Connect(closeProfile)
addFriendButton.MouseButton1Click:Connect(sendFriendRequest)
donateButton.MouseButton1Click:Connect(openDonationGui)

-- Export openProfile function globally (can be called from other scripts)
_G.OpenPlayerProfile = openProfile

-- Example: Open profile when player clicks on another player's character
Players.PlayerAdded:Connect(function(newPlayer)
	newPlayer.CharacterAdded:Connect(function(character)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 10)
		if humanoidRootPart then
			-- This is a basic example - you might want a more sophisticated click detection system
		end
	end)
end)

-- Parent GUI to StarterGui for persistence
profileGui.Parent = StarterGui

print("AvatarProfileAllInOne loaded successfully!")

