# Production Image
FROM php:7.3-fpm-alpine3.14

# Install deps + sudo
RUN apk update
RUN apk add libpng-dev libzip-dev composer
RUN docker-php-ext-install gd zip pdo_mysql
RUN apk add sudo

# Add user and let it sudo
RUN addgroup -g 1000 datawrapper
RUN adduser -D -G datawrapper -u 1000 datawrapper
RUN echo "datawrapper ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN cd /usr/local/etc/php && \
	ln -s php.ini-production php.ini && \
	sed -i \
		-e 's@^memory_limit = 128M$@memory_limit = 512M@' \
		-e 's@^upload_max_filesize = 2M$@upload_max_filesize = 8M@' php.ini
RUN sed -i \
	-e 's@^pm.max_children = 5$@pm.max_children = 25@' \
	-e 's@^pm.start_servers = 2$@pm.start_servers = 5@' \
	-e 's@^pm.min_spare_servers = 1$@pm.min_spare_servers = 2@' \
	-e 's@^pm.max_spare_servers = 3$@pm.max_spare_servers = 5@' \
	/usr/local/etc/php-fpm.d/www.conf

RUN sed -i \
	-e 's@^listen = 9000$@listen = 0.0.0.0:9000@' \
	/usr/local/etc/php-fpm.d/zz-docker.conf


RUN mkdir /etc/datawrapper && \
	ln -s /datawrapper/code/config.yaml /etc/datawrapper/config.yaml

USER datawrapper

ENTRYPOINT ["/datawrapper/code/services/php/docker/entrypoint.sh"]

CMD ["php-fpm"]
