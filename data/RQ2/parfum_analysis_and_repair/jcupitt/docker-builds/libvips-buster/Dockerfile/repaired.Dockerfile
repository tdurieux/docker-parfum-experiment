FROM debian:buster

RUN apt-get -y update \
  && apt-get -y --no-install-recommends install \
    build-essential \
    pkg-config \
    wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install \
  glib2.0-dev \
  libexif-dev \
  libexpat1-dev \
  libfftw3-dev \
  libgif-dev \
  libgsf-1-dev \
  libimagequant-dev \
  liblcms2-dev \
  libmagickcore-dev \
  libopenjp2-7-dev \
  liborc-0.4-dev \
  libpng-dev \
  librsvg2-dev \
  libtiff5-dev && rm -rf /var/lib/apt/lists/*;

ENV VIPS_VERSION=8.12.1
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

WORKDIR /usr/local/src

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib

# compile libvips
RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
  && tar xf vips-${VIPS_VERSION}.tar.gz \
  && cd vips-${VIPS_VERSION} \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make -j V=0 \
  && make install && rm vips-${VIPS_VERSION}.tar.gz

WORKDIR /data
