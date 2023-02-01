FROM lambci/lambda:build-ruby2.7

# general build stuff
RUN yum update -y \
	&& yum groupinstall -y "Development Tools" \
	&& yum install -y \
		wget \
		mercurial && rm -rf /var/cache/yum

WORKDIR /build

ENV WORKDIR="/build"
ENV INSTALLDIR="/opt"
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

ARG PTOOLS_URL=http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages
ARG NASM_VERSION=2.15.03-3
RUN curl -f $PTOOLS_URL/nasm-$NASM_VERSION.el8.x86_64.rpm --output nasm.rpm \
	&& yum install -y nasm.rpm && rm -rf /var/cache/yum

RUN hg clone http://hg.videolan.org/x265
RUN cd ./x265/build/linux \
	&& cmake -G "Unix Makefiles" ../../source \
	&& make -j6 \
	&& make install \
	&& ldconfig

ARG HEIF_URL=https://github.com/strukturag/libheif/releases/download
ARG HEIF_VERSION=1.9.1

RUN curl -f -L $HEIF_URL/v$HEIF_VERSION/libheif-$HEIF_VERSION.tar.gz | tar xz \
	&& cd libheif-$HEIF_VERSION \
	&& ./autogen.sh \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make V=0 \
	&& make install

ARG VIPS_VERSION=8.11.0
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

# selection of packages for libvips -- you might want to expand this
RUN yum install -y \
	expat-devel \
	glib2-devel \
	lcms2-devel \
	libexif-devel \
	libgsf-devel \
	libjpeg-turbo-devel \
	libpng-devel \
	libtiff-devel \
	orc-devel && rm -rf /var/cache/yum

RUN wget $VIPS_URL/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz \
	&& tar xzf vips-$VIPS_VERSION.tar.gz \
	&& cd vips-$VIPS_VERSION \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make V=0 \
	&& make install && rm vips-$VIPS_VERSION.tar.gz

# test ruby-vips
RUN gem install ruby-vips \
	&& ruby -e 'require "vips"; puts "success!"'

