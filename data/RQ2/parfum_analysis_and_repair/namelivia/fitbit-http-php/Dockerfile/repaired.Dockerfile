FROM php:8.0

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    libzip-dev \
    zip && rm -rf /var/lib/apt/lists/*;

# Install extensions
RUN docker-php-ext-install zip

# Set working directory
WORKDIR /usr/src/app

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /usr/src/app

# Install dependencies
RUN ["composer", "install"]
