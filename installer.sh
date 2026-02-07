#!/bin/bash

# Stop execution if a critical error occurs
set -e

# --- COLORS FOR AESTHETICS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- SAFETY CHECK: ROMS FOLDER ---
CURRENT_FOLDER_NAME=$(basename "$PWD")

if [ "$CURRENT_FOLDER_NAME" != "roms" ]; then
    echo -e ""
    echo -e "${RED}#########################################################${NC}"
    echo -e "${RED}    CRITICAL ERROR: SAFETY PROTECTION TRIGGERED          ${NC}"
    echo -e "${RED}#########################################################${NC}"
    echo -e ""
    echo -e "${BOLD}Current folder:${NC} $CURRENT_FOLDER_NAME"
    echo -e "This script must be run ONLY inside the ${YELLOW}'roms'${NC} folder."
    echo -e "Please move this script and try again."
    echo -e ""
    read -p "Press [ENTER] to close..."
    kill -9 $PPID
    exit 1
fi

# --- START INSTALLATION ---
clear
echo -e "${BLUE}=======================================================${NC}"
echo -e "${BOLD}          RGSX INSTALLER FOR STEAM DECK               ${NC}"
echo -e "${BLUE}=======================================================${NC}"
echo -e ""

INSTALL_DIR="$(pwd)"
TEMP_DIR=$(mktemp -d)

# 1. DOWNLOAD
echo -e "${BLUE}[1/5]${NC} Downloading repository from GitHub..."
curl -L -s "https://github.com/RetroGameSets/RGSX/archive/refs/heads/main.zip" -o "$TEMP_DIR/repo.zip"

# 2. EXTRACTION AND CONFIGURATION
echo -e "${BLUE}[2/5]${NC} Extracting and configuring files..."
unzip -q "$TEMP_DIR/repo.zip" -d "$TEMP_DIR"
EXTRACTED_FOLDER="$TEMP_DIR/RGSX-main"

# Remove old installation if present
if [ -d "$INSTALL_DIR/RGSX" ]; then
    rm -rf "$INSTALL_DIR/RGSX"
fi

# Move ports -> RGSX
if [ -d "$EXTRACTED_FOLDER/ports" ]; then
    mv "$EXTRACTED_FOLDER/ports" "$INSTALL_DIR/RGSX"
    
    # SILENT CLEANUP (No output messages)
    rm -rf "$INSTALL_DIR/RGSX/images"
    rm -rf "$INSTALL_DIR/RGSX/videos"
    rm -f  "$INSTALL_DIR/RGSX/gamelist.xml"
else
    echo -e "${RED}[ERROR]${NC} 'ports' folder not found in download!"
    rm -rf "$TEMP_DIR"
    read -p "Press [ENTER] to close..."
    kill -9 $PPID
    exit 1
fi

# 3. CREATE LAUNCHER
echo -e "${BLUE}[3/5]${NC} Creating optimized launcher script..."
TARGET_DIR="$INSTALL_DIR/RGSX/RGSX"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}[ERROR]${NC} Inner RGSX folder structure is incorrect."
    exit 1
fi

TARGET_SCRIPT="$TARGET_DIR/RGSX_Deck.sh"

cat << 'EOF' > "$TARGET_SCRIPT"
#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

if [ -f /.flatpak-info ] && command -v flatpak-spawn > /dev/null; then
    exec flatpak-spawn --host "$0" "$@"
fi

export SDL_VIDEODRIVER=x11
export DISPLAY=:0

if [ ! -f "venv/bin/python3" ]; then
    python3 -m venv venv --without-pip
fi

if [ ! -f "venv/bin/pip" ]; then
    curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    ./venv/bin/python3 get-pip.py > /dev/null
    rm get-pip.py
fi

./venv/bin/python3 -c "import pygame" 2>/dev/null || ./venv/bin/pip install -q pygame requests pillow

if [ -f "Python/__main__.py" ]; then
    ./venv/bin/python3 Python/__main__.py
else
    ./venv/bin/python3 __main__.py
fi
EOF

chmod +x "$TARGET_SCRIPT"

# 4. DOWNLOAD ASSETS
echo -e "${BLUE}[4/5]${NC} Downloading Steam Assets..."
ASSET_DIR="$INSTALL_DIR/RGSX/steam_asset"
mkdir -p "$ASSET_DIR"

# Silent download
curl -L -s "https://i.ibb.co/vCwgy6Hx/Header-Capsule-920x430.png" -o "$ASSET_DIR/Header-Capsule-920x430.png"
curl -L -s "https://i.ibb.co/gFVdym0M/Vertical-Capsule-748x896.png" -o "$ASSET_DIR/Vertical-Capsule-748x896.png"
curl -L -s "https://i.ibb.co/gZfx5kyc/Page-Background-1438x810.png" -o "$ASSET_DIR/Page-Background-1438x810.png"

# 5. FINALIZATION
echo -e "${BLUE}[5/5]${NC} Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

echo -e ""
echo -e "${GREEN}=======================================================${NC}"
echo -e "${BOLD}              INSTALLATION COMPLETED!                 ${NC}"
echo -e "${GREEN}=======================================================${NC}"
echo -e ""
echo -e " Location: ${YELLOW}$INSTALL_DIR/RGSX/${NC}"
echo -e " Launcher: ${YELLOW}.../RGSX/RGSX/RGSX_Deck.sh${NC}"
echo -e " Assets:   ${YELLOW}.../RGSX/steam_asset/${NC}"
echo -e ""
echo -e "${BOLD}--- HOW TO ADD TO STEAM LIBRARY ---${NC}"
echo -e "1. Open Steam in Desktop Mode."
echo -e "2. Go to: ${BOLD}Games -> Add a Non-Steam Game${NC}."
echo -e "3. Click ${BOLD}Browse...${NC}"
echo -e "4. Navigate to: ${YELLOW}$TARGET_DIR${NC}"
echo -e "5. Select file: ${GREEN}RGSX_Deck.sh${NC}"
echo -e "6. Click ${BOLD}Add Selected Programs${NC}."
echo -e ""
echo -e "${BOLD}--- OPTIONAL: CUSTOM ARTWORK ---${NC}"
echo -e "Use images inside the ${YELLOW}steam_asset${NC} folder to customize"
echo -e "the game banner and cover in Steam properties."
echo -e ""
echo -e "${BLUE}=======================================================${NC}"
echo -e ""
# --- WAIT FOR USER INPUT BEFORE KILLING THE TERMINAL ---
read -p "Press [ENTER] to close this window..."
kill -9 $PPID
