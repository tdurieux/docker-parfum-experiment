FROM ubuntu:focal AS build
ENV container docker
RUN chmod 1777 /tmp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
        apt-get -y --no-install-recommends install wget unzip openjdk-11-jre cmake libglib2.0-dev git && rm -rf /var/lib/apt/lists/*;

# Install Android SDK.
ENV ver=6609375_latest
RUN mkdir /android-sdk && cd /android-sdk && \
        wget https://dl.google.com/android/repository/commandlinetools-linux-$ver.zip && \
        unzip commandlinetools-linux-$ver.zip && \
        rm commandlinetools-linux-$ver.zip && \
        mkdir cmdline-tools && \
        mv tools cmdline-tools/latest
ENV ANDROID_HOME=/android-sdk ANDROID_SDK=/android-sdk PATH=/android-sdk/cmdline-tools/latest/bin:$PATH
ENV android_api=30 ndk_ver=21.3.6528147 buildtools_ver=30.0.1
ENV ANDROID_PLATFORM=android-$android_api ANDROID_NDK_HOME=$ANDROID_HOME/ndk/$ndk_ver
RUN yes | sdkmanager --install "platforms;$ANDROID_PLATFORM"
RUN yes | sdkmanager --install "ndk;$ndk_ver"
RUN yes | sdkmanager --install "build-tools;$buildtools_ver"

COPY env-android.sh /usr/local/bin/env-android.sh

# Build pkgconfig
ENV ver=0.29.2
RUN wget https://pkg-config.freedesktop.org/releases/pkg-config-$ver.tar.gz && \
        tar xf pkg-config-$ver.tar.gz && rm pkg-config-$ver.tar.gz

SHELL ["/bin/bash", "-c"]

ENV arch=arm
RUN mkdir -p pkg-config-$ver/build-$arch && \
        cd pkg-config-$ver/build-$arch && \
        . env-android.sh android-$arch 1 && \
        ../configure --disable-host-tool --prefix=$ins_prefix && \
        make install -j$(nproc)

ENV arch=arm64
RUN mkdir -p pkg-config-$ver/build-$arch && \
        cd pkg-config-$ver/build-$arch && \
        . env-android.sh android-$arch 1 && \
        ../configure --disable-host-tool --prefix=$ins_prefix && \
        make install -j$(nproc)

ENV arch=x86
RUN mkdir -p pkg-config-$ver/build-$arch && \
        cd pkg-config-$ver/build-$arch && \
        . env-android.sh android-$arch 1 && \
        ../configure --disable-host-tool --prefix=$ins_prefix && \
        make install -j$(nproc)

ENV arch=x86_64
RUN mkdir -p pkg-config-$ver/build-$arch && \
        cd pkg-config-$ver/build-$arch && \
        . env-android.sh android-$arch 1 && \
        ../configure --disable-host-tool --prefix=$ins_prefix && \
        make install -j$(nproc)

# Build eigen3
ENV ver=3.3.7
RUN wget https://gitlab.com/libeigen/eigen/-/archive/$ver/eigen-$ver.tar.gz && \
        tar xf eigen-$ver.tar.gz && rm eigen-$ver.tar.gz

ENV arch=arm
RUN mkdir -p eigen-$ver/build-$arch && \
        cd eigen-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        cmake .. $cmake_flags && \
        make install -j$(nproc)

ENV arch=arm64
RUN mkdir -p eigen-$ver/build-$arch && \
        cd eigen-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        cmake .. $cmake_flags && \
        make install -j$(nproc)

ENV arch=x86
RUN mkdir -p eigen-$ver/build-$arch && \
        cd eigen-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        cmake .. $cmake_flags && \
        make install -j$(nproc)

ENV arch=x86_64
RUN mkdir -p eigen-$ver/build-$arch && \ 
        cd eigen-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        cmake .. $cmake_flags && \
        make install -j$(nproc)

# Build fftw3
ENV ver=3.3.8
RUN wget https://www.fftw.org/fftw-$ver.tar.gz && \
        tar xf fftw-$ver.tar.gz && rm fftw-$ver.tar.gz

ENV arch=arm
RUN mkdir -p fftw-$ver/build-$arch && \
        cd fftw-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        ../configure --enable-shared --disable-static $configure_flags && \
        make install -j$(nproc)

ENV arch=arm64
RUN mkdir -p fftw-$ver/build-$arch && \
        cd fftw-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        ../configure --enable-shared --disable-static $configure_flags && \
        make install -j$(nproc)

ENV arch=x86
RUN mkdir -p fftw-$ver/build-$arch && \
        cd fftw-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        ../configure --enable-shared --disable-static $configure_flags && \
        make install -j$(nproc)

ENV arch=x86_64
RUN mkdir -p fftw-$ver/build-$arch && \
        cd fftw-$ver/build-$arch && \
        . env-android.sh android-$arch && \
        ../configure --enable-shared --disable-static $configure_flags && \
        make install -j$(nproc)

# Build SDL2
ENV SDL2_ver=2.0.12
RUN wget https://www.libsdl.org/release/SDL2-$SDL2_ver.tar.gz && \
        tar xf SDL2-$SDL2_ver.tar.gz && \
        ln -s SDL2-$SDL2_ver SDL2 && rm SDL2-$SDL2_ver.tar.gz

RUN cd /SDL2/build-scripts && ./androidbuild.sh org.libsdl /dev/null
RUN cd /SDL2/build/org.libsdl/app && \
        rm -r jni/src && \
        ln -s /SDL2_ttf jni && \
        $ANDROID_NDK_HOME/ndk-build -j$(nproc)

COPY android-sdl2 /android-sdl2

ENV arch=arm
RUN cd /SDL2/build/org.libsdl/app && \
        . env-android.sh android-$arch && \
        mkdir -p $ins_prefix/lib && \
        cp libs/$android_abi/* $ins_prefix/lib && \
        mkdir -p $ins_prefix/include/SDL2 && \
        cp jni/SDL/include/* $ins_prefix/include/SDL2 && \
        mkdir -p $ins_prefix/lib/pkgconfig && \
        cp /android-sdl2/sdl2.pc $ins_prefix/lib/pkgconfig && \
        mkdir -p $ins_prefix/bin && \
        cp /android-sdl2/sdl2-config $ins_prefix/bin && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" $ins_prefix/lib/pkgconfig/sdl2.pc && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" -e "s/@SDL_VERSION@/${SDL2_ver}/g" $ins_prefix/bin/sdl2-config

ENV arch=arm64
RUN cd /SDL2/build/org.libsdl/app && \
        . env-android.sh android-$arch && \
        mkdir -p $ins_prefix/lib && \
        cp libs/$android_abi/* $ins_prefix/lib && \
        mkdir -p $ins_prefix/include/SDL2 && \
        cp jni/SDL/include/* $ins_prefix/include/SDL2 && \
        mkdir -p $ins_prefix/lib/pkgconfig && \
        cp /android-sdl2/sdl2.pc $ins_prefix/lib/pkgconfig && \
        mkdir -p $ins_prefix/bin && \
        cp /android-sdl2/sdl2-config $ins_prefix/bin && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" $ins_prefix/lib/pkgconfig/sdl2.pc && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" -e "s/@SDL_VERSION@/${SDL2_ver}/g" $ins_prefix/bin/sdl2-config

ENV arch=x86
RUN cd /SDL2/build/org.libsdl/app && \
        . env-android.sh android-$arch && \
        mkdir -p $ins_prefix/lib && \
        cp libs/$android_abi/* $ins_prefix/lib && \
        mkdir -p $ins_prefix/include/SDL2 && \
        cp jni/SDL/include/* $ins_prefix/include/SDL2 && \
        mkdir -p $ins_prefix/lib/pkgconfig && \
        cp /android-sdl2/sdl2.pc $ins_prefix/lib/pkgconfig && \
        mkdir -p $ins_prefix/bin && \
        cp /android-sdl2/sdl2-config $ins_prefix/bin && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" $ins_prefix/lib/pkgconfig/sdl2.pc && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" -e "s/@SDL_VERSION@/${SDL2_ver}/g" $ins_prefix/bin/sdl2-config

ENV arch=x86_64
RUN cd /SDL2/build/org.libsdl/app && \
        . env-android.sh android-$arch && \
        mkdir -p $ins_prefix/lib && \
        cp libs/$android_abi/* $ins_prefix/lib && \
        mkdir -p $ins_prefix/include/SDL2 && \
        cp jni/SDL/include/* $ins_prefix/include/SDL2 && \
        mkdir -p $ins_prefix/lib/pkgconfig && \
        cp /android-sdl2/sdl2.pc $ins_prefix/lib/pkgconfig && \
        mkdir -p $ins_prefix/bin && \
        cp /android-sdl2/sdl2-config $ins_prefix/bin && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" $ins_prefix/lib/pkgconfig/sdl2.pc && \
        sed -i -e "s/@PREFIX@/${ins_prefix//\//\\/}/g" -e "s/@SDL_VERSION@/${SDL2_ver}/g" $ins_prefix/bin/sdl2-config

ENV gver=4.10.2
RUN wget https://downloads.gradle-dn.com/distributions/gradle-$gver-bin.zip && \
        unzip gradle-$gver-bin.zip && \
        mv gradle-$gver gradle

# Install recent GLES headers
RUN mkdir gles-headers && \
        cd gles-headers && \
        wget https://www.khronos.org/registry/OpenGL/api/GLES3/gl3.h && \
        wget https://www.khronos.org/registry/OpenGL/api/GLES2/gl2ext.h && \
        for arch in arm arm64 x86 x86_64; do \
            mkdir -p /usr/android-$arch/include/GLES3; \
            cp gl3.h /usr/android-$arch/include/GLES3 ; \
            mkdir -p /usr/android-$arch/include/GLES2; \
            cp gl2ext.h /usr/android-$arch/include/GLES2 ; \
        done

ENV ver=0.9.9.8
RUN wget https://github.com/g-truc/glm/archive/$ver.tar.gz -O glm.tgz && \
        tar xf glm.tgz && rm glm.tgz
RUN cd glm-$ver && \
        for arch in arm arm64 x86 x86_64; do \
            cp -r glm /usr/android-$arch/include; \
        done

RUN for path in /usr/android-{arm,arm64,x86,x86_64}; do rm -r $path/share/{aclocal,doc,info,man}; done

FROM ubuntu:focal
COPY --from=build /android-sdk        /android-sdk
COPY --from=build /usr/android-arm    /usr/android-arm
COPY --from=build /usr/android-arm64  /usr/android-arm64
COPY --from=build /usr/android-x86    /usr/android-x86
COPY --from=build /usr/android-x86_64 /usr/android-x86_64
COPY --from=build /gradle             /gradle

RUN chmod 1777 /tmp

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
        apt-get -y --no-install-recommends install cmake openjdk-11-jre libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

ENV PATH=/gradle/bin:$PATH
RUN mkdir -p /tmp/gradle
COPY android-project/build.gradle /tmp/gradle
RUN cd /tmp/gradle && gradle --no-daemon

ENV android_api=30 ndk_ver=21.3.6528147
ENV ANDROID_HOME=/android-sdk ANDROID_PLATFORM=android-$android_api ANDROID_NDK_HOME=/android-sdk/ndk/$ndk_ver

COPY env-android.sh /usr/local/bin
COPY deploy-android.sh /usr/local/bin

SHELL ["/bin/bash", "-c"]
CMD . env-android.sh android-arm && \
        cd /build && \
        mkdir -p $target && \
        cd $target && \
        cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE $cmake_flags /src && \
        make -j$(nproc) && \
    . env-android.sh android-arm64 && \
        cd /build && \
        mkdir -p $target && \
        cd $target && \
        cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE $cmake_flags /src && \
        make -j$(nproc) && \
    . env-android.sh android-x86 && \
        cd /build && \
        mkdir -p $target && \
        cd $target && \
        cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE $cmake_flags /src && \
        make -j$(nproc) && \
    . env-android.sh android-x86_64 && \
        cd /build && \
        mkdir -p $target && \
        cd $target && \
        cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE $cmake_flags /src && \
        make -j$(nproc) && \
    deploy-android.sh $debug
