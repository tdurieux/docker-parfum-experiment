FROM {{ "composer-package-php73" | image_tag }}

USER root

# TODO: Should these be installed in a more base dockerfile?
{% set mediawiki_deps|replace('\n', ' ') -%}
php7.3-apcu
php7.3-imagick
php7.3-ldap
php7.3-mysql
php7.3-pgsql
php7.3-sqlite3
php7.3-tidy
{%- endset -%}

RUN {{ mediawiki_deps | apt_install }}

USER nobody

COPY run.sh /run.sh
COPY run-core.sh /run-core.sh
COPY run-libraries.sh /run-libraries.sh
COPY run-generic.sh /run-generic.sh
ENTRYPOINT ["/run.sh"]