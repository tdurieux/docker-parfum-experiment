FROM node:11.2.0-alpine

RUN apk add --no-cache curl-dev libzip-dev autoconf build-base gmp-dev coreutils python

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app

RUN npm i && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]