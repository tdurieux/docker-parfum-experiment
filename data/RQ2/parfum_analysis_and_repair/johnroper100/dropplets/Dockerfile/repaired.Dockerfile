FROM php:7.4-apache

RUN a2enmod rewrite ssl proxy proxy_http headers

RUN apt-get update && apt-get install --no-install-recommends -y \
git \
bash \
curl \
unzip \
vim && rm -rf /var/lib/apt/lists/*;