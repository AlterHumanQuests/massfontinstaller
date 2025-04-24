# Font Downloader App - Installation Guide

## Overview
This document provides instructions for properly installing the Font Downloader app on macOS. The app has been code-signed and notarized with Apple, but you may need to follow these steps to ensure it runs properly.

## Installation Steps

### Step 1: Extract the App
1. Download the "Font_Downloader_Fixed.zip" file
2. Double-click the zip file to extract it
3. You should now have a "Font Downloader.app" in the same folder

### Step 2: Remove Quarantine Flags (Important!)
When downloading apps from the internet, macOS automatically adds "quarantine" flags as a security measure. Even though this app is signed and notarized, you may need to manually remove these flags.

#### Option A: Using Finder
1. Right-click (or Control+click) on "Font Downloader.app"
2. Select "Open" from the context menu
3. If you get a warning dialog, click "Open" again

#### Option B: Using Terminal (Recommended if Option A fails)
1. Open Terminal (from Applications > Utilities > Terminal)
2. Copy and paste the following command, but don't press Enter yet:
   ```
   xattr -d com.apple.quarantine 
   ```
3. Add a space after the command, then drag and drop the "Font Downloader.app" into the Terminal window to automatically fill in the path
4. Press Enter to execute the command
5. There will be no output if successful

### Step 3: Open the App
After removing the quarantine flags, you should be able to open the app normally:
1. Double-click on "Font Downloader.app"
2. The app should now open without any warnings

## Troubleshooting

If you still see an error message stating "The application 'Font Downloader' can't be opened":

1. Make sure you've properly removed the quarantine flags (Step 2)
2. Check your Security & Privacy settings:
   - Open System Preferences
   - Go to Security & Privacy
   - Look for a message about "Font Downloader" being blocked
   - Click "Open Anyway" if available

3. Try running the following command in Terminal:
   ```
   chmod +x "/path/to/Font Downloader.app/Contents/MacOS/applet"
   ```
   (Replace "/path/to/" with the actual path to your app)

4. If the above steps don't work, try reinstalling the app

## Security Information
- This app has been properly code-signed with a Developer ID certificate
- The app has been notarized by Apple's security service
- The notarization ticket has been stapled to the app

## Support
If you continue to experience issues opening the app, please contact the developer for assistance.