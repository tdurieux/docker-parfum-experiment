FROM quay.io/vesica/php73:latest

# Copy files
RUN cd ../ && rm -rf /var/www/html
COPY . /var/www/
COPY /etc/apache2/mods-enabled/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# Run Composer
RUN cd /var/www && composer install --no-dev

RUN chown -R www-data:www-data /var/www/
ENV MYSQL_USER "someUser"
ENV MYSQL_PASSWORD "somePassword"
ENV MYSQL_DATABASE "someDb"
ENV MYSQL_HOST "localhost"
# 0 = disabled. 1 = enabled
ENV WAF_PROXY_MODE "0"
ENV WAF_KEY "someKey"
ENV LOAD_BALANCER_MODE "0"
ENV LOAD_BALANCER_KEY "KEY"

COPY doctrineProxies.sh /usr/local/bin/doctrineProxies.sh
RUN chmod 755 /usr/local/bin/doctrineProxies.sh

CMD ["/usr/local/bin/doctrineProxies.sh"]
