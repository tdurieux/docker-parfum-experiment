# Linux, Windows, MacOS cross compile environment, based on Ubuntu Focal Fossa
# NOTE: This script does _not_ download the MacOS SDK from somewhere!
#       Instead it is expected to sit in the current folder as MacOSX11.1.sdk.tar.xz
#       or its location be passed via Docker ARGs "DARWIN_SDK_VERSION" and/or "DARWIN_SDK_PATH".

FROM ubuntu:20.04

### MingW64 setup taken over from mmozeiko/mingw-w64 #####################
# but I want Win32 threads, so I need to configure gcc differently

WORKDIR /mnt

ENV MINGW=/mingw

ARG PKG_CONFIG_VERSION=0.29.2
ARG CMAKE_VERSION=3.19.2
ARG BINUTILS_VERSION=2.35.1
ARG MINGW_VERSION=8.0.0
ARG GCC_VERSION=10.2.0
ARG NASM_VERSION=2.15.02
ARG NVCC_VERSION=11.2.0

SHELL [ "/bin/bash", "-c" ]

RUN set -ex \
    \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade --no-install-recommends -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates \
        gcc-10 \
        g++-10 \
        zlib1g-dev \
        libssl-dev \
        libgmp-dev \
        libmpfr-dev \
        libmpc-dev \
        libisl-dev \
        libssl1.1 \
        libgmp10 \
        libmpfr6 \
        libmpc3 \
        libisl22 \
        xz-utils \
        python \
        python-lxml \
        python-mako \
        ninja-build \
        texinfo \
        meson \
        gnupg \
        bzip2 \
        patch \
        gperf \
        bison \
        file \
        flex \
        make \
        yasm \
        wget \
        zip \
        git \
    \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 1000 --slave /usr/bin/g++ g++ /usr/bin/g++-10 \
    \
    && wget -q https://pkg-config.freedesktop.org/releases/pkg-config-${PKG_CONFIG_VERSION}.tar.gz -O - | tar -xz \
    && wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz -O - | tar -xz \
    && wget -q https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz -O - | tar -xJ \
    && wget -q https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${MINGW_VERSION}.tar.bz2 -O - | tar -xj \
    && wget -q https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz -O - | tar -xJ \
    && wget -q https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.xz -O - | tar -xJ \
    \
    && wget -q https://raw.githubusercontent.com/msys2/MINGW-packages/master/mingw-w64-gcc/0020-libgomp-Don-t-hard-code-MS-printf-attributes.patch -O - | \
        patch -d gcc-${GCC_VERSION} -p 1 \
    \
    && mkdir -p ${MINGW}/include ${MINGW}/lib/pkgconfig \
    && chmod 0777 -R /mnt ${MINGW} \
    \
    && cd pkg-config-${PKG_CONFIG_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix=/usr/local \
        --with-pc-path=${MINGW}/lib/pkgconfig \
        --with-internal-glib \
        --disable-shared \
        --disable-nls \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && cd cmake-${CMAKE_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix=/usr/local \
        --parallel=`nproc` \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && cd binutils-${BINUTILS_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix=/usr/local \
        --target=x86_64-w64-mingw32 \
        --disable-shared \
        --enable-static \
        --disable-lto \
        --disable-plugins \
        --disable-multilib \
        --disable-nls \
        --disable-werror \
        --with-system-zlib \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && mkdir mingw-w64 \
    && cd mingw-w64 \
    && ../mingw-w64-v${MINGW_VERSION}/mingw-w64-headers/configure \
        --prefix=/usr/local/x86_64-w64-mingw32 \
        --host=x86_64-w64-mingw32 \
        --enable-sdk=all \
        --enable-secure-api \
    && make install \
    && cd .. \

    && mkdir gcc \
    && cd gcc \
    && ../gcc-${GCC_VERSION}/configure \
        --prefix=/usr/local \
        --target=x86_64-w64-mingw32 \
        --enable-languages=c,c++ \
        --disable-shared \
        --enable-static \
        --enable-threads=win32 \
        --with-system-zlib \
        --enable-libgomp \
        --enable-libatomic \
        --enable-graphite \
        --disable-libstdcxx-pch \
        --disable-libstdcxx-debug \
        --disable-multilib \
        --disable-lto \
        --disable-nls \
        --disable-werror \
    && make -j`nproc` all-gcc \
    && make install-gcc \
    && cd .. \

    && cd mingw-w64 \
    && ../mingw-w64-v${MINGW_VERSION}/mingw-w64-crt/configure \
        --prefix=/usr/local/x86_64-w64-mingw32 \
        --host=x86_64-w64-mingw32 \
        --enable-wildcard \
        --disable-lib32 \
        --enable-lib64 \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && cd mingw-w64 \
    && ../mingw-w64-v${MINGW_VERSION}/mingw-w64-libraries/winpthreads/configure \
        --prefix=/usr/local/x86_64-w64-mingw32 \
        --host=x86_64-w64-mingw32 \
        --enable-static \
        --disable-shared \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && cd gcc \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && cd nasm-${NASM_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
    && make -j`nproc` \
    && make install \
    && cd .. \

    && rm -r pkg-config-${PKG_CONFIG_VERSION} \
    && rm -r cmake-${CMAKE_VERSION} \
    && rm -r binutils-${BINUTILS_VERSION} \
    && rm -r mingw-w64 mingw-w64-v${MINGW_VERSION} \
    && rm -r gcc gcc-${GCC_VERSION} \
    && rm -r nasm-${NASM_VERSION} \

    && apt-get remove --purge -y file gcc-10 g++-10 zlib1g-dev libssl-dev libgmp-dev libmpfr-dev libmpc-dev libisl-dev python-lxml python-mako \

    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub \
    && echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" > /etc/apt/sources.list.d/cuda.list \
    && apt-get update \

    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        cuda-nvcc-${NVCC_VERSION:0:2}-${NVCC_VERSION:3:1} \

    && ln -s /usr/local/cuda-${NVCC_VERSION:0:2}.${NVCC_VERSION:3:1} /usr/local/cuda \
    && ln -s /usr/bin/gcc-9 /usr/local/cuda/bin/gcc \
    && ln -s /usr/bin/g++-9 /usr/local/cuda/bin/g++ \

    && apt-get remove --purge -y gnupg \
    && apt-get autoremove --purge -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

### -- End of MingW64 setup taken over from mmozeiko/mingw-w64 --- #######


### MacOS ################################################################

# Install OS X cross-compiling toolchain (clang).
RUN apt-get install -y --no-install-recommends git sudo clang llvm-dev libxml2-dev uuid-dev libssl-dev bash patch make tar xz-utils bzip2 gzip sed cpio libbz2-dev zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
#Build arguments
ARG OSXCROSS_REPO="tpoechtrager/osxcross"
ARG DARWIN_SDK_VERSION="11.1"
ARG DARWIN_SDK_PATH="MacOSX${DARWIN_SDK_VERSION}.sdk.tar.xz"
ARG DARWIN_TOOLCHAIN="x86_64-apple-darwin20.2"

# ENV available in docker image
ENV CROSSBUILD=1 \
    OSX_SDK_PATH="/usr/osxcross/SDK/MacOSX${DARWIN_SDK_VERSION}.sdk" \
    OSX_TOOLCHAIN_PREFIX=${DARWIN_TOOLCHAIN}

# Clone the OSXCross repo, latest master
RUN git clone 'https://github.com/tpoechtrager/osxcross' /tmp/osxcross

# Copy the _provided_ MacOS SDK into the image as a tar ball (don't unpack yet! osxcross build.sh will do that later)
COPY ${DARWIN_SDK_PATH} /tmp/osxcross/tarballs/

# Build OSXCross
RUN cd /tmp/osxcross \
 && UNATTENDED=1 JOBS=4 SDK_VERSION=${DARWIN_SDK_VERSION} ./build.sh \
 && mv target /usr/osxcross \
 && mv tools /usr/osxcross/ \
 && sudo ldconfig /usr/osxcross/lib \
 && rm -rf "${OSX_SDK_PATH}/usr/share/man" \
 && rm -rf "/tmp/osxcross" \
 && true


### Linux ################################################################

# Install Linux toolchain (GCC) including CMake
RUN apt-get install -y --no-install-recommends \
        build-essential ninja-build \
        sudo bash coreutils curl \
        libcurl4-openssl-dev freeglut3-dev libudev-dev libopenal-dev \
 && apt-get clean \
# && curl -sSL https://github.com/Kitware/CMake/releases/download/v3.19.2/cmake-3.19.2-Linux-x86_64.tar.gz | tar -xz -C /usr/local/ --strip-components=1 \
 && true && rm -rf /var/lib/apt/lists/*;


### CURL #################################################################

# Download and build libCURL (in a limited version for our purposes: static only for HTTP and FTP)
RUN apt-get install -y --no-install-recommends curl \
 && mkdir /tmp/build-curl \
 && cd /tmp/build-curl \
 && curl -f -sSL https://curl.se/download/curl-7.74.0.tar.gz | tar -xz -C . --strip-components=1 && rm -rf /var/lib/apt/lists/*;
ARG MY_CURL_OPT="--enable-static --disable-shared --enable-optimize --without-zlib --enable-http --enable-ipv6 --disable-dict --disable-file --disable-gopher --disable-imap --disable-ldap --disable-mqtt --disable-pop3 --disable-rtsp --disable-smtp --disable-telnet"
ARG WIN_TOOLCHAIN_PREFIX="x86_64-w64-mingw32"

# --- Mingw64 (Windows) ---
RUN cd /tmp/build-curl \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host=${WIN_TOOLCHAIN_PREFIX} --prefix=/usr/${WIN_TOOLCHAIN_PREFIX} --exec-prefix=/usr/${WIN_TOOLCHAIN_PREFIX} --disable-pthreads --with-winssl ${MY_CURL_OPT} \
 # install header files
 && cd include \
 && make install \
 # make and install libcurl
 && cd ../lib \
 && make \
 && make install \
 # remove the temporary build directory
 && cd / \
 && rm -Rf /tmp/build-curl \
 && true

### Add OSXCross and Mingw paths
ENV PATH="${PATH}:/usr/osxcross/bin" \
    MINGW_TOOLCHAIN_PREFIX="x86_64-w64-mingw32" \
    MINGW_PATH="/usr/x86_64-w64-mingw32"
RUN sudo ldconfig /usr/osxcross/lib

### User / Entrypoint ####################################################expor

# Add essential users to the docker image
RUN apt-get install -y --no-install-recommends sudo && apt-get clean \
 && echo "" | adduser --uid 1000 --disabled-password  --gecos "" xpbuild && adduser xpbuild sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && rm -rf /var/lib/apt/lists/*;

VOLUME /build
USER xpbuild
ADD build.sh /usr/bin/build.sh

# Entrypoint is the build.sh script, which takes care of actual building
WORKDIR /build
ENTRYPOINT ["build.sh"]
