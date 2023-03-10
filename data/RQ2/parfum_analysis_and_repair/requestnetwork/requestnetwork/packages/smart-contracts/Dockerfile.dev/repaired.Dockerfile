FROM node:14 as builder

WORKDIR /app
COPY package.json .
RUN yarn

COPY truffle-config.js .
COPY ./src ./src
RUN yarn build:sol

FROM trufflesuite/ganache-cli as runtime
WORKDIR /app

RUN apk add --no-cache bash
RUN npm install -g truffle && npm cache clean --force;
RUN npm install -g node-wait-for-it && npm cache clean --force;

COPY truffle-config.js .
COPY --from=builder "/app/build/contracts" "/app/build/contracts"
COPY ./docker/ .
COPY ./migrations ./migrations
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
