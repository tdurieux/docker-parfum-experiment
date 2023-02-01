FROM lambci/lambda:build-go1.x AS compile-image

# See here for more build examples: https://github.com/stechstudio/libvips-lambda/tree/master/build/dependencies
# https://github.com/jeylabs/aws-lambda-poppler-layer
# https://github.com/pjfoley/poppler-for-lambda

# SHELL ["/bin/bash", "-c"]

ENV BUILD_DIR="/tmp/build"
ENV INSTALL_DIR="/opt"

# Create all necessary build directories
#
RUN set -Eeuxo pipefail \
  && mkdir -p ${BUILD_DIR}/{etc,bin,doc,include,lib,lib64,libexec,sbin,share}

# Install Development Tools
#
WORKDIR /tmp

RUN set -Eeuxo pipefail \
  && yum -y update \
  && yum -y install \
  gcc72-c++ \
  # libuuid is required by Fontconfig
  libuuid-devel \
  nasm \
  ninja-build \
  && yum -y clean all && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir meson

# Set GCC to 7.2.1-2 (default is 4.8.5-28 on lambci/lambda:build-go1.x image)
RUN update-alternatives --set gcc /usr/bin/gcc72


# Install CMake (http://www.linuxfromscratch.org/blfs/view/svn/general/cmake.html)
#
# Pre-installed on Amazon Linux: 2.8.12.2
# Required by: Fontconfig (Poppler)
#
ENV CMAKE3_VERSION=3.18.0
ENV CMAKE3_BUILD_DIR=${BUILD_DIR}/cmake3

RUN set -Eeuxo pipefail \
  && mkdir -p ${CMAKE3_BUILD_DIR} \
  && curl -f -L https://github.com/Kitware/CMake/releases/download/v${CMAKE3_VERSION}/cmake-${CMAKE3_VERSION}.tar.gz \
  | tar xzC ${CMAKE3_BUILD_DIR} --strip-components=1 \
  && curl -f -L https://www.linuxfromscratch.org/patches/blfs/svn/cmake-${CMAKE3_VERSION}-regression_fix-1.patch -o ${CMAKE3_BUILD_DIR}/cmake-${CMAKE3_VERSION}-regression_fix-1.patch

