FROM cloud9/workspace
# Android Build Dockerfile for Parafuzo.
#
# This is a fork from:
# https://github.com/lukin0110/docker-android-build
MAINTAINER Jeremy Ellis <keyfreemusic@gmail.com>

ADD ./files/workspace /home/ubuntu/workspace

RUN chmod -R g+w /home/ubuntu/workspace && \
    chown -R ubuntu:ubuntu /home/ubuntu/workspace

# Update, upgrade and install packages
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install curl unzip python-software-properties software-properties-common lib32stdc++6 lib32z1 && rm -rf /var/lib/apt/lists/*;

# Install Android SDK
# https://developer.android.com/sdk/index.html#Other
RUN SDK_VERSION=r24.3.3 && \
    set -x && \
    cd /usr/local/ && \
    curl -f -L -o android-sdk.tgz https://dl.google.com/android/android-sdk_${SDK_VERSION}-linux.tgz && \
    tar xf android-sdk.tgz && \
    rm android-sdk.tgz && \
    chmod -R +r /usr/local/android-sdk-* && \
    bash -c 'for file in $(find /usr/local/android-sdk-*); do [[ -x $file ]] && chmod +x "$file"; done'; \
    exit 0

# Install Android NDK
# https://developer.android.com/tools/sdk/ndk/index.html
# https://developer.android.com/ndk/index.html
RUN NDK_VERSION=r10e && \
    cd /usr/local && \
    curl -f -L -o android-ndk.bin https://dl.google.com/android/ndk/android-ndk-${NDK_VERSION}-linux-x86_64.bin && \
    chmod a+x android-ndk.bin && \
    ./android-ndk.bin && \
    rm -f android-ndk.bin && \
    chmod -R +r /usr/local/android-ndk-* && \
    bash -c 'for file in $(find /usr/local/android-ndk-*); do [[ -x $file ]] && chmod +x "$file"; done'

# Install Gradle
RUN GRADLE_VERSION=2.5 && \
    cd /usr/local && \
    curl -f -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o gradle-bin.zip && \
    unzip gradle-bin.zip && \
    rm gradle-bin.zip

# Update & Install Android Tools
# Cloud message, billing, licensing, play services, admob, analytics
RUN yes | (\
    /usr/local/android-sdk-linux/tools/android update sdk --filter tools --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter platform-tools --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter android-19 --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter android-20 --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter android-21 --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter android-22 --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter android-23 --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --filter extra --no-ui --force -a && \
    /usr/local/android-sdk-linux/tools/android update sdk --all --filter build-tools-23.0.2 --no-ui --force)

# Set PATH
RUN \
    echo 'export ANDROID_HOME=/usr/local/android-sdk-linux' > /etc/profile.d/android.sh && \
    echo 'export ANDROID_SDK_HOME=/usr/local/android-sdk-linux' >> /etc/profile.d/android.sh && \
    echo 'export ANDROID_NDK_HOME=/usr/local/android-ndk-r10e' >> /etc/profile.d/android.sh && \
    echo 'export GRADLE_HOME=/usr/local/gradle-2.5' >> /etc/profile.d/android.sh && \
    echo 'export NDK_PROJECT_PATH=/home/ubuntu/workspace' >> /etc/profile.d/android.sh && \
    echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_NDK_HOME/platform-tools:$ANDROID_NDK_HOME:$GRADLE_HOME/bin' >> /etc/profile.d/android.sh

ADD ./files/check-environment /.check-environment/android
