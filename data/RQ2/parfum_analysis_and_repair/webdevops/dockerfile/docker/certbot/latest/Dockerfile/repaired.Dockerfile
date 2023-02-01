#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/certbot:latest
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/bootstrap:alpine

VOLUME /etc/letsencrypt
VOLUME /var/www

RUN set -x \
    && apk-install \
        gcc \
        python2-dev \
        musl-dev \
        libffi-dev \
        openssl-dev \
        py2-pip \
    && pip install --no-cache-dir --upgrade pip \
    && hash -r \
    && pip install --no-cache-dir certbot \
    && docker-run-bootstrap \
    && docker-image-cleanup
