// SPDX-FileCopyrightText: 2021 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import Fluid.Core 1.0 as FluidCore
import Liri.Notifications 1.0 as Notifications

FluidCore.Object {
    NotificationWindow {
        id: notificationWindow
    }

    Notifications.NotificationsServer {
        onActiveChanged: {
            if (active)
                console.debug("Notifications manager activated");
            else
                console.debug("Notifications manager deactivated");
        }

        onNotificationReceived: {
            console.debug("Notification", notificationId, "received");
            var props = {
                "notificationId": notificationId,
                "appName": appName,
                "appIcon": appIcon,
                "iconUrl": "image://notifications/%1/%2".arg(notificationId).arg(Date.now() / 1000 | 0),
                "hasIcon": hasIcon,
                "summary": summary,
                "body": body,
                "isPersistent": isPersistent,
                "expireTimeout": expireTimeout,
                "hints": hints,
                "actions": actions,
            };
            notificationWindow.model.append(props);
        }

        onNotificationClosed: {
            console.debug("Notification", notificationId, "closed for", reason);
        }

        onActionInvoked: {
            console.debug("Notification", notificationId, "action:", actionKey);
        }
    }
}
