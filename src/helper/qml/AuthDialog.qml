// SPDX-FileCopyrightText: 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Aurora.Client 1.0 as AuroraClient
import Fluid.Controls 1.0 as FluidControls

Window {
    id: authDialogWindow

    property string actionId
    property alias message: messageLabel.text
    property string iconName
    property alias realName: avatarName.text
    property string avatar
    property alias prompt: promptLabel.text
    property bool echo: false
    property alias infoMessage: infoLabel.text
    property alias errorMessage: errorLabel.text

    color: "transparent"
    visible: false

    AuroraClient.WlrLayerSurfaceV1 {
        layer: AuroraClient.WlrLayerSurfaceV1.TopLayer
        anchors: AuroraClient.WlrLayerSurfaceV1.LeftAnchor |
                 AuroraClient.WlrLayerSurfaceV1.TopAnchor |
                 AuroraClient.WlrLayerSurfaceV1.RightAnchor |
                 AuroraClient.WlrLayerSurfaceV1.BottomAnchor
        keyboardInteractivity: AuroraClient.WlrLayerSurfaceV1.ExclusiveKeyboardInteractivity
        exclusiveZone: -1
        role: "auth-dialog"
    }

    Dialog {
        id: authDialog

        Material.theme: Material.Dark
        Material.primary: Material.Blue
        Material.accent: Material.Blue

        title: qsTr("Authentication required")

        focus: true
        visible: authDialogWindow.visible

        onOpened: {
            // Give focus to the password field
            passwordInput.forceActiveFocus();
        }
        onClosed: {
            // Cleanup
            actionId = "";
            message = "";
            iconName = "";
            realName = "";
            avatar = "";
            prompt = "";
            passwordInput.text = "";
            infoMessage = "";
            errorMessage = "";
        }

        onAccepted: {
            policyKitAgent.authenticate(passwordInput.text);
            authDialogWindow.hide();
        }
        onRejected: {
            policyKitAgent.abortAuthentication();
            authDialogWindow.hide();
        }

        ColumnLayout {
            id: mainLayout

            spacing: FluidControls.Units.smallSpacing

            RowLayout {
                spacing: FluidControls.Units.smallSpacing

                FluidControls.Icon {
                    source: FluidControls.Utils.iconUrl("action/lock")
                    size: FluidControls.Units.iconSizes.medium

                    Layout.alignment: Qt.AlignTop
                }

                ColumnLayout {
                    spacing: FluidControls.Units.smallSpacing

                    FluidControls.DialogLabel {
                        id: messageLabel
                        wrapMode: Text.WordWrap

                        Layout.fillWidth: true
                    }

                    RowLayout {
                        spacing: FluidControls.Units.smallSpacing

                        FluidControls.Icon {
                            id: avatarImage
                            size: FluidControls.Units.iconSizes.large
                        }

                        Label {
                            id: avatarName

                            Layout.alignment: Qt.AlignVCenter
                        }

                        Layout.alignment: Qt.AlignCenter
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        spacing: FluidControls.Units.smallSpacing

                        Label {
                            id: promptLabel
                        }

                        TextField {
                            id: passwordInput
                            echoMode: echo ? TextInput.Normal : TextInput.Password
                            focus: true
                            onAccepted: authDialog.accepted()

                            Layout.fillWidth: true
                        }
                    }

                    Label {
                        id: infoLabel
                        color: "green"
                        font.bold: true
                        wrapMode: Text.WordWrap
                        visible: text != ""

                        Layout.fillWidth: true
                    }

                    Label {
                        id: errorLabel
                        color: "red"
                        font.bold: true
                        wrapMode: Text.WordWrap
                        visible: text != ""

                        Layout.fillWidth: true
                    }
                }

                Layout.fillHeight: true
            }
        }

        footer: DialogButtonBox {
            Button {
                text: qsTr("Authenticate")
                flat: true

                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            }

            Button {
                text: qsTr("Cancel")
                flat: true

                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }
    }

    onAvatarChanged: {
        // Load the image from the disk if it's an absolute path
        if (avatar.indexOf("/") == 0) {
            avatarImage.name = "";
            avatarImage.source = avatar;
        }

        // Otherwise use a standard icon
        avatarImage.source = "";
        avatarImage.name = "action/verified_user";
    }
    onErrorMessageChanged: {
        // Give focus to the password field and clear
        passwordInput.text = "";
        passwordInput.forceActiveFocus();
    }
}
