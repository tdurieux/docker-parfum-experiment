FROM wordpress:latest

RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN docker-php-ext-install pdo_mysql

RUN apt-get update \
    && apt-get -y --no-install-recommends install default-mysql-client less && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN curl -f -sLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN usermod -u $UID www-data
RUN groupmod -o -g $GID www-data
