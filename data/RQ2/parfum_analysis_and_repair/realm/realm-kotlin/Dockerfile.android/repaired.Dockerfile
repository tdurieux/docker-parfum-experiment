FROM ubuntu:18.04

# Locales
RUN apt-get clean && apt-get -y update && apt-get install --no-install-recommends -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV ANDROID_HOME /opt/android-sdk-linux
# Need by cmake
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV ANDROID_NDK /opt/android-ndk
ENV PATH ${PATH}:${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV PATH ${PATH}:${NDK_HOME}
ENV NDK_CCACHE /usr/bin/ccache
ENV CCACHE_CPP2 yes

# Keep the packages in alphabetical order to make it easy to avoid duplication
# tzdata needs to be installed first. See https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
# `file` is need by the Android Emulator
RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -y tzdata \
    && apt-get install --no-install-recommends -y bsdmainutils \
                          bridge-utils \
                          build-essential \
                          ccache \
                          curl \
                          file \
                          git \
                          jq \
                          libc6 \
                          libgcc1 \
                          libglu1 \
                          libncurses5 \
                          libssl-dev \
                          libstdc++6 \
                          libz1 \
                          libvirt-clients \
                          libvirt-daemon-system \
                          openjdk-8-jdk-headless \
                          openjdk-11-jdk-headless \
                          qemu-kvm \
                          s3cmd \
                          swig \
                          unzip \
                          virt-manager \
                          wget \
                          zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install the Android SDK
RUN cd /opt && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -O android-tools-linux.zip && \
    unzip android-tools-linux.zip -d ${ANDROID_HOME} && \
    rm -f android-tools-linux.zip

# Grab what's needed in the SDK
RUN sdkmanager --update

# Accept licenses before installing components, no need to echo y for each component
# License is valid for all the standard components in versions installed from this file
# Non-standard components: MIPS system images, preview versions, GDK (Google Glass) and Android Google TV require separate licenses, not accepted there
RUN yes | sdkmanager --licenses

# SDKs
# The `yes` is for accepting all non-standard tool licenses.
# Please keep all sections in descending order!
RUN yes | sdkmanager \
    'build-tools;29.0.3' \
    'cmake;3.6.4111459' \
    'emulator' \
    'extras;android;m2repository' \
    'platforms;android-29' \
    'platform-tools' \
    'ndk;21.0.6113669' \
    'system-images;android-29;default;x86_64'


# Make the SDK universally writable
RUN chmod -R a+rwX ${ANDROID_HOME}

ENV PATH "$ANDROID_HOME/cmake/3.6.4111459/bin:$PATH"

# Building core from source requires CMake 3.15 or higher
# Install CMake
RUN cd /opt \
    && wget https://cmake.org/files/v3.15/cmake-3.15.2-Linux-x86_64.tar.gz \
    && tar zxvf cmake-3.15.2-Linux-x86_64.tar.gz && rm cmake-3.15.2-Linux-x86_64.tar.gz

ENV PATH "/opt/cmake-3.15.2-Linux-x86_64/bin:$PATH"

