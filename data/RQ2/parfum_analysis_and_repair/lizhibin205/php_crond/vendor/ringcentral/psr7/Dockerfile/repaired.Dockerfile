FROM    greensheep/dockerfiles-php-5.3
RUN apt-get update -y && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php
RUN     mv composer.phar /usr/local/bin/composer