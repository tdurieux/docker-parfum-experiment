# Note : if you set the environment variable COMPOSE_PROJECT_NAME to a non-default value, you'll need to set the
# DISTRIBUTION_IMAGE build arg too (for instance docker-compose build --no-cache --build-arg DISTRIBUTION_IMAGE=customprojectname_app distribution)
ARG DISTRIBUTION_IMAGE=docker_app
ARG PHP_IMAGE=ezsystems/php:7.4-v1
FROM ${DISTRIBUTION_IMAGE} as distrofiles

FROM ${PHP_IMAGE} as builder

COPY --from=distrofiles /var/www /var/www

RUN composer config extra.symfony-assets-install hard
RUN composer run-script post-install-cmd --no-interaction

RUN rm -Rf /var/www/var/cache/*/*

FROM busybox

COPY --from=builder /var/www /var/www

WORKDIR /var/www

# Fix permissions for www-data