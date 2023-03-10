FROM hotsapi/hotsapi

RUN apt update && \
	apt install --no-install-recommends -y php7.0-fpm nginx supervisor && \
	rm -rf /var/lib/apt/lists/*

RUN sed -i 's/upload_max_filesize = .*/upload_max_filesize = 30M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/post_max_size = .*/post_max_size = 30M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/;clear_env = .*/clear_env = no/g' /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i 's/pm.max_children = .*/pm.max_children = 10/g' /etc/php/7.0/fpm/pool.d/www.conf
RUN mkdir /var/run/php
COPY docker/nginx.conf /etc/nginx
COPY docker/supervisord.conf /etc/supervisor

EXPOSE 80
ENTRYPOINT []
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
