#!/bin/sh
# Copyright (C) 2026 the eleven-kde authors (AI-assisted, see README.md)
# SPDX-License-Identifier: LGPL-3.0-only
#
# Builds a QML overlay: copies the system QML module(s) listed below and puts the files of qml/ (same relative paths)
# over them.
# Usage: make-qml-overlay.sh [output-dir]   (default: <project>/build/qml-overlay)
# Use it with QML_IMPORT_PATH=<output-dir> (import paths win over the system modules).
# ELEVEN_QML_SRC overrides where our qml/ files come from (the Debian package ships them outside the source tree).
set -e
root=$(cd "$(dirname "$0")/.." && pwd)
sysroot=/usr/lib/x86_64-linux-gnu/qt6/qml
dest=${1:-$root/build/qml-overlay}
src=${ELEVEN_QML_SRC:-$root/qml}
modules="org/kde/desktop"

rm -rf "$dest"
for m in $modules; do
    [ -d "$sysroot/$m" ] || { echo "system module not found: $sysroot/$m" >&2; exit 1; }
    mkdir -p "$dest/$m"
    cp -a "$sysroot/$m"/. "$dest/$m"/
    # the system modules prefer the QML compiled into their libraries; drop that so our files on disk are used
    find "$dest/$m" -name qmldir -exec sed -i '/^prefer /d' {} +
done
cp -a "$src/org" "$dest"/
echo "overlay ready: $dest"
