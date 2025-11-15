--[[
	RemoteEventHandlers.lua
	Server-side handlers for various RemoteEvents
	
	Handles:
	- Friend requests (fallback)
	- Other client-server communications
]]

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Wait for RemoteEvents
local remoteEventsFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local friendRequestEvent = remoteEventsFolder:WaitForChild("FriendRequest")

-- Handle friend request (fallback when SetCore fails)
friendRequestEvent.OnServerEvent:Connect(function(player, targetUserId)
	-- Validate input
	if type(targetUserId) ~= "number" then
		warn("Invalid targetUserId from", player.Name)
		return
	end
	
	-- Cannot send to self
	if targetUserId == player.UserId then
		return
	end
	
	-- Validate target exists
	local targetPlayer = Players:GetPlayerByUserId(targetUserId)
	if not targetPlayer then
		warn("Target player not found:", targetUserId)
		return
	end
	
	-- Attempt to prompt friend request on client
	-- Note: Server cannot directly prompt friend requests, so we notify the client
	friendRequestEvent:FireClient(player, targetUserId)
	
	print(player.Name, "attempted to send friend request to", targetPlayer.Name)
end)

print("RemoteEventHandlers loaded successfully!")

