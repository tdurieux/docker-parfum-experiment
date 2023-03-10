FROM node:12 as contracts

WORKDIR /mono

COPY contracts/package.json contracts/package-lock.json ./contracts/

WORKDIR /mono/contracts
RUN npm install --only=prod && npm cache clean --force;

COPY ./contracts/truffle-config.js ./
COPY ./contracts/contracts ./contracts
RUN npm run compile

FROM node:12

WORKDIR /mono
COPY package.json .
COPY --from=contracts /mono/contracts/build ./contracts/build
COPY commons/package.json ./commons/
COPY oracle-e2e/package.json ./oracle-e2e/
COPY monitor-e2e/package.json ./monitor-e2e/
COPY oracle/src/utils/constants.js ./oracle/src/utils/constants.js

COPY yarn.lock .
RUN NOYARNPOSTINSTALL=1 yarn install --frozen-lockfile --production && yarn cache clean;

COPY ./contracts/deploy ./contracts/deploy
RUN yarn install:deploy && yarn cache clean;

COPY commons/ ./commons/
COPY oracle-e2e/ ./oracle-e2e/
COPY monitor-e2e/ ./monitor-e2e/
COPY e2e-commons/ ./e2e-commons/
