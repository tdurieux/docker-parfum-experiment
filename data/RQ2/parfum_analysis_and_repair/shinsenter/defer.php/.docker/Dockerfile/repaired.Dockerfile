# Dockerfile
FROM php:7-zts

# Install Composer, NPM
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    ; apt update -y \
    ; apt install --no-install-recommends -y nodejs npm git zip unzip \
    ; rm -rf /var/lib/apt/lists/*; npm i -g npm && npm cache clean --force;

CMD ["/usr/local/bin/composer", "docker"]
