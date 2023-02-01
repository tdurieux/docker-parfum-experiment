FROM amazonlinux:2

# general build stuff
RUN yum update -y \
	&& yum groupinstall -y "Development Tools" \
	&& yum install -y wget tar && rm -rf /var/cache/yum

# libvips needs libwebp 0.5 or later and the one on amazonlinux2 is 0.3.0, so
# we have to build it ourselves

# packages needed by libwebp
RUN yum install -y \
	libjpeg-devel \
	libpng-devel \
	libtiff-devel \
	libgif-devel && rm -rf /var/cache/yum

# stuff we need to build our own libvips ... this is a pretty basic selection
# of dependencies, you'll want to adjust these
# dzsave needs libgsf
RUN yum install -y \
	libpng-devel \
	poppler-glib-devel \
	glib2-devel \
	libjpeg-devel \
	expat-devel \
	zlib-devel \
	orc-devel \
	lcms2-devel \
	libexif-devel \
	libgsf-devel && rm -rf /var/cache/yum

# openslide is in epel -- extra packages for enterprise linux
RUN yum install -y \
	https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y \
	openslide-devel && rm -rf /var/cache/yum

# non-standard stuff we build from source goes here
ENV VIPSHOME /usr/local/vips
ENV PKG_CONFIG_PATH $VIPSHOME/lib/pkgconfig

ARG WEBP_VERSION=1.1.0
ARG WEBP_URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp

RUN cd /usr/local/src \
	&& wget ${WEBP_URL}/libwebp-${WEBP_VERSION}.tar.gz \
	&& tar xzf libwebp-${WEBP_VERSION}.tar.gz \
	&& cd libwebp-${WEBP_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libwebpmux --enable-libwebpdemux \
		--prefix=$VIPSHOME \
	&& make V=0 \
	&& make install && rm libwebp-${WEBP_VERSION}.tar.gz

ARG VIPS_VERSION=8.10.5
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN cd /usr/local/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$VIPSHOME \
	&& make V=0 \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

RUN ls $VIPSHOME/lib
