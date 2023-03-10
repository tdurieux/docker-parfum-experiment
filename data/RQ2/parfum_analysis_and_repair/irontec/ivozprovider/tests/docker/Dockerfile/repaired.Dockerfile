FROM debian:stretch

MAINTAINER Mikel Madariaga <mikel@irontec.com>

RUN echo deb http://packages.irontec.com/debian bleeding main extra >> /etc/apt/sources.list
RUN echo deb http://repo.percona.com/apt stretch main >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes --force-yes \
        gettext \
        composer \
        make \
        git \
        unzip \
        curl \
        wget \
        sqlite3 \
        sphinx-intl \
        nodejs \
        php7.0 \
        php7.0-cli \
        php7.0-mysql \
        php7.0-xml \
        php7.0-gd \
        php7.0-mbstring \
        php7.0-sqlite3 \
        php7.0-igbinary \
        php7.0-curl \
        php7.0-fpm \
        php-yaml \
        php-gearman \
        php-redis \
        php-mailparse \
        php-imagick \
        php-xdebug \
        php-zip \
        percona-toolkit && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# Create jenkins user (configurable)
ARG UNAME=jenkins
ARG UID=108
ARG GID=117
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME
RUN chown jenkins.jenkins /opt/

# Install node tools for testing
RUN npm install -g swagger-cli && npm cache clean --force;

# Base project
USER $UNAME
RUN mkdir -p /opt/irontec
RUN git clone -b bleeding --depth 1 https://github.com/irontec/ivozprovider /opt/irontec/ivozprovider

# Install phpunit 6.5.14
RUN mkdir -p /opt/phpunit/
RUN wget https://github.com/sebastianbergmann/phpunit/archive/6.5.14.zip -O /opt/phpunit/phpunit.zip
RUN unzip /opt/phpunit/phpunit.zip -d /opt/phpunit/

# Get dependencies
RUN /opt/irontec/ivozprovider/library/bin/composer-install --prefer-dist --no-progress

# Store the main project vendor
RUN cp -r /opt/irontec/ivozprovider/library/vendor/    /opt/library-vendor

# We dont require project files anymore
RUN rm -fr /opt/irontec/ivozprovider/

WORKDIR /opt/irontec/ivozprovider/
