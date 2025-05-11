#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

# Installs needed packages from fedora repos
rpm-ostree install screen vlc python python-pip plymouth-plugin-script snapper
# Remove firefox
rpm-ostree override remove firefox firefox-langpacks

# Build apexOS theme from python script (declines an image in 202 images with various lightning to make the logo glow on boot)
python /temp/rpm-custom-plymouth-theme/apex/fade-apex.py
cp -r /temp/rpm-custom-plymouth-theme/apex/ /usr/share/plymouth/themes/

# Remove fedora flatpak repos
flatpak remote-delete --system fedora
flatpak remote-delete --system fedora-testing
# Add flathub as the default source
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# Clear gnome software cache to make sure the repo is removed
rm -rf /var/cache/flatpak /var/lib/flatpak/appstream

# Tests
# Maybe install homebrew for macOS appslike Arc? no, there's a module for that.
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Maybe install ollama if ever needed? But the Alpaca app replaces it
#curl -fsSL https://ollama.com/install.sh | sh

# Create snapper config
snapper -c home-dir-backup create-config /home
# Make it user-manageable
chmod a+rx /home/.snapshots
# Enable automatic snapshots & automatic cleaning of the snapshots
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleaner.timer
