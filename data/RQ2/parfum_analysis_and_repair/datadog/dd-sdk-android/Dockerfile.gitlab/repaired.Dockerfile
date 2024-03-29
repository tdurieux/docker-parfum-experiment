FROM registry.ddbuild.io/images/mirror/ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apt-get update \
    && apt-get -y --no-install-recommends install openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
 && apt-get update \
 && apt-get -y upgrade \
 && apt-get -y install --no-install-recommends \
    curl \
    git \
    unzip \
    wget \
    openssh-client \
    expect \
    python3-distutils \
    python3-apt \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ENV GRADLE_VERSION 7.2
ENV ANDROID_COMPILE_SDK 31
ENV ANDROID_BUILD_TOOLS 31.0.0
ENV ANDROID_SDK_TOOLS 7583922
ENV NDK_VERSION 22.1.7171670
ENV CMAKE_VERSION 3.10.2.4988404



RUN apt update && apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

#  Install pip for aws
RUN set -x \
 && curl -f -OL https://bootstrap.pypa.io/get-pip.py \
 && python3 get-pip.py \
 && rm get-pip.py

RUN python3 --version

RUN set -x \
 && pip install --no-cache-dir awscli

# Gradle
RUN \
    cd /usr/local && \
    curl -f -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip && \
    rm gradle-${GRADLE_VERSION}-bin.zip

# Workaround for
# Warning: File /root/.android/repositories.cfg could not be loaded.
RUN mkdir /root/.android \
  && touch /root/.android/repositories.cfg


# Android SDK
RUN \
    wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip && \
    mkdir -p android-sdk-linux/cmdline-tools && \
    unzip -d android-sdk-linux/cmdline-tools android-sdk.zip && \
    mv android-sdk-linux/cmdline-tools/cmdline-tools android-sdk-linux/cmdline-tools/latest && \
    echo y | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null && \
    echo y | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager "platform-tools" >/dev/null && \
    echo y | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null && \
    echo y | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --install "ndk;${NDK_VERSION}" >/dev/null && \
    echo y | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --install "cmake;${CMAKE_VERSION}" >/dev/null && \
    yes | android-sdk-linux/cmdline-tools/latest/bin/sdkmanager --licenses

RUN set -x \
 && curl -f -OL https://s3.amazonaws.com/dd-package-public/dd-package.deb && dpkg -i dd-package.deb && rm dd-package.deb \
 && apt-get update \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_ROOT $PWD/android-sdk-linux
ENV ANDROID_HOME $PWD/android-sdk-linux
ENV GRADLE_HOME /usr/local/gradle-${GRADLE_VERSION}
ENV ANDROID_NDK $ANDROID_SDK_ROOT/ndk/${NDK_VERSION}
ENV PATH $PATH:$GRADLE_HOME/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:$ANDROID_SDK_ROOT/build-tools/${ANDROID_BUILD_TOOLS}:$ANDROID_NDK

# Woke
ENV WOKE_VERSION "0.6.0"
ENV WOKE_SHA256 "ea5605d4242b93d9586a21878264dd8abcf64ed92f0f6538ea831d9d3215b883"

RUN curl -f -L https://github.com/get-woke/woke/releases/download/v${WOKE_VERSION}/woke-${WOKE_VERSION}-linux-amd64.tar.gz -o woke-linux-amd64.tar.gz \
 && echo "${WOKE_SHA256}  woke-linux-amd64.tar.gz" | sha256sum -c \
 && tar -xf woke-linux-amd64.tar.gz \
 && mv woke-${WOKE_VERSION}-linux-amd64/woke /usr/bin/woke \
 && rm -Rf woke-${WOKE_VERSION}-linux-amd64 woke-${WOKE_VERSION}-linux-amd64.tar.gz
