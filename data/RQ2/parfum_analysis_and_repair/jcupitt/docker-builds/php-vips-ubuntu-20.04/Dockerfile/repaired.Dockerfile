FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install --no-install-recommends -y \
        build-essential \
        unzip \
        wget \
        pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src

# stuff we need to build our own libvips
# glib and expat are the only required ones, the others are optional and
# enable features like jpeg load etc.
RUN apt-get install --no-install-recommends -y \
    glib-2.0-dev \
    libheif-dev \
    libexpat-dev \
    librsvg2-dev \
    libpng-dev \
    libpoppler-glib-dev \
    libgif-dev \
    libjpeg-dev \
    libexif-dev \
    liblcms2-dev \
    liborc-dev && rm -rf /var/lib/apt/lists/*;

ARG VIPS_URL=https://github.com/libvips/libvips/releases/download
ARG VIPS_VERSION=8.10.5

RUN wget $VIPS_URL/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz \
    && tar xf vips-$VIPS_VERSION.tar.gz \
    && cd vips-$VIPS_VERSION \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
    && make V=0 \
    && make install && rm vips-$VIPS_VERSION.tar.gz

# php layers
RUN apt-get install --no-install-recommends -y \
    php-dev \
    php-pear \
    composer && rm -rf /var/lib/apt/lists/*;

# install the php extension that links it to libvips
RUN pecl install vips

# enable the vips.so extension at the cli so composer can find it
RUN echo "extension=vips.so" > /etc/php/7.4/mods-available/vips.ini
RUN phpenmod vips

WORKDIR /data
