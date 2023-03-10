FROM index.docker.io/alpine:latest
RUN apk add --update \
  build-base \
  && rm -rf /var/cache/apk/*

RUN apk add --update \
  curl \
  && rm -rf /var/cache/apk/*

RUN apk add --update \
  autoconf \
  && rm -rf /var/cache/apk/*

# PHP-5.4.9
RUN curl -f -so php-5.4.9.tar.bz2 \
 https://museum.php.net/php5/php-5.4.9.tar.bz2
RUN tar xjf php-5.4.9.tar.bz2 && rm php-5.4.9.tar.bz2
RUN cd php-5.4.9 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-5.4.9 \
      --enable-debug \
      --disable-all \
      --disable-cgi \
      --disable-dom \
      --disable-libxml \
      --disable-simplexml \
      --disable-xml \
      --disable-xmlreader \
      --disable-xmlwriter \
      --without-pear && \
    make install
RUN cd .. && rm -rf php-5.4.9*
RUN strip /opt/php-5.4.9/bin/php

# PHP-5.5.38
RUN curl -f -so php-5.5.38.tar.bz2 \
    https://www.php.net/distributions/php-5.5.38.tar.bz2
RUN tar xjf php-5.5.38.tar.bz2 && rm php-5.5.38.tar.bz2
RUN cd php-5.5.38 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-5.5.38 \
      --enable-debug \
      --disable-all \
      --disable-cgi \
      --disable-dom \
      --disable-libxml \
      --disable-simplexml \
      --disable-xml \
      --disable-xmlreader \
      --disable-xmlwriter \
      --without-pear && \
    make install
RUN cd .. && rm -rf php-5.5.38*
RUN strip /opt/php-5.5.38/bin/php

# PHP-5.6.28
RUN curl -f -so php-5.6.28.tar.bz2 \
    https://www.php.net/distributions/php-5.6.28.tar.bz2
RUN tar xjf php-5.6.28.tar.bz2 && rm php-5.6.28.tar.bz2
RUN cd php-5.6.28 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-5.6.28 \
      --enable-debug \
      --disable-all \
      --disable-cgi \
      --disable-dom \
      --disable-libxml \
      --disable-simplexml \
      --disable-xml \
      --disable-xmlreader \
      --disable-xmlwriter \
      --without-pear && \
    make install
RUN cd .. && rm -rf php-5.6.28*
RUN strip /opt/php-5.6.28/bin/php

# PHP-7.0.13
RUN curl -f -so php-7.0.13.tar.bz2 \
    https://www.php.net/distributions/php-7.0.13.tar.bz2
RUN tar xjf php-7.0.13.tar.bz2 && rm php-7.0.13.tar.bz2
RUN cd php-7.0.13 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-7.0.13 \
      --enable-debug \
      --disable-all \
      --disable-cgi \
      --disable-dom \
      --disable-libxml \
      --disable-simplexml \
      --disable-xml \
      --disable-xmlreader \
      --disable-xmlwriter \
      --without-pear && \
    make install
RUN cd .. && rm -rf php-7.0.13*
RUN rm /opt/php-7.0.13/bin/phpdbg
RUN strip /opt/php-7.0.13/bin/php

# PHP-7.1.0
RUN curl -f -so php-7.1.0.tar.bz2 \
    https://www.php.net/distributions/php-7.1.0.tar.bz2
RUN tar xjf php-7.1.0.tar.bz2 && rm php-7.1.0.tar.bz2
RUN cd php-7.1.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-7.1.0 \
      --enable-debug \
      --disable-all \
      --disable-cgi \
      --disable-dom \
      --disable-libxml \
      --disable-simplexml \
      --disable-xml \
      --disable-xmlreader \
      --disable-xmlwriter \
      --without-pear && \
    make install
RUN cd .. && rm -rf php-7.1.0*
RUN rm /opt/php-7.1.0/bin/phpdbg
RUN strip /opt/php-7.1.0/bin/php


# GEOS-3.4.3
RUN curl -f -so geos-3.4.3.tar.bz2 \
    https://download.osgeo.org/geos/geos-3.4.3.tar.bz2
RUN tar xjf geos-3.4.3.tar.bz2 && rm geos-3.4.3.tar.bz2
RUN cd geos-3.4.3 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/geos-3.4.3 \
      --disable-swig \
      --disable-static \
    && make install-strip
RUN cd .. && rm -rf geos-3.4.3*

# GEOS-3.5.1
RUN curl -f -so geos-3.5.1.tar.bz2 \
    https://download.osgeo.org/geos/geos-3.5.1.tar.bz2
RUN tar xjf geos-3.5.1.tar.bz2 && rm geos-3.5.1.tar.bz2
RUN cd geos-3.5.1 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/geos-3.5.1 \
      --disable-swig \
      --disable-static \
    && make install-strip
RUN cd .. && rm -rf geos-3.5.1*

# GEOS-3.6.0
RUN curl -f -so geos-3.6.0.tar.bz2 \
    https://download.osgeo.org/geos/geos-3.6.0.tar.bz2
RUN tar xjf geos-3.6.0.tar.bz2 && rm geos-3.6.0.tar.bz2
RUN cd geos-3.6.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/geos-3.6.0 \
      --disable-swig \
      --disable-static \
    && make install-strip
RUN cd .. && rm -rf geos-3.6.0*
