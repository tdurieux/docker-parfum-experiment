FROM webdevops/apache:ubuntu-16.04

MAINTAINER Eric Pfeiffer <computerfr33k@users.noreply.github.com>

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

ENV WEB_PHP_SOCKET=${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}
ENV WEB_DOCUMENT_ROOT=/var/www/

EXPOSE 80 443 5233 5555

WORKDIR /var/www/

RUN apt-get update && \
    apt-get install --no-install-recommends -y --force-yes \
        nano \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]

CMD ["supervisord"]