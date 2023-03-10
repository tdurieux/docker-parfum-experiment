ARG LAGOON_IMAGE_VERSION

FROM uselagoon/php-8.1-cli-drupal:${LAGOON_IMAGE_VERSION} as builder

ARG GOVCMS_PROJECT_VERSION
ARG COMPOSER_AUTH
ARG GITHUB_TOKEN

COPY composer.* /app/

# Copy base file for extensible saas.
COPY custom /app/custom

# Install yq for YAML parsing.
RUN case $(uname -m) in x86_64)  ARCH="amd64" ;; aarch64) ARCH="arm64" ;; *) ARCH="amd64" ;; esac \
  && wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_${ARCH}" \
  && chmod +x /usr/local/bin/yq

# Install jq for YAML/JSON parsing.
RUN apk add --no-cache jq

RUN sed -i -e "/govcms\/govcms/ s!2.x-dev!${GOVCMS_PROJECT_VERSION}!" /app/composer.json

COPY scripts/composer/ScriptHandler.php /app/scripts/composer/ScriptHandler.php

ENV COMPOSER_MEMORY_LIMIT=-1
# Set the Github OAuth token only when the variable is set.
RUN [[ ! -z "${GITHUB_TOKEN}" ]]  && composer config -g github-oauth.github.com ${GITHUB_TOKEN} || echo "Personal Github OAuth token is not set."
RUN composer validate \
    && composer self-update --2 \
    && composer update -d /app \
    && composer clearcache

COPY .docker/sanitize.sh /app/sanitize.sh

COPY .docker/images/govcms/scripts /usr/bin/
RUN chmod 755 /usr/bin/govcms-deploy
COPY .docker/images/govcms/govcms.site.yml /app/drush/sites/

# Ensure MySQL client can accept server max_allowed_packet
COPY .docker/images/govcms/mariadb-client.cnf /etc/my.cnf.d

RUN mkdir -p /app/web/sites/default/files/private \
    && fix-permissions /home/.drush \
    && fix-permissions /app/drush/sites \
    && fix-permissions /etc/my.cnf.d \
    && chmod +x /app/sanitize.sh \
    && /app/sanitize.sh \
    && rm -f /app/sanitize.sh

COPY modules/ /app/web/sites/all/modules/

# Install the R3 intermediary for LE.
RUN mkdir -p /usr/share/ca-certificates/letsencrypt \
  && curl -f -o /usr/share/ca-certificates/letsencrypt/lets-encrypt-r3.crt https://letsencrypt.org/certs/lets-encrypt-r3.pem \
  && echo -e "\nletsencrypt/lets-encrypt-r3.crt" >> /etc/ca-certificates.conf \
  && update-ca-certificates

# Define where the Drupal Root is located
ENV WEBROOT=web
