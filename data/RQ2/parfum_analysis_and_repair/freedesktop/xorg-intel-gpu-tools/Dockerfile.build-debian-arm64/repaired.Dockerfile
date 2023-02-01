FROM debian:buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y \
			flex \
			bison \
			pkg-config \
			x11proto-dri2-dev \
			python-docutils \
			valgrind \
			peg && rm -rf /var/lib/apt/lists/*;

RUN dpkg --add-architecture arm64
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
			gcc-aarch64-linux-gnu \
			libatomic1:arm64 \
			libpciaccess-dev:arm64 \
			libkmod-dev:arm64 \
			libprocps-dev:arm64 \
			libunwind-dev:arm64 \
			libdw-dev:arm64 \
			zlib1g-dev:arm64 \
			liblzma-dev:arm64 \
			libcairo-dev:arm64 \
			libpixman-1-dev:arm64 \
			libudev-dev:arm64 \
			libgsl-dev:arm64 \
			libasound2-dev:arm64 \
			libjson-c-dev:arm64 \
			libcurl4-openssl-dev:arm64 \
			libxrandr-dev:arm64 \
			libxv-dev:arm64 \
			meson \
			libdrm-dev:arm64 \
			qemu-user \
			qemu-user-static && rm -rf /var/lib/apt/lists/*;


RUN apt-get clean
