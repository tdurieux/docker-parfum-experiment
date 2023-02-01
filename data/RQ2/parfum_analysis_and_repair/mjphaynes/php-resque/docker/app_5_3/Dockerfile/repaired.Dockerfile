FROM tomsowerby/php-5.3

RUn apt-get update -yqq && apt-get upgrade -yqq

RUN apt-get install --no-install-recommends -yqq git-core && rm -rf /var/lib/apt/lists/*;

RUN pecl install -o -f redis &&  rm -rf /tmp/pear &&  docker-php-ext-enable redis

# composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pcntl


CMD composer install -v && tail -f /dev/null

