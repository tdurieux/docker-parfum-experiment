FROM php:5.6-cli

WORKDIR /usr/src/myapp

RUN apt-get update && apt-get install -y \
    git \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY composer.json /usr/src/myapp
RUN composer install

COPY . /usr/src/myapp
CMD [ "/bin/bash" ]

# docker build -t diff-match-patch:5.6 -f ./Dockerfile_5.6 .
# docker run -it --rm diff-match-patch:5.6 ./vendor/bin/phpunit
# docker run -it -v `pwd`/src:/usr/src/myapp/src -v `pwd`/tests:/usr/src/myapp/tests  --rm  diff-match-patch:5.6
