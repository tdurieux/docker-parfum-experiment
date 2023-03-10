FROM {{ "php-ast" | image_tag }} AS php-ast
FROM {{ "composer-php72" | image_tag }}

# Install php-ast
USER root
COPY --from=php-ast /usr/lib/php/20170718/ast.so /usr/lib/php/20170718/ast_1.0.1.so

# There should be a nicer way to do this.
RUN printf '%s\n%s\n%s\n' '; configuration for php ast module' '; priority=20' 'extension=ast_1.0.1.so' > /etc/php/7.2/mods-available/ast.ini
RUN echo "extension=ast_1.0.1.so" > /etc/php/7.2/cli/conf.d/20-ast.ini

# We'll need various dependencies. mysqli seems to be the only relevant dependency for core,
# but as per mediawiki-phan dockerfile, these deps should maybe be installed in a more base dockerfile
RUN {{ "php7.2-mysql" | apt_install }}

USER nobody
COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]