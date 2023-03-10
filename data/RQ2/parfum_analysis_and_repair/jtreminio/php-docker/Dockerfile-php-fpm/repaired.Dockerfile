ARG PHP_VER
ARG PHP_VER_DOT
FROM jtreminio/php-cli:$PHP_VER_DOT
LABEL maintainer="Juan Treminio <jtreminio@gmail.com>"

USER root

RUN apt-get update &&\
    apt-get install --no-install-recommends --no-install-suggests -y \
        php${PHP_VER}-fpm \
    &&\
    apt-get -y --purge autoremove &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/{man,doc}

RUN mkdir /docker_build

COPY ./files/php/bin_* /docker_build/
RUN chmod +x /docker_build/bin_* &&\
    /docker_build/bin_clean_directories.sh ${PHP_VER} &&\
    /docker_build/bin_rm_symlinked_ini.sh ${PHP_VER} fpm &&\
    rm -rf /docker_build

# Save INI and FPM conf files into non-versioned directory
# This makes managing them across several different PHP versions easier
COPY files/php/fpm.conf /etc/php/fpm.conf
RUN ln -s /etc/php/fpm.conf /etc/php/${PHP_VER}/fpm/php-fpm.conf

RUN rm -rf /etc/apache2

# Standardize PHP-FPM executable location
RUN rm -f /usr/sbin/php-fpm &&\
    ln -s /usr/sbin/php-fpm${PHP_VER} /usr/sbin/php-fpm

# Only set PHP_INI_SCAN_DIR inside following file so it does not affect PHP CLI
# runit config
RUN mkdir /etc/service/fpm
COPY files/php/php-fpm /etc/service/fpm/run
RUN chmod +x /etc/service/fpm/run

# PID directory
RUN install -d -m 0755 -o www-data -g www-data /var/run/php-fpm

EXPOSE 9000

CMD ["/sbin/my_init"]