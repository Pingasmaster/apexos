snapper -c home-dir-backup create-config /home
systemctl enable --now snapper-cleanup.timer
systemctl enable --now snapper-timeline.timer
flatpak remote-delete --system --force fedora
flatpak remote-delete --system --force fedora-testing
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo
