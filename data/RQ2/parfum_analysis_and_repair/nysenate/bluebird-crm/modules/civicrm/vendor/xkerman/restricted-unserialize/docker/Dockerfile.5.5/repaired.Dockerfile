FROM nyanpass/php5.5:5.5-cli

RUN echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    pecl install xdebug-2.5.5 && \
    docker-php-ext-enable xdebug && rm -rf /var/lib/apt/lists/*;
