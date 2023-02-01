FROM wordpress:5-php7.3

ENV WORDPRESS_VERSION 5.9
ENV WORDPRESS_UPSTREAM_VERSION 5.9
ENV WORDPRESS_SHA1 4e9a256f5cbcfba26108a1a9ebdb31f2ab29af9f
ENV WORDPRESS_DB_USER root
ENV WORDPRESS_DB_PASSWORD root
ENV WORDPRESS_DEBUG true

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -f -o wordpress.tar.gz -sSL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && mkdir /usr/src/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /usr/src/wordpress && rm -rf /usr/src/wordpress/wp-content/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
