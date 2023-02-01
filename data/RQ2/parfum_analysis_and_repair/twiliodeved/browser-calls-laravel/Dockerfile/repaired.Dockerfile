FROM php:7.4

WORKDIR /usr/src/app

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y zip unzip && rm -rf /var/lib/apt/lists/*;

COPY composer* ./
RUN curl -f --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer


COPY . .
RUN make install

EXPOSE 8000

CMD [ "php", "artisan", "serve", "--host=0.0.0.0" ]
