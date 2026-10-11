#!/bin/bash

# exit 1 - Sudo Error
# exit 2 - Package Installer Error.

# flatpak_available=0   # Found Flatpak.
# flatpak_available=1   # Not found Flatpak. 
flatpak_available=0

# Type of installation (1..4)
n=0 


# Install Setups
# 0 = none 
# 1 = install                
game_setup=0 
work_setup=0 
leisure_setup=0

# List of package installers
install=(
    "dnf install -y"
    "apt install -y"
    "yum install -y"
    "pacman -S --noconfirm"
    "zypper install -y"
    "emerge" "apk add"
    "pkg install -y"
    "brew install -y"
    "snap install -y"
    ) 
flatpak_install_work_setup=(
    "com.github.tchx84.Flatseal"
    "md.obsidian.Obsidian"
    "com.visualstudio.code"
    "org.onlyoffice.desktopeditors"
    "com.github.vikdevelop.timer"
    "org.torproject.torbrowser-launcher"
    "com.brave.Browser"
    "com.rustdesk.RustDesk"
    "org.tenacityaudio.Tenacity"
)
flatpak_install_game_setup=(
    "org.vinegarhq.Sober"
    "com.valvesoftware.Steam"
    "net.andyofniall.missingno"
    "net.rpcs3.RPCS3"
    "com.heroicgameslauncher.hgl"
    "xyz.xclicker.xclicker"
    )
flatpak_install_leisure_setup=(
    "org.bunkus.mkvtoolnix-gui"
    "com.github.johnfactotum.Foliate"
    "io.github.screwys.Rufin"
    "org.qbittorrent.qBittorrent"
    "org.videolan.VLC"
)

# --- Flatpak Install Apps
# -- Work Apps
# Flatseal
# Obsidian 
# Visual Studio Code
# Only Office
# Timer
# Tor Browser
# Brave Browser
# RustDesk
# Tenacity

# -- Game Apps
# Sober
# Steam
# Missingno
# RPCS3
# Heroic
# XClicker

# -- Leisure Apps
# MKVToolNix
# Foliate
# Rufin
# qBittorrent
# VLC


echo "=== FLATPAK INSTALLER ==="

echo "Type of installation:"
echo "1. Full"
echo "2. Work only"
echo "3. Games only"
echo "4. Leisure only"
read -p "Enter a number (1..4) -> " n

if [ $n -eq 1 ]; then
    game_setup=1
    work_setup=1
    leisure_setup=1
elif [ $n -eq 2 ]; then
    work_setup=1
elif [ $n -eq 3 ]; then
    game_setup=1
elif [ $n -eq 4 ]; then
    leisure_setup=1
else
    echo "Invalid option. Closing program..."
    exit
fi



# Password Request
sudo -v || { echo "Incorrect password or sudo required. Aborting."; exit 1; }

# Automatically renew root permission
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
KEEP_ALIVE_PID=$!

# Checking for the existence of the flatpak command
command -v flatpak >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-- Flatpak found!"
    
    else
        echo "-- Flatpak not found."
        echo "-- Trying install.."
        flatpak_available=1
    
    
    for inst in "${install[@]}"; do 
        
        sudo $inst flatpak
        
        if [ $? -eq 0 ]; then
            echo "[+] Flatpak Installed."
            flatpak_available=0
            break
        fi

    done
        # Installation Failed: Terminating the Program
        if [ $flatpak_available -eq 1 ]; then
            echo "Your package manager was unable to download Flatpak."
            echo "Closing program..."
            exit 2
        fi
fi



# Adding flathub route to flatpak
if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1; then
    echo "[+] Route to flathub repository checked/added."
else
    echo "[-] Error when trying to check/add route to flathub repository"
fi


#--- Installation

# Messages
msg_already_installed="[=] Already installed"
msg_successfully_installed="[+] Installed successfully"
msg_unexpected_error="[X] Unexpected error with package"

# Work Setup
if [ $work_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_work_setup[@]}"; do
        if flatpak info "$flatpak_item" >/dev/null 2>&1; then
            echo "$msg_already_installed: $flatpak_item"

        else
            flatpak install -y flathub "$flatpak_item"
            if [ $? -eq 0 ]; then
                echo "$msg_successfully_installed: $flatpak_item"
                else
                echo "$msg_unexpected_error: $flatpak_item"
            fi
        fi
    done
fi

# Games Setup
if [ $game_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_game_setup[@]}"; do
        if flatpak info "$flatpak_item" >/dev/null 2>&1; then
            echo "$msg_already_installed: $flatpak_item"

        else
            flatpak install -y flathub "$flatpak_item"
            if [ $? -eq 0 ]; then
                echo "$msg_successfully_installed: $flatpak_item"
                else
                echo "$msg_unexpected_error: $flatpak_item"
            fi
        fi
    done
fi

# Leisure Setup
if [ $leisure_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_leisure_setup[@]}"; do
        if flatpak info "$flatpak_item" >/dev/null 2>&1; then
            echo "$msg_already_installed: $flatpak_item"

        else
            flatpak install -y flathub "$flatpak_item"
            if [ $? -eq 0 ]; then
                echo "$msg_successfully_installed: $flatpak_item"
                else
                echo "$msg_unexpected_error: $flatpak_item"
            fi
        fi
    done
fi

echo "=== FLATPAK INSTALLER FINISHED ==="

kill $KEEP_ALIVE_PID