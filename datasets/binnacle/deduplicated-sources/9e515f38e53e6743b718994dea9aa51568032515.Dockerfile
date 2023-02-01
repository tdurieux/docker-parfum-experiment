#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/base-app:ubuntu-15.04
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:ubuntu-15.04

ENV APPLICATION_USER=application \
    APPLICATION_GROUP=application \
    APPLICATION_PATH=/app \
    APPLICATION_UID=1000 \
    APPLICATION_GID=1000

COPY conf/ /opt/docker/

RUN set -x \
    # Install services
    && apt-install \
        # Install common tools
        zip \
        unzip \
        bzip2 \
        moreutils \
        dnsutils \
        openssh-client \
        rsync \
        git \
    && mkdir -p /var/lib/syslog-ng/ \
    && /usr/local/bin/generate-locales \
    && docker-run-bootstrap \
    && docker-image-cleanup
