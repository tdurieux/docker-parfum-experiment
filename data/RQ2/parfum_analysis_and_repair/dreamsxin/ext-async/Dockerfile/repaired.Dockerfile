FROM php:7.3.4-zts

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libssl-dev libxml2-dev autoconf bison bash automake libtool && rm -rf /var/lib/apt/lists/*;

COPY . /usr/local/ext-async
WORKDIR /usr/local/ext-async

RUN phpize --clean
RUN phpize
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make install -B

RUN cat ./defaults.ini >> /usr/local/etc/php/conf.d/async.ini

RUN php -v
RUN php -m

CMD ["/bin/sh"]
