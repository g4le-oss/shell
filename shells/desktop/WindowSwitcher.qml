/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2014-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import GreenIsland 1.0
import Hawaii.Themes 1.0 as Themes

Rectangle {
    id: root
    color: "#80000000"
    radius: Themes.Units.gu(0.5)
    opacity: 0.0

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.InQuad
            duration: Themes.Units.shortDuration
        }
    }

    // Keyboard event handling
    Connections {
        target: compositorRoot
        onWindowSwitchPrev: {
            if (listView.currentIndex == 0)
                listView.currentIndex = listView.count - 1;
            else
                listView.currentIndex--;
        }
        onWindowSwitchNext: {
            if (listView.currentIndex == listView.count - 1)
                listView.currentIndex = 0;
            else
                listView.currentIndex++;
        }
        onWindowSwitchSelect: {
            // Give focus to the selected window
            compositorRoot.windowList[listView.currentIndex].child.takeFocus();
        }
    }

    ListView {
        readonly property real ratio: compositorRoot.width / compositorRoot.height

        id: listView
        anchors {
            fill: parent
            margins: Themes.Units.largeSpacing
        }
        clip: true
        orientation: ListView.Horizontal
        model: compositorRoot.windowList
        spacing: Themes.Units.smallSpacing
        highlightMoveDuration: Themes.Units.shortDuration
        delegate: Item {
            readonly property real scaleFactor: listView.width / compositorRoot.width
            readonly property real thumbnailWidth: thumbnailHeight * listView.ratio
            readonly property real thumbnailHeight: listView.height - Themes.Units.smallSpacing - (Themes.Units.largeSpacing * 2)

            id: wrapper
            width: thumbnailWidth + thumbnailLayout.anchors.margins + thumbnailLayout.spacing
            height: thumbnailHeight + thumbnailLayout.anchors.margins + thumbnailLayout.spacing

            ColumnLayout {
                id: thumbnailLayout
                anchors {
                    fill: parent
                    margins: Themes.Units.smallSpacing
                }
                spacing: Themes.Units.largeSpacing

                Rectangle {
                    id: thumbnailItem
                    color: wrapper.ListView.isCurrentItem ? Themes.Theme.palette.panel.selectedBackgroundColor : "transparent"
                    radius: Themes.Units.gu(0.5)
                    width: thumbnailWidth - Themes.Units.smallSpacing
                    height: thumbnailHeight - Themes.Units.smallSpacing - label.height

                    SurfaceRenderer {
                        anchors {
                            fill: parent
                            margins: Themes.Units.smallSpacing
                        }
                        source: modelData.child

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.AllButtons
                            onClicked: listView.currentIndex = index
                        }
                    }
                }

                Label {
                    id: label
                    text: modelData.child.surface.title ? modelData.child.surface.title : qsTr("Untitled")
                    wrapMode: Text.Wrap
                    color: Themes.Theme.palette.panel.textColor
                    font.bold: true
                    style: Text.Raised
                    styleColor: Themes.Theme.palette.panel.textEffectColor
                    maximumLineCount: 2
                    opacity: wrapper.ListView.isCurrentItem ? 1.0 : 0.6

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component.onCompleted: {
        // Show with an animtation
        opacity = 1.0;

        var newIndex = compositorRoot.activeWindowIndex + 1;
        if (newIndex === compositorRoot.surfaceModel.count)
            newIndex = 0;
        listView.currentIndex = newIndex;
    }
}
