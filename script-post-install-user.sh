#!/bin/bash
set -euo pipefail

# Swap Fedora flatpak remotes (idempotent — ignore if already absent) for flathub at user scope
flatpak remote-delete --user --force fedora 2>/dev/null || true
flatpak remote-delete --user --force fedora-testing 2>/dev/null || true
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

# On KDE sessions, set the ApexOS wallpaper as the default. Skipped cleanly on GNOME
# (plasma-apply-wallpaperimage isn't present there, and XDG_CURRENT_DESKTOP won't match).
if [[ "${XDG_CURRENT_DESKTOP:-}" == *KDE* ]] && command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
    plasma-apply-wallpaperimage /usr/share/wallpapers/ApexOS || true
fi
