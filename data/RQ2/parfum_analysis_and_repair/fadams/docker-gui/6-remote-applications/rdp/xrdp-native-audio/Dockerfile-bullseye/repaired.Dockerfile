#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM debian:bullseye-slim

ENV LANG=en_GB.UTF-8
ENV TZ=Europe/London

RUN \
    sed -i 's/main/main non-free/' /etc/apt/sources.list && \
    apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    wget apt-utils git autoconf automake libtool x11-utils \
    software-properties-common libssl-dev libpam0g-dev \
    nasm xsltproc flex bison pkg-config locales libcap-dev \
    libpulse-dev pulseaudio libudev-dev \
    intltool libltdl-dev libsndfile-dev bash-completion \
    libsystemd-dev libdbus-1-dev libspeexdsp-dev autopoint \
    libx11-dev xserver-xorg-dev xserver-xorg-core \
    libxfixes-dev libxrandr-dev libxml2-dev dpkg-dev \
    libmp3lame-dev libopus-dev libfdk-aac-dev libjpeg-dev \
    libturbojpeg0-dev libpixman-1-dev libfuse-dev \
    libgl1-mesa-glx libgl1-mesa-dri jwm xauth xfonts-base \
    xfonts-75dpi xfonts-100dpi xfonts-scalable && \
    #
    # Install tini. Can't just use --init in docker run because we need
    # tini's -g option so every process in the group gets the signal
    wget -O /sbin/init https://github.com/krallin/tini/releases/download/v0.18.0/tini && \
    chmod +x /sbin/init && \
    # Generate locales
    sed -i "s/^# *\($LANG\)/\1/" /etc/locale.gen && \
    locale-gen && \
    # Set up the timezone
    echo $TZ > /etc/timezone && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    DEBIAN_FRONTEND=noninteractive \
    dpkg-reconfigure tzdata && \
    # Tidy up JWM for single app use case
    sed -i "s/Desktops width=\"4\"/Desktops width=\"1\"/g" /etc/jwm/system.jwmrc && \
    sed -i "s/<TrayButton icon=\"\/usr\/share\/jwm\/jwm-red.svg\">root:1<\/TrayButton>//g" /etc/jwm/system.jwmrc && \
    sed -i "s/<TrayButton label=\"_\">showdesktop<\/TrayButton>//g" /etc/jwm/system.jwmrc && \
    sed -i "s/<Include>\/etc\/jwm\/debian-menu<\/Include>//g" /etc/jwm/system.jwmrc && \
    #
    # Clone xrdp and xorgxrdp source from GitHub and build them.
    cd /usr/src && \
    git clone --recursive \
        https://github.com/neutrinolabs/xrdp.git && \
    git clone \
        https://github.com/neutrinolabs/xorgxrdp.git && \
    git clone \
        https://github.com/pulseaudio/pulseaudio.git && \
    git clone \
        https://github.com/neutrinolabs/pulseaudio-module-xrdp.git && \
    cd xrdp && git checkout v0.9.15 -b build && \
    # The default xrdp behaviour is to defer starting Xorg
    # until session start, so we patch session.c to prevent
    # it skipping the display we will be pre-starting.
    sed -i 's/!x_server_running_check_ports(display)/!x_server_running_check_ports(display) || 1/' /usr/src/xrdp/sesman/session.c && \
    ./bootstrap && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-opus --enable-fuse --enable-jpeg \
                --enable-tjpeg --enable-ipv6 --enable-vsock \
                --enable-pixman --enable-mp3lame \
                --enable-fdkaac && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install && \
    cd ../xorgxrdp && git checkout v0.2.15 -b build && \
    ./bootstrap && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install && \
    sed -i 's/ssl_protocols=TLSv1.2, TLSv1.3/ssl_protocols=TLSv1.2/' \
        /etc/xrdp/xrdp.ini && \
    #
    # Build xrdp source / sink modules
    cd ../pulseaudio && git checkout v14.1 -b build && \
    ./autogen.sh && \
    cd ../pulseaudio-module-xrdp && \
    git checkout v0.4 -b build && \
    ./bootstrap && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" PULSE_DIR=/usr/src/pulseaudio && \
    make -j$(getconf _NPROCESSORS_ONLN) && make install && \
    #
    # Modify PulseAudio daemon config to support xrdp.
    sed -i "s/; exit-idle-time = 20/exit-idle-time = -1/g" \
        /etc/pulse/daemon.conf && \
    sed -i "s/load-module module-console-kit/#load-module module-console-kit/g" \
        /etc/pulse/default.pa && \
    echo "load-module module-xrdp-sink" >> \
         /etc/pulse/default.pa && \
    echo "load-module module-xrdp-source" >> \
         /etc/pulse/default.pa && \
    # Make the log files writeable so xrdp needn't be root.
    touch /var/log/xrdp.log && \
    chmod 1666 /var/log/xrdp.log && \
    touch /var/log/xrdp-sesman.log && \
    chmod 1666 /var/log/xrdp-sesman.log && \
    chmod 644 /etc/xrdp/rsakeys.ini && \
    chmod 644 /etc/xrdp/cert.pem && \
    chmod 644 /etc/xrdp/key.pem && \
    chmod 666 /etc/xrdp/sesman.ini && \
    #
    # We'll be exporting /tmp/.X11-unix and /run/user as volumes
    # and we need the mode of these to be set to 1777
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    mkdir -p /run/user && \
    chmod 1777 /run/user && \
    #
    # Create Fake Xorg for xrdp to use on session start.
    echo '#!/bin/bash\nsleep infinity' > \
         /usr/lib/xorg/XorgFake && \
    chmod +x /usr/lib/xorg/XorgFake && \
    sed -i 's/param=Xorg/param=\/usr\/lib\/xorg\/XorgFake/' \
        /etc/xrdp/sesman.ini && \
    #
    # Script to start Xorg, jwm and xrdp. The sed replaces
    # X11DisplayOffset with $DISPLAY using a temp file in
    # /tmp as /etc/xrdp isn't writable so can't use sed -i
    echo '#!/bin/bash\nsed '\"'s/X11DisplayOffset=10/X11DisplayOffset=${DISPLAY:1}/'\"' /etc/xrdp/sesman.ini > /tmp/sesman.ini && cat /tmp/sesman.ini > /etc/xrdp/sesman.ini && rm -f /tmp/sesman.ini\npulseaudio &\nXorg $DISPLAY -ac -noreset -nolisten tcp -config /etc/X11/xrdp/xorg.conf &\nxrdp-sesman --nodaemon &\nexec xrdp --nodaemon' > /usr/local/bin/startup && \
    chmod +x /usr/local/bin/startup && \
    #
    # Remove miscellaneous packages used for installation and build.
    # Need to keep pkg-config or xrdp-chansrv behaves weirdly.
    rm -rf /usr/src/xrdp && \
    rm -rf /usr/src/xorgxrdp && \
    rm -rf /usr/src/pulseaudio && \
    rm -rf /usr/src/pulseaudio-module-xrdp && \
    apt-get clean && \
    apt-get purge -y software-properties-common bzip2 \
    wget apt-utils git autoconf automake libtool xsltproc \
    nasm flex bison gcc-10 libgcc-10-dev binutils xz-utils \
    intltool libltdl-dev libsndfile-dev bash-completion \
    libsystemd-dev libdbus-1-dev libspeexdsp-dev \
    libpython3.9-minimal libx11-dev xserver-xorg-dev \
    libpulse-dev libudev-dev autopoint && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

VOLUME /tmp/.X11-unix
VOLUME /run/user

# The -g option here is important for cleanly shutting down.
# See https://github.com/krallin/tini#process-group-killing
ENTRYPOINT ["/sbin/init", "-g", "--"]
CMD ["/usr/local/bin/startup"]

#-------------------------------------------------------------------------------
#
# To build the image
# docker build -t xrdp-native-audio -f Dockerfile-bullseye .
#

