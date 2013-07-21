/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2013 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#ifndef POWERMANAGER_H
#define POWERMANAGER_H

#include <QtCore/QObject>

#include "powermanagerbackend.h"

class PowerManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PowerCapabilities capabilities READ capabilities NOTIFY capabilitiesChanged)
public:
    explicit PowerManager(QObject *parent = 0);
    ~PowerManager();

    PowerCapabilities capabilities() const;

Q_SIGNALS:
    void capabilitiesChanged();

public Q_SLOTS:
    void powerOff();
    void restart();
    void suspend();
    void hibernate();
    void hybridSleep();

private Q_SLOTS:
    void serviceRegistered(const QString &service);
    void serviceUnregistered(const QString &service);

private:
    QList<PowerManagerBackend *> m_backends;
};

#endif // POWERMANAGER_H
