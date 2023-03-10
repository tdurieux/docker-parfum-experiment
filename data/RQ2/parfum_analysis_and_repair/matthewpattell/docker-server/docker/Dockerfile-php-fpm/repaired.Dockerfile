FROM ubuntu:18.04
MAINTAINER Matthew Patell <lukomi@mail.ru>

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

ENV PHP_VERSION 7.4

RUN apt-get update -y --fix-missing \
    # Images utils \
    && apt-get install --no-install-recommends -y libjpeg-progs jpegoptim pngquant librsvg2-2 libfcgi0ldbl \
    # PHP repository
    && echo 'deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main' \
            > /etc/apt/sources.list.d/ondrej-ubuntu-php-bionic.list \
    && apt-get install --no-install-recommends -y gnupg \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-get update -y --fix-missing \
    # PHP
    && apt-get install --no-install-recommends -y --allow-unauthenticated \
            php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-cgi php${PHP_VERSION}-cli php${PHP_VERSION}-common \
            php${PHP_VERSION}-bcmath php${PHP_VERSION}-curl php${PHP_VERSION}-dba php${PHP_VERSION}-enchant \
            php${PHP_VERSION}-gd php${PHP_VERSION}-gmp php-imagick \
            php${PHP_VERSION}-imap php${PHP_VERSION}-interbase \
            php${PHP_VERSION}-intl php${PHP_VERSION}-json php${PHP_VERSION}-ldap \
            php${PHP_VERSION}-mbstring \
            php${PHP_VERSION}-mysql php${PHP_VERSION}-odbc php${PHP_VERSION}-pgsql php${PHP_VERSION}-sqlite3 \
            php${PHP_VERSION}-opcache php${PHP_VERSION}-pspell php${PHP_VERSION}-readline \
            php${PHP_VERSION}-snmp php${PHP_VERSION}-soap \
            php${PHP_VERSION}-sybase php${PHP_VERSION}-tidy \
            php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-xsl \
            php${PHP_VERSION}-zip php${PHP_VERSION}-bz2 \
            php${PHP_VERSION}-dev php${PHP_VERSION}-xdebug \
    # Pecl extensions
    # yaml
    && apt-get install --no-install-recommends -y libyaml-dev \
    && printf "\n" | pecl install yaml-2.0.4 \
    && echo "extension=yaml.so" >> /etc/php/${PHP_VERSION}/mods-available/yaml.ini \
    && phpenmod yaml \
    # Xdebug default disable
    && phpdismod xdebug \
    # Cleaup
    && apt-get remove -y php${PHP_VERSION}-dev gnupg \
    && apt-get -y autoremove && apt-get autoclean && rm -rf /var/lib/apt/lists/*;

# Copy start script
COPY php/php${PHP_VERSION}-fpm /etc/init.d/php${PHP_VERSION}-fpm
# Set correct permission
RUN chmod 0755 /etc/init.d/php${PHP_VERSION}-fpm

RUN update-rc.d php${PHP_VERSION}-fpm defaults

EXPOSE 9000

CMD service php${PHP_VERSION}-fpm start && tail -f /var/log/php${PHP_VERSION}-fpm/fpm.log
