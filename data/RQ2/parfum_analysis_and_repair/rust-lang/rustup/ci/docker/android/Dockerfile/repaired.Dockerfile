FROM rust-android

ENV PATH=$PATH:/android/ndk/arm-21/bin:/android/ndk/arm64-21/bin:/android/ndk/x86-21/bin:/android/ndk/x86_64-21/bin \
    CC_arm_linux_androideabi=arm-linux-androideabi-clang \
    CC_armv7_linux_androideabi=arm-linux-androideabi-clang \
    CC_aarch64_linux_android=aarch64-linux-android-clang \
    CC_i686_linux_android=i686-linux-android-clang \
    CC_x86_64_linux_android=x86_64-linux-android-clang \
    CXX_arm_linux_androideabi=arm-linux-androideabi-clang++ \
    CXX_armv7_linux_androideabi=arm-linux-androideabi-clang++ \
    CXX_aarch64_linux_android=aarch64-linux-android-clang++ \
    CXX_i686_linux_android=i686-linux-android-clang++ \
    CXX_x86_64_linux_android=x86_64-linux-android-clang++ \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-clang \
    CARGO_TARGET_ARMV7_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-clang \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-clang \
    CARGO_TARGET_I686_LINUX_ANDROID_LINKER=i686-linux-android-clang \
    CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=x86_64-linux-android-clang