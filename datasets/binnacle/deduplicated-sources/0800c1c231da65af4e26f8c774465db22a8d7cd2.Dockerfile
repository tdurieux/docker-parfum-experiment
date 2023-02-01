ARG PHP_IMAGE_VERSION
FROM dmstr/php-yii2:${PHP_IMAGE_VERSION}-alpine

# Install Forego
RUN curl -L -o /usr/local/bin/forego https://github.com/jwilder/forego/releases/download/v0.16.1/forego
RUN chmod u+x /usr/local/bin/forego

# Install nginx
RUN apk --update add nginx

# Add configuration files, Note: nginx runs under `www-data`
# Note: chmod is a workaround for esotheric permissions issues on Alpine
COPY image-files/ /
RUN chown -R www-data:www-data /var/lib/nginx/ \
 && mkdir -p /var/lib/nginx/tmp \
 && chmod 777 /var/lib/nginx/tmp

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["forego", "start", "-r", "-f", "/root/Procfile"]

EXPOSE 80 443