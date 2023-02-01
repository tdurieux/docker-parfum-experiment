# Copyright 2018-2022 Nick Brassel (@tzarc)
# SPDX-License-Identifier: GPL-3.0-or-later
FROM qmkfm/base_container:latest

#FROM fedora:latest

ENV PATH="/home/qmk/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN apt-get update \
    && apt-get install --no-install-recommends -y awscli curl gawk nano && rm -rf /var/lib/apt/lists/*;

#RUN dnf install -y \
#    arm-none-eabi-binutils-cs \
#    arm-none-eabi-gcc-cs \
#    arm-none-eabi-newlib \
#    avr-gcc \
#    avrdude \
#    binutils \
#    clang-tools-extra \
#    dfu-programmer \
#    dfu-util \
#    dos2unix \
#    gcc \
#    gcc-c++ \
#    git \
#    glibc-devel \
#    libtool \
#    make \
#    pkgconf \
#    pkgconf-m4 \
#    pkgconf-pkg-config \
#    python3 \
#    python3-pip \
#    tar \
#    unzip \
#    wget \
#    zip

RUN groupadd -f qmk -g 10000 \
    && useradd -d /home/qmk -g qmk -m -N -u 10000 qmk

RUN mkdir -p /usr/local/bin \
    && curl -f -L https://github.com/pixelb/scripts/raw/master/scripts/ansi2html.sh > /usr/local/bin/ansi2html.sh \
    && chmod 755 /usr/local/bin/ansi2html.sh

USER 10000:10000
WORKDIR /home/qmk

RUN python3 -m pip install -U pip wheel \
    && python3 -m pip install -U qmk milc \
    && git clone --depth=5 -b develop https://github.com/qmk/qmk_firmware /home/qmk/qmk_firmware \
    && cd /home/qmk/qmk_firmware \
    && git checkout develop \
    && git pull --depth=5 --ff-only \
    && make git-submodule

COPY entrypoint.sh /home/qmk/entrypoint.sh
COPY run_ci_build.sh /home/qmk/run_ci_build.sh

USER 0:0
WORKDIR /home/qmk

RUN chmod 755 /home/qmk/*.sh \
    && chown qmk:qmk /home/qmk/*.sh

USER 10000:10000
WORKDIR /home/qmk

ENTRYPOINT ["/home/qmk/entrypoint.sh"]