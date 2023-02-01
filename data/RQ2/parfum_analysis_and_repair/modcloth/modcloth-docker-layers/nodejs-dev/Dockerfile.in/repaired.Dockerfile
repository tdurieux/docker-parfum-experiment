FROM quay.io/modcloth/build-essential:latest
MAINTAINER Dan Buch <d.buch@modcloth.com>

ADD ./Dockerfile /
RUN cd / && \
    curl -f -s https://nodejs.org/dist/__NODE_VERSION__/node-__NODE_VERSION__-linux-x64.tar.gz | \
      tar xzf - --strip-components=1
