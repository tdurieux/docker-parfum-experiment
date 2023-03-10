FROM debian:bullseye-20210816

# TODO this should be obsolete, since we generate the certificates with a first run script.
#  however, this does not work for the ci (which becomes visible for the offline vm test)
RUN apt-get update && apt-get install --yes --no-install-recommends openssl \
    && mkdir /etc/ssl/apache2 \
    && openssl req \
        -x509 \
        -newkey rsa:4096 \
        -out /etc/ssl/apache2/server.pem \
        -keyout /etc/ssl/apache2/server.key \
        -days 365 \
        -nodes \
        -subj "/C=DE/O=CdE e.V./CN=cdedb.local/emailAddress=cdedb@lists.cde-ev.de" \
    && apt-get purge --yes --autoremove openssl \
    && rm -rf /var/lib/apt/lists/*

# rarely changing base of bigger packages whose cache we do not want to bust
RUN apt-get update && apt-get install --yes --no-install-recommends \
    sudo \
    make \
    gettext \
    git \
    \
    openssl \
    apache2 \
    python3 \
    libapache2-mod-wsgi-py3 \
    \
    postgresql-client \
    \
    texlive \
    texlive-latex-extra \
    texlive-lang-german \
    texlive-luatex \
    && rm -rf /var/lib/apt/lists/*

# mostly python packages and some dev tools
RUN apt-get update && apt-get install --yes --no-install-recommends \
    python3-psycopg2 \
    python3-dateutil \
    python3-babel \
    python3-icu \
    python3-jinja2 \
    python3-tz \
    python3-sphinx \
    python3-lxml \
    python3-pil \
    python3-webtest \
    python3-werkzeug \
    python3-ldap3 \
    python3-passlib \
    python3-bleach \
    python3-magic \
    python3-segno \
    python3-sphinx-rtd-theme \
    python3-zxcvbn \
    python3-markdown \
    python3-requests \
    python3-vobject \
    python3-graphviz \
    python3-phonenumbers \
    \
    python3-pip \
    python3-click \
    python3-freezegun \
    flake8 \
    isort \
    pylint \
    wget \
    unzip \

    && apt-get install --no-install-recommends --yes python3-coverage \

    && rm -rf /var/lib/apt/lists/* \

    && python3 -m pip --no-cache-dir install \
    ldaptor==21.2.0 \
    mailmanclient==3.3.3 \
    psycopg[binary]==3.0.15 \
    psycopg_pool==3.1.1 \
    schulze_condorcet==2.0.0 \
    subman==0.1.0 \
    segno==1.5.2 \

    && python3 -m pip --no-cache-dir install \
    mypy==0.950 \
    types-werkzeug \
    types-pytz \
    types-jinja2 \
    types-python-dateutil \
    types-freezegun \
    types-bleach \
    types-Markdown \
    types-click

# get the configuration files from the autobuild
COPY ./related/docker/cdedb-entrypoint.sh ./related/auto-build/files/stage3 /tmp/autobuild/

# This does the following:
# - configure apache,
# - add the mailman basic-auth password,
# - put the localconfig at the default config path and
#   create an empty secrets config (there has to exist one but the fallbacks are fine),
# - add symlink to /cdedb2/cdedb directory so python can find it,
# - create the cdedb user and enable passwordless sudo,
# - create the magic file to signal that we are inside a container.
RUN cp /tmp/autobuild/cdedb-entrypoint.sh /cdedb-entrypoint.sh \
    \
    && a2enmod ssl wsgi headers authnz_ldap \
    && a2dissite 000-default \
    && echo "" > /etc/apache2/ports.conf \
    && cp /tmp/autobuild/cdedb-site.conf /etc/apache2/sites-available \
    && a2ensite cdedb-site \
    && cp /tmp/autobuild/index.html /var/www/html/ \
    \
    && cp /tmp/autobuild/mailman-htpasswd /etc/cdedb-mailman-htpasswd \
    && chown www-data:www-data /etc/cdedb-mailman-htpasswd \
    && chmod 640 /etc/cdedb-mailman-htpasswd \
    \
    && install -D /tmp/autobuild/localconfig.py /etc/cdedb/config.py \
    && touch /etc/cdedb/public-secrets.py \
    \
    && rm -rf /tmp/autobuild \
    \
    && ln -s /cdedb2/cdedb/ /usr/lib/python3/dist-packages/cdedb \
    \
    && useradd --no-create-home cdedb \
    && echo "%cdedb ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
    \
    && touch /CONTAINER

# make config persistent
VOLUME /etc/cdedb
# the ssl certificate is created dynamically and has should persist
VOLUME /etc/ssl/apache2
# the storage dir is created during the first startup by the entrypoint
VOLUME /var/lib/cdedb

EXPOSE 443

# mount the code here
WORKDIR /cdedb2

STOPSIGNAL SIGWINCH
ENTRYPOINT ["/cdedb-entrypoint.sh"]
CMD ["sh", "-c", "APACHE_HTTPD='exec /usr/sbin/apache2' exec apachectl -DFOREGROUND"]
