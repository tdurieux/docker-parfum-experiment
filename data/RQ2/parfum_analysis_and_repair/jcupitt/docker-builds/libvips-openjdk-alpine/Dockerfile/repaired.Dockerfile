FROM openjdk:8-jre-alpine

RUN apk update \
	&& apk upgrade \
	&& apk add --no-cache build-base

# packages for libvips ... this is a very basic selection, you'll need others
# for things like pyramid support
RUN apk add --no-cache \
	expat-dev \
	zlib-dev \
	tiff-dev \
	glib-dev \
	gdk-pixbuf-dev \
	libjpeg-turbo-dev \
	libexif-dev \
	lcms2-dev \
	fftw-dev \
	giflib-dev \
	libpng-dev \
	libwebp-dev \
	orc-dev

WORKDIR /usr/local/src

ARG VIPS_VERSION=8.10.5
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make V=0 \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

WORKDIR /data
