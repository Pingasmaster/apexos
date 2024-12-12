#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/41/x86_64/repoview/index.html&protocol=https&redirect=1

# Installs the screen package from fedora repos for advanced users
rpm-ostree install screen

## Tier 0 : Needed apps
# Adds the remote flathub repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Flatseal for flatpak permissions management
flatpak install flathub com.github.tchx84.Flatseal
# For extensions management
flatpak install flathub com.mattjakeman.ExtensionManager
# Warehouse for flatpak apps management
flatpak install flathub io.github.flattool.Warehouse
# Bottles for Windows apps compatiblity
flatpak install flathub com.usebottles.bottles
# Gearlever to manage AppImages
flatpak install flathub it.mijorus.gearlever

## Tier 1: Heavily Recommended apps
# Impression for flahsing USB drives
flatpak install flathub io.gitlab.adhami3310.Impression
# Steam adwaita theme
flatpak install flathub io.github.Foldex.AdwSteamGtk
# Steam for games
flatpak install flathub com.valvesoftware.Steam
# Libreoffice for documents edition
flatpak install flathub org.libreoffice.LibreOffice
# Gapless for music
flatpak install flathub com.github.neithern.g4music
# Gnome simple texte editor
flatpak install flathub org.gnome.TextEditor
# Librewolf for a browser
flatpak install flathub io.gitlab.librewolf-community
# Addwater for browser adwaita theming
flatpak install flathub dev.qwery.AddWater
# Ungoogled Chromium for secondary browser
flatpak install flathub io.github.ungoogled_software.ungoogled_chromium
# GIMP for image edition
flatpak install flathub org.gimp.GIMP
# Gwenview for image edition
flatpak install flathub org.kde.gwenview
# Anytypes for beautiful notes
flatpak install flathub io.anytype.anytype
# Upscayl for upscaling images
flatpak install flathub org.upscayl.Upscayl
# Fragments for torrents
flatpak install flathub de.haeckerfelix.Fragments
# Hidamari for video wallpapers
flatpak install flathub io.github.jeffshee.Hidamari
# Mandatory calculator
flatpak install flathub org.gnome.Calculator
# Metadata cleaner
flatpak install flathub fr.romainvigier.MetadataCleaner
# Steam Link to stream games from another PC
flatpak install flathub com.valvesoftware.SteamLink


## Tier 2: Cool apps
# Teams app for linux
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
# Collision to check files hashes
flatpak install flathub dev.geopjr.Collision
# For ASCII art
flatpak install flathub dev.geopjr.Calligraphy
# Onlyoffice for advanced powerpoint management, to replace libreoffice by default???
flatpak install flathub org.onlyoffice.desktopeditors
# Countpile for an item counter
flatpak install flathub garden.turtle.Jellybean
# Signal for desktop messages
flatpak install flathub org.signal.Signal
# Alpaca for local AI
flatpak install flathub com.jeffser.Alpaca
# Maps for places to go to
flatpak install flathub org.gnome.Maps
# Railway for trains info
flatpak install flathub de.schmidhuberj.DieBahn

## Tier 3: Optionnal apps for demonstration purposes
# OBS for video recording
flatpak install flathub com.obsproject.Studio
# Kdenlive for video editing
flatpak install flathub org.kde.kdenlive
# Davinci resolve for video editing
# ProtonVPN for free VPN
flatpak install flathub com.protonvpn.www
# Parabolic for downloading videos from the internet
flatpak install flathub org.nickvision.tubeconverter
# Android Studio to showcase android dev capabilities
flatpak install flathub com.google.AndroidStudio
# Tor Browser for obvious reasons
flatpak install flathub org.torproject.torbrowser-launcher
# Blender for 3d design
flatpak install flathub org.blender.Blender
# FreeCAD also for 3d design but CAD
flatpak install flathub org.freecad.FreeCAD
# Audacity for music and audio editing
flatpak install flathub org.audacityteam.Audacity
# KeePassXC for passwor manager
flatpak install flathub org.keepassxc.KeePassXC
# Bitwarden for password manager
flatpak install flathub com.bitwarden.desktop
# Protonmail for mail
flatpak install flathub me.proton.Mail
# Elements for secure matrix chats
https://flathub.org/apps/im.riot.Riot
# Parsec for low latency gaming
flatpak install flathub com.parsecgaming.parsec
# Rustdesk for remote desktop access
flatpak install flathub com.rustdesk.RustDesk



# this would install a package from rpmfusion
rpm-ostree install vlc brew

#### Example for enabling a System Unit File

#systemctl enable podman.socket
