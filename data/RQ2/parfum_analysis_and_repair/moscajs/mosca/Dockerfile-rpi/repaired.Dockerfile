# Mosca
#
# VERSION 2.5.2

FROM hypriot/rpi-node:6
MAINTAINER Matteo Collina <hello@matteocollina.com>

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app/

COPY ./ /usr/src/app/

RUN apt-get update && \
    apt-get install -y --no-install-recommends make gcc g++ python git libzmq3-dev libkrb5-dev && \
    npm install --unsafe-perm --production && \
    apt-get remove make gcc g++ python git && \
    apt-get autoremove && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

EXPOSE 80
EXPOSE 1883

ENTRYPOINT ["/usr/src/app/bin/mosca", "-d", "/db", "--http-port", "80", "--http-bundle", "-v"]
