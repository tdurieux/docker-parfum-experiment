FROM webdevops/apache:ubuntu-16.04

MAINTAINER Eric Pfeiffer <computerfr33k@users.noreply.github.com>

ARG PHP_SOCKET=php-fpm:9000
ARG PROJECT_SUBDIRECTORY=""

ENV WEB_PHP_SOCKET=$PHP_SOCKET

ENV WEB_DOCUMENT_ROOT=/var/www/$PROJECT_SUBDIRECTORY

EXPOSE 80 443

WORKDIR /var/www

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]

CMD ["supervisord"]