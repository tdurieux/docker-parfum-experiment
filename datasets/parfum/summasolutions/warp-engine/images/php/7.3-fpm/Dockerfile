FROM summasolutions/php:7.3-fpm

LABEL maintainer="Barchiesi Mauricio <barchiesi.mauricio@gmail.com>"

# Custom Entrypoint Stuffs:
COPY --chown=root:root setup-php-modules-summa /usr/local/bin/
RUN chmod 755 /usr/local/bin/setup-php-modules-summa
COPY --chown=root:root php-custom-entrypoint /usr/local/bin/
RUN chmod 755 /usr/local/bin/php-custom-entrypoint

RUN apt-get update && apt-get install -y sudo
RUN echo "www-data  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT ["php-custom-entrypoint"]
CMD ["php-fpm"]