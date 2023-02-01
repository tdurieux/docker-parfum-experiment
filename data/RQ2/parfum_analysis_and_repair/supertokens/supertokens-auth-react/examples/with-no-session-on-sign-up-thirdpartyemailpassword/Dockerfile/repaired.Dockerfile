FROM node:lts-alpine3.12

RUN apk add --no-cache curl

WORKDIR /usr/src/app

RUN npm i -g pm2 && npm cache clean --force;

USER node

CMD ["pm2-docker", "start", "pm2.json"]

EXPOSE 10000

EXPOSE 10001