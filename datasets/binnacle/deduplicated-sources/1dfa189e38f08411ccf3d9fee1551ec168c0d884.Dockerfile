#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'php-fpm' base Image, visit its repository on Github
#    https://github.com/Laradock/php-fpm
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/php-fpm/tags/
#
# Note: Base Image name format {image-tag}-{php-version}
#

FROM laradock/php-fpm:1.4-70

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

#
#--------------------------------------------------------------------------
# Mandatory Software's Installation
#--------------------------------------------------------------------------
#
# Mandatory Software's such as ("mcrypt", "pdo_mysql", "libssl-dev", ....)
# are installed on the base image 'laradock/php-fpm' image. If you want
# to add more Software's or remove existing one, you need to edit the
# base image (https://github.com/Laradock/php-fpm).
#

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# Optional Software's will only be installed if you set them to `true`
# in the `docker-compose.yml` before the build.
# Example:
#   - INSTALL_ZIP_ARCHIVE=true
#

#####################################
# SOAP:
#####################################

ARG INSTALL_SOAP=false
RUN if [ ${INSTALL_SOAP} = true ]; then \
    # Install the soap extension
    apt-get update -yqq && \
    apt-get -y install libxml2-dev php-soap && \
    docker-php-ext-install soap \
;fi

#####################################
# PHP GMP
#####################################

ARG INSTALL_GMP=false
ENV INSTALL_GMP ${INSTALL_GMP}

RUN if [ ${INSTALL_GMP} = true ]; then \
    # Install GMP extension
    apt-get update -yqq && \
    apt-get -y install libgmp-dev && \
    docker-php-ext-configure gmp && \
    docker-php-ext-install gmp && \
    docker-php-ext-enable gmp \
;fi

#####################################
# xDebug:
#####################################

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    # Install the xdebug extension
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

# Copy xdebug configration for remote debugging
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

#####################################
# Blackfire:
#####################################

ARG INSTALL_BLACKFIRE=false
RUN if [ ${INSTALL_XDEBUG} = false -a ${INSTALL_BLACKFIRE} = true ]; then \
    version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
;fi

#####################################
# PHP REDIS EXTENSION FOR PHP 7
#####################################

ARG INSTALL_PHPREDIS=false
RUN if [ ${INSTALL_PHPREDIS} = true ]; then \
    # Install Php Redis Extension
    pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis \
;fi

#####################################
# Swoole EXTENSION FOR PHP 7
#####################################

ARG INSTALL_SWOOLE=false
RUN if [ ${INSTALL_SWOOLE} = true ]; then \
    # Install Php Swoole Extension
    pecl install swoole \
    &&  docker-php-ext-enable swoole \
;fi

#####################################
# MongoDB:
#####################################

ARG INSTALL_MONGO=false

RUN if [ ${INSTALL_MONGO} = true ]; then \
    # Install the mongodb extension
    pecl install mongodb && \
    docker-php-ext-enable mongodb \
;fi

#####################################
# ZipArchive:
#####################################

ARG INSTALL_ZIP_ARCHIVE=false
RUN if [ ${INSTALL_ZIP_ARCHIVE} = true ]; then \
    # Install the zip extension
    docker-php-ext-install zip \
;fi

#####################################
# bcmath:
#####################################

ARG INSTALL_BCMATH=false
RUN if [ ${INSTALL_BCMATH} = true ]; then \
    # Install the bcmath extension
    docker-php-ext-install bcmath \
;fi

#####################################
# PHP Memcached:
#####################################

