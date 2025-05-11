#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/41/x86_64/repoview/index.html&protocol=https&redirect=1

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
# Edit the config to allow user access
tee /etc/snapper/configs/home-dir-backup <<'EOF'
ALLOW_USERS="user"
ALLOW_GROUPS="wheel"

# sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots
# directory
SYNC_ACL="no"


# start comparing pre- and post-snapshot in background after creating
# post-snapshot
BACKGROUND_COMPARISON="yes"


# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup
NUMBER_MIN_AGE="3600"
NUMBER_LIMIT="50"
NUMBER_LIMIT_IMPORTANT="10"


# create hourly snapshots
TIMELINE_CREATE="yes"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup
TIMELINE_MIN_AGE="3600"
TIMELINE_LIMIT_HOURLY="10"
TIMELINE_LIMIT_DAILY="10"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="10"
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="10"


# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="3600"
EOF
# Enable automatic snapshots & automatic cleaning of the snapshots
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleaner.timer
