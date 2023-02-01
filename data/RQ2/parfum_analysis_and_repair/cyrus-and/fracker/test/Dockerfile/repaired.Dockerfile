FROM node:12-buster

RUN apt-get update && apt-get install --yes --no-install-recommends \
    php-dev autoconf gcc make git libjson-c-dev iproute2 && rm -rf /var/lib/apt/lists/*;

COPY . /fracker

WORKDIR /fracker/test
RUN make rebuild

ENTRYPOINT make test
