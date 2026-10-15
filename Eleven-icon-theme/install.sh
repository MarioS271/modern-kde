#!/bin/sh

cd "$(dirname "$0")" || exit 1

ICONDIR="$HOME/.local/share/icons"

mkdir -p "$ICONDIR"
cp -r src/Eleven "$ICONDIR"
cp -r src/Eleven-Dark "$ICONDIR"
cp -r src/Eleven-Light "$ICONDIR"

exit 0
