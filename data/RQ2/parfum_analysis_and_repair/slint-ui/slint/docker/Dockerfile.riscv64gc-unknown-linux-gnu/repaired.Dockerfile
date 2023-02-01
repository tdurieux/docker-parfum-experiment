# Copyright © SixtyFPS GmbH <info@slint-ui.com>
# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-Slint-commercial

# Use cross-image once https://github.com/rust-embedded/cross/pull/591 is merged & released
#FROM rustembedded/cross:riscv64gc-unknown-linux-gnu-0.2.1
FROM ghcr.io/slint-ui/cross-riscv64-base:1.0

RUN dpkg --add-architecture riscv64 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes libfontconfig1-dev:riscv64 libxcb1-dev:riscv64 libxcb-render0-dev:riscv64 libxcb-shape0-dev:riscv64 libxcb-xfixes0-dev:riscv64 libxkbcommon-dev:riscv64 python3 \
                                     libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;

ENV PKG_CONFIG_PATH=/usr/lib/riscv64-linux-gnu/pkgconfig
