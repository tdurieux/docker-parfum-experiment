FROM medicean/vulapps:base_wordpress
MAINTAINER cnsolu@163.com

COPY src/mailpress.sql /tmp/mailpress.sql

ENV PLUGIN_URL http://oe58q5lw3.bkt.clouddn.com/w/wordpress/plugins/mailpress-5.4.2.zip
RUN apt-get install --no-install-recommends -y wget unzip && rm -rf /var/lib/apt/lists/*;

RUN set -x \
    && wget -qO /tmp/mailpress-5.4.2.zip $PLUGIN_URL \
    && /etc/init.d/mysql start \
    && mysql -e "use wordpress;source /tmp/mailpress.sql;" -uroot -proot \
    && unzip -x /tmp/mailpress-5.4.2.zip -d /var/www/html/wp-content/plugins/ \
    && chown -R www-data:www-data /var/www/html/ \
    && wp --path=/var/www/html/ plugin activate mailpress --allow-root \
    && rm -rf /tmp/*

EXPOSE 80
CMD ["/start.sh"]
