ARG PHP_IMAGE=ezsystems/php:7.3-v1
FROM ${PHP_IMAGE}-node as web-build

ENV SYMFONY_ENV=prod

# Copy in project files into work dir
COPY . /var/www

# Create asset directories that might not exists
RUN if [ ! -d /var/www/web/bundles ]; then mkdir /var/www/web/bundles; fi
RUN if [ ! -d /var/www/web/css ]; then mkdir /var/www/web/css; fi
RUN if [ ! -d /var/www/web/fonts ]; then mkdir /var/www/web/fonts; fi
RUN if [ ! -d /var/www/web/js ]; then mkdir /var/www/web/js; fi
RUN if [ ! -d /var/www/web/assets ]; then mkdir /var/www/web/assets; fi

# Generate assets using hard copy as we need to copy them over to resulting image
RUN composer config extra.symfony-assets-install hard
RUN composer run-script post-install-cmd --no-interaction


# Copy over just the files we want in second stage, so resulting stage only has assets
# and vhost config in as few layers as possible
FROM nginx:stable as web-multilayers

COPY bin/vhost.sh /var/www/bin/vhost.sh
COPY doc/nginx/vhost.template /var/www/doc/nginx/vhost.template

# Auto generated assets
COPY --from=web-build /var/www/web/bundles /var/www/web/bundles
COPY --from=web-build /var/www/web/css /var/www/web/css
COPY --from=web-build /var/www/web/fonts /var/www/web/fonts
COPY --from=web-build /var/www/web/js /var/www/web/js

# User provided assets
COPY --from=web-build /var/www/web/assets /var/www/web/assets


# In third stage build the resulting image
FROM nginx:stable

COPY --from=web-multilayers /var/www /var/www
COPY doc/nginx/ez_params.d /etc/nginx/ez_params.d

CMD /bin/bash -c "cd /var/www && bin/vhost.sh --template-file=doc/nginx/vhost.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"