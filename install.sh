#!/bin/sh
# Copyright (C) 2026 the modern-kde authors (AI-assisted, see README.md)
# SPDX-License-Identifier: LGPL-3.0-only
#
# Installs, and only installs (nothing is selected or applied for you):
#   1. the Plasma desktop theme Windows11-Nord         (Win11Nord-kde/install.sh --plasma-theme-only)
#   2. the Qt widget style eleven-kde, its QML overlay and the color scheme ElevenDark
#                                                      (application-style/tools/install-eleven-kde.sh --no-style)
#   3. the icon themes Eleven, Eleven-Dark, Eleven-Light (Eleven-icon-theme/install.sh)
# Everything goes into your user directories except the style plugin, which needs the system Qt plugin directory:
# for that the script asks sudo once. Run it as your user, not as root (and from a terminal, sudo needs one).
# Usage: ./install.sh [--dry-run]
#   --dry-run   only print what would be done
set -eu

root=$(cd "$(dirname "$0")" && pwd)
dry=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry=1 ;;
        -h|--help) sed -n '5,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done

say() { printf '%s\n' "$*"; }
run() {
    if [ "$dry" -eq 1 ]; then say "  would run: $*"; else "$@"; fi
}

if [ "$(id -u)" -eq 0 ]; then
    echo "run this as your normal user, not as root: it installs into your home directory and asks sudo only for the style plugin" >&2
    exit 1
fi

eleven_args=--no-style
[ "$dry" -eq 1 ] && eleven_args="$eleven_args --dry-run"

say "=== 1/3 Plasma desktop theme Windows11-Nord ==="
run bash "$root/Win11Nord-kde/install.sh" --plasma-theme-only
say
say "=== 2/3 eleven-kde style, QML overlay and color scheme ElevenDark ==="
# shellcheck disable=SC2086
"$root/application-style/tools/install-eleven-kde.sh" $eleven_args
say
say "=== 3/3 icon themes Eleven ==="
run sh "$root/Eleven-icon-theme/install.sh"
say

if [ "$dry" -eq 1 ]; then
    say "dry run, nothing was changed"
else
    say "done. Nothing is switched on yet, choose in System Settings:"
    say "  Appearance > Application Style > eleven-kde"
    say "  Appearance > Colors > Eleven Dark"
    say "  Appearance > Plasma Style > Windows11-Nord"
    say "  Appearance > Icons > Eleven"
    say "Log out and in again afterwards (the QML overlay and the running KDE services need it)."
fi
