/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL3+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
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
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Material 2.0
import Fluid.Controls 1.0
import org.hawaiios.launcher 0.1 as CppLauncher

Popup {
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    modal: true
    focus: true
    implicitWidth: layout.width + (2 * Units.largeSpacing)
    implicitHeight: layout.height + (2 * Units.largeSpacing)

    Material.theme: Material.Dark
    Material.primary: Material.Blue
    Material.accent: Material.Blue

    CppLauncher.ProcessRunner {
        id: process
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: Units.smallSpacing

        Label {
            text: qsTr("Enter a Command")
        }

        TextField {
            focus: true
            onAccepted: {
                process.launchCommand(text);
                text = "";
                close();
            }

            Layout.minimumWidth: 350
            Layout.fillWidth: true
        }

        Button {
            text: qsTr("Close")
            onClicked: close()

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
