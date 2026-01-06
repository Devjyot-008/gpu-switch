#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   GPU Switch Utility Uninstaller      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo

read -rp "Are you sure you want to uninstall GPU Switch Utility? [y/N]: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled.${NC}"
    exit 0
fi

echo

# Remove symlink
if [ -L "/usr/local/bin/gpu" ]; then
    sudo rm /usr/local/bin/gpu
    echo -e "${GREEN}✓ Removed symlink: /usr/local/bin/gpu${NC}"
else
    echo -e "${YELLOW}⚠ Symlink not found${NC}"
fi

# Remove directory
if [ -d "$HOME/.IGPU_DGPU_STITCH" ]; then
    rm -rf "$HOME/.IGPU_DGPU_STITCH"
    echo -e "${GREEN}✓ Removed directory: ~/.IGPU_DGPU_STITCH${NC}"
else
    echo -e "${YELLOW}⚠ Directory not found${NC}"
fi

# Remove sudoers file
if [ -f "/etc/sudoers.d/gpu-switch" ]; then
    sudo rm /etc/sudoers.d/gpu-switch
    echo -e "${GREEN}✓ Removed sudoers configuration${NC}"
else
    echo -e "${YELLOW}⚠ Sudoers file not found${NC}"
fi

echo
echo -e "${GREEN}✓ Uninstallation complete!${NC}"
echo -e "${YELLOW}Note: envycontrol was not removed. To remove it manually:${NC}"
echo -e "  yay -R envycontrol"