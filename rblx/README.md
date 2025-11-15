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

