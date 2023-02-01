ARG V8VER
FROM stesie/libv8-${V8VER}:latest

ARG PHPVER

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV NO_INTERACTION=1
ENV REPORT_EXIT_STATUS=1

RUN apt-get update -q && apt-get install --no-install-recommends -y wget autoconf build-essential libreadline-dev pkg-config && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.php.net/distributions/php-${PHPVER}.tar.gz && \
    tar xzf php-${PHPVER}.tar.gz && rm php-${PHPVER}.tar.gz
ADD . /php-${PHPVER}/ext/v8js
WORKDIR /php-${PHPVER}

RUN ./buildconf --force
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-all --with-readline --enable-cli --enable-json --enable-maintainer-zts --with-v8js=/opt/libv8-$V8VER/ CFLAGS="-fsanitize=address -g -O0" CXXFLAGS="-fsanitize=address -g -O0" CPPFLAGS="$([ $( echo "$V8VER" | cut -c 1-1 ) -ge 8 ] && echo "-DV8_COMPRESS_POINTERS" || echo "")"
RUN sed -e "s/^EXTRA_LIBS.*/& -lv8_libplatform -ldl/" -i Makefile
RUN make -j5
