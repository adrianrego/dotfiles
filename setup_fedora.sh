#!/bin/bash

#==============================================================================
#
#         FILE: fedora-ultimate-install-script.sh
#        USAGE: sudo fedora-ultimate-install-script.sh
#
#  DESCRIPTION: Post-installation install script for Fedora 29/30/31 Workstation
#      WEBSITE: https://github.com/David-Else/fedora-ultimate-setup-script
#
# REQUIREMENTS: Fresh copy of Fedora 29/30/31 installed on your computer
#               https://dl.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/
#       AUTHOR: David Else
#      COMPANY: https://www.elsewebdevelopment.com/
#      VERSION: 3.0
#==============================================================================

#==============================================================================
# script settings and checks
#==============================================================================
set -euo pipefail
exec 2> >(tee "error_log_$(date -Iseconds).txt")

GREEN=$(tput setaf 2)
BOLD=$(tput bold)
RESET=$(tput sgr0)
USR_HOME=$(grep ${SUDO_USER} /etc/passwd | cut -d ":" -f6)


if [ "$(id -u)" != 0 ]; then
    echo "You're not root! Use sudo ./setup_fedora.sh" && exit 1
fi

if [[ $(rpm -E %fedora) -lt 29 ]]; then
    echo >&2 "You must install at least ${GREEN}Fedora 29${RESET} to use this script" && exit 1
fi

# >>>>>> start of user settings <<<<<<

#==============================================================================
# packages to remove
#==============================================================================
packages_to_remove=()

#==============================================================================
# common packages to install *arrays can be left empty, but don't delete them
#==============================================================================
dnf_packages_to_install=(
    awscli
    bat
    bluez
    bluez-obexd
    bluez-tools
    bzip2
    cargo
    curl
    dkms
    dnf-plugins-core
    docker-compose
    fzf
    gcc
    gcc-c++
    git
    google-chrome
    htop
    kernel-headers
    kernel-devel
    kubernetes-client
    kitty
    libstdc++-static
    lsd
    make
    mesa-va-drivers-freeworld
    mesa-vdpau-drivers-freeworld
    neovim
    nodejs
    podman
    podman-docker
    ripgrep
    rust
    steam
    stow
    wget
    tmux
    toolbox
    unzip
    util-linux-user
    zsh)

flathub_packages_to_install=(
    com.bitwarden.desktop
    com.getpostman.Postman
    com.github.wwmm.easyeffects
    com.github.xournalpp.xournalpp
    org.darktable.Darktable
    org.fedoraproject.MediaWriter
    org.filezillaproject.Filezilla
    org.gimp.GIMP
    org.gnome.SoundRecorder
    org.inkscape.Inkscape
    org.qgis.qgis
    us.zoom.Zoom)
# >>>>>> end of user settings <<<<<<

#==============================================================================
# display user settings
#==============================================================================
cat <<EOL
${BOLD}Packages to install${RESET}
${BOLD}-------------------${RESET}

DNF packages: ${GREEN}${dnf_packages_to_install[*]}${RESET}

Flathub packages: ${GREEN}${flathub_packages_to_install[*]}${RESET}

${BOLD}Packages to remove${RESET}
${BOLD}------------------${RESET}
DNF packages: ${GREEN}${packages_to_remove[*]}${RESET}

EOL
read -rp "Press enter to install, or ctrl+c to quit"


#==============================================================================
# add repositories
#==============================================================================
echo "${BOLD}Adding repositories...${RESET}"
dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#==============================================================================
# install packages
#==============================================================================
echo "${BOLD}Removing unwanted programs...${RESET}"
dnf -y remove "${packages_to_remove[@]}"

echo "${BOLD}Updating Fedora, enabling module streams...${RESET}"
dnf -y --refresh upgrade

echo "${BOLD}Installing packages...${RESET}"
dnf -y install "${dnf_packages_to_install[@]}"

# Codecs
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
dnf group upgrade --with-optional Multimedia

echo "${BOLD}Installing flathub packages...${RESET}"
flatpak install -y flathub "${flathub_packages_to_install[@]}"

echo "${BOLD}Installing Hashicorp products...${RESET}"
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
dnf install -y terraform packer

echo "${BOLD}Installing Starship prompt...${RESET}"
sh -c "$(curl -fsSL https://starship.rs/install.sh)"

cat <<EOL
  =================================================================
  Congratulations, everything is installed!

  Now use the setup script...
  =================================================================
EOL
