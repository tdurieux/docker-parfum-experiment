FROM php:7.3-cli
RUN mkdir -p /usr/share/man/man1 \
    && apt-get update && apt-get install --no-install-recommends -y \
        default-jdk \
        default-jdk-headless \
    && dpkg --configure -a \
    && apt-get install --no-install-recommends -y \
        graphviz \
        plantuml && rm -rf /var/lib/apt/lists/*;
COPY . /dephpend
WORKDIR /dephpend
RUN curl -f https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer | php -- --quiet \
    && php -n composer.phar install
ENTRYPOINT [ "php", "-n", "-d memory_limit=-1", "./bin/dephpend" ]
