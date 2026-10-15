#!/bin/sh
# Copyright (C) 2026 the eleven-kde authors (AI-assisted, see README.md)
# SPDX-License-Identifier: LGPL-3.0-only
#
# Builds two Debian/Ubuntu packages into dist/ from the current build:
#   eleven-kde      the style plugin (installs into the system Qt plugin directory)
#   eleven-kde-qml  optional QML overlay (gray lists, popups and switch for QtQuick apps such as System Settings);
#                   it copies the system org.kde.desktop module on install and whenever that module changes
# The plugin uses Qt private API, so the packages depend on the Qt version they were built against.
# Usage: tools/build-deb.sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
build=$root/build
out=$root/dist
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

cmake -S "$root" -B "$build" -DCMAKE_BUILD_TYPE=Release >/dev/null
cmake --build "$build"

version=$(sed -n 's/^project(eleven-kde VERSION \([0-9.]*\).*/\1/p' "$root/CMakeLists.txt")
arch=$(dpkg --print-architecture)
qt=$(dpkg-query -W -f='${Version}' libqt6widgets6 | sed 's/+dfsg.*//; s/-.*//')   # e.g. 6.10.2
qtnext=$(echo "$qt" | awk -F. '{print $1"."$2"."$3+1}')
qtdep() { echo "$1 (>= $qt), $1 (<< $qtnext)"; }
plugdir=$(qmake6 -query QT_INSTALL_PLUGINS)

umask 022
mkdir -p "$out"
rm -f "$out"/eleven-kde*_"$version"_*.deb

doc() { # $1 = package root, $2 = package name
    install -d "$1/usr/share/doc/$2"
    install -m644 "$root/README.md" "$1/usr/share/doc/$2/README.md"
    cat > "$1/usr/share/doc/$2/copyright" <<C
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: eleven-kde
Files: *
Copyright: 2026 the eleven-kde authors (AI-assisted, see README.md)
License: LGPL-3.0-only
 The full text is in /usr/share/common-licenses/LGPL-3 (Qt derived files keep Qt's LGPL/GPL choice, QML files keep
 KDE's licenses, see the SPDX headers in the sources).
C
}

# ---- eleven-kde ----
p=$stage/eleven-kde
install -D -m755 "$build/plugins/styles/eleven-kde.so" "$p$plugdir/styles/eleven-kde.so"
strip --strip-unneeded "$p$plugdir/styles/eleven-kde.so"
doc "$p" eleven-kde
install -d "$p/DEBIAN"
cat > "$p/DEBIAN/control" <<C
Package: eleven-kde
Version: $version
Section: kde
Priority: optional
Architecture: $arch
Depends: kde-style-breeze, $(qtdep libqt6core6t64), $(qtdep libqt6gui6), $(qtdep libqt6widgets6)
Recommends: eleven-kde-qml
Maintainer: eleven-kde authors <noreply@invalid>
Description: Windows 11 (WinUI 3) inspired Qt 6 widget style for KDE Plasma
 QProxyStyle on top of Breeze with rounded controls, translucent gray fills and gray hover highlights.
 Built against Qt $qt private API: it only works with that Qt version (dependencies are pinned accordingly).
 Select it in System Settings > Appearance > Application Style.
C
dpkg-deb --root-owner-group --build "$p" "$out/eleven-kde_${version}_${arch}.deb" >/dev/null

# ---- eleven-kde-qml ----
q=$stage/eleven-kde-qml
install -d "$q/usr/share/eleven-kde" "$q/etc/xdg/plasma-workspace/env" "$q/DEBIAN"
cp -a "$root/qml" "$q/usr/share/eleven-kde/qml"
chmod -R go-w,a+rX "$q/usr/share/eleven-kde/qml"
install -m755 "$root/tools/make-qml-overlay.sh" "$q/usr/share/eleven-kde/make-qml-overlay.sh"
cat > "$q/etc/xdg/plasma-workspace/env/eleven-kde-qml.sh" <<'C'
# eleven-kde-qml: let QtQuick apps (System Settings, ...) pick up the eleven-kde QML overlay
export QML_IMPORT_PATH="/var/lib/eleven-kde/qml-overlay${QML_IMPORT_PATH:+:$QML_IMPORT_PATH}"
C
doc "$q" eleven-kde-qml
cat > "$q/DEBIAN/control" <<C
Package: eleven-kde-qml
Version: $version
Section: kde
Priority: optional
Architecture: all
Depends: eleven-kde (>= $version), qml6-module-org-kde-desktop
Maintainer: eleven-kde authors <noreply@invalid>
Description: QML overlay for eleven-kde (switch, gray list highlights, popups)
 Copies the system org.kde.desktop QML module and replaces a few files, so Kirigami/QtQuick Controls apps match the
 eleven-kde style. Active after the next login (Plasma exports QML_IMPORT_PATH).
C
echo "/etc/xdg/plasma-workspace/env/eleven-kde-qml.sh" > "$q/DEBIAN/conffiles"
echo "interest-noawait /usr/lib/x86_64-linux-gnu/qt6/qml/org/kde/desktop" > "$q/DEBIAN/triggers"
cat > "$q/DEBIAN/postinst" <<'C'
#!/bin/sh
set -e
case "$1" in
    configure|triggered)
        ELEVEN_QML_SRC=/usr/share/eleven-kde/qml /usr/share/eleven-kde/make-qml-overlay.sh /var/lib/eleven-kde/qml-overlay >/dev/null
        ;;
esac
exit 0
C
cat > "$q/DEBIAN/postrm" <<'C'
#!/bin/sh
set -e
case "$1" in
    remove|purge) rm -rf /var/lib/eleven-kde/qml-overlay; rmdir /var/lib/eleven-kde 2>/dev/null || true ;;
esac
exit 0
C
chmod 755 "$q/DEBIAN/postinst" "$q/DEBIAN/postrm"
dpkg-deb --root-owner-group --build "$q" "$out/eleven-kde-qml_${version}_all.deb" >/dev/null

ls -l "$out"/*.deb
