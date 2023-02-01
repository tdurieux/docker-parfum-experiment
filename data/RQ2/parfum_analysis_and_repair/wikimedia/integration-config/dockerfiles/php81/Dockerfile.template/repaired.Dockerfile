FROM {{ "sury-php" | image_tag }}

# zip is needed for composer to install things from dist
# others are libraries/MediaWiki related
{% set packages|replace('\n', ' ') -%}
php8.1-ast
php8.1-cli
php8.1-zip
php8.1-bcmath
php8.1-curl
php8.1-dba
php8.1-gd
php8.1-gmp
php8.1-intl
php8.1-mbstring
php8.1-redis
php8.1-sqlite3
php8.1-xdebug
php8.1-xml
php8.1-yaml
zip
unzip
{%- endset -%}

RUN {{ packages | apt_install }}

# Disable xdebug by default due to its performance impact
RUN phpdismod xdebug

USER nobody

ENTRYPOINT ["php"]
CMD ["--help"]