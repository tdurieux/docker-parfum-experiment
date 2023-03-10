# Built from https://github.com/qwandor/cross/blob/context/docker/Dockerfile.context
FROM ghcr.io/qwandor/cross-context:0.2.1 as context

# Debian and Raspberry Pi use armhf to refer to different architectures
# Raspberry Pi 1 (A, B, A+, B+, Zero, Zero W) is supported by armel for Debian
# More details here https://wiki.debian.org/RaspberryPi#Raspberry_Pi_1_.28A.2C_B.2C_A.2B-.2C_B.2B-.2C_Zero.2C_Zero_W.29

FROM debian:buster

COPY --from=context common.sh lib.sh /
RUN /common.sh

COPY --from=context cmake.sh /
RUN /cmake.sh

COPY --from=context xargo.sh /
RUN /xargo.sh

RUN apt-get install -y --assume-yes --no-install-recommends \
	g++-arm-linux-gnueabi \
	libc6-dev-armel-cross && rm -rf /var/lib/apt/lists/*;

RUN dpkg --add-architecture armel && \
	apt-get update && \
	apt-get install --no-install-recommends -y libdbus-1-dev:armel && rm -rf /var/lib/apt/lists/*;

ENV CARGO_TARGET_ARM_UNKNOWN_LINUX_GNUEABI_LINKER=arm-linux-gnueabi-gcc \
	CC_arm_unknown_linux_gnueabi=arm-linux-gnueabi-gcc \
	CXX_arm_unknown_linux_gnueabi=arm-linux-gnueabi-g++ \
	QEMU_LD_PREFIX=/usr/arm-linux-gnueabi \
	RUST_TEST_THREADS=1 \
	PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabi/pkgconfig
