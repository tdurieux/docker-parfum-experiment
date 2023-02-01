FROM ubuntu:latest

# Suitable for builds
RUN apt update && apt -y install --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt update && add-apt-repository ppa:mutlaqja/indinightly
RUN apt update && apt -y install --no-install-recommends \
      gcc-multilib \
      g++-multilib \
      make \
      gettext \
      coreutils \
      cmake \
      extra-cmake-modules \
      qtbase5-dev \
      qtdeclarative5-dev \
      qtmultimedia5-dev \
      qtpositioning5-dev \
      libqt5websockets5-dev \
      libqt5svg5-dev \
      libqt5sql5-sqlite \
      kdoctools-dev \
      libkf5config-dev \
      libkf5guiaddons-dev \
      libkf5i18n-dev \
      libkf5newstuff-dev \
      libkf5notifications-dev \
      libkf5xmlgui-dev \
      libkf5plotting-dev \
      libkf5crash-dev \
      libkf5notifyconfig-dev \
      libeigen3-dev \
      zlib1g-dev \
      libcfitsio-dev \
      libnova-dev \
      wcslib-dev \
      libraw-dev \
      libgsl-dev \
      phonon4qt5-backend-vlc \
      qt5keychain-dev \
      libsecret-1-dev && rm -rf /var/lib/apt/lists/*;

# Suitable for tests
RUN apt update && add-apt-repository ppa:mutlaqja/indinightly
RUN apt update && add-apt-repository ppa:pch/phd2
RUN apt update && apt -y --no-install-recommends install \
      make \
      cmake \
      extra-cmake-modules \
      xplanet \
      xplanet-images \
      astrometry.net \
      kded5 \
      kinit \
      breeze-icon-theme \
      libqt5sql5-sqlite \
      qml-module-qtquick-controls \
      gsc gsc-data \
      phd2 \
      xvfb && rm -rf /var/lib/apt/lists/*;

# QT5 theme
ENV QT_QPA_PLATFORMTHEME=qt5ct
RUN apt update && apt -y --no-install-recommends install qt5ct && rm -rf /var/lib/apt/lists/*;
RUN d=/root/.config/qt5ct ; mkdir -p "$d" && echo '[Appearance]\nicon_theme=breeze' > "$d/qt5ct.conf"

# Ninja
RUN apt update && apt -y --no-install-recommends install ninja-build && rm -rf /var/lib/apt/lists/*;

# CCache
ENV CCACHE_DIR=/var/ccache
RUN apt update && apt -y --no-install-recommends install ccache && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p $CCACHE_DIR && chmod a=rwx $CCACHE_DIR && update-ccache-symlinks

# AppImage
RUN apt update && apt -y --no-install-recommends install \
      python3-pip \
      python3-setuptools \
      patchelf \
      desktop-file-utils \
      libgdk-pixbuf2.0-dev \
      fakeroot \
      wget \
      gpg-agent && rm -rf /var/lib/apt/lists/*;

# Saxon
RUN apt install -y --no-install-recommends \
      libsaxon-java \
      openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;

# Astrometry
ADD http://broiler.astrometry.net/~dstn/4200/index-4208.fits /root/.local/share/kstars/astrometry/
ADD http://broiler.astrometry.net/~dstn/4200/index-4209.fits /root/.local/share/kstars/astrometry/
ADD http://broiler.astrometry.net/~dstn/4200/index-4210.fits /root/.local/share/kstars/astrometry/

# From https://invent.kde.org/sysadmin/ci-tooling/-/blob/master/system-images/suse-qt515/Dockerfile
RUN apt update && apt -y --no-install-recommends install dbus && rm -rf /var/lib/apt/lists/*;
RUN dbus-uuidgen > /etc/machine-id

CMD /bin/bash

