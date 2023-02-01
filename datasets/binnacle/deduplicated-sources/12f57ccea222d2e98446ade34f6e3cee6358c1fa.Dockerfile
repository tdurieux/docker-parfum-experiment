# Minimal docker container to build project
# Image: rabits/qt:5.12-android

FROM ubuntu:18.04
MAINTAINER Rabit <home@rabits.org> (@rabits)

ARG QT_VERSION=5.12.0
ARG NDK_VERSION=r18b
ARG SDK_PLATFORM=android-21
ARG SDK_BUILD_TOOLS=21.1.2
ARG SDK_PACKAGES="tools platform-tools"

ENV DEBIAN_FRONTEND=noninteractive \
    QT_PATH=/opt/Qt
ENV QT_ANDROID ${QT_PATH}/${QT_VERSION}/android_armv7
ENV ANDROID_HOME /opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME} \
    ANDROID_NDK_ROOT=/opt/android-ndk \
    ANDROID_NDK_TOOLCHAIN_PREFIX=arm-linux-androideabi \
    ANDROID_NDK_TOOLCHAIN_VERSION=4.9 \
    ANDROID_NDK_HOST=linux-x86_64 \
    ANDROID_NDK_PLATFORM=${SDK_PLATFORM}
ENV ANDROID_NDK_TOOLS_PREFIX ${ANDROID_NDK_TOOLCHAIN_PREFIX}
ENV QMAKESPEC android-g++
ENV PATH ${QT_ANDROID}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Install updates & requirements:
#  * unzip - unpack platform tools
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * make, openjdk-8-jdk-headless, ant - basic build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3, libx11-xcb1 - dependencies of Qt bundle run-file
#  * libc6:i386, libncurses5:i386, libstdc++6:i386, libz1:i386 - dependencides of android sdk binaries
RUN dpkg --add-architecture i386 && apt update && apt full-upgrade -y && apt install -y --no-install-recommends \
    unzip \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    make \
    openjdk-8-jdk-headless \
    openjdk-8-jre-headless \
    ant \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    libx11-xcb1 \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libz1:i386 \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

COPY extract-qt-installer.sh /tmp/qt/

# Download & unpack Qt toolchains & clean
RUN curl -Lo /tmp/qt/installer.run "https://download.qt.io/official_releases/qt/$(echo "${QT_VERSION}" | cut -d. -f 1-2)/${QT_VERSION}/qt-opensource-linux-x64-${QT_VERSION}.run" \
    && QT_CI_PACKAGES=qt.qt5.$(echo "${QT_VERSION}" | tr -d .).android_armv7 /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "${QT_PATH}" -mindepth 1 -maxdepth 1 ! -name "${QT_VERSION}" -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \; \
    && rm -rf /tmp/qt

# Download & unpack android SDK
RUN curl -Lo /tmp/sdk-tools.zip 'https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip' \
    && mkdir -p /opt/android-sdk && unzip -q /tmp/sdk-tools.zip -d /opt/android-sdk && rm -f /tmp/sdk-tools.zip \
    && yes | sdkmanager --licenses && sdkmanager --update && sdkmanager --verbose "platforms;${SDK_PLATFORM}" "build-tools;${SDK_BUILD_TOOLS}" ${SDK_PACKAGES}

# Download & unpack android NDK
RUN mkdir /tmp/android && cd /tmp/android && curl -Lo ndk.zip "https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip" \
    && unzip -q ndk.zip && mv android-ndk-* $ANDROID_NDK_ROOT && chmod -R +rX $ANDROID_NDK_ROOT \
    && rm -rf /tmp/android

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
