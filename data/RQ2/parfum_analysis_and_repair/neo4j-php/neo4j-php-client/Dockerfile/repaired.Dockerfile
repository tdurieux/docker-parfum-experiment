FROM php:8.1-cli
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libzip-dev \
        unzip \
        git \
        wget \
    && docker-php-ext-install -j$(nproc) bcmath \
    && wget https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 \
    && mv test-reporter-latest-linux-amd64 /usr/bin/cc-test-reporter \
    && chmod +x /usr/bin/cc-test-reporter && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /opt/project

COPY composer.json ./

RUN composer install

COPY phpunit.xml.dist phpunit.coverage.xml.dist psalm.xml .php-cs-fixer.php ./
COPY src/ src/
COPY tests/ tests/
COPY .git/ .git/



