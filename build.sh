#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/41/x86_64/repoview/index.html&protocol=https&redirect=1

# Installs needed packages from fedora repos
rpm-ostree install screen vlc python python-pip plymouth-plugin-script

# Build apexOS theme from python script (declines an image in 202 images with various lightning to make the logo glow on boot)
python /temp/rpm-custom-plymouth-theme/apex/fade-apex.py

# Build apexOS theme as a rpm to install it and layer it on the immutable distro otherwise it will get reset on next boot
# First have a tar image of the plymouth theme
mkdir -p /temp/rpm-custom-plymouth-theme/rpmbuild/SOURCES/ /temp/rpm-custom-plymouth-theme/rpmbuild/RPMS/noarch/
tar -cvf /temp/rpm-custom-plymouth-theme/rpmbuild/SOURCES/apex.tar.gz /temp/rpm-custom-plymouth-theme/apex
# Encapsulate in a RPM package
rpmbuild -ba /temp/rpm-custom-plymouth-theme/rpmbuild/SPECS/apex-plymouth-theme.spec
# Install the RPM package
ls -lh /temp/rpm-custom-plymouth-theme/ /temp/rpm-custom-plymouth-theme/apex/ /temp/rpm-custom-plymouth-theme/rpmbuild/RPMS/noarch/
rpm-ostree install /temp/rpm-custom-plymouth-theme/rpmbuild/RPMS/noarch/apex-plymouth-theme-*
# Apply the plymouth theme
plymouth-set-default-theme -R apex
# Regenerate initramfs
rpm-ostree initramfs --enable

# Maybe install homebrew for macOS appslike Arc? no, there's a module for that.
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Maybe install ollama if ever needed? But the Alpaca app replaces it
#curl -fsSL https://ollama.com/install.sh | sh

#### Example for enabling a System Unit File

#systemctl enable podman.socket
