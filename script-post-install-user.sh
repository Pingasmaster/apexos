#!/bin/bash
# Adds needed user flatpaks sources
flatpak remote-delete --user --force fedora
flatpak remote-delete --user --force fedora-testing
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
# This file is needed because it allows the system to launch .exe automatically via wine.
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
# Once this file is installed, these two commands are run to update and set wine by default for .exe in the file explorer:
update-desktop-database ~/.local/share/applications
xdg-mime default wine.desktop application/x-ms-dos-executable
rm -f /etc/script-post-install-user.sh
