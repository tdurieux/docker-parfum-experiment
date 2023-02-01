FROM php:7.2.10-apache

RUN apt-get update && apt-get install --no-install-recommends --upgrade dnsutils python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests PyYAML

RUN sed -i '0,/Listen [0-9]*/s//Listen 15002/' /etc/apache2/ports.conf

RUN mkdir /var/www/html/lib/ && cd /var/www/html/lib && \
    curl -f -sL 'https://github.com/smarty-php/smarty/archive/v3.1.32.tar.gz' | tar xzf - && \
    curl -f -sL 'https://github.com/twigphp/Twig/archive/v1.20.0.tar.gz' | tar xzf - && \
    curl -f -sL 'https://github.com/twigphp/Twig/archive/v1.19.0.tar.gz' | tar xzf -

COPY  . /apps/
COPY tests/env_php_tests/* /var/www/html/

WORKDIR /apps/tests/
