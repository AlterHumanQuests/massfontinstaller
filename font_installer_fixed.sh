#!/bin/bash

# Font Mass Installer Script
# This script allows you to download and install multiple font files at once on macOS

# Set terminal colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}      FONT MASS INSTALLER TOOL       ${NC}"
echo -e "${YELLOW}======================================${NC}"

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}Error: This script is designed for macOS only.${NC}"
    exit 1
fi

# Font Library paths
USER_FONT_DIR="$HOME/Library/Fonts"
SYSTEM_FONT_DIR="/Library/Fonts"
TEMP_DIR="$HOME/Downloads/FontInstaller_Temp"

# Check if font directory exists, create if not
if [[ ! -d "$USER_FONT_DIR" ]]; then
    echo -e "${YELLOW}Creating user font directory at: ${NC}$USER_FONT_DIR"
    mkdir -p "$USER_FONT_DIR"
fi

# Create temp directory for downloads
mkdir -p "$TEMP_DIR"

# Function to install fonts from a directory
install_fonts_from_dir() {
    local font_dir="$1"
    local installed=0
    local skipped=0
    local failed=0
    
    # Check if directory exists
    if [[ ! -d "$font_dir" ]]; then
        echo -e "${RED}Error: Directory $font_dir does not exist.${NC}"
        return 1
    fi
    
    # Count font files - looking for common font extensions
    local font_count=$(find "$font_dir" -type f \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc" -o -iname "*.dfont" \) | wc -l | tr -d ' ')
    
    if [[ $font_count -eq 0 ]]; then
        echo -e "${RED}No font files found in the directory.${NC}"
        echo -e "${YELLOW}Supported formats: .ttf, .otf, .ttc, .dfont${NC}"
        return 1
    fi
    
    echo -e "\n${YELLOW}Found ${font_count} font files. Starting installation...${NC}"
    echo -e "${YELLOW}Fonts will be installed to: ${NC}$USER_FONT_DIR"
    
    # Install fonts
    echo -e "\n${YELLOW}Installing fonts...${NC}"
    
    find "$font_dir" -type f \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.ttc" -o -iname "*.dfont" \) | while read -r FONT_FILE; do
        FONT_NAME=$(basename "$FONT_FILE")
        
        # Check if font already exists
        if [[ -f "$USER_FONT_DIR/$FONT_NAME" ]]; then
            echo -e "${YELLOW}Skipping: ${NC}$FONT_NAME (already installed)"
            skipped=$((skipped + 1))
        else
            # Copy font to user's font directory
            if cp "$FONT_FILE" "$USER_FONT_DIR/"; then
                echo -e "${GREEN}Installed: ${NC}$FONT_NAME"
                installed=$((installed + 1))
            else
                echo -e "${RED}Failed to install: ${NC}$FONT_NAME"
                failed=$((failed + 1))
            fi
        fi
    done
    
    # Update font cache
    echo -e "\n${YELLOW}Updating font cache...${NC}"
    atsutil databases -removeUser
    atsutil server -shutdown
    atsutil server -ping
    
    # Installation summary
    echo -e "\n${YELLOW}======================================${NC}"
    echo -e "${YELLOW}      INSTALLATION SUMMARY           ${NC}"
    echo -e "${YELLOW}======================================${NC}"
    echo -e "${GREEN}Fonts installed: $installed${NC}"
    echo -e "${YELLOW}Fonts skipped: $skipped${NC}"
    echo -e "${RED}Fonts failed: $failed${NC}"
    echo -e "\n${GREEN}Font installation complete!${NC}"
    echo -e "${YELLOW}You may need to restart your applications to use the new fonts.${NC}"
    
    return 0
}

# Function to download and install fonts
download_and_install() {
    local url="$1"
    local name="$2"
    local filename="$TEMP_DIR/$(basename "$url")"
    
    echo -e "\n${YELLOW}Downloading ${name}...${NC}"
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: curl is not installed. Please install curl and try again.${NC}"
        return 1
    fi
    
    # Download the file
    if ! curl -L -o "$filename" "$url"; then
        echo -e "${RED}Error: Failed to download from $url${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Download complete!${NC}"
    
    # Extract if necessary based on file extension
    if [[ "$filename" == *.zip ]]; then
        echo -e "\n${YELLOW}Extracting ZIP archive...${NC}"
        local extract_dir="$TEMP_DIR/extracted_fonts"
        mkdir -p "$extract_dir"
        
        if ! unzip -q -o "$filename" -d "$extract_dir"; then
            echo -e "${RED}Error: Failed to extract ZIP file.${NC}"
            return 1
        fi
        
        echo -e "${GREEN}Extraction complete!${NC}"
        install_fonts_from_dir "$extract_dir"
        
    elif [[ "$filename" == *.tar.gz || "$filename" == *.tgz ]]; then
        echo -e "\n${YELLOW}Extracting tarball...${NC}"
        local extract_dir="$TEMP_DIR/extracted_fonts"
        mkdir -p "$extract_dir"
        
        if ! tar -xzf "$filename" -C "$extract_dir"; then
            echo -e "${RED}Error: Failed to extract tarball.${NC}"
            return 1
        fi
        
        echo -e "${GREEN}Extraction complete!${NC}"
        install_fonts_from_dir "$extract_dir"
        
    elif [[ "$filename" == *.ttf || "$filename" == *.otf || "$filename" == *.ttc || "$filename" == *.dfont ]]; then
        # Single font file
        echo -e "\n${YELLOW}Installing single font file...${NC}"
        local font_name=$(basename "$filename")
        
        if [[ -f "$USER_FONT_DIR/$font_name" ]]; then
            echo -e "${YELLOW}Skipping: ${NC}$font_name (already installed)"
        else
            if cp "$filename" "$USER_FONT_DIR/"; then
                echo -e "${GREEN}Installed: ${NC}$font_name"
                # Update font cache
                echo -e "\n${YELLOW}Updating font cache...${NC}"
                atsutil databases -removeUser
                atsutil server -shutdown
                atsutil server -ping
                echo -e "\n${GREEN}Font installation complete!${NC}"
            else
                echo -e "${RED}Failed to install: ${NC}$font_name"
            fi
        fi
    else
        echo -e "${RED}Error: Unsupported file format. Cannot process ${filename}${NC}"
        return 1
    fi
    
    return 0
}

# Function to display main menu
show_main_menu() {
    echo -e "\n${YELLOW}======================================${NC}"
    echo -e "${YELLOW}      SELECT AN OPTION               ${NC}"
    echo -e "${YELLOW}======================================${NC}"
    echo -e "${BLUE}1.${NC} Download and install fonts automatically"
    echo -e "${BLUE}2.${NC} Install fonts from a local directory"
    echo -e "${BLUE}3.${NC} Exit"
    echo -e "\n${YELLOW}Enter your choice (1-3):${NC} "
}

# Function to display font sources menu
show_font_sources() {
    echo -e "\n${YELLOW}======================================${NC}"
    echo -e "${YELLOW}      SELECT FONT PACKAGE            ${NC}"
    echo -e "${YELLOW}======================================${NC}"
    echo -e "${BLUE}1.${NC} Google Fonts - Popular Selection (Open Sans, Roboto, Lato, etc.)"
    echo -e "${BLUE}2.${NC} Programming Fonts Collection (JetBrains Mono, Fira Code, etc.)"
    echo -e "${BLUE}3.${NC} IBM Plex Font Family"
    echo -e "${BLUE}4.${NC} Source Sans Pro Font Family"
    echo -e "${BLUE}5.${NC} Ubuntu Font Family"
    echo -e "${BLUE}6.${NC} Inter Font Family"
    echo -e "${BLUE}7.${NC} Back to main menu"
    echo -e "\n${YELLOW}Enter your choice (1-7):${NC} "
}

# Main program loop
while true; do
    show_main_menu
    read -r MAIN_CHOICE
    
    case $MAIN_CHOICE in
        1)  # Download and install fonts automatically
            while true; do
                show_font_sources
                read -r FONT_CHOICE
                
                case $FONT_CHOICE in
                    1)  # Google Fonts Popular Selection
                        download_and_install "https://github.com/google/fonts/archive/main.zip" "Google Fonts Selection"
                        break
                        ;;
                    2)  # Programming Fonts
                        download_and_install "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip" "JetBrains Mono Nerd Font"
                        break
                        ;;
                    3)  # IBM Plex
                        download_and_install "https://github.com/IBM/plex/archive/refs/tags/v6.3.0.zip" "IBM Plex Font Family"
                        break
                        ;;
                    4)  # Source Sans Pro
                        download_and_install "https://github.com/adobe-fonts/source-sans/archive/refs/tags/3.046R.zip" "Source Sans Pro Font Family"
                        break
                        ;;
                    5)  # Ubuntu Font Family
                        download_and_install "https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip" "Ubuntu Font Family"
                        break
                        ;;
                    6)  # Inter Font Family
                        download_and_install "https://github.com/rsms/inter/releases/download/v3.19/Inter-3.19.zip" "Inter Font Family"
                        break
                        ;;
                    7)  # Back to main menu
                        break
                        ;;
                    *)
                        echo -e "${RED}Invalid choice. Please try again.${NC}"
                        ;;
                esac
            done
            
            # Cleanup temp files
            echo -e "\n${YELLOW}Cleaning up temporary files...${NC}"
            rm -rf "$TEMP_DIR"
            echo -e "${GREEN}Cleanup complete!${NC}"
            ;;
            
        2)  # Install fonts from a local directory - FIXED VERSION
            echo -e "\n${YELLOW}Enter the full path to your fonts directory:${NC}"
            echo -e "${YELLOW}(Example: /Users/username/Downloads/my_fonts)${NC}"
            read -r FONT_DIR
            
            # Check if input is empty
            if [[ -z "$FONT_DIR" ]]; then
                echo -e "${RED}No directory path provided. Returning to main menu.${NC}"
                continue
            fi
            
            # Remove quotes if present (in case user copied path with quotes)
            FONT_DIR=$(echo "$FONT_DIR" | sed "s/^['\"]\(.*\)['\"]$/\1/")
            
            echo -e "\n${YELLOW}Selected directory: ${NC}$FONT_DIR"
            install_fonts_from_dir "$FONT_DIR"
            ;;
            
        3)  # Exit
            echo -e "\n${GREEN}Thank you for using the Font Mass Installer Tool!${NC}"
            # Cleanup temp files
            rm -rf "$TEMP_DIR"
            exit 0
            ;;
            
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            ;;
    esac
    
    echo -e "\n${YELLOW}Press any key to continue...${NC}"
    read -n 1 -s
done