FROM alpine:3.9.3

MAINTAINER Imarc <info@imarc.com>

RUN apk add --update --no-cache \
        bash \
        curl \
        composer \
        docker \
        git \
        jq \
        openssh \
        openssl \
        socat \
        rsync \
        nodejs \
        nss \
        nss-tools \
        npm \
        netcat-openbsd \
        php7 \
        py-pip \
        socat \
        unzip \
        wget \
        sudo \
        apache2 \
        && rm -rf /var/cache/apk/*

RUN pip install --no-cache-dir yq

# install docker-compose
RUN curl -f -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

RUN mkdir /home/ops
RUN mkdir /home/ops/Sites

RUN addgroup -g 1000 ops && \
    adduser -h /home/ops -D -u 1000 -G ops ops

COPY . /usr/local/var/ops

RUN echo '%ops ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ops

WORKDIR /home/ops

RUN chown -R ops:ops /home/ops
RUN chown ops:ops /usr/lib/node_modules
RUN chown ops:ops /usr/bin

USER ops

RUN npm install -g /usr/local/var/ops && npm cache clean --force;

