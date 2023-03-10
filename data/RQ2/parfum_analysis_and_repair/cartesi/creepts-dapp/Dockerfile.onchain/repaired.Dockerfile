FROM node:12-alpine as builder

RUN apk add --no-cache \
    git

# install truffle globally
RUN yarn global add truffle@5.1.17
RUN yarn add @truffle/hdwallet-provider@1.0.33
RUN yarn add @truffle/contract@4.1.13

ENV BASE /opt/cartesi
WORKDIR $BASE/share/blockchain

ARG NPM_TOKEN
RUN echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > ~/.npmrc

COPY ./contracts ./contracts
COPY ./migrations ./migrations
COPY ./package.json .
COPY ./truffle-config.js .
COPY ./yarn.lock .

RUN yarn install --flat --production --frozen-lockfile && yarn cache clean;

# testnet deployment
ARG PROJECT_ID
ARG MNEMONIC

RUN truffle migrate --network ropsten
RUN truffle migrate --network kovan
RUN truffle migrate --network rinkeby
RUN truffle migrate --network matic_testnet

CMD ["truffle", "networks"]
