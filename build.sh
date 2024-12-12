#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/41/x86_64/repoview/index.html&protocol=https&redirect=1

# Installs the screen package from fedora repos for advanced users
rpm-ostree install screen vlc wget curl flatpak

# Maybe install homebrew for macOS appslike Arc?
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Maybe install ollama if ever needed? But the Alpaca app replaces it
#curl -fsSL https://ollama.com/install.sh | sh

#### Example for enabling a System Unit File

#systemctl enable podman.socket
