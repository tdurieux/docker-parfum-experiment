FROM {{ "ci-buster" | image_tag }}

# Align with SRE provided packages
COPY wikimedia-php74.list /etc/apt/sources.list.d/wikimedia-php74.list

# zip is needed for composer to install things from dist
# others are libraries/MediaWiki related
{% set packages|replace('\n', ' ') -%}
php7.4-cli
php7.4-zip
php7.4-ast
php7.4-bcmath
php7.4-curl
php7.4-dba
php7.4-gd
php7.4-gmp
php7.4-intl
php7.4-mbstring
php7.4-redis
php7.4-sqlite3
php7.4-xdebug
php7.4-xml
php7.4-yaml
zip
unzip
{%- endset -%}

RUN {{ packages | apt_install }}

# Disable xdebug by default due to its performance impact
RUN phpdismod xdebug

USER nobody

ENTRYPOINT ["php"]
CMD ["--help"]