FROM rustembedded/cross:aarch64-linux-android

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends --fix-missing libclang-dev wget unzip libz-dev && rm -rf /var/lib/apt/lists/*;

# Remove the existing npk and replace with r19c
RUN rm -r /android-ndk
COPY install-ndk.sh /
RUN /install-ndk.sh && rm /install-ndk.sh

COPY install-squashfs-tools.sh /
RUN /install-squashfs-tools.sh && rm /install-squashfs-tools.sh

ENV PATH=/android-ndk/bin:$PATH \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android28-clang \
    CC_aarch64_linux_android=aarch64-linux-android28-clang \
    CXX_aarch64_linux_android=aarch64-linux-android28-clang++