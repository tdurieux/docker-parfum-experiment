FROM alpine:3.14.2

MAINTAINER Imarc <info@imarc.com>

RUN apk add --update --no-cache \
        bash \
        curl \
        docker \
        git \
        jq \
        openssh \
        openssl \
        socat \
        rsync \
        nodejs \
        npm \
        netcat-openbsd \
        py-pip \
        unzip \
        wget \
        apache2 \
        && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir yq

# install docker-compose
RUN curl -f -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# install npm dependencies
#RUN npm install broken-link-checker -g
RUN npm install -g localtunnel && npm cache clean --force;
