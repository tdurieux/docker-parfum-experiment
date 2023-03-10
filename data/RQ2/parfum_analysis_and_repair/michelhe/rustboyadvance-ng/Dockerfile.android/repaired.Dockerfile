FROM npetrovsky/docker-android-sdk-ndk

# Update default packages
RUN apt-get update

# Get Ubuntu packages
RUN apt-get install --no-install-recommends -y \
    build-essential \
    curl && rm -rf /var/lib/apt/lists/*;

# Update new packages
RUN apt-get update

# Get Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

RUN . $HOME/.cargo/env && rustup target add aarch64-linux-android armv7-linux-androideabi i686-linux-android

ENV NDK=$ANDROID_HOME/ndk-bundle

RUN echo \
        '[target.aarch64-linux-android]\n'\ 
        'ar = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/aarch64-linux-android/bin/ar "\n'\
        'linker = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android26-clang"\n'\
        \
        '[target.armv7-linux-androideabi]\n'\
        'ar = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/arm-linux-androideabi/bin/ar "\n'\
        'linker = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi26-clang"\n'\
        \
        '[target.i686-linux-android]\n'\
        'ar = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/i386-linux-android/bin/ar"\n'\
        'linker = "/opt/android-sdk-linux/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android26-clang"' > $HOME/.cargo/config
