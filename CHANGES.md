# Changes to third-party code

This file states what was changed in the parts of this repository that come from other people's projects, as the
licenses (GPL-3.0 section 5(a), LGPL) ask for. The exact data is in [`licenses/changes/`](licenses/changes/). The
original git histories of the three folders were removed when this repository was created; copies of them are not part
of this repository (the commit list of `eleven-kde` is in `licenses/changes/eleven-kde-commit-history.txt`).

All changes below were made on or before **2026-10-15**. The recoloring and the new music emblem in the icon theme
and almost everything in `eleven-kde` were made with the help of an AI assistant (Claude), see the notice in the
[README](README.md). Who made the other edits (the `Win11Nord-kde` scripts and the four earlier icon edits) was not
recorded.

## Win11Nord-kde

Upstream: <https://github.com/yeyushengfan258/Win11Nord-kde> by yeyushengfan258, GPL-3.0. Baseline: commit
`76a2993f92b50002295e7f9782c743eac77d9795`. Full diff: [`licenses/changes/Win11Nord-kde.patch`](licenses/changes/Win11Nord-kde.patch).

| File                                                                          | Change                                                                                             |
|-------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------|
| `install.sh`                                                                  | after copying the desktop theme, delete leftover `panel-background.svg(z)` files of older installs |
| `uninstall.sh`                                                                | file mode changed from 644 to 755, no content change                                               |
| `plasma/desktoptheme/Windows11-Nord/widgets/panel-background.svg`             | removed                                                                                            |
| `plasma/desktoptheme/Windows11-Nord/translucent/widgets/panel-background.svg` | removed                                                                                            |
| `plasma/desktoptheme/Windows11-Nord/solid/widgets/panel-background.svg`       | removed                                                                                            |

The reason for removing the panel background is in the comment added to `install.sh`: without it Plasma falls back to
Breeze's panel background, which keeps the tray and clock spacing correct. Nothing else in this folder was edited. It
is in this repository as the visual reference for `eleven-kde`, not as part of it.

## Eleven-icon-theme

Upstream: <https://github.com/mjkim0727/Eleven-icon-theme>, GPL-3.0, "successor of Cobalt-icons". Baseline: commit
`3e0a65fb4d69c4493347ac08fd5c51922898dc95` (2026-05-30). Upstream commit authors are in
`licenses/changes/Eleven-icon-theme-upstream-authors.txt`.

| What                                        | Files                                                                                                            | Detail                                                                                                                                                                                                                                                            |
|---------------------------------------------|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Symbolic icons made follow the color scheme | 267 files in `src/Eleven/*/symbolic/`, list in `licenses/changes/Eleven-icon-theme-recolored-symbolic-icons.txt` | the fixed dark gray `#363636` was replaced by `currentColor`, the `ColorScheme-Text` class was added to every shape and group, and KDE's `current-color-scheme` style element was added, so KDE can recolor them. Without this they stay dark gray on dark panels |
| `emblem-music-symbolic` replaced            | 7 files, list in `licenses/changes/Eleven-icon-theme-music-emblem.txt`                                           | the flat 16 px gray note was replaced by a colored tile with a white note (16, 22 and 24 px; new files in `emblems/` and `symbolic/emblems/`). This is a new drawing                                                                                              |
| Earlier local edits                         | 4 files, diff in `licenses/changes/Eleven-icon-theme-earlier-local-edits.patch`                                  | `window-close.svg`, `window-close-symbolic.svg`, `view-more-symbolic.svg`, `view-more-horizontal-symbolic.svg`: the same kind of change (color scheme stylesheet), made before the changes above                                                                  |

The recoloring was checked by rendering every converted icon with a replaced stylesheet color (none stayed black). It
was not checked in a running Plasma session beyond that.

## eleven-kde

This is the main project of this repository, not a copy. It is derived from:

* Qt's `QWindows11Style` and `QCommonStyle` (`qtbase`, tag v6.10.2), ported to Linux and changed to run on top of Breeze.
  The drawing code in `src/elevenstyle.cpp` still follows Qt's structure and many comments are Qt's.
* KDE's `qqc2-desktop-style` (`org.kde.desktop`): four QML files in `eleven-kde/qml/` replace the originals.
* KDE's `plasma-nm`: `eleven-kde/kcm/kcm_networkmanagement/qml/ConnectionItem.qml` is a modified copy of the page.

Files with a modified-from notice carry it in their SPDX header. The commit history up to the import is in
`licenses/changes/eleven-kde-commit-history.txt` (14 commits by the AI assistant, 1 by the repository owner). The
working tree at import time also contained uncommitted changes, listed in
`licenses/changes/eleven-kde-uncommitted-at-import.txt`; they are part of the first commit of this repository:
scrollbar, slider and toggle in the shape of the Win11Nord theme, gray buttons without a rest fill, a restyled
autocomplete list, `tools/build-deb.sh` and the `GALLERY_DARK` option of the demo.
