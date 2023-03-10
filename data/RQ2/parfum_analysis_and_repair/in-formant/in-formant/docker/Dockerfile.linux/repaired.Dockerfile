FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
        apt-get update -y && \
        apt-get install --no-install-recommends -y \
            gcc-10 \
            g++-10 \
            wget \
            make \
            libasound-dev \
            libpulse-dev \
            libpng-dev \
            libxcomposite-dev \
            libxcb-glx0-dev \
            libx11-xcb-dev \
            libxrender-dev \
            libxkbcommon-x11-dev \
            libfontconfig1-dev \
            libwayland-cursor0 \
            libgl1-mesa-glx \
            python3 python3-pip python-is-python3 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /dockerbuild
WORKDIR /dockerbuild
ENV CC=/usr/bin/gcc-10 CXX=/usr/bin/g++-10

RUN echo $PKG_CONFIG_PATH

# Install AppImageKit.
RUN wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage && \
        cp appimagetool-x86_64.AppImage /usr/local/bin/appimagetool && \
        chmod +x /usr/local/bin/appimagetool

# Install cmake
ENV ver=3.20.5
RUN wget https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver-Linux-x86_64.sh && \
        sh cmake-$ver-Linux-x86_64.sh --skip-license --prefix=/usr/local

RUN pip install --no-cache-dir aqtinstall
RUN aqt install 6.1.2 linux desktop -m addons.qtcharts --outputdir /opt/Qt

RUN apt-get update -y && apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;

# Build portaudio
RUN wget https://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz && \
        tar -xvf pa_stable_v190700_20210406.tgz && rm pa_stable_v190700_20210406.tgz
RUN cd portaudio && \
        mkdir objs && \
        cd objs && \
        ../configure --enable-shared --disable-static --prefix=/usr/local && \
        make -j$(nproc) && \
        make install

# Build eigen3
ENV ver=3.3.9
RUN wget https://gitlab.com/libeigen/eigen/-/archive/$ver/eigen-$ver.tar.gz && \
        tar -xvf eigen-$ver.tar.gz && rm eigen-$ver.tar.gz
RUN cd eigen-$ver && \
        mkdir build && \
        cd build && \
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
        make -j$(nproc) && \
        make install

# Build fftw3
ENV ver=3.3.9
RUN wget https://www.fftw.org/fftw-$ver.tar.gz && \
        tar -xvf fftw-$ver.tar.gz && rm fftw-$ver.tar.gz
RUN cd fftw-$ver && \
        mkdir build && \
        cd build && \
        ../configure --enable-shared --disable-static --prefix=/usr/local && \
        make -j$(nproc) && \
        make install

RUN apt-get update -y && \
        apt-get install --no-install-recommends -y mesa-common-dev unzip && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-cxx11-abi-shared-with-deps-1.7.1%2Bcpu.zip -O libtorch.zip && \
        unzip libtorch.zip && \
        mv libtorch /usr/libtorch

RUN wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage -O /usr/bin/linuxdeploy && \
        chmod 755 /usr/bin/linuxdeploy

RUN wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage -O /usr/bin/linuxdeploy-plugin-qt && \
        chmod 755 /usr/bin/linuxdeploy-plugin-qt

RUN apt-get update -y && apt-get install --no-install-recommends -y fuse libegl1-mesa libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libgssapi-krb5-2 libxcb-shape0 && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /dockerbuild

RUN apt-get update -y && apt-get install --no-install-recommends -y ccache && rm -rf /var/lib/apt/lists/*;
ENV CCACHE_DIR=/ccache

RUN groupadd -g 1000 swu && useradd -m -u 1000 -g swu swu
USER swu

CMD cd /build && \
        export version=`cat /src/version` && \
        export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64 && \
        export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig:/usr/local/pkgconfig:/usr/local/lib64/pkgconfig:/usr/local/share/pkgconfig && \
        cmake \
            -DCUR_VERSION=$version \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
            -DCMAKE_PREFIX_PATH="/opt/Qt/6.1.2/gcc_64;/usr/libtorch" \
            -DENABLE_TORCH=$ENABLE_TORCH \
            /src && \
        make -j$(nproc) && \
        /src/docker/deploy-linux.sh
