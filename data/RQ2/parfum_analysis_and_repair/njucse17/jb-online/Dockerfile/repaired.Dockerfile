FROM php:7.3-cli

RUN apt-get update -yqq
RUN apt-get install --no-install-recommends -yqq build-essential git curl unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq icu-devtools libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN docker-php-ext-install bcmath intl pdo pdo_mysql

RUN curl -f --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require laravel/envoy

RUN curl -f https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz | tar xJf - --exclude CHANGELOG.md --exclude LICENSE --exclude README.md --strip-components 1 -C /usr/local/
RUN npm install -g yarn && npm cache clean --force;