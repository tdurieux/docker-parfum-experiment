FROM ubuntu:18.04

MAINTAINER Muhammad Surya Ihsanuddin<surya.kejawen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ADD docker/apt/sources.list /etc/apt/sources.list

# Install Software
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends nginx supervisor vim software-properties-common curl ca-certificates unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends php php-cli php-curl php-intl php-mbstring php-xml php-zip \
    php-bcmath php-cli php-fpm php-imap php-json php-opcache php-xmlrpc \
    php-bz2 php-common php-gd php-ldap php-pgsql php-mysql php-readline php-soap php-tidy php-xsl php-redis -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod a+x /usr/local/bin/composer && composer self-update

RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer

# Nginx Configuration
ADD docker/nginx/sites-enabled/site.conf /etc/nginx/conf.d/default.conf
ADD docker/nginx/sites-enabled/php-fpm.conf /etc/nginx/conf.d/php-fpm.conf
ADD docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD docker/nginx/fastcgi_cache /etc/nginx/fastcgi_cache
ADD docker/nginx/logs/site.access.log /var/log/nginx/site.access.log
ADD docker/nginx/logs/site.error.log /var/log/nginx/site.error.log
ADD docker/nginx/etc/sysctl.conf /etc/sysctl.conf
ADD docker/nginx/etc/security/limits.conf /etc/security/limits.conf

RUN mkdir -p /tmp/nginx/cache
RUN chmod 777 -R /tmp/nginx

RUN chmod 777 /var/log/nginx/site.access.log
RUN chmod 777 /var/log/nginx/site.error.log

# PHP Configuration
ADD docker/php/php.ini /etc/php/7.2/fpm/php.ini
ADD docker/php/php.ini /etc/php/7.2/cli/php.ini
ADD docker/php/php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
RUN mkdir /run/php
RUN touch /run/php/php7.2-fpm.sock
RUN chmod 777 /run/php/php7.2-fpm.sock

# Supervisor Configuration
ADD docker/supervisor/supervisor.conf /etc/supervisord.conf

# Here we go
ADD docker/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /semart

EXPOSE 443 80

CMD ["/start.sh"]
