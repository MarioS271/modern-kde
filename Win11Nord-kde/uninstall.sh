 #!/bin/bash

ROOT_UID=0

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LAYOUT_DIR="/usr/share/plasma/layout-templates"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LAYOUT_DIR="$HOME/.local/share/plasma/layout-templates"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Win11Nord

# --plasma-theme-only: remove only the Plasma desktop theme (the one install.sh --plasma-theme-only installs)
PLASMA_ONLY=0
[[ "$1" == "--plasma-theme-only" ]] && PLASMA_ONLY=1

uninstall() {
  local name=${1}

  local AURORAE_THEME="${AURORAE_DIR}/${name}"
  local PLASMA_THEME="${PLASMA_DIR}/Windows11-Nord"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.yeyushengfan258.${name}"

  if [[ -d ${PLASMA_THEME} ]]; then
    echo "removing ${PLASMA_THEME}"
    rm -rf ${PLASMA_THEME}
  fi
  [[ ${PLASMA_ONLY} -eq 1 ]] && return 0
  [[ -d ${AURORAE_THEME} ]] && rm -rfv ${AURORAE_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rfv ${LOOKFEEL_THEME}
  [[ -d ${KVANTUM_THEME}/${name} ]] && rm -rfv ${KVANTUM_THEME}/${name}
  [[ -d ${SCHEMES_DIR}/${name}.colors ]] && rm -rfv ${SCHEMES_DIR}/${name}.colors
  [[ -d ${WALLPAPER_DIR}/Layan ]] && rm -rfv ${WALLPAPER_DIR}/{Win11Nord-light,Win11Nord-dark}
}

echo "Uninstalling '${THEME_NAME} kde themes'..."

uninstall "${name:-${THEME_NAME}}"

echo "Uninstall finished..."
