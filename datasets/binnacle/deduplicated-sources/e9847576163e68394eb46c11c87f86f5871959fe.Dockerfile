FROM debian:stretch-slim

#mkdir is fix for openjdk on stretch-slim
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
            ca-certificates wget unzip python make git python python3-minimal bzip2 \
            openjdk-8-jre-headless openjdk-8-jdk-headless libncurses5 && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /build

ENV toolchains=/build/toolchains androidsdk=/build/android-sdk prebuilt=/build/prebuilt

#Boost headers
ENV boost=1.70.0
RUN bash -c "wget -q https://dl.bintray.com/boostorg/release/${boost}/source/boost_\${boost//./_}.tar.bz2 -O - | tar -xj" && \
    mkdir -p ${prebuilt}/boost-${boost}/include && \
    mv boost_*/boost ${prebuilt}/boost-${boost}/include/ && \
    rm -Rf boost_*

#Android SDK
ENV build_tools=28.0.3 platform=28
RUN mkdir -p ${androidsdk} && cd ${androidsdk} && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip -q *.zip && \
    rm *.zip && \
    (yes | tools/bin/sdkmanager --install "build-tools;${build_tools}" "platform-tools" "platforms;android-${platform}")

#Gradle
ENV gradle=4.1
RUN wget -q https://services.gradle.org/distributions/gradle-${gradle}-bin.zip && \
    unzip -q *.zip && \
    echo "buildscript{\nrepositories{\njcenter()\ngoogle()\n}\ndependencies{\nclasspath 'com.android.tools.build:gradle:3.0.1'\n}\n}\nallprojects{\nrepositories\n{\njcenter()\ngoogle()\n}\n}" > build.gradle && \
    gradle*/bin/gradle tasks && \
    rm -Rf gradle* build.gradle

WORKDIR ${toolchains}
#NDK toolchains
ENV ndk_version=r20
RUN wget -q https://dl.google.com/android/repository/android-ndk-${ndk_version}-linux-x86_64.zip && \
    unzip -q *.zip && \
    mv android-ndk*/toolchains/llvm/prebuilt/linux-x86_64 . && \
    rm -Rf android-ndk-*

# TODO: remove after full clang support
COPY make_ndk_wrapper.sh .
RUN ./make_ndk_wrapper.sh arm-linux-androideabi armv7a-linux-androideabi16 && \
    ./make_ndk_wrapper.sh aarch64-linux-android aarch64-linux-android21 && \
    ./make_ndk_wrapper.sh i686-linux-android i686-linux-android16 && \
    ./make_ndk_wrapper.sh x86_64-linux-android x86_64-linux-android21

#Sources
RUN mkdir -p /build/zxtune && cd /build/zxtune && \
    git init && \
    git remote add --tags origin https://bitbucket.org/zxtune/zxtune.git && \
    echo "toolchains.root=${toolchains}\nprebuilt.dir=${prebuilt}\nboost.version=${boost}\n"\
         "tools.python=python3\nld_flags=-static-libstdc++\n" > variables.mak && \
    mkdir -p apps/zxtune-android && echo "sdk.dir=${androidsdk}" > apps/zxtune-android/local.properties && \
    echo "org.gradle.jvmargs=-Xmx2048M" > apps/zxtune-android/gradle.properties

WORKDIR /build/zxtune/apps/zxtune-android
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
CMD ["publicBuild"]
