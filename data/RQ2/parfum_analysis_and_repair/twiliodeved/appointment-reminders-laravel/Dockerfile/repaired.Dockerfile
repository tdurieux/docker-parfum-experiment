FROM php:7.4

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Zip for Composer and Dusk
RUN apt-get install --no-install-recommends -y zip unzip libzip-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip

# Install Node
RUN apt-get -y --no-install-recommends install curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

COPY composer* ./
RUN curl -f --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer


COPY . .
RUN make install

EXPOSE 8000

CMD [ "php", "artisan", "serve", "--host=0.0.0.0" ]
