FROM php:8.1-fpm
WORKDIR /app/

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libfreetype6-dev \
    locales \
    zip \
    unzip \
    libzip-dev \
    git \
    curl && rm -rf /var/lib/apt/lists/*;

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo_mysql zip exif pcntl

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /app/
