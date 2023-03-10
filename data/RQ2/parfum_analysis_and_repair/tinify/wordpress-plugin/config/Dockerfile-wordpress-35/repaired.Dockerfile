FROM wordpress:4-php5.6

RUN docker-php-ext-install mysql

ENV WORDPRESS_VERSION 3.5.2
ENV WORDPRESS_UPSTREAM_VERSION 3.5.2
ENV WORDPRESS_SHA1 f75e9aadb1c2f754e89aacdfb5ab72bbfb10678d

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -f -o wordpress.tar.gz -sSL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && mkdir /usr/src/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /usr/src/wordpress && rm -rf /usr/src/wordpress/wp-content/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
