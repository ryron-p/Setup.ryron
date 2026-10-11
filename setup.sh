#!/bin/bash

#exit 1 - Erro com a senha sudo.
#exit 2 - Erro com o instalador de pacotes.



flatpak_available=0
#flatpak_available=0   # Flatpak encontrado.
#flatpak_available=1   # Flatpak não encontrado. 

n=0 # Escolha de tipos de intalação


# Install Setups
# 0 = none 
# 1 = install                
game_setup=0 
work_setup=0 
leisure_setup=0

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


echo "--- INSTALADOR DE AMBIENTE FLATPAK ---"

echo "Tipo de instalação:"
echo "1. Completa"
echo "2. Apenas trabalho"
echo "3. Apenas jogos"
echo "4. Apenas lazer"
read -p "Digite um número (1..4) -> " n

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
    echo "Opção inválida. Abortando o programa..."
    exit
fi



# Requisitando Senha
sudo -v || { echo "Senha incorreta ou sudo indisponível. Abortando."; exit 1; }

# Renovando permissão root automaticamente
while true; do sudo -n true; sleep 50; kill -0 "$$" || exit; done 2>/dev/null &
KEEP_ALIVE_PID=$!

#Verificando a existência do comando flatpak
command -v flatpak >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "-- Flatpak encontrado!"
    
    else
        echo "-- Flatpak não encontrado."
        echo "-- Tentando baixar.."
        flatpak_available=1
    
    
    for inst in "${install[@]}"; do 
        
        sudo $inst flatpak
        
        if [ $? -eq 0 ]; then
            echo "[+] Flatpak Instalado."
            flatpak_available=0
            break
        fi

    done
        # Falha de instalação: Encerrando o programa
        if [ $flatpak_available -eq 1 ]; then
            echo "Seu instalador não conseguiu baixar o Flatpak."
            echo "Encerrando programa..."
            exit 2
        fi
fi



# Adiciona rota flathub para downloads
if flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1; then
    echo "[+] Rota para o repositório flathub verificada/adicionada."
else
    echo "[-] Erro ao tentar verificar/adicionar a rota para o repositório flathub"
fi


#----------------------#
#---   Instalação   ---#
#----------------------#


if [ $work_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_work_setup[@]}"; do
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
fi

if [ $game_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_game_setup[@]}"; do
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
fi

if [ $leisure_setup -eq 1 ]; then
    for flatpak_item in "${flatpak_install_leisure_setup[@]}"; do
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
fi

echo "--- INTALADOR DE AMBIENTE FLATPAK FINALIZADO ---"

kill $KEEP_ALIVE_PID