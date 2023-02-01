FROM php:7.2-apache

WORKDIR /var/www/

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y yarn && \
    apt-get install -y git && \
    a2enmod rewrite && \
    rm -r -f /var/www/html && \
    git clone https://github.com/enhavo/enhavo.git /var/www && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"  && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    apt-get install -y zlib1g-dev libicu-dev g++ && \
    apt-get install -y libpng-dev && \
    docker-php-ext-install intl && \
    docker-php-ext-install zip && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install gd && \
    docker-php-ext-install mbstring && \
    php composer.phar install --prefer-dist && \
    mkdir /var/startup && \
    git clone https://github.com/vishnubob/wait-for-it.git /var/startup/wait-for-it && \
    yarn install && \
    yarn encore prod

COPY etc/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY etc/php/docker-php-enhavo.ini /usr/local/etc/php/conf.d/docker-php-enhavo.ini
COPY startup/startup.bash /var/startup/startup.bash
COPY startup/docker-php-enrypoint.sh /usr/local/bin/docker-php-entrypoint
COPY startup/install.bash /var/startup/install.bash

RUN chmod 755 /usr/local/bin/docker-php-entrypoint && \
    chmod 755 /var/startup/startup.bash && \
    chmod 755 /var/startup/install.bash && \
    chmod 755 /var/www/var && \
    bin/console fos:js-routing:dump --format=json --target=public/js/fos_js_routes.json && \
    bin/console cache:warmup && \
    chown -R www-data:www-data /var/www/var

EXPOSE 80