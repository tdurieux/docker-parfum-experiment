FROM nginx:latest

RUN apt-get update && apt-get install --no-install-recommends -y php5-fpm php5-curl && rm -rf /var/lib/apt/lists/*;

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -i 's/listen.owner = www-data/listen.owner = nginx/' /etc/php5/fpm/pool.d/www.conf
RUN sed -i 's/listen.group = www-data/listen.group = nginx/' /etc/php5/fpm/pool.d/www.conf
RUN sed -i 's/;listen.mode = 0660/listen.mode = 0660/' /etc/php5/fpm/pool.d/www.conf

COPY ./docker/default.conf /etc/nginx/conf.d/

CMD service php5-fpm start && nginx