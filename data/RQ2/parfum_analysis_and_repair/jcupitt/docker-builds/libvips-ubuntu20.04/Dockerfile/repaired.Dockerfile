FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
	build-essential \
	unzip \
	wget && rm -rf /var/lib/apt/lists/*;

# stuff we need to build our own libvips ... this is a pretty random selection
# of dependencies, you'll want to adjust these
RUN apt-get install --no-install-recommends -y \
	glib-2.0-dev \
	libexpat-dev \
	librsvg2-dev \
	libpng-dev \
	libgif-dev \
	libjpeg-turbo8-dev \
	libtiff-dev \
	libexif-dev \
	liblcms2-dev \
	libheif-dev \
	liborc-dev && rm -rf /var/lib/apt/lists/*;

ARG VIPS_VERSION=8.9.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

WORKDIR /usr/local/src

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make V=0 \
	&& make install \
	&& ldconfig && rm vips-${VIPS_VERSION}.tar.gz

# pyvips .. handy for testing
RUN apt-get install --no-install-recommends -y \
	python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pyvips

