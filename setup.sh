#!/bin/bash

#exit 1 - Erro com a senha sudo.
#exit 2 - Erro com o instalador de pacotes.


#has_flatpak=0   # tem flatpak
#has_flatpak=1   # não tem, precisa baixar
#has_flatpak=2   # tentou baixar, pode ter falhado
#has_flatpak=3   # conseguiu instalar

has_flatpak=0

install=("dnf install -y" "apt install -y" "yum install -y" "pacman -S --noconfirm" "zypper install -y" "emerge" "apk add" "pkg install -y" "brew install -y" "snap install -y") 

echo "--- INSTALADOR DE AMBIENTE FLATPAK ---"

#Verificando a existência do comando flatpak
command -v flatpak >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-- Flatpak encontrado!"
else
    echo "-- Flatpak não encontrado."
    echo "-- Tentando baixar.."
    has_flatpak=1
fi


# Requisitando Senha
sudo -v || { echo "Senha incorreta ou sudo indisponível. Abortando."; exit 1; }

# Renovando permissão root automaticamente
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
KEEP_ALIVE_PID=$!

# Instalando Flatpak
if [ $has_flatpak -eq 1 ]; then
    has_flatpak=2
    for inst in "${install[@]}"; do
    sudo $inst flatpak

        if [ $? -eq 0 ]; then
            echo "[+] Flatpak Instalado."
            has_flatpak=3
            break
        fi

    done
fi
# Adiciona rota flathub para downloads
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1
echo "[+] Rota para o repositório flathub verificada."


# Encerrando com falha de instalação
if [ $has_flatpak -eq 2 ]; then
    echo "Seu instalador não conseguiu baixar o Flatpak."
    echo "Encerrando processo..."
    exit 2
fi



# Flatpak Install
# -- Work Apps
# Flatseal
# Obsidian 
# Visual Studio Code
# Only Office
# Timer
# VLC
# Tor Browser
# Brave Browser
# qBittorrent
# MKVToolNix
# RustDesk
# Foliate
# Rufin
# Tenacity
# Proton VPN

# -- Game Apps
# Sober
# Steam
# Missingno
# RPCS3
# Heroic
# XClicker

flatpak_install_apps=(
    "com.github.tchx84.Flatseal"
    "md.obsidian.Obsidian"
    "com.visualstudio.code"
    "org.onlyoffice.desktopeditors"
    "com.github.vikdevelop.timer"
    "org.videolan.VLC"
    "org.torproject.torbrowser-launcher"
    "com.brave.Browser"
    "org.qbittorrent.qBittorrent"
    "org.bunkus.mkvtoolnix-gui"
    "com.rustdesk.RustDesk"
    "com.github.johnfactotum.Foliate"
    "io.github.screwys.Rufin"
    "org.tenacityaudio.Tenacity"
    "com.protonvpn.www"
    "org.vinegarhq.Sober"
    "com.valvesoftware.Steam"
    "net.andyofniall.missingno"
    "net.rpcs3.RPCS3"
    "com.heroicgameslauncher.hgl"
    "xyz.xclicker.xclicker"
    )

for flatpak_item in "${flatpak_install_apps[@]}"; do
    if flatpak info "$flatpak_item" >/dev/null 2>&1; then
        echo "[=] Já instalado: $flatpak_item"

    else
        flatpak install -y flathub "$flatpak_item"
        if [ $? -eq 0 ]; then
            echo "[+] Instalado com sucesso: $flatpak_item"
            else
            echo "[X] Erro inexperado com o pacote: $flatpak_item"
        fi
    fi
done

echo "--- INTALADOR DE AMBIENTE FLATPAK FINALIZADO ---"

kill $KEEP_ALIVE_PID