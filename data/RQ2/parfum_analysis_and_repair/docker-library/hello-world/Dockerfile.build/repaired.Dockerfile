# explicitly use Debian for maximum cross-architecture compatibility
FROM debian:bullseye-slim

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		gnupg dirmngr \
		wget \
		\
		gcc \
		libc6-dev \
		make \
		\
		libc6-dev-arm64-cross \
		libc6-dev-armel-cross \
		libc6-dev-armhf-cross \
		libc6-dev-i386-cross \
		libc6-dev-mips64el-cross \
		libc6-dev-ppc64el-cross \
		libc6-dev-riscv64-cross \
		libc6-dev-s390x-cross \
		\
		gcc-aarch64-linux-gnu \
		gcc-arm-linux-gnueabi \
		gcc-arm-linux-gnueabihf \
		gcc-i686-linux-gnu \
		gcc-mips64el-linux-gnuabi64 \
		gcc-powerpc64le-linux-gnu \
		gcc-riscv64-linux-gnu \
		gcc-s390x-linux-gnu \
		\
		arch-test \
		file \
	; \
	rm -rf /var/lib/apt/lists/*

# https://musl.libc.org/releases.html