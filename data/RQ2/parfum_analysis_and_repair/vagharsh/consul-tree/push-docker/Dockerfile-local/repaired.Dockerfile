FROM php:7.2.6-apache

RUN set -ex; \
apt-get update ; \
apt-get install --no-install-recommends -y git wget; rm -rf /var/lib/apt/lists/*; \
git clone https://github.com/vagharsh/consul-tree.git ; \
mv consul-tree/* /var/www/html/; \
rm -rf consul-tree/;

CMD ["apache2-foreground"]