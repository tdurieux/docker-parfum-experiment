# Built from https://github.com/qwandor/cross/blob/context/docker/Dockerfile.context
FROM ghcr.io/qwandor/cross-context:0.2.1 as context

FROM debian:buster

COPY --from=context common.sh lib.sh /
RUN /common.sh

COPY --from=context cmake.sh /
RUN /cmake.sh

COPY --from=context xargo.sh /
RUN /xargo.sh

RUN apt-get install -y --assume-yes --no-install-recommends \
	g++-arm-linux-gnueabihf \
	libc6-dev-armhf-cross && rm -rf /var/lib/apt/lists/*;

RUN dpkg --add-architecture armhf && \
	apt-get update && \
	apt-get install --no-install-recommends -y libdbus-1-dev:armhf && rm -rf /var/lib/apt/lists/*;

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc \
	CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc \
	CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++ \
	QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf \
	RUST_TEST_THREADS=1 \
	PKG_CONFIG_PATH=/usr/lib/arm-linux-gnueabihf/pkgconfig
