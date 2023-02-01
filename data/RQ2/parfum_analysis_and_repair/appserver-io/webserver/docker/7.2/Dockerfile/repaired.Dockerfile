################################################################################
# Dockerfile for appserver.io webserver
################################################################################

# base image
FROM php:7.2-zts

# author
MAINTAINER Tim Wagner <tw@appserver.io>

# update the sources list
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
       wget \
       git \
       curl \
       zlib1g-dev \
       zlibc \
    && docker-php-ext-install -j$(nproc) zip && rm -rf /var/lib/apt/lists/*;

################################################################################

# download and compile pthreads extension
RUN git clone https://github.com/krakjoe/pthreads.git \
    && cd pthreads \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

################################################################################

# clear apk cache to optimize image filesize
RUN rm -rf /var/cache/apk/*

################################################################################

# install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

################################################################################

# install the appserver.io webserver
RUN cd /opt && composer create-project --no-dev appserver-io/webserver

################################################################################

# define working directory
WORKDIR /opt/webserver

# expose ports
EXPOSE 9080 9443

# start the webserver
CMD ["php", "-dextension=pthreads.so", "bin/webserver"]