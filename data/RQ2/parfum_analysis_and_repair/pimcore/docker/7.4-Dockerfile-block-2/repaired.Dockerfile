docker-php-ext-configure gd -enable-gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install xmlrpc gd; \
    pecl install imagick; \
