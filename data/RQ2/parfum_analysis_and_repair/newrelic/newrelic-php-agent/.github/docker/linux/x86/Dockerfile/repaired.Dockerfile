#
# Copyright 2020 New Relic Corporation. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
#

#
# Build args passed from GHA
#
ARG PHP_VER

FROM i386/php:${PHP_VER}

RUN docker-php-source extract

#
# Uncomment deb-src lines for all enabled repos. First part of single-quoted
# string (up the the !) is the pattern of the lines that will be ignored.
# Needed for apt-get build-dep call later in script
#
RUN sed -Ei '/.*partner/! s/^# (deb-src .*)/\1/g' /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

#
# PHP dependencies
#
RUN apt-get update \
 && apt-get -y --no-install-recommends install gcc git netcat wget unzip \
 libpcre3 libpcre3-dev golang psmisc automake libtool \
 insserv procps vim ${PHP_USER_SPECIFIED_PACKAGES} && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y default-libmysqlclient-dev libmcrypt-dev && rm -rf /var/lib/apt/lists/*;

#
# Other tools
#

RUN apt-get install --no-install-recommends -y curl gdb libcurl4-openssl-dev pkg-config postgresql libpq-dev libedit-dev libreadline-dev git && rm -rf /var/lib/apt/lists/*;

#
# Install basic packages.
#
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  autotools-dev \
  golang \
  valgrind \
  libc6 \
  libc6-dbg \
  libc6-dev \
  libgtest-dev \
  libtool \
  make \
  perl \
  strace \
  python-dev \
  python-setuptools \
  python3-argon2 \
  sqlite3 \
  libsqlite3-dev \
  libghc-argon2-dev \openssl \
  libxml2 \
  libxml2-dev \
  libonig-dev \
  libssl-dev \
  zip && apt-get clean && rm -rf /var/lib/apt/lists/*;

#
# C++ dependencies
#
RUN apt-get update && apt-get -y --no-install-recommends install libgflags-dev libgtest-dev libc++-dev clang && apt-get clean && rm -rf /var/lib/apt/lists/*;

#
# Install packages for 32-bit compilation
#
RUN apt-get update && apt-get -y --no-install-recommends install gcc gcc-multilib g++ g++-multilib && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update

#
# These args need to be repeated so we can propagate the VARS within this build context.
#

ARG PHP_VER
ARG ARCH
ARG BUILD_TYPE
ENV PHP_VER=${PHP_VER}
ENV ARCH=$ARCH
ENV BUILD_TYPE=$BUILD_TYPE

COPY /.github/docker/linux/${BUILD_TYPE}_build.sh /build.sh

ENTRYPOINT ["/build.sh"]
