FROM {{ "php72" | image_tag }}

USER root

# libthai is for wikidiff2, and
# liblua5.1 is for luasandbox
{% set packages|replace('\n', ' ') -%}
php7.2-dev
build-essential
pkg-config
libthai-dev
liblua5.1-dev
{%- endset -%}

RUN {{ packages | apt_install }}

USER nobody

COPY run.sh /run.sh
ENTRYPOINT ["/run.sh"]