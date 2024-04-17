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

import org.kde.plasma.components as PC
import org.kde.plasma.extras as PlasmaExtras
import org.kde.coreaddons as KCoreAddons
import org.kde.kirigami as Kirigami

PlasmaExtras.Representation {
    id: expandedRepresentation
    enabled: root.loaded

    spacing: Kirigami.Units.smallSpacing * 2

    readonly property int durationFormattingOptions: root.length >= 60*60*1000*1000 ? 0 : KCoreAddons.FormatTypes.FoldHours

    Layout.minimumWidth: root.minWidth + Kirigami.Units.gridUnit * 4
    Layout.maximumWidth: root.maxWidth
    Layout.preferredWidth: root.width

    Layout.minimumHeight: Math.max(Layout.minimumWidth, column.implicitHeight)
    Layout.maximumHeight: Math.min(Layout.maximumWidth + Kirigami.Units.gridUnit * 8, column.implicitHeight)
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
            } else if (event.key === Qt.Key_Home || event.key === Qt.Key_0) {
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

        Image {
            visible: status === Image.Ready
            asynchronous: true
            cache: false
            source: root.albumArt
            sourceSize.width: expandedRepresentation.width
            fillMode: Image.PreserveAspectFit
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing * 2

            TextMetrics {
                id: timeMetrics
                text: i18nc("Remaining time for song e.g -5:42", "-%1", formatTime(progressBar.to))
                font: Kirigami.Theme.smallFont
            }

            PC.Label {
                text: formatTime(progressBar.value)
                textFormat: Text.PlainText
                font: timeMetrics.font
                color: Kirigami.Theme.textColor
                opacity: 0.9
                horizontalAlignment: Text.AlignRight
                Layout.preferredWidth: timeMetrics.width
            }

            PC.ProgressBar {
                id: progressBar
                to: Math.ceil(root.length / 1000)
                value: Math.ceil(root.position / 1000)
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            PC.Label {
                text: formatTime(progressBar.to)
                textFormat: Text.PlainText
                font: timeMetrics.font
                color: Kirigami.Theme.textColor
                opacity: 0.9
                horizontalAlignment: Text.AlignLeft
                Layout.preferredWidth: timeMetrics.width
            }
        }

        Kirigami.Heading {
            visible: text.length > 0
            level: 2

            text: root.toolTipMainText
            color: Kirigami.Theme.textColor

            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap

            Layout.fillWidth: true
            Layout.maximumWidth: expandedRepresentation.width
        }

        Kirigami.Heading {
            visible: text.length > 0
            level: 3

            text: root.toolTipSubText
            color: Kirigami.Theme.textColor
            opacity: 0.6

            textFormat: Text.PlainText
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap

            Layout.fillWidth: true
            Layout.maximumWidth: expandedRepresentation.width
        }
    }
}
