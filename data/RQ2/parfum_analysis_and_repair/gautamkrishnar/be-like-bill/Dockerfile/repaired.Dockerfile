FROM php:5.6-apache
RUN apt-get update && apt-get install --no-install-recommends -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;
COPY . /var/www/html/
