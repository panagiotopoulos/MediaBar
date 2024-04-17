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
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.private.mediacontroller
import org.kde.plasma.private.mpris as Mpris
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property bool showStatusIcon: Plasmoid.configuration.showStatusIcon
    property bool seekingWheel: Plasmoid.configuration.useWheelForSeeking
    property int minWidth: Plasmoid.configuration.minimumWidth
    property int maxWidth: Plasmoid.configuration.maximumWidth
    property string preferredSource: Plasmoid.configuration.preferredSource

    onExpandedChanged: {
        if (root.expanded) {
            mpris2Model.currentPlayer?.updatePosition();
        }
    }

    onPreferredSourceChanged: {
        mpris2Model.refreshSource();
    }

    compactRepresentation: CompactRepresentation {}
    fullRepresentation: ExpandedRepresentation {}
    preferredRepresentation: compactRepresentation

    Plasmoid.status: PlasmaCore.Types.ActiveStatus
    Plasmoid.icon: isPlaying ? "stock_media-pause" : "stock_media-play"
    toolTipMainText: track
    toolTipSubText: artist && album ? (artist + " - " + album) : (artist || album)
    toolTipTextFormat: Text.PlainText

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18nc("Open player window or bring it to the front if already open", "Open")
            icon.name: "go-up-symbolic"
            priority: PlasmaCore.Action.LowPriority
            visible: canRaise
            onTriggered: raise()
        }
    ]

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (loaded) {
                mpris2Model.currentPlayer.updatePosition();
            }
        }
    }

    // BEGIN model properties
    readonly property bool loaded: {
        if (mpris2Model.currentPlayer == null) {
            return false;
        }
        return mpris2Model.currentPlayer.objectName === preferredSource || preferredSource === "@multiplex";
    }
    readonly property string track: loaded ? mpris2Model.currentPlayer.track : ""
    readonly property string artist: loaded ? mpris2Model.currentPlayer.artist : ""
    readonly property string album: loaded ? mpris2Model.currentPlayer.album : ""
    readonly property string albumArt: loaded ? mpris2Model.currentPlayer.artUrl : ""
    readonly property double length: loaded ? mpris2Model.currentPlayer.length : 0
    readonly property double position: loaded ? mpris2Model.currentPlayer.position : 0
    readonly property bool canGoPrevious: loaded ? mpris2Model.currentPlayer.canGoPrevious : false
    readonly property bool canGoNext: loaded ? mpris2Model.currentPlayer.canGoNext : false
    readonly property bool isPlaying: loaded ? mpris2Model.currentPlayer.playbackStatus === Mpris.PlaybackStatus.Playing : false
    readonly property bool canRaise: loaded ? mpris2Model.currentPlayer.canRaise : false
    // END model properties

    function previous() {
        mpris2Model.currentPlayer.Previous();
    }
    function next() {
        mpris2Model.currentPlayer.Next();
    }
    function togglePlaying() {
        mpris2Model.currentPlayer.PlayPause();
    }
    function raise() {
        mpris2Model.currentPlayer.Raise();
    }
    function seekBack() {
        mpris2Model.currentPlayer.Seek(-5000000);
    }
    function seekForward() {
        mpris2Model.currentPlayer.Seek(5000000);
    }
    function setPosition(pos) {
        mpris2Model.currentPlayer.position = pos;
    }
    Mpris.Mpris2Model {
        id: mpris2Model

        onRowsInserted: (_, rowIndex) => {
            refreshSource();
        }

        onRowsRemoved: (_, rowIndex) => {
            refreshSource();
        }

        function refreshSource() {
            const CONTAINER_ROLE = Qt.UserRole + 1
            for (var idx = 1; idx < rowCount(); ++idx) {
                const player = data(index(idx, 0), CONTAINER_ROLE)
                if (player.objectName === preferredSource) {
                    currentIndex = idx;
                    return;
                }
            }
            currentIndex = 0;
        }
    }
}
