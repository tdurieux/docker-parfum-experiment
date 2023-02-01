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
	g++-aarch64-linux-gnu \
	libc6-dev-arm64-cross && rm -rf /var/lib/apt/lists/*;

RUN dpkg --add-architecture arm64 && \
	apt-get update && \
	apt-get install --no-install-recommends -y libdbus-1-dev:arm64 && rm -rf /var/lib/apt/lists/*;

ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc \
	CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc \
	CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++ \
	QEMU_LD_PREFIX=/usr/aarch64-linux-gnu \
	RUST_TEST_THREADS=1 \
	PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig
