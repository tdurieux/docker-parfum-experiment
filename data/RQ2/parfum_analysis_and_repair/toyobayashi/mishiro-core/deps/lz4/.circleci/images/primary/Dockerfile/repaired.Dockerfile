FROM circleci/buildpack-deps:bionic

RUN sudo apt-get -y -qq update
RUN sudo apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN sudo apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install qemu-system-ppc qemu-user-static qemu-system-arm && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install libc6-dev-armel-cross libc6-dev-arm64-cross libc6-dev-i386 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install clang clang-tools && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install gcc-5 gcc-5-multilib gcc-6 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install valgrind && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install gcc-multilib-powerpc-linux-gnu gcc-powerpc-linux-gnu gcc-arm-linux-gnueabi gcc-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
