FROM php:7.4-fpm

COPY . /usr/src/blog
WORKDIR /usr/src/blog

# install tools
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends zip unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxml2-dev && rm -rf /var/lib/apt/lists/*;

# install PHP extenstions
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install xml

#node js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x |  bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# install app
RUN composer install -vvv
RUN npm install && npm cache clean --force;
RUN composer update
RUN npm run dev

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

EXPOSE 8000
