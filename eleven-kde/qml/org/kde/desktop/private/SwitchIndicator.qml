/*
    Based on org.kde.desktop.private from KDE's qqc2-desktop-style, modified for eleven-kde (AI-assisted).

    SPDX-FileCopyrightText: 2017 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2017 The Qt Company Ltd.
    SPDX-FileCopyrightText: 2022 Tanbir Jishan <tantalising007@gmail.com>
    SPDX-FileCopyrightText: 2026 the eleven-kde authors
    SPDX-License-Identifier: LGPL-3.0-only OR GPL-2.0-or-later
*/
// Toggle in the shape of the Win11Nord Plasma theme (widgets/switch.svg): a pill with a faint fill and a 1px
// outline, and a round knob (button background, 1px ring) that is bigger than the pill; sizes follow the font (gridUnit). When on, the pill is
// tinted with the accent color and gets an accent outline.
import QtQuick
import QtQuick.Templates as T
import org.kde.kirigami as Kirigami

Item {
    id: indicator
    implicitHeight: Kirigami.Units.gridUnit
    implicitWidth: Math.round(implicitHeight * 2.1)
    layer.enabled: control.opacity < 1.0

    property T.AbstractButton control
    property alias handle: handle

    Kirigami.Theme.colorSet: Kirigami.Theme.Button
    Kirigami.Theme.inherit: false

    readonly property bool checked: control.checked

    Rectangle {
        id: track
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Math.round(indicator.height * 0.14)
        anchors.rightMargin: Math.round(indicator.height * 0.14)
        height: Math.round(indicator.height * 0.7)
        radius: height / 2
        color: indicator.checked ? Qt.tint(Kirigami.Theme.backgroundColor, Qt.alpha(Kirigami.Theme.highlightColor, 0.5))
                                 : Qt.alpha(Kirigami.Theme.textColor, control.hovered ? 0.14 : 0.09)
        border.width: 1
        border.color: indicator.checked ? Kirigami.Theme.highlightColor
                                        : Qt.alpha(Kirigami.Theme.textColor, control.enabled ? 0.24 : 0.12)
        Behavior on color { ColorAnimation { duration: Kirigami.Units.shortDuration } }
    }

    Rectangle {
        id: handle
        width: indicator.height
        height: indicator.height
        radius: height / 2
        anchors.verticalCenter: parent.verticalCenter
        x: control.visualPosition * (indicator.width - width)
        color: Kirigami.Theme.backgroundColor
        border.width: 1
        border.color: Qt.alpha(Kirigami.Theme.textColor, control.enabled ? (control.hovered || control.pressed ? 0.5 : 0.3) : 0.15)
        opacity: control.enabled ? 1 : 0.6

        Behavior on x {
            enabled: !control.pressed && Kirigami.Units.shortDuration > 0
            SmoothedAnimation { duration: Kirigami.Units.shortDuration }
        }
    }
}
