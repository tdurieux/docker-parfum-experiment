FROM wordpress:4-php7.0

ENV WORDPRESS_VERSION 4.0.10
ENV WORDPRESS_UPSTREAM_VERSION 4.0.10
ENV WORDPRESS_SHA1 a9e4d8cd92e211d55b40de3afd09efc5068ad483

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -f -o wordpress.tar.gz -sSL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && mkdir /usr/src/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /usr/src/wordpress && rm -rf /usr/src/wordpress/wp-content/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
