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

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PC3
import org.kde.kirigami 2 as Kirigami

MouseArea {
    id: compactRepresentation

    Layout.fillHeight: true

    Layout.minimumWidth: root.minWidth
    Layout.maximumWidth: root.maxWidth
    Layout.preferredWidth: row.width

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton

    property int wheelDelta: 0

    onClicked: mouse => {
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

    onWheel: wheel => {
        wheelDelta += (wheel.inverted ? -1 : 1) * (wheel.angleDelta.y ? wheel.angleDelta.y : -wheel.angleDelta.x)
        while (wheelDelta >= 120) {
            wheelDelta -= 120;
            root.seekBack();
        }
        while (wheelDelta <= -120) {
            wheelDelta += 120;
            root.seekForward();
        }
    }

    RowLayout {
        id: row;
        spacing: 0

        Kirigami.Icon {
            id: icon
            color: Kirigami.Theme.textColor
            implicitHeight: Math.min(compactRepresentation.height, Kirigami.Units.iconSizes.medium)
            implicitWidth: implicitHeight
            source: root.isPlaying ? "stock_media-pause" : "stock_media-play"
        }

        PC3.Label {
            text: (root.artist ? root.artist + " - " : "") + (root.track || "")
            Layout.maximumWidth: root.maxWidth - icon.width
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
