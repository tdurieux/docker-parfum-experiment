FROM composer:latest

RUN curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

RUN wp --allow-root package install wp-cli/dist-archive-command

ADD . /app/colormeshop-wp-plugin

WORKDIR /app/colormeshop-wp-plugin

RUN composer install --no-dev

CMD ["wp", "--allow-root", "dist-archive", "./", "/tmp/dist/colormeshop-wp-plugin.zip", "--create-target-dir"]
