#    Copyright © 2021 by The qTox Project Contributors
#
#    This program is libre software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
        apt-get -y --force-yes --no-install-recommends install \
        curl \
        ca-certificates \
        elfutils \
        # flatpak-validate-icon uses gdk-pixbuf which needs an svg loader
        librsvg2-common \
        flatpak \
        flatpak-builder && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Pre-download kde flatpak environment to speed up flatpak builds