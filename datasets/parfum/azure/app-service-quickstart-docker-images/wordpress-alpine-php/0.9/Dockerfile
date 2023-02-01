#
# Dockerfile for WordPress
#
FROM appsvcorg/nginx-fpm:php7.3.4-redis
LABEL MAINTAINER Azure App Service Container Images <appsvc-images@microsoft.com>
# ========
# ENV vars
# ========
# ssh

ENV SUPERVISOR_LOG_DIR "/var/log/supervisor"

ENV SSH_PASSWD "root:Docker!"
ENV SSH_PORT 2222
#nginx
ENV NGINX_LOG_DIR "/var/log/nginx"
#php
ENV PHP_HOME "/usr/local/etc/php"
ENV PHP_CONF_DIR $PHP_HOME
ENV PHP_CONF_FILE $PHP_CONF_DIR"/php.ini"
# mariadb
ENV MARIADB_DATA_DIR "/home/data/mysql"
ENV MARIADB_LOG_DIR "/var/log/mysql"
# phpmyadmin
ENV PHPMYADMIN_SOURCE "/usr/src/phpmyadmin"
ENV PHPMYADMIN_HOME "/home/phpmyadmin"
# wordpress
ENV WORDPRESS_SOURCE "/usr/src/wordpress"
ENV WORDPRESS_HOME "/home/site/wwwroot"
#
ENV DOCKER_BUILD_HOME "/dockerbuild"
# ====================
# ====================
# wordpress
COPY wordpress_src/. $WORDPRESS_SOURCE/
# supervisor
COPY supervisord.conf /etc/
# php
COPY uploads.ini /usr/local/etc/php/conf.d/
# nginx

# override nginx config
COPY nginx_conf/nginx.conf /etc/nginx/nginx.conf
COPY nginx_conf/default.conf /etc/nginx/conf.d/default.conf
COPY nginx_conf/spec-settings.conf /etc/nginx/conf.d/spec-settings.conf

#
COPY local_bin/. /usr/local/bin/
RUN chmod -R +x /usr/local/bin
EXPOSE $SSH_PORT 80
ENTRYPOINT ["entrypoint.sh"]
