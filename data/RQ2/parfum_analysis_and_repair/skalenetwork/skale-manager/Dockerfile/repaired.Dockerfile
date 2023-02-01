FROM node:16

RUN mkdir /usr/src/manager && rm -rf /usr/src/manager
WORKDIR /usr/src/manager

RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

COPY package.json ./
COPY hardhat.config.ts ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;

ENV NODE_OPTIONS="--max-old-space-size=2048"

COPY . .
