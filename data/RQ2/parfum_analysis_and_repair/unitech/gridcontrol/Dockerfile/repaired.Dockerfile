FROM mhart/alpine-node:latest

RUN apk update && apk add git && rm -rf /var/cache/apk/*
RUN npm install pm2@next -g && npm cache clean --force;
RUN mkdir -p /var/app

WORKDIR /var/app

COPY ./package.json /var/app
RUN npm install && npm cache clean --force;
ENV NODE_ENV=production
COPY . /var/app/
CMD ["pm2-docker", "start", "--auto-exit", "index.js"]