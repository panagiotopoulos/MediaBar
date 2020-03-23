/*
 *   Copyright 2019-2020 Panagiotis Panagiotopoulos <panagiotopoulos.git@gmail.com>
 *
 * 	  This file is part of MediaBar.
 *
 *    MediaBar is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    MediaBar is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MediaBar.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

Item {
	id: configRoot

	property alias cfg_maximumWidth: widthSlider.value
	property alias cfg_minimumWidth: widthSlider.from
	property alias cfg_preferredSource: sourceInput.text
	property alias cfg_useWheelForSeeking: scrollSeekCheckBox.checked

	ColumnLayout {
		Label {
			text: i18n("Maximum width for compact view when in a panel:")
		}

		RowLayout {
			Slider {
				id: widthSlider
				stepSize: 10
				snapMode: Slider.SnapAlways
				from: 200
				to: 1000
			}
			Label {
				text: widthSlider.value + i18n("px")
			}
		}

		Item { // spacer item
			Layout.fillWidth: true
			Layout.topMargin: 8
			Layout.bottomMargin: 8
			Rectangle {
				width: parent.width*0.9
				height: 1
				color: "#666666"
			}
        }

		Label {
			text: "Preferred media source (for example: cantata, @multiplex, etc):"
		}

		TextField {
			id: sourceInput
			focus: true
			placeholderText: qsTr("@multiplex")
		}

		Item { // spacer item
			Layout.fillWidth: true
			Layout.topMargin: 8
			Layout.bottomMargin: 8
			Rectangle {
				width: parent.width*0.9
				height: 1
				color: "#666666"
			}
        }

		CheckBox {
			id: scrollSeekCheckBox
			text: i18n("Use scroll wheel for seeking")
		}
	}
}
