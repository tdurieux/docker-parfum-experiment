FROM ubuntu:focal

#Locale
ENV LANG C.UTF-8

#
# Android SDK
# https://developer.android.com/studio#downloads
ENV ANDROID_SDK_TOOLS_VERSION 6858069
ENV ANDROID_PLATFORM_VERSION 31
ENV ANDROID_BUILD_TOOLS_VERSION 32.0.0-rc1
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_SDK_ROOT="$ANDROID_HOME"
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

#
# Flutter SDK
# https://flutter.dev/docs/development/tools/sdk/releases?tab=linux
ENV FLUTTER_CHANNEL="master"
ENV FLUTTER_VERSION="2.6.0-12.0.pre.901"
# Set this variable as "enable" to auto config flutter web-server.
# Make sure to use the needed channel and version for this.
ENV FLUTTER_WEB="enable"
ENV FLUTTER_HOME=/opt/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#
# Install needed packages, setup user anda clean up.
RUN apt-get update \
	&& apt-get install --no-install-recommends -y sudo \
	&& apt-get install -y openjdk-8-jdk-headless --no-install-recommends \
	&& apt-get install -y wget curl git xz-utils zip unzip --no-install-recommends \
	# Clean Up
	&& apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* \
	# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
	# [Optional] Add sudo support for the non-root user
	&& groupadd --gid $USER_GID $USERNAME \
	&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
	&& chmod 0440 /etc/sudoers.d/$USERNAME

#
# Android SDK
RUN cd /opt \
	&& curl -f -C - --output android-sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip \
	&& mkdir -p ${ANDROID_HOME}/cmdline-tools/ \
	&& unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
	&& mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools  ${ANDROID_HOME}/cmdline-tools/tools \
	&& rm android-sdk-tools.zip \
	&& yes | sdkmanager --licenses \
	&& touch $HOME/.android/repositories.cfg \
	&& sdkmanager --update \
	&& sdkmanager platform-tools \
	&& sdkmanager emulator \
	&& sdkmanager "platforms;android-$ANDROID_PLATFORM_VERSION" "build-tools;$ANDROID_BUILD_TOOLS_VERSION"

#
# Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /opt/flutter/
RUN cd /opt \
	&& yes | flutter doctor --android-licenses \
	&& flutter config --no-analytics \
	&& if [ "$FLUTTER_WEB" = "enable" ]; then flutter config --enable-web; fi \
	&& flutter update-packages

RUN dart pub global activate derry
# Run basic check to download Dark SDK
RUN flutter doctor
