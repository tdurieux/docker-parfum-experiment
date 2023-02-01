FROM wpdiaries/wordpress-xdebug:5.8.2-php7.4-apache
RUN apt-get --allow-releaseinfo-change update && apt-get install --no-install-recommends -y git-core vim && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Want more than just the step debugger mode? Throw your additional modes in
# here. See documentation at https://xdebug.org/docs/all_settings#mode.
#
# RUN sed -i 's/xdebug.mode=debug/xdebug.mode=debug,develop,coverage,gcstats,profile,trace/g' /usr/local/etc/php/conf.d/xdebug.ini

RUN echo 'xdebug.client_host=host.docker.internal \n\
xdebug.start_with_request=yes \n\
xdebug.output_dir=/var/www/html/wp-content/plugins/cloudflare/xdebug' >> /usr/local/etc/php/conf.d/xdebug.ini
