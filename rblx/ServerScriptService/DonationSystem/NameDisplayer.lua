--[[
	NameDisplayer.lua
	ModuleScript for displaying donor names server-wide
]]

local NameDisplayer = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Display donor name to all players
function NameDisplayer.ShowDonorName(donorName, donationType)
	local message = ""
	
	-- Customize message based on donation type
	if donationType == "SMALL" then
		message = "🎆 " .. donorName .. " donated! 🎆"
	elseif donationType == "MEDIUM" then
		message = "🎇 " .. donorName .. " is feeling generous! 🎇"
	elseif donationType == "LARGE" then
		message = "🎉 " .. donorName .. " made a huge donation! 🎉"
	elseif donationType == "EPIC" then
		message = "⭐ " .. donorName .. " IS A LEGEND! ⭐"
	else
		message = "🎆 " .. donorName .. " donated! 🎆"
	end
	
	-- Create GUI for each player
	for _, player in ipairs(Players:GetPlayers()) do
		spawn(function()
			local playerGui = player:WaitForChild("PlayerGui")
			
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "DonorNameDisplay"
			screenGui.ResetOnSpawn = false
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Parent = playerGui
			
			-- Main frame
			local frame = Instance.new("Frame")
			frame.Name = "DisplayFrame"
			frame.Size = UDim2.new(0, 600, 0, 80)
			frame.Position = UDim2.new(0.5, -300, 0.1, 0)
			frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			frame.BackgroundTransparency = 0.5
			frame.BorderSizePixel = 0
			frame.Parent = screenGui
			
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 8)
			corner.Parent = frame
			
			-- Stroke
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(255, 215, 0)
			stroke.Thickness = 3
			stroke.Parent = frame
			
			-- Name label
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -20, 1, 0)
			nameLabel.Position = UDim2.new(0, 10, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = message
			nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
			nameLabel.TextSize = 36
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextStrokeTransparency = 0.5
			nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			nameLabel.Parent = frame
			
			-- Animate in
			frame.Position = UDim2.new(0.5, -300, -0.2, 0)
			local slideIn = TweenService:Create(
				frame,
				TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
				{Position = UDim2.new(0.5, -300, 0.1, 0)}
			)
			slideIn:Play()
			
			-- Wait duration
			wait(5)
			
			-- Animate out
			local slideOut = TweenService:Create(
				frame,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Position = UDim2.new(0.5, -300, -0.2, 0), BackgroundTransparency = 1, TextTransparency = 1}
			)
			slideOut:Play()
			
			-- Also fade stroke
			local strokeFade = TweenService:Create(
				stroke,
				TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Transparency = 1}
			)
			strokeFade:Play()
			
			strokeFade.Completed:Wait()
			screenGui:Destroy()
		end)
	end
end

return NameDisplayer

