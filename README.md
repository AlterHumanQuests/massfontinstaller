# Font Downloader App - Comprehensive Troubleshooting Guide

## Overview
This document provides comprehensive troubleshooting steps if you encounter issues with the Font Downloader app on macOS.

## Basic Troubleshooting Steps

### Method 1: Open Using Right-Click
1. Right-click (or Control+click) on "Font Downloader.app"
2. Select "Open" from the context menu
3. If a warning appears, click "Open" again

### Method 2: Fix Permissions
1. Open Terminal (Applications > Utilities > Terminal)
2. Run this command:
   ```
   chmod -R +x /Applications/Font\ Downloader.app/Contents/MacOS/
   ```

### Method 3: Remove Quarantine Attribute
Some macOS versions add quarantine attributes to downloaded apps. Remove it with:
```
xattr -d com.apple.quarantine /Applications/Font\ Downloader.app
```
Note: If you get "No such xattr" message, that's fine - it means the attribute isn't there.

## Advanced Troubleshooting

### Method 4: Check Security & Privacy Settings
1. Open System Preferences
2. Go to Security & Privacy > General tab
3. Look for a message about "Font Downloader" being blocked
4. Click "Open Anyway" if available

### Method 5: Try Running from Terminal
Run the app directly from Terminal to see any error messages:
```
/Applications/Font\ Downloader.app/Contents/MacOS/applet
```

### Method 6: Reinstall from a Different Location
1. Extract the zip to your Desktop instead of Downloads
2. Drag the app to Applications from the Desktop
3. Try opening it using the right-click > Open method

### Method 7: Run the Script Directly Instead
If the app bundle consistently fails to open, refer to RUN_SCRIPT_DIRECTLY.txt for instructions on running the script without the app bundle.

## Technical Issues and Solutions

### AppleScript Permissions
1. Open System Preferences > Security & Privacy > Privacy
2. Check permissions for:
   - Automation
   - Files and Folders
   - Full Disk Access
3. Add Script Editor and Terminal to these lists if needed

### System Requirements
- Make sure your macOS version is compatible with the app
- Ensure you have sufficient permissions on your user account
- Try restarting your Mac
- Make sure you have the latest macOS updates

### Common Issues with AppleScript Apps
1. **Access to protected resources**: Modern macOS versions restrict script access to many system resources
2. **Sandboxing limitations**: AppleScript apps have limited access to the file system
3. **Gatekeeper restrictions**: Even signed apps can be blocked depending on security settings

## Last Resort Solutions

### Rebuild the App from Source
If you have the source code (.applescript or .scpt file):
1. Open it in Script Editor
2. Choose File > Export
3. Set File Format to "Application"
4. Save to create a fresh app bundle

### Temporarily Disable Gatekeeper (Use with Caution)
This is not recommended but can help diagnose issues:
```
sudo spctl --master-disable
```
Remember to re-enable it after testing:
```
sudo spctl --master-enable
```

### Check Console Logs
1. Open Console app (Applications > Utilities > Console)
2. Look for messages related to "Font Downloader" or "applet"
3. These logs might reveal specific issues preventing the app from running

## If All Else Fails
Consider using alternative methods to download and install fonts:
1. Use Safari to download fonts directly
2. Use the Font Book app to install downloaded fonts
3. Contact the developer about a different application format (like a standard macOS app instead of AppleScript)