# Run Attendize on an apache server
# Multi stage docker file for the Attendize application layer images

# Base image with apache, php, composer and mysql built on ubuntu
FROM leen15/apache-php-mysql as base

# update composer to v2
RUN composer self-update

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
       libpq-dev \
       libpng-dev \
       libjpeg62-dev \
       libfreetype6-dev \
       libxrender1 \
       libfontconfig \
       libxext-dev \
       libglib2.0-0 \
       php-mysql \
       php-pgsql \
       php-gd \
       php-zip \
       zip \
       unzip git nano \
       wait-for-it && rm -rf /var/lib/apt/lists/*;

# Set up code
WORKDIR /var/www
COPY . .

# run composer, chmod files, setup laravel key
RUN ./scripts/setup

# The worker container runs the laravel queue in the background
FROM base as worker

CMD ["php", "artisan", "queue:work", "--daemon"]

# The web container runs the HTTP server and connects to all other services in the application stack
FROM base as web

# TODO: Add self signed SSL certificate

# Port to expose
EXPOSE 80

# Starting apache server
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

# NOTE: if you are deploying to production with this image, you should extend this Dockerfile with another stage that
# performs clean up (i.e. removing composer) and installs your own dependencies (i.e. your own ssl certificate).
