# Copyright © SixtyFPS GmbH <info@slint-ui.com>
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Slint-commercial

FROM rustembedded/cross:armv7-unknown-linux-gnueabihf-0.2.1

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libfontconfig1-dev:armhf libxcb1-dev:armhf libxcb-render0-dev:armhf libxcb-shape0-dev:armhf libxcb-xfixes0-dev:armhf libxkbcommon-dev:armhf python3 \
                                 libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;

ENV PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig
