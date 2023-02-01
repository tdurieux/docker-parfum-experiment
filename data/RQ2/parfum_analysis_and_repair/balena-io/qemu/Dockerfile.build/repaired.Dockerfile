# Use this dockerfile to build the qemu binary

FROM debian:jessie

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		autoconf \
		bison \
		build-essential \
		flex \
		libglib2.0-dev \
		libtool \
		make \
		pkg-config \
		python \
		libpixman-1-dev \
		zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/qemu

COPY . /usr/src/qemu


ARG TARGET_ARCH=arm-linux-user
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --target-list=$TARGET_ARCH --static --extra-cflags="-DCONFIG_RTNETLINK"

RUN make -j $(nproc)
