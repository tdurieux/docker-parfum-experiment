FROM wordpress:5-php7.3

ENV WORDPRESS_VERSION 5.5
ENV WORDPRESS_UPSTREAM_VERSION 5.5.3
ENV WORDPRESS_SHA1 61015720c679a6cbf9ad51701f0f3fedb51b3273

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -f -o wordpress.tar.gz -sSL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && mkdir /usr/src/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /usr/src/wordpress && rm -rf /usr/src/wordpress/wp-content/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
