FROM php:7.1
COPY ./php.ini /usr/local/lib/
RUN apt-get update && apt install -y --no-install-recommends zip unzip && rm -rf /var/lib/apt/lists/*;