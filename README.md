# Font Mass Installer

This tool allows you to download and install multiple font files into your system with ease.

## Features

- Download popular free font collections directly from the internet
- Install fonts from a local directory in a single operation
- Automatically handles font extraction and installation
- Skips fonts that are already installed
- Updates the system font cache automatically
- Requires no administrator privileges

## How to Use

1. Double-click the `font_installer_fixed.sh` file on your desktop
   - If you get a security warning, right-click (or Control-click) the file and select "Open"
   - Select "Open" when prompted

2. Choose from the main menu options:
   - **Download and install fonts automatically** - Choose from a curated list of popular free font collections
   - **Install fonts from a local directory** - Select a folder containing font files you already have
   - **Exit** - Close the application

3. If you choose to download fonts automatically:
   - Select a font package from the available options
   - The script will download, extract, and install the fonts automatically
   - Wait for the process to complete

4. If you choose to install from a local directory:
   - Select a folder containing font files (.ttf, .otf, .ttc, or .dfont)
   - You can drag the folder containing the font files directly into the terminal window
   - Wait for the process to complete

5. When finished, you'll see a summary of:
   - Number of fonts installed
   - Number of fonts skipped (already installed)
   - Number of fonts that failed to install (if any)

## Available Font Packages

The following font packages are available for automatic download:

1. **Google Fonts - Popular Selection** - A collection of popular Google fonts including Open Sans, Roboto, Lato, and more
2. **Programming Fonts Collection** - Fonts optimized for coding including JetBrains Mono, Fira Code, and others
3. **IBM Plex Font Family** - IBM's open-source corporate typeface
4. **Source Sans Pro Font Family** - Adobe's open-source sans serif font family
5. **Ubuntu Font Family** - The official font family of the Ubuntu operating system
6. **Inter Font Family** - A modern typeface designed for computer screens

## Notes

- Fonts are installed to your user's font directory (`~/Library/Fonts`)
- You may need to restart applications to see the newly installed fonts
- No system-level permissions are required as this script only modifies your user font directory
- Internet connection is required for the automatic download option

## Troubleshooting

If the script doesn't run:
1. Open Terminal (Applications > Utilities > Terminal)
2. Type: `chmod +x /Users/mac/Desktop/font_installer.sh`
3. Try running the script again

If downloads fail:
1. Check your internet connection
2. Try a different font package
3. If problems persist, try the "Install fonts from a local directory" option instead

If you encounter any issues or have questions, please let me know!
