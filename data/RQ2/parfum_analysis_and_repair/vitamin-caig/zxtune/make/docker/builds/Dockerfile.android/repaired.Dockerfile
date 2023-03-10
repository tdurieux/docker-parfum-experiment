FROM debian:buster-slim

#mkdir is fix for openjdk install on empty system
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates wget unzip python make git python python3-minimal bzip2 nano \
            openjdk-11-jre-headless openjdk-11-jdk-headless libncurses5 ccache && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -s /bin/bash -U -G users -d /build build && \
    mkdir /ccache && chown build:users /ccache

USER build
WORKDIR /build

ENV androidsdk=/build/android-sdk prebuilt=/build/prebuilt CCACHE_DIR=/ccache

#Boost headers
ENV boost=1.77.0
RUN bash -c "wget -q https://boostorg.jfrog.io/artifactory/main/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    mkdir -p ${prebuilt}/boost-${boost}/include && \
    mv boost_*/boost ${prebuilt}/boost-${boost}/include/ && \
    rm -Rf boost_*

#Android SDK AGP=7.0.3
ENV build_tools=30.0.2 platform=31 ndk=21.4.7075529
RUN mkdir -p ${androidsdk} && cd ${androidsdk} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip && \
    unzip -q *.zip && \
    (yes | cmdline-tools/bin/sdkmanager --sdk_root=${androidsdk} --install "build-tools;${build_tools}" "platform-tools" "platforms;android-${platform}" "ndk;${ndk}") && \
    rm -Rf *.zip cmdline-tools

#Sources
RUN mkdir -p /build/zxtune && cd /build/zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "android.ndk=${androidsdk}/ndk/${ndk}\nprebuilt.dir=${prebuilt}\nboost.version=${boost}\n"\
         "tools.python=python3\n" > variables.mak && \
    mkdir -p apps/zxtune-android && echo "sdk.dir=${androidsdk}\nndk.version=${ndk}" > apps/zxtune-android/local.properties && \
    echo "org.gradle.jvmargs=-Xmx4g\nandroid.enableJetifier=true\nandroid.useAndroidX=true" > apps/zxtune-android/gradle.properties

# To allow volume binding with proper access rights
RUN  mkdir /build/.gradle && chown build:users /build/.gradle

WORKDIR /build/zxtune/apps/zxtune-android
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["publicBuild"]