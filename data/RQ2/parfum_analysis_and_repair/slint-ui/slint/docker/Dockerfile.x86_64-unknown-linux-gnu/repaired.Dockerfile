# Copyright © SixtyFPS GmbH <info@slint-ui.com>
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Slint-commercial

FROM rustembedded/cross:x86_64-unknown-linux-gnu
# Unfortunately the base container is based on Centos7 rather than Ubuntu

RUN yum update --assumeyes
RUN yum install --assumeyes glibc fontconfig-devel libxcb-devel xcb-util-renderutil-devel xcb-util-devel libxkbcommon-devel python3 && rm -rf /var/cache/yum
