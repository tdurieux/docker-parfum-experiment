ARG img_version
FROM godot-mono:${img_version}

ARG mono_version

ENV ANDROID_SDK_ROOT=/root/sdk
ENV ANDROID_NDK_VERSION=23.2.8568313
ENV ANDROID_NDK_ROOT=${ANDROID_SDK_ROOT}/ndk/${ANDROID_NDK_VERSION}

RUN if [ -z "${mono_version}" ]; then echo -e "\n\nargument mono-version is mandatory!\n\n"; exit 1; fi && \
    dnf -y install --setopt=install_weak_deps=False \
      java-11-openjdk-devel ncurses-compat-libs && \
    mkdir -p sdk && cd sdk && \
    export CMDLINETOOLS=commandlinetools-linux-8512546_latest.zip && \
    curl -f -LO https://dl.google.com/android/repository/${CMDLINETOOLS} && \
    unzip ${CMDLINETOOLS} && \
    rm ${CMDLINETOOLS} && \
    yes | cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --licenses && \
    cmdline-tools/bin/sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" "ndk;${ANDROID_NDK_VERSION}" 'cmdline-tools;latest' 'build-tools;32.0.0' 'platforms;android-32' 'cmake;3.18.1'

RUN cp -a /root/files/${mono_version} /root && \
    export MONO_SOURCE_ROOT=/root/${mono_version} && \
    cd /root/${mono_version}/godot-mono-builds && \
    python3 android.py configure -j --target=all-targets && \
    python3 android.py make -j --target=all-targets && \
    python3 bcl.py make -j --product=android && \
    cd /root && \
    rm -rf /root/${mono_version}

CMD /bin/bash
