FROM medicean/vulapps:base_lamp
MAINTAINER Medici.Yan <Medici.Yan@Gmail.com>

ARG WP_URL=http://oe58q5lw3.bkt.clouddn.com/w/wordpress/wordpress/wordpress-4.6.tar.gz
ARG WPCLI_URL=http://oe58q5lw3.bkt.clouddn.com/w/wordpress/wp-cli/wp-cli.phar

COPY src/wordpress.sql /tmp/wordpress.sql
COPY src/apache2.conf /etc/apache2/apache2.conf
RUN set -x \
    && apt-get update \
    && apt-get install -y --force-yes php5-mysql php5-dev php5-gd php5-memcache php5-pspell php5-snmp snmp php5-xmlrpc libapache2-mod-php5 php5-cli unzip wget exim4 \
    && ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ \
    && rm -rf /var/www/html/* \
    && wget -qO /tmp/wordpress.tar.gz $WP_URL \
    && tar -zxf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm -rf /tmp/wordpress.tar.gz

COPY src/.htaccess /var/www/html/.htaccess
COPY src/wp-config.php /var/www/html/wp-config.php

RUN set -x \
    && wget -qO /usr/bin/wp $WPCLI_URL \
    && chmod a+x /usr/bin/wp \
    && chown -R www-data:www-data /var/www/html/ \
    && /etc/init.d/mysql start \
    && mysql -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8;" -uroot -proot \
    && mysql -e "use wordpress;source /tmp/wordpress.sql;" -uroot -proot \
    && rm -f /tmp/wordpress.sql

COPY src/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 80
CMD ["/start.sh"]
