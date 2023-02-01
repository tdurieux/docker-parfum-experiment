# Markdown renderer does not support PHP 8 due to a syntax deprecation
FROM php:7-apache

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/www/html

RUN git clone --depth 1 --branch master https://github.com/Overv/Open.GL.git .
