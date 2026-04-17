#!/bin/bash
set -euo pipefail

# Swap Fedora flatpak remotes (idempotent — ignore if already absent) for flathub at user scope
flatpak remote-delete --user --force fedora 2>/dev/null || true
flatpak remote-delete --user --force fedora-testing 2>/dev/null || true
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
