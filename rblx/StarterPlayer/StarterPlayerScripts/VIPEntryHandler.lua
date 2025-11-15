--[[
	VIPEntryHandler.lua
	Client-side handler for VIP room entry
	
	Handles proximity prompts and entry requests
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local requestVIPEntryEvent = remoteEventsFolder:WaitForChild("RequestVIPEntry")
local checkVIPAccessEvent = remoteEventsFolder:WaitForChild("CheckVIPAccess")

-- Find VIP room entry points
player.CharacterAdded:Connect(function(character)
	wait(2) -- Wait for workspace to load
	
	local vipRoom = workspace:FindFirstChild("VIPRoom")
	if not vipRoom then
		warn("VIPRoom not found in workspace - please create it!")
		return
	end
	
	-- Find entry gate or proximity prompt
	local entryGate = vipRoom:FindFirstChild("EntryGate")
	
	if entryGate then
		local proximityPrompt = entryGate:FindFirstChildOfClass("ProximityPrompt")
		
		if not proximityPrompt then
			-- Create proximity prompt
			proximityPrompt = Instance.new("ProximityPrompt")
			proximityPrompt.Name = "VIPEntryPrompt"
			proximityPrompt.ActionText = "Enter VIP Room"
			proximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
			proximityPrompt.HoldDuration = 0
			proximityPrompt.MaxActivationDistance = 10
			proximityPrompt.Parent = entryGate
		end
		
		-- Handle activation
		proximityPrompt.Triggered:Connect(function()
			-- Request entry from server
			requestVIPEntryEvent:FireServer()
		end)
		
		-- Update prompt text based on VIP status (optional enhancement)
		checkVIPAccessEvent:FireServer()
		checkVIPAccessEvent.OnClientEvent:Connect(function(hasAccess)
			if hasAccess then
				proximityPrompt.ActionText = "Enter VIP Room (VIP)"
				proximityPrompt.ObjectText = "Welcome back!"
			else
				proximityPrompt.ActionText = "Enter VIP Room"
				proximityPrompt.ObjectText = "VIP Access Required"
			end
		end)
	end
	
	-- Handle touch events (fallback if no proximity prompt)
	local function onPartTouched(hit)
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.RootPart == hit then
			local touchedPlayer = Players:GetPlayerFromCharacter(hit.Parent)
			if touchedPlayer == player then
				requestVIPEntryEvent:FireServer()
			end
		end
	end
	
	-- Check for touch parts
	for _, child in ipairs(vipRoom:GetDescendants()) do
		if child:IsA("BasePart") and child.Name == "TouchToEnter" then
			child.Touched:Connect(onPartTouched)
		end
	end
end)

print("VIPEntryHandler loaded successfully!")

