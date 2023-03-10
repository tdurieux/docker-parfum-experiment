FROM devnexen/android-ndk:r20 AS android-ndk
ARG ANDROID_ARCH
ARG ANDROID_TOOLCHAIN_SUF
ARG ANDROID_ARCH_SUF
ARG ANDROID_SDK_VER
RUN apt-get update && apt-get install -y --no-install-recommends python && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /botan/android
WORKDIR /botan
COPY configure.py configure.py
COPY src src
COPY doc doc
COPY license.txt license.txt
COPY news.rst news.rst
ENV PATH=$PATH:/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin/
RUN ./configure.py --prefix=android/arm --os=android --cpu=${ANDROID_ARCH} --cc=clang --cc-bin=${ANDROID_ARCH}${ANDROID_ARCH_SUF}-linux-android${ANDROID_TOOLCHAIN_SUF}${ANDROID_SDK_VER}-clang++ --ar-command=${ANDROID_ARCH}${ANDROID_ARCH_SUF}-linux-android${ANDROID_TOOLCHAIN_SUF}-ar
RUN make -j`getconf _NPROCESSORS_ONLN`
RUN make install
