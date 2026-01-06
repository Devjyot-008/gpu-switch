# 🎮 GPU Switch Utility

A simple and elegant command-line utility to switch between Intel iGPU and NVIDIA dGPU on Arch Linux laptops with hybrid graphics (NVIDIA Optimus).

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Arch%20Linux-blue.svg)

## ✨ Features

- 🔄 Easy switching between Intel iGPU, NVIDIA dGPU, and Hybrid modes
- 🎯 Simple command-line interface
- 🔔 Desktop notifications
- 💾 State tracking
- ⚡ Automatic reboot confirmation
- 🔒 Optional passwordless sudo configuration

## 📋 Requirements

- Arch Linux (or Arch-based distribution)
- NVIDIA Optimus laptop (Intel iGPU + NVIDIA dGPU)
- AUR helper (yay or paru)

## 🚀 Installation
```bash
git clone https://github.com/Devjyot-008/gpu-switch.git
cd gpu-switch
chmod +x install.sh
./install.sh
```

The installer will:
- Install `envycontrol` if not already installed
- Copy the script to `~/.IGPU_DGPU_STITCH/`
- Create a system-wide `gpu` command
- Optionally configure passwordless sudo

## 📖 Usage
```bash
gpu -igpu     # Switch to Intel iGPU only (better battery life)
gpu -dgpu     # Switch to NVIDIA dGPU only (maximum performance)
gpu -hybrid   # Hybrid mode (both GPUs available, on-demand)
gpu -state    # Show current GPU mode
gpu -help     # Show help message
```

### Examples

**Save battery on the go:**
```bash
gpu -igpu
```

**Gaming or heavy workload:**
```bash
gpu -dgpu
```

**Balanced mode:**
```bash
gpu -hybrid
```

## 🗑️ Uninstallation
```bash
cd gpu-switch
chmod +x uninstall.sh
./uninstall.sh
```

Or manually:
```bash
sudo rm /usr/local/bin/gpu
rm -rf ~/.IGPU_DGPU_STITCH
sudo rm /etc/sudoers.d/gpu-switch
```

## ⚙️ How It Works

This utility uses [envycontrol](https://github.com/bayasdev/envycontrol) under the hood to manage GPU switching on Optimus laptops. It provides a user-friendly wrapper with:

- State persistence
- Interactive confirmations
- Desktop notifications
- Clean command-line interface

## 🔧 Tested On

- Arch Linux with Hyprland
- end-4 dotfiles
- Intel Core i5 13th Gen + RTX 3050

Should work on any Arch-based system with NVIDIA Optimus.

## ⚠️ Notes

- A reboot is required after switching GPU modes
- The script creates a state file in `~/.IGPU_DGPU_STITCH/.gpu_state`
- Works with Wayland compositors (Hyprland, Sway, etc.)

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## 📜 License

MIT License - feel free to use and modify as needed.

## 🙏 Credits

- Built on top of [envycontrol](https://github.com/bayasdev/envycontrol)
- Inspired by the need for simple GPU switching on Linux

---

Made with ❤️ for the Arch Linux community
