FROM php:7-fpm

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN apt update -y
RUN docker-php-ext-install iconv
RUN apt install --no-install-recommends -y libicu-dev && docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libpq-dev && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pgsql && rm -rf /var/lib/apt/lists/*;

# Configure python
COPY requirements.txt .
RUN apt install --no-install-recommends -y python3 python3-pip && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# Configure cron
RUN apt install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;
COPY cron /etc/cron.d/clist
RUN chmod 0644 /etc/cron.d/clist
RUN crontab /etc/cron.d/clist

ENV APPDIR=/usr/src/legacy
WORKDIR $APPDIR

CMD bash -c "cron && php-fpm"
