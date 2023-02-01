#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/mail-sandbox:latest
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php-nginx:latest

ENV MAILBOX_USERNAME="dev" \
    MAILBOX_PASSWORD="dev"

COPY conf/ /opt/docker/

RUN set -x \
    # Install services
    && apt-install \
        dovecot-core \
        dovecot-imapd \
    && docker-service enable postfix \
    && docker-service enable dovecot \
    && docker-run-bootstrap \
    && docker-image-cleanup

RUN set -x \
    # Install Roundcube + plugins