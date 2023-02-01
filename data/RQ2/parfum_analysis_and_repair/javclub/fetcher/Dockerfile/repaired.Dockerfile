FROM node:13.8.0-alpine

RUN apk add --no-cache ffmpeg

WORKDIR /usr/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "src/app.js" ]
