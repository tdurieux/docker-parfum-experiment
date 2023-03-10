FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
        apt-get install --no-install-recommends -y \
            wget \
            unzip \
            openjdk-11-jre-headless \
            make \
            gcc-10 \
            g++-10 \
            xz-utils && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/gcc-10 /usr/bin/gcc && \
        ln -s /usr/bin/g++-10 /usr/bin/g++

RUN mkdir /dockerbuild
WORKDIR /dockerbuild

# Install cmake
ENV ver=3.19.3
RUN wget https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver-Linux-x86_64.sh && \
        sh cmake-$ver-Linux-x86_64.sh --skip-license --prefix=/usr/local

ENV ver=6858069_latest
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-$ver.zip && \
        unzip commandlinetools-linux-$ver.zip && \
        mkdir -p /android-sdk/cmdline-tools && \
        mv cmdline-tools /android-sdk/cmdline-tools/latest

ENV ANDROID_HOME /android-sdk
ENV ANDROID_SDK  $ANDROID_HOME
ENV PATH $ANDROID_HOME/cmdline-tools/latest/bin:$PATH

ENV ANDROID_API=30
ENV ANDROID_PLATFORM=android-$ANDROID_API
RUN yes | sdkmanager --install "platforms;$ANDROID_PLATFORM"

ENV NDK_VER=21.4.7075529
ENV ANDROID_NDK_HOME $ANDROID_HOME/ndk/$NDK_VER
ENV ANDROID_NDK      $ANDROID_NDK_HOME
RUN yes | sdkmanager --install "ndk;$NDK_VER"

ENV BUILD_TOOLS_VER=30.0.3
RUN yes | sdkmanager --install "build-tools;$BUILD_TOOLS_VER"

