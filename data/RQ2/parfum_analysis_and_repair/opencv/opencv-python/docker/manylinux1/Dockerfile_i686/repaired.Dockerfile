FROM quay.io/pypa/manylinux1_i686:latest

RUN curl -f -O -L https://download.qt.io/archive/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz && \
    tar -xf qt-everywhere-opensource-src-4.8.7.tar.gz && \
    cd qt-everywhere* && \
    #configure does a bootstrap make under the hood
    #manylinux1 is too old to have `nproc`
    export MAKEFLAGS=-j$(getconf _NPROCESSORS_ONLN) && \
    #OpenCV only links against QtCore, QtGui, QtTest
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" -prefix /opt/Qt4.8.7 -release -opensource -confirm-license -make && \
    make && \
    make install && \
    cd .. && \
    rm -rf qt-everywhere-opensource-src-4.8.7 && \
    rm qt-everywhere-opensource-src-4.8.7.tar.gz

ENV QTDIR /opt/Qt4.8.7
ENV PATH "$QTDIR/bin:$PATH"

RUN curl -f -O -L https://cmake.org/files/v3.9/cmake-3.9.0.tar.gz && \
    tar -xf cmake-3.9.0.tar.gz && \
    cd cmake-3.9.0 && \
    #manylinux1 provides curl-devel equivalent and libcurl statically linked
    # against the same newer OpenSSL as other source-built tools
    # (1.0.2s as of this writing)
    yum -y install zlib-devel && \
    #configure does a bootstrap make under the hood
    export MAKEFLAGS=-j$(getconf _NPROCESSORS_ONLN) && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --system-curl && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-3.9.0* && rm -rf /var/cache/yum

# https://trac.ffmpeg.org/wiki/CompilationGuide/Centos#GettheDependencies
# manylinux provides the toolchain and git; we provide cmake
RUN yum install freetype-devel bzip2-devel zlib-devel -y && \
    mkdir ~/ffmpeg_sources && rm -rf /var/cache/yum

# Newer openssl configure requires newer perl
RUN curl -f -O -L https://www.cpan.org/src/5.0/perl-5.20.1.tar.gz && \
    tar -xf perl-5.20.1.tar.gz && \
    cd perl-5.20.1 && \
    ./Configure -des -Dprefix="$HOME/openssl_build" && \
    #perl build scripts do much redundant work
    # if running "make install" separately
    make install -j$(getconf _NPROCESSORS_ONLN) && \
    cd .. && \
    rm -rf perl-5.20.1* && rm perl-5.20.1.tar.gz

RUN cd ~/ffmpeg_sources && \
    curl -f -O -L https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz && \
    tar -xf OpenSSL_1_1_1c.tar.gz && \
    cd openssl-OpenSSL_1_1_1c && \
    #in i686, ./config detects x64 in i686 container without linux32
    # when run from "docker build"
    PERL="$HOME/openssl_build/bin/perl" linux32 ./config --prefix="$HOME/ffmpeg_build" --openssldir="$HOME/ffmpeg_build" shared zlib && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    #skip installing documentation
    make install_sw && \
    rm -rf ~/openssl_build && rm OpenSSL_1_1_1c.tar.gz

RUN cd ~/ffmpeg_sources && \
    curl -f -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.01/nasm-2.14.01.tar.bz2 && \
    tar -xf nasm-2.14.01.tar.bz2 && cd nasm-2.14.01 && ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && rm nasm-2.14.01.tar.bz2

RUN cd ~/ffmpeg_sources && \
    curl -f -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
    tar -xf yasm-1.3.0.tar.gz && \
    cd yasm-1.3.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && rm yasm-1.3.0.tar.gz

RUN cd ~/ffmpeg_sources && \
    git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
    cd libvpx && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm --enable-pic --enable-shared && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install

RUN cd ~/ffmpeg_sources && \
    curl -f -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar -xf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    PATH=~/bin:$PATH && \
    PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --enable-openssl --enable-libvpx --enable-shared --enable-pic --bindir="$HOME/bin" && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    echo "/root/ffmpeg_build/lib/" >> /etc/ld.so.conf && \
    ldconfig && \
    rm -rf ~/ffmpeg_sources && rm ffmpeg-snapshot.tar.bz2

ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig:/root/ffmpeg_build/lib/pkgconfig
ENV LDFLAGS -L/root/ffmpeg_build/lib

RUN curl -f -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/videodev2.h && \
    curl -f -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/v4l2-common.h && \
    curl -f -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/uapi/linux/v4l2-controls.h && \
    curl -f -O https://raw.githubusercontent.com/torvalds/linux/v4.14/include/linux/compiler.h && \
    mv videodev2.h v4l2-common.h v4l2-controls.h compiler.h /usr/include/linux

#in i686, yum metadata ends up with slightly wrong timestamps
#which inhibits its update
#https://github.com/skvark/opencv-python/issues/148
RUN yum clean all

ENV PATH "$HOME/bin:$PATH"
