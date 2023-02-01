FROM php:8-fpm

# Get repository and install wget and vim
RUN apt-get update && apt-get install --no-install-recommends -y wget vim git unzip apt-transport-https gnupg && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen && rm -rf /var/lib/apt/lists/*;

# Install PHP extensions deps
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        unixodbc-dev \
        libssl-dev \
        g++ && rm -rf /var/lib/apt/lists/*;

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install \
            mbstring \
            pdo_mysql \
            zip \
            ftp \
    && docker-php-ext-enable \
            opcache

# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

# Install supervisor
RUN apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# Clean repository
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN "date"

CMD mkdir -p /app

VOLUME /app

CMD chown -R www-data:www-data /app

WORKDIR /app

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]
