FROM wordpress:latest

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
&& apt-get purge -y --auto-remove libldap2-dev