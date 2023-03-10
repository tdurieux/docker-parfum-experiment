FROM php:8-fpm

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    cron \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libssl-dev \
    mariadb-client \
    zlib1g-dev \
    bzip2 \
    supervisor \
    libzip-dev \
    vim \
    git && rm -rf /var/lib/apt/lists/*;


# remove apt lists
RUN rm -rf /var/lib/apt/lists/*

# install php extentions
RUN docker-php-ext-install gd mysqli zip pdo pdo_mysql soap ftp opcache bcmath pcntl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg\
&& docker-php-ext-configure pcntl --enable-pcntl

RUN touch /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_autostart=0 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_connephpct_back=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_log=/tmp/php5-xdebug.log >> /usr/local/etc/php/conf.d/xdebug.ini;

EXPOSE 9000
COPY ./owner-changer.sh /owner-changer.sh
RUN chmod +x /owner-changer.sh
ENTRYPOINT ["/owner-changer.sh"]
CMD ["www-data"]
