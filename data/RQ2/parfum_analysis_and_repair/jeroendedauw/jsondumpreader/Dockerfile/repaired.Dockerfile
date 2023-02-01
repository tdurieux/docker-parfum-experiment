FROM php:7.2-cli

RUN apt-get update \
	&& apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libbz2-dev \
	&& docker-php-ext-install -j$(nproc) bz2 \
	&& apt-get install --no-install-recommends -y libicu-dev \
	&& docker-php-ext-install -j$(nproc) intl && rm -rf /var/lib/apt/lists/*;