FROM node:17-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "index.js" ]


LABEL org.opencontainers.image.source https://github.com/CompeyDev/MusicComp-v2
