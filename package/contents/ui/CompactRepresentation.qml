/*
*   Copyright 2019-2024 Panagiotis Panagiotopoulos <panagiotopoulos.git@gmail.com>
*
* 	This file is part of MediaBar.
*
*   MediaBar is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   MediaBar is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with MediaBar. If not, see <https://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PC
import org.kde.kirigami as Kirigami

MouseArea {
    id: compactRepresentation

    Layout.fillHeight: true

    Layout.minimumWidth: root.minWidth
    Layout.maximumWidth: root.maxWidth
    Layout.preferredWidth: row.width

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton

    onClicked: mouse => {
         if (!root.loaded) {
            return;
        }
        switch (mouse.button) {
            case Qt.LeftButton:
                root.togglePlaying();
                break;
            case Qt.BackButton:
                if (root.canGoPrevious) {
                    root.previous();
                }
                break;
            case Qt.ForwardButton:
                if (root.canGoNext) {
                    root.next();
                }
                break;
            default:
                root.expanded = !root.expanded;
        }
    }

    property int wheelDelta: 0

    onWheel: wheel => {
        if (!root.loaded) {
            return;
        }
        wheelDelta += (wheel.inverted ? -1 : 1) * (wheel.angleDelta.y ? wheel.angleDelta.y : -wheel.angleDelta.x)
        while (wheelDelta >= 120) {
            wheelDelta -= 120;
            root.seekForward();
        }
        while (wheelDelta <= -120) {
            wheelDelta += 120;
            root.seekBack();
        }
    }

    RowLayout {
        id: row
        spacing: 0
        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        Kirigami.Icon {
            visible: root.showStatusIcon
            id: icon
            color: Kirigami.Theme.textColor
            implicitHeight: Math.min(compactRepresentation.height, Kirigami.Units.iconSizes.medium)
            implicitWidth: implicitHeight
            source: plasmoid.icon
        }

        PC.Label {
            visible: root.loaded
            text: (root.artist ? root.artist + " - " : "") + root.track
            textFormat: Text.PlainText
            maximumLineCount: 1
            elide: Text.ElideRight
            Layout.maximumWidth: root.maxWidth - icon.width
            opacity: !root.isPlaying && !root.showStatusIcon ? 0.6 : 1
        }

        PC.Label {
            visible: !root.loaded
            text: i18n("No Source")
            textFormat: Text.PlainText
        }
    }
}
