FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends -y \
			gcc \
			flex \
			bison \
			pkg-config \
			libatomic1 \
			libpciaccess-dev \
			libkmod-dev \
			libprocps-dev \
			libdw-dev \
			zlib1g-dev \
			liblzma-dev \
			libcairo-dev \
			libpixman-1-dev \
			libudev-dev \
			libxrandr-dev \
			libxv-dev \
			x11proto-dri2-dev \
			meson \
			libdrm-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
