FROM ubuntu:14.04
MAINTAINER Max Goodman <max@euphoria.io>

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y nodejs nodejs-legacy npm git && rm -rf /var/lib/apt/lists/*;

# for phantomjs
RUN apt-get install --no-install-recommends -y libfontconfig && rm -rf /var/lib/apt/lists/*;

# copy source code to /srv/heim/client/src
WORKDIR /srv/heim/client/

ENV PATH $PATH:node_modules/.bin

VOLUME /srv/heim/client/build
