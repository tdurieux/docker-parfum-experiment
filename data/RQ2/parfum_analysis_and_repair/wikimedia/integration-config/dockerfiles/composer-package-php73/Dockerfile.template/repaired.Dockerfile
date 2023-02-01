FROM {{ "php-ast" | image_tag }} as ast

FROM {{ "composer-scratch" | image_tag }} as composer

FROM {{ "php73" | image_tag }}

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Grab our composer helper scripts
COPY --from=composer /srv/composer /srv/composer

USER root

# FIXME: Don't hardcode the phpapi version (but php-config is in php-dev pkg)
# This will override the already-existing ast
COPY --from=ast /usr/lib/php/20180731/ast.so /usr/lib/php/20180731/ast.so
# … and this will make the ast extension actually be loaded
COPY --from=ast /srv/20-ast.ini /etc/php/7.3/cli/conf.d/

# Enable xdebug for PHPUnit coverage reports
RUN phpenmod xdebug

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]