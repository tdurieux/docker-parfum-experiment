# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

####### PHP custom runtime #######

####### Install and compile everything #######

# Same AL version as Lambda execution environment AMI
FROM amazonlinux:2018.03.0.20190514 as builder

# Set desired PHP Version
ARG php_version="7.3.6"

# Lock to 2018.03 release (same as Lambda) and install compilation dependencies
RUN sed -i 's;^releasever.*;releasever=2018.03;;' /etc/yum.conf && \
    yum clean all && \
    yum install -y autoconf \
                bison \
                bzip2-devel \
                gcc \
                gcc-c++ \
                git \
                gzip \
                libcurl-devel \
                libxml2-devel \
                make \
                openssl-devel \
                tar \
                unzip \
                zip && rm -rf /var/cache/yum

# Download the PHP source, compile, and install both PHP and Composer
RUN curl -f -sL https://github.com/php/php-src/archive/php-${php_version}.tar.gz | tar -xvz && \
    cd php-src-php-${php_version} && \
    ./buildconf --force && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/php-7-bin/ --with-openssl --with-curl --with-zlib --without-pear --enable-bcmath --with-bz2 --enable-mbstring --with-mysqli && \
    make -j 5 && \
    make install && \
    /opt/php-7-bin/bin/php -v && \
    curl -f -sS https://getcomposer.org/installer | /opt/php-7-bin/bin/php -- --install-dir=/opt/php-7-bin/bin/ --filename=composer

# Prepare runtime files
RUN mkdir -p /lambda-php-runtime/bin && \
    cp /opt/php-7-bin/bin/php /lambda-php-runtime/bin/php

COPY runtime/bootstrap /lambda-php-runtime/
RUN chmod 0555 /lambda-php-runtime/bootstrap

# Install Guzzle, prepare vendor files
RUN mkdir /lambda-php-vendor && \
    cd /lambda-php-vendor && \
    /opt/php-7-bin/bin/php /opt/php-7-bin/bin/composer require guzzlehttp/guzzle

###### Create runtime image ######

FROM lambci/lambda:provided as runtime

# Layer 1
COPY --from=builder /lambda-php-runtime /opt/

# Layer 2
COPY --from=builder /lambda-php-vendor/vendor /opt/vendor

###### Create function image ######

FROM runtime as function

COPY function/src /var/task/src/
