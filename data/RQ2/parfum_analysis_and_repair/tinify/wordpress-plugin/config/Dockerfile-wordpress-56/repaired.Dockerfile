FROM wordpress:5-php7.3

ENV WORDPRESS_VERSION 5.6
ENV WORDPRESS_UPSTREAM_VERSION 5.6
ENV WORDPRESS_SHA1 db8b75bfc9de27490434b365c12fd805ca6784ce

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -f -o wordpress.tar.gz -sSL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && mkdir /usr/src/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /usr/src/wordpress && rm -rf /usr/src/wordpress/wp-content/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