WORKDIR ${CMAKE3_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && patch -Np1 -i cmake-${CMAKE3_VERSION}-regression_fix-1.patch \
  && sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake \
  && ./bootstrap \
  #  --prefix=/usr/local \
  --parallel=4 \
  && make V=0 \
  && make install


# Configure Default Compiler Variables
#
ENV PATH="${INSTALL_DIR}/bin:${PATH}" \
  LD_LIBRARY_PATH="${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib:${LD_LIBRARY_PATH}" \
  PKG_CONFIG_PATH="${INSTALL_DIR}/lib64/pkgconfig:${INSTALL_DIR}/lib/pkgconfig"


# Install GLib (http://www.linuxfromscratch.org/blfs/view/svn/general/cmake.html)
#
# Pre-installed on Amazon Linux: 2.36.3
# Required by: Poppler
# Note: Amazon Linux has GLib 2.36.3 but Poppler requires >=2.41.0
#
ENV GLIB_VERSION=2.64.4
ENV GLIB_MAJOR=2.64
ENV GLIB_BUILD_DIR=${BUILD_DIR}/glib

RUN set -Eeuxo pipefail \
  && mkdir -p ${GLIB_BUILD_DIR} \
  && curl -f -L https://ftp.gnome.org/pub/gnome/sources/glib/${GLIB_MAJOR}/glib-${GLIB_VERSION}.tar.xz \
  | tar xJC ${GLIB_BUILD_DIR} --strip-components=1

WORKDIR ${GLIB_BUILD_DIR}

RUN set -Eeuxo pipefail \
  && mkdir build \
  && cd build \
  && meson \
  --prefix=${INSTALL_DIR} \
  -Dselinux=disabled \
  && ninja \
  && ninja install


# Install Libpng (http://www.linuxfromscratch.org/blfs/view/svn/general/openjpeg2.html)
#
# Pre-installed on Amazon Linux: 1.2.49
# Required by: Cairo (Poppler)
# Recommended dependency of: Poppler, FreeType (Poppler)
# Optional dependency of: libvips
#
ENV LIBPNG_VERSION=1.6.37
ENV LIBPNG_BUILD_DIR=${BUILD_DIR}/libpng

RUN set -Eeuxo pipefail \
  && mkdir -p ${LIBPNG_BUILD_DIR} \
  && curl -f -L https://downloads.sourceforge.net/libpng/libpng-${LIBPNG_VERSION}.tar.xz \
  | tar xJC ${LIBPNG_BUILD_DIR} --strip-components=1

WORKDIR ${LIBPNG_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  --disable-static \
  && make V=0 \
  && make install


# Install LibTIFF (http://www.linuxfromscratch.org/blfs/view/svn/general/libtiff.html)
#
# Pre-installed on Amazon Linux: 4.0.3
# Optional dependency of: libvips, Poppler
#
# ENV LIBTIFF_VERSION=4.1.0
# ENV LIBTIFF_BUILD_DIR=${BUILD_DIR}/tiff

# RUN set -Eeuxo pipefail \
#   && mkdir -p ${LIBTIFF_BUILD_DIR} \
#   && curl -L http://download.osgeo.org/libtiff/tiff-${LIBTIFF_VERSION}.tar.gz \
#   | tar xzC ${LIBTIFF_BUILD_DIR} --strip-components=1

# WORKDIR ${LIBTIFF_BUILD_DIR}/

# RUN set -Eeuxo pipefail \
#   && mkdir -p libtiff-build \
#   && cd libtiff-build \
#   && cmake .. \
#   -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.1.0 \
#   -DCMAKE_INSTALL_PREFIX=/usr -G Ninja \
#   && ninja \
#   && ninja install


# Install Libjpeg-Turbo (http://www.linuxfromscratch.org/blfs/view/svn/general/libjpeg.html)
#
# Pre-installed on Amazon Linux: no
# Recommended dependency of: Poppler
# Optional dependency of: libvips
#
ENV LIBJPEG_TURBO_VERSION=2.0.5
ENV LIBJPEG_TURBO_BUILD_DIR=${BUILD_DIR}/libjpeg

RUN set -Eeuxo pipefail \
  && mkdir -p ${LIBJPEG_TURBO_BUILD_DIR}/build \
  && curl -f -L https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-${LIBJPEG_TURBO_VERSION}.tar.gz \
  | tar xzC ${LIBJPEG_TURBO_BUILD_DIR} --strip-components=1

WORKDIR ${LIBJPEG_TURBO_BUILD_DIR}/build/

RUN set -Eeuxo pipefail \
  && cmake .. \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DCMAKE_BUILD_TYPE=RELEASE \
  -DENABLE_STATIC=FALSE \
  -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib \
  && make V=0 \
  && make install


# Install libexif (http://www.linuxfromscratch.org/blfs/view/svn/general/libexif.html)
#
# Pre-installed on Amazon Linux: 0.6.21
# Optional dependency of: libvips
#
# ENV LIBEXIF_VERSION=0.6.22
# ENV LIBEXIF_VERSION_URL=0_6_22
# ENV LIBEXIF_BUILD_DIR=${BUILD_DIR}/libexif

# RUN set -Eeuxo pipefail \
#   && mkdir -p ${LIBEXIF_BUILD_DIR} \
#   && curl -L https://github.com/libexif/libexif/releases/download/libexif-${LIBEXIF_VERSION_URL}-release/libexif-${LIBEXIF_VERSION}.tar.xz \
#   | tar xJC ${LIBEXIF_BUILD_DIR} --strip-components=1

# WORKDIR ${LIBEXIF_BUILD_DIR}

# RUN set -Eeuxo pipefail \
#   && ./configure  \
#   --prefix=${INSTALL_DIR} \
#   --disable-docs \
#   --disable-static \
#   && make V=0 \
#   && make install


# Install OpenJPEG (http://www.linuxfromscratch.org/blfs/view/svn/general/openjpeg2.html)
#
# Pre-installed on Amazon Linux: no
# Recommended dependency of: Poppler
#
ENV OPENJPEG_VERSION=2.3.1
ENV OPENJPEG_BUILD_DIR=${BUILD_DIR}/openjpeg2

RUN set -Eeuxo pipefail \
  && mkdir -p ${OPENJPEG_BUILD_DIR}/build \
  && curl -f -L https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG_VERSION}/openjpeg-${OPENJPEG_VERSION}.tar.gz \
  | tar xzC ${OPENJPEG_BUILD_DIR} --strip-components=1

WORKDIR ${OPENJPEG_BUILD_DIR}/build/

RUN set -Eeuxo pipefail \
  && cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  -DBUILD_STATIC_LIBS=OFF \
  && make V=0 \
  && make install


# Build libxml2 (http://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html)
#
# Pre-installed on Amazon Linux: 2.9.1
# Optional dependency of: Fontconfig (Poppler)
#
# ENV XML2_VERSION=2.9.10
# ENV XML2_BUILD_DIR=${BUILD_DIR}/libxml2

#RUN set -Eeuxo pipefail; \
#  mkdir -p ${XML2_BUILD_DIR} \
#  && curl -L http://xmlsoft.org/sources/libxml2-${XML2_VERSION}.tar.gz \
#  | tar xzC ${XML2_BUILD_DIR} --strip-components=1

# WORKDIR ${XML2_BUILD_DIR}/

# RUN set -Eeuxo pipefail \
#   && ./configure \
#   --prefix=${INSTALL_DIR} \
#   --with-sysroot=${INSTALL_DIR} \
#   --disable-static \
#   --with-history \
#   --with-icu \
#   --without-python

# RUN set -Eeuxo pipefail \
#   && make install \
#   && cp xml2-config ${INSTALL_DIR}/bin/xml2-config


# Install FreeType (http://www.linuxfromscratch.org/blfs/view/svn/general/freetype2.html)
#
# Pre-installed on Amazon Linux: 2.3.11
# Required by: Fontconfig (Poppler)
#
ENV FREETYPE_VERSION=2.10.2
ENV FREETYPE_BUILD_DIR=${BUILD_DIR}/freetype

RUN set -Eeuxo pipefail \
  && mkdir -p ${FREETYPE_BUILD_DIR} \
  && curl -f -L https://download-mirror.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.xz \
  | tar xJC ${FREETYPE_BUILD_DIR} --strip-components=1

WORKDIR ${FREETYPE_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg

RUN set -Eeuxo pipefail \
  && sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  --with-sysroot=${INSTALL_DIR} \
  --enable-freetype-config \
  --disable-static \
  && make V=0 \
  && make install


# Install Harfbuzz (http://www.linuxfromscratch.org/blfs/view/svn/general/harfbuzz.html)
#
# Pre-installed on Amazon Linux: no
# Recommended dependency of: FreeType
#
ENV HARZBUFF_VERSION=2.7.0
ENV HARZBUFF_BUILD_DIR=${BUILD_DIR}/harfbuzz

RUN set -Eeuxo pipefail \
  && mkdir -p ${HARZBUFF_BUILD_DIR} \
  && curl -f -L https://github.com/harfbuzz/harfbuzz/archive/${HARZBUFF_VERSION}.tar.gz \
  | tar xzC ${HARZBUFF_BUILD_DIR} --strip-components=1

WORKDIR ${HARZBUFF_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && mkdir build \
  && cd build \
  && meson \
  --prefix=${INSTALL_DIR} \
  && ninja \
  && ninja install

# Now re-install FreeType

WORKDIR ${FREETYPE_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  --with-sysroot=${INSTALL_DIR} \
  --enable-freetype-config \
  --disable-static \
  && make V=0 \
  && make install


# Install Gperf (http://www.linuxfromscratch.org/blfs/view/7.4/general/gperf.html)
#
# Pre-installed on Amazon Linux: no
# Required by: Fontconfig
#
ENV GPERF_VERSION=3.1
ENV GPERF_BUILD_DIR=${BUILD_DIR}/gperf

RUN set -Eeuxo pipefail \
  && mkdir -p ${GPERF_BUILD_DIR} \
  && curl -f -L https://ftp.gnu.org/pub/gnu/gperf/gperf-${GPERF_VERSION}.tar.gz \
  | tar xzC ${GPERF_BUILD_DIR} --strip-components=1

WORKDIR  ${GPERF_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  && make V=0 \
  && make install


# Install Fontconfig (http://www.linuxfromscratch.org/blfs/view/svn/general/fontconfig.html)
#
# Pre-installed on Amazon Linux: 2.8.0
# Required by: Poppler
# Requires: freetype and either expat or libxml2 (http://bio.gsi.de/DOCS/SOFTWARE/fontconfig.html) - not sure if that's still the case
#
ENV FONTCONFIG_VERSION=2.13.1
ENV FONTCONFIG_BUILD_DIR=${BUILD_DIR}/fontconfig

RUN set -Eeuxo pipefail \
  && mkdir -p ${FONTCONFIG_BUILD_DIR} \
  && curl -f -L https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.bz2 \
  | tar xjC ${FONTCONFIG_BUILD_DIR} --strip-components=1

WORKDIR ${FONTCONFIG_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && rm -f src/fcobjshash.h

RUN set -Eeuxo pipefail \
  && LDFLAGS="-L${INSTALL_DIR}/lib64 -L${INSTALL_DIR}/lib" \
  FONTCONFIG_PATH=${INSTALL_DIR} \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \


  --sysconfdir=${INSTALL_DIR}/etc \
  --localstatedir=${INSTALL_DIR}/var \
  --prefix=${INSTALL_DIR} \
  --disable-docs \
  # --enable-libxml2 \
  && make V=0 \
  && make install


# Install Pixman (http://www.linuxfromscratch.org/blfs/view/svn/general/pixman.html)
#
# Pre-installed on Amazon Linux: 0.32.4
# Required by: Cairo (Poppler)
#
ENV PIXMAN_VERSION=0.40.0
ENV PIXMAN_BUILD_DIR=${BUILD_DIR}/pixman

RUN set -Eeuxo pipefail \
  && mkdir -p ${PIXMAN_BUILD_DIR} \
  && curl -f -L https://www.cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz \
  | tar xzC ${PIXMAN_BUILD_DIR} --strip-components=1

WORKDIR ${PIXMAN_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && mkdir build \
  && cd build \
  && meson --prefix=${INSTALL_DIR} \
  && ninja \
  && ninja install


# Install Cairo (http://www.linuxfromscratch.org/blfs/view/svn/x/cairo.html)
#
# Pre-installed on Amazon Linux: 1.12.14
# Recommend eddependency of: Poppler
#
ENV CAIRO_VERSION=1.17.2
ENV CAIRO_BUILD_DIR=${BUILD_DIR}/cairo

RUN set -Eeuxo pipefail \
  && mkdir -p ${CAIRO_BUILD_DIR} \
  && curl -f -L https://cairographics.org/snapshots/cairo-${CAIRO_VERSION}.tar.xz \
  | tar xJC ${CAIRO_BUILD_DIR} --strip-components=1

WORKDIR ${CAIRO_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && autoreconf -fiv \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  --disable-static \
  --enable-tee \
  && make \
  && make install


# Install Little CMS (http://www.linuxfromscratch.org/blfs/view/svn/general/lcms2.html)
#
# Pre-installed on Amazon Linux: 2.6
# Recommended dependency of: Poppler
# Optional dependency of: libvips
#
ENV LCMS2_VERSION=2.11
ENV LCMS2_BUILD_DIR=${BUILD_DIR}/lcms

RUN set -Eeuxo pipefail \
  && mkdir -p ${LCMS2_BUILD_DIR} \
  && curl -f -L https://downloads.sourceforge.net/lcms/lcms2-${LCMS2_VERSION}.tar.gz \
  | tar xzC ${LCMS2_BUILD_DIR} --strip-components=1

WORKDIR ${LCMS2_BUILD_DIR}/

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix=${INSTALL_DIR} \
  --disable-static \
  && make V=0 \
  && make install


# Install Poppler (http://www.linuxfromscratch.org/blfs/view/svn/general/poppler.html)
#
# Pre-installed on Amazon Linux: no
#
ENV POPPLER_VERSION=0.89.0
ENV POPPLER_BUILD_DIR=${BUILD_DIR}/poppler
# ENV POPPLER_TEST_DIR=${BUILD_DIR}/poppler-test

# RUN set -Eeuxo pipefail \
#   && mkdir -p ${POPPLER_TEST_DIR} \
#   && git clone git://git.freedesktop.org/git/poppler/test ${POPPLER_TEST_DIR}

RUN set -Eeuxo pipefail \
  && mkdir -p ${POPPLER_BUILD_DIR}/build \
  && curl -f -L https://poppler.freedesktop.org/poppler-${POPPLER_VERSION}.tar.xz \
  | tar xJC ${POPPLER_BUILD_DIR} --strip-components=1

WORKDIR ${POPPLER_BUILD_DIR}/build/

RUN set -Eeuxo pipefail \
  && CFLAGS="" \
  CPPFLAGS="-I${INSTALL_DIR}/include -I/usr/include" \
  LDFLAGS="-L${INSTALL_DIR}/lib64 -L${INSTALL_DIR}/lib" \
  cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
  # -DTESTDATADIR=${POPPLER_TEST_DIR} \
  -DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
  -DENABLE_CPP=OFF \
  -DENABLE_QT5=OFF \
  -DENABLE_GLIB=ON \
  -DENABLE_SPLASH=OFF \
  && make V=0 \
  && make install


# Install libimagequant
#
# Pre-installed on Amazon Linux: no
# Optional dependency of: libvips
#
# ENV LIBIMAGEQUANT_VERSION=2.12.6
# ENV LIBIMAGEQUANT_BUILD_DIR=${BUILD_DIR}/libimagequant

# RUN set -Eeuxo pipefail \
#   && mkdir -p ${LIBIMAGEQUANT_BUILD_DIR} \
#   && git clone https://github.com/ImageOptim/libimagequant.git ${LIBIMAGEQUANT_BUILD_DIR}

# WORKDIR ${LIBIMAGEQUANT_BUILD_DIR}

# RUN set -Eeuxo pipefail \
#   && ./configure \
#   --prefix=${INSTALL_DIR} && \
#   make V=0 libimagequant.so && \
#   make install


# Install orc (https://gitlab.freedesktop.org/gstreamer/orc/-/blob/master/.gitlab-ci.yml#L15)
#
# Pre-installed on Amazon Linux: no
# Optional dependency of: libvips
#
ENV ORC_VERSION=0.4.31
ENV ORC_BUILD_DIR=${BUILD_DIR}/orc

RUN set -Eeuxo pipefail \
  && mkdir -p ${ORC_BUILD_DIR} \
  && curl -f -L https://gstreamer.freedesktop.org/src/orc/orc-${ORC_VERSION}.tar.xz \
  | tar xJC ${ORC_BUILD_DIR} --strip-components=1

WORKDIR ${ORC_BUILD_DIR}

RUN set -Eeuxo pipefail \
  && mkdir build \
  && cd build \
  && meson --prefix=${INSTALL_DIR} --werror \
  && ninja \
  && ninja install


# Install libvips (https://libvips.github.io/libvips/install.html)
#
# Pre-installed on Amazon Linux: no
#
ENV LIBVIPS_VERSION=8.9.2
ENV LIBVIPS_BUILD_DIR=${BUILD_DIR}/libvips

RUN set -Eeuxo pipefail \
  && mkdir -p ${LIBVIPS_BUILD_DIR} \
  && curl -f -L https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz \
  | tar xzC ${LIBVIPS_BUILD_DIR} --strip-components=1

WORKDIR ${LIBVIPS_BUILD_DIR}

RUN set -Eeuxo pipefail \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${INSTALL_DIR} \
  --without-gsf \
  --without-fftw \
  --without-magick \
  --without-OpenEXR \
  --without-nifti \
  --without-heif \
  --without-pdfium \
  --without-rsvg \
  --without-openslide \
  --without-matio \
  --without-cfitsio \
  --without-libwebp \
  --without-pangoft2 \
  --without-tiff \
  --without-giflib \
  --without-imagequant \
  --without-libexif \
  --disable-gtk-doc \
  && make V=0 \
  && make install \
  && echo /opt/lib > /etc/ld.so.conf.d/libvips.conf \
  && ldconfig


FROM lambci/lambda:build-go1.x AS runtime-image

ENV SOURCE_DIR="/opt"
ENV INSTALL_DIR="/opt"

ENV PATH="/opt/bin:${PATH}" \
  LD_LIBRARY_PATH="${INSTALL_DIR}/lib64:${INSTALL_DIR}/lib"

# Install zip
#
RUN set -Eeuxo pipefail \
  && yum update -y \
  && yum -y install zip \
  && yum -y clean all && rm -rf /var/cache/yum

# Copy all binaries/libaries
#
RUN set -Eeuxo pipefail \
  && mkdir -p ${INSTALL_DIR}/{etc,bin,var,share,lib}

COPY --from=compile-image /lib64/libuuid.so.* ${INSTALL_DIR}/lib/
COPY --from=compile-image ${SOURCE_DIR}/share/ /tmp/share
COPY --from=compile-image ${SOURCE_DIR}/etc/ ${INSTALL_DIR}/etc/
COPY --from=compile-image ${SOURCE_DIR}/bin/ ${INSTALL_DIR}/bin/
COPY --from=compile-image ${SOURCE_DIR}/var/ ${INSTALL_DIR}/var/
COPY --from=compile-image ${SOURCE_DIR}/lib/ ${INSTALL_DIR}/lib/
# COPY --from=compile-image ${SOURCE_DIR}/lib64/ ${INSTALL_DIR}/lib/

RUN set -Eeuxo pipefail \
  && cp -R /tmp/share/fontconfig ${INSTALL_DIR}/share/fontconfig
