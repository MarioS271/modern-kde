# Licenses

This repository bundles three separate projects. They are **not** one work under one license: each keeps the license it
came with. This folder collects every license text that applies to something in the repository, and
[`changes/`](changes/) records what was changed in the third-party parts (see also [`../CHANGES.md`](../CHANGES.md)).

The original license files are still in place inside each project folder, untouched.

## Which license applies where

| Path                                                                        | License (SPDX)                                                                                                                     | Text in this folder                                    |
|-----------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|
| `application-style/src/`, `tools/`, `CMakeLists.txt`                        | `LGPL-3.0-only`                                                                                                                    | `LGPL-3.0-only.txt`                                    |
| `application-style/src/elevenstyle.cpp`, `elevenstyle.h` (Qt-derived parts) | `LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only` (the commercial Qt alternative cannot be granted here) | `LGPL-3.0-only.txt`, `GPL-3.0-only.txt`, `GPL-2.0.txt` |
| `application-style/qml/`                                                    | `LGPL-3.0-only OR GPL-2.0-or-later` (derived from KDE's qqc2-desktop-style)                                                        | `LGPL-3.0-only.txt`, `GPL-2.0.txt`                     |
| `application-style/kcm/kcm_networkmanagement/qml/ConnectionItem.qml`        | `LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL` (derived from plasma-nm)                                          | `LGPL-2.1.txt`, `LGPL-3.0-only.txt`                    |
| `application-style/color-schemes/ElevenDark.colors`                         | `LGPL-2.0-or-later` (SPDX header of the file, copied from KDE's Breeze Dark; modified, see CHANGES.md)                             | `LGPL-2.0.txt`                                         |
| `Eleven-icon-theme/`                                                        | `GPL-3.0` as shipped by the upstream project                                                                                       | `Eleven-icon-theme.LICENSE`                            |
| `Win11Nord-kde/`                                                            | `GPL-3.0` as shipped by the upstream project                                                                                       | `Win11Nord-kde.LICENSE`, `Win11Nord-kde.AUTHORS`       |
| `Win11Nord-kde/sddm/6.0/Windows11-Nord/*.qml`                               | `LGPL-2.0-or-later` (derived from KDE's Breeze SDDM theme)                                                                         | `LGPL-2.0.txt`                                         |

`GPL-3.0-only.txt` and `Eleven-icon-theme.LICENSE` / `Win11Nord-kde.LICENSE` are the same license; the project copies are
kept as they were shipped so the exact upstream wording is preserved.

## Things this folder cannot settle

These are facts about the sources, not legal conclusions:

* **Eleven-icon-theme** lists *Segoe Fluent*, *Fluent-icon-theme* and *Cobalt-icons* as its sources (see its README). The
  licenses of those projects are not part of the upstream repository and are not included here. Segoe Fluent Icons is
  a Microsoft font and is not under a free license. Whether the icon shapes in `Eleven-icon-theme/` may be
  redistributed under GPL-3.0 was **not** checked by the author of this repository.
* **Win11Nord-kde**: the SDDM theme's `metadata.desktop` says `License=CC-BY-SA` without a version, while the project
  as a whole ships GPL-3.0. The CC-BY-SA text is not included because the version is not stated. The Kvantum theme in
  it is credited to "Vince Liuice, based on KvAdapta by Tsu Jan" and carries no license text of its own. The
  wallpapers and images in it were not checked.
* Names of Microsoft, Qt and KDE products are used descriptively only. This repository is not affiliated with or endorsed
  by Microsoft, KDE, or The Qt Company.

If you are an author of any of the upstream projects and something here is wrong or unwanted, please open an issue.
