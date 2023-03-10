FROM alpine:3.14

RUN apk update && apk upgrade

# basic packages libvips likes
RUN apk add --no-cache \
	build-base \
	autoconf \
	automake \
	libtool \
	bc \
	zlib-dev \
	expat-dev \
	jpeg-dev \
	tiff-dev \
	glib-dev \
	libjpeg-turbo-dev \
	libexif-dev \
	lcms2-dev \
	fftw-dev \
	giflib-dev \
	libpng-dev \
	libwebp-dev \
	orc-dev \
	libgsf-dev

# add these if you like for text rendering, PDF rendering, SVG rendering,
# but they will pull in loads of other stuff
RUN apk add --no-cache \
	gdk-pixbuf-dev \
	poppler-dev \
	librsvg-dev

# there are other optional deps you can add for openslide / openexr /
# imagmagick support / Matlab support etc etc

ARG VIPS_VERSION=8.12.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget -O- ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	| tar xzC /tmp
RUN cd /tmp/vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
		--disable-static \
		--disable-debug \
		--disable-deprecated \
	&& make -j 16 V=0 \
	&& make install

RUN apk add --no-cache \
	python3-dev \
	py3-pip

RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir pyvips

WORKDIR /data
