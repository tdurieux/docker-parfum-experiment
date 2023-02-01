FROM php:8.0-cli

RUN apt-get update && apt-get install --no-install-recommends -y \
        unzip \
    && docker-php-source extract \
    && php -r 'file_put_contents("mysql.zip", file_get_contents("https://github.com/php/pecl-database-mysql/archive/refs/heads/master.zip"));' \
    && unzip -q mysql.zip \
    && cd pecl-database-mysql-master \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j$(nproc) install \
    && docker-php-ext-enable mysql \
    && docker-php-ext-install pdo_mysql \
    && docker-php-source delete && rm -rf /var/lib/apt/lists/*;