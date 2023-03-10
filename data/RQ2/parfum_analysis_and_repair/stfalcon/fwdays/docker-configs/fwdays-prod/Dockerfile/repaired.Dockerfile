FROM gitlab.stfalcon.com:4567/stfalcon/fwdays/fwdays-base:v1.4
RUN apt-get update && apt-get install --no-install-recommends -y nginx-extras && rm -rf /var/lib/apt/lists/*;
ADD configs/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
ADD configs/fpm-pool.conf /etc/php/7.3/fpm/pool.d/www.conf
ADD configs/php-fpm.ini /etc/php/7.3/fpm/php.ini
ADD configs/php-cli.ini /etc/php/7.3/cli/php.ini
ADD configs/nginx.conf /etc/nginx/nginx.conf
ADD configs/nginx-vhost.conf /etc/nginx/conf.d/fwdays.conf
ADD configs/admin_auth /etc/nginx/admin_auth
RUN mkdir /etc/nginx/stag_conf_avaliable /etc/nginx/stag_conf_enabled
COPY configs/stag_conf/* /etc/nginx/stag_conf_avaliable
ADD configs/start /usr/local/bin/start
RUN chmod a+x /usr/local/bin/start
ADD configs/services /usr/local/bin/services
RUN chmod a+x /usr/local/bin/services
RUN usermod -s /bin/bash www-data
ADD configs/graceful-shutdown /usr/local/bin/graceful-shutdown
RUN chmod a+x /usr/local/bin/graceful-shutdown
ENTRYPOINT ["/usr/local/bin/start"]
CMD ["/usr/local/bin/services"]
