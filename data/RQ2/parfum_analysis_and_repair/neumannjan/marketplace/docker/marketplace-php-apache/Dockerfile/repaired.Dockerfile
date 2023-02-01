FROM webdevops/php-apache-dev:7.1

RUN apt-get update && apt-get install --no-install-recommends -y supervisor zlib1g-dev libicu-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

COPY laravel-worker.conf /opt/docker/etc/supervisor.d

COPY crontab /opt/docker/etc/cron/laravel
RUN chmod 0644 /opt/docker/etc/cron/laravel

COPY entrypoint.sh /entrypoint.d
