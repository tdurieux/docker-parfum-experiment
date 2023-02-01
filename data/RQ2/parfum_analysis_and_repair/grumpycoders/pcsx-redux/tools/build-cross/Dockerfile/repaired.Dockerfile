# Dockerfile for grumpycoders/pcsx-redux-build-cross
# IMPORTANT: to build this file, the package qemu-user-static needs to be
# installed on the host machine.

FROM debian:bookworm-slim

# The tzdata package isn't docker-friendly, and something pulls it.
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/GMT

RUN apt update
RUN apt dist-upgrade -y

# Utility packages
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;

# Compilers & base libraries
RUN apt install --no-install-recommends -y g++-10 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gcc-10 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
# CI utilities
RUN apt install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python-is-python3 && rm -rf /var/lib/apt/lists/*;


# Cross Compiler stuff
RUN apt install --no-install-recommends -y debootstrap && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y qemu-user-static && rm -rf /var/lib/apt/lists/*;

WORKDIR /

# Create directory to hold aarch64 sysroot
RUN mkdir -p /opt/cross/sysroot

# Run debootstrap to pull down Debian bookworm aarch64 rootfs
RUN debootstrap --arch=arm64 --variant=minbase \
    --include=\
build-essential,\
pkg-config,\
libavcodec-dev,\
libavformat-dev,\
libavutil-dev,\
libcapstone-dev,\
libcurl4-openssl-dev,\
libfreetype-dev,\
libglfw3-dev,\
libswresample-dev,\
libuv1-dev,\
zlib1g-dev --foreign bookworm /opt/cross/sysroot

# Copy qemu-user-static over to sysroot so second stage can run
RUN cp /usr/bin/qemu-aarch64-static /opt/cross/sysroot/usr/bin/

# chroot into aarch64 sysroot and run debootstrap second stage to unpack packages and set up symlinks
RUN chroot /opt/cross/sysroot /usr/bin/qemu-aarch64-static /bin/sh -c "/debootstrap/debootstrap --second-stage"

# Fix symlinks in the sysroot
WORKDIR /opt/cross
RUN wget https://raw.githubusercontent.com/abhiTronix/rpi_rootfs/master/scripts/sysroot-relativelinks.py
RUN chmod +x sysroot-relativelinks.py
RUN ./sysroot-relativelinks.py sysroot

RUN mkdir /project
RUN mkdir -p /home/coder/dconf
RUN chmod a+rwx /home/coder/dconf
WORKDIR /project
