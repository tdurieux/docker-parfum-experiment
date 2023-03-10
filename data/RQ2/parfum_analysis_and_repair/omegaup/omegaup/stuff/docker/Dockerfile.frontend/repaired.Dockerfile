FROM ubuntu:focal AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        software-properties-common \
        && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        git \
        ca-certificates \
        gnupg2 \
        curl \
        php8.0-cli \
        php8.0-curl \
        php8.0-gmp \
        php8.0-mbstring \
        php8.0-zip \
        php8.0-xml \
        && \
    /usr/sbin/update-ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y nginx yarn nodejs && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://getcomposer.org/download/2.1.14/composer.phar -o /usr/bin/composer && \
    chmod +x /usr/bin/composer

RUN useradd --create-home --shell=/bin/bash ubuntu
RUN mkdir -p /opt/omegaup /var/lib/omegaup && chown -R ubuntu /opt/omegaup /var/lib/omegaup
USER ubuntu
WORKDIR /opt/omegaup
ARG BRANCH=release
ENV BRANCH=$BRANCH
RUN git clone --branch=${BRANCH} --depth=1 --recurse-submodules --shallow-submodules https://github.com/omegaup/omegaup .
RUN yarn install && yarn build && yarn cache clean;
RUN composer install --no-dev --classmap-authoritative
RUN printf "<?php\n\
define('OMEGAUP_ENVIRONMENT', 'production');\n\
define('TEMPLATE_CACHE_DIR', '/var/lib/omegaup/templates');\n" > frontend/server/config.php
RUN php frontend/server/cmd/CompileTemplatesCmd.php

FROM alpine:latest AS frontend
RUN apk add --no-cache rsync
RUN mkdir -p /var/lib/omegaup /opt/omegaup
COPY --from=build /opt/omegaup /opt/omegaup
COPY --from=build /var/lib/omegaup /var/lib/omegaup

FROM ubuntu:focal AS nginx

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y nginx ca-certificates && \
    /usr/sbin/update-ca-certificates && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell=/bin/bash ubuntu

RUN mkdir -p /etc/omegaup/frontend
RUN mkdir -p /var/log/omegaup && chown -R ubuntu /var/log/omegaup

USER ubuntu
WORKDIR /opt/omegaup

EXPOSE 8001

CMD ["/usr/sbin/nginx"]

FROM ubuntu:focal AS php

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        curl \
        gnupg \
        ca-certificates \
        software-properties-common \
        && \
    /usr/sbin/update-ca-certificates && \
    echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' > /etc/apt/sources.list.d/newrelic.list && \
    curl -f -sL https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y \
        newrelic-php5 \
        openjdk-16-jre-headless \
        php8.0-apcu \
        php8.0-curl \
        php8.0-fpm \
        php8.0-gmp \
        php8.0-mbstring \
        php8.0-mysql \
        php8.0-opcache \
        php8.0-redis \
        php8.0-xml \
        php8.0-zip \
        && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://github.com/omegaup/libinteractive/releases/download/v2.0.27/libinteractive.jar \
        -o /usr/share/java/libinteractive.jar

RUN useradd --create-home --shell=/bin/bash ubuntu && \
    mkdir -p /etc/omegaup/frontend && \
    mkdir -p /var/log/omegaup /var/lib/omegaup /opt/omegaup && \
    chown -R ubuntu /var/log/omegaup /var/lib/omegaup /opt/omegaup

RUN rm -rf /etc/php/8.0/fpm/pool.d/

USER ubuntu
WORKDIR /opt/omegaup

# Override stop signal to stop process gracefully
# # https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT
EXPOSE 9001

CMD ["php-fpm8.0", "--nodaemonize", "--force-stderr"]

FROM ubuntu:focal as frontend-sidecar

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        git \
        mysql-client-core-8.0 \
        python3-pip \
        && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/
RUN python3 -m pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

RUN useradd --create-home --shell=/bin/bash ubuntu && \
    mkdir -p /etc/omegaup/frontend && \
    mkdir -p /var/log/omegaup && chown -R ubuntu /var/log/omegaup && \
    mkdir /opt/omegaup && \
    chown -R ubuntu /opt/omegaup

USER ubuntu
WORKDIR /opt/omegaup
