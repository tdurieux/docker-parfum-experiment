FROM heroku/heroku:18

# generic build tools  ... libgsf needs intltool
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		build-essential \
		wget \
		python3-pip \
		ninja-build \
		intltool \
		pkg-config && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir meson

# use the heroku platform libraries when we can
#
# see https://devcenter.heroku.com/articles/stack-packages
#
# libgsf needs libxml2
#
# this should only pull in header files and should not create any extra run
# time dependencies
RUN apt-get install --no-install-recommends -y \
	glib-2.0-dev \
	libexpat1-dev \
	libpango1.0-dev \
	librsvg2-dev \
	libpng-dev \
	libwebp-dev \
	libjpeg-turbo8-dev \
	libtiff5-dev \
	libexif-dev \
	liblcms2-dev \
	libxml2-dev \
	libfftw3-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src

# build to this prefix
#  - heroku has /usr/local/lib on the default ld.so.conf search path, so
#    this is convenient
#  - heroku has a basic dir structure in /usr/local, but no files
ARG PREFIX=/usr/local
ENV PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

# the main libimagequant is now gpl3 and we can't use it ... this is a
# maintained fork of the old BSD-licensed version
ARG IMAGEQUANT_VERSION=main
ARG IMAGEQUANT_URL=https://github.com/lovell/libimagequant

RUN git clone $IMAGEQUANT_URL \
	&& cd libimagequant \
	&& git checkout $IMAGEQUANT_VERSION \
	&& meson build --prefix=${PREFIX} --libdir=lib \
	&& cd build \
	&& ninja \
	&& ninja install

# need to add heif

ARG ORC_VERSION=0.4.32
ARG ORC_URL=https://gstreamer.freedesktop.org/src/orc

RUN wget ${ORC_URL}/orc-$ORC_VERSION.tar.xz \
	&& tar xf orc-${ORC_VERSION}.tar.xz \
	&& cd orc-${ORC_VERSION} \
	&& meson build --prefix=${PREFIX} --libdir=lib \
	&& cd build \
	&& ninja \
	&& ninja install && rm orc-${ORC_VERSION}.tar.xz

ARG GSF_VERSION=1.14.48
ARG GSF_URL=http://ftp.gnome.org/pub/GNOME/sources/libgsf

RUN wget ${GSF_URL}/${GSF_VERSION%.*}/libgsf-$GSF_VERSION.tar.xz \
	&& tar xf libgsf-${GSF_VERSION}.tar.xz \
	&& cd libgsf-${GSF_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$PREFIX --disable-gtk-doc \
	&& make \
	&& make install && rm libgsf-${GSF_VERSION}.tar.xz

# use cgif for GIF write
ARG CGIF_VERSION=0.2.0
ARG CGIF_URL=https://github.com/dloebl/cgif/archive/refs/tags

RUN wget ${CGIF_URL}/V${CGIF_VERSION}.tar.gz \
	&& tar xf V${CGIF_VERSION}.tar.gz \
	&& cd cgif-${CGIF_VERSION} \
	&& meson build --prefix=${PREFIX} --libdir=lib \
	&& cd build \
	&& ninja \
	&& ninja install && rm V${CGIF_VERSION}.tar.gz

# use libspng for PNG load (libvips 8.13 will support PNG save as well, but
# for now it's only load)
ARG SPNG_VERSION=0.7.2
ARG SPNG_URL=https://github.com/randy408/libspng/archive/refs/tags

RUN wget ${SPNG_URL}/v${SPNG_VERSION}.tar.gz \
	&& tar xf v${SPNG_VERSION}.tar.gz \
	&& cd libspng-${SPNG_VERSION} \
	&& meson build --prefix=${PREFIX} --libdir=lib \
	&& cd build \
	&& ninja \
	&& ninja install && rm v${SPNG_VERSION}.tar.gz

# the version number is was correct in feb 2022 ... it just needs to be >4200
# for libvips
ARG PDFIUM_URL=https://github.com/bblanchon/pdfium-binaries/releases/latest/download
ARG PDFIUM_VERSION=4901

RUN wget $PDFIUM_URL/pdfium-linux-x64.tgz \
	&& mkdir pdfium \
	&& cd pdfium \
	&& tar xf ../pdfium-linux-x64.tgz \
	&& cp lib/* $PREFIX/lib \
	&& cp -r include/* $PREFIX/include && rm ../pdfium-linux-x64.tgz

# make a pdfium.pc file libvips can use
RUN mkdir -p $PREFIX/lib/pkgconfig \
	&& cd $PREFIX/lib/pkgconfig \
	&& echo "prefix=$PREFIX" >> pdfium.pc \
	&& echo "exec_prefix=\${prefix}" >> pdfium.pc \
	&& echo "libdir=\${exec_prefix}/lib" >> pdfium.pc \
	&& echo "includedir=\${prefix}/include" >> pdfium.pc \
	&& echo "Name: pdfium" >> pdfium.pc \
	&& echo "Description: pdfium" >> pdfium.pc \
	&& echo "Version: $PDFIUM_VERSION" >> pdfium.pc \
	&& echo "Requires: " >> pdfium.pc \
	&& echo "Libs: -L\${libdir} -lpdfium" >> pdfium.pc \
	&& echo "Cflags: -I\${includedir}" >> pdfium.pc

ARG VIPS_VERSION=8.12.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$PREFIX \
		--disable-deprecated \
		--without-radiance \
		--without-analyze \
	&& make V=0 \
	&& make install && rm vips-${VIPS_VERSION}.tar.gz

# clean and package
RUN cd $PREFIX \
	&& cp -r lib libvips-heroku20 \
	&& cd libvips-heroku20 \
	&& rm *.a \
	&& rm *.la \
	&& strip lib*.so* \
	&& rm -rf pkgconfig \
	&& rm -rf python* \
	&& tar cfz ../libvips-heroku18.tar.gz * \
	&& echo built libvips-heroku18.tar.gz \
 	&& ls -l $PREFIX/libvips-heroku18.tar.gz

# install and test ruby-vips to confirm we can pick up the libraries
# correctly
# we need ruby-dev to install ruby-ffi
ENV LD_LIBRAY_PATH=$PREFIX/lib
RUN apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install ruby-vips
RUN ruby -e 'require "vips"; puts "ruby-vips: libvips #{Vips::LIBRARY_VERSION}"'
