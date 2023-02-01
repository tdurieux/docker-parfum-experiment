FROM php:7.2-apache

# Install Dependencies
RUN apt-get update && apt-get -y --no-install-recommends install gnupg2 \
    apt-transport-https \
    unixodbc-dev && rm -rf /var/lib/apt/lists/*;

# Add Microsoft repo for Microsoft ODBC Driver 17 for Linux
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -f https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update && ACCEPT_EULA=Y apt-get --no-install-recommends install -y \
    msodbcsql17 && rm -rf /var/lib/apt/lists/*;

# Enable the php extensions
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && rm -rf /var/lib/apt/lists/*

COPY ./ /var/www/html