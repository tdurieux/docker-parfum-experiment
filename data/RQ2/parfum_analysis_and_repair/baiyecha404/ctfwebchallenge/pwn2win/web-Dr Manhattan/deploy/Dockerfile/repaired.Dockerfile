FROM php:7.2-apache

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update ; \
		apt install --no-install-recommends -y curl wget iptables net-tools && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g wappalyzer@5.9.34 && npm cache clean --force;

ENV APACHE_DOCUMENT_ROOT /var/www/html/

WORKDIR /var/www/html/

COPY index.php .
COPY trippy.js .

WORKDIR /var/www

RUN chown -R www-data:www-data .

RUN groupadd -r gnx && useradd --no-log-init -G audio,video -m -r -g gnx gnx


COPY flag.txt /
COPY get_flag /

RUN chown root:gnx /get_flag;\
		chmod 2755 /get_flag;\
		chown root:gnx /flag.txt;\
		chmod 440 /flag.txt;\
		chmod -R 555 /var/www/;
