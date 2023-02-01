FROM node:9.2.0

RUN npm install -g truffle@5.0.18 ethereumjs-testrpc-sc@6.1.2 --unsafe && npm cache clean --force;

WORKDIR /app

COPY package.json ./package.json
COPY package-lock.json ./package-lock.json

RUN npm install && npm cache clean --force;

COPY contracts/ contracts/
COPY migrations/ migrations/
COPY scripts/ scripts/
COPY test/ test/
COPY truffle.js .solcover.js ./


