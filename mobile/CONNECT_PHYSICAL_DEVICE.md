# Connect Physical Android Device - Step by Step

## Quick Steps

### Step 1: Enable Developer Options on Your Phone

1. Open **Settings** on your Android phone
2. Go to **About Phone** (or **About Device**)
3. Find **Build Number** (usually at the bottom)
4. **Tap Build Number 7 times** - You'll see a message "You are now a developer!"
5. Go back to main Settings
6. You'll now see **Developer Options** (usually under System)

### Step 2: Enable USB Debugging

1. Open **Settings** → **Developer Options**
2. Toggle **Developer Options** ON (if not already)
3. Enable **USB Debugging**
4. (Optional) Enable **Stay Awake** (keeps screen on while charging)

### Step 3: Connect Phone to Computer

1. Connect your phone to computer via USB cable
2. On your phone, you'll see a popup: **"Allow USB debugging?"**
3. Check **"Always allow from this computer"**
4. Tap **Allow**

### Step 4: Verify Connection

Open PowerShell and run:

```powershell
# Refresh PATH first
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"

# Check if device is connected
adb devices
```

You should see:
```
List of devices attached
ABC123XYZ    device
```

If you see "unauthorized", tap "Allow" on your phone again.

### Step 5: Run the App

```powershell
cd mobile

# Make sure PATH is set
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"

npm run android
```

## Troubleshooting

### "adb is not recognized"

Refresh PATH in PowerShell:
```powershell
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"
```

Or close and reopen PowerShell (PATH refreshes automatically).

### "No devices found"

1. Check USB cable (try different cable)
2. Check USB connection mode on phone:
   - Pull down notification panel
   - Tap USB notification
   - Select **File Transfer** or **MTP** mode
3. Try different USB port on computer
4. Restart ADB:
   ```powershell
   adb kill-server
   adb start-server
   adb devices
   ```

### "Device unauthorized"

1. Unplug and replug USB cable
2. On phone, tap "Allow" when popup appears
3. Check "Always allow from this computer"
4. Run `adb devices` again

### Phone Not Showing Up

1. Install phone drivers (if Windows doesn't recognize it):
   - Samsung: Install Samsung USB drivers
   - Google Pixel: Usually works automatically
   - Other brands: Check manufacturer website for USB drivers
2. Try different USB port (USB 2.0 ports work better)
3. Enable "USB Debugging" in Developer Options
4. Restart phone and computer

## Quick Connection Script

Save this as `connect-device.ps1`:

```powershell
# Refresh PATH
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"

Write-Host "Checking for connected devices..." -ForegroundColor Yellow
$devices = adb devices

if ($devices -match "device$") {
    Write-Host "✅ Device connected!" -ForegroundColor Green
    adb devices
} else {
    Write-Host "❌ No device found" -ForegroundColor Red
    Write-Host "`nMake sure:" -ForegroundColor Yellow
    Write-Host "1. USB Debugging is enabled on phone" -ForegroundColor White
    Write-Host "2. Phone is connected via USB" -ForegroundColor White
    Write-Host "3. You tapped 'Allow' on the USB debugging popup" -ForegroundColor White
}
```

## Alternative: Use Wireless Debugging (Android 11+)

If USB is problematic, use wireless debugging:

1. Connect phone and computer to same WiFi
2. On phone: **Developer Options** → **Wireless debugging** → Enable
3. Tap **Wireless debugging** → **Pair device with pairing code**
4. Note the IP address and port (e.g., 192.168.1.100:12345)
5. In PowerShell:
   ```powershell
   adb pair 192.168.1.100:12345
   # Enter pairing code when prompted
   adb connect 192.168.1.100:PORT
   ```

## Verify Everything Works

```powershell
# 1. Check ADB
adb --version

# 2. Check devices
adb devices

# 3. If device shows, you're ready!
cd mobile
npm run android
```

## Common Issues

| Issue | Solution |
|-------|----------|
| "adb: command not found" | Add to PATH: `$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"` |
| "unauthorized" | Tap "Allow" on phone popup |
| "offline" | Restart ADB: `adb kill-server && adb start-server` |
| Phone not detected | Install USB drivers for your phone brand |
| "No devices" | Check USB cable, try different port, enable USB debugging |

## Next Steps

Once device is connected:
1. Verify: `adb devices` shows your device
2. Run: `cd mobile && npm run android`
3. App will install and launch on your phone!

