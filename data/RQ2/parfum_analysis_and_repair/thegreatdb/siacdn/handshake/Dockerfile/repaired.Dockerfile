FROM ubuntu:20.04

ENV SIACDN_BASE_BUILD_VERSION 1

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install ca-certificates curl git build-essential dnsutils unbound libunbound-dev python2 && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

ENV SIACDN_CORE_BUILD_VERSION 1

RUN mkdir /etc/handshake
WORKDIR /etc/handshake

RUN git clone git://github.com/handshake-org/hsd.git && \
    cd hsd && \
    yarn install --production && yarn cache clean;

COPY start.sh /etc/handshake/start.sh
RUN chmod +x /etc/handshake/start.sh