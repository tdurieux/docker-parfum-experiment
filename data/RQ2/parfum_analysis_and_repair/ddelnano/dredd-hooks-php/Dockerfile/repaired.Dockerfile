FROM php

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    wget \
    nodejs \
    npm \
    git \
    net-tools \
    zip \
    unzip \
    && wget https://getcomposer.org/installer \
    && chmod +x installer \
    && php installer --install-dir=/usr/local/bin/ --filename=composer && rm -rf /var/lib/apt/lists/*;