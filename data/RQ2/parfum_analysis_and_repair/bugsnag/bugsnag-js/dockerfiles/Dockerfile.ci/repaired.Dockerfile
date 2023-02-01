# CI test image for unit/lint/type tests
FROM node:14-alpine

RUN apk add --no-cache --update bash python3 make gcc g++ musl-dev xvfb-run

WORKDIR /app

COPY package*.json ./
RUN npm install --unsafe-perm && npm cache clean --force;

COPY babel.config.js lerna.json .eslintignore .eslintrc.js jest.config.js tsconfig.json ./
ADD min_packages.tar .
COPY bin ./bin
RUN npx lerna bootstrap
COPY scripts ./scripts
COPY test ./test
COPY packages ./packages
RUN npm run build
