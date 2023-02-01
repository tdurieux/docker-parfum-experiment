FROM node:16.14.2-alpine3.15

WORKDIR /usr/src/app

COPY tsconfig.json .
COPY package*.json ./
COPY src ./src
COPY test ./test
COPY migration ./migration


RUN apk add --no-cache --update alpine-sdk
RUN apk add --no-cache git python3
RUN apk add --no-cache  chromium --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main
RUN npm ci
RUN npm i -g ts-node && npm cache clean --force;
CMD npm run typeorm:cli:live -- migration:run && ts-node --project ./tsconfig.json src/index.ts
EXPOSE 4000
