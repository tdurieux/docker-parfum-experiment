FROM node:16 as build-stage

WORKDIR /usr/src/app

COPY package* /

RUN npm ci

COPY . .

RUN npm run build

FROM node:alpine

ENV PORT 80

RUN npm install -g serve && npm cache clean --force;

COPY --from=build-stage /usr/src/app/public /usr/src/html

CMD serve -l $PORT /usr/src/html
