FROM ubuntu:14.04

MAINTAINER Jan Prach <jendap@google.com>

# Copy and run the install scripts.
COPY install/install_deb_packages.sh /install/install_deb_packages.sh
RUN /install/install_deb_packages.sh
COPY install/install_openjdk8_from_ppa.sh /install/install_openjdk8_from_ppa.sh
RUN /install/install_openjdk8_from_ppa.sh
COPY install/install_bazel.sh /install/install_bazel.sh
RUN /install/install_bazel.sh

# Set up bazelrc.
COPY install/.bazelrc /root/.bazelrc
ENV BAZELRC /root/.bazelrc

# Install extra libraries for android sdk.
# (see http://stackoverflow.com/questions/33427893/can-not-run-android-sdk-build-tools-23-0-2-aapt)
RUN apt-get update && apt-get install -y \
        lib32stdc++6 \
        lib32z1 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Android SDK.
ENV ANDROID_SDK_FILENAME android-sdk_r24.4.1-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVEL 23
ENV ANDROID_BUILD_TOOLS_VERSION 23.0.2
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo y | android update sdk --no-ui -a --filter tools,platform-tools,android-${ANDROID_API_LEVEL},build-tools-${ANDROID_BUILD_TOOLS_VERSION}

# Install Android NDK.
ENV ANDROID_NDK_FILENAME android-ndk-r10e-linux-x86_64.bin
ENV ANDROID_NDK_URL http://dl.google.com/android/ndk/${ANDROID_NDK_FILENAME}
ENV ANDROID_NDK_HOME /opt/android-ndk
ENV PATH ${PATH}:${ANDROID_NDK_HOME}
RUN cd /opt && \
    wget -q ${ANDROID_NDK_URL} && \
    chmod +x ${ANDROID_NDK_FILENAME} && \
    ./${ANDROID_NDK_FILENAME} -o/opt && \
    rm ${ANDROID_NDK_FILENAME} && \
    bash -c 'ln -s /opt/android-ndk-* /opt/android-ndk'

# Make android ndk executable to all users.
RUN chmod -R a+rx /opt
