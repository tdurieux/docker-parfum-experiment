FROM hhvm/hhvm:latest

# APT packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# XDebug configuration
COPY config/xdebug.ini /var/www/xdebug.ini

# Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin

# Bash
RUN chsh -s /bin/bash www-data

# Permissions
RUN chown www-data:www-data /var/www

# Workdir
WORKDIR /var/www/html

# Entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
