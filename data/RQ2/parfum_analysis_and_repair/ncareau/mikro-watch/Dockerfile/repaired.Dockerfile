FROM php:7.4-cli

RUN apt-get update && \
					apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pcntl bcmath

RUN curl -f -sS https://getcomposer.org/installer | \
            php -- --install-dir=/usr/bin/ --filename=composer

COPY . /app

WORKDIR /app

RUN php /usr/bin/composer install --no-dev --no-interaction

CMD [ "php", "./mikro-watch",  "daemon" ]
