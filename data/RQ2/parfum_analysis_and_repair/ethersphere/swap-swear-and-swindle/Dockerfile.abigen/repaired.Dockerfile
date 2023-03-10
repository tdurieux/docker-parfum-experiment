FROM node:10.16.0-stretch as builder

ARG GETH_VERSION="1.9.20-979fc968"
ARG SOLIDITY_VERSION="0.6.12"

RUN wget -q "https://github.com/ethereum/solidity/releases/download/v$SOLIDITY_VERSION/solc-static-linux" \
  && chmod +x solc-static-linux \
  && mv solc-static-linux /usr/local/bin/solc \
  && wget -q "https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-$GETH_VERSION.tar.gz" \
  && tar xvzf "geth-alltools-linux-amd64-$GETH_VERSION.tar.gz" \
  && mv "geth-alltools-linux-amd64-$GETH_VERSION/abigen" /usr/local/bin/abigen \
  && rm -rf "geth-alltools-linux-amd64-$GETH_VERSION" \
  && rm "geth-alltools-linux-amd64-$GETH_VERSION.tar.gz"

WORKDIR /sw3
ADD . /sw3

RUN npm install && npm cache clean --force;