RUN apt-get update -y && apt-get install --no-install-recommends -y openjdk-11-jdk-headless perl pkg-config git python3 python-is-python3 python3-distutils python3-yaml && rm -rf /var/lib/apt/lists/*;

ENV ver=5.15.2
RUN wget https://download.qt.io/official_releases/qt/5.15/$ver/submodules/qtbase-everywhere-src-$ver.tar.xz && \
        tar -xvf qtbase-everywhere-src-$ver.tar.xz && rm qtbase-everywhere-src-$ver.tar.xz
RUN mkdir qtbase-build && \
        cd qtbase-build && \
        ../qtbase-everywhere-src-$ver/configure \
            -opensource \
            -confirm-license \
            -xplatform android-clang \
            -release \
            -shared \
            -android-ndk $ANDROID_NDK_HOME \
            -android-sdk $ANDROID_HOME \
            -prefix /android

RUN apt-get update -y && apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

RUN cd qtbase-build && \
        ../qtbase-everywhere-src-$ver/configure \
            -opensource \
            -confirm-license \
            -xplatform android-clang \
            -release \
            -shared \
            -android-ndk $ANDROID_NDK_HOME \
            -android-sdk $ANDROID_HOME \
            -prefix /android \
            -nomake examples \
            -nomake tests \
            -no-feature-concurrent \
            -no-feature-sql \
            -no-feature-xml && \
        make -j$(nproc) && \
        make install

ENV ver=5.15.2
RUN wget https://download.qt.io/official_releases/qt/5.15/$ver/submodules/qtdeclarative-everywhere-src-$ver.tar.xz && \
        tar -xvf qtdeclarative-everywhere-src-$ver.tar.xz && rm qtdeclarative-everywhere-src-$ver.tar.xz
RUN cd qtdeclarative-everywhere-src-$ver && \
        /android/bin/qmake && \
        make -j$(nproc) && \
        make install

ENV ver=5.15.2
RUN wget https://download.qt.io/official_releases/qt/5.15/$ver/submodules/qtquickcontrols2-everywhere-src-$ver.tar.xz && \
        tar -xvf qtquickcontrols2-everywhere-src-$ver.tar.xz && rm qtquickcontrols2-everywhere-src-$ver.tar.xz
RUN cd qtquickcontrols2-everywhere-src-$ver && \
        /android/bin/qmake && \
        make -j$(nproc) && \
        make install

COPY set-env-android.sh /set-env-android.sh

# Build fftw3
ENV ver=3.3.9
RUN wget https://www.fftw.org/fftw-$ver.tar.gz && \
        tar -xvf fftw-$ver.tar.gz && rm fftw-$ver.tar.gz
ENV ARCH=arm
RUN cd fftw-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        ../../configure $configure_flags --enable-shared --disable-static && \
        make -j$(nproc) && \
        make install
ENV ARCH=arm64
RUN cd fftw-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        ../../configure $configure_flags --enable-shared --disable-static && \
        make -j$(nproc) && \
        make install
ENV ARCH=x86
RUN cd fftw-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        ../../configure $configure_flags --enable-shared --disable-static && \
        make -j$(nproc) && \
        make install
ENV ARCH=x86_64
RUN cd fftw-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        ../../configure $configure_flags --enable-shared --disable-static && \
        make -j$(nproc) && \
        make install

# Build eigen3
ENV ver=3.3.9
RUN wget https://gitlab.com/libeigen/eigen/-/archive/$ver/eigen-$ver.tar.gz && \
        tar -xvf eigen-$ver.tar.gz && rm eigen-$ver.tar.gz
ENV ARCH=arm
RUN cd eigen-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DCMAKE_INSTALL_PREFIX=$INS_PREFIX ../.. && \
        make -j$(nproc) && \
        make install
ENV ARCH=arm64
RUN cd eigen-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DCMAKE_INSTALL_PREFIX=$INS_PREFIX ../.. && \
        make -j$(nproc) && \
        make install
ENV ARCH=x86
RUN cd eigen-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DCMAKE_INSTALL_PREFIX=$INS_PREFIX ../.. && \
        make -j$(nproc) && \
        make install
ENV ARCH=x86_64
RUN cd eigen-$ver && \
        . /set-env-android.sh && \
        mkdir -p build/$HOST && \
        cd build/$HOST && \
        cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE -DCMAKE_INSTALL_PREFIX=$INS_PREFIX ../.. && \
        make -j$(nproc) && \
        make install

ENV ver=5.15.2
RUN wget https://download.qt.io/official_releases/qt/5.15/$ver/submodules/qtandroidextras-everywhere-src-$ver.tar.xz && \
        tar -xvf qtandroidextras-everywhere-src-$ver.tar.xz && rm qtandroidextras-everywhere-src-$ver.tar.xz
RUN cd qtandroidextras-everywhere-src-$ver && \
        /android/bin/qmake && \
        make -j$(nproc) && \
        make install

ENV ver=5.15.2
RUN wget https://download.qt.io/official_releases/qt/5.15/$ver/submodules/qtcharts-everywhere-src-$ver.tar.xz && \
        tar -xvf qtcharts-everywhere-src-$ver.tar.xz && rm qtcharts-everywhere-src-$ver.tar.xz
RUN cd qtcharts-everywhere-src-$ver && \
        /android/bin/qmake && \
        make -j$(nproc) && \
        make install

RUN /android/src/3rdparty/gradle/gradlew

RUN rm -r /dockerbuild

CMD cd /build && \
        . /set-env-android.sh && \
        export version=`cat /src/version` && \
        cmake \
            -DCUR_VERSION=$version \
            -DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE \
            -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
            -DCMAKE_PREFIX_PATH="/android;$INS_PREFIX" \
            -DEigen3_DIR=$INS_PREFIX/share/eigen3/cmake \
            -DANDROID_PLATFORM=$ANDROID_PLATFORM \
            -DANDROID_ABI="$ANDROID_ABI" \
            -DANDROID_SDK="$ANDROID_SDK" \
            /src && \
        make -j$(nproc) && \
        /src/docker/deploy-android.sh
