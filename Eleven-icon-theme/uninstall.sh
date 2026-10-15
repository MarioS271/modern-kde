#!/bin/sh
# Removes what install.sh copied to ~/.local/share/icons (the three themes Eleven, Eleven-Dark and Eleven-Light).

ICONDIR="$HOME/.local/share/icons"

for theme in Eleven Eleven-Dark Eleven-Light; do
    if [ -d "$ICONDIR/$theme" ]; then
        echo "removing $ICONDIR/$theme"
        rm -rf "$ICONDIR/$theme"
    fi
done

exit 0
