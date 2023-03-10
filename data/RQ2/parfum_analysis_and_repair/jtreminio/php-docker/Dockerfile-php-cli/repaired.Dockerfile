FROM jtreminio/phpenv:latest
LABEL maintainer="Juan Treminio <jtreminio@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN update-alternatives --install /bin/sh sh /bin/bash 100

RUN mkdir /docker_build

COPY ./files/base_packages.sh /docker_build/base_packages.sh
RUN chmod +x /docker_build/base_packages.sh &&\
    /docker_build/base_packages.sh

ENV COMPOSER_HOME /.composer
ARG PHP_VER_DOT
ARG PHP_VER
ENV PHP_VER=$PHP_VER

COPY ./files/php/bin_* /docker_build/
RUN chmod +x /docker_build/bin_* &&\
    /docker_build/bin_install_modules.sh ${PHP_VER} &&\
    /docker_build/bin_clean_directories.sh ${PHP_VER}

RUN /docker_build/bin_install_composer.sh &&\
    /docker_build/bin_rm_symlinked_ini.sh ${PHP_VER} cli &&\
    /docker_build/bin_link_ini.sh ${PHP_VER} &&\
    rm -rf /docker_build

# Save INI file into non-versioned directory
# This makes managing them across several different PHP versions easier
COPY files/php/php.ini /etc/php/php.ini

# Default sessions directory
RUN install -d -m 0755 -o www-data -g www-data /var/lib/php/sessions

# Xdebug CLI debugging
COPY files/php/xdebug /usr/bin/xdebug
RUN chmod +x /usr/bin/xdebug

WORKDIR /etc/php/${PHP_VER}

USER www-data