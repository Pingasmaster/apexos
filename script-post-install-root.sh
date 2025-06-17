#!/bin/bash
# Creates the config for the automatic backups of the user drive
snapper -c home-dir-backup create-config /home
# Enables the services for that
systemctl enable --now snapper-cleanup.timer
systemctl enable --now snapper-timeline.timer
# Removes stupid fedora flatpaks and installs flathub, both on system and user profiles
flatpak remote-delete --system --force fedora
flatpak remote-delete --system --force fedora-testing
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
# Recompile glib schemas to apply default wallpapers
glib-compile-schemas /usr/share/glib-2.0/schemas/
rm -f /etc/script-post-install-root.sh
