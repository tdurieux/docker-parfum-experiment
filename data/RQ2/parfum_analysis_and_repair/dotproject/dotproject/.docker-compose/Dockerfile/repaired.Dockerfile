FROM  phpdockerio/php74-fpm

RUN apt update && \
      apt install -y --no-install-recommends \
        php7.4-mysql && rm -rf /var/lib/apt/lists/*;
