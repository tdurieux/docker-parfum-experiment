ARG docker_repo=zokradonh
FROM ${docker_repo}/kopano_base

ARG VCS_REF
ARG ADDITIONAL_KOPANO_PACKAGES=""
ARG DOWNLOAD_COMMUNITY_PACKAGES=1
ARG KOPANO_REPOSITORY_FLAGS="trusted=yes"
ARG RELEASE_KEY_DOWNLOAD=0
ARG DEBIAN_FRONTEND=noninteractive
ARG KOPANO_CORE_REPOSITORY_URL="file:/kopano/repo/core"
ARG KOPANO_CORE_VERSION=newest
ARG KOPANO_ZPUSH_REPOSITORY_URL="http://repo.z-hub.io/z-push:/final/Debian_9.0/"
ARG KOPANO_ZPUSH_VERSION=newest

ENV \
    ADDITIONAL_KOPANO_PACKAGES=$ADDITIONAL_KOPANO_PACKAGES \
    DOWNLOAD_COMMUNITY_PACKAGES=$DOWNLOAD_COMMUNITY_PACKAGES \
    KOPANO_CORE_REPOSITORY_URL=$KOPANO_CORE_REPOSITORY_URL \
    KOPANO_CORE_VERSION=$KOPANO_CORE_VERSION \
    KOPANO_REPOSITORY_FLAGS=$KOPANO_REPOSITORY_FLAGS \
    RELEASE_KEY_DOWNLOAD=$RELEASE_KEY_DOWNLOAD \
    KOPANO_ZPUSH_REPOSITORY_URL=$KOPANO_ZPUSH_REPOSITORY_URL \
    KOPANO_ZPUSH_VERSION=$KOPANO_ZPUSH_VERSION

LABEL maintainer=az@zok.xyz \
    org.label-schema.name="Kopano Z-Push container" \
    org.label-schema.description="Container for running Z-Push with Kopano Groupware Core" \
    org.label-schema.url="https://kopano.io" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/zokradonh/kopano-docker" \
    org.label-schema.version=$KOPANO_ZPUSH_VERSION \
    org.label-schema.schema-version="1.0"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install Kopano WebApp and refresh ca-certificates
RUN \
    # community download and package as apt source repository
    . /kopano/helper/create-kopano-repo.sh && \
    if [ ${DOWNLOAD_COMMUNITY_PACKAGES} -eq 1 ]; then \
        dl_and_package_community "core"; \
    fi; \
    echo "deb [${KOPANO_REPOSITORY_FLAGS}] ${KOPANO_CORE_REPOSITORY_URL} ./" > /etc/apt/sources.list.d/kopano.list; \
    # prepare z-push installation
    echo "deb ${KOPANO_ZPUSH_REPOSITORY_URL} /" > /etc/apt/sources.list.d/zpush.list && \
    # this is the same key as for the rest of the Kopano stack, making a separate download anyways as this may not be the case in the future 
    curl -s -S -o - "${KOPANO_ZPUSH_REPOSITORY_URL}/Release.key" | apt-key add - && \
    # install
    set -x && \
    # TODO set IGNORE_FIXSTATES_ON_UPGRADE https://jira.z-hub.io/browse/ZP-1164?jql=text%20~%20%22IGNORE_FIXSTATES_ON_UPGRADE%22
    apt-get update && apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-php7.0 \
        crudini \
        z-push-kopano \
        z-push-config-apache \
        z-push-kopano-gabsync \
        z-push-autodiscover \
        z-push-config-apache-autodiscover \
        ca-certificates \
        ${ADDITIONAL_KOPANO_PACKAGES} \
    && rm -rf /var/cache/apt /var/lib/apt/lists

COPY apache2-kopano.conf /etc/apache2/sites-available/kopano.conf

# configure basics
RUN \
    # configure apache
    rm /etc/apache2/sites-enabled/* && \
    sed -e 's,^ErrorLog.*,ErrorLog "|/bin/cat",' -i /etc/apache2/apache2.conf && \
    sed -e "s,MaxSpareServers[^:].*,MaxSpareServers 5," -i /etc/apache2/mods-available/mpm_prefork.conf && \
    a2disconf other-vhosts-access-log && \
    a2ensite kopano && \
    echo "Listen 80" > /etc/apache2/ports.conf && \
    # configure mod_php
    a2enmod rewrite && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP upload_max_filesize 500M && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP post_max_size 500M && \
    crudini --set /etc/php/7.0/apache2/php.ini PHP max_input_vars 1800 && \
    crudini --set /etc/php/7.0/apache2/php.ini Session session.save_path /run/sessions && \
    # configure z-push
    mkdir -p /var/lib/z-push /var/log/z-push && \
    chown www-data:www-data /var/lib/z-push /var/log/z-push

# Patch Gabsync to make it work
# See https://jira.z-hub.io/browse/ZP-1463
# https://forum.kopano.io/topic/1928/8-7-80-missing-php-files-in-php-mapi-deb-package-ubuntu-16-04
# can be removed once gabsync is fixed - should not hurt
RUN sed -i -e "s/set_include_path(get_include_path() . PATH_SEPARATOR . BASE_PATH_CLI);/define('PATH_TO_ZPUSH', '..\/..\/backend\/kopano\/');\n    set_include_path(get_include_path() . PATH_SEPARATOR . BASE_PATH_CLI . PATH_SEPARATOR . BASE_PATH_CLI . PATH_TO_ZPUSH);/" /usr/share/z-push/tools/gab-sync/gab-sync.php

VOLUME /var/lib/z-push/

EXPOSE 80/tcp

COPY start.sh /kopano/start.sh

ENV LANG en_US.UTF-8

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD [ "/kopano/start.sh" ]
