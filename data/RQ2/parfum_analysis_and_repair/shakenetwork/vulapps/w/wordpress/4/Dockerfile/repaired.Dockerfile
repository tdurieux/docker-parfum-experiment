FROM medicean/vulapps:base_wordpress
MAINTAINER Medici.Yan@Gmail.com

ENV STATIC_DOMAIN http://oe58q5lw3.bkt.clouddn.com
ENV PLUGIN_NAME product-catalog-8
ENV PLUGIN_VERSION 1.2

RUN apt-get install --no-install-recommends -y unzip wget && rm -rf /var/lib/apt/lists/*;

RUN set -x \
    && wget -qO /tmp/$PLUGIN_NAME-$PLUGIN_VERSION.zip $STATIC_DOMAIN/w/wordpress/plugins/$PLUGIN_NAME-$PLUGIN_VERSION.zip \
    && unzip -x /tmp/$PLUGIN_NAME-$PLUGIN_VERSION.zip -d /var/www/html/wp-content/plugins/ \
    && chown -R www-data:www-data /var/www/html/ \
    && /etc/init.d/mysql start \
    && wp --path=/var/www/html/ plugin activate $PLUGIN_NAME --allow-root \
    && chown -R www-data:www-data /var/www/html/ \
    && rm -rf /tmp/*

EXPOSE 80
CMD ["/start.sh"]
