FROM php:7.0-cli

# Update and import specific required librairies

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
	unzip \
	libicu-dev \
	gcc \
	wget \
	zlib1g-dev \
    libzip-dev && rm -rf /var/lib/apt/lists/*;

# Parametrize PHP

RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install pcntl
RUN docker-php-source delete

# Install composer
COPY composer.sh /
RUN chmod +x composer.sh
RUN /composer.sh
RUN mv composer.phar /usr/local/bin/composer
RUN mkdir /.composer && chmod o+rwx /.composer
