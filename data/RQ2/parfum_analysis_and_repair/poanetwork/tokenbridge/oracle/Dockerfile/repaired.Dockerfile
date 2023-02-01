FROM node:12 as contracts

WORKDIR /mono

COPY contracts/package.json contracts/package-lock.json ./contracts/

WORKDIR /mono/contracts
RUN npm install --only=prod && npm cache clean --force;

COPY ./contracts/truffle-config.js ./
COPY ./contracts/contracts ./contracts
RUN npm run compile

FROM node:12

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential libc6-dev libc6-dev-i386 wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /mono
COPY package.json .
COPY --from=contracts /mono/contracts/build ./contracts/build
COPY commons/package.json ./commons/
COPY oracle/package.json ./oracle/
COPY yarn.lock .
RUN NOYARNPOSTINSTALL=1 yarn install --frozen-lockfile --production && yarn cache clean;

COPY ./commons ./commons
COPY ./oracle ./oracle

WORKDIR /mono/oracle
CMD echo "To start a bridge process run:" \
  "ORACLE_VALIDATOR_ADDRESS=<validator address> ORACLE_VALIDATOR_ADDRESS_PRIVATE_KEY=<validator address private key> docker-compose up -d --build"
