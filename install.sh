#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   GPU Switch Utility Installer        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo

# Check if running on Arch-based system
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}✗ Error: This script is designed for Arch-based systems.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Arch-based system detected${NC}"

# Check if envycontrol is installed
if ! command -v envycontrol &> /dev/null; then
    echo -e "${YELLOW}⚠ envycontrol not found. Installing...${NC}"
    
    # Check if yay is installed
    if command -v yay &> /dev/null; then
        yay -S --noconfirm envycontrol
    elif command -v paru &> /dev/null; then
        paru -S --noconfirm envycontrol
    else
        echo -e "${RED}✗ Error: AUR helper (yay or paru) not found.${NC}"
        echo "Please install envycontrol manually:"
        echo "  yay -S envycontrol"
        exit 1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ envycontrol installed successfully!${NC}"
    else
        echo -e "${RED}✗ Failed to install envycontrol.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ envycontrol is already installed${NC}"
fi

# Create directory if it doesn't exist
INSTALL_DIR="$HOME/.IGPU_DGPU_STITCH"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✓ Created directory: $INSTALL_DIR${NC}"

# Copy script to install directory
SCRIPT_PATH="$INSTALL_DIR/gpu_switch.sh"

if [ -f "gpu_switch.sh" ]; then
    cp gpu_switch.sh "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
    echo -e "${GREEN}✓ Script installed to $INSTALL_DIR${NC}"
else
    echo -e "${RED}✗ Error: gpu_switch.sh not found in current directory${NC}"
    exit 1
fi

# Create symlink
if [ -L "/usr/local/bin/gpu" ]; then
    echo -e "${YELLOW}⚠ Removing existing symlink...${NC}"
    sudo rm /usr/local/bin/gpu
fi

sudo ln -s "$SCRIPT_PATH" /usr/local/bin/gpu

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Symlink created: /usr/local/bin/gpu${NC}"
else
    echo -e "${RED}✗ Failed to create symlink. You may need sudo privileges.${NC}"
    exit 1
fi

# Optional: Configure sudoers for passwordless operation
echo
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -rp "Do you want to configure passwordless sudo for GPU switching? [y/N]: " configure_sudo

if [[ "$configure_sudo" =~ ^[Yy]$ ]]; then
    SUDOERS_FILE="/etc/sudoers.d/gpu-switch"
    ENVYCONTROL_PATH=$(which envycontrol)
    echo "$USER ALL=(ALL) NOPASSWD: $ENVYCONTROL_PATH, /usr/sbin/reboot" | sudo tee "$SUDOERS_FILE" > /dev/null
    sudo chmod 440 "$SUDOERS_FILE"
    echo -e "${GREEN}✓ Passwordless sudo configured!${NC}"
else
    echo -e "${YELLOW}⚠ Skipped passwordless sudo configuration${NC}"
    echo -e "${YELLOW}  You will need to enter your password when switching GPUs${NC}"
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo -e "${BLUE}Available commands:${NC}"
echo -e "  ${GREEN}gpu -igpu${NC}     - Switch to Intel iGPU only (battery saving)"
echo -e "  ${GREEN}gpu -dgpu${NC}     - Switch to NVIDIA dGPU only (performance)"
echo -e "  ${GREEN}gpu -hybrid${NC}   - Switch to Hybrid mode (both GPUs)"
echo -e "  ${GREEN}gpu -state${NC}    - Show current GPU mode"
echo -e "  ${GREEN}gpu -help${NC}     - Show help message"
echo
echo -e "${YELLOW}Note: Restart your terminal or run 'hash -r' to use the gpu command${NC}"