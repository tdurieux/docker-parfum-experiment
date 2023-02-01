FROM 7.4

WORKDIR /DOCKER_APPLICATION

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    unzip \
    g++ \
    libzip-dev \
    && pecl -q install \ 
    zip \
    && docker-php-ext-configure \ 
    opcache --enable-opcache \
    && docker-php-ext-enable \ 
    zip \ 
    opcache && rm -rf /var/lib/apt/lists/*;

