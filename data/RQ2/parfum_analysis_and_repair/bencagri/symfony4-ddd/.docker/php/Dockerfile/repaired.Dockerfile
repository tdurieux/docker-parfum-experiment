FROM php:7.3-cli


# Installing Ubuntu Packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-utils \
    && apt-get install --no-install-recommends -y sqlite3 \
    && apt-get install --no-install-recommends -y gzip git jq \
    && apt-get install --no-install-recommends -y zip unzip \
    && apt-get install --no-install-recommends -y libxml2-dev libzip-dev \
    && apt-get install --no-install-recommends -y libssl-dev libcurl4-openssl-dev pkg-config \
    && apt-get install --no-install-recommends -y libicu-dev g++ libxml2 \
    && apt-get install --no-install-recommends -y libbz2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Installing PHP Core Extensions
RUN docker-php-ext-install -j$(nproc) iconv \
	&& docker-php-ext-install -j$(nproc) bcmath \
	&& docker-php-ext-install -j$(nproc) intl \
	&& docker-php-ext-install -j$(nproc) sockets \
	&& docker-php-ext-install -j$(nproc) opcache \
	&& docker-php-ext-install -j$(nproc) calendar \
	&& docker-php-ext-install -j$(nproc) pdo_mysql \
	&& docker-php-ext-install -j$(nproc) zip \
	&& docker-php-ext-install -j$(nproc) pcntl soap curl xml mbstring soap

# Enable PHP Debug
RUN	pecl install xdebug \
	&& docker-php-ext-enable xdebug

# Install PHP composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./php.ini /usr/local/etc/php/php.ini



