FROM node:10.16.0-alpine

WORKDIR /build

RUN apk add --no-cache git python build-base

RUN npm install -g truffle && npm cache clean --force;
RUN npm install truffle-hdwallet-provider && npm cache clean --force;

RUN truffle obtain --solc 0.5.9

RUN mkdir temp \
 && cd temp \
 && truffle init \
 && mkdir ../contracts \
 && cp ./contracts/Migrations.sol ../contracts/Migrations.sol \
 && cd .. \
 && rm -rf temp

COPY truffle-config-build.js /build/truffle-config.js
COPY contracts /build/contracts

RUN truffle compile

COPY truffle-config.js /build/truffle-config.js
COPY migrations /build/migrations

ENTRYPOINT ["truffle", "deploy"]
