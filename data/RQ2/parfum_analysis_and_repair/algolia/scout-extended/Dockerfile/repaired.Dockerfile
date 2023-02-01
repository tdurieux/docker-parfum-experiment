# Dockerfile
FROM php:7.4.1-fpm

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        wget \
        zip \
        unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer