FROM heroku/heroku:18

# useful build tools ... we need gtk-doc to build orc, since they don't ship
# pre-baked tarballs
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	autoconf \
	automake \
	libtool \
	intltool \
	gtk-doc-tools \
	unzip \
	wget \
	git \
	pkg-config && rm -rf /var/lib/apt/lists/*;

# heroku:18 includes some libraries, like tiff and jpeg, as part of the
# run-time platform, and we want to use those libs if we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
RUN apt-get install --no-install-recommends -y \
	glib-2.0-dev \
	libexpat-dev \
	librsvg2-dev \
	libpng-dev \
	libjpeg-dev \
	libtiff5-dev \
	libexif-dev \
	liblcms2-dev \
	libxml2-dev \
	libfftw3-dev && rm -rf /var/lib/apt/lists/*;

ARG GIFLIB_VERSION=5.1.4
ARG GIFLIB_URL=http://downloads.sourceforge.net/project/giflib

RUN cd /usr/local/src \
	&& wget ${GIFLIB_URL}/giflib-$GIFLIB_VERSION.tar.bz2 \
	&& tar xf giflib-${GIFLIB_VERSION}.tar.bz2 \
	&& cd giflib-${GIFLIB_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/vips \
	&& make \
	&& make install && rm giflib-${GIFLIB_VERSION}.tar.bz2

# orc uses ninja and meson to build
RUN apt-get install --no-install-recommends -y \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir ninja meson

ARG ORC_VERSION=0.4.31
ARG ORC_URL=https://github.com/GStreamer/orc/archive

RUN cd /usr/local/src \
	&& wget ${ORC_URL}/$ORC_VERSION.tar.gz \
	&& tar xf ${ORC_VERSION}.tar.gz \
	&& cd orc-${ORC_VERSION} \
	&& meson build --prefix=/usr/local/vips --libdir=/usr/local/vips/lib \
	&& cd build \
	&& ninja \
	&& ninja install && rm ${ORC_VERSION}.tar.gz

ARG GSF_VERSION=1.14.46
ARG GSF_URL=http://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN cd /usr/local/src \
	&& wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
	&& tar xf libgsf-${GSF_VERSION}.tar.xz \
	&& cd libgsf-${GSF_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/vips --disable-gtk-doc \
	&& make \
	&& make install && rm libgsf-${GSF_VERSION}.tar.xz

ARG VIPS_VERSION=8.9.0
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN cd /usr/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& export PKG_CONFIG_PATH=/usr/local/vips/lib/pkgconfig \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local/vips --disable-gtk-doc \
	&& make \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

# clean the build area and make a tarball ready for packaging
RUN cd /usr/local/vips \
	&& rm bin/gif* bin/orc* bin/gsf* bin/batch_* bin/vips-8.9 \
	&& rm bin/vipsprofile bin/light_correct bin/shrink_width \
	&& strip lib/*.a lib/lib*.so* \
	&& rm -rf share/gtk-doc \
	&& rm -rf share/man \
	&& rm -rf share/thumbnailers \
	&& cd /usr/local \
	&& tar cfz libvips-dev-{VIPS_VERSION}.tar.gz vips

# ruby-vips needs ffi, and ffi needs the dev headers for ruby
RUN apt-get install --no-install-recommends -y \
    ruby-dev && rm -rf /var/lib/apt/lists/*;

# test ruby-vips
RUN export LD_LIBRARY_PATH=/usr/local/vips/lib \
	&& gem install ruby-vips \
	&& ruby -e 'require "ruby-vips"; puts "success!"'

