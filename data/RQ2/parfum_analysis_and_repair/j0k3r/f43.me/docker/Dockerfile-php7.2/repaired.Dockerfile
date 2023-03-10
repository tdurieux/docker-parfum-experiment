FROM php:7.2-fpm

# Install nginx & ruby stuff (for sass)
RUN apt-get update \
    && apt-get install --no-install-recommends -y -q nginx libssl-dev build-essential vim git curl ruby-dev rubygems zlib1g-dev apt-utils && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql

ADD ./fastcgi-php.conf /etc/nginx/snippets/fastcgi-php.conf
ADD ./upstream-php.conf /etc/nginx/conf.d/php7.2-fpm.conf
ADD ./vhost.sh /tmp/vhost.sh

RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=v0.12.2

RUN . $HOME/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system --no-document \
    && gem install sass compass --no-document && rm -rf /root/.gem;

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/sbin/composer

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
