FROM debian:10-slim AS builder

USER root

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    mariadb-client wget curl unzip inetutils-ping \
    ca-certificates lsb-release apt-transport-https gnupg

# Install 3rd party PHP packages
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list \
    && curl https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y php8.0 php8.0-common php8.0-cli php8.0-fpm \
    php8.0-mysql  php8.0-curl php8.0-xml php8.0-mbstring  \
    php8.0-intl php8.0-redis php8.0-zip php8.0-dev

FROM builder AS imagick_builder
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y gcc make \
    libpng-dev libjpeg-dev ghostscript libxml2-dev  \
    libtiff5-dev libwebp-dev libfreetype6-dev libfftw3-dev

COPY install_imagemagick.sh /tmp/install_imagemagick.sh
COPY install_imagick.sh /tmp/install_imagick.sh

RUN sh /tmp/install_imagemagick.sh
RUN sh /tmp/install_imagick.sh

FROM builder as actual_site
COPY --from=imagick_builder /etc/php/8.0/cli/conf.d/imagick.ini /etc/php/8.0/cli/conf.d/imagick.ini
COPY --from=imagick_builder /etc/php/8.0/fpm/conf.d/imagick.ini /etc/php/8.0/fpm/conf.d/imagick.ini
COPY --from=imagick_builder /usr/lib/php/20200930/imagick.so /usr/lib/php/20200930/imagick.so

COPY --from=imagick_builder /usr/local/lib/ImageMagick-6.9.12/config-Q16/configure.xml /usr/local/lib/ImageMagick-6.9.12/config-Q16/configure.xml

COPY --from=imagick_builder /usr/local/lib/libMagickCore-6.Q16.a /usr/local/lib/libMagickCore-6.Q16.a
COPY --from=imagick_builder /usr/local/lib/libMagickCore-6.Q16.la /usr/local/lib/libMagickCore-6.Q16.la
COPY --from=imagick_builder /usr/local/lib/libMagickCore-6.Q16.so /usr/local/lib/libMagickCore-6.Q16.so
COPY --from=imagick_builder /usr/local/lib/libMagickCore-6.Q16.so.7 /usr/local/lib/libMagickCore-6.Q16.so.7
COPY --from=imagick_builder /usr/local/lib/libMagickCore-6.Q16.so.7.0.0 /usr/local/lib/libMagickCore-6.Q16.so.7.0.0
COPY --from=imagick_builder /usr/local/lib/libMagickWand-6.Q16.a /usr/local/lib/libMagickWand-6.Q16.a
COPY --from=imagick_builder /usr/local/lib/libMagickWand-6.Q16.la /usr/local/lib/libMagickWand-6.Q16.la
COPY --from=imagick_builder /usr/local/lib/libMagickWand-6.Q16.so /usr/local/lib/libMagickWand-6.Q16.so
COPY --from=imagick_builder /usr/local/lib/libMagickWand-6.Q16.so.7 /usr/local/lib/libMagickWand-6.Q16.so.7
COPY --from=imagick_builder /usr/local/lib/libMagickWand-6.Q16.so.7.0.0 /usr/local/lib/libMagickWand-6.Q16.so.7.0.0

COPY --from=imagick_builder /usr/local/lib/pkgconfig/ImageMagick-6.Q16.pc /usr/local/lib/pkgconfig/ImageMagick-6.Q16.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/ImageMagick.pc /usr/local/lib/pkgconfig/ImageMagick.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/MagickCore-6.Q16.pc /usr/local/lib/pkgconfig/MagickCore-6.Q16.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/MagickCore.pc /usr/local/lib/pkgconfig/MagickCore.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/MagickWand-6.Q16.pc /usr/local/lib/pkgconfig/MagickWand-6.Q16.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/MagickWand.pc /usr/local/lib/pkgconfig/MagickWand.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/Wand-6.Q16.pc /usr/local/lib/pkgconfig/Wand-6.Q16.pc
COPY --from=imagick_builder /usr/local/lib/pkgconfig/Wand.pc /usr/local/lib/pkgconfig/Wand.pc

COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libfftw3.so.3 /usr/lib/x86_64-linux-gnu/libfftw3.so.3
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libfreetype.so.6 /usr/lib/x86_64-linux-gnu/libfreetype.so.6
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libjbig.so.0 /usr/lib/x86_64-linux-gnu/libjbig.so.0
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libjpeg.so.62 /usr/lib/x86_64-linux-gnu/libjpeg.so.62
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/lib/x86_64-linux-gnu/libpng16.so.16
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libtiff.so.5 /usr/lib/x86_64-linux-gnu/libtiff.so.5
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libwebpmux.so.3 /usr/lib/x86_64-linux-gnu/libwebpmux.so.3
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libwebpdemux.so.2 /usr/lib/x86_64-linux-gnu/libwebpdemux.so.2
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libwebp.so.6 /usr/lib/x86_64-linux-gnu/libwebp.so.6
COPY --from=imagick_builder /usr/lib/x86_64-linux-gnu/libzstd.so.1 /usr/lib/x86_64-linux-gnu/libzstd.so.1

COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/coder.xml /usr/local/etc/ImageMagick-6/coder.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/colors.xml /usr/local/etc/ImageMagick-6/colors.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/delegates.xml /usr/local/etc/ImageMagick-6/delegates.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/log.xml /usr/local/etc/ImageMagick-6/log.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/magic.xml /usr/local/etc/ImageMagick-6/magic.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/mime.xml /usr/local/etc/ImageMagick-6/mime.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/policy.xml /usr/local/etc/ImageMagick-6/policy.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/quantization-table.xml /usr/local/etc/ImageMagick-6/quantization-table.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/thresholds.xml /usr/local/etc/ImageMagick-6/thresholds.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type-apple.xml /usr/local/etc/ImageMagick-6/type-apple.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type-dejavu.xml /usr/local/etc/ImageMagick-6/type-dejavu.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type-ghostscript.xml /usr/local/etc/ImageMagick-6/type-ghostscript.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type-urw-base35.xml /usr/local/etc/ImageMagick-6/type-urw-base35.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type-windows.xml /usr/local/etc/ImageMagick-6/type-windows.xml
COPY --from=imagick_builder /usr/local/etc/ImageMagick-6/type.xml /usr/local/etc/ImageMagick-6/type.xml


# Check that Imagick is loaded and working. It's better for
# the container to fail to build, than for it to be built, but
# not working.
# COPY check_imagick_working.php /tmp/check_imagick_working.php
# RUN php /tmp/check_imagick_working.php

CMD echo "The PHP Imagick base image has been run."
