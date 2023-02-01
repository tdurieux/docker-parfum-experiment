# DOCKER-VERSION 1.3.0

FROM ubuntu:14.04

MAINTAINER Itay Weinberger <itay@joo.la>

# start of by updating packages and installing base packages
RUN apt-get update -ym
RUN apt-get upgrade -ym
RUN apt-get install --no-install-recommends -y curl build-essential python git && rm -rf /var/lib/apt/lists/*;

RUN \
    curl -f --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# setup needed settings/configuration for stack
RUN ulimit -n 1024
ENV LC_ALL C
ENV NODE_CONFIG_DIR /opt/joola/bin/config

# setup joola directories
RUN mkdir -p /opt/joola/bin /opt/joola/logs

# install joola
COPY . /opt/joola/bin
RUN \
    cd /opt/joola/bin && \
    npm install && npm cache clean --force;

EXPOSE 8080
CMD []
ENTRYPOINT ["node", "/opt/joola/bin/joola.js"]
