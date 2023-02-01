FROM php:7
RUN apt-get update -y && apt-get install --no-install-recommends -y openssl zip unzip git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo
WORKDIR /app
COPY . /app
RUN composer install

CMD php artisan serve --host=0.0.0.0 --port=8080
EXPOSE 8080
