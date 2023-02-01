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

RUN dpkg --add-architecture armhf
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
			gcc-arm-linux-gnueabihf \
			libatomic1:armhf \
			libpciaccess-dev:armhf \
			libkmod-dev:armhf \
			libprocps-dev:armhf \
			libunwind-dev:armhf \
			libdw-dev:armhf \
			zlib1g-dev:armhf \
			liblzma-dev:armhf \
			libcairo-dev:armhf \
			libpixman-1-dev:armhf \
			libudev-dev:armhf \
			libgsl-dev:armhf \
			libasound2-dev:armhf \
			libjson-c-dev:armhf \
			libcurl4-openssl-dev:armhf \
			libxrandr-dev:armhf \
			libxv-dev:armhf \
			meson \
			libdrm-dev:armhf \
			qemu-user \
			qemu-user-static && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
