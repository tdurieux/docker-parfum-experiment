FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
        apt-get install --no-install-recommends -y \
            build-essential \
            clang-11 \
            clang++-11 \
            llvm-11-dev \
            llvm-11-tools \
            libxml2-dev \
            uuid-dev \
            libssl-dev \
            make \
            tar \
            xz-utils \
            bzip2 \
            gzip \
            cpio \
            libbz2-dev \
            zlib1g-dev \
            cmake \
            git \
            python3 python3-pip python-is-python3 && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/clang-11 /usr/bin/clang && \
        ln -s /usr/bin/clang++-11 /usr/bin/clang++ && \
        ln -s /usr/bin/llvm-config-11 /usr/bin/llvm-config

COPY MacOSX11.3.sdk.tar.xz /dockerbuild/MacOSX11.3.sdk.tar.xz
RUN git clone https://github.com/tpoechtrager/osxcross && \
        mv /dockerbuild/MacOSX11.3.sdk.tar.xz osxcross/tarballs && \
        cd osxcross && \
        UNATTENDED=1 ./build.sh

ENV HOST x86_64-apple-darwin20.4

# Install qt
RUN pip install --no-cache-dir aqtinstall==1.2.2
COPY aqtinstall-patch/updater.py /usr/local/lib/python3.8/dist-packages/aqt
RUN aqt install 6.1.2 mac desktop -m addons.qtcharts --outputdir /opt/Qt

# Replace mac binaries with linux Binaries
RUN aqt install 6.1.2 linux desktop --noarchives -m qtbase qtdeclarative icu --outputdir /opt/Qt && \
	rm -r /opt/Qt/6.1.2/macos/bin /opt/Qt/6.1.2/macos/libexec && \
	ln -s /opt/Qt/6.1.2/gcc_64/bin /opt/Qt/6.1.2/macos/bin && \
	ln -s /opt/Qt/6.1.2/gcc_64/libexec /opt/Qt/6.1.2/macos/libexec

ENV PATH /osxcross/target/bin:$PATH
ENV CC /osxcross/target/bin/$HOST-clang
ENV CXX /osxcross/target/bin/$HOST-clang++

RUN apt-get update -y && apt-get install --no-install-recommends -y autoconf wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /dockerbuild

# Build portaudio
RUN wget https://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz && \
        tar -xvf pa_stable_v190700_20210406.tgz && rm pa_stable_v190700_20210406.tgz
RUN cd portaudio && \
        autoconf && \
        mkdir objs && \
        cd objs && \
        CFLAGS="-arch x86_64 -Wno-implicit-int-float-conversion" \
        ../configure --host=$HOST --prefix=/osxcross/target/$HOST --enable-shared --disable-static --disable-mac-universal --disable-dependency-tracking && \
        make -j$(nproc) && \
        make install

# Build fftw3
ENV ver=3.3.9
RUN wget https://www.fftw.org/fftw-$ver.tar.gz && \
        tar -xvf fftw-$ver.tar.gz && rm fftw-$ver.tar.gz
RUN cd fftw-$ver && \
        mkdir build && \
        cd build && \
        CFLAGS="-arch x86_64" \
        ../configure --host=$HOST --prefix=/osxcross/target/$HOST --enable-shared --disable-static --disable-mac-universal --disable-dependency-tracking && \
        make -j$(nproc) && \
        make install

# Build eigen3
ENV ver=3.3.9
RUN wget https://gitlab.com/libeigen/eigen/-/archive/$ver/eigen-$ver.tar.gz && \
        tar -xvf eigen-$ver.tar.gz && rm eigen-$ver.tar.gz
RUN cd eigen-$ver && \
        mkdir build && \
        cd build && \
        $HOST-cmake -DCMAKE_INSTALL_PREFIX=/osxcross/target/$HOST .. && \
        make -j$(nproc) && \
        make install

RUN apt-get update -y && apt-get install --no-install-recommends -y pkg-config qt5-qmake qtbase5-dev unzip zlib1g-dev hfsprogs && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/clo-yunhee/pytorch_osx_cross/releases/download/1.7.1-osx-cross-1/libtorch-x86_64-darwin18.tar.gz && \
        tar -xvf libtorch-x86_64-darwin18.tar.gz -C /usr && rm libtorch-x86_64-darwin18.tar.gz

RUN git clone https://github.com/planetbeing/libdmg-hfsplus -b openssl-1.1
RUN cd libdmg-hfsplus && \
        mkdir build && \
        cd build && \
        CC= CXX= cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
        make -j$(nproc) && \
        make install

COPY macdeployqt macdeployqt
RUN cd macdeployqt && \
        /opt/Qt/6.1.2/macos/bin/qmake && \
        make -j$(nproc) && \
        cp macdeployqt /osxcross/target/bin

RUN rm -r /dockerbuild

COPY macos-toolchain.cmake /usr/macos-toolchain.cmake

RUN apt-get update -y && apt-get install --no-install-recommends -y ccache && rm -rf /var/lib/apt/lists/*;
ENV CCACHE_DIR=/ccache

RUN groupadd -g 1000 swu && useradd -m -u 1000 -g swu swu
USER swu

CMD cd /build && \
        export version=`cat /src/version` && \
        export QT_DIR=/opt/Qt/6.1.2/macos && \
        export MACOSX_DEPLOYMENT_TARGET=10.14 && \
        $HOST-cmake \
            -DCUR_VERSION=$version \
            -DCMAKE_TOOLCHAIN_FILE=/usr/macos-toolchain.cmake \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
            -DCMAKE_PREFIX_PATH="/opt/Qt/6.1.2/macos;/osxcross/target/$HOST;/usr/libtorch" \
            -DENABLE_TORCH=$ENABLE_TORCH \
            /src && \
        make -j$(nproc) && \
        DIST_SUFFIX=macos-x86_64 \
        /src/docker/deploy-macos.sh

