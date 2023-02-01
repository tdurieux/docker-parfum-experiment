FROM node:14.15.0-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
  vips-dev fftw-dev gcc g++ make libc6-compat \
  --virtual builds-deps build-base python

COPY package.json .

RUN npm install && npm cache clean --force;

RUN npm i bcrypt sharp && npm cache clean --force;
RUN npm install pm2@latest -g && npm cache clean --force;

COPY . .

RUN npm run build

EXPOSE 3000


CMD ["pm2-runtime","start" ,"ecosystem.config.json"]
