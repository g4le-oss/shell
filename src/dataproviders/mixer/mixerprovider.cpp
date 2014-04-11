/****************************************************************************
 * This file is part of Hawaii Shell.
 *
 * Copyright (C) 2012-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

#include "mixerprovider.h"
#include "mixersource.h"

MixerProvider::MixerProvider(QObject *parent)
    : Hawaii::DataProvider(parent)
{
    // Update date and time information every 500ms
    setPollingInterval(500);

    // Add master source
    addSource(new MixerSource(this));
}

void MixerProvider::setMute(bool value)
{
    MixerSource *mixer = qobject_cast<MixerSource *>(source("Master"));
    if (mixer)
        mixer->setMute(value);
}

void MixerProvider::setVolume(int value)
{
    MixerSource *mixer = qobject_cast<MixerSource *>(source("Master"));
    if (mixer)
        mixer->setVolume(value);
}

#include "moc_mixerprovider.cpp"
