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
import Qt5Compat.GraphicalEffects

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PC3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.coreaddons 1.0 as KCoreAddons
import org.kde.kirigami 2 as Kirigami

PlasmaExtras.Representation {
    id: expandedRepresentation

    readonly property int durationFormattingOptions: root.length >= 60*60*1000*1000 ? 0 : KCoreAddons.FormatTypes.FoldHours

    spacing: Kirigami.Units.smallSpacing * 2

    Layout.minimumWidth: root.minWidth
    Layout.maximumWidth: root.maxWidth
    Layout.preferredWidth: root.maxWidth

    Layout.preferredHeight: column.implicitHeight

    function formatTime(time) {
        return KCoreAddons.Format.formatDuration(time, expandedRepresentation.durationFormattingOptions);
    }

    Keys.onReleased: event => {
        if (!event.modifiers) {
            event.accepted = true;
            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                // K is YouTube's key for "play/pause
                root.togglePlaying();
            } else if (event.key === Qt.Key_P) {
                root.previous();
            } else if (event.key === Qt.Key_N) {
                root.next();
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_J) {
                // seek back 5s
               root.seekBack();
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_L) {
                // seek forward 5s
                root.seekForward();
            } else if (event.key === Qt.Key_Home ||  event.key === Qt.Key_0) {
                root.setPosition(0);
            } else if (event.key > Qt.Key_0 && event.key <= Qt.Key_9) {
                // jump to percentage, ie. 0 = beginning, 1 = 10% of total length etc
                root.setPosition(root.length / 10 * (event.key - Qt.Key_0));
            } else {
                event.accepted = false;
            }
        }
    }

    ColumnLayout {
        id: column
        enabled: root.loaded

        Image {
            id: albumArt
            source: plasmoid.icon
            asynchronous: true
            sourceSize.width: expandedRepresentation.width
            Layout.fillWidth: true
            fillMode: Image.PreserveAspectFit
            visible: status === Image.Ready
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing * 2
            TextMetrics {
                id: timeMetrics
                text: i18nc("Remaining time for song e.g -5:42", "-%1", formatTime(progressBar.to))
                font: Kirigami.Theme.smallFont
            }

            PC3.Label {
                Layout.preferredWidth: timeMetrics.width
                horizontalAlignment: Text.AlignRight
                text: formatTime(progressBar.value)
                opacity: 0.9
                font: Kirigami.Theme.smallFont
                color: Kirigami.Theme.textColor
            }

            PC3.ProgressBar {
                id: progressBar
                to: Math.ceil(root.length / 1000)
                value: Math.ceil(root.position / 1000)
                Layout.fillWidth: true
            }

            PC3.Label {
                Layout.preferredWidth: timeMetrics.width
                horizontalAlignment: Text.AlignLeft
                text: formatTime(progressBar.to)
                opacity: 0.9
                font: Kirigami.Theme.smallFont
                color: Kirigami.Theme.textColor
            }
        }

        PC3.Label {
            Layout.fillWidth: true
            visible: text !== ""
            horizontalAlignment: Text.AlignHCenter
            text: root.toolTipMainText
            wrapMode: Text.WordWrap
            font.pointSize: subLabel.font.pointSize * 1.2
            minimumPointSize: Kirigami.Theme.smallFont.pointSize
        }

        PC3.Label {
            id: subLabel
            visible: text !== ""
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: root.toolTipSubText
            wrapMode: Text.WordWrap
            fontSizeMode: Text.Fit
            minimumPointSize: Kirigami.Theme.smallFont.pointSize
            opacity: 0.6
        }
    }
}
