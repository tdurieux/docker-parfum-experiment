FROM debian:buster

RUN apt-get update
RUN apt-get -y --no-install-recommends install gnupg curl wget && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install lsb-release apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list

RUN apt-get update

RUN apt-get -y --no-install-recommends install rake php8.1 php8.1-cli php8.1-curl php-pear php8.1-xml php8.1-mbstring && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --set php /usr/bin/php8.1 && php -v
WORKDIR /braintree-php
