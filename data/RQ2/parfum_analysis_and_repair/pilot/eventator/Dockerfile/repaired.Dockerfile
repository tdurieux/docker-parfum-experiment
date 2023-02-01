FROM phpmentors/symfony-app:php70

# default document root is /var/app/web folder
COPY ./ /var/app

# example how to install app in the container
# RUN apt-get update && \
#    apt-get install -y curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update && apt-get install --no-install-recommends -y \
    unzip \
    libssl-dev \
    libzip-dev \
    zlib1g-dev \
    libgs-dev \
    cron && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

VOLUME ["/var/app"]

WORKDIR /var/app

EXPOSE 80