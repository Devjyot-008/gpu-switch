#!/bin/bash

STATE_FILE="$HOME/.IGPU_DGPU_STITCH/.gpu_state"
##============confirm reboot===============
confirm_reboot() {
    read -rp "Reboot now to apply changes? [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo "Rebooting..."
        sudo reboot
    else
        echo "Reboot canceled. Please reboot manually later."
    fi
}
#============================================

#===========current state=====================
get_state() {
    envycontrol --query 2>/dev/null | awk '{print $NF}'
}
#=============================================

#==============confirmation=====================
confirm_switch() {
    local target_mode="$1"
    read -rp "Switch to $target_mode mode? [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        return 0
    else
        echo "Operation canceled."
        return 1
    fi
}
#=============================================

#===============state============================
check_already_in_state() {
    local target_state="$1"
    local current_state
    current_state=$(get_state)
    
    if [[ "$current_state" == "$target_state" ]]; then
        echo "Already in $target_state mode. No changes needed."
        return 0
    fi
    return 1
}
#===============================================

#==============help option======================
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
#=================================================

#==============Directory===========================
mkdir -p "$(dirname "$STATE_FILE")"
#==================================================
#===============option=========================
case "$1" in
    -igpu)
        check_already_in_state "integrated" && exit 0
        confirm_switch "Intel iGPU" || exit 0
        echo "Switching to Intel iGPU only..."
        sudo envycontrol -s integrated || exit 1
        echo "integrated" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to Intel iGPU. Reboot required."
        confirm_reboot
        ;;

    -dgpu)
        check_already_in_state "nvidia" && exit 0
        confirm_switch "NVIDIA dGPU" || exit 0
        echo "Switching to NVIDIA dGPU only..."
        sudo envycontrol -s nvidia || exit 1
        echo "nvidia" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to NVIDIA dGPU. Reboot required."
        confirm_reboot
        ;;

    -hybrid)
        check_already_in_state "hybrid" && exit 0
        confirm_switch "Hybrid" || exit 0
        echo "Switching to Hybrid mode..."
        sudo envycontrol -s hybrid || exit 1
        echo "hybrid" > "$STATE_FILE"
        notify-send "GPU Switch" "Switched to Hybrid mode. Reboot required."
        confirm_reboot
        ;;

    -state)
        current_mode=$(get_state)
        if [[ -n "$current_mode" ]]; then
            echo "Current GPU mode: $current_mode"
        else
            echo "Unable to determine current GPU mode. Is envycontrol installed?"
            exit 1
        fi
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
#=============================================================