FROM splitbrain/phpfarm:jessie

RUN apt-get update && apt-get install --no-install-recommends -y git zip && rm -rf /var/lib/apt/lists/*;

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY . /var/www/

WORKDIR /var/www/
