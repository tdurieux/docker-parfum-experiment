FROM php:7.2-fpm

# Install nginx & ruby stuff (for sass)
RUN apt-get update && apt-get install -y -q nginx \
    && apt-get install -y -q libssl-dev build-essential vim git curl ruby2.3-dev rubygems zlib1g-dev

RUN apt-get update \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install zip \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

ADD ./fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf
ADD ./upstream-php.conf /etc/nginx/conf.d/php7.2-fpm.conf
ADD ./vhost.sh /tmp/vhost.sh

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=v0.12.2

RUN . $HOME/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN gem update --system \
    && gem install sass compass --no-document

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/sbin/composer

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
