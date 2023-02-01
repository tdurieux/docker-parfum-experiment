FROM ubuntu:16.04

RUN mkdir -p /opt/app/src
VOLUME /opt/app

RUN apt-get update
RUN apt-get install --no-install-recommends curl --yes && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Elm needs this and the base ubuntu images does not have it
RUN apt-get install --no-install-recommends netbase --yes && rm -rf /var/lib/apt/lists/*;

RUN npm i -g yarn@0.24.6 && npm cache clean --force;

WORKDIR /opt/app


CMD yarn install && yarn build && yarn server

# CMD yarn build && yarn server