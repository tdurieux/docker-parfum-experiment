FROM php:7.2-cli

RUN docker-php-ext-install mysqli
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && docker-php-ext-install pgsql && rm -rf /var/lib/apt/lists/*;

# Memory Limit
RUN echo "memory_limit=1024M" > $PHP_INI_DIR/conf.d/memory-limit.ini
