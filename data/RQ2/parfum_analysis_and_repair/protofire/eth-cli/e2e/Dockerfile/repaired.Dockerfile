FROM node:10

WORKDIR /eth-cli

COPY package.json .
COPY yarn.lock .
RUN yarn && yarn cache clean;

COPY src src
COPY bin bin
COPY README.md .prettierrc.json tsconfig.json .eslintrc.json ./

RUN yarn prepack && yarn cache clean;

COPY e2e e2e

CMD node e2e/run.js
