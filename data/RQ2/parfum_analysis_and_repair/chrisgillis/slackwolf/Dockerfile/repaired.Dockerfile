FROM php:5.6-cli
RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

COPY . /usr/src/slackwolf
WORKDIR /usr/src/slackwolf

RUN composer install --prefer-source --no-interaction
CMD [ "php", "./bot.php" ]
