FROM public.ecr.aws/lts/ubuntu:focal

ENV TZ=America/New_York

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update \
    && apt-get -yqq --no-install-recommends install \
    php \
    apache2 \
    libapache2-mod-php \
    php-mysql \
    php-xml \
    php-curl \
    php-gd \
    php-zip \
    php-pdo \
    php-mbstring \
    unzip \
    libmcrypt-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    libpng-dev \
    mcrypt \
    curl \
    zip && rm -rf /var/lib/apt/lists/*;

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN /bin/bash -c "source /etc/apache2/envvars"

EXPOSE 80

ADD docker/index.html /var/www/html
ADD main_server/. /var/www/html/main_server
ADD docker/auto-config.inc.php /var/www/html/auto-config.inc.php
ADD docker/start-bmlt.sh /tmp/start-bmlt.sh

RUN chown -R www-data: /var/www/html
RUN chmod 0644 /var/www/html/auto-config.inc.php
RUN chmod +x /tmp/start-bmlt.sh

RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

CMD ["/bin/bash", "/tmp/start-bmlt.sh"]
