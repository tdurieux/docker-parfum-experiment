FROM matthewpatell/universal-docker-server:4.0

# RUN apt-get update

RUN apt-get install --no-install-recommends -y \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-phpdbg \
    php-codesniffer && rm -rf /var/lib/apt/lists/*;

RUN phpenmod xdebug
