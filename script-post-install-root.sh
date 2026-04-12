#!/bin/bash
set -euo pipefail

# Creates the config for the automatic backups of the user drive
snapper -c home-dir-backup create-config /home
# Enables the services for that
systemctl enable --now snapper-cleanup.timer
systemctl enable --now snapper-timeline.timer
# Remove Fedora flatpak remotes (idempotent — ignore if already absent) and install flathub
flatpak remote-delete --system --force fedora 2>/dev/null || true
flatpak remote-delete --system --force fedora-testing 2>/dev/null || true
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# Recompile glib schemas to apply default wallpapers
glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -f /etc/script-post-install-root.sh
