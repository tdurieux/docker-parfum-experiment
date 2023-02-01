FROM node:12.8-buster

ENV NODE_ENV=production

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install build-essential libtiff5-dev libpng-dev \
  libfftw3-dev librsvg2-dev libgif-dev libexif-dev \
  libexpat1-dev pkg-config glib2.0-dev libimagequant-dev libgsf-1-dev \
  liborc-0.4-dev liblcms2-dev autoconf nasm libtool automake && rm -rf /var/lib/apt/lists/*;

ENV VIPS_VERSION=8.10.5
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

ENV MOZJPEG_VERSION=3.3.1
ARG MOZJPEG_URL=https://github.com/mozilla/mozjpeg/archive

WORKDIR /tmp
ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib

# get vips and mozjpeg
ADD ${MOZJPEG_URL}/v${MOZJPEG_VERSION}.tar.gz \
  ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  /tmp/

# compile mozjpeg
RUN tar xf v${MOZJPEG_VERSION}.tar.gz \
  && cd mozjpeg-${MOZJPEG_VERSION} \
  && aclocal \
  && autoconf \
  && autoheader \
  && libtoolize \
  && automake --add-missing \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make -j4 V=0 \
  && make install libdir=/usr/lib/x86_64-linux-gnu prefix=/usr \
  && cp jpegint.h /usr/include/jpegint.h \
  && cd .. \
  && rm -rf mozjpeg && rm v${MOZJPEG_VERSION}.tar.gz

# compile libvips
RUN tar xf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --without-magick --without-pangoft2 --without-ppm \
       --without-analyze --without-radiance --without-OpenEXR \
       --with-jpeg-includes=/opt/mozjpeg/include \
       --with-jpeg-libraries=/opt/mozjpeg/lib64 \
  && make -j4 V=0 \
  && make install \
  && rm -rf /tmp/* && rm vips-${VIPS_VERSION}.tar.gz

WORKDIR /data
