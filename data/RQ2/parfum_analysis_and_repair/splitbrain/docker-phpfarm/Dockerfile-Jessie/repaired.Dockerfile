#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-jessie:latest

LABEL author="Andreas Gohr <andi@splitbrain.org>, Eugene Sia <eugene@eugenesia.co.uk>"

ENV \
  # Packages needed for running various build scripts.
  SCRIPT_PKGS=" \
    debian-keyring \
    wget \
  " \
  # Packages only needed for PHP build.
  BUILD_PKGS=" \
    autoconf \
    build-essential \
    # Flex needed for PHP 5.1 & 5.2 see http://php.net/manual/en/install.unix.php
    flex \
    lemon \
    bison \
    pkg-config \
    re2c \
  " \
  # PHP runtime dependencies.
  RUNTIME_PKGS=" \
    # Needed for PHP and Git to connect with SSL sites.
    ca-certificates \
    curl \
    # apt-get complains that this is an 'essential' package.
    debian-archive-keyring \
    imagemagick \
    libbz2-dev \
    libc-client2007e-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libkrb5-dev \
    libldap2-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmhash-dev \
    libmysqlclient-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssl-dev \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt1-dev \
    libzip-dev \
  " \
  # Packages needed to run Apache httpd.
  APACHE_PKGS="\
    apache2 \
    apache2-mpm-prefork \
    # Fcgid mod for Apache - not a build dependency library.
    libapache2-mod-fcgid \
  "

# Install packages we need for runtime usage.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    $RUNTIME_PKGS \
    $APACHE_PKGS && \
    \
    # Clean up apt package lists.
    rm -rf /var/lib/apt/lists/*


# Reconfigure Apache
RUN rm -rf /var/www/*
# Import our Apache configs.
COPY var-www /var/www/
COPY apache /etc/apache2/


# Import our own modifications for the PhpFarm script.
COPY phpfarm /phpfarm_mod

# The PHP versions to compile.
ENV PHP_FARM_VERSIONS="5.3.29 5.4.45 5.5.38 5.6.39 7.0.33 7.1.25 7.2.34 7.3.25 7.4.13 8.0.0" \
  \
  # Flags for C Compiler Loader: make php 5.3 work again.
  LDFLAGS="-lssl -lcrypto -lstdc++" \
  \
  # Add path to built PHP executables, for module building and for Apache.
  PATH="/phpfarm/inst/bin/:$PATH"


# Install packages needed for build.
RUN apt-get update && \
  apt-get install -y --no-install-recommends $SCRIPT_PKGS $BUILD_PKGS && \
  \
  # Download PhpFarm scripts into /phpfarm/.
  wget -O /phpfarm.tar.gz https://github.com/fpoirotte/phpfarm/archive/v0.3.0.tar.gz && \
  mkdir /phpfarm && \
  tar -xf /phpfarm.tar.gz -C /phpfarm --strip 1 && \
  #
  # Overwrite PhpFarm with our own modifications.
  rm -rf /phpfarm/src/bzips /phpfarm/src/custom && \
  mv /phpfarm_mod/* /phpfarm/src/ && \
  #
  # Wait for docker.sh to finish moving else trying to exec a file being
  # written will output "Text file busy" error.
  sleep 5s && \
  rmdir /phpfarm_mod && \
  #
  # Build all PHP versions.
  cd /phpfarm/src && \
  ./docker.sh && \
  #
  # Clean up.
  apt-get purge -y $SCRIPT_PKGS $BUILD_PKGS && \
  apt-get autoremove -y && \
  rm -rf /var/lib/apt/lists/* && rm /phpfarm.tar.gz


# expose the ports
EXPOSE 8053 8054 8055 8056 8070 8071 8072 8073 8074 8080

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]

