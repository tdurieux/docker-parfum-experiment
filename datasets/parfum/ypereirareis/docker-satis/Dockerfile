ARG BUILD_FROM=debian:bullseye-slim
FROM $BUILD_FROM

MAINTAINER Yannick Pereira-Reis <yannick.pereira.reis@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        software-properties-common \
        cron \
        nano \
        wget \
        sudo \
        lsb-release \
        apt-transport-https \
        git \
        curl \
        supervisor \
        nginx \
        ssh \
        unzip \
        libmcrypt-dev \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
        && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" >> /etc/apt/sources.list.d/php.list \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
        php8.1 \
        php8.1-tidy \
        php8.1-cli \
        php8.1-common \
        php8.1-curl \
        php8.1-intl \
        php8.1-fpm \
        php8.1-zip \
        php8.1-apcu \
        php8.1-xml \
        php8.1-mbstring \
	&& apt-get clean \
    && rm -Rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /tmp/* /var/tmp/*

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini \
	&& sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf \
	&& sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.1/fpm/php-fpm.conf \
	&& sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini \
	&& sed -i "s/;decorate_workers_output/decorate_workers_output/" /etc/php/8.1/fpm/pool.d/www.conf \
	&& sed -i "s/;clear_env/clear_env/" /etc/php/8.1/fpm/pool.d/www.conf

ADD nginx/default   /etc/nginx/sites-available/default

# Install ssh key
ENV USER_HOME /var/www
RUN mkdir -p $USER_HOME/.ssh/ && touch $USER_HOME/.ssh/known_hosts

ADD scripts /app/scripts
# Install Composer, satis and satisfy
ENV COMPOSER_HOME /var/www/.composer
RUN chmod +x /app/scripts/composer_install.sh \
    && /app/scripts/composer_install.sh

#############################################################################################"
##
## Install from dist
##
ADD https://github.com/ludofleury/satisfy/archive/3.4.0.zip /
RUN unzip 3.4.0.zip \
    && mv /satisfy-3.4.0 /satisfy \
    && rm -rf 3.4.0.zip

##
##
## Install from composer/packagist
#RUN composer create-project playbloom/satisfy:dev-master

##
## Install from git clone
##
#RUN git clone https://github.com/ludofleury/satisfy.git
#############################################################################################"


RUN cd /satisfy \
    && composer install --no-dev -n --optimize-autoloader \
    && composer update composer/composer composer/satis \
    && chmod -R 777 /satisfy

ADD scripts/crontab /etc/cron.d/satis-cron
ADD config/ /satisfy/config_tmp

RUN chmod 0644 /etc/cron.d/satis-cron \
	&& touch /var/log/satis-cron.log \
	&& chmod +x /app/scripts/startup.sh

ADD supervisor/0-install.conf /etc/supervisor/conf.d/0-install.conf
ADD supervisor/1-cron.conf /etc/supervisor/conf.d/1-cron.conf
ADD supervisor/2-nginx.conf /etc/supervisor/conf.d/2-nginx.conf
ADD supervisor/3-php.conf /etc/supervisor/conf.d/3-php.conf

ENV APP_ENV prod
ENV APP_DEBUG 0
RUN mkdir -p /run/php && touch /run/php/php8.1-fpm.sock && touch /run/php/php8.1-fpm.pid

WORKDIR /app

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80
EXPOSE 443

