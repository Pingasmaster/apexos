#!/bin/bash
set -euo pipefail

# Create snapper config + .snapshots subvolume for /home, then apply our tuned settings
snapper -c home-dir-backup create-config /home
install -m 600 -o root -g root /etc/apexos/home-dir-backup.conf /etc/snapper/configs/home-dir-backup
rm -f /etc/apexos/home-dir-backup.conf
rmdir --ignore-fail-on-non-empty /etc/apexos || true

# Enable the snapper cleanup/timeline timers
systemctl enable --now snapper-cleanup.timer
systemctl enable --now snapper-timeline.timer

# Remove Fedora flatpak remotes (idempotent — ignore if already absent) and install flathub
flatpak remote-delete --system --force fedora 2>/dev/null || true
flatpak remote-delete --system --force fedora-testing 2>/dev/null || true
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

rm -f /etc/script-post-install-root.sh
