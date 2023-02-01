FROM php:7.0-cli

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y libicu-dev \
  && docker-php-ext-install -j$(nproc) bcmath intl mbstring && rm -rf /var/lib/apt/lists/*;
