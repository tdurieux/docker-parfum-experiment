FROM php:8.0-fpm

# Grab magical script that brings back balance throughout earth
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install NGINX and other packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      nginx \
      cron \
      supervisor && rm -rf /var/lib/apt/lists/*;

# Configure NGINX
COPY nginx.conf /etc/nginx/sites-enabled/default

# Configure cron
COPY cron.conf /etc/cron.d/budget

# Configure Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/budget.conf

# Install PHP extensions
RUN install-php-extensions pdo_mysql zip calendar gd

# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js and Yarn
RUN curl -f -sL https://deb.nodesource.com/setup_15.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www
