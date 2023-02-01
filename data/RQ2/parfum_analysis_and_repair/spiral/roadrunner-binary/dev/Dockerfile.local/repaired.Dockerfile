# Image page: <https://hub.docker.com/_/golang>
FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:alpine as builder

# app version and build date must be passed during image building (version without any prefix).
# e.g.: `docker build --build-arg "APP_VERSION=1.2.3" --build-arg "BUILD_TIME=$(date +%FT%T%z)" .`
ARG APP_VERSION="undefined"
ARG BUILD_TIME="undefined"

COPY . /src

# Image page: <https://hub.docker.com/_/alpine>
# https://alpinelinux.org/posts/Alpine-3.13.4-released.html
# Critical issue with 3.13.3 https://nvd.nist.gov/vuln/detail/CVE-2021-28831
FROM --platform=${TARGETPLATFORM:-linux/amd64} php:latest

# use same build arguments for image labels
ARG APP_VERSION="undefined"
ARG BUILD_TIME="undefined"

# copy required files from builder image
COPY --from=builder /src/rr /usr/bin/rr
COPY --from=builder /src/.rr-docker.yaml /etc/rr-docker.yaml
COPY --from=builder /src/composer.json /etc/composer.json
COPY --from=builder /src/psr-worker.php /etc/psr-worker.php

WORKDIR /etc

RUN docker-php-ext-install sockets

RUN apt update -y && apt install --no-install-recommends git zip unzip -y && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y


RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install

# use roadrunner binary as image entrypoint
ENTRYPOINT ["/usr/bin/rr"]
