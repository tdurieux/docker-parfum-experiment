FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        unzip \
        wget \
        pkg-config && rm -rf /var/lib/apt/lists/*;

# web server stuff
RUN apt-get install --no-install-recommends -y \
    nginx && rm -rf /var/lib/apt/lists/*;

# php layers
RUN apt-get install --no-install-recommends -y \
    php7.0-dev \
    php-pear \
    composer && rm -rf /var/lib/apt/lists/*;

# stuff we need to build our own libvips
# glib and expat are the only required ones, the others are optional and
# enable features like jpeg load etc.
# there are other optional dependencies for things like PDF load, see the
# libvips README
RUN apt-get install --no-install-recommends -y \
    glib-2.0-dev \
    libexpat-dev \
    librsvg2-dev \
    libpng-dev \
    libpoppler-glib-dev \
    libgif-dev \
    libjpeg-dev \
    libexif-dev \
    liblcms2-dev \
    libwebp-dev \
    liborc-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# 16.04 libwebp is too old
ARG WEBP_VERSION=1.2.1
ARG WEBP_URL=https://storage.googleapis.com/downloads.webmproject.org/releases/webp

RUN wget ${WEBP_URL}/libwebp-${WEBP_VERSION}.tar.gz \
    && tar xzf libwebp-${WEBP_VERSION}.tar.gz \
    && cd libwebp-${WEBP_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libwebpmux --enable-libwebpdemux \
    && make V=0 \
    && make install \
    && ldconfig && rm libwebp-${WEBP_VERSION}.tar.gz

ARG VIPS_VERSION=8.12.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
    && tar xf vips-${VIPS_VERSION}.tar.gz \
    && cd vips-${VIPS_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make V=0 \
    && make install \
    && ldconfig && rm vips-${VIPS_VERSION}.tar.gz

# install the php extension that links it to libvips
RUN pecl install vips

# enable the vips.so extension at the cli so composer can find it
RUN echo "extension=vips.so" > /etc/php/7.0/mods-available/vips.ini \
    && ln -s /etc/php/7.0/mods-available/vips.ini \
                /etc/php/7.0/cli/conf.d/20-vips.ini

WORKDIR /data

