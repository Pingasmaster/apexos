#!/bin/bash
set -euo pipefail

# Adds needed user flatpaks sources
flatpak remote-delete --user --force fedora 2>/dev/null || true
flatpak remote-delete --user --force fedora-testing 2>/dev/null || true
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
# This file is needed because it allows the system to launch .exe automatically via wine.
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/wine.desktop <<EOF
[Desktop Entry]
Name=Wine
Comment=Run Windows applications
Exec=wine %f
Terminal=false
Type=Application
MimeType=application/x-ms-dos-executable
NoDisplay=true
EOF
# Once this file is installed, update the desktop db and set wine as the default handler for .exe
update-desktop-database ~/.local/share/applications
xdg-mime default wine.desktop application/x-ms-dos-executable
rm -f /etc/script-post-install-user.sh
