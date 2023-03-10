FROM {{ "composer-package-php72" | image_tag }}

USER root

# TODO: Should these be installed in a more base dockerfile?
{% set mediawiki_deps|replace('\n', ' ') -%}
php-apcu
php-imagick
php7.2-ldap
php7.2-mysql
php7.2-pgsql
php7.2-sqlite3
php7.2-tidy
{%- endset -%}

RUN {{ mediawiki_deps | apt_install }}

USER nobody

COPY run.sh /run.sh
COPY run-core.sh /run-core.sh
COPY run-libraries.sh /run-libraries.sh
COPY run-generic.sh /run-generic.sh
ENTRYPOINT ["/run.sh"]