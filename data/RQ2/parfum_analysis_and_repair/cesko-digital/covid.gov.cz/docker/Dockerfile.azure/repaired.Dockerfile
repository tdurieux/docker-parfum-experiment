## Install dependencies by composer
FROM composer:1 as deps

# Copy only composer files, so cache relies only on them.
COPY composer.json composer.lock /app/
COPY scripts/composer/ScriptHandler.php /app/scripts/composer/
RUN cd /app && composer install --ignore-platform-reqs

FROM php:7.3-apache

ENV DB_NAME="msdb"
ENV DB_USER="sa"
ENV DB_PASS="SuperDrupalSite8"
ENV DB_HOST="database"
ENV DB_PORT="1433"
ENV DB_SCHEMA="dbo"
ENV BASE_URL=""

USER root

RUN addgroup -g 1001 -S default \
    && adduser -u 1001 -S default -G default \
	  && mkdir -p /app \
	  && chown -R 1001:1001 /app

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates wget apt-transport-https gnupg apt-utils && rm -rf /var/lib/apt/lists/*;
# Add Microsoft repositories
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN chown 1001:1001 /var/www
RUN apt-get update \
    && apt-get install --no-install-recommends -y libpng-dev libjpeg-dev libwebp-dev libpq-dev libmemcached-dev zlib1g-dev libicu-dev libzip-dev libxslt-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 mssql-tools unixodbc-dev g++ make && rm -rf /var/lib/apt/lists/*;
RUN pecl install sqlsrv pdo_sqlsrv redis \
    && docker-php-ext-configure bcmath --enable-bcmath \
    && docker-php-ext-configure gd --with-webp-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring opcache zip xsl bz2 exif  bcmath \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv redis \
    && apt-get clean

COPY ./php/php.ini /usr/local/etc/php/conf.d/drupal.ini
COPY ./php/apache.conf /etc/apache2/sites-enabled/000-default.conf

RUN sed -s -i -e "s/80/8080/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf
RUN sed -i "s/@@DOMAIN@@/$BASE_URL/g" /etc/apache2/sites-enabled/000-default.conf

WORKDIR /app

# Copy dependencies from first stage
COPY --from=deps /app /app
# Copy app
COPY . /app/

RUN mkdir -pm 777 /tmp/drupal /privatefiles /app/web/sites/default/files \
	&& chown -R 1001:1001 /tmp/drupal /privatefiles /app/web/sites/default/files /app/web

VOLUME ["/tmp/drupal", "/privatefiles", "/app/web/sites/default/files"]

EXPOSE 8080

USER 1001
