FROM node:14-alpine
WORKDIR /usr/src/app
RUN apk add --no-cache --update alpine-sdk && apk add --no-cache linux-headers
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python

COPY package.json package-lock.json ./

RUN npm i && npm cache clean --force;

COPY . .

RUN npm run build

ENV NODE_ENV production
CMD [ "node", "dist/index.js" ]
USER node