ARG INSTALL_MEMCACHED=false
RUN if [ ${INSTALL_MEMCACHED} = true ]; then \
    # Install the php memcached extension
    curl -L -o /tmp/memcached.tar.gz "https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz" \
    && mkdir -p memcached \
    && tar -C memcached -zxvf /tmp/memcached.tar.gz --strip 1 \
    && ( \
        cd memcached \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r memcached \
    && rm /tmp/memcached.tar.gz \
    && docker-php-ext-enable memcached \
;fi

#####################################
# Exif:
#####################################

ARG INSTALL_EXIF=false
RUN if [ ${INSTALL_EXIF} = true ]; then \
    # Enable Exif PHP extentions requirements
    docker-php-ext-install exif \
;fi

#####################################
# PHP Aerospike:
#####################################

ARG INSTALL_AEROSPIKE=false
ENV INSTALL_AEROSPIKE ${INSTALL_AEROSPIKE}
# Copy aerospike configration for remote debugging
COPY ./aerospike.ini /usr/local/etc/php/conf.d/aerospike.ini
RUN if [ ${INSTALL_AEROSPIKE} = true ]; then \
    # Install the php aerospike extension
    curl -L -o /tmp/aerospike-client-php.tar.gz "https://github.com/aerospike/aerospike-client-php/archive/3.4.14.tar.gz" \
    && mkdir -p aerospike-client-php \
    && tar -C aerospike-client-php -zxvf /tmp/aerospike-client-php.tar.gz --strip 1 \
    && ( \
        cd aerospike-client-php/src/aerospike \
        && phpize \
        && ./build.sh \
        && make install \
    ) \
    && rm /tmp/aerospike-client-php.tar.gz \
    && docker-php-ext-enable aerospike \
;fi

#####################################
# Opcache:
#####################################

ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi

# Copy opcache configration
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

#####################################
# Mysqli Modifications:
#####################################

ARG INSTALL_MYSQLI=false
RUN if [ ${INSTALL_MYSQLI} = true ]; then \
    docker-php-ext-install mysqli \
;fi

#####################################
# Tokenizer Modifications:
#####################################

ARG INSTALL_TOKENIZER=false
RUN if [ ${INSTALL_TOKENIZER} = true ]; then \
    docker-php-ext-install tokenizer \
;fi

#####################################
# Human Language and Character Encoding Support:
#####################################

ARG INSTALL_INTL=false
RUN if [ ${INSTALL_INTL} = true ]; then \
    # Install intl and requirements
    apt-get update -yqq && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl \
;fi

#####################################
# GHOSTSCRIPT:
#####################################

ARG INSTALL_GHOSTSCRIPT=false
RUN if [ ${INSTALL_GHOSTSCRIPT} = true ]; then \
    # Install the ghostscript extension
    # for PDF editing
    apt-get update -yqq \
    && apt-get install -y \
    poppler-utils \
    ghostscript \
;fi

#####################################
# LDAP:
#####################################

ARG INSTALL_LDAP=false
RUN if [ ${INSTALL_LDAP} = true ]; then \
    apt-get update -yqq && \
    apt-get install -y libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap \
;fi

#####################################
# ImageMagick
#####################################

ARG INSTALL_IMAGICK=false
RUN if [ ${INSTALL_IMAGICK} ]; then \
  # Add source src
  echo "deb-src http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list && \
  echo "deb-src http://deb.debian.org/debian jessie-updates main" >> /etc/apt/sources.list && \
  echo "deb-src http://security.debian.org jessie/updates main" >> /etc/apt/sources.list && \
  # Update and build required
  apt-get update && \
  apt-get build-dep imagemagick -y && \
  apt-get install libwebp-dev -y && \
  # Ready and go
  mkdir /tmp/imagemagick && \
  cd /tmp/imagemagick && \
  curl -L -o ImageMagick.tar.gz http://www.imagemagick.org/download/ImageMagick.tar.gz && \
  tar xf ImageMagick*.tar.gz && \
  cd ImageMagic* && \
  ./configure --prefix=/usr --without-x && \
  make && \
  make install && \
  # Install php ext
  pecl install imagick && \
  docker-php-ext-enable imagick \
;fi

#####################################
# SQL SERVER:
#####################################
ARG INSTALL_MSSQL=false
ENV INSTALL_MSSQL ${INSTALL_MSSQL}

RUN if [ ${INSTALL_MSSQL} = true ]; then \
    #####################################
    # Install Depenencies:
    #####################################
        apt-get update -yqq && \
        apt-get install -y --force-yes wget apt-transport-https curl freetds-common libsybdb5 freetds-bin unixodbc unixodbc-dev && \

    #####################################
    #  The following steps were taken from
    #  Microsoft's github account:
    #  https://github.com/Microsoft/msphpsql/wiki/Dockerfile-for-getting-pdo_sqlsrv-for-PHP-7.0-on-Debian-in-3-ways
    #####################################

    # Add PHP 7 repository
    # for Debian jessie
    # And System upgrade
        echo "deb http://packages.dotdeb.org jessie all" \
        | tee /etc/apt/sources.list.d/dotdeb.list \
        && wget -qO- https://www.dotdeb.org/dotdeb.gpg \
        | apt-key add - \
        && apt-get update -yqq \
        && apt-get upgrade -qq && \

    # Install UnixODBC
    # Compile odbc_config as it is not part of unixodbc package
        apt-get update -yqq && \
        apt-get install -y whiptail \
        unixodbc libgss3 odbcinst devscripts debhelper dh-exec dh-autoreconf libreadline-dev libltdl-dev \
        && dget -u -x http://http.debian.net/debian/pool/main/u/unixodbc/unixodbc_2.3.1-3.dsc \
        && cd unixodbc-*/ \
        && ./configure && make && make install \
        && cp -v ./exe/odbc_config /usr/local/bin/ && \

    # Fake uname for install.sh
        printf '#!/bin/bash\nif [ "$*" == "-p" ]; then echo "x86_64"; else /bin/uname "$@"; fi' \
        | tee /usr/local/bin/uname \
        && chmod +x /usr/local/bin/uname && \

    # Microsoft ODBC Driver 13 for Linux
    # Note: There's a copy of this tar on my hubiC
        wget -nv -O msodbcsql-13.0.0.0.tar.gz \
        "https://meetsstorenew.blob.core.windows.net/contianerhd/Ubuntu%2013.0%20Tar/msodbcsql-13.0.0.0.tar.gz?st=2016-10-18T17%3A29%3A00Z&se=2022-10-19T17%3A29%3A00Z&sp=rl&sv=2015-04-05&sr=b&sig=cDwPfrouVeIQf0vi%2BnKt%2BzX8Z8caIYvRCmicDL5oknY%3D" \
        && tar -xf msodbcsql-13.0.0.0.tar.gz \
        && cd msodbcsql-*/ \
        && ldd lib64/libmsodbcsql-13.0.so.0.0 \
        && ./install.sh install --accept-license \
        && ls -l /opt/microsoft/msodbcsql/ \
        && odbcinst -q -d -n "ODBC Driver 13 for SQL Server" && \


    #####################################
    # Install sqlsrv y pdo_sqlsrv
    # extensions:
    #####################################

    pecl install sqlsrv-4.0.8 && \
    pecl install pdo_sqlsrv-4.0.8 && \

    #####################################
    # Set locales for the container
    #####################################

    apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/20-sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" > /usr/local/etc/php/conf.d/20-pdo_sqlsrv.ini \
;fi

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

ADD ./laravel.ini /usr/local/etc/php/conf.d/
ADD ./laravel.pool.conf /usr/local/etc/php-fpm.d/

#RUN rm -r /var/lib/apt/lists/*

RUN usermod -u 1000 www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
