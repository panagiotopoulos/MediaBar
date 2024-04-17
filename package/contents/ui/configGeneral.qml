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
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.private.mpris as Mpris
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_showStatusIcon: showStatusIcon.checked
    property alias cfg_useWheelForSeeking: scrollSeek.checked
    property alias cfg_maximumWidth: widthSlider.value
    property alias cfg_minimumWidth: widthSlider.from
    property string cfg_preferredSource: sources.displayText

    Kirigami.FormLayout {
        Layout.fillWidth: true

        CheckBox {
            id: showStatusIcon
            text: i18n("Show playback status icon")
        }

        CheckBox {
            id: scrollSeek
            text: i18n("Use scroll wheel for seeking")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        Label {
            text: i18n("Maximum width:")
        }

        RowLayout {
            Layout.fillWidth: true

            Slider {
                id: widthSlider
                Layout.fillWidth: true
                stepSize: 10
                snapMode: Slider.SnapAlways
                from: 200
                to: 1000
            }

            Label {
                text: widthSlider.value + i18n("px")
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
        }

        Label {
            text: i18n("Preferred media source:")
        }

        ComboBox {
            id: sources
            Layout.fillWidth: true
            model: Mpris.Mpris2Model {}
            delegate: ItemDelegate {
                width: parent.width
                text: model.index === 0 ? "@multiplex" : model.container.objectName
            }
            focus: true
            displayText: currentIndex === 0 ? "@multiplex" : currentValue.container.objectName
            Component.onCompleted: {
                for (var i = 1; i < count; ++i) {
                    const name = valueAt(i).container.objectName;
                    if (name === cfg_preferredSource) {
                        currentIndex = i;
                        return;
                    }
                }
                currentIndex = 0;
            }
            onActivated: {
                cfg_preferredSource = displayText;
            }
        }
    }
}
