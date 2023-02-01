# Truffle in docker

FROM node:14.13.1

USER root

# Install essential OS packages
RUN apt-get update && apt-get install --no-install-recommends --yes build-essential inotify-tools git python g++ make libsecret-1-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/node/app

COPY ./package.json /home/node/app/package.json
RUN npm install -g truffle && npm cache clean --force;
RUN npm install && npm cache clean --force;

ENTRYPOINT []
