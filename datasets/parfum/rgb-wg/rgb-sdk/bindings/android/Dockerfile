FROM rust:1.47.0-slim-buster

# mkdir required to install openjdk on slim images
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y \
        cmake g++ git libpcre3-dev make openjdk-11-jdk unzip wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN wget https://freefr.dl.sourceforge.net/project/swig/swig/swig-4.0.1/swig-4.0.1.tar.gz && \
    tar xf swig-*.tar.gz && \
    cd swig-* && \
    ./configure && make -j12 && \
    make install && \
    rm -rf /tmp/*

ENV ANDROID_SDK_ROOT=/root/sdk
ARG NDK_VERSION=20.1.5948944
ENV NDK_HOME=$ANDROID_SDK_ROOT/ndk/$NDK_VERSION

RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip && \
    unzip commandlinetools-linux-*_latest.zip && \
    mkdir $ANDROID_SDK_ROOT && \
    mv tools $ANDROID_SDK_ROOT/ && \
    rm -rf /tmp/*

RUN yes | $ANDROID_SDK_ROOT/tools/bin/sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
        "platform-tools" \
        "build-tools;29.0.3" \
        "platforms;android-29" \
        "ndk;$NDK_VERSION" \
        "cmake;3.10.2.4988404"

RUN rustup target add \
        aarch64-linux-android \
        x86_64-linux-android \
        armv7-linux-androideabi \
        i686-linux-android

COPY bindings/android /rgb-sdk/bindings/android
COPY librgb /rgb-sdk/librgb

WORKDIR /rgb-sdk/bindings/android

RUN ./gradlew build
