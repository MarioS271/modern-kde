#!/bin/sh
# Copyright (C) 2026 the modern-kde authors (AI-assisted, see README.md)
# SPDX-License-Identifier: LGPL-3.0-only
#
# Removes what install.sh installed, using the uninstall scripts of the modules:
#   1. the icon themes Eleven, Eleven-Dark, Eleven-Light  (Eleven-icon-theme/uninstall.sh)
#   2. the style plugin, QML overlay and color scheme ElevenDark (application-style/tools/uninstall-eleven-kde.sh)
#   3. the Plasma desktop theme Windows11-Nord            (Win11Nord-kde/uninstall.sh --plasma-theme-only)
# Settings that still point to something removed are switched back (style to Breeze, color scheme to BreezeDark,
# Plasma style to default, icons to breeze), because the settings would otherwise point to nothing.
# Removing the plugin from the system directory needs sudo (once, for that file only).
# Usage: ./uninstall.sh [--keep-settings] [--dry-run]
#   --keep-settings   do not touch any setting
#   --dry-run         only print what would be done
set -u

root=$(cd "$(dirname "$0")" && pwd)
dry=0; keep=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry=1 ;;
        --keep-settings) keep=1 ;;
        -h|--help) sed -n '5,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "unknown option: $arg" >&2; exit 2 ;;
    esac
done

say() { printf '%s\n' "$*"; }
run() {
    if [ "$dry" -eq 1 ]; then say "  would run: $*"; else "$@"; fi
}

if [ "$(id -u)" -eq 0 ]; then
    echo "run this as your normal user, not as root" >&2
    exit 1
fi

# read the settings first, the module scripts must not be confused by changes in between
if command -v kreadconfig6 >/dev/null 2>&1; then
    plasma_theme=$(kreadconfig6 --file plasmarc --group Theme --key name)
    icon_theme=$(kreadconfig6 --file kdeglobals --group Icons --key Theme)
else
    plasma_theme=""; icon_theme=""
fi

eleven_args=""
[ "$keep" -eq 1 ] && eleven_args="--keep-style"
[ "$dry" -eq 1 ] && eleven_args="$eleven_args --dry-run"

say "=== 1/3 icon themes Eleven ==="
run sh "$root/Eleven-icon-theme/uninstall.sh"
say
say "=== 2/3 eleven-kde style, QML overlay and color scheme ElevenDark ==="
# shellcheck disable=SC2086
"$root/application-style/tools/uninstall-eleven-kde.sh" $eleven_args
say
say "=== 3/3 Plasma desktop theme Windows11-Nord ==="
run bash "$root/Win11Nord-kde/uninstall.sh" --plasma-theme-only
say

if [ "$keep" -eq 0 ] && command -v kwriteconfig6 >/dev/null 2>&1; then
    case "$icon_theme" in
        Eleven|Eleven-Dark|Eleven-Light)
            say "icon theme was $icon_theme, switching back to breeze"
            run kwriteconfig6 --file kdeglobals --group Icons --key Theme breeze ;;
    esac
    if [ "$plasma_theme" = "Windows11-Nord" ]; then
        say "Plasma style was Windows11-Nord, switching back to default"
        run kwriteconfig6 --file plasmarc --group Theme --key name default
    fi
fi

if [ "$dry" -eq 1 ]; then
    say "dry run, nothing was changed"
else
    say "done. Log out and in again so running sessions and the login environment are clean."
fi
