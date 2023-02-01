FROM node:16.13.1-alpine3.14
EXPOSE 5488
USER root

ENV GOSU_VERSION 1.12
RUN set -eux; \
    \
    apk add --no-cache --virtual .gosu-deps \
    ca-certificates \
    dpkg \
    gnupg \
    ; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
    # verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    # clean up fetch dependencies
    apk del --no-network .gosu-deps; \
    \
    chmod +x /usr/local/bin/gosu; \
    # verify that the binary works
    gosu --version; \
    gosu nobody true

RUN addgroup -S jsreport && adduser --shell /bin/bash -S -G jsreport jsreport

RUN apk update --no-cache && \
    echo @edge http://dl-cdn.alpinelinux.org/alpine/v3.14/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache \
    libstdc++@edge \
    chromium@edge=93.0.4577.82-r0 \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont@edge \
    # just for now as we npm install from git
    git \
    # so user can docker exec -it test /bin/bash
    bash

RUN rm -rf /var/cache/apk/* /tmp/*

RUN mkdir -p /app

# we need to create the volume and give it expected owner
# before the VOLUME step in order for the volume to be created with non-root user
RUN mkdir /jsreport
RUN chown jsreport:jsreport /jsreport
RUN chmod g+s /jsreport

VOLUME ["/jsreport"]

ENV NPM_CONFIG_PREFIX /home/jsreport/.npm-global
ENV PATH $PATH:/home/jsreport/.npm-global/bin

WORKDIR /app

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

RUN npm i -g @jsreport/jsreport-cli
RUN jsreport init

RUN npm cache clean -f && rm -rf /tmp/*

COPY ./packages/jsreport/docker/default/editConfig.js editConfig.js
COPY ./packages/jsreport/docker/default/run.sh run.sh
RUN node editConfig.js

RUN chown -R jsreport:jsreport /app

ENV chrome:launchOptions:executablePath /usr/lib/chromium/chrome
ENV chrome_launchOptions_args --no-sandbox,--disable-dev-shm-usage


CMD ["bash", "run.sh"]
