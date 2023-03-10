ARG  PHP_VERSION=7.3
FROM php:${PHP_VERSION}-cli

# get apt-get lists for the first time
RUN apt-get update

## install zip extension using debian buster repo (which is now available)
## we need zip-1.14 or higher and libzip 1.2 or higher for ZIP encryption support
RUN apt-get update && apt-get install --no-install-recommends -t buster -y zlib1g-dev libzip-dev \
    && pecl install zip && rm -rf /var/lib/apt/lists/*;

# for PHP <= 7.3 we need to perform this step before installing
RUN if [ "$PHP_VERSION" <= "7.3" ] ; then docker-php-ext-configure zip --with-libzip ; fi
RUN docker-php-ext-install zip

RUN apt-get install --no-install-recommends -y libgmp-dev && rm -rf /var/lib/apt/lists/*;

# install some php extensions
RUN docker-php-ext-install gmp bcmath

RUN apt-get install --no-install-recommends -y git wget && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive --depth=1 https://github.com/kjdev/php-ext-snappy.git \
  && cd php-ext-snappy \
  && phpize \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && make \
  && make install \
  && docker-php-ext-enable snappy

# install composer
RUN curl -f -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/bin/ --filename=composer

# include the files in the docker image
COPY . /usr/src/app
WORKDIR /usr/src/app

# run composer installation
RUN composer self-update && composer update --ignore-platform-reqs

ENTRYPOINT [ "vendor/bin/phpunit" ]
CMD [ "tests" ]
