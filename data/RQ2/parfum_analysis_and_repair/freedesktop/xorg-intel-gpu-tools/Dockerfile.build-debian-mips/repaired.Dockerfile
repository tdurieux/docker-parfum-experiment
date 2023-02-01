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

RUN dpkg --add-architecture mips
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
			gcc-mips-linux-gnu \
			libatomic1:mips \
			libpciaccess-dev:mips \
			libkmod-dev:mips \
			libprocps-dev:mips \
			libunwind-dev:mips \
			libdw-dev:mips \
			zlib1g-dev:mips \
			liblzma-dev:mips \
			libcairo-dev:mips \
			libpixman-1-dev:mips \
			libudev-dev:mips \
			libgsl-dev:mips \
			libasound2-dev:mips \
			libjson-c-dev:mips \
			libcurl4-openssl-dev:mips \
			libxrandr-dev:mips \
			libxv-dev:mips \
			meson \
			libdrm-dev:mips \
			qemu-user \
			qemu-user-static && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
