#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/41/x86_64/repoview/index.html&protocol=https&redirect=1

# Installs needed packages from fedora repos
rpm-ostree install screen vlc python python-pip plymouth-plugin-script rpm-build

# Build apexOS theme from python script (declines an image in 202 images with various lightning to make the logo glow on boot)
python /temp/rpm-custom-plymouth-theme/apex/fade-apex.py
cp -r /temp/rpm-custom-plymouth-theme/apex/ /usr/share/plymouth/themes/
# Apply the plymouth theme
#plymouth-set-default-theme -R apex
# Regenerate initramfs
rpm-ostree initramfs --enable


# Tests
# Maybe install homebrew for macOS appslike Arc? no, there's a module for that.
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Maybe install ollama if ever needed? But the Alpaca app replaces it
#curl -fsSL https://ollama.com/install.sh | sh

#### Example for enabling a System Unit File

#systemctl enable podman.socket


# Remove rpm-build
rpm-ostree remove rpm-build
