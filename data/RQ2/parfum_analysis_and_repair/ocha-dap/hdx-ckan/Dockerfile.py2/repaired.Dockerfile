FROM public.ecr.aws/unocha/debian-base-s6:10-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en_US \
    LC_ALL=en_US.UTF-8 \
    HDX_CKAN_WORKERS=4 \
    INI_FILE=/etc/ckan/prod.ini \
    HDX_CACHE_DIR=/srv/cache \
    HDX_LOG_LEVEL=INFO

WORKDIR /srv/ckan

COPY . .

RUN apt-get -qq -y update && \
    apt-get -qq --no-install-recommends -y install locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    cp docker/locale /etc/default/locale && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    update-locale LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    mkdir -p \
        /usr/share/man/man1 \
        /usr/share/man/man2 \
        /usr/share/man/man3 \
        /usr/share/man/man4 \
        /usr/share/man/man5 \
        /usr/share/man/man6 \
        /usr/share/man/man7 \
        /usr/share/man/man8 \
        /usr/share/man/man9 && \
    apt-get -qq --no-install-recommends -y install \
        procps \
        psmisc \
        net-tools \
        iputils-ping \
        gettext-base \
        nano \
        libmagic1 \
        git \
        gpg \
        build-essential \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        python-dev \
        python-setuptools \
        postgresql-client \
        libpq-dev \
        libyaml-dev \
        python3-psycopg2 \
        libffi-dev \
        libssl-dev && \
    curl -f -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get -qq --no-install-recommends -y install nodejs && \
    npm install -g less@3.13.1 && \
    apt-get -qq --no-install-recommends -y install python-pip && \
    python -m pip install --upgrade pip && \
    pip -q --no-cache-dir install --upgrade \
        lxml && \
    mkdir -p /var/log/ckan /srv/filestore /etc/services.d/unit /etc/ckan && \
    cp -a docker/run_unit /etc/services.d/unit/run && \
    chown www-data:www-data -R /var/log/ckan /srv/filestore && \
    cp -a docker/hdxckantool-ng.py /srv/hdxckantool-ng.py && \
    chmod +x /srv/hdxckantool-ng.py && \
    ln -s /srv/hdxckantool-ng.py /usr/sbin/hdxckantool && \
    echo "application/vnd.geo+json       geojson" >> /etc/mime.types && \
    pip install --no-cache-dir -r requirement-setuptools.txt && \
    pip -q --no-cache-dir install --upgrade -r requirements-py2.txt && \
    pip install --no-cache-dir newrelic==5.12.1.141 && \
    chmod +x run_pytest_with_coverage.sh && \
    chmod +x setup_py_helper.sh && \
    ./setup_py_helper.sh && \
    cd /srv/ckan && \
    newrelic-admin generate-config LICENSE_KEY /srv/newrelic.ini && \
    chown -R www-data ckan/public/base/i18n && \
    curl -f --output /usr/share/keyrings/nginx-keyring.gpg https://unit.nginx.org/keys/nginx-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ buster unit" > /etc/apt/sources.list.d/unit.list && \
    echo "deb-src [signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://packages.nginx.org/unit/debian/ buster unit" >> /etc/apt/sources.list.d/unit.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y unit unit-python2.7 && \
    apt-get -qq -y remove \
        build-essential \
        gpg \
        libffi-dev \
        libpq-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
        zlib1g-dev \
        python-dev && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf \
        /root/.cache \
        /root/.npm \
        /usr/local/man \
        /usr/share/doc \
        /usr/share/man \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/* && npm cache clean --force;

VOLUME ["/srv/filestore", "/srv/backup", "/var/log/ckan"]

EXPOSE 5000
