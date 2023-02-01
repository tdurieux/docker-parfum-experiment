ARG version=latest
FROM php:$version

RUN apt-get update \
    && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY prism/prism/nginx/cert.crt /usr/local/share/ca-certificates/cert.crt
RUN update-ca-certificates

WORKDIR /app
COPY . .

RUN make install
