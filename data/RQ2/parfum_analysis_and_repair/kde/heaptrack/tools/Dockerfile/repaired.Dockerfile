# trusty
FROM ubuntu:14.04 as heaptrack_appimage_intermediate

# install dependencies
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y software-properties-common build-essential curl git wget \
        autotools-dev autoconf libtool liblzma-dev libz-dev gettext && \
    add-apt-repository ppa:beineri/opt-qt-5.10.1-trusty -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install --no-install-recommends -y qt510base qt510svg qt510x11extras cmake3 mesa-common-dev \
        libboost-iostreams-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev \
        gcc-4.9 g++-4.9 && \
    apt-get -y upgrade && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9 && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt

# download prebuild KF5 libraries and ECM

RUN wget -c "https://github.com/chigraph/precompiled-kf5-linux/releases/download/precompiled/kf5-gcc6-linux64-release.tar.xz" && \
    tar --strip-components=2 -xf kf5-gcc6-linux64-release.tar.xz && rm kf5-gcc6-linux64-release.tar.xz

# download AppImage tools and extract them, to remove fuse dependency

RUN wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage" -O /tmp/linuxdeployqt && \
    wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O /tmp/appimagetool && \
    chmod a+x /tmp/linuxdeployqt /tmp/appimagetool && \
    /tmp/linuxdeployqt --appimage-extract && mv squashfs-root linuxdeployqt && \
    ln -s /opt/linuxdeployqt/AppRun /opt/bin/linuxdeployqt && \
    /tmp/appimagetool --appimage-extract && mv squashfs-root appimagetool && \
    ln -s /opt/appimagetool/AppRun /opt/bin/appimagetool

# setup env

ENV PATH="/opt/bin:/opt/qt510/bin:${PATH}" \
    PKG_CONFIG_PATH="/opt/qt510/lib/pkgconfig:${PKG_CONFIG_PATH}" \
    LD_LIBRARY_PATH="/opt/qt510/lib:/opt/lib/x86_64-linux-gnu"

# grab sources

RUN git clone git://git.sv.gnu.org/libunwind.git && \
    git clone https://github.com/facebook/zstd.git && \
    wget -c "https://invent.kde.org/graphics/kdiagram/-/archive/2.6/kdiagram-2.6.tar.bz2" && \
    tar -xf kdiagram-2.6.tar.bz2 && mv kdiagram-2.6 kdiagram && rm kdiagram-2.6.tar.bz2

# build libunwind

WORKDIR /opt/libunwind

COPY tools/elf.h /usr/include/
RUN autoreconf -vfi && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr/local --enable-debug-frame --enable-minidebuginfo --disable-coredump && \
    make -j$(nproc) && make install

# build zstd

WORKDIR /opt/zstd

RUN make -j$(nproc) && make install

# build kdiagram

WORKDIR /opt/kdiagram

RUN cmake -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/opt -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && make install

# setup heaptrack build environment

FROM heaptrack_appimage_intermediate

ADD . /opt/heaptrack
WORKDIR /opt/heaptrack

CMD ./tools/build_appimage.sh /opt /artifacts
