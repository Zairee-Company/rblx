--[[
	SetupRemoteEvents.lua
	Auto-creates RemoteEvents if they don't exist
	
	Run this script once, or it will auto-create missing RemoteEvents
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ensure RemoteEvents folder exists
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
	remoteEventsFolder = Instance.new("Folder")
	remoteEventsFolder.Name = "RemoteEvents"
	remoteEventsFolder.Parent = ReplicatedStorage
end

-- List of required RemoteEvents
local requiredRemoteEvents = {
	"FriendRequest",
	"CheckVIPAccess",
	"RequestVIPEntry",
	"DonationTriggered",
	"OpenDonationGui"
}

-- Create missing RemoteEvents
for _, eventName in ipairs(requiredRemoteEvents) do
	local existingEvent = remoteEventsFolder:FindFirstChild(eventName)
	if not existingEvent then
		local remoteEvent = Instance.new("RemoteEvent")
		remoteEvent.Name = eventName
		remoteEvent.Parent = remoteEventsFolder
		print("Created RemoteEvent:", eventName)
	else
		print("RemoteEvent already exists:", eventName)
	end
end

print("RemoteEvents setup complete!")

