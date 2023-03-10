RUN apt-get update; \
    apt-get install -y --no-install-recommends \
      autoconf automake libtool nasm make pkg-config libz-dev build-essential g++ iproute2; \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    apt-get autoremove -y; \
    apt-get remove -y autoconf automake libtool nasm make pkg-config libz-dev build-essential g++; \
    apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* ~/.composer;

# allow container to run as custom user, this won't work otherwise because config is changed in entrypoint.sh
RUN chmod -R 0777 /usr/local/etc/php/conf.d

ENV PHP_IDE_CONFIG serverName=localhost

COPY entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]