FROM ubuntu:18.04 as nodejs_ubuntu

RUN \
  apt-get update && apt-get install --no-install-recommends -y nodejs npm curl python make build-essential && rm -rf /var/lib/apt/lists/*

RUN \
  npm install -g npm@latest && \
  npm install -g http-server && npm cache clean --force;


