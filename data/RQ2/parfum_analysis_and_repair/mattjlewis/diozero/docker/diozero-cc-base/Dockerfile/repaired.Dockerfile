FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

# Install some tools and compilers + clean up
RUN apt-get update && apt-get -y upgrade && \
  apt-get install --no-install-recommends -y sudo git wget build-essential gawk texinfo bison file \
    gcc g++ gcc-8 g++-8 make cmake autoconf automake \
    bzip2 python python3 rsync libtool libtool-bin i2c-tools libi2c-dev && \
  apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# Generic cross-compilation toolchain
RUN sudo apt-get update && apt-get -y --no-install-recommends install build-essential lib32z1 \
  gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf binutils-aarch64-linux-gnu binutils-arm-linux-gnueabihf \
  crossbuild-essential-arm64 crossbuild-essential-armhf && rm -rf /var/lib/apt/lists/*;

# Enable x86
RUN sudo dpkg --add-architecture i386
RUN sudo apt-get update && apt-get -y --no-install-recommends install libstdc++6:i386 libgcc1:i386 zlib1g:i386 && rm -rf /var/lib/apt/lists/*;

# Install JDK 11
RUN sudo apt-get update && apt-get -y --no-install-recommends install openjdk-11-jdk-headless && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
