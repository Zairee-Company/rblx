# Roblox VIP System with Friend Request & Gamepass Gate

A complete Roblox VIP system featuring friend requests, gamepass-based access control, and a donation system with fireworks displays.

## 📋 Features

- **Friend Request Integration**: Add friends directly from player profiles
- **VIP Gamepass System**: Secure VIP room access controlled by gamepass purchases
- **Donation System**: Multi-tier donations with spectacular fireworks shows
- **Server-Wide Announcements**: Donor names displayed to all players
- **Anti-Exploit Protection**: All verification performed server-side

## 🚀 Quick Start

### Step 1: Setup in Roblox Studio

1. Open your Roblox game in Studio
2. Copy all files from this repository to your game following the directory structure
3. Create the necessary RemoteEvents in `ReplicatedStorage/RemoteEvents/`:
   - `FriendRequest` (RemoteEvent)
   - `CheckVIPAccess` (RemoteEvent)
   - `RequestVIPEntry` (RemoteEvent)
   - `DonationTriggered` (RemoteEvent)

### Step 2: Create Gamepass

1. Go to [Roblox Creator Dashboard](https://create.roblox.com/dashboard)
2. Navigate to your game → Monetization → Gamepasses
3. Create a new gamepass:
   - Name: "VIP Access" (or your preferred name)
   - Description: List VIP benefits
   - Icon: Upload an icon image
   - Price: Set your desired Robux amount (e.g., 100 Robux)
4. Copy the Gamepass ID (found in the URL or gamepass settings)
5. Update `ReplicatedStorage/Modules/GamepassConfig.lua`:
   ```lua
   VIP_GAMEPASS_ID = YOUR_GAMEPASS_ID_HERE
   ```

### Step 3: Create Developer Products (Donations)

1. In Creator Dashboard → Your Game → Monetization → Developer Products
2. Create 4 products:
   - **Small Donation**: 25 Robux
   - **Medium Donation**: 50 Robux
   - **Large Donation**: 100 Robux
   - **Epic Donation**: 250 Robux
3. Copy each Product ID
4. Update `ReplicatedStorage/Modules/DonationConfig.lua` with the product IDs:
   ```lua
   PRODUCTS = {
       SMALL = { ID = YOUR_SMALL_PRODUCT_ID, ... },
       MEDIUM = { ID = YOUR_MEDIUM_PRODUCT_ID, ... },
       LARGE = { ID = YOUR_LARGE_PRODUCT_ID, ... },
       EPIC = { ID = YOUR_EPIC_PRODUCT_ID, ... },
   }
   ```

### Step 4: Create VIP Room in Workspace

1. In Roblox Studio, create a new Model named `VIPRoom` in Workspace
2. Create a Part named `EntryGate` (this is where players will enter)
3. Add a `ProximityPrompt` to the EntryGate:
   - ActionText: "Enter VIP Room"
   - KeyboardKeyCode: E
   - MaxActivationDistance: 10
4. Optionally create an `EntryPoint` part inside VIPRoom (player will teleport here)
5. Update `GamepassConfig.lua` if you set a custom entry position:
   ```lua
   VIP_ROOM_ENTRY_POSITION = Vector3.new(X, Y, Z)
   ```

### Step 5: Setup Fireworks Spawn Zone (Optional)

1. Create a Part in Workspace named `FireworksSpawnZone`
2. Position it where you want fireworks to appear (e.g., center of map, above spawn)
3. The system will automatically use this location, or default to (0, 200, 0)

### Step 6: Test Your System

⚠️ **Important**: Friend prompts and gamepass purchases only work in **Play mode** or **published game**, not in Studio Edit mode.

1. Click "Play" in Studio to test with multiple players
2. Test friend requests from player profiles
3. Test VIP entry without gamepass (should prompt purchase)
4. Purchase gamepass and test entry again
5. Test donations and verify fireworks appear

## 📁 File Structure

```
StarterGui/
  ├── AvatarProfileGui (auto-created by AvatarProfileAllInOne.lua)
  ├── VIPPurchaseGui/
  │   └── VIPPurchaseGui.lua
  └── DonationGui/
      └── DonationController.lua

StarterPlayer/StarterPlayerScripts/
  ├── AvatarProfileAllInOne.lua
  └── VIPEntryHandler.lua

ServerScriptService/
  ├── VIPAccessManager.lua
  ├── RemoteEventHandlers.lua
  └── DonationSystem/
      ├── DonationHandler.lua
      ├── FireworksEngine.lua (ModuleScript)
      └── NameDisplayer.lua (ModuleScript)

ReplicatedStorage/
  ├── Modules/
  │   ├── GamepassConfig.lua
  │   └── DonationConfig.lua
  └── RemoteEvents/
      ├── FriendRequest.lua (RemoteEvent - create in Studio)
      ├── CheckVIPAccess.lua (RemoteEvent - create in Studio)
      ├── RequestVIPEntry.lua (RemoteEvent - create in Studio)
      └── DonationTriggered.lua (RemoteEvent - create in Studio)

Workspace/
  ├── VIPRoom/
  │   ├── EntryGate (Part with ProximityPrompt)
  │   └── EntryPoint (Optional Part - teleport location)
  └── FireworksSpawnZone (Optional Part - fireworks spawn location)
```

## 🔧 Configuration

### GamepassConfig.lua

```lua
return {
    VIP_GAMEPASS_ID = 123456789, -- Your gamepass ID
    VIP_ROOM_BENEFITS = {
        "Exclusive lounge area",
        "Special avatar items",
        "Priority server access",
        "Unique badge"
    },
    PRICE_ROBUX = 100,
    VIP_ROOM_ENTRY_POSITION = Vector3.new(0, 50, 0)
}
```

### DonationConfig.lua

```lua
return {
    PRODUCTS = {
        SMALL = {
            ID = 123456789,
            NAME = "Small Donation",
            DURATION = 10,
            FIREWORKS_COUNT = 15,
            COLORS = {Color3.fromRGB(255, 100, 100), Color3.fromRGB(100, 100, 255)},
            SOUND_ID = "rbxassetid://9125644075"
        },
        -- ... more tiers
    },
    DISPLAY_HEIGHT = 200,
    NAME_DISPLAY_DURATION = 5,
    COOLDOWN = 2
}
```

## 🎮 Usage

### Opening Player Profiles

Call from any script:
```lua
_G.OpenPlayerProfile(targetPlayer)
```

Or integrate with your existing player click system.

### Opening Donation GUI

Call from any script:
```lua
_G.ShowDonationGUI()
```

Or click the "💰 Donate" button in the player profile.

### Opening VIP Purchase GUI

Triggered automatically when player tries to enter VIP room without gamepass, or call:
```lua
_G.ShowVIPPurchaseGUI()
```

## 🔒 Security Features

- **Server-Side Verification**: All gamepass checks performed server-side
- **No Client Trust**: Client requests are validated on server
- **Access Caching**: VIP status cached with expiration (60 seconds)
- **Rate Limiting**: Donation cooldown prevents spam
- **Receipt Processing**: Proper ProcessReceipt handler for purchases

## 🐛 Troubleshooting

### Friend Request Errors

- **SetCore error in Studio**: Normal behavior. Test in Play mode or published game.
- **Fallback not working**: Ensure `FriendRequest` RemoteEvent exists in ReplicatedStorage/RemoteEvents/

### VIP Access Issues

- **Gamepass not recognized**: 
  - Verify correct Gamepass ID in GamepassConfig.lua
  - Ensure gamepass is on sale (Active status)
  - Check that gamepass is associated with your game
- **Players bypassing gate**: 
  - Server-side scripts should prevent this
  - Add physical barriers in workspace
  - Verify VIPAccessManager.lua is running

### Donation Problems

- **Purchase doesn't trigger fireworks**: 
  - Verify ProcessReceipt is set (in DonationHandler.lua)
  - Check product IDs in DonationConfig.lua
  - Ensure products are active in dashboard
- **Fireworks not visible**: 
  - Check FireworksSpawnZone position
  - Verify FireworksEngine.lua is loaded
  - Check console for errors

### GUI Not Appearing

- **Profile GUI**: Ensure AvatarProfileAllInOne.lua is in StarterPlayer/StarterPlayerScripts/
- **VIP Purchase GUI**: Check VIPPurchaseGui.lua is in StarterGui/VIPPurchaseGui/
- **Donation GUI**: Verify DonationController.lua is in StarterGui/DonationGui/

## 📝 Additional Notes

- **Testing**: Always test with real Robux purchases in a published game before public release
- **Performance**: Fireworks are cleaned up automatically, but monitor with many simultaneous displays
- **Customization**: Feel free to modify colors, durations, and effects in config files
- **Localization**: Update text strings in scripts for different languages

## 🎨 Customization Ideas

- **VIP Badge**: Add a badge above VIP players' heads
- **Tiered VIP**: Multiple gamepass levels with different rooms
- **VIP Chat**: Exclusive chat channel for VIP members
- **Donation Leaderboard**: Track top donors
- **Seasonal Themes**: Special fireworks for holidays

## 📄 License

This code is provided as-is for use in your Roblox games. Modify and customize as needed.

## 🤝 Support

If you encounter issues:

1. Check the Troubleshooting section above
2. Verify all RemoteEvents are created in Studio
3. Ensure all configuration files have correct IDs
4. Test in Play mode (not Edit mode)
5. Check the Output window in Studio for error messages

---

**Ready to implement!** Follow the setup steps above in order for best results.



# Setup Guide - Roblox VIP System

This guide will walk you through setting up the complete VIP system step-by-step.

## Prerequisites

- Roblox Studio installed
- Access to Roblox Creator Dashboard
- Your game published (at least once) to test purchases

## Step 1: Copy Files to Your Game

1. Open your Roblox game in Studio
2. Copy all files from this repository to match the directory structure:
   - `StarterPlayer/StarterPlayerScripts/` → Your game's StarterPlayer/StarterPlayerScripts/
   - `ServerScriptService/` → Your game's ServerScriptService/
   - `StarterGui/` → Your game's StarterGui/
   - `ReplicatedStorage/Modules/` → Your game's ReplicatedStorage/Modules/

3. If folders don't exist, create them:
   - Right-click ReplicatedStorage → Insert Object → Folder → Name it "Modules"
   - Right-click ReplicatedStorage → Insert Object → Folder → Name it "RemoteEvents"

## Step 2: Create RemoteEvents

The `SetupRemoteEvents.lua` script will auto-create these, but you can also create them manually:

1. In ReplicatedStorage/RemoteEvents/, create these RemoteEvents:
   - Right-click RemoteEvents folder → Insert Object → RemoteEvent → Name: "FriendRequest"
   - Right-click RemoteEvents folder → Insert Object → RemoteEvent → Name: "CheckVIPAccess"
   - Right-click RemoteEvents folder → Insert Object → RemoteEvent → Name: "RequestVIPEntry"
   - Right-click RemoteEvents folder → Insert Object → RemoteEvent → Name: "DonationTriggered"
   - Right-click RemoteEvents folder → Insert Object → RemoteEvent → Name: "OpenDonationGui"

Or run the game once - `SetupRemoteEvents.lua` will create them automatically.

## Step 3: Create VIP Gamepass

1. Go to https://create.roblox.com/dashboard
2. Click on your game
3. Click "Monetization" in the left sidebar
4. Click "Gamepasses" tab
5. Click "Create Gamepass" button
6. Fill in:
   - **Name**: "VIP Access" (or your choice)
   - **Description**: List benefits (e.g., "Exclusive VIP room access")
   - **Icon**: Upload a 512x512 image
   - **Price**: Enter your price in Robux (e.g., 100)
7. Click "Save"
8. **Copy the Gamepass ID** from the URL or gamepass page
   - URL format: `https://create.roblox.com/dashboard/games/[GAME_ID]/game-passes/[GAMEPASS_ID]`
   - The GAMEPASS_ID is what you need
9. Open `ReplicatedStorage/Modules/GamepassConfig.lua` in Studio
10. Replace `VIP_GAMEPASS_ID = 0` with your actual ID:
    ```lua
    VIP_GAMEPASS_ID = 123456789  -- Replace with your ID
    ```

## Step 4: Create Developer Products (Donations)

1. In Creator Dashboard → Your Game → Monetization → Developer Products
2. Click "Create Developer Product"
3. Create 4 products with these settings:

   **Small Donation:**
   - Name: "Small Donation"
   - Description: "Thank you for supporting the game!"
   - Icon: Upload image
   - Price: 25 Robux
   - Copy Product ID

   **Medium Donation:**
   - Name: "Medium Donation"
   - Price: 50 Robux
   - Copy Product ID

   **Large Donation:**
   - Name: "Large Donation"
   - Price: 100 Robux
   - Copy Product ID

   **Epic Donation:**
   - Name: "Epic Donation"
   - Price: 250 Robux
   - Copy Product ID

4. Open `ReplicatedStorage/Modules/DonationConfig.lua` in Studio
5. Replace the `ID = 0` for each product with your actual IDs:
   ```lua
   SMALL = {
       ID = 123456789,  -- Replace with Small Donation Product ID
       ...
   },
   MEDIUM = {
       ID = 987654321,  -- Replace with Medium Donation Product ID
       ...
   },
   -- etc.
   ```

## Step 5: Create VIP Room in Workspace

1. In Studio, open the Workspace view
2. Insert a new Model:
   - Right-click Workspace → Insert Object → Model
   - Rename to "VIPRoom"
3. Create Entry Gate:
   - Inside VIPRoom model, insert a Part
   - Rename to "EntryGate"
   - Position it where you want the VIP entrance (e.g., near spawn)
   - Size it appropriately (e.g., 4x8x1 studs)
   - Color it distinctively (e.g., gold: RGB 255, 215, 0)
4. Add ProximityPrompt:
   - Select EntryGate part
   - Insert Object → ProximityPrompt
   - Set properties:
     - ActionText: "Enter VIP Room"
     - KeyboardKeyCode: E
     - HoldDuration: 0
     - MaxActivationDistance: 10
5. (Optional) Create EntryPoint:
   - Inside VIPRoom, insert a Part
   - Rename to "EntryPoint"
   - Position it where players should teleport inside the room
   - The system will use this as the teleport destination

6. Build your VIP room:
   - Add walls, floor, ceiling
   - Add VIP-exclusive items, NPCs, or areas
   - Add lighting and effects
   - Make it visually distinct from the regular area

## Step 6: Create Fireworks Spawn Zone (Optional)

1. In Workspace, insert a Part
2. Rename to "FireworksSpawnZone"
3. Position it where fireworks should appear (e.g., center of map, above spawn)
4. Make it invisible:
   - Set Transparency to 1
   - Or uncheck "Visible" in properties
5. Size it as needed (large area for spread)

If you don't create this, fireworks will spawn at position (0, 200, 0) by default.

## Step 7: Configure Entry Position (Optional)

If you created an EntryPoint in the VIPRoom, the system will use it automatically. Otherwise:

1. Open `ReplicatedStorage/Modules/GamepassConfig.lua`
2. Update `VIP_ROOM_ENTRY_POSITION`:
   ```lua
   VIP_ROOM_ENTRY_POSITION = Vector3.new(0, 50, 0)  -- Replace with your coordinates
   ```
   To find coordinates:
   - In Studio, move your camera to the entry location
   - Check the camera's Position in the Properties panel
   - Use those X, Y, Z values

## Step 8: Test Your System

### Testing Friend Requests

1. Click "Play" in Studio
2. Open PlayerGui for your test player
3. Find AvatarProfileGui
4. Use `_G.OpenPlayerProfile(targetPlayer)` in the console, or integrate with your click system
5. Click "Add Friend" button
6. **Note**: Friend requests only work in Play mode or published game

### Testing VIP Access

1. Click "Play" in Studio with 2+ players
2. Approach the VIPRoom EntryGate as a player without the gamepass
3. Press E or interact with the ProximityPrompt
4. VIP Purchase GUI should appear
5. Click "Purchase Gamepass" (this will work in Play mode)
6. Complete purchase (you'll be charged real Robux in published game)
7. Player should be teleported into VIP room
8. Test with another player who doesn't own gamepass - they should be blocked

### Testing Donations

1. Click "Play" in Studio
2. Click the "💰 Donate" button (top right of screen)
3. Or call `_G.ShowDonationGUI()` from console
4. Select a donation tier
5. Complete purchase
6. Fireworks should appear after purchase processes
7. Donor name should display to all players

**Important**: In Studio, you can test the GUI and purchase prompts, but actual processing happens in published games.

## Step 9: Publish and Test with Real Purchases

1. Publish your game to Roblox
2. Join your published game
3. Test with real Robux purchases:
   - Purchase VIP gamepass
   - Verify access is granted
   - Purchase donations
   - Verify fireworks display
4. Test with multiple accounts
5. Verify server-side checks are working (can't bypass with exploits)

## Troubleshooting

### Scripts Not Running

- Check Output window for errors
- Verify all files are in correct locations
- Ensure folder structure matches exactly
- Check that scripts aren't disabled

### RemoteEvents Not Found

- Run `SetupRemoteEvents.lua` once (it auto-runs on server start)
- Or manually create RemoteEvents in ReplicatedStorage/RemoteEvents/

### Gamepass Not Recognized

- Verify Gamepass ID is correct in GamepassConfig.lua
- Ensure gamepass is Active (on sale)
- Check that gamepass is associated with your game
- Clear VIP cache: Wait 60 seconds or restart server

### Fireworks Not Appearing

- Check FireworksSpawnZone position
- Verify DonationHandler.lua is running (check Output)
- Ensure product IDs are correct
- Check that products are Active

### VIP Room Access Issues

- Verify VIPRoom model exists in Workspace
- Check EntryGate has ProximityPrompt
- Ensure VIPAccessManager.lua is running
- Test with player who actually owns gamepass

## Next Steps

- Customize VIP room design
- Add VIP-exclusive features (speed boost, special tools, etc.)
- Create donation leaderboard
- Add VIP badge above heads
- Customize fireworks effects and colors
- Add more donation tiers

## Support

If you encounter issues:
1. Check the README.md troubleshooting section
2. Review Output window for error messages
3. Verify all configuration IDs are correct
4. Test in Play mode (not Edit mode)
5. Ensure your game is published and products are active

---

**Ready to launch!** Your VIP system should now be fully functional.



