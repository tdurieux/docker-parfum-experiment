ARG PHP_VERSION
FROM bref/tmp/cleaned-build-php-$PHP_VERSION
ARG PHP_VERSION

COPY bootstrap /opt/bootstrap
COPY breftoolbox.php /opt/breftoolbox.php
COPY php.ini /opt/bref/etc/php/conf.d/bref.ini
COPY php-fpm.conf /opt/bref/etc/php-fpm.conf

# Build the final image from the amazon image that is close to the production environment
FROM public.ecr.aws/lambda/provided:al2
COPY --from=0 /opt /opt
# Copy files to /var/runtime to support deploying as a Docker image
RUN cp /opt/bootstrap /var/runtime && cp /opt/breftoolbox.php /var/runtime