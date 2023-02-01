FROM razonyang/php-cron:7.2
RUN apt-get update

# Intl
RUN apt-get install --no-install-recommends -y \
        zlib1g-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*;

# MySQL
RUN docker-php-ext-install pdo_mysql

# PostgreSQL
RUN apt-get update && apt-get install --no-install-recommends -y \
        libpq-dev \
    && docker-php-ext-install pdo_pgsql && rm -rf /var/lib/apt/lists/*;