FROM    php:7.3-apache
RUN apt-get update -y && apt-get install --no-install-recommends -y libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install gd
RUN apt-get install --no-install-recommends -y libicu-dev \
        && docker-php-ext-configure intl \
        && docker-php-ext-install intl \
        && docker-php-ext-install gettext \
        && apt-get install --no-install-recommends -y locales-all && rm -rf /var/lib/apt/lists/*;

COPY    translations /var/www/translations/
COPY    www/ /var/www/html/
COPY    on-init /pwinit/
