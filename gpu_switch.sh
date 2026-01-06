#!/bin/bash

STATE_FILE="$HOME/.IGPU_DGPU_STITCH/.gpu_state"

confirm_reboot() {
    read -rp "Reboot now to apply changes? [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo "Rebooting..."
        sudo reboot
    else
        echo "Reboot canceled. Please reboot manually later."
    fi
}

get_state() {
    envycontrol --query | awk '{print $NF}'
}

show_help() {
    echo "GPU Switch Utility"
    echo
    echo "Usage:"
    echo "  gpu -igpu     Switch to Intel iGPU only"
    echo "  gpu -dgpu     Switch to NVIDIA dGPU only"
    echo "  gpu -hybrid   Switch to Hybrid (Intel + NVIDIA)"
    echo "  gpu -state    Show current GPU mode"
    echo "  gpu -help     Show this help message"
}

case "$1" in
    -igpu)
        echo "Switching to Intel iGPU only..."
        sudo envycontrol -s integrated || exit 1
        echo "integrated" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to Intel iGPU. Reboot required."
        confirm_reboot
        ;;

    -dgpu)
        echo "Switching to NVIDIA dGPU only..."
        sudo envycontrol -s nvidia || exit 1
        echo "nvidia" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to NVIDIA dGPU. Reboot required."
        confirm_reboot
        ;;

    -hybrid)
        echo "Switching to Hybrid mode..."
        sudo envycontrol -s hybrid || exit 1
        echo "hybrid" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to Hybrid mode. Reboot required."
        confirm_reboot
        ;;

    -state)
        echo "Current GPU mode: $(get_state)"
        ;;

    -help|--help|-h|"")
        show_help
        ;;

    *)
        echo "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
esac
