FROM {{ "php-ast" | image_tag }} as ast

FROM {{ "composer-scratch" | image_tag }} as composer

FROM {{ "php81" | image_tag }}

USER root

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Grab our composer helper scripts
COPY --from=composer /srv/composer /srv/composer

# This will override the already-existing ast
COPY --from=ast /usr/lib/php/20200930/ast.so /usr/lib/php/20200930/ast.so
COPY --from=ast /srv/20-ast.ini /etc/php/8.1/cli/conf.d/20-ast.ini

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]